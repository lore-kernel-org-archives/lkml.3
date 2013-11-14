Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab3KNQjk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:39:40 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46035 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab3KNQjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:39:01 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Bob Glossman <bob.glossman@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/39] staging/lustre/libcfs: improve validity test for valid file descriptors
Date: Fri, 15 Nov 2013 00:32:31 +0800
Message-Id: <1384446782-13741-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Glossman <bob.glossman@intel.com>

File descriptor members of struct lustre_kernelcomm aren't set to
anything special at start time.
This leads to incorrect tests and skipping valid fd closes at stop time.
Fixed by defining, setting, and testing against a specific LK_NOFD value.

Lustre-change: http://review.whamcloud.com/7275
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3683
Signed-off-by: Bob Glossman <bob.glossman@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 .../include/linux/libcfs/libcfs_kernelcomm.h       |    1 +
 .../lustre/lustre/libcfs/kernel_user_comm.c        |   10 ++++++++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h b/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h
index 596a15f..4e12ffc 100644
--- a/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h
+++ b/drivers/staging/lustre/include/linux/libcfs/libcfs_kernelcomm.h
@@ -97,6 +97,7 @@ extern int libcfs_kkuc_group_foreach(int group, libcfs_kkuc_cb_t cb_func,
 				     void *cb_arg);
 
 #define LK_FLG_STOP 0x01
+#define LK_NOFD -1U
 
 /* kernelcomm control structure, passed from userspace to kernel */
 typedef struct lustre_kernelcomm {
diff --git a/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c b/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c
index 74a0db5..9e5e3cc 100644
--- a/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c
+++ b/drivers/staging/lustre/lustre/libcfs/kernel_user_comm.c
@@ -56,6 +56,8 @@ int libcfs_ukuc_start(lustre_kernelcomm *link, int group)
 {
 	int pfd[2];
 
+	link->lk_rfd = link->lk_wfd = LK_NOFD;
+
 	if (pipe(pfd) < 0)
 		return -errno;
 
@@ -69,9 +71,13 @@ int libcfs_ukuc_start(lustre_kernelcomm *link, int group)
 
 int libcfs_ukuc_stop(lustre_kernelcomm *link)
 {
-	if (link->lk_wfd > 0)
+	int rc;
+
+	if (link->lk_wfd != LK_NOFD)
 		close(link->lk_wfd);
-	return close(link->lk_rfd);
+	rc = close(link->lk_rfd);
+	link->lk_rfd = link->lk_wfd = LK_NOFD;
+	return rc;
 }
 
 #define lhsz sizeof(*kuch)
-- 
1.7.9.5

