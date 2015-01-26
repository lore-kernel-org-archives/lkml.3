Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbbAZKK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:10:26 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:52725 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744AbbAZKKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:10:23 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: <nicolas.ferre@atmel.com>, <linux@arm.linux.org.uk>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <alexandre.belloni@free-electrons.com>, <sylvain.rochet@finsecur.com>,
        <peda@axentia.se>, <wenyou.yang@atmel.com>,
        <Patrice.VILCHEZ@atmel.com>
Subject: [PATCH 6/7] pm: at91: add achieve the mpddrc peripheral ID and the DDR clock ID support
Date: Mon, 26 Jan 2015 18:08:16 +0800
Message-ID: <1422266896-24666-1-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
References: <1422266617-24381-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch achieves the mpddr controller peripheral ID
and the DDR clock ID from the dts file.

They will be used in the future to disable the mpddr controller'c clock
the and DDR clock to decrease the power consumption during suspending.

Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
---
 arch/arm/mach-at91/generic.h |    2 ++
 arch/arm/mach-at91/setup.c   |   24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/arch/arm/mach-at91/generic.h b/arch/arm/mach-at91/generic.h
index 41796bf..3c72a3e 100644
--- a/arch/arm/mach-at91/generic.h
+++ b/arch/arm/mach-at91/generic.h
@@ -47,6 +47,8 @@ void __init at91_sam9x5_pm_init(void) { }
 struct at91_pm_struct {
 	unsigned long uhp_udp_mask;
 	int memctrl;
+	u32 mpddrc_id[2];
+	u32 ddrck_id;
 };
 
 #endif /* _AT91_GENERIC_H */
diff --git a/arch/arm/mach-at91/setup.c b/arch/arm/mach-at91/setup.c
index 7924663..a306f95 100644
--- a/arch/arm/mach-at91/setup.c
+++ b/arch/arm/mach-at91/setup.c
@@ -363,6 +363,27 @@ void __init at91_ioremap_matrix(u32 base_addr)
 		panic(pr_fmt("Impossible to ioremap at91_matrix_base\n"));
 }
 
+static u32 at91_of_get_ddr_id(struct device_node *np, char *name)
+{
+	struct of_phandle_args clkspec;
+	u32 id;
+	int index;
+	int rc;
+
+	index = of_property_match_string(np, "clock-names", name);
+	rc = of_parse_phandle_with_args(np, "clocks", "#clock-cells", index, &clkspec);
+	if (rc)
+		return 0;
+
+	rc = of_property_read_u32(clkspec.np, "reg", &id);
+	if (rc)
+		return 0;
+
+	of_node_put(clkspec.np);
+
+	return id;
+}
+
 struct at91_ramc_of_data {
 	u8 ramc_type;
 };
@@ -400,6 +421,9 @@ static void at91_dt_ramc(void)
 		of_data = of_id->data;
 		at91_pm_data.memctrl = of_data->ramc_type;
 
+		at91_pm_data.mpddrc_id[idx] = at91_of_get_ddr_id(np, "mpddr");
+		at91_pm_data.ddrck_id = at91_of_get_ddr_id(np, "ddrck");
+
 		idx++;
 	}
 
-- 
1.7.9.5

