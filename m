Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932842Ab3GVQL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:11:59 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61556 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932814Ab3GVQLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:11:48 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, jcl <jacques-charles.lafoucriere@cea.fr>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 24/48] staging/lustre/llite: force lvb_data update after layout change
Date: Tue, 23 Jul 2013 00:06:45 +0800
Message-Id: <1374509230-3324-25-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: jcl <jacques-charles.lafoucriere@cea.fr>

When a file is restored the layout lock is first
associated with the released layout and after restore
it has to be assocaited with the new layout. This patch
forces lvb_data update in ll_layout_fetch() even if one
is present (case for released->normal state change)

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3299
Lustre-change: http://review.whamcloud.com/6291
Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Johann Lombardi <johann.lombardi@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 5493845..b1df7f5 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -2941,7 +2941,11 @@ static int ll_layout_fetch(struct inode *inode, struct ldlm_lock *lock)
 	int rc;
 	ENTRY;
 
-	if (lock->l_lvb_data != NULL)
+	CDEBUG(D_INODE, DFID" LVB_READY=%d l_lvb_data=%p l_lvb_len=%d\n",
+	       PFID(ll_inode2fid(inode)), !!(lock->l_flags & LDLM_FL_LVB_READY),
+	       lock->l_lvb_data, lock->l_lvb_len);
+
+	if ((lock->l_lvb_data != NULL) && (lock->l_flags & LDLM_FL_LVB_READY))
 		RETURN(0);
 
 	/* if layout lock was granted right away, the layout is returned
@@ -2977,15 +2981,13 @@ static int ll_layout_fetch(struct inode *inode, struct ldlm_lock *lock)
 
 	memcpy(lvbdata, lmm, lmmsize);
 	lock_res_and_lock(lock);
-	if (lock->l_lvb_data == NULL) {
-		lock->l_lvb_data = lvbdata;
-		lock->l_lvb_len = lmmsize;
-		lvbdata = NULL;
-	}
+	if (lock->l_lvb_data != NULL)
+		OBD_FREE_LARGE(lock->l_lvb_data, lock->l_lvb_len);
+
+	lock->l_lvb_data = lvbdata;
+	lock->l_lvb_len = lmmsize;
 	unlock_res_and_lock(lock);
 
-	if (lvbdata != NULL)
-		OBD_FREE_LARGE(lvbdata, lmmsize);
 	EXIT;
 
 out:
@@ -3017,7 +3019,7 @@ static int ll_layout_lock_set(struct lustre_handle *lockh, ldlm_mode_t mode,
 	LASSERT(ldlm_has_layout(lock));
 
 	LDLM_DEBUG(lock, "File %p/"DFID" being reconfigured: %d.\n",
-		inode, PFID(&lli->lli_fid), reconf);
+		   inode, PFID(&lli->lli_fid), reconf);
 
 	/* in case this is a caching lock and reinstate with new inode */
 	md_set_lock_data(sbi->ll_md_exp, &lockh->cookie, inode, NULL);
-- 
1.7.9.5

