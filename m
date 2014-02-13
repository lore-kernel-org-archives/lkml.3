Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBMTqC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25707 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaBMTp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:56 -0500
Date: Thu, 13 Feb 2014 14:45:47 -0500
Message-Id: <201402131945.s1DJjlMB022531@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 09/38] staging/bcm: move IOCTL_BCM_GPIO_MODE_REQUEST case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 156 ++++++++++++++++++++++--------------------
 1 file changed, 80 insertions(+), 76 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index e69315833a08..eaf8eb5d4f87 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -661,6 +661,83 @@ static int bcm_char_ioctl_gpio_multi_request(void __user *argp, struct bcm_mini_
 	return Status;
 }
 
+static int bcm_char_ioctl_gpio_mode_request(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_gpio_multi_mode gpio_multi_mode[MAX_IDX];
+	struct bcm_gpio_multi_mode *pgpio_multi_mode = (struct bcm_gpio_multi_mode *)gpio_multi_mode;
+	struct bcm_ioctl_buffer IoBuffer;
+	UCHAR ucResetValue[4];
+	INT Status;
+	int bytes;
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE))
+		return -EINVAL;
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.InputLength > sizeof(gpio_multi_mode))
+		return -EINVAL;
+
+	if (copy_from_user(&gpio_multi_mode, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		return -EFAULT;
+
+	bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER, (PUINT)ucResetValue, sizeof(UINT));
+
+	if (bytes < 0) {
+		Status = bytes;
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Read of GPIO_MODE_REGISTER failed");
+		return Status;
+	} else {
+		Status = STATUS_SUCCESS;
+	}
+
+	/* Validating the request */
+	if (IsReqGpioIsLedInNVM(Adapter, pgpio_multi_mode[WIMAX_IDX].uiGPIOMask) == false) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"Sorry, Requested GPIO<0x%X> is not correspond to NVM LED bit map<0x%X>!!!",
+				pgpio_multi_mode[WIMAX_IDX].uiGPIOMask, Adapter->gpioBitMap);
+		return -EINVAL;
+	}
+
+	if (pgpio_multi_mode[WIMAX_IDX].uiGPIOMask) {
+		/* write all OUT's (1's) */
+		*(UINT *) ucResetValue |= (pgpio_multi_mode[WIMAX_IDX].uiGPIOMode &
+					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
+
+		/* write all IN's (0's) */
+		*(UINT *) ucResetValue &= ~((~pgpio_multi_mode[WIMAX_IDX].uiGPIOMode) &
+					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
+
+		/* Currently implemented return the modes of all GPIO's
+		 * else needs to bit AND with  mask
+		 */
+		pgpio_multi_mode[WIMAX_IDX].uiGPIOMode = *(UINT *)ucResetValue;
+
+		Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER, (PUINT)ucResetValue, sizeof(ULONG));
+		if (Status == STATUS_SUCCESS) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+					"WRM to GPIO_MODE_REGISTER Done");
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"WRM to GPIO_MODE_REGISTER Failed");
+			return -EFAULT;
+		}
+	} else {
+		/* if uiGPIOMask is 0 then return mode register configuration */
+		pgpio_multi_mode[WIMAX_IDX].uiGPIOMode = *(UINT *)ucResetValue;
+	}
+
+	Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_mode, IoBuffer.OutputLength);
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Failed while copying Content to IOBufer for user space err:%d", Status);
+		return -EFAULT;
+	}
+	return Status;
+}
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -670,7 +747,6 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	INT Status = STATUS_FAILURE;
 	int timeout = 0;
 	struct bcm_ioctl_buffer IoBuffer;
-	int bytes;
 
 	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
 			"Parameters Passed to control IOCTL cmd=0x%X arg=0x%lX",
@@ -747,81 +823,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_gpio_multi_request(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GPIO_MODE_REQUEST: {
-		UCHAR ucResetValue[4];
-		struct bcm_gpio_multi_mode gpio_multi_mode[MAX_IDX];
-		struct bcm_gpio_multi_mode *pgpio_multi_mode = (struct bcm_gpio_multi_mode *)gpio_multi_mode;
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE))
-			return -EINVAL;
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength > sizeof(gpio_multi_mode))
-			return -EINVAL;
-
-		if (copy_from_user(&gpio_multi_mode, IoBuffer.InputBuffer, IoBuffer.InputLength))
-			return -EFAULT;
-
-		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER, (PUINT)ucResetValue, sizeof(UINT));
-
-		if (bytes < 0) {
-			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Read of GPIO_MODE_REGISTER failed");
-			return Status;
-		} else {
-			Status = STATUS_SUCCESS;
-		}
-
-		/* Validating the request */
-		if (IsReqGpioIsLedInNVM(Adapter, pgpio_multi_mode[WIMAX_IDX].uiGPIOMask) == false) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"Sorry, Requested GPIO<0x%X> is not correspond to NVM LED bit map<0x%X>!!!",
-					pgpio_multi_mode[WIMAX_IDX].uiGPIOMask, Adapter->gpioBitMap);
-			Status = -EINVAL;
-			break;
-		}
-
-		if (pgpio_multi_mode[WIMAX_IDX].uiGPIOMask) {
-			/* write all OUT's (1's) */
-			*(UINT *) ucResetValue |= (pgpio_multi_mode[WIMAX_IDX].uiGPIOMode &
-						pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
-
-			/* write all IN's (0's) */
-			*(UINT *) ucResetValue &= ~((~pgpio_multi_mode[WIMAX_IDX].uiGPIOMode) &
-						pgpio_multi_mode[WIMAX_IDX].uiGPIOMask);
-
-			/* Currently implemented return the modes of all GPIO's
-			 * else needs to bit AND with  mask
-			 */
-			pgpio_multi_mode[WIMAX_IDX].uiGPIOMode = *(UINT *)ucResetValue;
-
-			Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER, (PUINT)ucResetValue, sizeof(ULONG));
-			if (Status == STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-						"WRM to GPIO_MODE_REGISTER Done");
-			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-						"WRM to GPIO_MODE_REGISTER Failed");
-				Status = -EFAULT;
-				break;
-			}
-		} else {
-/* if uiGPIOMask is 0 then return mode register configuration */
-			pgpio_multi_mode[WIMAX_IDX].uiGPIOMode = *(UINT *)ucResetValue;
-		}
-
-		Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_mode, IoBuffer.OutputLength);
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Failed while copying Content to IOBufer for user space err:%d", Status);
-			return -EFAULT;
-		}
-	}
-	break;
+	case IOCTL_BCM_GPIO_MODE_REQUEST:
+		Status = bcm_char_ioctl_gpio_mode_request(argp, Adapter);
+		return Status;
 
 	case IOCTL_MAC_ADDR_REQ:
 	case IOCTL_LINK_REQ:
-- 
1.8.5.3

