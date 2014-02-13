Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015AbaBMTpt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:45:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaBMTpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:45 -0500
Date: Thu, 13 Feb 2014 14:45:36 -0500
Message-Id: <201402131945.s1DJja6i022519@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 07/38] staging/bcm: move IOCTL_BCM_GPIO_STATUS_REQUEST case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 78 ++++++++++++++++++++++++-------------------
 1 file changed, 43 insertions(+), 35 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index c0b29971dd72..56b445abedf8 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -529,6 +529,46 @@ static int bcm_char_ioctl_led_thread_state_change_req(void __user *argp, struct
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_gpio_status_request(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_gpio_info gpio_info = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	ULONG uiBit = 0;
+	UCHAR ucRead[4];
+	INT Status;
+	int bytes;
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE))
+		return -EACCES;
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.InputLength > sizeof(gpio_info))
+		return -EINVAL;
+
+	if (copy_from_user(&gpio_info, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		return -EFAULT;
+
+	uiBit = gpio_info.uiGpioNumber;
+
+	/* Set the gpio output register */
+	bytes = rdmaltWithLock(Adapter, (UINT)GPIO_PIN_STATE_REGISTER,
+				(PUINT)ucRead, sizeof(UINT));
+
+	if (bytes < 0) {
+		Status = bytes;
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"RDM Failed\n");
+		return Status;
+	} else {
+		Status = STATUS_SUCCESS;
+	}
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -607,41 +647,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_led_thread_state_change_req(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GPIO_STATUS_REQUEST: {
-		ULONG uiBit = 0;
-		UCHAR ucRead[4];
-		struct bcm_gpio_info gpio_info = {0};
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE))
-			return -EACCES;
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength > sizeof(gpio_info))
-			return -EINVAL;
-
-		if (copy_from_user(&gpio_info, IoBuffer.InputBuffer, IoBuffer.InputLength))
-			return -EFAULT;
-
-		uiBit = gpio_info.uiGpioNumber;
-
-		/* Set the gpio output register */
-		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_PIN_STATE_REGISTER,
-					(PUINT)ucRead, sizeof(UINT));
-
-		if (bytes < 0) {
-			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"RDM Failed\n");
-			return Status;
-		} else {
-			Status = STATUS_SUCCESS;
-		}
-	}
-	break;
+	case IOCTL_BCM_GPIO_STATUS_REQUEST:
+		Status = bcm_char_ioctl_gpio_status_request(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GPIO_MULTI_REQUEST: {
 		UCHAR ucResetValue[4];
-- 
1.8.5.3

