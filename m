Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbaBMTvj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 14:51:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43800 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbaBMTrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 14:47:16 -0500
Date: Thu, 13 Feb 2014 14:47:08 -0500
Message-Id: <201402131947.s1DJl8qu023036@gelk.kernelslacker.org>
From: Dave Jones <davej@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org
Subject: [PATCH 25/38] staging/bcm: move IOCTL_BCM_SET_DEBUG case out to its own function.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bcm_char_ioctl is one of the longest non-generated functions in the kernel,
at 1906 lines.  Splitting it up into multiple functions should simplify
this a lot.

Signed-off-by: Dave Jones <davej@fedoraproject.org>
---
 drivers/staging/bcm/Bcmchar.c | 71 +++++++++++++++++++++++--------------------
 1 file changed, 38 insertions(+), 33 deletions(-)

diff --git a/drivers/staging/bcm/Bcmchar.c b/drivers/staging/bcm/Bcmchar.c
index dc0e53493e64..a5d5c58b5a90 100644
--- a/drivers/staging/bcm/Bcmchar.c
+++ b/drivers/staging/bcm/Bcmchar.c
@@ -1250,6 +1250,42 @@ static int bcm_char_ioctl_cal_init(void __user *argp, struct bcm_mini_adapter *A
 	return Status;
 }
 
+static int bcm_char_ioctl_set_debug(void __user *argp, struct bcm_mini_adapter *Adapter)
+{
+#ifdef DEBUG
+	struct bcm_ioctl_buffer IoBuffer;
+	struct bcm_user_debug_state sUserDebugState;
+
+	BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "In SET_DEBUG ioctl\n");
+	if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
+		return -EFAULT;
+
+	if (copy_from_user(&sUserDebugState, IoBuffer.InputBuffer, sizeof(struct bcm_user_debug_state)))
+		return -EFAULT;
+
+	BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "IOCTL_BCM_SET_DEBUG: OnOff=%d Type = 0x%x ",
+			sUserDebugState.OnOff, sUserDebugState.Type);
+	/* sUserDebugState.Subtype <<= 1; */
+	sUserDebugState.Subtype = 1 << sUserDebugState.Subtype;
+	BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "actual Subtype=0x%x\n", sUserDebugState.Subtype);
+
+	/* Update new 'DebugState' in the Adapter */
+	Adapter->stDebugState.type |= sUserDebugState.Type;
+	/* Subtype: A bitmap of 32 bits for Subtype per Type.
+	 * Valid indexes in 'subtype' array: 1,2,4,8
+	 * corresponding to valid Type values. Hence we can use the 'Type' field
+	 * as the index value, ignoring the array entries 0,3,5,6,7 !
+	 */
+	if (sUserDebugState.OnOff)
+		Adapter->stDebugState.subtype[sUserDebugState.Type] |= sUserDebugState.Subtype;
+	else
+		Adapter->stDebugState.subtype[sUserDebugState.Type] &= ~sUserDebugState.Subtype;
+
+	BCM_SHOW_DEBUG_BITMAP(Adapter);
+#endif
+	return STATUS_SUCCESS;
+}
+
 
 static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 {
@@ -1439,39 +1475,8 @@ static long bcm_char_ioctl(struct file *filp, UINT cmd, ULONG arg)
 		return Status;
 
 	case IOCTL_BCM_SET_DEBUG:
-#ifdef DEBUG
-	{
-		struct bcm_user_debug_state sUserDebugState;
-
-		BCM_DEBUG_PRINT(Adapter, DBG_TYPE_OTHERS, OSAL_DBG, DBG_LVL_ALL, "In SET_DEBUG ioctl\n");
-		if (copy_from_user(&IoBuffer, argp, sizeof(struct bcm_ioctl_buffer)))
-			return -EFAULT;
-
-		if (copy_from_user(&sUserDebugState, IoBuffer.InputBuffer, sizeof(struct bcm_user_debug_state)))
-			return -EFAULT;
-
-		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "IOCTL_BCM_SET_DEBUG: OnOff=%d Type = 0x%x ",
-				sUserDebugState.OnOff, sUserDebugState.Type);
-		/* sUserDebugState.Subtype <<= 1; */
-		sUserDebugState.Subtype = 1 << sUserDebugState.Subtype;
-		BCM_DEBUG_PRINT (Adapter, DBG_TYPE_PRINTK, 0, 0, "actual Subtype=0x%x\n", sUserDebugState.Subtype);
-
-		/* Update new 'DebugState' in the Adapter */
-		Adapter->stDebugState.type |= sUserDebugState.Type;
-		/* Subtype: A bitmap of 32 bits for Subtype per Type.
-		 * Valid indexes in 'subtype' array: 1,2,4,8
-		 * corresponding to valid Type values. Hence we can use the 'Type' field
-		 * as the index value, ignoring the array entries 0,3,5,6,7 !
-		 */
-		if (sUserDebugState.OnOff)
-			Adapter->stDebugState.subtype[sUserDebugState.Type] |= sUserDebugState.Subtype;
-		else
-			Adapter->stDebugState.subtype[sUserDebugState.Type] &= ~sUserDebugState.Subtype;
-
-		BCM_SHOW_DEBUG_BITMAP(Adapter);
-	}
-#endif
-	break;
+		Status = bcm_char_ioctl_set_debug(argp, Adapter);
+		return Status;
 
 	case IOCTL_BCM_NVM_READ:
 	case IOCTL_BCM_NVM_WRITE: {
-- 
1.8.5.3

