Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752079AbaAQGrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 01:47:47 -0500
Received: from smtp.csie.ntu.edu.tw ([140.112.30.61]:33719 "EHLO
	smtp.csie.ntu.edu.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310AbaAQGrh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 01:47:37 -0500
From: Chen-Yu Tsai <wens@csie.org>
To: Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>
Cc: Chen-Yu Tsai <wens@csie.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH RFC 2/6] net: rfkill: gpio: use clk_prepare_enable/clk_disable_unprepare
Date: Fri, 17 Jan 2014 14:47:27 +0800
Message-Id: <1389941251-32692-3-git-send-email-wens@csie.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389941251-32692-1-git-send-email-wens@csie.org>
References: <1389941251-32692-1-git-send-email-wens@csie.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill-gpio calls clk_enable() without first calling clk_prepare(),
resulting in a warning and no effect. Switch to clk_prepare_enable()
and clk_disable_unprepare.

Signed-off-by: Chen-Yu Tsai <wens@csie.org>
---
 net/rfkill/rfkill-gpio.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/rfkill/rfkill-gpio.c b/net/rfkill/rfkill-gpio.c
index 97ec12a..c7081b7 100644
--- a/net/rfkill/rfkill-gpio.c
+++ b/net/rfkill/rfkill-gpio.c
@@ -51,10 +51,10 @@ static int rfkill_gpio_set_power(void *data, bool blocked)
 		gpiod_set_value(rfkill->shutdown_gpio, 0);
 		gpiod_set_value(rfkill->reset_gpio, 0);
 		if (!IS_ERR(rfkill->clk) && rfkill->clk_enabled)
-			clk_disable(rfkill->clk);
+			clk_disable_unprepare(rfkill->clk);
 	} else {
 		if (!IS_ERR(rfkill->clk) && !rfkill->clk_enabled)
-			clk_enable(rfkill->clk);
+			clk_prepare_enable(rfkill->clk);
 		gpiod_set_value(rfkill->reset_gpio, 1);
 		gpiod_set_value(rfkill->shutdown_gpio, 1);
 	}
-- 
1.8.5.2

