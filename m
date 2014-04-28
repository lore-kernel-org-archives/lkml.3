Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626AbaD1CWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 22:22:31 -0400
Received: from linuxhacker.ru ([217.76.32.60]:51597 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752184AbaD1CW3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 22:22:29 -0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: Oleg Drokin <green@linuxhacker.ru>, Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH] staging/lustre: Replace jobid acquiring with per node setting
Date: Sun, 27 Apr 2014 22:21:52 -0400
Message-Id: <1398651712-5015-1-git-send-email-green@linuxhacker.ru>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Insted of meddling directly in process environment variables
(which is also not possible on certain platforms due to not exported
symbols), create jobid_name proc file to represent this info
(to be filled by job scheduler epilogue).

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
CC: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/include/linux/libcfs/curproc.h  |   1 -
 .../staging/lustre/lustre/include/lprocfs_status.h |   1 +
 drivers/staging/lustre/lustre/include/obd_class.h  |   3 +
 .../lustre/lustre/libcfs/linux/linux-curproc.c     | 152 ---------------------
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  50 ++-----
 .../lustre/lustre/obdclass/linux/linux-module.c    |  27 ++++
 6 files changed, 44 insertions(+), 190 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index 8fd47c9..b314f34 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -56,7 +56,6 @@
 /* check if task is running in compat mode.*/
 #define current_pid()		(current->pid)
 #define current_comm()		(current->comm)
-int cfs_get_environ(const char *key, char *value, int *val_len);
 
 typedef __u32 cfs_cap_t;
 
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 9ce12c7..1b7f6a9 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -369,6 +369,7 @@ static inline void s2dhms(struct dhms *ts, time_t secs)
 #define JOBSTATS_JOBID_VAR_MAX_LEN	20
 #define JOBSTATS_DISABLE		"disable"
 #define JOBSTATS_PROCNAME_UID		"procname_uid"
+#define JOBSTATS_NODELOCAL		"nodelocal"
 
 extern int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
 				     int *val, int mult);
diff --git a/drivers/staging/lustre/lustre/include/obd_class.h b/drivers/staging/lustre/lustre/include/obd_class.h
index 61ba370..e265820 100644
--- a/drivers/staging/lustre/lustre/include/obd_class.h
+++ b/drivers/staging/lustre/lustre/include/obd_class.h
@@ -2182,6 +2182,9 @@ void class_exit_uuidlist(void);
 int mea_name2idx(struct lmv_stripe_md *mea, const char *name, int namelen);
 int raw_name2idx(int hashtype, int count, const char *name, int namelen);
 
+/* class_obd.c */
+extern char obd_jobid_node[];
+
 /* prng.c */
 #define ll_generate_random_uuid(uuid_out) cfs_get_random_bytes(uuid_out, sizeof(class_uuid_t))
 
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index e74c3e2..bd301ce 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -100,158 +100,6 @@ cfs_cap_t cfs_curproc_cap_pack(void)
 	return cap;
 }
 
-static int cfs_access_process_vm(struct task_struct *tsk, unsigned long addr,
-				 void *buf, int len, int write)
-{
-	/* Just copied from kernel for the kernels which doesn't
-	 * have access_process_vm() exported */
-	struct mm_struct *mm;
-	struct vm_area_struct *vma;
-	struct page *page;
-	void *old_buf = buf;
-
-	mm = get_task_mm(tsk);
-	if (!mm)
-		return 0;
-
-	down_read(&mm->mmap_sem);
-	/* ignore errors, just check how much was successfully transferred */
-	while (len) {
-		int bytes, rc, offset;
-		void *maddr;
-
-		rc = get_user_pages(tsk, mm, addr, 1,
-				     write, 1, &page, &vma);
-		if (rc <= 0)
-			break;
-
-		bytes = len;
-		offset = addr & (PAGE_SIZE-1);
-		if (bytes > PAGE_SIZE-offset)
-			bytes = PAGE_SIZE-offset;
-
-		maddr = kmap(page);
-		if (write) {
-			copy_to_user_page(vma, page, addr,
-					  maddr + offset, buf, bytes);
-			set_page_dirty_lock(page);
-		} else {
-			copy_from_user_page(vma, page, addr,
-					    buf, maddr + offset, bytes);
-		}
-		kunmap(page);
-		page_cache_release(page);
-		len -= bytes;
-		buf += bytes;
-		addr += bytes;
-	}
-	up_read(&mm->mmap_sem);
-	mmput(mm);
-
-	return buf - old_buf;
-}
-
-/* Read the environment variable of current process specified by @key. */
-int cfs_get_environ(const char *key, char *value, int *val_len)
-{
-	struct mm_struct *mm;
-	char *buffer, *tmp_buf = NULL;
-	int buf_len = PAGE_CACHE_SIZE;
-	int key_len = strlen(key);
-	unsigned long addr;
-	int rc;
-
-	buffer = kmalloc(buf_len, GFP_USER);
-	if (!buffer)
-		return -ENOMEM;
-
-	mm = get_task_mm(current);
-	if (!mm) {
-		kfree(buffer);
-		return -EINVAL;
-	}
-
-	/* Avoid deadlocks on mmap_sem if called from sys_mmap_pgoff(),
-	 * which is already holding mmap_sem for writes.  If some other
-	 * thread gets the write lock in the meantime, this thread will
-	 * block, but at least it won't deadlock on itself.  LU-1735 */
-	if (down_read_trylock(&mm->mmap_sem) == 0) {
-		kfree(buffer);
-		return -EDEADLK;
-	}
-	up_read(&mm->mmap_sem);
-
-	addr = mm->env_start;
-	while (addr < mm->env_end) {
-		int this_len, retval, scan_len;
-		char *env_start, *env_end;
-
-		memset(buffer, 0, buf_len);
-
-		this_len = min_t(int, mm->env_end - addr, buf_len);
-		retval = cfs_access_process_vm(current, addr, buffer,
-					       this_len, 0);
-		if (retval != this_len)
-			break;
-
-		addr += retval;
-
-		/* Parse the buffer to find out the specified key/value pair.
-		 * The "key=value" entries are separated by '\0'. */
-		env_start = buffer;
-		scan_len = this_len;
-		while (scan_len) {
-			char *entry;
-			int entry_len;
-
-			env_end = memscan(env_start, '\0', scan_len);
-			LASSERT(env_end >= env_start &&
-				env_end <= env_start + scan_len);
-
-			/* The last entry of this buffer cross the buffer
-			 * boundary, reread it in next cycle. */
-			if (unlikely(env_end - env_start == scan_len)) {
-				/* This entry is too large to fit in buffer */
-				if (unlikely(scan_len == this_len)) {
-					CERROR("Too long env variable.\n");
-					GOTO(out, rc = -EINVAL);
-				}
-				addr -= scan_len;
-				break;
-			}
-
-			entry = env_start;
-			entry_len = env_end - env_start;
-
-			/* Key length + length of '=' */
-			if (entry_len > key_len + 1 &&
-			    !memcmp(entry, key, key_len)) {
-				entry += key_len + 1;
-				entry_len -= key_len + 1;
-				/* The 'value' buffer passed in is too small.*/
-				if (entry_len >= *val_len)
-					GOTO(out, rc = -EOVERFLOW);
-
-				memcpy(value, entry, entry_len);
-				*val_len = entry_len;
-				GOTO(out, rc = 0);
-			}
-
-			scan_len -= (env_end - env_start + 1);
-			env_start = env_end + 1;
-		}
-	}
-	GOTO(out, rc = -ENOENT);
-
-out:
-	mmput(mm);
-	kfree((void *)buffer);
-	if (tmp_buf)
-		kfree((void *)tmp_buf);
-	return rc;
-}
-EXPORT_SYMBOL(cfs_get_environ);
-
 EXPORT_SYMBOL(cfs_cap_raise);
 EXPORT_SYMBOL(cfs_cap_lower);
 EXPORT_SYMBOL(cfs_cap_raised);
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index c93131e..dde04b7 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -102,23 +102,17 @@ EXPORT_SYMBOL(obd_dirty_transit_pages);
 char obd_jobid_var[JOBSTATS_JOBID_VAR_MAX_LEN + 1] = JOBSTATS_DISABLE;
 EXPORT_SYMBOL(obd_jobid_var);
 
-/* Get jobid of current process by reading the environment variable
- * stored in between the "env_start" & "env_end" of task struct.
- *
- * TODO:
- * It's better to cache the jobid for later use if there is any
- * efficient way, the cl_env code probably could be reused for this
- * purpose.
+char obd_jobid_node[JOBSTATS_JOBID_SIZE + 1];
+
+/* Get jobid of current process from stored variable or calculate
+ * it from pid and user_id.
  *
- * If some job scheduler doesn't store jobid in the "env_start/end",
- * then an upcall could be issued here to get the jobid by utilizing
- * the userspace tools/api. Then, the jobid must be cached.
+ * Historically this was also done by reading the environment variable
+ * stored in between the "env_start" & "env_end" of task struct.
+ * This is now deprecated.
  */
 int lustre_get_jobid(char *jobid)
 {
-	int jobid_len = JOBSTATS_JOBID_SIZE;
-	int rc = 0;
-
 	memset(jobid, 0, JOBSTATS_JOBID_SIZE);
 	/* Jobstats isn't enabled */
 	if (strcmp(obd_jobid_var, JOBSTATS_DISABLE) == 0)
@@ -132,31 +126,13 @@ int lustre_get_jobid(char *jobid)
 		return 0;
 	}
 
-	rc = cfs_get_environ(obd_jobid_var, jobid, &jobid_len);
-	if (rc) {
-		if (rc == -EOVERFLOW) {
-			/* For the PBS_JOBID and LOADL_STEP_ID keys (which are
-			 * variable length strings instead of just numbers), it
-			 * might make sense to keep the unique parts for JobID,
-			 * instead of just returning an error.  That means a
-			 * larger temp buffer for cfs_get_environ(), then
-			 * truncating the string at some separator to fit into
-			 * the specified jobid_len.  Fix later if needed. */
-			static bool printed;
-			if (unlikely(!printed)) {
-				LCONSOLE_ERROR_MSG(0x16b, "%s value too large "
-						   "for JobID buffer (%d)\n",
-						   obd_jobid_var, jobid_len);
-				printed = true;
-			}
-		} else {
-			CDEBUG((rc == -ENOENT || rc == -EINVAL ||
-				rc == -EDEADLK) ? D_INFO : D_ERROR,
-			       "Get jobid for (%s) failed: rc = %d\n",
-			       obd_jobid_var, rc);
-		}
+	/* Whole node dedicated to single job */
+	if (strcmp(obd_jobid_var, JOBSTATS_NODELOCAL) == 0) {
+		strcpy(jobid, obd_jobid_node);
+		return 0;
 	}
-	return rc;
+
+	return -ENOENT;
 }
 EXPORT_SYMBOL(lustre_get_jobid);
 
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 0334882..bdf2eed 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -292,6 +292,31 @@ static ssize_t obd_proc_jobid_var_seq_write(struct file *file, const char *buffe
 }
 LPROC_SEQ_FOPS(obd_proc_jobid_var);
 
+static int obd_proc_jobid_name_seq_show(struct seq_file *m, void *v)
+{
+	return seq_printf(m, "%s\n", obd_jobid_var);
+}
+
+static ssize_t obd_proc_jobid_name_seq_write(struct file *file,
+					     const char __user *buffer,
+					     size_t count, loff_t *off)
+{
+	if (!count || count > JOBSTATS_JOBID_SIZE)
+		return -EINVAL;
+
+	if (copy_from_user(obd_jobid_node, buffer, count))
+		return -EFAULT;
+
+	obd_jobid_node[count] = 0;
+
+	/* Trim the trailing '\n' if any */
+	if (obd_jobid_node[count - 1] == '\n')
+		obd_jobid_node[count - 1] = 0;
+
+	return count;
+}
+LPROC_SEQ_FOPS(obd_proc_jobid_name);
+
 /* Root for /proc/fs/lustre */
 struct proc_dir_entry *proc_lustre_root = NULL;
 EXPORT_SYMBOL(proc_lustre_root);
@@ -301,6 +326,8 @@ struct lprocfs_vars lprocfs_base[] = {
 	{ "pinger", &obd_proc_pinger_fops },
 	{ "health_check", &obd_proc_health_fops },
 	{ "jobid_var", &obd_proc_jobid_var_fops },
+	{ .name =	"jobid_name",
+	  .fops =	&obd_proc_jobid_name_fops},
 	{ 0 }
 };
 
-- 
1.9.0

