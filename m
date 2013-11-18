Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3KRLpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 06:45:40 -0500
Received: from mail-out.m-online.net ([212.18.0.10]:34072 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab3KRLpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 06:45:34 -0500
X-Auth-Info: 90WDVQ9kBSWOnyluMd3mJ6AENb9Oh2XZ3yDKrE/ejjk=
Date: Mon, 18 Nov 2013 12:45:28 +0100
From: Gerhard Sittig <gsi@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>
Subject: checkpatch.pl "Use of uninitialized value" warnings
Message-ID: <20131118114528.GJ17929@book.gsilab.sittig.org>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Joe Perches <joe@perches.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="1SQmhf2mF2YjsYvc"
Content-Disposition: inline
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Please tell me when the Cc: list is inappropriate, it appears
that get_maintainer.pl does not know of a maintainer for the
checkpatch.pl script, but lists you as the most active
committers.


Execution of the checkpatch.pl script (v3.12 kernel tree) emitted
the following messages when fed with the attached patch.

  Use of uninitialized value $c in pattern match (m//) at ./scripts/checkpatch.pl line 3280.
  Use of uninitialized value in substr at ./scripts/checkpatch.pl line 3287.
  Use of uninitialized value $s in substr at ./scripts/checkpatch.pl line 3287.
  total: 0 errors, 0 warnings, 0 checks, 185 lines checked

The patch is not inlined, to keep its formatting in verbatim
form, and was sent to the linuxppc-dev@lists.ozlabs.org and
linux-arm-kernel@lists.infradead.org mailing lists with
Message-ID <1384729577-7336-6-git-send-email-gsi@denx.de> on
Mon, 18 Nov 2013 00:06:05 +0100 if that's easier to lookup or in
case the attachment won't pass email filters).

The offending part of the code appears to be the NODE_CHK() macro
spanning lines 68 to 82 of the patch, while the FOR_NODES() and
PREP_NODE() macros don't have issues.

What can I do to help diagnose and fix the warnings?


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de

--1SQmhf2mF2YjsYvc
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0005-clk-mpc512x-add-backwards-compat-to-the-CCF-code.patch"

>From dcd03deec6ec87164f0d5114f6b3b705798c9e00 Mon Sep 17 00:00:00 2001
From: Gerhard Sittig <gsi@denx.de>
Date: Sat, 9 Nov 2013 21:40:05 +0100
Subject: [PATCH v5 05/17] clk: mpc512x: add backwards compat to the CCF code

extend the recently added COMMON_CLK platform support for MPC512x such
that it works with incomplete device tree data which lacks clock specs

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Anatolij Gustschin <agust@denx.de>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Gerhard Sittig <gsi@denx.de>
---
 arch/powerpc/platforms/512x/clock-commonclk.c |  173 ++++++++++++++++++++++++-
 1 file changed, 172 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/512x/clock-commonclk.c b/arch/powerpc/platforms/512x/clock-commonclk.c
index ddbeaec79246..c1faf3a9ea1f 100644
--- a/arch/powerpc/platforms/512x/clock-commonclk.c
+++ b/arch/powerpc/platforms/512x/clock-commonclk.c
@@ -11,6 +11,7 @@
  * (at your option) any later version.
  */
 
+#include <linux/bitops.h>
 #include <linux/clk-provider.h>
 #include <linux/clkdev.h>
 #include <linux/device.h>
@@ -744,7 +745,177 @@ static void mpc5121_clk_provide_migration_support(void)
  */
 static void mpc5121_clk_provide_backwards_compat(void)
 {
-	/* TODO */
+	enum did_reg_flags {
+		DID_REG_PSC	= BIT(0),
+		DID_REG_PSCFIFO	= BIT(1),
+		DID_REG_NFC	= BIT(2),
+		DID_REG_CAN	= BIT(3),
+		DID_REG_I2C	= BIT(4),
+		DID_REG_DIU	= BIT(5),
+		DID_REG_VIU	= BIT(6),
+		DID_REG_FEC	= BIT(7),
+		DID_REG_USB	= BIT(8),
+		DID_REG_PATA	= BIT(9),
+	};
+
+	int did_register;
+	struct device_node *np;
+	struct resource res;
+	int idx;
+	char devname[32];
+
+	/*
+	 * those macros are not exactly pretty, but they encapsulate a lot
+	 * of copy'n'paste heavy code which is even more ugly, and reduce
+	 * the potential for inconsistencies in those many code copies
+	 */
+
+#define FOR_NODES(compatname) \
+	for_each_compatible_node(np, NULL, compatname)
+
+#define NODE_PREP do { \
+	of_address_to_resource(np, 0, &res); \
+	snprintf(devname, sizeof(devname), "%08x.%s", res.start, np->name); \
+} while (0)
+
+#define NODE_CHK(clkname, clkitem, regnode, regflag) do { \
+	struct clk *clk; \
+	clk = of_clk_get_by_name(np, clkname); \
+	if (IS_ERR(clk)) { \
+		clk = clkitem; \
+		clk_register_clkdev(clk, clkname, devname); \
+		if (regnode) \
+			clk_register_clkdev(clk, clkname, np->name); \
+		did_register |= DID_REG_ ## regflag; \
+		pr_debug("clock alias name '%s' for dev '%s' pointer %p\n", \
+			 clkname, devname, clk); \
+	} else { \
+		clk_put(clk); \
+	} \
+} while (0)
+
+	did_register = 0;
+
+	FOR_NODES(mpc512x_select_psc_compat()) {
+		NODE_PREP;
+		idx = (res.start >> 8) & 0xf;
+		NODE_CHK("ipg", clks[MPC512x_CLK_PSC0 + idx], 0, PSC);
+		NODE_CHK("mclk", clks[MPC512x_CLK_PSC0_MCLK + idx], 0, PSC);
+	}
+
+	FOR_NODES("fsl,mpc5121-psc-fifo") {
+		NODE_PREP;
+		NODE_CHK("ipg", clks[MPC512x_CLK_PSC_FIFO], 1, PSCFIFO);
+	}
+
+	FOR_NODES("fsl,mpc5121-nfc") {
+		NODE_PREP;
+		NODE_CHK("ipg", clks[MPC512x_CLK_NFC], 0, NFC);
+	}
+
+	FOR_NODES("fsl,mpc5121-mscan") {
+		NODE_PREP;
+		idx = 0;
+		idx += (res.start & 0x2000) ? 2 : 0;
+		idx += (res.start & 0x0080) ? 1 : 0;
+		NODE_CHK("ipg", clks[MPC512x_CLK_BDLC], 0, CAN);
+		NODE_CHK("mclk", clks[MPC512x_CLK_MSCAN0_MCLK + idx], 0, CAN);
+	}
+
+	/*
+	 * do register the 'ips', 'sys', and 'ref' names globally
+	 * instead of inside each individual CAN node, as there is no
+	 * potential for a name conflict (in contrast to 'ipg' and 'mclk')
+	 */
+	if (did_register & DID_REG_CAN) {
+		clk_register_clkdev(clks[MPC512x_CLK_IPS], "ips", NULL);
+		clk_register_clkdev(clks[MPC512x_CLK_SYS], "sys", NULL);
+		clk_register_clkdev(clks[MPC512x_CLK_REF], "ref", NULL);
+	}
+
+	FOR_NODES("fsl,mpc5121-i2c") {
+		NODE_PREP;
+		NODE_CHK("ipg", clks[MPC512x_CLK_I2C], 0, I2C);
+	}
+
+	/*
+	 * workaround for the fact that the I2C driver does an "anonymous"
+	 * lookup (NULL name spec, which yields the first clock spec) for
+	 * which we cannot register an alias -- a _global_ 'ipg' alias that
+	 * is not bound to any device name and returns the I2C clock item
+	 * is not a good idea
+	 *
+	 * so we have the lookup in the peripheral driver fail, which is
+	 * silent and non-fatal, and pre-enable the clock item here such
+	 * that register access is possible
+	 *
+	 * see commit b3bfce2b "i2c: mpc: cleanup clock API use" for
+	 * details, adjusting s/NULL/"ipg"/ in i2c-mpc.c would make this
+	 * workaround obsolete
+	 */
+	if (did_register & DID_REG_I2C)
+		clk_prepare_enable(clks[MPC512x_CLK_I2C]);
+
+	FOR_NODES("fsl,mpc5121-diu") {
+		NODE_PREP;
+		NODE_CHK("ipg", clks[MPC512x_CLK_DIU], 1, DIU);
+	}
+
+	FOR_NODES("fsl,mpc5121-viu") {
+		NODE_PREP;
+		NODE_CHK("ipg", clks[MPC512x_CLK_VIU], 0, VIU);
+	}
+
+	/*
+	 * note that 2771399a "fs_enet: cleanup clock API use" did use the
+	 * "per" string for the clock lookup in contrast to the "ipg" name
+	 * which most other nodes are using -- this is not a fatal thing
+	 * but just something to keep in mind when doing compatibility
+	 * registration, it's a non-issue with up-to-date device tree data
+	 */
+	FOR_NODES("fsl,mpc5121-fec") {
+		NODE_PREP;
+		NODE_CHK("per", clks[MPC512x_CLK_FEC], 0, FEC);
+	}
+	FOR_NODES("fsl,mpc5121-fec-mdio") {
+		NODE_PREP;
+		NODE_CHK("per", clks[MPC512x_CLK_FEC], 0, FEC);
+	}
+
+	FOR_NODES("fsl,mpc5121-usb2-dr") {
+		NODE_PREP;
+		idx = (res.start & 0x4000) ? 1 : 0;
+		NODE_CHK("ipg", clks[MPC512x_CLK_USB1 + idx], 0, USB);
+	}
+
+	FOR_NODES("fsl,mpc5121-pata") {
+		NODE_PREP;
+		NODE_CHK("ipg", clks[MPC512x_CLK_PATA], 0, PATA);
+	}
+
+	/*
+	 * try to collapse diagnostics into a single line of output yet
+	 * provide a full list of what is missing, to avoid noise in the
+	 * absence of up-to-date device tree data -- backwards
+	 * compatibility to old DTBs is a requirement, updates may be
+	 * desirable or preferrable but are not at all mandatory
+	 */
+	if (did_register) {
+		pr_notice("device tree lacks clock specs, adding fallbacks (0x%x,%s%s%s%s%s%s%s%s%s%s)\n",
+			  did_register,
+			  (did_register & DID_REG_PSC) ? " PSC" : "",
+			  (did_register & DID_REG_PSCFIFO) ? " PSCFIFO" : "",
+			  (did_register & DID_REG_NFC) ? " NFC" : "",
+			  (did_register & DID_REG_CAN) ? " CAN" : "",
+			  (did_register & DID_REG_I2C) ? " I2C" : "",
+			  (did_register & DID_REG_DIU) ? " DIU" : "",
+			  (did_register & DID_REG_VIU) ? " VIU" : "",
+			  (did_register & DID_REG_FEC) ? " FEC" : "",
+			  (did_register & DID_REG_USB) ? " USB" : "",
+			  (did_register & DID_REG_PATA) ? " PATA" : "");
+	} else {
+		pr_debug("device tree has clock specs, no fallbacks added\n");
+	}
 }
 
 int __init mpc5121_clk_init(void)
-- 
1.7.10.4


--1SQmhf2mF2YjsYvc--
