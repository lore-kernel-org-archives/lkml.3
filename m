Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab3BMGM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 01:12:58 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10006 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3BMGM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 01:12:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 12 Feb 2013 22:12:45 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>
CC: "arnd@arndb.de" <arnd@arndb.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "marvin24@gmx.de" <marvin24@gmx.de>, "balbi@ti.com" <balbi@ti.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 13 Feb 2013 07:12:40 +0100
Subject: Re: [v2 3/3] ARM: tegra: Unify Device tree board files
Thread-Topic: [v2 3/3] ARM: tegra: Unify Device tree board files
Thread-Index: Ac4JsSIpDZs4WPVVQTeuOL1vTFW61w==
Message-ID: <20130213.081240.1605796167151164030.hdoyu@nvidia.com>
References: <20130212.070456.532657136988541923.hdoyu@nvidia.com><201302121350.15683.arnd@arndb.de><511A6F6C.8090205@wwwdotorg.org>
In-Reply-To: <511A6F6C.8090205@wwwdotorg.org>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Warren <swarren@wwwdotorg.org> wrote @ Tue, 12 Feb 2013 17:35:56 +0100:

> However I'd like to avoid changing the body of those two functions at
> all if possible, since I hope the PCIe driver rework will be merged in
> 3.10, and that will allow the Harmony and TrimSlice init functions to be
> removed entirely. I'd rather not have conflicts with the removal patch.
> 
> > Since we are not going to add any other board specfic init functions, you
> > can also unroll the loop and put everything into tegra_dt_init_late:
> 
> That's not necessarily true. While we certainly don't plan to, I don't
> think we can rule it out; after all, we don't have rfkill bindings and
> yet other boards will need them.

Considering the above points,

- The Harmony and TrimSlice init functions will be removed entirely
  so soon that we want to avoid those merge conflicts as much as
  possible.
- We may still need board specific init, especially for rfkill.
- We want to build any combination of Tegra{20,30,114}, 2^3 - 1 == 7.

The patch for "tegra.c" would be as below.

Should I still keep the name, "tegra20_auxdata_lookup" to avoid
any conflicts or "tegra_auxdata_lookup" would be ok for merge?

diff --git a/arch/arm/mach-tegra/tegra.c b/arch/arm/mach-tegra/tegra.c
index fca18e9..fd4412d 100644
--- a/arch/arm/mach-tegra/tegra.c
+++ b/arch/arm/mach-tegra/tegra.c
@@ -1,6 +1,7 @@
 /*
- * nVidia Tegra device tree board support
+ * NVIDIA Tegra SoC device tree board support
  *
+ * Copyright (C) 2011, 2013, NVIDIA Corporation
  * Copyright (C) 2010 Secret Lab Technologies, Ltd.
  * Copyright (C) 2010 Google, Inc.
  *
@@ -67,7 +68,7 @@ static struct tegra_ehci_platform_data tegra_ehci3_pdata = {
 	.vbus_gpio = -1,
 };
 
-static struct of_dev_auxdata tegra20_auxdata_lookup[] __initdata = {
+static struct of_dev_auxdata tegra_auxdata_lookup[] __initdata = {
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5000000, "tegra-ehci.0",
 		       &tegra_ehci1_pdata),
 	OF_DEV_AUXDATA("nvidia,tegra20-ehci", 0xC5004000, "tegra-ehci.1",
@@ -84,7 +85,7 @@ static void __init tegra_dt_init(void)
 	 * devices
 	 */
 	of_platform_populate(NULL, of_default_bus_match_table,
-				tegra20_auxdata_lookup, NULL);
+				tegra_auxdata_lookup, NULL);
 }
 
 static void __init trimslice_init(void)
@@ -111,7 +112,8 @@ static void __init harmony_init(void)
 
 static void __init paz00_init(void)
 {
-	tegra_paz00_wifikill_init();
+	if (IS_ENABLED(CONFIG_ARCH_TEGRA_2x_SOC))
+		tegra_paz00_wifikill_init();
 }
 
 static struct {
@@ -137,12 +139,14 @@ static void __init tegra_dt_init_late(void)
 	}
 }
 
-static const char *tegra20_dt_board_compat[] = {
+static const char * const tegra_dt_board_compat[] = {
+	"nvidia,tegra114",
+	"nvidia,tegra30",
 	"nvidia,tegra20",
 	NULL
 };
 
-DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
+DT_MACHINE_START(TEGRA_DT, "NVIDIA Tegra SoC (Flattened Device Tree)")
 	.map_io		= tegra_map_common_io,
 	.smp		= smp_ops(tegra_smp_ops),
 	.init_early	= tegra_init_early,
@@ -151,5 +155,5 @@ DT_MACHINE_START(TEGRA_DT, "nVidia Tegra20 (Flattened Device Tree)")
 	.init_machine	= tegra_dt_init,
 	.init_late	= tegra_dt_init_late,
 	.restart	= tegra_assert_system_reset,
-	.dt_compat	= tegra20_dt_board_compat,
+	.dt_compat	= tegra_dt_board_compat,
 MACHINE_END
-- 
1.7.9.5
