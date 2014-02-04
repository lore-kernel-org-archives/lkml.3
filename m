Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859AbaBDGdt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 01:33:49 -0500
Received: from linuxhacker.ru ([217.76.32.60]:44079 "EHLO fiona.linuxhacker.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaBDGdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 01:33:39 -0500
X-Greylist: delayed 1278 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Feb 2014 01:33:38 EST
Date: Tue, 4 Feb 2014 10:12:10 +0400
From: Oleg Drokin <green@linuxhacker.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Peng Tao <bergwolf@gmail.com>, linux-kernel@vger.kernel.org,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 2/4] staging/lustre/obdclass: read jobid from proc
Message-ID: <20140204061210.GA944142@fiona.linuxhacker.ru>
References: <1383132636-8952-1-git-send-email-bergwolf@gmail.com>
 <1383132636-8952-2-git-send-email-bergwolf@gmail.com>
 <20131030132101.GD30087@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030132101.GD30087@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

On Wed, Oct 30, 2013 at 06:21:01AM -0700, Greg Kroah-Hartman wrote:
> > - * stored in between the "env_start" & "env_end" of task struct.
> > +static char *self_environ_file = "/proc/self/environ";
> 
> Heh, no, that's not ok at all.
> 
> This is a _huge_ sign that you are doing something wrong in your driver
> if you need something that isn't exported, or that you have to dig out
> of proc.
> 
> Sorry, I can't take this, please fix the underlying problems that would
> even think that you need access to the environment from within a kernel
> driver.

I took a stab at this.
This is not a final patch, I know there's still some number of checkpatch
warnings and the proc layout is not finalized yet for example.

But before I spend any more time in polishing this, can you please take a look
and advise if this direction would be acceptable for you when driven to
completion?

Thanks.


>From 6a5b58657cc32163738d4a8c210e8683159b582f Mon Sep 17 00:00:00 2001
From: Oleg Drokin <green@linuxhacker.ru>
Date: Tue, 4 Feb 2014 00:32:12 -0500
Subject: [PATCH] staging/lustre: Obtain jobid invormation via upcall

Replace lustre jobid information fetching directly from
process env variable with either node-wide jobid obtained via
a proc file, or through an upcall that would provide the jobid
if more fine-grained operations are necessary.

Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>
---
 .../staging/lustre/include/linux/libcfs/curproc.h  |   1 -
 .../staging/lustre/include/linux/libcfs/lucache.h  |   6 +
 .../staging/lustre/lustre/include/lprocfs_status.h |   1 +
 .../lustre/lustre/libcfs/linux/linux-curproc.c     | 152 -----------------
 drivers/staging/lustre/lustre/obdclass/Makefile    |   2 +-
 drivers/staging/lustre/lustre/obdclass/class_obd.c |  67 ++++----
 .../staging/lustre/lustre/obdclass/jobid_cache.c   | 181 +++++++++++++++++++++
 .../lustre/lustre/obdclass/jobid_internal.h        |  10 ++
 .../lustre/lustre/obdclass/linux/linux-module.c    | 114 +++++++++++++
 9 files changed, 345 insertions(+), 189 deletions(-)
 create mode 100644 drivers/staging/lustre/lustre/obdclass/jobid_cache.c
 create mode 100644 drivers/staging/lustre/lustre/obdclass/jobid_internal.h

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index 507d16b..cf1f26b 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -63,7 +63,6 @@ int    cfs_curproc_groups_nr(void);
 /* check if task is running in compat mode.*/
 #define current_pid()		(current->pid)
 #define current_comm()		(current->comm)
-int cfs_get_environ(const char *key, char *value, int *val_len);
 
 typedef __u32 cfs_cap_t;
 
diff --git a/drivers/staging/lustre/include/linux/libcfs/lucache.h b/drivers/staging/lustre/include/linux/libcfs/lucache.h
index 9668b39..f8361d7 100644
--- a/drivers/staging/lustre/include/linux/libcfs/lucache.h
+++ b/drivers/staging/lustre/include/linux/libcfs/lucache.h
@@ -82,6 +82,11 @@ struct md_identity {
 	struct md_perm	    *mi_perms;
 };
 
+struct jobid_cache_entry {
+	struct upcall_cache_entry *jce_uc_entry;
+	char			  *jce_jobid;
+};
+
 struct upcall_cache_entry {
 	struct list_head	      ue_hash;
 	__u64		   ue_key;
@@ -92,6 +97,7 @@ struct upcall_cache_entry {
 	cfs_time_t	      ue_expire;
 	union {
 		struct md_identity     identity;
+		struct jobid_cache_entry jobid;
 	} u;
 };
 
diff --git a/drivers/staging/lustre/lustre/include/lprocfs_status.h b/drivers/staging/lustre/lustre/include/lprocfs_status.h
index 428e3e4..3c99dcf 100644
--- a/drivers/staging/lustre/lustre/include/lprocfs_status.h
+++ b/drivers/staging/lustre/lustre/include/lprocfs_status.h
@@ -369,6 +369,7 @@ static inline void s2dhms(struct dhms *ts, time_t secs)
 #define JOBSTATS_JOBID_VAR_MAX_LEN	20
 #define JOBSTATS_DISABLE		"disable"
 #define JOBSTATS_PROCNAME_UID		"procname_uid"
+#define JOBSTATS_NODELOCAL		"nodelocal"
 
 extern int lprocfs_write_frac_helper(const char *buffer, unsigned long count,
 				     int *val, int mult);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index a2ef64c..7c48601 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -140,158 +140,6 @@ int cfs_capable(cfs_cap_t cap)
 	return capable(cfs_cap_unpack(cap));
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
 EXPORT_SYMBOL(cfs_curproc_groups_nr);
 EXPORT_SYMBOL(cfs_cap_raise);
 EXPORT_SYMBOL(cfs_cap_lower);
diff --git a/drivers/staging/lustre/lustre/obdclass/Makefile b/drivers/staging/lustre/lustre/obdclass/Makefile
index 8a0e08c..7949838 100644
--- a/drivers/staging/lustre/lustre/obdclass/Makefile
+++ b/drivers/staging/lustre/lustre/obdclass/Makefile
@@ -7,7 +7,7 @@ obdclass-y := linux/linux-module.o linux/linux-obdo.o linux/linux-sysctl.o \
 	      local_storage.o statfs_pack.o obdo.o obd_config.o obd_mount.o\
 	      mea.o lu_object.o dt_object.o capa.o cl_object.o   \
 	      cl_page.o cl_lock.o cl_io.o lu_ref.o acl.o idmap.o	   \
-	      lu_ucred.o
+	      lu_ucred.o jobid_cache.o
 
 
 ccflags-y := -I$(src)/../include
diff --git a/drivers/staging/lustre/lustre/obdclass/class_obd.c b/drivers/staging/lustre/lustre/obdclass/class_obd.c
index c93131e..e4fdd73 100644
--- a/drivers/staging/lustre/lustre/obdclass/class_obd.c
+++ b/drivers/staging/lustre/lustre/obdclass/class_obd.c
@@ -45,7 +45,9 @@
 #include <lustre/lustre_build_version.h>
 #include <linux/list.h>
 #include <cl_object.h>
+#include <linux/libcfs/lucache.h>
 #include "llog_internal.h"
+#include "jobid_internal.h"
 
 
 struct obd_device *obd_devs[MAX_OBD_DEVICES];
@@ -102,22 +104,18 @@ EXPORT_SYMBOL(obd_dirty_transit_pages);
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
+/* Get jobid of current process from stored variable or from upcall.
+ * jobid obtained from upcall would be cached in upcall cache.
  *
- * If some job scheduler doesn't store jobid in the "env_start/end",
- * then an upcall could be issued here to get the jobid by utilizing
- * the userspace tools/api. Then, the jobid must be cached.
+ * Historically this was also done by reading the environment variable
+ * stored in between the "env_start" & "env_end" of task struct.
+ * This is now deprecated and slated for removal at a later date, though.
  */
 int lustre_get_jobid(char *jobid)
 {
 	int jobid_len = JOBSTATS_JOBID_SIZE;
-	int rc = 0;
 
 	memset(jobid, 0, JOBSTATS_JOBID_SIZE);
 	/* Jobstats isn't enabled */
@@ -132,31 +130,27 @@ int lustre_get_jobid(char *jobid)
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
+	/* If there's an upcall defined, let's try that */
+	if (obd_jobid_upcall != NULL) {
+		struct jobid_cache_entry *entry;
+
+		entry = jobid_cache_get(current_pid());
+
+		if (IS_ERR(entry))
+			return PTR_ERR(entry);
+
+		strncpy(jobid, entry->jce_jobid, JOBSTATS_JOBID_SIZE);
+		jobid_cache_put(entry);
+		return 0;
+	}
+
+	return -ENOENT;
 }
 EXPORT_SYMBOL(lustre_get_jobid);
 
@@ -674,6 +668,9 @@ static void cleanup_obdclass(void)
 
 	class_procfs_clean();
 
+	if (obd_jobid_upcall)
+		upcall_cache_cleanup(obd_jobid_upcall);
+
 	class_handle_cleanup();
 	class_exit_uuidlist();
 	obd_zombie_impexp_stop();
diff --git a/drivers/staging/lustre/lustre/obdclass/jobid_cache.c b/drivers/staging/lustre/lustre/obdclass/jobid_cache.c
new file mode 100644
index 0000000..4c99ff0
--- /dev/null
+++ b/drivers/staging/lustre/lustre/obdclass/jobid_cache.c
@@ -0,0 +1,181 @@
+/*
+ * GPL HEADER START
+ *
+ * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 only,
+ * as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License version 2 for more details (a copy is included
+ * in the LICENSE file that accompanied this code).
+ *
+ * You should have received a copy of the GNU General Public License
+ * version 2 along with this program; If not, see
+ * http://www.gnu.org/licenses/gpl-2.0.html
+ *
+ * Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara,
+ * CA 95054 USA or visit www.sun.com if you need additional information or
+ * have any questions.
+ *
+ * GPL HEADER END
+ */
+/*
+ * Copyright (c) 2007, 2010, Oracle and/or its affiliates. All rights reserved.
+ * Use is subject to license terms.
+ *
+ * Copyright (c) 2011, 2013, Intel Corporation.
+ */
+/*
+ * lustre/obdclass/jobid_cache.c
+ *
+ * Author: Lai Siyao <lsy@clusterfs.com>
+ * Author: Fan Yong <fanyong@clusterfs.com>
+ * Author: Oleg Drokin <oleg.drokin@intel.com>
+ */
+
+#define DEBUG_SUBSYSTEM S_CLASS
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/mm.h>
+#include <linux/string.h>
+#include <linux/errno.h>
+#include <linux/version.h>
+#include <linux/uaccess.h>
+#include <linux/slab.h>
+
+#include <linux/libcfs/libcfs.h>
+#include <linux/libcfs/lucache.h>
+#include <obd.h>
+#include <obd_class.h>
+#include <obd_support.h>
+#include <lustre_lib.h>
+
+#include "jobid_internal.h"
+
+struct upcall_cache *obd_jobid_upcall;
+
+static void jobid_cache_entry_init(struct upcall_cache_entry *entry,
+				    void *unused)
+{
+	entry->u.jobid.jce_uc_entry = entry;
+}
+
+static void jobid_cache_entry_free(struct upcall_cache *cache,
+				   struct upcall_cache_entry *entry)
+{
+	if (entry->u.jobid.jce_jobid)
+		OBD_FREE(entry->u.jobid.jce_jobid, JOBSTATS_JOBID_SIZE);
+}
+
+static int jobid_cache_do_upcall(struct upcall_cache *cache,
+				 struct upcall_cache_entry *entry)
+{
+	char keystr[32];
+	char *argv[] = {
+		[0] = cache->uc_upcall,
+		[1] = cache->uc_name,
+		[2] = keystr,
+		[3] = NULL
+	};
+	char *envp[] = {
+		[0] = "HOME=/",
+		[1] = "PATH=/sbin:/usr/sbin",
+		[2] = NULL
+	};
+	struct timeval start, end;
+	int rc;
+
+	read_lock(&cache->uc_upcall_rwlock);
+	CDEBUG(D_INFO, "The upcall is: '%s'\n", cache->uc_upcall);
+
+	if (unlikely(!strcmp(cache->uc_upcall, "/NONE")))
+		GOTO(out, rc = -ENOENT);
+
+	argv[0] = cache->uc_upcall;
+	snprintf(keystr, sizeof(keystr), LPU64, entry->ue_key);
+
+	do_gettimeofday(&start);
+	rc = call_usermodehelper(argv[0], argv, envp, 1);
+	do_gettimeofday(&end);
+	if (rc < 0) {
+		CERROR("%s: error invoking upcall %s %s %s: rc %d; "
+		       "check /proc/fs/lustre/jobid_upcall, "
+		       "time %ldus\n",
+		       cache->uc_name, argv[0], argv[1], argv[2], rc,
+		       cfs_timeval_sub(&end, &start, NULL));
+	} else {
+		CDEBUG(D_CACHE, "%s: invoked upcall %s %s %s, time %ldus\n",
+		       cache->uc_name, argv[0], argv[1], argv[2],
+		       cfs_timeval_sub(&end, &start, NULL));
+		rc = 0;
+	}
+out:
+	read_unlock(&cache->uc_upcall_rwlock);
+	return rc;
+}
+
+static int jobid_cache_parse_downcall(struct upcall_cache *cache,
+				       struct upcall_cache_entry *entry,
+				       void *args)
+{
+	struct jobid_cache_entry *jobid = &entry->u.jobid;
+	char *val = args;
+
+	if (jobid == NULL)
+		return -ENOENT;
+
+	if (jobid->jce_jobid == NULL)
+		OBD_ALLOC(jobid->jce_jobid, JOBSTATS_JOBID_SIZE);
+
+	strncpy(jobid->jce_jobid, val, JOBSTATS_JOBID_SIZE);
+
+	return 0;
+}
+
+struct jobid_cache_entry *jobid_cache_get(__u64 pid)
+{
+	struct upcall_cache_entry *entry;
+
+	if (!obd_jobid_upcall)
+		return ERR_PTR(-ENOENT);
+
+	entry = upcall_cache_get_entry(obd_jobid_upcall, pid, NULL);
+	if (IS_ERR(entry))
+		return ERR_PTR(PTR_ERR(entry));
+	else if (unlikely(!entry))
+		return ERR_PTR(-ENOENT);
+	else
+		return &entry->u.jobid;
+}
+
+void jobid_cache_put(struct jobid_cache_entry *jobid)
+{
+	if (!obd_jobid_upcall)
+		return;
+
+	LASSERT(jobid);
+	upcall_cache_put_entry(obd_jobid_upcall, jobid->jce_uc_entry);
+}
+
+struct upcall_cache_ops jobid_cache_upcall_cache_ops = {
+	.init_entry     = jobid_cache_entry_init,
+	.free_entry     = jobid_cache_entry_free,
+	.do_upcall      = jobid_cache_do_upcall,
+	.parse_downcall = jobid_cache_parse_downcall,
+};
+
+void jobid_flush_cache(__u64 pid)
+{
+	if (!obd_jobid_upcall)
+		return;
+
+	if (pid < 0)
+		upcall_cache_flush_idle(obd_jobid_upcall);
+	else
+		upcall_cache_flush_one(obd_jobid_upcall, pid, NULL);
+}
diff --git a/drivers/staging/lustre/lustre/obdclass/jobid_internal.h b/drivers/staging/lustre/lustre/obdclass/jobid_internal.h
new file mode 100644
index 0000000..56db606
--- /dev/null
+++ b/drivers/staging/lustre/lustre/obdclass/jobid_internal.h
@@ -0,0 +1,10 @@
+#include <linux/libcfs/lucache.h>
+
+extern struct upcall_cache_ops jobid_cache_upcall_cache_ops;
+extern char obd_jobid_node[];
+extern struct upcall_cache *obd_jobid_upcall;
+
+struct jobid_cache_entry *jobid_cache_get(__u64 pid);
+void jobid_cache_put(struct jobid_cache_entry *jobid);
+void jobid_flush_cache(__u64 pid);
+
diff --git a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
index 121a856..3acdbbc 100644
--- a/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
+++ b/drivers/staging/lustre/lustre/obdclass/linux/linux-module.c
@@ -66,12 +66,14 @@
 #include <linux/seq_file.h>
 
 #include <linux/libcfs/libcfs.h>
+#include <linux/libcfs/lucache.h>
 #include <obd_support.h>
 #include <obd_class.h>
 #include <linux/lnet/lnetctl.h>
 #include <lprocfs_status.h>
 #include <lustre_ver.h>
 #include <lustre/lustre_build_version.h>
+#include "../jobid_internal.h"
 
 int proc_version;
 
@@ -283,6 +285,114 @@ static ssize_t obd_proc_jobid_var_seq_write(struct file *file, const char *buffe
 }
 LPROC_SEQ_FOPS(obd_proc_jobid_var);
 
+static int obd_proc_jobid_upcall_seq_show(struct seq_file *m, void *v)
+{
+
+	return seq_printf(m, "%s\n",
+			  obd_jobid_upcall?obd_jobid_upcall->uc_upcall:"NONE");
+}
+
+static ssize_t
+obd_proc_jobid_upcall_seq_write(struct file *file, const char *buffer,
+				size_t count, loff_t *off)
+{
+	char *kernbuf;
+	int rc = 0;
+
+	if (!count || count >= UC_CACHE_UPCALL_MAXPATH)
+		return -EINVAL;
+
+	OBD_ALLOC(kernbuf, count + 1);
+
+	if (copy_from_user(kernbuf, buffer, count)) {
+		rc = -EFAULT;
+		goto out;
+	}
+
+	if (count > 10 && strcmp(kernbuf, "downcall: ") == 0) {
+		__u64 pid;
+		char *end;
+
+		if (obd_jobid_upcall == NULL) {
+			rc = -EINVAL;
+			goto out;
+		}
+
+		kernbuf += 10;
+
+		pid = simple_strtoul(kernbuf, &end, 10);
+
+		if (kernbuf == end) {
+			rc = -EINVAL;
+		} else {
+			end++;
+			if (strcmp(end, "NONE") == 0)
+				rc = -ENOENT;
+			rc = upcall_cache_downcall(obd_jobid_upcall, rc, pid,
+						   end);
+		}
+		goto out;
+
+	} else if (count >= 5 && strcmp(kernbuf, "flush") == 0) {
+		jobid_flush_cache(-1);
+		goto out;
+	}
+
+	/* Somebody must be trying to setup an upcall */
+	if (kernbuf[0] != '/') {
+		/* Not an absolute pathname? Ignore. */
+		rc = -EINVAL;
+		goto out;
+	}
+
+	/* If there's no cache yet, need to create it */
+	if (obd_jobid_upcall == NULL) {
+		obd_jobid_upcall = upcall_cache_init("jobid", "",
+						 &jobid_cache_upcall_cache_ops);
+		if (IS_ERR(obd_jobid_upcall)) {
+			rc = PTR_ERR(obd_jobid_upcall);
+			obd_jobid_upcall = NULL;
+
+			goto out;
+		}
+	}
+
+	/* Remove any extraneous bits from the upcall (e.g. linefeeds) */
+	write_lock(&obd_jobid_upcall->uc_upcall_rwlock);
+	sscanf(kernbuf, "%s", obd_jobid_upcall->uc_upcall);
+	write_unlock(&obd_jobid_upcall->uc_upcall_rwlock);
+
+out:
+	OBD_FREE(kernbuf, count + 1);
+	return rc?rc:count;
+}
+LPROC_SEQ_FOPS(obd_proc_jobid_upcall);
+
+static int obd_proc_jobid_name_seq_show(struct seq_file *m, void *v)
+{
+	return seq_printf(m, "%s\n", obd_jobid_var);
+}
+
+static ssize_t
+obd_proc_jobid_name_seq_write(struct file *file, const char *buffer,
+				size_t count, loff_t *off)
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
@@ -292,6 +402,10 @@ struct lprocfs_vars lprocfs_base[] = {
 	{ "pinger", &obd_proc_pinger_fops },
 	{ "health_check", &obd_proc_health_fops },
 	{ "jobid_var", &obd_proc_jobid_var_fops },
+	{ .name =	"jobid_upcall",
+	  .fops =	&obd_proc_jobid_upcall_fops},
+	{ .name =	"jobid_name",
+	  .fops =	&obd_proc_jobid_name_fops},
 	{ 0 }
 };
 
-- 
1.8.5.3

