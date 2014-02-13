Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751615AbaBMTpX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:45:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28617 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbaBMTpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:21 -0500
Date: Thu, 13 Feb 2014 14:45:16 -0500
Message-Id: <201402131945.s1DJjGHw022495@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 03/38] staging/bcm: move IOCTL_BCM_EEPROM_REGISTER_READ case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 127 ++++++++++++++++++++++--------------------
 1 file changed, 68 insertions(+), 59 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 8779ed6b3099..fcb19eaad244 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -244,6 +244,71 @@ static int bcm_char_ioctl_reg_write_private(void __user *argp, struct bcm_mini_a
 	return Status;
 }
 
+static int bcm_char_ioctl_eeprom_reg_read(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_rdm_buffer sRdmBuffer = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	PCHAR temp_buff = NULL;
+	UINT uiTempVar = 0;
+	INT Status;
+	int bytes;
+
+	if ((Adapter->IdleMode == TRUE) ||
+		(Adapter->bShutStatus == TRUE) ||
+		(Adapter->bPreparingForLowPowerMode == TRUE)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"Device in Idle Mode, Blocking Rdms\n");
+		return -EACCES;
+	}
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (IoBuffer.InputLength > sizeof(sRdmBuffer))
+		return -EINVAL;
+
+	if (copy_from_user(&sRdmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
+		return -EFAULT;
+
+	if (IoBuffer.OutputLength > USHRT_MAX ||
+		IoBuffer.OutputLength == 0) {
+		return -EINVAL;
+	}
+
+	temp_buff = kmalloc(IoBuffer.OutputLength, GFP_KERNEL);
+	if (!temp_buff)
+		return STATUS_FAILURE;
+
+	if ((((ULONG)sRdmBuffer.Register & 0x0F000000) != 0x0F000000) ||
+		((ULONG)sRdmBuffer.Register & 0x3)) {
+
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
+				"RDM Done On invalid Address : %x Access Denied.\n",
+				(int)sRdmBuffer.Register);
+
+		kfree(temp_buff);
+		return -EINVAL;
+	}
+
+	uiTempVar = sRdmBuffer.Register & EEPROM_REJECT_MASK;
+	bytes = rdmaltWithLock(Adapter, (UINT)sRdmBuffer.Register,
+			       (PUINT)temp_buff, IoBuffer.OutputLength);
+
+	if (bytes > 0) {
+		Status = STATUS_SUCCESS;
+		if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, bytes)) {
+			kfree(temp_buff);
+			return -EFAULT;
+		}
+	} else {
+		Status = bytes;
+	}
+
+	kfree(temp_buff);
+	return Status;
+}
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -305,66 +370,10 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		return Status;
 
 	case IOCTL_BCM_REGISTER_READ:
-	case IOCTL_BCM_EEPROM_REGISTER_READ: {
-		struct bcm_rdm_buffer sRdmBuffer = {0};
-		PCHAR temp_buff = NULL;
-		UINT uiTempVar = 0;
-		if ((Adapter->IdleMode == TRUE) ||
-			(Adapter->bShutStatus == TRUE) ||
-			(Adapter->bPreparingForLowPowerMode == TRUE)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"Device in Idle Mode, Blocking Rdms\n");
-			return -EACCES;
-		}
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (IoBuffer.InputLength > sizeof(sRdmBuffer))
-			return -EINVAL;
-
-		if (copy_from_user(&sRdmBuffer, IoBuffer.InputBuffer, IoBuffer.InputLength))
-			return -EFAULT;
-
-		if (IoBuffer.OutputLength > USHRT_MAX ||
-			IoBuffer.OutputLength == 0) {
-			return -EINVAL;
-		}
-
-		temp_buff = kmalloc(IoBuffer.OutputLength, GFP_KERNEL);
-		if (!temp_buff)
-			return STATUS_FAILURE;
-
-		if ((((ULONG)sRdmBuffer.Register & 0x0F000000) != 0x0F000000) ||
-			((ULONG)sRdmBuffer.Register & 0x3)) {
-
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0,
-					"RDM Done On invalid Address : %x Access Denied.\n",
-					(int)sRdmBuffer.Register);
-
-			kfree(temp_buff);
-			return -EINVAL;
-		}
-
-		uiTempVar = sRdmBuffer.Register & EEPROM_REJECT_MASK;
-		bytes = rdmaltWithLock(Adapter, (UINT)sRdmBuffer.Register,
-				       (PUINT)temp_buff, IoBuffer.OutputLength);
-
-		if (bytes > 0) {
-			Status = STATUS_SUCCESS;
-			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, bytes)) {
-				kfree(temp_buff);
-				return -EFAULT;
-			}
-		} else {
-			Status = bytes;
-		}
+	case IOCTL_BCM_EEPROM_REGISTER_READ:
+		Status = bcm_char_ioctl_eeprom_reg_read(argp, Adapter);
+		return Status;
 
-		kfree(temp_buff);
-		break;
-	}
 	case IOCTL_BCM_REGISTER_WRITE:
 	case IOCTL_BCM_EEPROM_REGISTER_WRITE: {
 		struct bcm_wrm_buffer sWrmBuffer = {0};
-- 
1.8.5.3

