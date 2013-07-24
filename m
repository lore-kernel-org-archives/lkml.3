Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752734Ab3GXIhk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 04:37:40 -0400
Received: from hop-nat-141.emc.com ([168.159.213.141]:31945 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752171Ab3GXIgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 04:36:03 -0400
From: mail-agent-noreply@emc.com
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sebastien Buisson <sebastien.buisson@bull.net>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 4/8] staging/lustre/llite: fix 'data race condition' issues of lli_flags
Date: Wed, 24 Jul 2013 16:31:28 +0800
Message-Id: <1374654692-13237-5-git-send-email-mail-agent-noreply@emc.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com>
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sebastien Buisson <sebastien.buisson@bull.net>

Fix 'data race condition' defects found by Coverity version
6.5.0:
Data race condition (MISSING_LOCK)
Accessing variable without holding lock. Elsewhere,
this variable is accessed with lock held.

lli->lli_flags need to be protected by lli->lli_lock.

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
 2 files changed, 8 insertions(+), 1 deletions(-)

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
1.7.1

