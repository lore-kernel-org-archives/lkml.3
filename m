Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab3EQVS6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 17:18:58 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:64134 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756632Ab3EQVSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:18:55 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 3/4] clk: vt8500: Remove unnecessary divisor adjustment in vtwm_dclk_set_rate()
Date: Sat, 18 May 2013 09:18:51 +1200
Message-Id: <1368825532-30917-4-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
References: <1368825532-30917-1-git-send-email-linux@prisktech.co.nz>
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
index ce401cf..82306f5 100644
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

