Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344Ab3LQPLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 10:11:36 -0500
Received: from gloria.sntech.de ([95.129.55.99]:35476 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543Ab3LQPLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 10:11:34 -0500
From: Heiko =?iso-8859-1?q?St=FCbner?= <heiko@sntech.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] rtc: hym8563: include clkout code only if COMMON_CLK active
Date: Tue, 17 Dec 2013 16:11:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.2.0-2-amd64; KDE/4.8.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org,
        rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201312171611.30526.heiko@sntech.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The contents of clk-provide.h, struct clk_hw etc, are only available
if CONFIG_COMMON_CLK is selected. Therefore IS_ENABLED(COMMON_CLK) is
not sufficient and real preprocessor conditions are necessary to
keep the code in question from being compiled on non-COMMON_CLK systems.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/rtc/rtc-hym8563.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/rtc/rtc-hym8563.c b/drivers/rtc/rtc-hym8563.c
index 841392c..b56e3d3 100644
--- a/drivers/rtc/rtc-hym8563.c
+++ b/drivers/rtc/rtc-hym8563.c
@@ -87,7 +87,9 @@ struct hym8563 {
 	struct i2c_client	*client;
 	struct rtc_device	*rtc;
 	bool			valid;
+#ifdef CONFIG_COMMON_CLK
 	struct clk_hw		clkout_hw;
+#endif
 };
 
 /*
@@ -290,6 +292,7 @@ static const struct rtc_class_ops hym8563_rtc_ops = {
  * Handling of the clkout
  */
 
+#ifdef CONFIG_COMMON_CLK
 #define clkout_hw_to_hym8563(_hw) container_of(_hw, struct hym8563, clkout_hw)
 
 static int clkout_rates[] = {
@@ -423,6 +426,7 @@ static struct clk *hym8563_clkout_register_clk(struct hym8563 *hym8563)
 
 	return clk;
 }
+#endif
 
 /*
  * The alarm interrupt is implemented as a level-low interrupt in the
@@ -565,8 +569,9 @@ static int hym8563_probe(struct i2c_client *client,
 	if (IS_ERR(hym8563->rtc))
 		return PTR_ERR(hym8563->rtc);
 
-	if (IS_ENABLED(CONFIG_COMMON_CLK))
-		hym8563_clkout_register_clk(hym8563);
+#ifdef CONFIG_COMMON_CLK
+	hym8563_clkout_register_clk(hym8563);
+#endif
 
 	return 0;
 }
-- 
1.7.10.4

