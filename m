Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3GVQNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:13:37 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:44952 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933111Ab3GVQN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:13:29 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 44/48] staging/lustre/build: fix 'data race condition' issues
Date: Tue, 23 Jul 2013 00:07:05 +0800
Message-Id: <1374509230-3324-45-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'data race condition' defects found by Coverity version
6.5.0:
Data race condition (MISSING_LOCK)
Accessing variable without holding lock. Elsewhere,
this variable is accessed with lock held.

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-2744
Lustre-change: http://review.whamcloud.com/6571
Signed-off-by: Sebastien Buisson <sebastien.buisson@bull.net>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Keith Mannthey <keith.mannthey@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/llite_lib.c |    4 ++++
 drivers/staging/lustre/lustre/llite/namei.c     |    5 ++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index d7d87b1..36a07fa 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1190,7 +1190,9 @@ void ll_clear_inode(struct inode *inode)
 		LASSERT(lli->lli_opendir_pid == 0);
 	}
 
+	spin_lock(&lli->lli_lock);
 	ll_i2info(inode)->lli_flags &= ~LLIF_MDS_SIZE_LOCK;
+	spin_unlock(&lli->lli_lock);
 	md_null_inode(sbi->ll_md_exp, ll_inode2fid(inode));
 
 	LASSERT(!lli->lli_open_fd_write_count);
@@ -1757,7 +1759,9 @@ void ll_update_inode(struct inode *inode, struct lustre_md *md)
 					/* Use old size assignment to avoid
 					 * deadlock bz14138 & bz14326 */
 					i_size_write(inode, body->size);
+					spin_lock(&lli->lli_lock);
 					lli->lli_flags |= LLIF_MDS_SIZE_LOCK;
+					spin_unlock(&lli->lli_lock);
 				}
 				ldlm_lock_decref(&lockh, mode);
 			}
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 8e948a7..333e55f 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -275,8 +275,11 @@ int ll_md_blocking_ast(struct ldlm_lock *lock, struct ldlm_lock_desc *desc,
 				CDEBUG(D_INODE, "invaliding layout %d.\n", rc);
 		}
 
-		if (bits & MDS_INODELOCK_UPDATE)
+		if (bits & MDS_INODELOCK_UPDATE) {
+			spin_lock(&lli->lli_lock);
 			lli->lli_flags &= ~LLIF_MDS_SIZE_LOCK;
+			spin_unlock(&lli->lli_lock);
+		}
 
 		if (S_ISDIR(inode->i_mode) &&
 		     (bits & MDS_INODELOCK_UPDATE)) {
-- 
1.7.9.5

