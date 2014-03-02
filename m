Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbaCBFYD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 00:24:03 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38149 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbaCBFXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 00:23:09 -0500
From: Axel Rasmussen <axel.rasmussen1@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 9/9] drivers: staging: rtl8187se: refactor wmm_param_update
Date: Sat,  1 Mar 2014 22:22:53 -0700
Message-Id: <1393737773-13937-10-git-send-email-axel.rasmussen1@gmail.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
References: <1393737773-13937-1-git-send-email-axel.rasmussen1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function rtl8180_wmm_param_update contained two blocks of code which
were nearly identical. This patch combines those two blocks into a
single function, to reduce code duplication, and do fix some
checkpatch.pl warnings about excessively long lines due to the large
number of indents that were needed for the original blocks of code.

Signed-off-by: Axel Rasmussen <axel.rasmussen1@gmail.com>
---
 drivers/staging/rtl8187se/r8180_core.c | 119 ++++++++++++++-------------------
 1 file changed, 49 insertions(+), 70 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
index b6fdb6f..fc5d4d9 100644
--- a/drivers/staging/rtl8187se/r8180_core.c
+++ b/drivers/staging/rtl8187se/r8180_core.c
@@ -2114,16 +2114,49 @@ static void rtl8180_hw_sleep(struct net_device *dev, u32 th, u32 tl)
 	spin_unlock_irqrestore(&priv->ps_lock, flags);
 }
 
+static void rtl8180_wmm_single_param_update(struct net_device *dev,
+	u8 mode, AC_CODING eACI, PAC_PARAM param)
+{
+	u8 u1bAIFS;
+	u32 u4bAcParam;
+
+	/* Retrieve parameters to update. */
+	/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
+	u1bAIFS = param->f.AciAifsn.f.AIFSN * ((mode & IEEE_G) == IEEE_G ?
+		9 : 20) + aSifsTime;
+	u4bAcParam = (((u32)param->f.TXOPLimit << AC_PARAM_TXOP_LIMIT_OFFSET) |
+		((u32)param->f.Ecw.f.ECWmax << AC_PARAM_ECW_MAX_OFFSET) |
+		((u32)param->f.Ecw.f.ECWmin << AC_PARAM_ECW_MIN_OFFSET) |
+		((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
+
+	switch (eACI) {
+	case AC1_BK:
+		write_nic_dword(dev, AC_BK_PARAM, u4bAcParam);
+		break;
+	case AC0_BE:
+		write_nic_dword(dev, AC_BE_PARAM, u4bAcParam);
+		break;
+	case AC2_VI:
+		write_nic_dword(dev, AC_VI_PARAM, u4bAcParam);
+		break;
+	case AC3_VO:
+		write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
+		break;
+	default:
+		pr_warn("SetHwReg8185(): invalid ACI: %d!\n", eACI);
+	break;
+	}
+}
+
 static void rtl8180_wmm_param_update(struct work_struct *work)
 {
-	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, wmm_param_update_wq);
+	struct ieee80211_device *ieee = container_of(work,
+		struct ieee80211_device, wmm_param_update_wq);
 	struct net_device *dev = ieee->dev;
 	u8 *ac_param = (u8 *)(ieee->current_network.wmm_param);
 	u8 mode = ieee->current_network.mode;
-	AC_CODING	eACI;
-	AC_PARAM	AcParam;
-	PAC_PARAM	pAcParam;
-	u8 i;
+	AC_CODING eACI;
+	AC_PARAM AcParam;
 
 	if (!ieee->current_network.QoS_Enable) {
 		/* legacy ac_xx_param update */
@@ -2133,78 +2166,24 @@ static void rtl8180_wmm_param_update(struct work_struct *work)
 		AcParam.f.Ecw.f.ECWmin = 3; /* Follow 802.11 CWmin. */
 		AcParam.f.Ecw.f.ECWmax = 7; /* Follow 802.11 CWmax. */
 		AcParam.f.TXOPLimit = 0;
+
 		for (eACI = 0; eACI < AC_MAX; eACI++) {
 			AcParam.f.AciAifsn.f.ACI = (u8)eACI;
-			{
-				u8		u1bAIFS;
-				u32		u4bAcParam;
-				pAcParam = (PAC_PARAM)(&AcParam);
-				/* Retrieve parameters to update. */
-				u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
-				u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit))<<AC_PARAM_TXOP_LIMIT_OFFSET)|
-					      (((u32)(pAcParam->f.Ecw.f.ECWmax))<<AC_PARAM_ECW_MAX_OFFSET)|
-					      (((u32)(pAcParam->f.Ecw.f.ECWmin))<<AC_PARAM_ECW_MIN_OFFSET)|
-					       (((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
-				switch (eACI) {
-				case AC1_BK:
-					write_nic_dword(dev, AC_BK_PARAM, u4bAcParam);
-					break;
-				case AC0_BE:
-					write_nic_dword(dev, AC_BE_PARAM, u4bAcParam);
-					break;
-				case AC2_VI:
-					write_nic_dword(dev, AC_VI_PARAM, u4bAcParam);
-					break;
-				case AC3_VO:
-					write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
-					break;
-				default:
-					pr_warn("SetHwReg8185():invalid ACI: %d!\n",
-						eACI);
-					break;
-				}
-			}
+
+			rtl8180_wmm_single_param_update(dev, mode, eACI,
+				(PAC_PARAM)&AcParam);
 		}
 		return;
 	}
 
-	for (i = 0; i < AC_MAX; i++) {
+	for (eACI = 0; eACI < AC_MAX; eACI++) {
 		/* AcParam.longData = 0; */
-		pAcParam = (AC_PARAM *)ac_param;
-		{
-			AC_CODING	eACI;
-			u8		u1bAIFS;
-			u32		u4bAcParam;
-
-			/* Retrieve parameters to update. */
-			eACI = pAcParam->f.AciAifsn.f.ACI;
-			/* Mode G/A: slotTimeTimer = 9; Mode B: 20 */
-			u1bAIFS = pAcParam->f.AciAifsn.f.AIFSN * (((mode&IEEE_G) == IEEE_G) ? 9 : 20) + aSifsTime;
-			u4bAcParam = ((((u32)(pAcParam->f.TXOPLimit)) << AC_PARAM_TXOP_LIMIT_OFFSET)	|
-					(((u32)(pAcParam->f.Ecw.f.ECWmax)) << AC_PARAM_ECW_MAX_OFFSET)	|
-					(((u32)(pAcParam->f.Ecw.f.ECWmin)) << AC_PARAM_ECW_MIN_OFFSET)	|
-					(((u32)u1bAIFS) << AC_PARAM_AIFS_OFFSET));
-
-			switch (eACI) {
-			case AC1_BK:
-				write_nic_dword(dev, AC_BK_PARAM, u4bAcParam);
-				break;
-			case AC0_BE:
-				write_nic_dword(dev, AC_BE_PARAM, u4bAcParam);
-				break;
-			case AC2_VI:
-				write_nic_dword(dev, AC_VI_PARAM, u4bAcParam);
-				break;
-			case AC3_VO:
-				write_nic_dword(dev, AC_VO_PARAM, u4bAcParam);
-				break;
-			default:
-				pr_warn("SetHwReg8185(): invalid ACI: %d !\n",
-					eACI);
-				break;
-			}
-		}
-		ac_param += (sizeof(AC_PARAM));
+
+		rtl8180_wmm_single_param_update(dev, mode,
+			((PAC_PARAM)ac_param)->f.AciAifsn.f.ACI,
+			(PAC_PARAM)ac_param);
+
+		ac_param += sizeof(AC_PARAM);
 	}
 }
 
-- 
1.8.3.2

