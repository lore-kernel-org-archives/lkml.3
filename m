Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbaBMT6r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:58:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751464AbaBMTpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:45:23 -0500
Date: Thu, 13 Feb 2014 14:45:05 -0500
Message-Id: <201402131945.s1DJj5WV022483@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 01/38] staging/bcm: move IOCTL_BCM_REGISTER_READ_PRIVATE case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 96 +++++++++++++++++++++++--------------------
 1 file changed, 52 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index f1b6de0293c8..0e63929b7b11 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -150,6 +150,55 @@ static ssize_t bcm_char_read(struct file *filp, char __user *buf, size_t size,
 	return PktLen;
 }
 
+static int bcm_char_ioctl_reg_read_private(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_rdm_buffer sRdmBuffer = {0};
+	struct bcm_ioctl_buffer IoBuffer;
+	PCHAR temp_buff;
+	INT Status = STATUS_FAILURE;
+	UINT Bufflen;
+	u16 temp_value;
+	int bytes;
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
+	Bufflen = IoBuffer.OutputLength;
+	temp_value = 4 - (Bufflen % 4);
+	Bufflen += temp_value % 4;
+
+	temp_buff = kmalloc(Bufflen, GFP_KERNEL);
+	if (!temp_buff)
+		return -ENOMEM;
+
+	bytes = rdmalt(Adapter, (UINT)sRdmBuffer.Register,
+			(PUINT)temp_buff, Bufflen);
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
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -201,50 +250,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 
 	switch (cmd) {
 	/* Rdms for Swin Idle... */
-	case IOCTL_BCM_REGISTER_READ_PRIVATE: {
-		struct bcm_rdm_buffer sRdmBuffer = {0};
-		PCHAR temp_buff;
-		UINT Bufflen;
-		u16 temp_value;
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
-		Bufflen = IoBuffer.OutputLength;
-		temp_value = 4 - (Bufflen % 4);
-		Bufflen += temp_value % 4;
-
-		temp_buff = kmalloc(Bufflen, GFP_KERNEL);
-		if (!temp_buff)
-			return -ENOMEM;
-
-		bytes = rdmalt(Adapter, (UINT)sRdmBuffer.Register,
-				(PUINT)temp_buff, Bufflen);
-		if (bytes > 0) {
-			Status = STATUS_SUCCESS;
-			if (copy_to_user(IoBuffer.OutputBuffer, temp_buff, bytes)) {
-				kfree(temp_buff);
-				return -EFAULT;
-			}
-		} else {
-			Status = bytes;
-		}
-
-		kfree(temp_buff);
-		break;
-	}
+	case IOCTL_BCM_REGISTER_READ_PRIVATE:
+		Status = bcm_char_ioctl_reg_read_private(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_REGISTER_WRITE_PRIVATE: {
 		struct bcm_wrm_buffer sWrmBuffer = {0};
-- 
1.8.5.3

