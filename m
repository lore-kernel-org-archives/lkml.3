Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaCYX5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 19:57:46 -0400
Received: from gloria.sntech.de ([95.129.55.99]:50254 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751907AbaCYX5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 19:57:45 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko@sntech.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Beniamino Galvani <b.galvani@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] pinctrl: rockchip: handle first half of rk3188-bank0 correctly
Date: Wed, 26 Mar 2014 00:57:52 +0100
Message-ID: <1405109.Gq1eC4TnP1@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <1647754.qr1tAySXax@diego>
References: <1395700561-3793-1-git-send-email-b.galvani@gmail.com> <20140325194357.GA27520@gmail.com> <1647754.qr1tAySXax@diego>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first half of pinbank 0 only has one muxing function (as gpios) and
does not have a special mux-register.

Therefore ensure that no other mux function can be selected and also do not
write to a non-existent register.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
---
 drivers/pinctrl/pinctrl-rockchip.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/pinctrl/pinctrl-rockchip.c b/drivers/pinctrl/pinctrl-rockchip.c
index 80e28e5..ffcd4f4 100644
--- a/drivers/pinctrl/pinctrl-rockchip.c
+++ b/drivers/pinctrl/pinctrl-rockchip.c
@@ -350,6 +350,20 @@ static int rockchip_set_mux(struct rockchip_pin_bank *bank, int pin, int mux)
 	u8 bit;
 	u32 data;
 
+	/*
+	 * The first 16 pins of rk3188_bank0 are always gpios and do not have
+	 * a mux register at all.
+	 */
+	if (bank->bank_type == RK3188_BANK0 && pin < 16) {
+		if (mux != RK_FUNC_GPIO) {
+			dev_err(info->dev,
+				"pin %d only supports a gpio mux\n", pin);
+			return -ENOTSUPP;
+		} else {
+			return 0;
+		}
+	}
+
 	dev_dbg(info->dev, "setting mux of GPIO%d-%d to %d\n",
 						bank->bank_num, pin, mux);
 
-- 
1.9.0


