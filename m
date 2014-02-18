Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaBRWrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 17:47:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaBRWrm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 17:47:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Shawn Guo <shawn.guo@linaro.org>, Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 3.13 40/40] ARM: imx6: Initialize low-power mode early again
Date: Tue, 18 Feb 2014 14:47:41 -0800
Message-Id: <20140218224434.459073779@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140218224433.337299968@linuxfoundation.org>
References: <20140218224433.337299968@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Zabel <p.zabel@pengutronix.de>

commit e7c57ecd6019cc6392223605aed18cce257c3eff upstream.

Since commit 9e8147bb5ec5d1dda2141da70f96b98985a306cb
"ARM: imx6q: move low-power code out of clock driver"
the kernel fails to boot on i.MX6Q/D if preemption is
enabled (CONFIG_PREEMPT=y). The kernel just hangs
before the console comes up.

The above commit moved the initalization of the low-power
mode setting (enabling clocked WAIT states), which was
introduced in commit 83ae20981ae924c37d02a42c829155fc3851260c
"ARM: imx: correct low-power mode setting", from
imx6q_clks_init to imx6q_pm_init. Now it is called
much later, after all cores are enabled.

This patch moves the low-power mode initialization back
to imx6q_clks_init again (and to imx6sl_clks_init).

Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-imx/clk-imx6q.c  |    3 +++
 arch/arm/mach-imx/clk-imx6sl.c |    3 +++
 arch/arm/mach-imx/pm-imx6q.c   |    2 --
 3 files changed, 6 insertions(+), 2 deletions(-)

--- a/arch/arm/mach-imx/clk-imx6q.c
+++ b/arch/arm/mach-imx/clk-imx6q.c
@@ -479,6 +479,9 @@ static void __init imx6q_clocks_init(str
 	if (IS_ENABLED(CONFIG_PCI_IMX6))
 		clk_set_parent(clk[lvds1_sel], clk[sata_ref]);
 
+	/* Set initial power mode */
+	imx6q_set_lpm(WAIT_CLOCKED);
+
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6q-gpt");
 	base = of_iomap(np, 0);
 	WARN_ON(!base);
--- a/arch/arm/mach-imx/clk-imx6sl.c
+++ b/arch/arm/mach-imx/clk-imx6sl.c
@@ -261,6 +261,9 @@ static void __init imx6sl_clocks_init(st
 		clk_prepare_enable(clks[IMX6SL_CLK_USBPHY2_GATE]);
 	}
 
+	/* Set initial power mode */
+	imx6q_set_lpm(WAIT_CLOCKED);
+
 	np = of_find_compatible_node(NULL, NULL, "fsl,imx6sl-gpt");
 	base = of_iomap(np, 0);
 	WARN_ON(!base);
--- a/arch/arm/mach-imx/pm-imx6q.c
+++ b/arch/arm/mach-imx/pm-imx6q.c
@@ -228,8 +228,6 @@ void __init imx6q_pm_init(void)
 		regmap_update_bits(gpr, IOMUXC_GPR1, IMX6Q_GPR1_GINT,
 				   IMX6Q_GPR1_GINT);
 
-	/* Set initial power mode */
-	imx6q_set_lpm(WAIT_CLOCKED);
 
 	suspend_set_ops(&imx6q_pm_ops);
 }


