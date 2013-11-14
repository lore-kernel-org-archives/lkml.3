Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261Ab3KNQlu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:41:50 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:47081 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601Ab3KNQkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:40 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Jinshan Xiong <jinshan.xiong@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 34/39] staging/lustre/llite: cancel open lock before closing file
Date: Fri, 15 Nov 2013 00:32:57 +0800
Message-Id: <1384446782-13741-35-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jinshan Xiong <jinshan.xiong@intel.com>

In error handling path of ll_lease_open(), och has already been
freed in ll_close_inode_openhandle() so the sequence of cancel
open lock and close open handle need adjusting.

Lustre-change: http://review.whamcloud.com/7346
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3647
Signed-off-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 390bea5..a2a9844 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -847,20 +847,24 @@ struct obd_client_handle *ll_lease_open(struct inode *inode, struct file *file,
 	return och;
 
 out_close:
-	rc2 = ll_close_inode_openhandle(sbi->ll_md_exp, inode, och, NULL);
-	if (rc2)
-		CERROR("Close openhandle returned %d\n", rc2);
-
-	/* cancel open lock */
+	/* Cancel open lock */
 	if (it.d.lustre.it_lock_mode != 0) {
 		ldlm_lock_decref_and_cancel(&och->och_lease_handle,
-						it.d.lustre.it_lock_mode);
+					    it.d.lustre.it_lock_mode);
 		it.d.lustre.it_lock_mode = 0;
+		och->och_lease_handle.cookie = 0ULL;
 	}
+	rc2 = ll_close_inode_openhandle(sbi->ll_md_exp, inode, och, NULL);
+	if (rc2 < 0)
+		CERROR("%s: error closing file "DFID": %d\n",
+		       ll_get_fsname(inode->i_sb, NULL, 0),
+		       PFID(&ll_i2info(inode)->lli_fid), rc2);
+	och = NULL; /* och has been freed in ll_close_inode_openhandle() */
 out_release_it:
 	ll_intent_release(&it);
 out:
-	OBD_FREE_PTR(och);
+	if (och != NULL)
+		OBD_FREE_PTR(och);
 	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(ll_lease_open);
-- 
1.7.9.5

