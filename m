Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaIDNZf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 09:25:35 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:39690 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaIDNZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 09:25:33 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: clabbe.montjoie@gmail.com, gregkh@linuxfoundation.org, salymsash@gmail.com,
        lisa@xenapiadmin.com, email@christophjaeger.info, bergwolf@gmail.com,
        andreas.dilger@intel.com, oleg.drokin@intel.com,
        doug.s.oucharek@intel.com, vitaly.osipov@gmail.com, haasken@cray.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: Annotate user buffer with __user
Date: Thu,  4 Sep 2014 15:24:57 +0200
Message-Id: <1409837097-12048-1-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the warning reported by sparse on drivers/staging/lustre/lnet/lnet/router_proc.c
warning: incorrect type in argument 4 (different address spaces)
The correction is to annotate all user buffer variable by __user

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 .../staging/lustre/include/linux/libcfs/libcfs_debug.h  |  6 +++---
 drivers/staging/lustre/lnet/lnet/router_proc.c          | 13 +++++++------
 drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c | 17 +++++++++--------
 drivers/staging/lustre/lustre/libcfs/tracefile.c        | 12 ++++++------
 drivers/staging/lustre/lustre/libcfs/tracefile.h        | 10 +++++-----
 5 files changed, 30 insertions(+), 28 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
index 30098f3..aa9222c 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_debug.h
@@ -265,9 +265,9 @@ int libcfs_debug_vmsg2(struct libcfs_debug_msg_data *msgdata,
 
 /* other external symbols that tracefile provides: */
 int cfs_trace_copyin_string(char *knl_buffer, int knl_buffer_nob,
-				   const char *usr_buffer, int usr_buffer_nob);
-int cfs_trace_copyout_string(char *usr_buffer, int usr_buffer_nob,
-				    const char *knl_buffer, char *append);
+		const char __user *usr_buffer, int usr_buffer_nob);
+int cfs_trace_copyout_string(char __user *usr_buffer, int usr_buffer_nob,
+		const char *knl_buffer, char *append);
 
 #define LIBCFS_DEBUG_FILE_PATH_DEFAULT "/tmp/lustre-log"
 
diff --git a/drivers/staging/lustre/lnet/lnet/router_proc.c b/drivers/staging/lustre/lnet/lnet/router_proc.c
index 166c1e6..6e8f7e2 100644
--- a/drivers/staging/lustre/lnet/lnet/router_proc.c
+++ b/drivers/staging/lustre/lnet/lnet/router_proc.c
@@ -90,9 +90,10 @@ enum {
 
 #define LNET_PROC_VERSION(v)	((unsigned int)((v) & LNET_PROC_VER_MASK))
 
-static int proc_call_handler(void *data, int write, loff_t *ppos, void *buffer,
-			     size_t *lenp, int (*handler)(void *data, int write,
-			     loff_t pos, void *buffer, int len))
+static int proc_call_handler(void *data, int write, loff_t *ppos,
+		void __user *buffer, size_t *lenp,
+		int (*handler)(void *data, int write,
+		loff_t pos, void __user *buffer, int len))
 {
 	int rc = handler(data, write, *ppos, buffer, *lenp);
 
@@ -109,7 +110,7 @@ static int proc_call_handler(void *data, int write, loff_t *ppos, void *buffer,
 }
 
 static int __proc_lnet_stats(void *data, int write,
-			     loff_t pos, void *buffer, int nob)
+			     loff_t pos, void __user *buffer, int nob)
 {
 	int	      rc;
 	lnet_counters_t *ctrs;
@@ -592,7 +593,7 @@ int proc_lnet_peers(struct ctl_table *table, int write, void __user *buffer,
 }
 
 static int __proc_lnet_buffers(void *data, int write,
-			       loff_t pos, void *buffer, int nob)
+			       loff_t pos, void __user *buffer, int nob)
 {
 	char	    *s;
 	char	    *tmpstr;
@@ -815,7 +816,7 @@ static struct lnet_portal_rotors	portal_rotors[] = {
 extern int portal_rotor;
 
 static int __proc_lnet_portal_rotor(void *data, int write,
-				    loff_t pos, void *buffer, int nob)
+				    loff_t pos, void __user *buffer, int nob)
 {
 	const int	buf_len	= 128;
 	char		*buf;
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
index 13a9266..bbe2c68 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-proc.c
@@ -98,9 +98,10 @@ enum {
 	PSDEV_LNET_FAIL_VAL,      /* userdata for fail loc */
 };
 
-static int proc_call_handler(void *data, int write, loff_t *ppos, void *buffer,
-			     size_t *lenp, int (*handler)(void *data, int write,
-			     loff_t pos, void *buffer, int len))
+static int proc_call_handler(void *data, int write, loff_t *ppos,
+		void __user *buffer, size_t *lenp,
+		int (*handler)(void *data, int write,
+		loff_t pos, void __user *buffer, int len))
 {
 	int rc = handler(data, write, *ppos, buffer, *lenp);
 
@@ -117,7 +118,7 @@ static int proc_call_handler(void *data, int write, loff_t *ppos, void *buffer,
 }
 
 static int __proc_dobitmasks(void *data, int write,
-			     loff_t pos, void *buffer, int nob)
+			     loff_t pos, void __user *buffer, int nob)
 {
 	const int     tmpstrlen = 512;
 	char	 *tmpstr;
@@ -168,7 +169,7 @@ static int min_watchdog_ratelimit = 0;	  /* disable ratelimiting */
 static int max_watchdog_ratelimit = (24*60*60); /* limit to once per day */
 
 static int __proc_dump_kernel(void *data, int write,
-			      loff_t pos, void *buffer, int nob)
+			      loff_t pos, void __user *buffer, int nob)
 {
 	if (!write)
 		return 0;
@@ -184,7 +185,7 @@ static int proc_dump_kernel(struct ctl_table *table, int write,
 }
 
 static int __proc_daemon_file(void *data, int write,
-			      loff_t pos, void *buffer, int nob)
+			      loff_t pos, void __user *buffer, int nob)
 {
 	if (!write) {
 		int len = strlen(cfs_tracefile);
@@ -207,7 +208,7 @@ static int proc_daemon_file(struct ctl_table *table, int write,
 }
 
 static int __proc_debug_mb(void *data, int write,
-			   loff_t pos, void *buffer, int nob)
+			   loff_t pos, void __user *buffer, int nob)
 {
 	if (!write) {
 		char tmpstr[32];
@@ -344,7 +345,7 @@ int proc_fail_loc(struct ctl_table *table, int write, void __user *buffer,
 }
 
 static int __proc_cpt_table(void *data, int write,
-			    loff_t pos, void *buffer, int nob)
+			    loff_t pos, void __user *buffer, int nob)
 {
 	char *buf = NULL;
 	int   len = 4096;
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.c b/drivers/staging/lustre/lustre/libcfs/tracefile.c
index 0569bf8..7e3f6a4 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.c
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.c
@@ -755,7 +755,7 @@ void cfs_trace_flush_pages(void)
 }
 
 int cfs_trace_copyin_string(char *knl_buffer, int knl_buffer_nob,
-			    const char *usr_buffer, int usr_buffer_nob)
+			    const char __user *usr_buffer, int usr_buffer_nob)
 {
 	int    nob;
 
@@ -763,7 +763,7 @@ int cfs_trace_copyin_string(char *knl_buffer, int knl_buffer_nob,
 		return -EOVERFLOW;
 
 	if (copy_from_user((void *)knl_buffer,
-			   (void *)usr_buffer, usr_buffer_nob))
+			   usr_buffer, usr_buffer_nob))
 		return -EFAULT;
 
 	nob = strnlen(knl_buffer, usr_buffer_nob);
@@ -782,7 +782,7 @@ int cfs_trace_copyin_string(char *knl_buffer, int knl_buffer_nob,
 }
 EXPORT_SYMBOL(cfs_trace_copyin_string);
 
-int cfs_trace_copyout_string(char *usr_buffer, int usr_buffer_nob,
+int cfs_trace_copyout_string(char __user *usr_buffer, int usr_buffer_nob,
 			     const char *knl_buffer, char *append)
 {
 	/* NB if 'append' != NULL, it's a single character to append to the
@@ -824,7 +824,7 @@ void cfs_trace_free_string_buffer(char *str, int nob)
 	kfree(str);
 }
 
-int cfs_trace_dump_debug_buffer_usrstr(void *usr_str, int usr_str_nob)
+int cfs_trace_dump_debug_buffer_usrstr(void __user *usr_str, int usr_str_nob)
 {
 	char	 *str;
 	int	   rc;
@@ -886,7 +886,7 @@ int cfs_trace_daemon_command(char *str)
 	return rc;
 }
 
-int cfs_trace_daemon_command_usrstr(void *usr_str, int usr_str_nob)
+int cfs_trace_daemon_command_usrstr(void __user *usr_str, int usr_str_nob)
 {
 	char *str;
 	int   rc;
@@ -939,7 +939,7 @@ int cfs_trace_set_debug_mb(int mb)
 	return 0;
 }
 
-int cfs_trace_set_debug_mb_usrstr(void *usr_str, int usr_str_nob)
+int cfs_trace_set_debug_mb_usrstr(void __user *usr_str, int usr_str_nob)
 {
 	char     str[32];
 	int      rc;
diff --git a/drivers/staging/lustre/lustre/libcfs/tracefile.h b/drivers/staging/lustre/lustre/libcfs/tracefile.h
index 8df4af3..0601476 100644
--- a/drivers/staging/lustre/lustre/libcfs/tracefile.h
+++ b/drivers/staging/lustre/lustre/libcfs/tracefile.h
@@ -68,16 +68,16 @@ void cfs_tracefile_exit(void);
 
 
 int cfs_trace_copyin_string(char *knl_buffer, int knl_buffer_nob,
-			    const char *usr_buffer, int usr_buffer_nob);
-int cfs_trace_copyout_string(char *usr_buffer, int usr_buffer_nob,
+			    const char __user *usr_buffer, int usr_buffer_nob);
+int cfs_trace_copyout_string(char __user *usr_buffer, int usr_buffer_nob,
 			     const char *knl_str, char *append);
 int cfs_trace_allocate_string_buffer(char **str, int nob);
 void cfs_trace_free_string_buffer(char *str, int nob);
-int cfs_trace_dump_debug_buffer_usrstr(void *usr_str, int usr_str_nob);
+int cfs_trace_dump_debug_buffer_usrstr(void __user *usr_str, int usr_str_nob);
 int cfs_trace_daemon_command(char *str);
-int cfs_trace_daemon_command_usrstr(void *usr_str, int usr_str_nob);
+int cfs_trace_daemon_command_usrstr(void __user *usr_str, int usr_str_nob);
 int cfs_trace_set_debug_mb(int mb);
-int cfs_trace_set_debug_mb_usrstr(void *usr_str, int usr_str_nob);
+int cfs_trace_set_debug_mb_usrstr(void __user *usr_str, int usr_str_nob);
 int cfs_trace_get_debug_mb(void);
 
 extern void libcfs_debug_dumplog_internal(void *arg);
-- 
1.8.5.5

