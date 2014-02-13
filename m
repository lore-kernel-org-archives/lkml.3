Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752516AbaBMTqs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43611 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaBMTqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:46 -0500
Date: Thu, 13 Feb 2014 14:46:37 -0500
Message-Id: <201402131946.s1DJkbtl022622@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 19/38] staging/bcm: move IOCTL_BCM_SET_MAC_TRACING case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index da8443574643..30a00f9bcf3f 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1057,6 +1057,27 @@ static int bcm_char_ioctl_get_current_status(void __user *argp, struct bcm_mini_
 }
 
 
+static int bcm_char_ioctl_set_mac_tracing(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_ioctl_buffer IoBuffer;
+	UINT tracing_flag;
+
+	/* copy ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (copy_from_user(&tracing_flag, IoBuffer.InputBuffer, sizeof(UINT)))
+		return -EFAULT;
+
+	if (tracing_flag)
+		Adapter->pTarangs->MacTracingEnabled = TRUE;
+	else
+		Adapter->pTarangs->MacTracingEnabled = false;
+
+	return STATUS_SUCCESS;
+}
+
+
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
 	struct bcm_tarang_data *pTarang = filp->private_data;
@@ -1210,22 +1231,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_get_current_status(argp, Adapter);
 		return Status;
 
-	case IOCTL_BCM_SET_MAC_TRACING: {
-		UINT  tracing_flag;
-
-		/* copy ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (copy_from_user(&tracing_flag, IoBuffer.InputBuffer, sizeof(UINT)))
-			return -EFAULT;
-
-		if (tracing_flag)
-			Adapter->pTarangs->MacTracingEnabled = TRUE;
-		else
-			Adapter->pTarangs->MacTracingEnabled = false;
-		break;
-	}
+	case IOCTL_BCM_SET_MAC_TRACING:
+		Status = bcm_char_ioctl_set_mac_tracing(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_GET_DSX_INDICATION: {
 		ULONG ulSFId = 0;
-- 
1.8.5.3

