Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761464Ab3EAPcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:32:18 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:60411 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab3EAPcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:32:10 -0400
Message-ID: <1367422325.8160.2.camel@phoenix>
Subject: [RFT][PATCH 2/2] clk: wm831x: Fix wm831x_clkout_get_parent
From: Axel Lin <axel.lin@ingics.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Date: Wed, 01 May 2013 23:32:05 +0800
In-Reply-To: <1367422261.8160.1.camel@phoenix>
References: <1367422261.8160.1.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code looks strange because calling wm831x_clkout_set_parent() with 0 as
parent parameter, wm831x_clkout_get_parent() will return 1.

According to the datasheet:
R16528 (4090h) Clock Control1
        BIT 0: CLKOUT output source select
                0 = FLL output
                1 = 32.768kHz oscillator

Thus fix the entry order in wm831x_clkout_parents[] to make it has
the same meaning as the datasheet and make the return value
of wm831x_clkout_get_parent() consistent with the parent pass to
wm831x_clkout_set_parent().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/clk/clk-wm831x.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk-wm831x.c b/drivers/clk/clk-wm831x.c
index 4bdf0b0..58d08a6 100644
--- a/drivers/clk/clk-wm831x.c
+++ b/drivers/clk/clk-wm831x.c
@@ -299,8 +299,8 @@ static void wm831x_clkout_unprepare(struct clk_hw *hw)
 }
 
 static const char *wm831x_clkout_parents[] = {
-	"xtal",
 	"fll",
+	"xtal",
 };
 
 static u8 wm831x_clkout_get_parent(struct clk_hw *hw)
@@ -318,9 +318,9 @@ static u8 wm831x_clkout_get_parent(struct clk_hw *hw)
 	}
 
 	if (ret & WM831X_CLKOUT_SRC)
-		return 0;
-	else
 		return 1;
+	else
+		return 0;
 }
 
 static int wm831x_clkout_set_parent(struct clk_hw *hw, u8 parent)
-- 
1.8.1.2



