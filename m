Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaBMTqx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323AbaBMTqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:51 -0500
Date: Thu, 13 Feb 2014 14:46:42 -0500
Message-Id: <201402131946.s1DJkgP0022821@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 20/38] staging/bcm: move IOCTL_BCM_GET_DSX_INDICATION case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 46 ++++++++++++++++++++++++-------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 30a00f9bcf3f..00c66f503799 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1077,6 +1077,29 @@ static int bcm_char_ioctl_set_mac_tracing(void __user *argp, struct bcm_mini_ada
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_get_dsx_indication(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	ULONG ulSFId = 0;
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.OutputLength < sizeof(struct bcm_add_indication_alt)) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Mismatch req: %lx needed is =0x%zx!!!",
+				IoBuffer.OutputLength, sizeof(struct bcm_add_indication_alt));
+		return -EINVAL;
+	}
+
+	if (copy_from_user(&ulSFId, IoBuffer.InputBuffer, sizeof(ulSFId)))
+		return -EFAULT;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Get DSX Data SF ID is =%lx\n", ulSFId);
+	get_dsx_sf_data_to_application(Adapter, ulSFId, IoBuffer.OutputBuffer);
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1235,26 +1258,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_set_mac_tracing(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GET_DSX_INDICATION: {
-		ULONG ulSFId = 0;
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.OutputLength < sizeof(struct bcm_add_indication_alt)) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Mismatch req: %lx needed is =0x%zx!!!",
-					IoBuffer.OutputLength, sizeof(struct bcm_add_indication_alt));
-			return -EINVAL;
-		}
-
-		if (copy_from_user(&ulSFId, IoBuffer.InputBuffer, sizeof(ulSFId)))
-			return -EFAULT;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "Get DSX Data SF ID is =%lx\n", ulSFId);
-		get_dsx_sf_data_to_application(Adapter, ulSFId, IoBuffer.OutputBuffer);
-		Status = STATUS_SUCCESS;
-	}
-	break;
+	case IOCTL_BCM_GET_DSX_INDICATION:
+		Status = bcm_char_ioctl_get_dsx_indication(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GET_HOST_MIBS: {
 		PVOID temp_buff;
-- 
1.8.5.3

