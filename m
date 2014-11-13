Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbaKMRDI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:03:08 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:48873 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543AbaKMRDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:03:04 -0500
X-AuditID: cbfee61a-f79c06d000004e71-44-5464e44579e8
From: Lukasz Majewski <l.majewski@samsung.com>
To: Eduardo Valentin <edubezval@gmail.com>, Zhang Rui <rui.zhang@intel.com>
Cc: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lukasz Majewski <l.majewski@samsung.com>
Subject: [PATCH 0/8] thermal:cpu cooling:fix: Provide thermal core fixes with
 deferred probe for several drivers
Date: Thu, 13 Nov 2014 18:02:37 +0100
Message-id: <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
X-Mailer: git-send-email 1.7.10.4
In-reply-to: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsVy+t9jQV3XJykhBmuXK1tsnLGe1WL+lWus
	FqdPLWC1OPfqEYvF2+Zii1eHdzFavHnEbfHm4WZGi8u75rBZfO49wmjR+WUWm8WDq9PYLJ48
	7GOzeHWwjcXi5655LBbHTsxgdRDweLLpIqPHzll32T0W73nJ5LFu2ltmjwOTz7F69Da/Y/P4
	dmYii0ffllWMHk9/7GX2+LxJzmPj3NAA7igum5TUnMyy1CJ9uwSujCundjIVTJWpuLHjOFMD
	41TRLkZODgkBE4n3n84xQdhiEhfurWfrYuTiEBKYzigxZ9dfKKeLSeL/43dsIFVsAnoSn+8+
	BesQEfCWeL1vOiNIEbPAaxaJQz8a2EESwgJFEiveXmQGsVkEVCV+z1/JCGLzCrhJTFm2jxli
	naJE97MJYEM5Bdwlbv5+BtYrBFRz8NdB9gmMvAsYGVYxiqYWJBcUJ6XnGuoVJ+YWl+al6yXn
	525iBAf6M6kdjCsbLA4xCnAwKvHwvmBJCRFiTSwrrsw9xCjBwawkwlt9HyjEm5JYWZValB9f
	VJqTWnyIUZqDRUmc90CrdaCQQHpiSWp2ampBahFMlomDU6qBMXRphLAq+5GstYbWz2xSzp61
	LrJ7552c2d9ltLlqSdaa7JQjkhYrTl7lfXBm90IVbonwft/ez57WX/xTN2vwL+L6cW2ifHhi
	1Hf12qVxbA4G+ifPr1XdlbGQdcrW1ojNzYqXdhxbtKWk8kHLbDHhl2sWH/sZLrY1bs+Zpef3
	Vs9/7F+zzKNMTomlOCPRUIu5qDgRAIdfMTZwAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Presented fixes are a response for problem described below:
http://thread.gmane.org/gmane.linux.kernel/1793821/match=thermal+core+fix+initialize+max_state+variable+0

In short - it turned out that two trivial fixes (included in this patch set)
require support for deferred probe in thermal drivers.

This situation shows up when CPU frequency reduction is used as a thermal cooling
device for a thermal zone.
It happens that during initialization, the call to thermal probe will be executed
before cpufreq probe (it can be observed at ./drivers/Makefile).
In such a situation thermal will not be properly configured until cpufreq policy
is setup.

In the current code (without included fixes) there is a time window in which thermal
can try to use not configured cpufreq and possibly crash the system.


Proposed solution was based on the code already available in the imx_thermal.c file.

/db8500_thermal.c:                      -> NOT NEEDED
/intel_powerclamp.c:                    -> NOT NEEDED - INTEL (x86)
/intel_powerclamp.c:                    -> NOT NEEDED - INTEL (x86)
/ti-soc-thermal/ti-bandgap.c:           -> FIXED  [omap2plus_defconfig]
/dove_thermal.c:                        -> NOT NEEDED - CPU_COOLING NOT AVAILABLE
                                                        [dove_defconfig]
/spear_thermal.c:                       -> FIXED  [spear3xx_defconfig]
/samsung/exynos_tmu.c:                  -> NOT NEEDED (nasty hack - will be reworked in later patches)
/imx_thermal.c:                         -> OK (deferred probe already in place)
/int340x_thermal/int3402_thermal.c:     -> NOT NEEDED - ACPI x86 - Intel specific
/int340x_thermal/int3400_thermal.c:     -> NOT NEEDED - ACPI x86 - Intel specific
/tegra_soctherm.c:                      -> FIXED  [tegra_defconfig]
/kirkwood_thermal.c:                    -> FIXED  [multi_v5_defconfig]
/armada_thermal.c:                      -> FIXED  [multi_v7_defconfig]
/rcar_thermal.c:                        -> FIXED  [shmobile_defconfig]
/db8500_cpufreq_cooling.c:              -> OK (deferred probe already in place) [multi_v7_defconfig]
/st/st_thermal_syscfg.c:                -> NOT NEEDED (Those two are enabled by e.g. ARMADA)
/st/st_thermal_memmap.c:


I only possess Exynos boards and Beagle Bone Black, so I'd be grateful for
testing proposed solution on other boards. The posted code is compile tested.

This code applies on Eduardo's ti-soc-thermal-next tree:
SHA1: 208a97042d66d9bfbcfab0d4a00c9fe317bb73d3

Lukasz Majewski (8):
  thermal:cpu cooling:armada: Provide deferred probing for armada driver
  thermal:cpu cooling:kirkwood: Provide deferred probing for kirkwood
    driver
  thermal:cpu cooling:rcar: Provide deferred probing for rcar driver
  thermal:cpu cooling:spear: Provide deferred probing for spear driver
  thermal:cpu cooling:tegra: Provide deferred probing for tegra driver
  thermal:cpu cooling:ti: Provide deferred probing for ti drivers
  thermal:core:fix: Initialize the max_state variable to 0
  thermal:core:fix: Check return code of the ->get_max_state() callback

 drivers/thermal/armada_thermal.c            | 7 +++++++
 drivers/thermal/kirkwood_thermal.c          | 7 +++++++
 drivers/thermal/rcar_thermal.c              | 7 +++++++
 drivers/thermal/spear_thermal.c             | 7 +++++++
 drivers/thermal/tegra_soctherm.c            | 7 +++++++
 drivers/thermal/thermal_core.c              | 8 +++++---
 drivers/thermal/ti-soc-thermal/ti-bandgap.c | 7 +++++++
 7 files changed, 47 insertions(+), 3 deletions(-)

-- 
2.0.0.rc2

