Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaBMTqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbaBMTqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:42 -0500
Date: Thu, 13 Feb 2014 14:46:32 -0500
Message-Id: <201402131946.s1DJkWHS022585@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 18/38] staging/bcm: move IOCTL_BCM_GET_CURRENT_STATUS case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 55 +++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 26 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index 17d2a3f941f5..da8443574643 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1030,6 +1030,32 @@ static int bcm_char_ioctl_get_driver_version(void __user *argp)
 	return STATUS_SUCCESS;
 }
 
+static int bcm_char_ioctl_get_current_status(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+	struct bcm_link_state link_state;
+	struct bcm_ioctl_buffer IoBuffer;
+
+	/* Copy Ioctl Buffer structure */
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer))) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "copy_from_user failed..\n");
+		return -EFAULT;
+	}
+
+	if (IoBuffer.OutputLength != sizeof(link_state))
+		return -EINVAL;
+
+	memset(&link_state, 0, sizeof(link_state));
+	link_state.bIdleMode = Adapter->IdleMode;
+	link_state.bShutdownMode = Adapter->bShutStatus;
+	link_state.ucLinkStatus = Adapter->LinkStatus;
+
+	if (copy_to_user(IoBuffer.OutputBuffer, &link_state, min_t(size_t, sizeof(link_state), IoBuffer.OutputLength))) {
+		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy_to_user Failed..\n");
+		return -EFAULT;
+	}
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1180,32 +1206,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_get_driver_version(argp);
 		return Status;
 
-	case IOCTL_BCM_GET_CURRENT_STATUS: {
-		struct bcm_link_state link_state;
-
-		/* Copy Ioctl Buffer structure */
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer))) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "copy_from_user failed..\n");
-			return -EFAULT;
-		}
-
-		if (IoBuffer.OutputLength != sizeof(link_state)) {
-			Status = -EINVAL;
-			break;
-		}
-
-		memset(&link_state, 0, sizeof(link_state));
-		link_state.bIdleMode = Adapter->IdleMode;
-		link_state.bShutdownMode = Adapter->bShutStatus;
-		link_state.ucLinkStatus = Adapter->LinkStatus;
-
-		if (copy_to_user(IoBuffer.OutputBuffer, &link_state, min_t(size_t, sizeof(link_state), IoBuffer.OutputLength))) {
-			BCM_DEBUG_PRINT(Adapter, DBG_TYPE_PRINTK, 0, 0, "Copy_to_user Failed..\n");
-			return -EFAULT;
-		}
-		Status = STATUS_SUCCESS;
-		break;
-	}
+	case IOCTL_BCM_GET_CURRENT_STATUS:
+		Status = bcm_char_ioctl_get_current_status(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_SET_MAC_TRACING: {
 		UINT  tracing_flag;
-- 
1.8.5.3

