Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757692Ab3GVQKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 12:10:31 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39802 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757650Ab3GVQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 12:10:28 -0400
From: Peng Tao <bergwolf@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, "John L. Hammond" <john.hammond@intel.com>,
        Peng Tao <tao.peng@emc.com>, Andreas Dilger <andreas.dilger@intel.com>
Subject: [PATCH 08/48] staging/lustre/llite: check ll_prep_md_op_data() using IS_ERR()
Date: Tue, 23 Jul 2013 00:06:29 +0800
Message-Id: <1374509230-3324-9-git-send-email-bergwolf@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
References: <1374509230-3324-1-git-send-email-bergwolf@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "John L. Hammond" <john.hammond@intel.com>

In ll_file_ioctl() and ll_swap_layouts() check the result of
ll_prep_md_op_data() using IS_ERR().

Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3283
Lustre-change: http://review.whamcloud.com/6275
Signed-off-by: John L. Hammond <john.hammond@intel.com>
Reviewed-by: Jinshan Xiong <jinshan.xiong@intel.com>
Reviewed-by: Fan Yong <fan.yong@intel.com>
Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
Signed-off-by: Peng Tao <tao.peng@emc.com>
Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
---
 drivers/staging/lustre/lustre/llite/file.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 717682c..50ef6a5 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -1832,12 +1832,12 @@ static int ll_swap_layouts(struct file *file1, struct file *file2,
 	rc = -ENOMEM;
 	op_data = ll_prep_md_op_data(NULL, llss->inode1, llss->inode2, NULL, 0,
 				     0, LUSTRE_OPC_ANY, &msl);
-	if (op_data != NULL) {
-		rc = obd_iocontrol(LL_IOC_LOV_SWAP_LAYOUTS,
-				   ll_i2mdexp(llss->inode1),
-				   sizeof(*op_data), op_data, NULL);
-		ll_finish_md_op_data(op_data);
-	}
+	if (IS_ERR(op_data))
+		GOTO(free, rc = PTR_ERR(op_data));
+
+	rc = obd_iocontrol(LL_IOC_LOV_SWAP_LAYOUTS, ll_i2mdexp(llss->inode1),
+			   sizeof(*op_data), op_data, NULL);
+	ll_finish_md_op_data(op_data);
 
 putgl:
 	if (gid != 0) {
@@ -2031,9 +2031,9 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
 					     LUSTRE_OPC_ANY, hus);
-		if (op_data == NULL) {
+		if (IS_ERR(op_data)) {
 			OBD_FREE_PTR(hus);
-			RETURN(-ENOMEM);
+			RETURN(PTR_ERR(op_data));
 		}
 
 		rc = obd_iocontrol(cmd, ll_i2mdexp(inode), sizeof(*op_data),
@@ -2069,9 +2069,9 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
 					     LUSTRE_OPC_ANY, hss);
-		if (op_data == NULL) {
+		if (IS_ERR(op_data)) {
 			OBD_FREE_PTR(hss);
-			RETURN(-ENOMEM);
+			RETURN(PTR_ERR(op_data));
 		}
 
 		rc = obd_iocontrol(cmd, ll_i2mdexp(inode), sizeof(*op_data),
@@ -2093,9 +2093,9 @@ long ll_file_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 
 		op_data = ll_prep_md_op_data(NULL, inode, NULL, NULL, 0, 0,
 					     LUSTRE_OPC_ANY, hca);
-		if (op_data == NULL) {
+		if (IS_ERR(op_data)) {
 			OBD_FREE_PTR(hca);
-			RETURN(-ENOMEM);
+			RETURN(PTR_ERR(op_data));
 		}
 
 		rc = obd_iocontrol(cmd, ll_i2mdexp(inode), sizeof(*op_data),
-- 
1.7.9.5

