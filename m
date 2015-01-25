Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758318AbbAYSqf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:46:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbbAYSKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Heiko Stuebner <heiko@sntech.de>, FUKAUMI Naoki <naobsd@gmail.com>
Subject: [PATCH 3.18 091/183] clk: rockchip: fix rk3066 pll lock bit location
Date: Sun, 25 Jan 2015 10:06:53 -0800
Message-Id: <20150125180814.130009971@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Stuebner <heiko@sntech.de>

commit 12551f0239b50c88352e3292dd7703382addbf5e upstream.

The bit locations indicating the locking status of the plls on rk3066 are
shifted by one to the right when compared to the rk3188, bits [7:4] instead
of [8:5] on the rk3188, thus indicating the locking state of the wrong pll
or a completely different information in case of the gpll.

The recently introduced pll init code exposed that problem on some rk3066
boards when it tried to bring the boot-pll value in line with the value
from the rate table.

Fix this by defining separate pll definitions for rk3066 with the correct
locking indices.

Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Fixes: 2c14736c75db ("clk: rockchip: add clock driver for rk3188 and rk3066 clocks")
Tested-by: FUKAUMI Naoki <naobsd@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


---
 drivers/clk/rockchip/clk-rk3188.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/clk/rockchip/clk-rk3188.c
+++ b/drivers/clk/rockchip/clk-rk3188.c
@@ -210,6 +210,17 @@ PNAME(mux_sclk_hsadc_p)		= { "hsadc_src"
 PNAME(mux_mac_p)		= { "gpll", "dpll" };
 PNAME(mux_sclk_macref_p)	= { "mac_src", "ext_rmii" };
 
+static struct rockchip_pll_clock rk3066_pll_clks[] __initdata = {
+	[apll] = PLL(pll_rk3066, PLL_APLL, "apll", mux_pll_p, 0, RK2928_PLL_CON(0),
+		     RK2928_MODE_CON, 0, 5, rk3188_pll_rates),
+	[dpll] = PLL(pll_rk3066, PLL_DPLL, "dpll", mux_pll_p, 0, RK2928_PLL_CON(4),
+		     RK2928_MODE_CON, 4, 4, NULL),
+	[cpll] = PLL(pll_rk3066, PLL_CPLL, "cpll", mux_pll_p, 0, RK2928_PLL_CON(8),
+		     RK2928_MODE_CON, 8, 6, rk3188_pll_rates),
+	[gpll] = PLL(pll_rk3066, PLL_GPLL, "gpll", mux_pll_p, 0, RK2928_PLL_CON(12),
+		     RK2928_MODE_CON, 12, 7, rk3188_pll_rates),
+};
+
 static struct rockchip_pll_clock rk3188_pll_clks[] __initdata = {
 	[apll] = PLL(pll_rk3066, PLL_APLL, "apll", mux_pll_p, 0, RK2928_PLL_CON(0),
 		     RK2928_MODE_CON, 0, 6, rk3188_pll_rates),
@@ -742,8 +753,8 @@ static void __init rk3188_common_clk_ini
 static void __init rk3066a_clk_init(struct device_node *np)
 {
 	rk3188_common_clk_init(np);
-	rockchip_clk_register_plls(rk3188_pll_clks,
-				   ARRAY_SIZE(rk3188_pll_clks),
+	rockchip_clk_register_plls(rk3066_pll_clks,
+				   ARRAY_SIZE(rk3066_pll_clks),
 				   RK3066_GRF_SOC_STATUS);
 	rockchip_clk_register_branches(rk3066a_clk_branches,
 				  ARRAY_SIZE(rk3066a_clk_branches));


