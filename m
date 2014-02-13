Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbaBMTqe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752341AbaBMTqc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:32 -0500
Date: Thu, 13 Feb 2014 14:46:22 -0500
Message-Id: <201402131946.s1DJkM6J022573@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 16/38] staging/bcm: move IOCTL_BCM_SWITCH_TRANSFER_MODE case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 5dc9f71189fe..9d8048feae23 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -994,6 +994,25 @@ static int bcm_char_ioctl_qos_threshold(ULONG arg, struct bcm_mini_adapter *Adap
 	return 0;
 }
 
+static int bcm_char_ioctl_switch_transfer_mode(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	UINT uiData = 0;
+
+	if (copy_from_user(&uiData, argp, sizeof(UINT)))
+		return -EFAULT;
+
+	if (uiData) {
+		/* Allow All Packets */
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SWITCH_TRANSFER_MODE: ETH_PACKET_TUNNELING_MODE\n");
+			Adapter->TransferMode = ETH_PACKET_TUNNELING_MODE;
+	} else {
+		/* Allow IP only Packets */
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SWITCH_TRANSFER_MODE: IP_PACKET_ONLY_MODE\n");
+		Adapter->TransferMode = IP_PACKET_ONLY_MODE;
+	}
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1136,23 +1155,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = STATUS_SUCCESS;
 		break;
 
-	case IOCTL_BCM_SWITCH_TRANSFER_MODE: {
-		UINT uiData = 0;
-		if (copy_from_user(&uiData, argp, sizeof(UINT)))
-			return -EFAULT;
-
-		if (uiData) {
-			/* Allow All Packets */
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SWITCH_TRANSFER_MODE: ETH_PACKET_TUNNELING_MODE\n");
-				Adapter->TransferMode = ETH_PACKET_TUNNELING_MODE;
-		} else {
-			/* Allow IP only Packets */
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "IOCTL_BCM_SWITCH_TRANSFER_MODE: IP_PACKET_ONLY_MODE\n");
-			Adapter->TransferMode = IP_PACKET_ONLY_MODE;
-		}
-		Status = STATUS_SUCCESS;
-		break;
-	}
+	case IOCTL_BCM_SWITCH_TRANSFER_MODE:
+		Status = bcm_char_ioctl_switch_transfer_mode(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GET_DRIVER_VERSION: {
 		ulong len;
-- 
1.8.5.3

