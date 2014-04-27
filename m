Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454AbaD0RIb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:08:31 -0400
Received: from linuxhacker.ru ([217.76.32.60]:48106 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbaD0RI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:08:29 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: [PATCH 36/47] staging/lustre/clio: replace semaphore with mutex
Date: Sun, 27 Apr 2014 13:07:00 -0400
Message-Id: <1398618431-29757-37-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Eremin <dmitry.eremin@intel.com>

According https://www.kernel.org/doc/Documentation/mutex-design.txt:
- the mutex subsystem is slightly faster and has better scalability
  for contended workloads. In terms of 'ops per CPU cycle', the
  semaphore kernel performed 551 ops/sec per 1% of CPU time used,
  while the mutex kernel performed 3825 ops/sec per 1% of CPU time
  used - it was 6.9 times more efficient.
- there are no fastpath tradeoffs, the mutex fastpath is just as
  tight as the semaphore fastpath. On x86, the locking fastpath is
  2 instructions.
- 'struct mutex' semantics are well-defined and are enforced if
  CONFIG_DEBUG_MUTEXES is turned on. Semaphores on the other hand
  have virtually no debugging code or instrumentation.

One more benefit of mutex is optimistic spinning. It try to spin for
acquisition when there are no pending waiters and the lock owner is
currently running on a (different) CPU. The rationale is that if the
lock owner is running, it is likely to release the lock soon.

This significantly reduce amount of context switches when locked
region is small and we have high contention.
Signed-off-by: Dmitry Eremin <dmitry.eremin@intel.com>
Reviewed-on: http://review.whamcloud.com/9095
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-4257
Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
Reviewed-by: James Simmons <uja.ornl@gmail.com>
Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_internal.h | 10 ++++------
 drivers/staging/lustre/lustre/llite/llite_lib.c      | 12 +++---------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index d2f8250..f4b15bf 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -211,8 +211,7 @@ struct ll_inode_info {
 
 		/* for non-directory */
 		struct {
-			struct semaphore		f_size_sem;
-			void				*f_size_sem_owner;
+			struct mutex			f_size_mutex;
 			char				*f_symlink_name;
 			__u64				f_maxbytes;
 			/*
@@ -249,8 +248,7 @@ struct ll_inode_info {
 			char		     f_jobid[JOBSTATS_JOBID_SIZE];
 		} f;
 
-#define lli_size_sem	    u.f.f_size_sem
-#define lli_size_sem_owner      u.f.f_size_sem_owner
+#define lli_size_mutex          u.f.f_size_mutex
 #define lli_symlink_name	u.f.f_symlink_name
 #define lli_maxbytes	    u.f.f_maxbytes
 #define lli_trunc_sem	   u.f.f_trunc_sem
@@ -319,7 +317,7 @@ int ll_xattr_cache_get(struct inode *inode,
  * Locking to guarantee consistency of non-atomic updates to long long i_size,
  * consistency between file size and KMS.
  *
- * Implemented by ->lli_size_sem and ->lsm_lock, nested in that order.
+ * Implemented by ->lli_size_mutex and ->lsm_lock, nested in that order.
  */
 
 void ll_inode_size_lock(struct inode *inode);
@@ -1448,7 +1446,7 @@ static inline void cl_isize_unlock(struct inode *inode)
 
 static inline void cl_isize_write_nolock(struct inode *inode, loff_t kms)
 {
-	LASSERT(down_trylock(&ll_i2info(inode)->lli_size_sem) != 0);
+	LASSERT(mutex_is_locked(&ll_i2info(inode)->lli_size_mutex));
 	i_size_write(inode, kms);
 }
 
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index befc30b..34df5d9 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -982,8 +982,7 @@ void ll_lli_init(struct ll_inode_info *lli)
 		spin_lock_init(&lli->lli_sa_lock);
 		lli->lli_opendir_pid = 0;
 	} else {
-		sema_init(&lli->lli_size_sem, 1);
-		lli->lli_size_sem_owner = NULL;
+		mutex_init(&lli->lli_size_mutex);
 		lli->lli_symlink_name = NULL;
 		init_rwsem(&lli->lli_trunc_sem);
 		mutex_init(&lli->lli_write_mutex);
@@ -1700,10 +1699,7 @@ void ll_inode_size_lock(struct inode *inode)
 	LASSERT(!S_ISDIR(inode->i_mode));
 
 	lli = ll_i2info(inode);
-	LASSERT(lli->lli_size_sem_owner != current);
-	down(&lli->lli_size_sem);
-	LASSERT(lli->lli_size_sem_owner == NULL);
-	lli->lli_size_sem_owner = current;
+	mutex_lock(&lli->lli_size_mutex);
 }
 
 void ll_inode_size_unlock(struct inode *inode)
@@ -1711,9 +1707,7 @@ void ll_inode_size_unlock(struct inode *inode)
 	struct ll_inode_info *lli;
 
 	lli = ll_i2info(inode);
-	LASSERT(lli->lli_size_sem_owner == current);
-	lli->lli_size_sem_owner = NULL;
-	up(&lli->lli_size_sem);
+	mutex_unlock(&lli->lli_size_mutex);
 }
 
 void ll_update_inode(struct inode *inode, struct lustre_md *md)
-- 
1.8.5.3

