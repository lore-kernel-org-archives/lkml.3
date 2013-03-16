Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753754Ab3CPGRK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 02:17:10 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:55614 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab3CPGRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 02:17:07 -0400
From: Lokesh Vutla <lokeshvutla@ti.com>
To: <gregkh@linuxfoundation.org>
CC: <santosh.shilimkar@ti.com>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <lokeshvutla@ti.com>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V2 3/8] memory: emif: handle overflow for timing for LP mode
Date: Sat, 16 Mar 2013 11:46:43 +0530
Message-ID: <1363414608-7448-4-git-send-email-lokeshvutla@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
References: <1363414608-7448-1-git-send-email-lokeshvutla@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

In case the custom timings provide values which overflow
the maximum possible field value, warn and use maximum
permissible value.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
Changes since V1: No changes

 drivers/memory/emif.c |   36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 5f3b7ed..e513889 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -715,6 +715,8 @@ static u32 get_pwr_mgmt_ctrl(u32 freq, struct emif_data *emif, u32 ip_rev)
 	u32 timeout_perf	= EMIF_LP_MODE_TIMEOUT_PERFORMANCE;
 	u32 timeout_pwr		= EMIF_LP_MODE_TIMEOUT_POWER;
 	u32 freq_threshold	= EMIF_LP_MODE_FREQ_THRESHOLD;
+	u32 mask;
+	u8 shift;
 
 	struct emif_custom_configs *cust_cfgs = emif->plat_data->custom_configs;
 
@@ -743,27 +745,45 @@ static u32 get_pwr_mgmt_ctrl(u32 freq, struct emif_data *emif, u32 ip_rev)
 
 	switch (lpmode) {
 	case EMIF_LP_MODE_CLOCK_STOP:
-		pwr_mgmt_ctrl = (timeout << CS_TIM_SHIFT) |
-					SR_TIM_MASK | PD_TIM_MASK;
+		shift = CS_TIM_SHIFT;
+		mask = CS_TIM_MASK;
 		break;
 	case EMIF_LP_MODE_SELF_REFRESH:
 		/* Workaround for errata i735 */
 		if (timeout < 6)
 			timeout = 6;
 
-		pwr_mgmt_ctrl = (timeout << SR_TIM_SHIFT) |
-					CS_TIM_MASK | PD_TIM_MASK;
+		shift = SR_TIM_SHIFT;
+		mask = SR_TIM_MASK;
 		break;
 	case EMIF_LP_MODE_PWR_DN:
-		pwr_mgmt_ctrl = (timeout << PD_TIM_SHIFT) |
-					CS_TIM_MASK | SR_TIM_MASK;
+		shift = PD_TIM_SHIFT;
+		mask = PD_TIM_MASK;
 		break;
 	case EMIF_LP_MODE_DISABLE:
 	default:
-		pwr_mgmt_ctrl = CS_TIM_MASK |
-					PD_TIM_MASK | SR_TIM_MASK;
+		mask = 0;
+		shift = 0;
+		break;
+	}
+	/* Round to maximum in case of overflow, BUT warn! */
+	if (lpmode != EMIF_LP_MODE_DISABLE && timeout > mask >> shift) {
+		pr_err("TIMEOUT Overflow - lpmode=%d perf=%d pwr=%d freq=%d\n",
+		       lpmode,
+		       timeout_perf,
+		       timeout_pwr,
+		       freq_threshold);
+		WARN(1, "timeout=0x%02x greater than 0x%02x. Using max\n",
+		     timeout, mask >> shift);
+		timeout = mask >> shift;
 	}
 
+	/* Setup required timing */
+	pwr_mgmt_ctrl = (timeout << shift) & mask;
+	/* setup a default mask for rest of the modes */
+	pwr_mgmt_ctrl |= (SR_TIM_MASK | CS_TIM_MASK | PD_TIM_MASK) &
+			  ~mask;
+
 	/* No CS_TIM in EMIF_4D5 */
 	if (ip_rev == EMIF_4D5)
 		pwr_mgmt_ctrl &= ~CS_TIM_MASK;
-- 
1.7.9.5

