Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751166Ab3LXHHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 02:07:45 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:33266
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab3LXHHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 02:07:44 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6h1082kzz1de098h8275bh1de097hz2dh2a8h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h1155h)
From: Anson Huang <b20788@freescale.com>
To: <shawn.guo@linaro.org>, <kernel@pengutronix.de>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] ARM: imx: add necessary interface for pfd
Date: Tue, 24 Dec 2013 14:05:38 -0500
Message-ID: <1387911938-4828-1-git-send-email-b20788@freescale.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Common clk framework will disable unused clks in late init only if
they are enabled by default and no one is using it, so we need to
add is_enabled callback for clk framework to get clks' status.

PFD clocks are enabled by hardware reset, so we need to add
interface for common clk framework to disable those unused ones for
saving power.

Signed-off-by: Anson Huang <b20788@freescale.com>
---
 arch/arm/mach-imx/clk-pfd.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/arm/mach-imx/clk-pfd.c b/arch/arm/mach-imx/clk-pfd.c
index e2ed416..0b0f6f6 100644
--- a/arch/arm/mach-imx/clk-pfd.c
+++ b/arch/arm/mach-imx/clk-pfd.c
@@ -109,12 +109,23 @@ static int clk_pfd_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
+static int clk_pfd_is_enabled(struct clk_hw *hw)
+{
+	struct clk_pfd *pfd = to_clk_pfd(hw);
+
+	if (readl_relaxed(pfd->reg) & (1 << ((pfd->idx + 1) * 8 - 1)))
+		return 0;
+
+	return 1;
+}
+
 static const struct clk_ops clk_pfd_ops = {
 	.enable		= clk_pfd_enable,
 	.disable	= clk_pfd_disable,
 	.recalc_rate	= clk_pfd_recalc_rate,
 	.round_rate	= clk_pfd_round_rate,
 	.set_rate	= clk_pfd_set_rate,
+	.is_enabled     = clk_pfd_is_enabled,
 };
 
 struct clk *imx_clk_pfd(const char *name, const char *parent_name,
-- 
1.7.9.5


