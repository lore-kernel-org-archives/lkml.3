Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3A2HVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:21:51 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:33760 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab3A2HVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:21:47 -0500
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r0T7Lbuv004026
From: <wei_wang@realsil.com.cn>
To: <sameo@linux.intel.com>
CC: <devel@linuxdriverproject.org>, <linux-kernel@vger.kernel.org>,
        <rogerable@realtek.com>, Wei WANG <wei_wang@realsil.com.cn>
Subject: [PATCH 5/6] MFD:rtsx: Use macro defines to replace some variables
Date: Tue, 29 Jan 2013 15:21:36 +0800
Message-ID: <bea3fa9cacac12a3e93ff67ebceadd9fc2984764.1359443488.git.wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <cover.1359443487.git.wei_wang@realsil.com.cn>
References: <cover.1359443487.git.wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei WANG <wei_wang@realsil.com.cn>

In function rtsx_pci_switch_clock, some variables, such as min_n, max_n,
and max_div, are not necessary. And those assigned values look very
obscure for others. It's more proper to use macro definitions here to
replace these variables.

Signed-off-by: Wei WANG <wei_wang@realsil.com.cn>
Acked-by: Borislav Petkov <bp@alien8.de>
---
 drivers/mfd/rtsx_pcr.c |   13 ++++---------
 drivers/mfd/rtsx_pcr.h |    3 +++
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/mfd/rtsx_pcr.c b/drivers/mfd/rtsx_pcr.c
index 4897c39..67bb34e 100644
--- a/drivers/mfd/rtsx_pcr.c
+++ b/drivers/mfd/rtsx_pcr.c
@@ -590,8 +590,7 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
 		u8 ssc_depth, bool initial_mode, bool double_clk, bool vpclk)
 {
 	int err, clk;
-	u8 n, min_n, max_n, clk_divider;
-	u8 mcu_cnt, div, max_div;
+	u8 n, clk_divider, mcu_cnt, div;
 	u8 depth[] = {
 		[RTSX_SSC_DEPTH_4M] = SSC_DEPTH_4M,
 		[RTSX_SSC_DEPTH_2M] = SSC_DEPTH_2M,
@@ -615,10 +614,6 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
 	card_clock /= 1000000;
 	dev_dbg(&(pcr->pci->dev), "Switch card clock to %dMHz\n", card_clock);
 
-	min_n = 80;
-	max_n = 208;
-	max_div = CLK_DIV_8;
-
 	clk = card_clock;
 	if (!initial_mode && double_clk)
 		clk = card_clock * 2;
@@ -633,16 +628,16 @@ int rtsx_pci_switch_clock(struct rtsx_pcr *pcr, unsigned int card_clock,
 		n = (u8)pcr->ops->conv_clk_and_div_n(clk, CLK_TO_DIV_N);
 	else
 		n = (u8)(clk - 2);
-	if ((clk <= 2) || (n > max_n))
+	if ((clk <= 2) || (n > MAX_DIV_N_PCR))
 		return -EINVAL;
 
 	mcu_cnt = (u8)(125/clk + 3);
 	if (mcu_cnt > 15)
 		mcu_cnt = 15;
 
-	/* Make sure that the SSC clock div_n is equal or greater than min_n */
+	/* Make sure that the SSC clock div_n is not less than MIN_DIV_N_PCR */
 	div = CLK_DIV_1;
-	while ((n < min_n) && (div < max_div)) {
+	while ((n < MIN_DIV_N_PCR) && (div < CLK_DIV_8)) {
 		if (pcr->ops->conv_clk_and_div_n) {
 			int dbl_clk = pcr->ops->conv_clk_and_div_n(n,
 					DIV_N_TO_CLK) * 2;
diff --git a/drivers/mfd/rtsx_pcr.h b/drivers/mfd/rtsx_pcr.h
index 12462c1..33c210b 100644
--- a/drivers/mfd/rtsx_pcr.h
+++ b/drivers/mfd/rtsx_pcr.h
@@ -25,6 +25,9 @@
 
 #include <linux/mfd/rtsx_pci.h>
 
+#define MIN_DIV_N_PCR		80
+#define MAX_DIV_N_PCR		208
+
 void rts5209_init_params(struct rtsx_pcr *pcr);
 void rts5229_init_params(struct rtsx_pcr *pcr);
 void rtl8411_init_params(struct rtsx_pcr *pcr);
-- 
1.7.9.5

