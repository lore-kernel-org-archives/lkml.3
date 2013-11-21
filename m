Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab3KUOdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 09:33:19 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:33671 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3KUOb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 09:31:58 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 06/10] staging/lustre/libcfs: remove flock wrappers
Date: Thu, 21 Nov 2013 22:28:27 +0800
Message-Id: <1385044111-3129-7-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
References: <1385044111-3129-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Andreas Dilger <andreas.dilger@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
---
 .../lustre/include/linux/libcfs/linux/linux-fs.h   |    9 ---------
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c    |   17 +++++++----------
 2 files changed, 7 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
index fdec53a..71e7594 100644
--- a/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
+++ b/drivers/staging/lustre/include/linux/libcfs/linux/linux-fs.h
@@ -52,13 +52,4 @@
 #include <linux/backing-dev.h>
 #include <linux/posix_acl_xattr.h>
 
-#define flock_type(fl)			((fl)->fl_type)
-#define flock_set_type(fl, type)	do { (fl)->fl_type = (type); } while (0)
-#define flock_pid(fl)			((fl)->fl_pid)
-#define flock_set_pid(fl, pid)		do { (fl)->fl_pid = (pid); } while (0)
-#define flock_start(fl)			((fl)->fl_start)
-#define flock_set_start(fl, st)		do { (fl)->fl_start = (st); } while (0)
-#define flock_end(fl)			((fl)->fl_end)
-#define flock_set_end(fl, end)		do { (fl)->fl_end = (end); } while (0)
-
 #endif
diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index 39fcdac..456d5aa 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -665,23 +665,20 @@ granted:
 		/* fcntl(F_GETLK) request */
 		/* The old mode was saved in getlk->fl_type so that if the mode
 		 * in the lock changes we can decref the appropriate refcount.*/
-		ldlm_flock_destroy(lock, flock_type(getlk),
-				   LDLM_FL_WAIT_NOREPROC);
+		ldlm_flock_destroy(lock, getlk->fl_type, LDLM_FL_WAIT_NOREPROC);
 		switch (lock->l_granted_mode) {
 		case LCK_PR:
-			flock_set_type(getlk, F_RDLCK);
+			getlk->fl_type = F_RDLCK;
 			break;
 		case LCK_PW:
-			flock_set_type(getlk, F_WRLCK);
+			getlk->fl_type = F_WRLCK;
 			break;
 		default:
-			flock_set_type(getlk, F_UNLCK);
+			getlk->fl_type = F_UNLCK;
 		}
-		flock_set_pid(getlk, (pid_t)lock->l_policy_data.l_flock.pid);
-		flock_set_start(getlk,
-				(loff_t)lock->l_policy_data.l_flock.start);
-		flock_set_end(getlk,
-			      (loff_t)lock->l_policy_data.l_flock.end);
+		getlk->fl_pid = (pid_t)lock->l_policy_data.l_flock.pid;
+		getlk->fl_start = (loff_t)lock->l_policy_data.l_flock.start;
+		getlk->fl_end = (loff_t)lock->l_policy_data.l_flock.end;
 	} else {
 		__u64 noreproc = LDLM_FL_WAIT_NOREPROC;
 
-- 
1.7.9.5

