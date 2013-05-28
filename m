Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934602Ab3E1Poi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 11:44:38 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:31411 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934536Ab3E1Poh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 11:44:37 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/DHYjX4pSxBCUcKY47ETYstJsyb/9eY38=
Date: Tue, 28 May 2013 11:44:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 01/10] clk: mvebu: introduce per-clock-gate flags
Message-ID: <20130528154409.GU31290@titan.lakedaemon.net>
References: <1368234490-31416-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1368234490-31416-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368234490-31416-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian, Thomas,

On Sat, May 11, 2013 at 03:08:01AM +0200, Sebastian Hesselbarth wrote:
> Clock gates found on MVEBU SoCs get registered by a common function.
> To allow specific SoCs to provide tweaks introduce flags to the clock
> gate descriptor instead of filling up the common function SoC specific
> tweaks.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/mvebu/clk-gating-ctrl.c |  153 +++++++++++++++++------------------
>  1 file changed, 72 insertions(+), 81 deletions(-)

Here's the revised version after rebasing onto mvebu/pcie:

--->8-------

commit 12f8ebff609dc9378a8c121e195ccf6984d5e5c6
Author: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Date:   Sat May 11 03:08:01 2013 +0200

    clk: mvebu: introduce per-clock-gate flags
    
    Clock gates found on MVEBU SoCs get registered by a common function.
    To allow specific SoCs to provide tweaks introduce flags to the clock
    gate descriptor instead of filling up the common function SoC specific
    tweaks.
    
    Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
    Tested-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
    Signed-off-by: Jason Cooper <jason@lakedaemon.net>

diff --git a/drivers/clk/mvebu/clk-gating-ctrl.c b/drivers/clk/mvebu/clk-gating-ctrl.c
index 2f03723..1df6c4e 100644
--- a/drivers/clk/mvebu/clk-gating-ctrl.c
+++ b/drivers/clk/mvebu/clk-gating-ctrl.c
@@ -28,6 +28,7 @@ struct mvebu_soc_descr {
 	const char *name;
 	const char *parent;
 	int bit_idx;
+	unsigned long flags;
 };
 
 #define to_clk_gate(_hw) container_of(_hw, struct clk_gate, hw)
@@ -88,21 +89,11 @@ static void __init mvebu_clk_gating_setup(
 	}
 
 	for (n = 0; n < ctrl->num_gates; n++) {
-		u8 flags = 0;
 		const char *parent =
 			(descr[n].parent) ? descr[n].parent : default_parent;
-
-		/*
-		 * On Armada 370, the DDR clock is a special case: it
-		 * isn't taken by any driver, but should anyway be
-		 * kept enabled, so we mark it as IGNORE_UNUSED for
-		 * now.
-		 */
-		if (!strcmp(descr[n].name, "ddr"))
-			flags |= CLK_IGNORE_UNUSED;
-
 		ctrl->gates[n] = clk_register_gate(NULL, descr[n].name, parent,
-				   flags, base, descr[n].bit_idx, 0, &ctrl->lock);
+					descr[n].flags, base, descr[n].bit_idx,
+					0, &ctrl->lock);
 		WARN_ON(IS_ERR(ctrl->gates[n]));
 	}
 	of_clk_add_provider(np, mvebu_clk_gating_get_src, ctrl);
@@ -114,99 +105,99 @@ static void __init mvebu_clk_gating_setup(
 
 #ifdef CONFIG_MACH_ARMADA_370
 static const struct mvebu_soc_descr __initconst armada_370_gating_descr[] = {
-	{ "audio", NULL, 0 },
-	{ "pex0_en", NULL, 1 },
-	{ "pex1_en", NULL,  2 },
-	{ "ge1", NULL, 3 },
-	{ "ge0", NULL, 4 },
-	{ "pex0", "pex0_en", 5 },
-	{ "pex1", "pex1_en", 9 },
-	{ "sata0", NULL, 15 },
-	{ "sdio", NULL, 17 },
-	{ "tdm", NULL, 25 },
-	{ "ddr", NULL, 28 },
-	{ "sata1", NULL, 30 },
+	{ "audio", NULL, 0, 0 },
+	{ "pex0_en", NULL, 1, 0 },
+	{ "pex1_en", NULL,  2, 0 },
+	{ "ge1", NULL, 3, 0 },
+	{ "ge0", NULL, 4, 0 },
+	{ "pex0", "pex0_en", 5, 0 },
+	{ "pex1", "pex1_en", 9, 0 },
+	{ "sata0", NULL, 15, 0 },
+	{ "sdio", NULL, 17, 0 },
+	{ "tdm", NULL, 25, 0 },
+	{ "ddr", NULL, 28, CLK_IGNORE_UNUSED },
+	{ "sata1", NULL, 30, 0 },
 	{ }
 };
 #endif
 
 #ifdef CONFIG_MACH_ARMADA_XP
 static const struct mvebu_soc_descr __initconst armada_xp_gating_descr[] = {
-	{ "audio", NULL, 0 },
-	{ "ge3", NULL, 1 },
-	{ "ge2", NULL,  2 },
-	{ "ge1", NULL, 3 },
-	{ "ge0", NULL, 4 },
-	{ "pex00", NULL, 5 },
-	{ "pex01", NULL, 6 },
-	{ "pex02", NULL, 7 },
-	{ "pex03", NULL, 8 },
-	{ "pex10", NULL, 9 },
-	{ "pex11", NULL, 10 },
-	{ "pex12", NULL, 11 },
-	{ "pex13", NULL, 12 },
-	{ "bp", NULL, 13 },
-	{ "sata0lnk", NULL, 14 },
-	{ "sata0", "sata0lnk", 15 },
-	{ "lcd", NULL, 16 },
-	{ "sdio", NULL, 17 },
-	{ "usb0", NULL, 18 },
-	{ "usb1", NULL, 19 },
-	{ "usb2", NULL, 20 },
-	{ "xor0", NULL, 22 },
-	{ "crypto", NULL, 23 },
-	{ "tdm", NULL, 25 },
-	{ "pex20", NULL, 26 },
-	{ "pex30", NULL, 27 },
-	{ "xor1", NULL, 28 },
-	{ "sata1lnk", NULL, 29 },
-	{ "sata1", "sata1lnk", 30 },
+	{ "audio", NULL, 0, 0 },
+	{ "ge3", NULL, 1, 0 },
+	{ "ge2", NULL,  2, 0 },
+	{ "ge1", NULL, 3, 0 },
+	{ "ge0", NULL, 4, 0 },
+	{ "pex00", NULL, 5, 0 },
+	{ "pex01", NULL, 6, 0 },
+	{ "pex02", NULL, 7, 0 },
+	{ "pex03", NULL, 8, 0 },
+	{ "pex10", NULL, 9, 0 },
+	{ "pex11", NULL, 10, 0 },
+	{ "pex12", NULL, 11, 0 },
+	{ "pex13", NULL, 12, 0 },
+	{ "bp", NULL, 13, 0 },
+	{ "sata0lnk", NULL, 14, 0 },
+	{ "sata0", "sata0lnk", 15, 0 },
+	{ "lcd", NULL, 16, 0 },
+	{ "sdio", NULL, 17, 0 },
+	{ "usb0", NULL, 18, 0 },
+	{ "usb1", NULL, 19, 0 },
+	{ "usb2", NULL, 20, 0 },
+	{ "xor0", NULL, 22, 0 },
+	{ "crypto", NULL, 23, 0 },
+	{ "tdm", NULL, 25, 0 },
+	{ "pex20", NULL, 26, 0 },
+	{ "pex30", NULL, 27, 0 },
+	{ "xor1", NULL, 28, 0 },
+	{ "sata1lnk", NULL, 29, 0 },
+	{ "sata1", "sata1lnk", 30, 0 },
 	{ }
 };
 #endif
 
 #ifdef CONFIG_ARCH_DOVE
 static const struct mvebu_soc_descr __initconst dove_gating_descr[] = {
-	{ "usb0", NULL, 0 },
-	{ "usb1", NULL, 1 },
-	{ "ge", "gephy", 2 },
-	{ "sata", NULL, 3 },
-	{ "pex0", NULL, 4 },
-	{ "pex1", NULL, 5 },
-	{ "sdio0", NULL, 8 },
-	{ "sdio1", NULL, 9 },
-	{ "nand", NULL, 10 },
-	{ "camera", NULL, 11 },
-	{ "i2s0", NULL, 12 },
-	{ "i2s1", NULL, 13 },
-	{ "crypto", NULL, 15 },
-	{ "ac97", NULL, 21 },
-	{ "pdma", NULL, 22 },
-	{ "xor0", NULL, 23 },
-	{ "xor1", NULL, 24 },
-	{ "gephy", NULL, 30 },
+	{ "usb0", NULL, 0, 0 },
+	{ "usb1", NULL, 1, 0 },
+	{ "ge", "gephy", 2, 0 },
+	{ "sata", NULL, 3, 0 },
+	{ "pex0", NULL, 4, 0 },
+	{ "pex1", NULL, 5, 0 },
+	{ "sdio0", NULL, 8, 0 },
+	{ "sdio1", NULL, 9, 0 },
+	{ "nand", NULL, 10, 0 },
+	{ "camera", NULL, 11, 0 },
+	{ "i2s0", NULL, 12, 0 },
+	{ "i2s1", NULL, 13, 0 },
+	{ "crypto", NULL, 15, 0 },
+	{ "ac97", NULL, 21, 0 },
+	{ "pdma", NULL, 22, 0 },
+	{ "xor0", NULL, 23, 0 },
+	{ "xor1", NULL, 24, 0 },
+	{ "gephy", NULL, 30, 0 },
 	{ }
 };
 #endif
 
 #ifdef CONFIG_ARCH_KIRKWOOD
 static const struct mvebu_soc_descr __initconst kirkwood_gating_descr[] = {
-	{ "ge0", NULL, 0 },
-	{ "pex0", NULL, 2 },
-	{ "usb0", NULL, 3 },
-	{ "sdio", NULL, 4 },
-	{ "tsu", NULL, 5 },
-	{ "runit", NULL, 7 },
-	{ "xor0", NULL, 8 },
-	{ "audio", NULL, 9 },
-	{ "powersave", "cpuclk", 11 },
-	{ "sata0", NULL, 14 },
-	{ "sata1", NULL, 15 },
-	{ "xor1", NULL, 16 },
-	{ "crypto", NULL, 17 },
-	{ "pex1", NULL, 18 },
-	{ "ge1", NULL, 19 },
-	{ "tdm", NULL, 20 },
+	{ "ge0", NULL, 0, 0 },
+	{ "pex0", NULL, 2, 0 },
+	{ "usb0", NULL, 3, 0 },
+	{ "sdio", NULL, 4, 0 },
+	{ "tsu", NULL, 5, 0 },
+	{ "runit", NULL, 7, 0 },
+	{ "xor0", NULL, 8, 0 },
+	{ "audio", NULL, 9, 0 },
+	{ "powersave", "cpuclk", 11, 0 },
+	{ "sata0", NULL, 14, 0 },
+	{ "sata1", NULL, 15, 0 },
+	{ "xor1", NULL, 16, 0 },
+	{ "crypto", NULL, 17, 0 },
+	{ "pex1", NULL, 18, 0 },
+	{ "ge1", NULL, 19, 0 },
+	{ "tdm", NULL, 20, 0 },
 	{ }
 };
 #endif
