Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaBMTpz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:45:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57583 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbaBMTpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:50 -0500
Date: Thu, 13 Feb 2014 14:45:41 -0500
Message-Id: <201402131945.s1DJjfnm022525@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 08/38] staging/bcm: move IOCTL_BCM_GPIO_MULTI_REQUEST case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 183 ++++++++++++++++++++++--------------------
 1 file changed, 95 insertions(+), 88 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 56b445abedf8..e69315833a08 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -569,6 +569,98 @@ static int bcm_char_ioctl_gpio_status_request(void __user *argp, struct bcm_mini
 	return Status;
 }
 
+static int bcm_char_ioctl_gpio_multi_request(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_gpio_multi_info gpio_multi_info[MAX_IDX];
+	struct bcm_gpio_multi_info *pgpio_multi_info = (struct bcm_gpio_multi_info *)gpio_multi_info;
+	struct bcm_ioctl_buffer IoBuffer;
+	UCHAR ucResetValue[4];
+	INT Status = STATUS_FAILURE;
+	int bytes;
+
+	memset(pgpio_multi_info, 0, MAX_IDX * sizeof(struct bcm_gpio_multi_info));
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE))
+		return -EINVAL;
+
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.InputLength > sizeof(gpio_multi_info))
+		return -EINVAL;
+
+	if (copy_from_user(&gpio_multi_info, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		return -EFAULT;
+
+	if (IsReqGpioIsLedInNVM(Adapter, pgpio_multi_info[WIMAX_IDX].uiGPIOMask) == false) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL,
+				"Sorry, Requested GPIO<0x%X> is not correspond to NVM LED bit map<0x%X>!!!",
+				pgpio_multi_info[WIMAX_IDX].uiGPIOMask,
+				Adapter->gpioBitMap);
+		return -EINVAL;
+	}
+
+	/* Set the gpio output register */
+	if ((pgpio_multi_info[WIMAX_IDX].uiGPIOMask) &
+		(pgpio_multi_info[WIMAX_IDX].uiGPIOCommand)) {
+		/* Set 1's in GPIO OUTPUT REGISTER */
+		*(UINT *)ucResetValue =  pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
+			pgpio_multi_info[WIMAX_IDX].uiGPIOCommand &
+			pgpio_multi_info[WIMAX_IDX].uiGPIOValue;
+
+		if (*(UINT *) ucResetValue)
+			Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_SET_REG,
+						(PUINT)ucResetValue, sizeof(ULONG));
+
+		if (Status != STATUS_SUCCESS) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"WRM to BCM_GPIO_OUTPUT_SET_REG Failed.");
+			return Status;
+		}
+
+		/* Clear to 0's in GPIO OUTPUT REGISTER */
+		*(UINT *)ucResetValue = (pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
+					pgpio_multi_info[WIMAX_IDX].uiGPIOCommand &
+					(~(pgpio_multi_info[WIMAX_IDX].uiGPIOValue)));
+
+		if (*(UINT *) ucResetValue)
+			Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_CLR_REG, (PUINT)ucResetValue, sizeof(ULONG));
+
+		if (Status != STATUS_SUCCESS) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"WRM to BCM_GPIO_OUTPUT_CLR_REG Failed.");
+			return Status;
+		}
+	}
+
+	if (pgpio_multi_info[WIMAX_IDX].uiGPIOMask) {
+		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_PIN_STATE_REGISTER, (PUINT)ucResetValue, sizeof(UINT));
+
+		if (bytes < 0) {
+			Status = bytes;
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+					"RDM to GPIO_PIN_STATE_REGISTER Failed.");
+			return Status;
+		} else {
+			Status = STATUS_SUCCESS;
+		}
+
+		pgpio_multi_info[WIMAX_IDX].uiGPIOValue = (*(UINT *)ucResetValue &
+							pgpio_multi_info[WIMAX_IDX].uiGPIOMask);
+	}
+
+	Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_info, IoBuffer.OutputLength);
+	if (Status) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Failed while copying Content to IOBufer for user space err:%d", Status);
+		return -EFAULT;
+	}
+	return Status;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -651,94 +743,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_gpio_status_request(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_GPIO_MULTI_REQUEST: {
-		UCHAR ucResetValue[4];
-		struct bcm_gpio_multi_info gpio_multi_info[MAX_IDX];
-		struct bcm_gpio_multi_info *pgpio_multi_info = (struct bcm_gpio_multi_info *)gpio_multi_info;
-
-		memset(pgpio_multi_info, 0, MAX_IDX * sizeof(struct bcm_gpio_multi_info));
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE))
-			return -EINVAL;
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength > sizeof(gpio_multi_info))
-			return -EINVAL;
-
-		if (copy_from_user(&gpio_multi_info, IoBuffer.InputBuffer, IoBuffer.InputLength))
-			return -EFAULT;
-
-		if (IsReqGpioIsLedInNVM(Adapter, pgpio_multi_info[WIMAX_IDX].uiGPIOMask) == false) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL,
-					"Sorry, Requested GPIO<0x%X> is not correspond to NVM LED bit map<0x%X>!!!",
-					pgpio_multi_info[WIMAX_IDX].uiGPIOMask,
-					Adapter->gpioBitMap);
-			Status = -EINVAL;
-			break;
-		}
-
-		/* Set the gpio output register */
-		if ((pgpio_multi_info[WIMAX_IDX].uiGPIOMask) &
-			(pgpio_multi_info[WIMAX_IDX].uiGPIOCommand)) {
-			/* Set 1's in GPIO OUTPUT REGISTER */
-			*(UINT *)ucResetValue =  pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
-				pgpio_multi_info[WIMAX_IDX].uiGPIOCommand &
-				pgpio_multi_info[WIMAX_IDX].uiGPIOValue;
-
-			if (*(UINT *) ucResetValue)
-				Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_SET_REG,
-							(PUINT)ucResetValue, sizeof(ULONG));
-
-			if (Status != STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-						"WRM to BCM_GPIO_OUTPUT_SET_REG Failed.");
-				return Status;
-			}
-
-			/* Clear to 0's in GPIO OUTPUT REGISTER */
-			*(UINT *)ucResetValue = (pgpio_multi_info[WIMAX_IDX].uiGPIOMask &
-						pgpio_multi_info[WIMAX_IDX].uiGPIOCommand &
-						(~(pgpio_multi_info[WIMAX_IDX].uiGPIOValue)));
-
-			if (*(UINT *) ucResetValue)
-				Status = wrmaltWithLock(Adapter, BCM_GPIO_OUTPUT_CLR_REG, (PUINT)ucResetValue, sizeof(ULONG));
-
-			if (Status != STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-						"WRM to BCM_GPIO_OUTPUT_CLR_REG Failed.");
-				return Status;
-			}
-		}
-
-		if (pgpio_multi_info[WIMAX_IDX].uiGPIOMask) {
-			bytes = rdmaltWithLock(Adapter, (UINT)GPIO_PIN_STATE_REGISTER, (PUINT)ucResetValue, sizeof(UINT));
-
-			if (bytes < 0) {
-				Status = bytes;
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-						"RDM to GPIO_PIN_STATE_REGISTER Failed.");
-				return Status;
-			} else {
-				Status = STATUS_SUCCESS;
-			}
-
-			pgpio_multi_info[WIMAX_IDX].uiGPIOValue = (*(UINT *)ucResetValue &
-								pgpio_multi_info[WIMAX_IDX].uiGPIOMask);
-		}
-
-		Status = copy_to_user(IoBuffer.OutputBuffer, &gpio_multi_info, IoBuffer.OutputLength);
-		if (Status) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Failed while copying Content to IOBufer for user space err:%d", Status);
-			return -EFAULT;
-		}
-	}
-	break;
+	case IOCTL_BCM_GPIO_MULTI_REQUEST:
+		Status = bcm_char_ioctl_gpio_multi_request(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GPIO_MODE_REQUEST: {
 		UCHAR ucResetValue[4];
-- 
1.8.5.3

