Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbaBMT4r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:56:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752066AbaBMTp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:58 -0500
Date: Thu, 13 Feb 2014 14:45:31 -0500
Message-Id: <201402131945.s1DJjVAr022513@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 06/38] staging/bcm: move BCM_LED_THREAD_STATE_CHANGE_REQ case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 95 +++++++++++++++++++++++--------------------
 1 file changed, 51 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index a7991289c7c1..c0b29971dd72 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -482,6 +482,54 @@ static int bcm_char_ioctl_gpio_set_request(void __user *argp, struct bcm_mini_ad
 	return Status;
 }
 
+static int bcm_char_ioctl_led_thread_state_change_req(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_user_thread_req threadReq = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+			"User made LED thread InActive");
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
+	if (IoBuffer.InputLength > sizeof(threadReq))
+		return -EINVAL;
+
+	if (copy_from_user(&threadReq, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		return -EFAULT;
+
+	/* if LED thread is running(Actively or Inactively) set it state to make inactive */
+	if (Adapter->LEDInfo.led_thread_running) {
+		if (threadReq.ThreadState == LED_THREAD_ACTIVATION_REQ) {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL,
+					"Activating thread req");
+			Adapter->DriverState = LED_THREAD_ACTIVE;
+		} else {
+			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
+					OSAL_DBG, DBG_LVL_ALL,
+					"DeActivating Thread req.....");
+			Adapter->DriverState = LED_THREAD_INACTIVE;
+		}
+
+		/* signal thread. */
+		wake_up(&Adapter->LEDInfo.notify_led_event);
+	}
+	return STATUS_SUCCESS;
+}
+
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -555,50 +603,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_gpio_set_request(argp, Adapter);
 		return Status;
 
-	case BCM_LED_THREAD_STATE_CHANGE_REQ: {
-		struct bcm_user_thread_req threadReq = {0};
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-				"User made LED thread InActive");
-
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG,
-					DBG_LVL_ALL,
-					"GPIO Can't be set/clear in Low power Mode");
-			Status = -EACCES;
-			break;
-		}
-
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength > sizeof(threadReq))
-			return -EINVAL;
-
-		if (copy_from_user(&threadReq, IoBuffer.InputBuffer, IoBuffer.InputLength))
-			return -EFAULT;
-
-		/* if LED thread is running(Actively or Inactively) set it state to make inactive */
-		if (Adapter->LEDInfo.led_thread_running) {
-			if (threadReq.ThreadState == LED_THREAD_ACTIVATION_REQ) {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
-						OSAL_DBG, DBG_LVL_ALL,
-						"Activating thread req");
-				Adapter->DriverState = LED_THREAD_ACTIVE;
-			} else {
-				BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS,
-						OSAL_DBG, DBG_LVL_ALL,
-						"DeActivating Thread req.....");
-				Adapter->DriverState = LED_THREAD_INACTIVE;
-			}
-
-			/* signal thread. */
-			wake_up(&Adapter->LEDInfo.notify_led_event);
-		}
-	}
-	break;
+	case BCM_LED_THREAD_STATE_CHANGE_REQ:
+		Status = bcm_char_ioctl_led_thread_state_change_req(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GPIO_STATUS_REQUEST: {
 		ULONG uiBit = 0;
-- 
1.8.5.3

