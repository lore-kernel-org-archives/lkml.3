Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaHPCeg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 22:34:36 -0400
Received: from kanga.kvack.org ([205.233.56.17]:35975 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaHPCef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 22:34:35 -0400
Date: Fri, 15 Aug 2014 22:34:33 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-aio@kvack.org
Subject: [GIT PULL] aio changes for 3.17
Message-ID: <20140816023433.GB27088@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 263782c1c95bbddbb022dc092fd89a36bb8d5577:

  aio: protect reqs_available updates from changes in interrupt handlers (2014-07-14 13:05:26 -0400)

are available in the git repository at:

  git://git.kvack.org/~bcrl/aio-next.git master

for you to fetch changes up to 00fefb9cf2b5493a86912de55ba912bdfae4a207:

  aio: use iovec array rather than the single one (2014-07-24 10:59:40 -0400)

----------------------------------------------------------------
Benjamin LaHaise (2):
      Merge ../aio-fixes
      aio: remove no longer needed preempt_disable()

Gu Zheng (4):
      aio: remove the needless registration of ring file's private_data
      aio: use the macro rather than the inline magic number
      aio: fix some comments
      aio: use iovec array rather than the single one

Oleg Nesterov (2):
      aio: change exit_aio() to load mm->ioctx_table once and avoid rcu_read_lock()
      aio: kill the misleading rcu read locks in ioctx_add_table() and kill_ioctx()

 fs/aio.c | 86 ++++++++++++++++++++++------------------------------------------
 1 file changed, 30 insertions(+), 56 deletions(-)

diff --git a/fs/aio.c b/fs/aio.c
index 1c9c5f0..0fd9181 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -192,7 +192,6 @@ static struct file *aio_private_file(struct kioctx *ctx, loff_t nr_pages)
 	}
 
 	file->f_flags = O_RDWR;
-	file->private_data = ctx;
 	return file;
 }
 
@@ -202,7 +201,7 @@ static struct dentry *aio_mount(struct file_system_type *fs_type,
 	static const struct dentry_operations ops = {
 		.d_dname	= simple_dname,
 	};
-	return mount_pseudo(fs_type, "aio:", NULL, &ops, 0xa10a10a1);
+	return mount_pseudo(fs_type, "aio:", NULL, &ops, AIO_RING_MAGIC);
 }
 
 /* aio_setup
@@ -554,8 +553,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 	struct aio_ring *ring;
 
 	spin_lock(&mm->ioctx_lock);
-	rcu_read_lock();
-	table = rcu_dereference(mm->ioctx_table);
+	table = rcu_dereference_raw(mm->ioctx_table);
 
 	while (1) {
 		if (table)
@@ -563,7 +561,6 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 				if (!table->table[i]) {
 					ctx->id = i;
 					table->table[i] = ctx;
-					rcu_read_unlock();
 					spin_unlock(&mm->ioctx_lock);
 
 					/* While kioctx setup is in progress,
@@ -577,8 +574,6 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 				}
 
 		new_nr = (table ? table->nr : 1) * 4;
-
-		rcu_read_unlock();
 		spin_unlock(&mm->ioctx_lock);
 
 		table = kzalloc(sizeof(*table) + sizeof(struct kioctx *) *
@@ -589,8 +584,7 @@ static int ioctx_add_table(struct kioctx *ctx, struct mm_struct *mm)
 		table->nr = new_nr;
 
 		spin_lock(&mm->ioctx_lock);
-		rcu_read_lock();
-		old = rcu_dereference(mm->ioctx_table);
+		old = rcu_dereference_raw(mm->ioctx_table);
 
 		if (!old) {
 			rcu_assign_pointer(mm->ioctx_table, table);
@@ -737,12 +731,9 @@ static int kill_ioctx(struct mm_struct *mm, struct kioctx *ctx,
 
 
 	spin_lock(&mm->ioctx_lock);
-	rcu_read_lock();
-	table = rcu_dereference(mm->ioctx_table);
-
+	table = rcu_dereference_raw(mm->ioctx_table);
 	WARN_ON(ctx != table->table[ctx->id]);
 	table->table[ctx->id] = NULL;
-	rcu_read_unlock();
 	spin_unlock(&mm->ioctx_lock);
 
 	/* percpu_ref_kill() will do the necessary call_rcu() */
@@ -791,40 +782,30 @@ EXPORT_SYMBOL(wait_on_sync_kiocb);
  */
 void exit_aio(struct mm_struct *mm)
 {
-	struct kioctx_table *table;
-	struct kioctx *ctx;
-	unsigned i = 0;
-
-	while (1) {
-		rcu_read_lock();
-		table = rcu_dereference(mm->ioctx_table);
-
-		do {
-			if (!table || i >= table->nr) {
-				rcu_read_unlock();
-				rcu_assign_pointer(mm->ioctx_table, NULL);
-				if (table)
-					kfree(table);
-				return;
-			}
+	struct kioctx_table *table = rcu_dereference_raw(mm->ioctx_table);
+	int i;
 
-			ctx = table->table[i++];
-		} while (!ctx);
+	if (!table)
+		return;
 
-		rcu_read_unlock();
+	for (i = 0; i < table->nr; ++i) {
+		struct kioctx *ctx = table->table[i];
 
+		if (!ctx)
+			continue;
 		/*
-		 * We don't need to bother with munmap() here -
-		 * exit_mmap(mm) is coming and it'll unmap everything.
-		 * Since aio_free_ring() uses non-zero ->mmap_size
-		 * as indicator that it needs to unmap the area,
-		 * just set it to 0; aio_free_ring() is the only
-		 * place that uses ->mmap_size, so it's safe.
+		 * We don't need to bother with munmap() here - exit_mmap(mm)
+		 * is coming and it'll unmap everything. And we simply can't,
+		 * this is not necessarily our ->mm.
+		 * Since kill_ioctx() uses non-zero ->mmap_size as indicator
+		 * that it needs to unmap the area, just set it to 0.
 		 */
 		ctx->mmap_size = 0;
-
 		kill_ioctx(mm, ctx, NULL);
 	}
+
+	RCU_INIT_POINTER(mm->ioctx_table, NULL);
+	kfree(table);
 }
 
 static void put_reqs_available(struct kioctx *ctx, unsigned nr)
@@ -832,10 +813,8 @@ static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 	struct kioctx_cpu *kcpu;
 	unsigned long flags;
 
-	preempt_disable();
-	kcpu = this_cpu_ptr(ctx->cpu);
-
 	local_irq_save(flags);
+	kcpu = this_cpu_ptr(ctx->cpu);
 	kcpu->reqs_available += nr;
 
 	while (kcpu->reqs_available >= ctx->req_batch * 2) {
@@ -844,7 +823,6 @@ static void put_reqs_available(struct kioctx *ctx, unsigned nr)
 	}
 
 	local_irq_restore(flags);
-	preempt_enable();
 }
 
 static bool get_reqs_available(struct kioctx *ctx)
@@ -853,10 +831,8 @@ static bool get_reqs_available(struct kioctx *ctx)
 	bool ret = false;
 	unsigned long flags;
 
-	preempt_disable();
-	kcpu = this_cpu_ptr(ctx->cpu);
-
 	local_irq_save(flags);
+	kcpu = this_cpu_ptr(ctx->cpu);
 	if (!kcpu->reqs_available) {
 		int old, avail = atomic_read(&ctx->reqs_available);
 
@@ -876,7 +852,6 @@ static bool get_reqs_available(struct kioctx *ctx)
 	kcpu->reqs_available--;
 out:
 	local_irq_restore(flags);
-	preempt_enable();
 	return ret;
 }
 
@@ -1045,7 +1020,7 @@ void aio_complete(struct kiocb *iocb, long res, long res2)
 }
 EXPORT_SYMBOL(aio_complete);
 
-/* aio_read_events
+/* aio_read_events_ring
  *	Pull an event off of the ioctx's event ring.  Returns the number of
  *	events fetched
  */
@@ -1268,12 +1243,12 @@ static ssize_t aio_setup_vectored_rw(struct kiocb *kiocb,
 	if (compat)
 		ret = compat_rw_copy_check_uvector(rw,
 				(struct compat_iovec __user *)buf,
-				*nr_segs, 1, *iovec, iovec);
+				*nr_segs, UIO_FASTIOV, *iovec, iovec);
 	else
 #endif
 		ret = rw_copy_check_uvector(rw,
 				(struct iovec __user *)buf,
-				*nr_segs, 1, *iovec, iovec);
+				*nr_segs, UIO_FASTIOV, *iovec, iovec);
 	if (ret < 0)
 		return ret;
 
@@ -1297,9 +1272,8 @@ static ssize_t aio_setup_single_vector(struct kiocb *kiocb,
 }
 
 /*
- * aio_setup_iocb:
- *	Performs the initial checks and aio retry method
- *	setup for the kiocb at the time of io submission.
+ * aio_run_iocb:
+ *	Performs the initial checks and io submission.
  */
 static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
 			    char __user *buf, bool compat)
@@ -1311,7 +1285,7 @@ static ssize_t aio_run_iocb(struct kiocb *req, unsigned opcode,
 	fmode_t mode;
 	aio_rw_op *rw_op;
 	rw_iter_op *iter_op;
-	struct iovec inline_vec, *iovec = &inline_vec;
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct iov_iter iter;
 
 	switch (opcode) {
@@ -1346,7 +1320,7 @@ rw_common:
 		if (!ret)
 			ret = rw_verify_area(rw, file, &req->ki_pos, req->ki_nbytes);
 		if (ret < 0) {
-			if (iovec != &inline_vec)
+			if (iovec != inline_vecs)
 				kfree(iovec);
 			return ret;
 		}
@@ -1393,7 +1367,7 @@ rw_common:
 		return -EINVAL;
 	}
 
-	if (iovec != &inline_vec)
+	if (iovec != inline_vecs)
 		kfree(iovec);
 
 	if (ret != -EIOCBQUEUED) {
-- 
"Thought is the essence of where you are now."
