Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaF0N2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 09:28:11 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:34322 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753444AbaF0N0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 09:26:38 -0400
From: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
To: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Lee Jones <lee.jones@linaro.org>,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: [PATCH v2 08/14] drivers: clk: st: Add polarity bit indication
Date: Fri, 27 Jun 2014 15:25:05 +0200
Message-Id: <1403875511-7710-9-git-send-email-gabriel.fernandez@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
References: <1403875511-7710-1-git-send-email-gabriel.fernandez@linaro.org>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-27_03:2014-06-27,2014-06-27,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch introduces polarity indication for pll power up bit
and for standby bit in order to have same code between stih416
and stih407 boards.

Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
Acked-by: Peter Griffin <peter.griffin@linaro.org>
---
 drivers/clk/st/clkgen-fsyn.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/clk/st/clkgen-fsyn.c b/drivers/clk/st/clkgen-fsyn.c
index a7e5db4..43936b6 100644
--- a/drivers/clk/st/clkgen-fsyn.c
+++ b/drivers/clk/st/clkgen-fsyn.c
@@ -67,6 +67,8 @@ struct clkgen_quadfs_data {
 	bool reset_present;
 	bool bwfilter_present;
 	bool lockstatus_present;
+	bool powerup_polarity;
+	bool standby_polarity;
 	bool nsdiv_present;
 	struct clkgen_field ndiv;
 	struct clkgen_field ref_bw;
@@ -308,7 +310,7 @@ static int quadfs_pll_enable(struct clk_hw *hw)
 	/*
 	 * Power up the PLL
 	 */
-	CLKGEN_WRITE(pll, npda, 1);
+	CLKGEN_WRITE(pll, npda, !pll->data->powerup_polarity);
 
 	if (pll->lock)
 		spin_unlock_irqrestore(pll->lock, flags);
@@ -335,7 +337,7 @@ static void quadfs_pll_disable(struct clk_hw *hw)
 	 * Powerdown the PLL and then put block into soft reset if we have
 	 * reset control.
 	 */
-	CLKGEN_WRITE(pll, npda, 0);
+	CLKGEN_WRITE(pll, npda, pll->data->powerup_polarity);
 
 	if (pll->data->reset_present)
 		CLKGEN_WRITE(pll, nreset, 0);
@@ -611,7 +613,7 @@ static int quadfs_fsynth_enable(struct clk_hw *hw)
 	if (fs->lock)
 		spin_lock_irqsave(fs->lock, flags);
 
-	CLKGEN_WRITE(fs, nsb[fs->chan], 1);
+	CLKGEN_WRITE(fs, nsb[fs->chan], !fs->data->standby_polarity);
 
 	if (fs->lock)
 		spin_unlock_irqrestore(fs->lock, flags);
@@ -631,7 +633,7 @@ static void quadfs_fsynth_disable(struct clk_hw *hw)
 	if (fs->lock)
 		spin_lock_irqsave(fs->lock, flags);
 
-	CLKGEN_WRITE(fs, nsb[fs->chan], 0);
+	CLKGEN_WRITE(fs, nsb[fs->chan], !fs->data->standby_polarity);
 
 	if (fs->lock)
 		spin_unlock_irqrestore(fs->lock, flags);
@@ -645,7 +647,7 @@ static int quadfs_fsynth_is_enabled(struct clk_hw *hw)
 	pr_debug("%s: %s enable bit = 0x%x\n",
 		 __func__, __clk_get_name(hw->clk), nsb);
 
-	return !!nsb;
+	return fs->data->standby_polarity ? !nsb : !!nsb;
 }
 
 #define P15			(uint64_t)(1 << 15)
-- 
1.9.1

