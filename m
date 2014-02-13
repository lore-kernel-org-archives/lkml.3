Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaBMTp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:45:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752064AbaBMTp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:56 -0500
Date: Thu, 13 Feb 2014 14:45:52 -0500
Message-Id: <201402131945.s1DJjqZW022537@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 10/38] staging/bcm: move several request ioctl cases out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 84 +++++++++++++++++++++++--------------------
 1 file changed, 46 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index eaf8eb5d4f87..9b9bc5b09693 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -739,6 +739,49 @@ static int bcm_char_ioctl_gpio_mode_request(void __user *argp, struct bcm_mini_a
 	return Status;
 }
 
+static int bcm_char_ioctl_misc_request(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	PVOID pvBuffer = NULL;
+	INT Status;
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.InputLength < sizeof(struct bcm_link_request))
+		return -EINVAL;
+
+	if (IoBuffer.InputLength > MAX_CNTL_PKT_SIZE)
+		return -EINVAL;
+
+	pvBuffer = memdup_user(IoBuffer.InputBuffer,
+			       IoBuffer.InputLength);
+	if (IS_ERR(pvBuffer))
+		return PTR_ERR(pvBuffer);
+
+	down(&Adapter->LowPowerModeSync);
+	Status = wait_event_interruptible_timeout(Adapter->lowpower_mode_wait_queue,
+						!Adapter->bPreparingForLowPowerMode,
+						(1 * HZ));
+	if (Status == -ERESTARTSYS)
+		goto cntrlEnd;
+
+	if (Adapter->bPreparingForLowPowerMode) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
+				"Preparing Idle Mode is still True - Hence Rejecting control message\n");
+		Status = STATUS_FAILURE;
+		goto cntrlEnd;
+	}
+	Status = CopyBufferToControlPacket(Adapter, (PVOID)pvBuffer);
+
+cntrlEnd:
+	up(&Adapter->LowPowerModeSync);
+	kfree(pvBuffer);
+	return Status;
+}
+
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -832,44 +875,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 	case IOCTL_CM_REQUEST:
 	case IOCTL_SS_INFO_REQ:
 	case IOCTL_SEND_CONTROL_MESSAGE:
-	case IOCTL_IDLE_REQ: {
-		PVOID pvBuffer = NULL;
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength < sizeof(struct bcm_link_request))
-			return -EINVAL;
-
-		if (IoBuffer.InputLength > MAX_CNTL_PKT_SIZE)
-			return -EINVAL;
-
-		pvBuffer = memdup_user(IoBuffer.InputBuffer,
-				       IoBuffer.InputLength);
-		if (IS_ERR(pvBuffer))
-			return PTR_ERR(pvBuffer);
-
-		down(&Adapter->LowPowerModeSync);
-		Status = wait_event_interruptible_timeout(Adapter->lowpower_mode_wait_queue,
-							!Adapter->bPreparingForLowPowerMode,
-							(1 * HZ));
-		if (Status == -ERESTARTSYS)
-			goto cntrlEnd;
-
-		if (Adapter->bPreparingForLowPowerMode) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL,
-					"Preparing Idle Mode is still True - Hence Rejecting control message\n");
-			Status = STATUS_FAILURE;
-			goto cntrlEnd;
-		}
-		Status = CopyBufferToControlPacket(Adapter, (PVOID)pvBuffer);
-
-cntrlEnd:
-		up(&Adapter->LowPowerModeSync);
-		kfree(pvBuffer);
-		break;
-	}
+	case IOCTL_IDLE_REQ:
+		Status = bcm_char_ioctl_misc_request(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_BUFFER_DOWNLOAD_START: {
 		if (down_trylock(&Adapter->NVMRdmWrmLock)) {
-- 
1.8.5.3

