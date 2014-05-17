Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbaEQVUy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 17:20:54 -0400
Received: from mail-ee0-f50.google.com ([74.125.83.50]:33397 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaEQVUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 17:20:53 -0400
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Senna Tschudin <peter.senna@gmail.com>,
        kernel-janitors@vger.kernel.org, dan.carpenter@oracle.com
Subject: [PATCH 1/4 V2] VMCI: Remove redundant error check and code cleanup
Date: Sat, 17 May 2014 23:20:19 +0200
Message-Id: <1400361619-5323-1-git-send-email-peter.senna@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove double checks, and move the call to pr_devel. Remove the
initialization of the result variable, and return VMCI_SUCCESS on
success. Fix the condition of the for loop. Replace break with a
return. The simplified version of the coccinelle semantic patch
that find the redundant check issue is as follows:

// <smpl>
@@
expression E; identifier pr; expression list es;
@@
for(...;...;...){
...
-	if (E) break;
+	if (E){
+		pr(es);
+		break;
+	}
...
}
- if(E) pr(es);
// </smpl>

Tested by compilation only.

Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

---
Changes from V1:
 - Removed initialization of result
 - Return VMCI_SUCCESS instead of result on success
 - Fixed the for loop condition
 - Replaced break with a return

 drivers/misc/vmw_vmci/vmci_context.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_context.c b/drivers/misc/vmw_vmci/vmci_context.c
index f866a4b..78c1165 100644
--- a/drivers/misc/vmw_vmci/vmci_context.c
+++ b/drivers/misc/vmw_vmci/vmci_context.c
@@ -816,7 +816,7 @@ int vmci_ctx_set_chkpt_state(u32 context_id,
 {
 	u32 i;
 	u32 current_id;
-	int result = VMCI_SUCCESS;
+	int result;
 	u32 num_ids = buf_size / sizeof(u32);
 
 	if (cpt_type == VMCI_WELLKNOWN_CPT_STATE && num_ids > 0) {
@@ -833,17 +833,17 @@ int vmci_ctx_set_chkpt_state(u32 context_id,
 		return VMCI_ERROR_INVALID_ARGS;
 	}
 
-	for (i = 0; i < num_ids && result == VMCI_SUCCESS; i++) {
+	for (i = 0; i < num_ids; i++) {
 		current_id = ((u32 *)cpt_buf)[i];
 		result = vmci_ctx_add_notification(context_id, current_id);
-		if (result != VMCI_SUCCESS)
-			break;
+		if (result != VMCI_SUCCESS) {
+			pr_devel("Failed to set cpt state (type=%d) (error=%d)\n",
+				 cpt_type, result);
+			return result;
+		}
 	}
-	if (result != VMCI_SUCCESS)
-		pr_devel("Failed to set cpt state (type=%d) (error=%d)\n",
-			 cpt_type, result);
 
-	return result;
+	return VMCI_SUCCESS;
 }
 
 /*
