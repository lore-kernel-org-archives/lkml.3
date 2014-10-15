Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197AbaJOL0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:26:10 -0400
Received: from regular1.263xmail.com ([211.150.99.131]:50227 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbaJOL0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:26:08 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <96e6b7ff04ef6c958bd7d20ce7be1ff7>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 0
From: Addy Ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, dianders@chromium.org,
        grant.likely@linaro.org, robh+dt@kernel.org, amstan@google.com,
        sonnyrao@google.com
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH 1/2] spi/rockchip: fix bug that case spi can't go as fast as slave request
Date: Wed, 15 Oct 2014 19:25:49 +0800
Message-Id: <1413372349-4254-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com>
References: <1413372311-4203-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because the minimum divisor in rk3x's spi controller is 2,
if spi_clk is less than 2 * sclk_out, we can't get the right divisor.
So we must set spi_clk again to match slave request.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/spi/spi-rockchip.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index f96ea8a..3044c6c 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -145,6 +145,9 @@
 #define RXBUSY						(1 << 0)
 #define TXBUSY						(1 << 1)
 
+/* sclk_out: spi master internal logic in rk3x can support 50Mhz */
+#define MAX_SCLK_OUT		50000000
+
 enum rockchip_ssi_type {
 	SSI_MOTO_SPI = 0,
 	SSI_TI_SSP,
@@ -496,6 +499,15 @@ static void rockchip_spi_config(struct rockchip_spi *rs)
 			dmacr |= RF_DMA_EN;
 	}
 
+	if (WARN_ON(rs->speed > MAX_SCLK_OUT))
+		rs->speed = MAX_SCLK_OUT;
+
+	/* the minimum divsor is 2 */
+	if (rs->max_freq < 2 * rs->speed) {
+		clk_set_rate(rs->spiclk, 2 * rs->speed);
+		rs->max_freq = clk_get_rate(rs->spiclk);
+	}
+
 	/* div doesn't support odd number */
 	div = max_t(u32, rs->max_freq / rs->speed, 1);
 	div = (div + 1) & 0xfffe;
-- 
1.8.3.2


