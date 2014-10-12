Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812AbaJLSrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 14:47:35 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33994 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaJLSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 14:47:27 -0400
From: Koray Gulcu <koray.gulcu@ozu.edu.tr>
To: gregkh@linuxfoundation.org
Cc: peter.p.waskiewicz.jr@intel.com, antoine@schweitzer-chaput.fr,
        anarey@gmail.com, c@24.io, rickard_strandqvist@spectrumdigital.se,
        teobaluta@gmail.com, gdonald@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] staging: rtl8192u: Fix checkpatch.pl warnings
Date: Sun, 12 Oct 2014 19:46:51 +0100
Message-Id: <1413139611-22074-3-git-send-email-koray.gulcu@ozu.edu.tr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1413139611-22074-2-git-send-email-koray.gulcu@ozu.edu.tr>
References: <1413139611-22074-1-git-send-email-koray.gulcu@ozu.edu.tr>
 <1413139611-22074-2-git-send-email-koray.gulcu@ozu.edu.tr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes "line over 80 characters" warnings found in the first patch by breaking u4bAcParam's calculation down into a few steps.

Signed-off-by: Koray Gulcu <koray.gulcu@ozu.edu.tr>
---
 drivers/staging/rtl8192u/r8192U_core.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
index 49b40ea..e031a25 100644
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -1821,8 +1821,11 @@ static void rtl8192_qos_activate(struct work_struct *work)
 	struct net_device *dev = priv->ieee80211->dev;
 	struct ieee80211_qos_parameters *qos_parameters = &priv->ieee80211->current_network.qos_data.parameters;
 	u8 mode = priv->ieee80211->current_network.mode;
-	u8  u1bAIFS;
+	u32  u1bAIFS;
 	u32 u4bAcParam;
+	u32 op_limit;
+	u32 cw_max;
+	u32 cw_min;
 	int i;
 
 	mutex_lock(&priv->mutex);
@@ -1835,11 +1838,14 @@ static void rtl8192_qos_activate(struct work_struct *work)
 	for (i = 0; i <  QOS_QUEUE_NUM; i++) {
 		//Mode G/A: slotTimeTimer = 9; Mode B: 20
 		u1bAIFS = qos_parameters->aifs[i] * ((mode&(IEEE_G|IEEE_N_24G)) ? 9 : 20) + aSifsTime;
-		u4bAcParam = ((((u32)(le16_to_cpu(qos_parameters->tx_op_limit[i]))) << AC_PARAM_TXOP_LIMIT_OFFSET)|
-			      (((u32)(le16_to_cpu(qos_parameters->cw_max[i]))) << AC_PARAM_ECW_MAX_OFFSET)|
-			      (((u32)(le16_to_cpu(qos_parameters->cw_min[i]))) << AC_PARAM_ECW_MIN_OFFSET)|
-			      ((u32)u1bAIFS << AC_PARAM_AIFS_OFFSET));
-
+		u1bAIFS <<= AC_PARAM_AIFS_OFFSET;
+		op_limit = (u32)le16_to_cpu(qos_parameters->tx_op_limit[i]);
+		op_limit <<= AC_PARAM_TXOP_LIMIT_OFFSET;
+		cw_max = (u32)le16_to_cpu(qos_parameters->cw_max[i]);
+		cw_max <<= AC_PARAM_ECW_MAX_OFFSET;
+		cw_min = (u32)le16_to_cpu(qos_parameters->cw_min[i]);
+		cw_min <<= AC_PARAM_ECW_MIN_OFFSET;
+		u4bAcParam = op_limit | cw_max | cw_min | u1bAIFS;
 		write_nic_dword(dev, WDCAPARA_ADD[i], u4bAcParam);
 	}
 
-- 
1.7.10.4

