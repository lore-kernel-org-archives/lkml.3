Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab3GVQKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:07 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:35302 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab3GVQKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:00 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 02/48] staging/lustre/obdclass: restore lu_ref
Date: Tue, 23 Jul 2013 00:06:23 +0800
Message-Id: <1374509230-3324-3-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lu_ref.[ch] were mistakenly removed by coan2. Add them back and guard
with CONFIG_LUSTRE_DEBUG_LU_REF_CHECK.

Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/Kconfig           |   10 +
 drivers/staging/lustre/lustre/include/lu_ref.h  |  124 +++++--
 drivers/staging/lustre/lustre/obdclass/Makefile |    5 +-
 drivers/staging/lustre/lustre/obdclass/lu_ref.c |  403 ++++++++++++++++++++++-
 4 files changed, 511 insertions(+), 31 deletions(-)

diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
index 893a3c6..0a8eb1ad 100644
--- a/drivers/staging/lustre/lustre/Kconfig
+++ b/drivers/staging/lustre/lustre/Kconfig
@@ -40,6 +40,16 @@ config LUSTRE_OBD_MAX_IOCTL_BUFFER
 
 	  If unsure, use default.
 
+config LUSTRE_DEBUG_LU_REF_CHECK
+	bool "Enable Lustre DEBUG object refcount checks"
+	depends on LUSTRE_FS
+	default false
+	help
+	  This option is mainly for debug purpose. It enables Lustre code to track
+	  references between objects.
+
+	  If unsure, say N.
+
 config LUSTRE_DEBUG_EXPENSIVE_CHECK
 	bool "Enable Lustre DEBUG checks"
 	depends on LUSTRE_FS
diff --git a/drivers/staging/lustre/lustre/include/lu_ref.h b/drivers/staging/lustre/lustre/include/lu_ref.h
index 624c19b..adfbf51 100644
--- a/drivers/staging/lustre/lustre/include/lu_ref.h
+++ b/drivers/staging/lustre/lustre/include/lu_ref.h
@@ -36,11 +36,11 @@
  * who acquired references to instance of struct foo, add lu_ref field to it:
  *
  * \code
- *	 struct foo {
- *		 atomic_t      foo_refcount;
- *		 struct lu_ref foo_reference;
- *		 ...
- *	 };
+ *         struct foo {
+ *                 atomic_t      foo_refcount;
+ *                 struct lu_ref foo_reference;
+ *                 ...
+ *         };
  * \endcode
  *
  * foo::foo_reference has to be initialized by calling
@@ -54,28 +54,28 @@
  * usages are:
  *
  * \code
- *	struct bar *bar;
+ *        struct bar *bar;
  *
- *	// bar owns a reference to foo.
- *	bar->bar_foo = foo_get(foo);
- *	lu_ref_add(&foo->foo_reference, "bar", bar);
+ *        // bar owns a reference to foo.
+ *        bar->bar_foo = foo_get(foo);
+ *        lu_ref_add(&foo->foo_reference, "bar", bar);
  *
- *	...
+ *        ...
  *
- *	// reference from bar to foo is released.
- *	lu_ref_del(&foo->foo_reference, "bar", bar);
- *	foo_put(bar->bar_foo);
+ *        // reference from bar to foo is released.
+ *        lu_ref_del(&foo->foo_reference, "bar", bar);
+ *        foo_put(bar->bar_foo);
  *
  *
- *	// current thread acquired a temporary reference to foo.
- *	foo_get(foo);
- *	lu_ref_add(&foo->reference, __FUNCTION__, current);
+ *        // current thread acquired a temporary reference to foo.
+ *        foo_get(foo);
+ *        lu_ref_add(&foo->reference, __FUNCTION__, current);
  *
- *	...
+ *        ...
  *
- *	// temporary reference is released.
- *	lu_ref_del(&foo->reference, __FUNCTION__, current);
- *	foo_put(foo);
+ *        // temporary reference is released.
+ *        lu_ref_del(&foo->reference, __FUNCTION__, current);
+ *        foo_put(foo);
  * \endcode
  *
  * \e Et \e cetera. Often it makes sense to include lu_ref_add() and
@@ -91,15 +91,15 @@
  * lu_ref_del_at():
  *
  * \code
- *	// There is a large number of bar's for a single foo.
- *	bar->bar_foo     = foo_get(foo);
- *	bar->bar_foo_ref = lu_ref_add(&foo->foo_reference, "bar", bar);
+ *        // There is a large number of bar's for a single foo.
+ *        bar->bar_foo     = foo_get(foo);
+ *        bar->bar_foo_ref = lu_ref_add(&foo->foo_reference, "bar", bar);
  *
- *	...
+ *        ...
  *
- *	// reference from bar to foo is released.
- *	lu_ref_del_at(&foo->foo_reference, bar->bar_foo_ref, "bar", bar);
- *	foo_put(bar->bar_foo);
+ *        // reference from bar to foo is released.
+ *        lu_ref_del_at(&foo->foo_reference, bar->bar_foo_ref, "bar", bar);
+ *        foo_put(bar->bar_foo);
  * \endcode
  *
  * lu_ref interface degrades gracefully in case of memory shortages.
@@ -107,6 +107,75 @@
  * @{
  */
 
+#ifdef CONFIG_LUSTRE_DEBUG_LU_REF_CHECK
+
+/* An incomplete type (defined locally in lu_ref.c) */
+struct lu_ref_link;
+
+/**
+ * Data-structure to keep track of references to a given object. This is used
+ * for debugging.
+ *
+ * lu_ref is embedded into an object which other entities (objects, threads,
+ * etc.) refer to.
+ */
+struct lu_ref {
+	/**
+	 * Spin-lock protecting lu_ref::lf_list.
+	 */
+	spinlock_t		lf_guard;
+	/**
+	 * List of all outstanding references (each represented by struct
+	 * lu_ref_link), pointing to this object.
+	 */
+	struct list_head           lf_list;
+	/**
+	 * # of links.
+	 */
+	short                lf_refs;
+	/**
+	 * Flag set when lu_ref_add() failed to allocate lu_ref_link. It is
+	 * used to mask spurious failure of the following lu_ref_del().
+	 */
+	short                lf_failed;
+	/**
+	 * flags - attribute for the lu_ref, for pad and future use.
+	 */
+	short                lf_flags;
+	/**
+	 * Where was I initialized?
+	 */
+	short                lf_line;
+	const char          *lf_func;
+	/**
+	 * Linkage into a global list of all lu_ref's (lu_ref_refs).
+	 */
+	struct list_head           lf_linkage;
+};
+
+int lu_ref_global_init(void);
+void lu_ref_global_fini(void);
+void lu_ref_init_loc(struct lu_ref *ref, const char *func, const int line);
+void lu_ref_fini    (struct lu_ref *ref);
+#define lu_ref_init(ref) lu_ref_init_loc(ref, __FUNCTION__, __LINE__)
+
+struct lu_ref_link *lu_ref_add       (struct lu_ref *ref, const char *scope,
+				      const void *source);
+struct lu_ref_link *lu_ref_add_atomic(struct lu_ref *ref, const char *scope,
+				      const void *source);
+void lu_ref_del                      (struct lu_ref *ref, const char *scope,
+				      const void *source);
+void lu_ref_set_at                   (struct lu_ref *ref,
+				      struct lu_ref_link *link,
+				      const char *scope, const void *source0,
+				      const void *source1);
+void lu_ref_del_at                   (struct lu_ref *ref,
+				      struct lu_ref_link *link,
+				      const char *scope, const void *source);
+void lu_ref_print                    (const struct lu_ref *ref);
+void lu_ref_print_all                (void);
+
+#else /* !CONFIG_LUSTRE_DEBUG_LU_REF_CHECK */
 
 struct lu_ref  {};
 
@@ -164,6 +233,7 @@ static inline void lu_ref_print(const struct lu_ref *ref)
 static inline void lu_ref_print_all(void)
 {
 }
+#endif /* CONFIG_LUSTRE_DEBUG_LU_REF_CHECK */
 
 /** @} lu */
 
diff --git a/drivers/staging/lustre/lustre/obdclass/Makefile b/drivers/staging/lustre/lustre/obdclass/Makefile
index b80c13c..9930a9e 100644
--- a/drivers/staging/lustre/lustre/obdclass/Makefile
+++ b/drivers/staging/lustre/lustre/obdclass/Makefile
@@ -6,8 +6,9 @@ obdclass-y := linux/linux-module.o linux/linux-obdo.o linux/linux-sysctl.o \
 	      lprocfs_jobstats.o lustre_handles.o lustre_peer.o llog_osd.o \
 	      local_storage.o statfs_pack.o obdo.o obd_config.o obd_mount.o\
 	      mea.o lu_object.o dt_object.o capa.o cl_object.o   \
-	      cl_page.o cl_lock.o cl_io.o lu_ref.o acl.o idmap.o	   \
-	      lu_ucred.o
+	      cl_page.o cl_lock.o cl_io.o acl.o idmap.o	lu_ucred.o
+
+obdclass-$(CONFIG_LUSTRE_DEBUG_LU_REF_CHECK) += lu_ref.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/obdclass/lu_ref.c b/drivers/staging/lustre/lustre/obdclass/lu_ref.c
index 23a76f1..79d25c5 100644
--- a/drivers/staging/lustre/lustre/obdclass/lu_ref.c
+++ b/drivers/staging/lustre/lustre/obdclass/lu_ref.c
@@ -42,9 +42,408 @@
 
 #define DEBUG_SUBSYSTEM S_CLASS
 
-# include <linux/libcfs/libcfs.h>
-
+#include <linux/gfp.h>
+#include <linux/libcfs.h>
 #include <obd.h>
 #include <obd_class.h>
 #include <obd_support.h>
 #include <lu_ref.h>
+
+/**
+ * Asserts a condition for a given lu_ref. Must be called with
+ * lu_ref::lf_guard held.
+ */
+#define REFASSERT(ref, expr) do {					\
+	struct lu_ref *__tmp = (ref);					\
+									\
+	if (unlikely(!(expr))) {					\
+		lu_ref_print(__tmp);					\
+		spin_unlock(&__tmp->lf_guard);				\
+		lu_ref_print_all();					\
+		LASSERT(0);						\
+		spin_lock(&__tmp->lf_guard);				\
+	}								\
+} while (0)
+
+struct lu_ref_link {
+	struct lu_ref    *ll_ref;
+	struct list_head        ll_linkage;
+	const char       *ll_scope;
+	const void       *ll_source;
+};
+
+static struct kmem_cache *lu_ref_link_kmem;
+
+static struct lu_kmem_descr lu_ref_caches[] = {
+	{
+		.ckd_cache = &lu_ref_link_kmem,
+		.ckd_name  = "lu_ref_link_kmem",
+		.ckd_size  = sizeof (struct lu_ref_link)
+	},
+	{
+		.ckd_cache = NULL
+	}
+};
+
+/**
+ * Global list of active (initialized, but not finalized) lu_ref's.
+ *
+ * Protected by lu_ref_refs_guard.
+ */
+static LIST_HEAD(lu_ref_refs);
+static spinlock_t lu_ref_refs_guard;
+static struct lu_ref lu_ref_marker = {
+	.lf_guard   = __SPIN_LOCK_UNLOCKED(lu_ref_marker.lf_guard),
+	.lf_list    = LIST_HEAD_INIT(lu_ref_marker.lf_list),
+	.lf_linkage = LIST_HEAD_INIT(lu_ref_marker.lf_linkage)
+};
+
+void lu_ref_print(const struct lu_ref *ref)
+{
+	struct lu_ref_link *link;
+
+	CERROR("lu_ref: %p %d %d %s:%d\n",
+	       ref, ref->lf_refs, ref->lf_failed, ref->lf_func, ref->lf_line);
+	list_for_each_entry(link, &ref->lf_list, ll_linkage) {
+		CERROR("     link: %s %p\n", link->ll_scope, link->ll_source);
+	}
+}
+EXPORT_SYMBOL(lu_ref_print);
+
+static int lu_ref_is_marker(const struct lu_ref *ref)
+{
+	return (ref == &lu_ref_marker);
+}
+
+void lu_ref_print_all(void)
+{
+	struct lu_ref *ref;
+
+	spin_lock(&lu_ref_refs_guard);
+	list_for_each_entry(ref, &lu_ref_refs, lf_linkage) {
+		if (lu_ref_is_marker(ref))
+			continue;
+
+		spin_lock(&ref->lf_guard);
+		lu_ref_print(ref);
+		spin_unlock(&ref->lf_guard);
+	}
+	spin_unlock(&lu_ref_refs_guard);
+}
+EXPORT_SYMBOL(lu_ref_print_all);
+
+void lu_ref_init_loc(struct lu_ref *ref, const char *func, const int line)
+{
+	ref->lf_refs = 0;
+	ref->lf_func = func;
+	ref->lf_line = line;
+	spin_lock_init(&ref->lf_guard);
+	INIT_LIST_HEAD(&ref->lf_list);
+	spin_lock(&lu_ref_refs_guard);
+	list_add(&ref->lf_linkage, &lu_ref_refs);
+	spin_unlock(&lu_ref_refs_guard);
+}
+EXPORT_SYMBOL(lu_ref_init_loc);
+
+void lu_ref_fini(struct lu_ref *ref)
+{
+	REFASSERT(ref, list_empty(&ref->lf_list));
+	REFASSERT(ref, ref->lf_refs == 0);
+	spin_lock(&lu_ref_refs_guard);
+	list_del_init(&ref->lf_linkage);
+	spin_unlock(&lu_ref_refs_guard);
+}
+EXPORT_SYMBOL(lu_ref_fini);
+
+static struct lu_ref_link *lu_ref_add_context(struct lu_ref *ref,
+					      gfp_t flags,
+					      const char *scope,
+					      const void *source)
+{
+	struct lu_ref_link *link;
+
+	link = NULL;
+	if (lu_ref_link_kmem != NULL) {
+		OBD_SLAB_ALLOC_PTR_GFP(link, lu_ref_link_kmem, flags);
+		if (link != NULL) {
+			link->ll_ref    = ref;
+			link->ll_scope  = scope;
+			link->ll_source = source;
+			spin_lock(&ref->lf_guard);
+			list_add_tail(&link->ll_linkage, &ref->lf_list);
+			ref->lf_refs++;
+			spin_unlock(&ref->lf_guard);
+		}
+	}
+
+	if (link == NULL) {
+		spin_lock(&ref->lf_guard);
+		ref->lf_failed++;
+		spin_unlock(&ref->lf_guard);
+		link = ERR_PTR(-ENOMEM);
+	}
+
+	return link;
+}
+
+struct lu_ref_link *lu_ref_add(struct lu_ref *ref, const char *scope,
+			       const void *source)
+{
+	might_sleep();
+	return lu_ref_add_context(ref, GFP_IOFS, scope, source);
+}
+EXPORT_SYMBOL(lu_ref_add);
+
+/**
+ * Version of lu_ref_add() to be used in non-blockable contexts.
+ */
+struct lu_ref_link *lu_ref_add_atomic(struct lu_ref *ref, const char *scope,
+				      const void *source)
+{
+	return lu_ref_add_context(ref, GFP_ATOMIC, scope, source);
+}
+EXPORT_SYMBOL(lu_ref_add_atomic);
+
+static inline int lu_ref_link_eq(const struct lu_ref_link *link,
+				 const char *scope, const void *source)
+{
+	return link->ll_source == source && !strcmp(link->ll_scope, scope);
+}
+
+/**
+ * Maximal chain length seen so far.
+ */
+static unsigned lu_ref_chain_max_length = 127;
+
+/**
+ * Searches for a lu_ref_link with given [scope, source] within given lu_ref.
+ */
+static struct lu_ref_link *lu_ref_find(struct lu_ref *ref, const char *scope,
+				       const void *source)
+{
+	struct lu_ref_link *link;
+	unsigned            iterations;
+
+	iterations = 0;
+	list_for_each_entry(link, &ref->lf_list, ll_linkage) {
+		++iterations;
+		if (lu_ref_link_eq(link, scope, source)) {
+			if (iterations > lu_ref_chain_max_length) {
+				CWARN("Long lu_ref chain %d \"%s\":%p\n",
+				      iterations, scope, source);
+				lu_ref_chain_max_length = iterations * 3 / 2;
+			}
+			return link;
+		}
+	}
+	return NULL;
+}
+
+void lu_ref_del(struct lu_ref *ref, const char *scope, const void *source)
+{
+	struct lu_ref_link *link;
+
+	spin_lock(&ref->lf_guard);
+	link = lu_ref_find(ref, scope, source);
+	if (link != NULL) {
+		list_del(&link->ll_linkage);
+		ref->lf_refs--;
+		spin_unlock(&ref->lf_guard);
+		OBD_SLAB_FREE(link, lu_ref_link_kmem, sizeof(*link));
+	} else {
+		REFASSERT(ref, ref->lf_failed > 0);
+		ref->lf_failed--;
+		spin_unlock(&ref->lf_guard);
+	}
+}
+EXPORT_SYMBOL(lu_ref_del);
+
+void lu_ref_set_at(struct lu_ref *ref, struct lu_ref_link *link,
+		   const char *scope,
+		   const void *source0, const void *source1)
+{
+	spin_lock(&ref->lf_guard);
+	if (link != ERR_PTR(-ENOMEM)) {
+		REFASSERT(ref, link->ll_ref == ref);
+		REFASSERT(ref, lu_ref_link_eq(link, scope, source0));
+		link->ll_source = source1;
+	} else {
+		REFASSERT(ref, ref->lf_failed > 0);
+	}
+	spin_unlock(&ref->lf_guard);
+}
+EXPORT_SYMBOL(lu_ref_set_at);
+
+void lu_ref_del_at(struct lu_ref *ref, struct lu_ref_link *link,
+		   const char *scope, const void *source)
+{
+	if (link != ERR_PTR(-ENOMEM)) {
+		spin_lock(&ref->lf_guard);
+		REFASSERT(ref, link->ll_ref == ref);
+		REFASSERT(ref, lu_ref_link_eq(link, scope, source));
+		list_del(&link->ll_linkage);
+		ref->lf_refs--;
+		spin_unlock(&ref->lf_guard);
+		OBD_SLAB_FREE(link, lu_ref_link_kmem, sizeof(*link));
+	} else {
+		spin_lock(&ref->lf_guard);
+		REFASSERT(ref, ref->lf_failed > 0);
+		ref->lf_failed--;
+		spin_unlock(&ref->lf_guard);
+	}
+}
+EXPORT_SYMBOL(lu_ref_del_at);
+
+#ifdef LPROCFS
+
+static void *lu_ref_seq_start(struct seq_file *seq, loff_t *pos)
+{
+	struct lu_ref *ref = seq->private;
+
+	spin_lock(&lu_ref_refs_guard);
+	if (list_empty(&ref->lf_linkage))
+		ref = NULL;
+	spin_unlock(&lu_ref_refs_guard);
+
+	return ref;
+}
+
+static void *lu_ref_seq_next(struct seq_file *seq, void *p, loff_t *pos)
+{
+	struct lu_ref *ref = p;
+	struct lu_ref *next;
+
+	LASSERT(seq->private == p);
+	LASSERT(!list_empty(&ref->lf_linkage));
+
+	spin_lock(&lu_ref_refs_guard);
+	next = list_entry(ref->lf_linkage.next, struct lu_ref, lf_linkage);
+	if (&next->lf_linkage == &lu_ref_refs) {
+		p = NULL;
+	} else {
+		(*pos)++;
+		list_move(&ref->lf_linkage, &next->lf_linkage);
+	}
+	spin_unlock(&lu_ref_refs_guard);
+	return p;
+}
+
+static void lu_ref_seq_stop(struct seq_file *seq, void *p)
+{
+	/* Nothing to do */
+}
+
+
+static int lu_ref_seq_show(struct seq_file *seq, void *p)
+{
+	struct lu_ref *ref  = p;
+	struct lu_ref *next;
+
+	spin_lock(&lu_ref_refs_guard);
+	next = list_entry(ref->lf_linkage.next, struct lu_ref, lf_linkage);
+	if ((&next->lf_linkage == &lu_ref_refs) || lu_ref_is_marker(next)) {
+		spin_unlock(&lu_ref_refs_guard);
+		return 0;
+	}
+
+	/* print the entry */
+	spin_lock(&next->lf_guard);
+	seq_printf(seq, "lu_ref: %p %d %d %s:%d\n",
+		   next, next->lf_refs, next->lf_failed,
+		   next->lf_func, next->lf_line);
+	if (next->lf_refs > 64) {
+		seq_printf(seq, "  too many references, skip\n");
+	} else {
+		struct lu_ref_link *link;
+		int i = 0;
+
+		list_for_each_entry(link, &next->lf_list, ll_linkage)
+			seq_printf(seq, "  #%d link: %s %p\n",
+				   i++, link->ll_scope, link->ll_source);
+	}
+	spin_unlock(&next->lf_guard);
+	spin_unlock(&lu_ref_refs_guard);
+
+	return 0;
+}
+
+static struct seq_operations lu_ref_seq_ops = {
+	.start = lu_ref_seq_start,
+	.stop  = lu_ref_seq_stop,
+	.next  = lu_ref_seq_next,
+	.show  = lu_ref_seq_show
+};
+
+static int lu_ref_seq_open(struct inode *inode, struct file *file)
+{
+	struct lu_ref *marker = &lu_ref_marker;
+	int result = 0;
+
+	result = seq_open(file, &lu_ref_seq_ops);
+	if (result == 0) {
+		spin_lock(&lu_ref_refs_guard);
+		if (!list_empty(&marker->lf_linkage))
+			result = -EAGAIN;
+		else
+			list_add(&marker->lf_linkage, &lu_ref_refs);
+		spin_unlock(&lu_ref_refs_guard);
+
+		if (result == 0) {
+			struct seq_file *f = file->private_data;
+			f->private = marker;
+		} else {
+			seq_release(inode, file);
+		}
+	}
+
+	return result;
+}
+
+static int lu_ref_seq_release(struct inode *inode, struct file *file)
+{
+	struct lu_ref *ref = ((struct seq_file *)file->private_data)->private;
+
+	spin_lock(&lu_ref_refs_guard);
+	list_del_init(&ref->lf_linkage);
+	spin_unlock(&lu_ref_refs_guard);
+
+	return seq_release(inode, file);
+}
+
+static struct file_operations lu_ref_dump_fops = {
+	.owner   = THIS_MODULE,
+	.open    = lu_ref_seq_open,
+	.read    = seq_read,
+	.llseek  = seq_lseek,
+	.release = lu_ref_seq_release
+};
+
+int lu_ref_global_init(void)
+{
+	int result;
+
+	CDEBUG(D_CONSOLE,
+	       "lu_ref tracking is enabled. Performance isn't.\n");
+
+	spin_lock_init(&lu_ref_refs_guard);
+	result = lu_kmem_init(lu_ref_caches);
+
+#ifdef LPROCFS
+	if (result == 0) {
+		result = lprocfs_seq_create(proc_lustre_root, "lu_refs",
+					    0444, &lu_ref_dump_fops, NULL);
+		if (result)
+			lu_kmem_fini(lu_ref_caches);
+	}
+#endif
+
+	return result;
+}
+
+void lu_ref_global_fini(void)
+{
+#ifdef LPROCFS
+	lprocfs_remove_proc_entry("lu_refs", proc_lustre_root);
+#endif
+	lu_kmem_fini(lu_ref_caches);
+}
-- 
1.7.9.5

