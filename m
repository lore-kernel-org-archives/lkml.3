Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaBMT5l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:57:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30184 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751889AbaBMTpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:36 -0500
Date: Thu, 13 Feb 2014 14:45:26 -0500
Message-Id: <201402131945.s1DJjQ3W022507@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 05/38] staging/bcm: move IOCTL_BCM_GPIO_SET_REQUEST case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 215 ++++++++++++++++++++++--------------------
 1 file changed, 111 insertions(+), 104 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index c2219c544811..a7991289c7c1 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -374,6 +374,114 @@ static int bcm_char_ioctl_eeprom_reg_write(void __user *argp, struct bcm_mini_ad
 	return Status;
 }
 
+static int bcm_char_ioctl_gpio_set_request(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_gpio_info gpio_info = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	UCHAR ucResetValue[4];
+	UINT value = 0;
+	UINT uiBit = 0;
+	UINT uiOperation = 0;
+	INT Status;
+	int bytes;
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL,
+				"GPIO Can't be set/clear in Low power Mode");
+		return -EACCES;
+	}
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
+	uiBit  = gpio_info.uiGpioNumber;
+	uiOperation = gpio_info.uiGpioValue;
+	value = (1<<uiBit);
+
+	if (IsReqGpioIsLedInNVM(Adapter, value) == false) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL,
+				"Sorry, Requested GPIO<0x%X> is not correspond to LED !!!",
+				value);
+		return -EINVAL;
+	}
+
+	/* Set - setting 1 */
+	if (uiOperation) {
+		/* Set the gpio output register */
+		Status = wrmaltWithLock(Adapter,
+					BCM_GPIO_OUTPUT_SET_REG,
+					(PUINT)(&value), sizeof(UINT));
+
+		if (Status == STATUS_SUCCESS) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL,
+					"Set the GPIO bit\n");
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL,
+					"Failed to set the %dth GPIO\n",
+					uiBit);
+			return Status;
+		}
+	} else {
+		/* Set the gpio output register */
+		Status = wrmaltWithLock(Adapter,
+					BCM_GPIO_OUTPUT_CLR_REG,
+					(PUINT)(&value), sizeof(UINT));
+
+		if (Status == STATUS_SUCCESS) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL,
+					"Set the GPIO bit\n");
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL,
+					"Failed to clear the %dth GPIO\n",
+					uiBit);
+			return Status;
+		}
+	}
+
+	bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER,
+			       (PUINT)ucResetValue, sizeof(UINT));
+	if (bytes < 0) {
+		Status = bytes;
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"GPIO_MODE_REGISTER read failed");
+		return Status;
+	} else {
+		Status = STATUS_SUCCESS;
+	}
+
+	/* Set the gpio mode register to output */
+	*(UINT *)ucResetValue |= (1<<uiBit);
+	Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER,
+				(PUINT)ucResetValue, sizeof(UINT));
+
+	if (Status == STATUS_SUCCESS) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL,
+				"Set the GPIO to output Mode\n");
+	} else {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
+				DBG_LVL_ALL,
+				"Failed to put GPIO in Output Mode\n");
+	}
+
+	return Status;
+}
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -443,110 +551,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_eeprom_reg_write(argp, Adapter, cmd);
 		return Status;
 
-	case IOCTL_BCM_GPIO_SET_REQUEST: {
-		UCHAR ucResetValue[4];
-		UINT value = 0;
-		UINT uiBit = 0;
-		UINT uiOperation = 0;
-		struct bcm_gpio_info gpio_info = {0};
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL,
-					"GPIO Can't be set/clear in Low power Mode");
-			return -EACCES;
-		}
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
-		uiBit  = gpio_info.uiGpioNumber;
-		uiOperation = gpio_info.uiGpioValue;
-		value = (1<<uiBit);
-
-		if (IsReqGpioIsLedInNVM(Adapter, value) == false) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL,
-					"Sorry, Requested GPIO<0x%X> is not correspond to LED !!!",
-					value);
-			Status = -EINVAL;
-			break;
-		}
-
-		/* Set - setting 1 */
-		if (uiOperation) {
-			/* Set the gpio output register */
-			Status = wrmaltWithLock(Adapter,
-						BCM_GPIO_OUTPUT_SET_REG,
-						(PUINT)(&value), sizeof(UINT));
-
-			if (Status == STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
-						OSAL_DBG, DBG_LVL_ALL,
-						"Set the GPIO bit\n");
-			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
-						OSAL_DBG, DBG_LVL_ALL,
-						"Failed to set the %dth GPIO\n",
-						uiBit);
-				break;
-			}
-		} else {
-			/* Set the gpio output register */
-			Status = wrmaltWithLock(Adapter,
-						BCM_GPIO_OUTPUT_CLR_REG,
-						(PUINT)(&value), sizeof(UINT));
-
-			if (Status == STATUS_SUCCESS) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
-						OSAL_DBG, DBG_LVL_ALL,
-						"Set the GPIO bit\n");
-			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
-						OSAL_DBG, DBG_LVL_ALL,
-						"Failed to clear the %dth GPIO\n",
-						uiBit);
-				break;
-			}
-		}
-
-		bytes = rdmaltWithLock(Adapter, (UINT)GPIO_MODE_REGISTER,
-				       (PUINT)ucResetValue, sizeof(UINT));
-		if (bytes < 0) {
-			Status = bytes;
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"GPIO_MODE_REGISTER read failed");
-			break;
-		} else {
-			Status = STATUS_SUCCESS;
-		}
-
-		/* Set the gpio mode register to output */
-		*(UINT *)ucResetValue |= (1<<uiBit);
-		Status = wrmaltWithLock(Adapter, GPIO_MODE_REGISTER,
-					(PUINT)ucResetValue, sizeof(UINT));
-
-		if (Status == STATUS_SUCCESS) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL,
-					"Set the GPIO to output Mode\n");
-		} else {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL,
-					"Failed to put GPIO in Output Mode\n");
-			break;
-		}
-	}
-	break;
+	case IOCTL_BCM_GPIO_SET_REQUEST:
+		Status = bcm_char_ioctl_gpio_set_request(argp, Adapter);
+		return Status;
 
 	case BCM_LED_THREAD_STATE_CHANGE_REQ: {
 		struct bcm_user_thread_req threadReq = {0};
-- 
1.8.5.3

