Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755156Ab3KNQQC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:16:02 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:62377 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755018Ab3KNQPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:15:22 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, James Simmons <uja.ornl@gmail.com>,
        Jeff Mahoney <jeffm@suse.com>, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 14/40] staging/lustre/autoconf: remove LIBCFS_HAVE_IS_COMPAT_TASK test
Date: Fri, 15 Nov 2013 00:13:16 +0800
Message-Id: <1384445622-12346-15-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Simmons <uja.ornl@gmail.com>

is_compat_task has been defined on all arches since v2.6.29.
We can remove the test and dead code.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2800
Lustre-change: http://review.whamcloud.com/5393
Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: James Simmons <uja.ornl@gmail.com>
Reviewed-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../staging/lustre/include/linux/libcfs/curproc.h  |    1 -
 .../lustre/lustre/libcfs/linux/linux-curproc.c     |   13 -------------
 .../staging/lustre/lustre/llite/llite_internal.h   |    3 ++-
 3 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/curproc.h b/drivers/staging/lustre/include/linux/libcfs/curproc.h
index de8e35b..507d16b 100644
--- a/drivers/staging/lustre/include/linux/libcfs/curproc.h
+++ b/drivers/staging/lustre/include/linux/libcfs/curproc.h
@@ -61,7 +61,6 @@ int    cfs_curproc_groups_nr(void);
  */
 
 /* check if task is running in compat mode.*/
-int current_is_32bit(void);
 #define current_pid()		(current->pid)
 #define current_comm()		(current->comm)
 int cfs_get_environ(const char *key, char *value, int *val_len);
diff --git a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
index 0bf8e5d..a2ef64c 100644
--- a/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
+++ b/drivers/staging/lustre/lustre/libcfs/linux/linux-curproc.c
@@ -140,18 +140,6 @@ int cfs_capable(cfs_cap_t cap)
 	return capable(cfs_cap_unpack(cap));
 }
 
-/* Check if task is running in 32-bit API mode, for the purpose of
- * userspace binary interfaces.  On 32-bit Linux this is (unfortunately)
- * always true, even if the application is using LARGEFILE64 and 64-bit
- * APIs, because Linux provides no way for the filesystem to know if it
- * is called via 32-bit or 64-bit APIs.  Other clients may vary.  On
- * 64-bit systems, this will only be true if the binary is calling a
- * 32-bit system call. */
-int current_is_32bit(void)
-{
-	return is_compat_task();
-}
-
 static int cfs_access_process_vm(struct task_struct *tsk, unsigned long addr,
 				 void *buf, int len, int write)
 {
@@ -311,7 +299,6 @@ EXPORT_SYMBOL(cfs_cap_raised);
 EXPORT_SYMBOL(cfs_curproc_cap_pack);
 EXPORT_SYMBOL(cfs_curproc_cap_unpack);
 EXPORT_SYMBOL(cfs_capable);
-EXPORT_SYMBOL(current_is_32bit);
 
 /*
  * Local variables:
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 2debb24..e800f8d 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -46,6 +46,7 @@
 #include <lclient.h>
 #include <lustre_mdc.h>
 #include <linux/lustre_intent.h>
+#include <linux/compat.h>
 
 #ifndef FMODE_EXEC
 #define FMODE_EXEC 0
@@ -649,7 +650,7 @@ static inline int ll_need_32bit_api(struct ll_sb_info *sbi)
 #if BITS_PER_LONG == 32
 	return 1;
 #else
-	return unlikely(current_is_32bit() || (sbi->ll_flags & LL_SBI_32BIT_API));
+	return unlikely(is_compat_task() || (sbi->ll_flags & LL_SBI_32BIT_API));
 #endif
 }
 
-- 
1.7.9.5

