Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752786Ab3EMIU7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 04:20:59 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:54106 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab3EMIU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 04:20:57 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 2/2] clk: vt8500: Remove unnecessary divisor adjustment in vtwm_dclk_set_rate()
Date: Mon, 13 May 2013 20:21:00 +1200
Message-Id: <1368433260-16073-3-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368433260-16073-1-git-send-email-linux@prisktech.co.nz>
References: <1368433260-16073-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The divisor adjustment code to ensure that a divisor is not rounded down,
thereby giving a rate higher than requested, is unnecessary and in some
instances results in the actual rate being much lower than requested due to
rounding errors.

The test is already performed in vtwm_dclk_round_rate(), which is always
called when clk_set_rate is called. Due to rounding errors in the line:
divisor = parent_rate / rate (clk-vt8500.c:160) we will sometimes end up
adjusting the divisor twice - first in round_rate and then again in set_rate.

This patch removes the test/adjustment in vtwm_dclk_set_rate.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/clk/clk-vt8500.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/clk/clk-vt8500.c b/drivers/clk/clk-vt8500.c
index 6d5b6e9..d8fd085 100644
--- a/drivers/clk/clk-vt8500.c
+++ b/drivers/clk/clk-vt8500.c
@@ -157,10 +157,6 @@ static int vt8500_dclk_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	divisor =  parent_rate / rate;
 
-	/* If prate / rate would be decimal, incr the divisor */
-	if (rate * divisor < parent_rate)
-		divisor++;
-
 	if (divisor == cdev->div_mask + 1)
 		divisor = 0;
 
-- 
1.7.9.5

