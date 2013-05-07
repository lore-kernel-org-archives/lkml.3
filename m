Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758336Ab3EGIPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:15:11 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:57083 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757991Ab3EGIPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:15:08 -0400
From: Marek Belisko <marek.belisko@gmail.com>
To: mturquette@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        daniel@zonque.org, sebastian.hesselbarth@gmail.com,
        Marek Belisko <marek.belisko@streamunlimited.com>
Subject: [PATCH 1/2] clk: si5351: Fix msynth_recalc_rate return value when fOUT is 0.
Date: Tue,  7 May 2013 10:14:50 +0200
Message-Id: <1367914491-17445-1-git-send-email-marek.belisko@streamunlimited.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When p3 is eual to 0 then result for fOUT is 0. In that case we should
return 0 not parent_rate;

This issue was causing deadlock in si5351 chip when user set_rate for
ms0->clk0 and then set_rate for ms1->clk1 (both ms sourced from plla).
After that clk1 was 0 and it wasn't possible to enable it again (try also
manually with i2cset commands). Only power cycle helps.

Signed-off-by: Marek Belisko <marek.belisko@streamunlimited.com>
---
 drivers/clk/clk-si5351.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/clk-si5351.c b/drivers/clk/clk-si5351.c
index fc215ce..a8fc0f4 100644
--- a/drivers/clk/clk-si5351.c
+++ b/drivers/clk/clk-si5351.c
@@ -607,7 +607,7 @@ static unsigned long si5351_msynth_recalc_rate(struct clk_hw *hw,
 		si5351_read_parameters(hwdata->drvdata, reg, &hwdata->params);
 
 	if (hwdata->params.p3 == 0)
-		return parent_rate;
+		return 0;
 
 	/*
 	 * multisync0-5: fOUT = (128 * P3 * fIN) / (P1*P3 + P2 + 512*P3)
-- 
1.7.9.5

