Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758592Ab3DLWzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 18:55:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:50155 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab3DLWzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 18:55:05 -0400
From: Nishanth Menon <nm@ti.com>
To: <linux-omap@vger.kernel.org>
CC: <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <b-cousson@ti.com>,
        Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Mike Turquette <mturquette@linaro.org>, Nishanth Menon <nm@ti.com>
Subject: [PATCH V4 0/6] ARM: OMAP3+: support cpufreq-cpu0 for device tree boot
Date: Fri, 12 Apr 2013 17:54:32 -0500
Message-ID: <1365807278-554-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following version 4 of the series arose from trying to use BeagleBoard-XM
(OMAP3 variant) for doing CPU DVFS using cpufreq-cpu0. This series enables the
generic cpufreq-cpu0 driver to be used in device tree enabled boot while
maintaining support of the legacy omap-cpufreq driver when used in non device
tree enabled boot.

However, in order to enable complete SoC entitlement for OMAP platforms, with
this series, key features are still pending on device tree adaptation for OMAP:
A) clock framework data transition to DT - this should happen soon, so this
series hacks the clock node for the time being as suggested in review of
original series[1].
B) On processors that use voltage controller, voltage processor (VC/VP hardware
loop using I2C_SR path) - we have started work on transitioning them to
regulator framework driven by DT.
C) Adaptive Body Bias and SmartReflex AVS conversion to DT. [2]

Note: At this point in time, we do not have DT entries for clock on OMAP
platforms. Common Clock Framework(CCF) could also control regulators[3].
Once these conversions are complete, there might be minimal cleanup work to
switch to the new data structure changes.

Key benefit of the series is to allow all relevant TI platforms now to use a
single cpufreq driver and equivalent frameworks in addition be part of the
transition to device tree.
NOTE: As a result of this series:
1. omap-cpufreq will be used only in non device tree boot scenario. we should
   delete this driver once the 100% DT conversion is complete.
2. Generic cpufreq-cpu0 will be used only in device tree boot scenario.
   boot systems.

Key changes in version 4 since version 3:
	- OMAP clock driver introduced as discussed in
		http://marc.info/?t=136370325600009&r=1&w=2
	- cpufreq-cpu0 dummy device introduced in pm.c late_initcall: discussed
	  in http://marc.info/?t=136450773400004&r=1&w=2
	- updated test script (prints regulator voltage where available)
	- parts of the series probably belong to different maintainer:
	  consolidated as a single series to aid review in-context.

version 3 of the series:
	http://marc.info/?l=linux-pm&m=136450759315742&w=2
	available at:
	http://git.kernel.org/cgit/linux/kernel/git/bcousson/linux-omap-dt.git/log/?h=for_3.10/dts

version 2 of the series:
	http://marc.info/?t=136371570200003&r=1&w=2
	available at:
	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v2

version 1 of the series:
	http://marc.info/?t=136329485400005&r=1&w=2
	available at:
	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v1

[1] Original discussion thread which triggered this series:
	http://marc.info/?l=linux-pm&m=136304313700602&w=2
	https://patchwork.kernel.org/patch/2251841/
	https://patchwork.kernel.org/patch/2251851/
[2] ABB RFC: http://marc.info/?l=linux-omap&m=136449099409794&w=2 
[3] CCF DVFS patches:
https://patchwork.kernel.org/patch/2195431/
https://patchwork.kernel.org/patch/2195421/
https://patchwork.kernel.org/patch/2195451/
https://patchwork.kernel.org/patch/2195441/
https://patchwork.kernel.org/patch/2195461/

Version 4 is now based on a few branches to prevent merge conflicts(v3.9-rc6):
	git://git.linaro.org/people/mturquette/linux.git
		clk-next 38e4aa0 clk: sunxi: Unify oscillator clock
	git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
		linux-next 584fa10 Merge branch 'pm-runtime-next'
	git://git.kernel.org/pub/scm/linux/kernel/git/bcousson/linux-omap-dt.git
		for_3.10/dts 1fac4ff ARM: dts: Add OMAP3430
	(merged branch is called baseline-v4 on my tree)

Version 4 is also available at:
	https://github.com/nmenon/linux-2.6-playground/commits/push/cpufreq-cpu0-omap-all-v4
	git link: git://github.com/nmenon/linux-2.6-playground.git
	branch: cpufreq-cpu0-omap-all-v4

Test coverage:
	test script: http://pastebin.com/z4yqZrBg
Platforms verified:
	beaglebone(rev A6a) - AM33xx compatible - http://pastebin.com/YnSNiTnx
	beagleboard (rev C1D) - OMAP3430 compatible
		- DT enabled boot: http://pastebin.com/eGaDD3B4
		- No DT enabled boot: http://pastebin.com/5xqsNBA6
	omap3-beagle-xm -OMAP3630 compatible - http://pastebin.com/FdrG4Rna
	Pandaboard -(OMAP4430 ES2.1) - http://pastebin.com/1jjSRKQh
	Pandaboard-ES -(OMAP4460 ES1.1) - http://pastebin.com/B5acTbch

Nishanth Menon (6):
  clk: OMAP: introduce device tree binding to kernel clock data
[Clk probably belongs to mike's tree?]
  ARM: dts: OMAP3: add clock nodes for CPU
  ARM: dts: OMAP4: add clock nodes for CPU
  ARM: dts: AM33XX: add clock nodes for CPU
[The above probably belong to Benoit's tree]
  ARM: OMAP2+: AM33XX: add lateinit hook for calling pm late init
  ARM: OMAP3+: use cpu0-cpufreq driver in device tree supported boot
[The above probably belong to Kevin/Tony's tree]

 .../devicetree/bindings/clock/omap-clock.txt       |   40 ++++++++
 arch/arm/boot/dts/am33xx.dtsi                      |    7 ++
 arch/arm/boot/dts/omap3.dtsi                       |    7 ++
 arch/arm/boot/dts/omap4.dtsi                       |    7 ++
 arch/arm/mach-omap2/board-generic.c                |    1 +
 arch/arm/mach-omap2/cclock33xx_data.c              |    1 -
 arch/arm/mach-omap2/common.h                       |    1 +
 arch/arm/mach-omap2/io.c                           |    6 ++
 arch/arm/mach-omap2/pm.c                           |   11 ++-
 drivers/clk/Makefile                               |    1 +
 drivers/clk/omap/Makefile                          |    1 +
 drivers/clk/omap/clk.c                             |   96 ++++++++++++++++++++
 12 files changed, 175 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/omap-clock.txt
 create mode 100644 drivers/clk/omap/Makefile
 create mode 100644 drivers/clk/omap/clk.c

Regards,
Nishanth Menon
-- 
1.7.9.5

