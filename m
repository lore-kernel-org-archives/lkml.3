Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335AbaBMTqa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:46:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23501 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbaBMTq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:46:26 -0500
Date: Thu, 13 Feb 2014 14:46:17 -0500
Message-Id: <201402131946.s1DJkHrs022567@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 15/38] staging/bcm: move IOCTL_QOS_THRESHOLD case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 29 ++++++++++++++++-------------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index a03ba2ec02f8..5dc9f71189fe 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -981,6 +981,19 @@ static int bcm_char_ioctl_chip_reset(struct bcm_mini_adapter *Adapter)
 	return Status;
 }
 
+static int bcm_char_ioctl_qos_threshold(ULONG arg, struct bcm_mini_adapter *Adapter)
+{
+	USHORT uiLoopIndex;
+
+	for (uiLoopIndex = 0; uiLoopIndex < NO_OF_QUEUES; uiLoopIndex++) {
+		if (get_user(Adapter->PackInfo[uiLoopIndex].uiThreshold,
+				(unsigned long __user *)arg)) {
+			return -EFAULT;
+		}
+	}
+	return 0;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1107,19 +1120,9 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		Status = bcm_char_ioctl_chip_reset(Adapter);
 		return Status;
 
-	case IOCTL_QOS_THRESHOLD: {
-		USHORT uiLoopIndex;
-
-		Status = 0;
-		for (uiLoopIndex = 0; uiLoopIndex < NO_OF_QUEUES; uiLoopIndex++) {
-			if (get_user(Adapter->PackInfo[uiLoopIndex].uiThreshold,
-					(unsigned long __user *)arg)) {
-				Status = -EFAULT;
-				break;
-			}
-		}
-		break;
-	}
+	case IOCTL_QOS_THRESHOLD:
+		Status = bcm_char_ioctl_qos_threshold(arg, Adapter);
+		return Status;
 
 	case IOCTL_DUMP_PACKET_INFO:
 		DumpPackInfo(Adapter);
-- 
1.8.5.3

