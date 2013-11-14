Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681Ab3KNQlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 11:41:15 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:46021 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755266Ab3KNQkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 11:40:05 -0500
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, wang di <di.wang@intel.com>,
        Peng Tao <bergwolf@gmail.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 25/39] staging/lustre/lmv: choose right MDT for open by FID
Date: Fri, 15 Nov 2013 00:32:48 +0800
Message-Id: <1384446782-13741-26-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
References: <1384446782-13741-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wang di <di.wang@intel.com>

If the open is by FID, LMV should locate MDT by the FID
of the file/directory, instead of its parent.

Lustre-change: http://review.whamcloud.com/7253
Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3712
Signed-off-by: wang di <di.wang@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <bergwolf@gmail.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/lmv/lmv_intent.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/lustre/lustre/lmv/lmv_intent.c b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
index 511b3b4..9d25fc4 100644
--- a/drivers/staging/lustre/lustre/lmv/lmv_intent.c
+++ b/drivers/staging/lustre/lustre/lmv/lmv_intent.c
@@ -167,7 +167,13 @@ int lmv_intent_open(struct obd_export *exp, struct md_op_data *op_data,
 	struct mdt_body		*body;
 	int			rc;
 
-	tgt = lmv_locate_mds(lmv, op_data, &op_data->op_fid1);
+	/* Note: client might open with some random flags(sanity 33b), so we can
+	 * not make sure op_fid2 is being initialized with BY_FID flag */
+	if (it->it_flags & MDS_OPEN_BY_FID && fid_is_sane(&op_data->op_fid2))
+		tgt = lmv_locate_mds(lmv, op_data, &op_data->op_fid2);
+	else
+		tgt = lmv_locate_mds(lmv, op_data, &op_data->op_fid1);
+
 	if (IS_ERR(tgt))
 		return PTR_ERR(tgt);
 
-- 
1.7.9.5

