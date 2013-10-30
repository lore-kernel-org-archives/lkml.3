Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3J3La6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 07:30:58 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:37604 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab3J3Lay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 07:30:54 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 2/4] staging/lustre/obdclass: read jobid from proc
Date: Wed, 30 Oct 2013 19:30:34 +0800
Message-Id: <1383132636-8952-2-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so that we can get rid of cfs_get_environ() that needs access_process_vm() that
is a core mm function and is not available on some architectures.

Reviewed-by: Niu Yawei <yawei.niu@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  119 +++++++++++++++++++-
 1 file changed, 115 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index b1024a6..99ce863 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -96,8 +96,117 @@ EXPORT_SYMBOL(obd_dirty_transit_pages);
 char obd_jobid_var[JOBSTATS_JOBID_VAR_MAX_LEN + 1] = JOBSTATS_DISABLE;
 EXPORT_SYMBOL(obd_jobid_var);
 
-/* Get jobid of current process by reading the environment variable
- * stored in between the "env_start" & "env_end" of task struct.
+static char *self_environ_file = "/proc/self/environ";
+static int obd_get_environ(const char *key, char *value, int *val_len)
+{
+	struct mm_struct *mm;
+	struct path path;
+	struct file *filp = NULL;
+	int buf_len = PAGE_CACHE_SIZE;
+	int key_len = strlen(key);
+	char *buffer = NULL;
+	loff_t pos = 0;
+	int rc;
+
+	/*
+	 * test mm->mmap_sem to avoid deadlock if this ever gets called from
+	 * mmap code.
+	 */
+	mm = get_task_mm(current);
+	if (!mm)
+		return -EINVAL;
+	if (down_read_trylock(&mm->mmap_sem) == 0) {
+		mmput(mm);
+		return -EDEADLK;
+	}
+	up_read(&mm->mmap_sem);
+	mmput(mm);
+
+	buffer = kmalloc(buf_len, GFP_NOIO);
+	if (!buffer)
+		return -ENOMEM;
+
+	rc = kern_path(self_environ_file, LOOKUP_FOLLOW, &path);
+	if (rc)
+		goto out;
+
+	filp = dentry_open(&path, O_RDONLY, current_cred());
+	if (IS_ERR(filp)) {
+		rc = PTR_ERR(filp);
+		filp = NULL;
+		goto out;
+	}
+
+	/* loop reading... */
+	while (1) {
+		int scan_len, this_len;
+		char *env_start, *env_end;
+		rc = kernel_read(filp, pos, buffer, buf_len);
+		if (rc <= 0)
+			break;
+
+		pos += rc;
+		/* Parse the buffer to find out the specified key/value pair.
+		 * The "key=value" entries are separated by '\0'. */
+		env_start = buffer;
+		scan_len = this_len = rc;
+		while (scan_len) {
+			char *entry;
+			int entry_len;
+
+			env_end = memscan(env_start, '\0', scan_len);
+			LASSERT(env_end >= env_start &&
+				env_end <= env_start + scan_len);
+
+			/* The last entry of this buffer cross the buffer
+			 * boundary, reread it in next cycle. */
+			if (unlikely(env_end - env_start == scan_len)) {
+				/* This entry is too large to fit in buffer */
+				if (unlikely(scan_len == this_len)) {
+					rc = -EINVAL;
+					CWARN("Environment variable '%s' too long: rc = %d\n",
+					      key, rc);
+					goto out;
+				}
+				pos -= scan_len;
+				break;
+			}
+
+			entry = env_start;
+			entry_len = env_end - env_start;
+
+			/* Key length + length of '=' */
+			if (entry_len > key_len + 1 &&
+			    !memcmp(entry, key, key_len)) {
+				entry += key_len + 1;
+				entry_len -= key_len + 1;
+				/* The 'value' buffer passed in is too small.*/
+				if (entry_len >= *val_len)
+					GOTO(out, rc = -EOVERFLOW);
+
+				memcpy(value, entry, entry_len);
+				*val_len = entry_len;
+				rc = 0;
+				goto out;
+			}
+
+			scan_len -= (env_end - env_start + 1);
+			env_start = env_end + 1;
+		}
+	}
+	if (rc >= 0)
+		rc = -ENOENT;
+out:
+	if (filp)
+		fput(filp);
+	if (buffer)
+		kfree(buffer);
+	return rc;
+}
+
+/*
+ * Get jobid of current process by reading the environment variable
+ * from /proc/self/environ.
  *
  * TODO:
  * It's better to cache the jobid for later use if there is any
@@ -126,14 +235,14 @@ int lustre_get_jobid(char *jobid)
 		return 0;
 	}
 
-	rc = cfs_get_environ(obd_jobid_var, jobid, &jobid_len);
+	rc = obd_get_environ(obd_jobid_var, jobid, &jobid_len);
 	if (rc) {
 		if (rc == -EOVERFLOW) {
 			/* For the PBS_JOBID and LOADL_STEP_ID keys (which are
 			 * variable length strings instead of just numbers), it
 			 * might make sense to keep the unique parts for JobID,
 			 * instead of just returning an error.  That means a
-			 * larger temp buffer for cfs_get_environ(), then
+			 * larger temp buffer for obd_get_environ(), then
 			 * truncating the string at some separator to fit into
 			 * the specified jobid_len.  Fix later if needed. */
 			static bool printed;
@@ -149,6 +258,8 @@ int lustre_get_jobid(char *jobid)
 			       "Get jobid for (%s) failed: rc = %d\n",
 			       obd_jobid_var, rc);
 		}
+	} else {
+		CDEBUG(D_INFO, "Got jobid for (%s) value (%s)\n", obd_jobid_var, jobid);
 	}
 	return rc;
 }
-- 
1.7.9.5

