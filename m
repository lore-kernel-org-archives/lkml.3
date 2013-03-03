Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab3CCSrm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 13:47:42 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:59389 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3CCSrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 13:47:40 -0500
Date: Sun, 3 Mar 2013 18:47:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, David Miller <davem@davemloft.net>
Subject: [RFC][PATCH] making vfree() safe from interrupt contexts
Message-ID: <20130303184736.GM4503@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	To bring back the thing discussed back in, IIRC, December: we have
a bunch of places where inability to do vfree() from interrupt contexts
(the most common case is doing that from RCU callback) leads to very
ugly open-coded schemes that delay it one way or another.  We can let vfree()
itself do that instead.  AFAICS, it works; the diff below covers several
obvious cases found just by grep.  I'm fairly sure that there's more code
that could benefit from that...

	I'm not sure which tree should it go through, though.  Suggestions?
The reason I'm interested in this sucker is the mess in fs/file.c (fdtable
freeing), but the main change here is in mm/vmalloc.c...

	Note that the patch obviously ought to be split - mm/vmalloc.c
part, allowing vfree() in interrupt contexts (current mainline has
BUG_ON() triggered in that case) and a chunk for each ad-hoc vfree()
deferral scheme killed.

	Comments?

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/file.c b/fs/file.c
index 3906d95..4a78f98 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -23,24 +23,10 @@
 #include <linux/rcupdate.h>
 #include <linux/workqueue.h>
 
-struct fdtable_defer {
-	spinlock_t lock;
-	struct work_struct wq;
-	struct fdtable *next;
-};
-
 int sysctl_nr_open __read_mostly = 1024*1024;
 int sysctl_nr_open_min = BITS_PER_LONG;
 int sysctl_nr_open_max = 1024 * 1024; /* raised later */
 
-/*
- * We use this list to defer free fdtables that have vmalloced
- * sets/arrays. By keeping a per-cpu list, we avoid having to embed
- * the work_struct in fdtable itself which avoids a 64 byte (i386) increase in
- * this per-task structure.
- */
-static DEFINE_PER_CPU(struct fdtable_defer, fdtable_defer_list);
-
 static void *alloc_fdmem(size_t size)
 {
 	/*
@@ -67,46 +53,9 @@ static void __free_fdtable(struct fdtable *fdt)
 	kfree(fdt);
 }
 
-static void free_fdtable_work(struct work_struct *work)
-{
-	struct fdtable_defer *f =
-		container_of(work, struct fdtable_defer, wq);
-	struct fdtable *fdt;
-
-	spin_lock_bh(&f->lock);
-	fdt = f->next;
-	f->next = NULL;
-	spin_unlock_bh(&f->lock);
-	while(fdt) {
-		struct fdtable *next = fdt->next;
-
-		__free_fdtable(fdt);
-		fdt = next;
-	}
-}
-
 static void free_fdtable_rcu(struct rcu_head *rcu)
 {
-	struct fdtable *fdt = container_of(rcu, struct fdtable, rcu);
-	struct fdtable_defer *fddef;
-
-	BUG_ON(!fdt);
-	BUG_ON(fdt->max_fds <= NR_OPEN_DEFAULT);
-
-	if (!is_vmalloc_addr(fdt->fd) && !is_vmalloc_addr(fdt->open_fds)) {
-		kfree(fdt->fd);
-		kfree(fdt->open_fds);
-		kfree(fdt);
-	} else {
-		fddef = &get_cpu_var(fdtable_defer_list);
-		spin_lock(&fddef->lock);
-		fdt->next = fddef->next;
-		fddef->next = fdt;
-		/* vmallocs are handled from the workqueue context */
-		schedule_work(&fddef->wq);
-		spin_unlock(&fddef->lock);
-		put_cpu_var(fdtable_defer_list);
-	}
+	__free_fdtable(container_of(rcu, struct fdtable, rcu));
 }
 
 /*
@@ -174,7 +123,6 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	fdt->open_fds = data;
 	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = data;
-	fdt->next = NULL;
 
 	return fdt;
 
@@ -221,7 +169,7 @@ static int expand_fdtable(struct files_struct *files, int nr)
 		/* Continue as planned */
 		copy_fdtable(new_fdt, cur_fdt);
 		rcu_assign_pointer(files->fdt, new_fdt);
-		if (cur_fdt->max_fds > NR_OPEN_DEFAULT)
+		if (cur_fdt != &files->fdtab)
 			call_rcu(&cur_fdt->rcu, free_fdtable_rcu);
 	} else {
 		/* Somebody else expanded, so undo our attempt */
@@ -316,7 +264,6 @@ struct files_struct *dup_fd(struct files_struct *oldf, int *errorp)
 	new_fdt->close_on_exec = newf->close_on_exec_init;
 	new_fdt->open_fds = newf->open_fds_init;
 	new_fdt->fd = &newf->fd_array[0];
-	new_fdt->next = NULL;
 
 	spin_lock(&oldf->file_lock);
 	old_fdt = files_fdtable(oldf);
@@ -490,19 +437,8 @@ void exit_files(struct task_struct *tsk)
 	}
 }
 
-static void fdtable_defer_list_init(int cpu)
-{
-	struct fdtable_defer *fddef = &per_cpu(fdtable_defer_list, cpu);
-	spin_lock_init(&fddef->lock);
-	INIT_WORK(&fddef->wq, free_fdtable_work);
-	fddef->next = NULL;
-}
-
 void __init files_defer_init(void)
 {
-	int i;
-	for_each_possible_cpu(i)
-		fdtable_defer_list_init(i);
 	sysctl_nr_open_max = min((size_t)INT_MAX, ~(size_t)0/sizeof(void *)) &
 			     -BITS_PER_LONG;
 }
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index fb7daca..085197b 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -27,7 +27,6 @@ struct fdtable {
 	unsigned long *close_on_exec;
 	unsigned long *open_fds;
 	struct rcu_head rcu;
-	struct fdtable *next;
 };
 
 static inline bool close_on_exec(int fd, const struct fdtable *fdt)
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b3d00fa..997f4d7 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -594,7 +594,6 @@ struct rps_dev_flow {
 struct rps_dev_flow_table {
 	unsigned int mask;
 	struct rcu_head rcu;
-	struct work_struct free_work;
 	struct rps_dev_flow flows[0];
 };
 #define RPS_DEV_FLOW_TABLE_SIZE(_num) (sizeof(struct rps_dev_flow_table) + \
diff --git a/ipc/util.c b/ipc/util.c
index 74e1d9c..e2953cbd 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -479,10 +479,9 @@ void ipc_free(void* ptr, int size)
 
 /*
  * rcu allocations:
- * There are three headers that are prepended to the actual allocation:
+ * There are two headers that are prepended to the actual allocation:
  * - during use: ipc_rcu_hdr.
  * - during the rcu grace period: ipc_rcu_grace.
- * - [only if vmalloc]: ipc_rcu_sched.
  * Their lifetime doesn't overlap, thus the headers share the same memory.
  * Unlike a normal union, they are right-aligned, thus some container_of
  * forward/backward casting is necessary:
@@ -490,7 +489,6 @@ void ipc_free(void* ptr, int size)
 struct ipc_rcu_hdr
 {
 	int refcount;
-	int is_vmalloc;
 	void *data[0];
 };
 
@@ -502,25 +500,8 @@ struct ipc_rcu_grace
 	void *data[0];
 };
 
-struct ipc_rcu_sched
-{
-	struct work_struct work;
-	/* "void *" makes sure alignment of following data is sane. */
-	void *data[0];
-};
-
-#define HDRLEN_KMALLOC		(sizeof(struct ipc_rcu_grace) > sizeof(struct ipc_rcu_hdr) ? \
+#define HDRLEN		(sizeof(struct ipc_rcu_grace) > sizeof(struct ipc_rcu_hdr) ? \
 					sizeof(struct ipc_rcu_grace) : sizeof(struct ipc_rcu_hdr))
-#define HDRLEN_VMALLOC		(sizeof(struct ipc_rcu_sched) > HDRLEN_KMALLOC ? \
-					sizeof(struct ipc_rcu_sched) : HDRLEN_KMALLOC)
-
-static inline int rcu_use_vmalloc(int size)
-{
-	/* Too big for a single page? */
-	if (HDRLEN_KMALLOC + size > PAGE_SIZE)
-		return 1;
-	return 0;
-}
 
 /**
  *	ipc_rcu_alloc	-	allocate ipc and rcu space 
@@ -533,27 +514,16 @@ static inline int rcu_use_vmalloc(int size)
  
 void* ipc_rcu_alloc(int size)
 {
-	void* out;
+	size_t len = size + HDRLEN;
+	void *out;
 	/* 
-	 * We prepend the allocation with the rcu struct, and
-	 * workqueue if necessary (for vmalloc). 
+	 * We prepend the allocation with the rcu struct
 	 */
-	if (rcu_use_vmalloc(size)) {
-		out = vmalloc(HDRLEN_VMALLOC + size);
-		if (out) {
-			out += HDRLEN_VMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 1;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
-		}
-	} else {
-		out = kmalloc(HDRLEN_KMALLOC + size, GFP_KERNEL);
-		if (out) {
-			out += HDRLEN_KMALLOC;
-			container_of(out, struct ipc_rcu_hdr, data)->is_vmalloc = 0;
-			container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
-		}
+	out = (len > PAGE_SIZE) ? vmalloc(len) : kmalloc(len, GFP_KERNEL);
+	if (out) {
+		out += HDRLEN;
+		container_of(out, struct ipc_rcu_hdr, data)->refcount = 1;
 	}
-
 	return out;
 }
 
@@ -562,29 +532,15 @@ void ipc_rcu_getref(void *ptr)
 	container_of(ptr, struct ipc_rcu_hdr, data)->refcount++;
 }
 
-static void ipc_do_vfree(struct work_struct *work)
-{
-	vfree(container_of(work, struct ipc_rcu_sched, work));
-}
-
 /**
  * ipc_schedule_free - free ipc + rcu space
  * @head: RCU callback structure for queued work
- * 
- * Since RCU callback function is called in bh,
- * we need to defer the vfree to schedule_work().
  */
 static void ipc_schedule_free(struct rcu_head *head)
 {
 	struct ipc_rcu_grace *grace;
-	struct ipc_rcu_sched *sched;
-
 	grace = container_of(head, struct ipc_rcu_grace, rcu);
-	sched = container_of(&(grace->data[0]), struct ipc_rcu_sched,
-				data[0]);
-
-	INIT_WORK(&sched->work, ipc_do_vfree);
-	schedule_work(&sched->work);
+	vfree(grace);
 }
 
 void ipc_rcu_putref(void *ptr)
@@ -592,7 +548,7 @@ void ipc_rcu_putref(void *ptr)
 	if (--container_of(ptr, struct ipc_rcu_hdr, data)->refcount > 0)
 		return;
 
-	if (container_of(ptr, struct ipc_rcu_hdr, data)->is_vmalloc) {
+	if (is_vmalloc_addr(ptr)) {
 		call_rcu(&container_of(ptr, struct ipc_rcu_grace, data)->rcu,
 				ipc_schedule_free);
 	} else {
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 0f751f2..27ac467 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -1176,6 +1176,32 @@ void __init vm_area_register_early(struct vm_struct *vm, size_t align)
 	vm_area_add_early(vm);
 }
 
+struct vfree_deferred {
+	spinlock_t lock;
+	void *list;
+	struct work_struct wq;
+};
+
+static DEFINE_PER_CPU(struct vfree_deferred, vfree_deferred);
+
+static void __vunmap(const void *, int);
+
+static void free_work(struct work_struct *w)
+{
+	struct vfree_deferred *p = container_of(w, struct vfree_deferred, wq);
+	void *list;
+
+	spin_lock_bh(&p->lock);
+	list = p->list;
+	p->list = NULL;
+	spin_unlock_bh(&p->lock);
+	while (list) {
+		void *next = *(void **)list;
+		__vunmap(list, 1);
+		list = next;
+	}
+}
+
 void __init vmalloc_init(void)
 {
 	struct vmap_area *va;
@@ -1184,10 +1210,15 @@ void __init vmalloc_init(void)
 
 	for_each_possible_cpu(i) {
 		struct vmap_block_queue *vbq;
+		struct vfree_deferred *p;
 
 		vbq = &per_cpu(vmap_block_queue, i);
 		spin_lock_init(&vbq->lock);
 		INIT_LIST_HEAD(&vbq->free);
+		p = &per_cpu(vfree_deferred, i);
+		spin_lock_init(&p->lock);
+		p->list = NULL;
+		INIT_WORK(&p->wq, free_work);
 	}
 
 	/* Import existing vmlist entries. */
@@ -1512,6 +1543,17 @@ static void __vunmap(const void *addr, int deallocate_pages)
 	return;
 }
 
+static inline void deferred_vfree(void *addr)
+{
+	struct vfree_deferred *p = &get_cpu_var(vfree_deferred);
+	spin_lock(&p->lock);
+	*(void **)addr = p->list;
+	p->list = addr;
+	schedule_work(&p->wq);
+	spin_unlock(&p->lock);
+	put_cpu_var(vfree_deferred);
+}
+
 /**
  *	vfree  -  release memory allocated by vmalloc()
  *	@addr:		memory base address
@@ -1519,16 +1561,14 @@ static void __vunmap(const void *addr, int deallocate_pages)
  *	Free the virtually continuous memory area starting at @addr, as
  *	obtained from vmalloc(), vmalloc_32() or __vmalloc(). If @addr is
  *	NULL, no operation is performed.
- *
- *	Must not be called in interrupt context.
  */
 void vfree(const void *addr)
 {
-	BUG_ON(in_interrupt());
-
 	kmemleak_free(addr);
-
-	__vunmap(addr, 1);
+	if (unlikely(in_interrupt()))
+		deferred_vfree((void *)addr);
+	else
+		__vunmap(addr, 1);
 }
 EXPORT_SYMBOL(vfree);
 
diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
index 7427ab5..981fed3 100644
--- a/net/core/net-sysfs.c
+++ b/net/core/net-sysfs.c
@@ -606,21 +606,11 @@ static ssize_t show_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
 	return sprintf(buf, "%lu\n", val);
 }
 
-static void rps_dev_flow_table_release_work(struct work_struct *work)
-{
-	struct rps_dev_flow_table *table = container_of(work,
-	    struct rps_dev_flow_table, free_work);
-
-	vfree(table);
-}
-
 static void rps_dev_flow_table_release(struct rcu_head *rcu)
 {
 	struct rps_dev_flow_table *table = container_of(rcu,
 	    struct rps_dev_flow_table, rcu);
-
-	INIT_WORK(&table->free_work, rps_dev_flow_table_release_work);
-	schedule_work(&table->free_work);
+	vfree(table);
 }
 
 static ssize_t store_rps_dev_flow_table_cnt(struct netdev_rx_queue *queue,
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 61e03da..6bf4b83 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -125,7 +125,6 @@ struct tnode {
 	unsigned int empty_children;	/* KEYLENGTH bits needed */
 	union {
 		struct rcu_head rcu;
-		struct work_struct work;
 		struct tnode *tnode_free;
 	};
 	struct rt_trie_node __rcu *child[0];
@@ -383,12 +382,6 @@ static struct tnode *tnode_alloc(size_t size)
 		return vzalloc(size);
 }
 
-static void __tnode_vfree(struct work_struct *arg)
-{
-	struct tnode *tn = container_of(arg, struct tnode, work);
-	vfree(tn);
-}
-
 static void __tnode_free_rcu(struct rcu_head *head)
 {
 	struct tnode *tn = container_of(head, struct tnode, rcu);
@@ -397,10 +390,8 @@ static void __tnode_free_rcu(struct rcu_head *head)
 
 	if (size <= PAGE_SIZE)
 		kfree(tn);
-	else {
-		INIT_WORK(&tn->work, __tnode_vfree);
-		schedule_work(&tn->work);
-	}
+	else
+		vfree(tn);
 }
 
 static inline void tnode_free(struct tnode *tn)
diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 7430298..5b62af7 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -105,19 +105,6 @@ void *kvmalloc(size_t size)
 }
 
 /**
- * do_vfree - workqueue routine for freeing vmalloced memory
- * @work: data to be freed
- *
- * The work_struct is overlaid to the data being freed, as at the point
- * the work is scheduled the data is no longer valid, be its freeing
- * needs to be delayed until safe.
- */
-static void do_vfree(struct work_struct *work)
-{
-	vfree(work);
-}
-
-/**
  * kvfree - free an allocation do by kvmalloc
  * @buffer: buffer to free (MAYBE_NULL)
  *
@@ -125,13 +112,8 @@ static void do_vfree(struct work_struct *work)
  */
 void kvfree(void *buffer)
 {
-	if (is_vmalloc_addr(buffer)) {
-		/* Data is no longer valid so just use the allocated space
-		 * as the work_struct
-		 */
-		struct work_struct *work = (struct work_struct *) buffer;
-		INIT_WORK(work, do_vfree);
-		schedule_work(work);
-	} else
+	if (is_vmalloc_addr(buffer))
+		vfree(buffer);
+	else
 		kfree(buffer);
 }
