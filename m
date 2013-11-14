Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757786Ab3KNQuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:50:46 -0500
Received: from mail-pb0-f49.google.com ([209.85.160.49]:65520 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756960Ab3KNQnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:43:47 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Bruno Faccini <bruno.faccini@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 04/26] staging/lustre/ldlm: Fix a race during FLock handling
Date: Fri, 15 Nov 2013 00:42:51 +0800
Message-Id: <1384447393-13838-5-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
References: <1384447393-13838-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bruno Faccini <bruno.faccini@intel.com>

Protect against race where lock could have been just destroyed
due to overlap, in ldlm_process_flock_lock().
Easy reproducer is BULL's NFS Locktests in pthread mode.
(http://nfsv4.bullopensource.org/tools/tests/locktest.php)

Lustre-change: http://review.whamcloud.com/7134
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-1126
Signed-off-by: Bruno Faccini <bruno.faccini@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/ldlm/ldlm_flock.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
index d4598b6..37ebd2a 100644
--- a/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
+++ b/drivers/staging/lustre/lustre/ldlm/ldlm_flock.c
@@ -653,11 +653,6 @@ ldlm_flock_completion_ast(struct ldlm_lock *lock, __u64 flags, void *data)
 granted:
 	OBD_FAIL_TIMEOUT(OBD_FAIL_LDLM_CP_CB_WAIT, 10);
 
-	if (lock->l_flags & LDLM_FL_DESTROYED) {
-		LDLM_DEBUG(lock, "client-side enqueue waking up: destroyed");
-		return 0;
-	}
-
 	if (lock->l_flags & LDLM_FL_FAILED) {
 		LDLM_DEBUG(lock, "client-side enqueue waking up: failed");
 		return -EIO;
@@ -673,6 +668,16 @@ granted:
 
 	lock_res_and_lock(lock);
 
+
+	/* Protect against race where lock could have been just destroyed
+	 * due to overlap in ldlm_process_flock_lock().
+	 */
+	if (lock->l_flags & LDLM_FL_DESTROYED) {
+		unlock_res_and_lock(lock);
+		LDLM_DEBUG(lock, "client-side enqueue waking up: destroyed");
+		return 0;
+	}
+
 	/* take lock off the deadlock detection hash list. */
 	ldlm_flock_blocking_unlink(lock);
 
-- 
1.7.9.5

