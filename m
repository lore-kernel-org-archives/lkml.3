Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030214AbaFXQJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 12:09:37 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:17343 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965173AbaFXQJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 12:09:34 -0400
X-AuditID: cbfec7f5-b7f626d000004b39-8e-53a9a2bbbd94
From: Tomasz Figa <t.figa@samsung.com>
To: linux-samsung-soc@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pankaj Dubey <pankaj.dubey@samsung.com>,
        Rahul Sharma <rahul.sharma@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Daniel Drake <drake@endlessm.com>, Tomasz Figa <tomasz.figa@gmail.com>,
        Tomasz Figa <t.figa@samsung.com>
Subject: [PATCH v2 0/4] Add support for Exynos clock output configuration
Date: Tue, 24 Jun 2014 18:08:23 +0200
Message-id: <1403626107-12073-1-git-send-email-t.figa@samsung.com>
X-Mailer: git-send-email 1.9.3
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprMLMWRmVeSWpSXmKPExsVy+t/xK7q7F60MNuh8rWwx9eETNotH8x8z
	W/QuuMpmsenxNVaLy7vmsFnMOL+PyWLtkbvsFkuvX2SyeDrhIpvFoq1f2C2mLDrMatG69wi7
	xeE37awW62e8ZrFYtesPowO/x5p5axg9Fn3P8tg56y67x6ZVnWwed67tYfPYvKTeo2/LKkaP
	z5vkAjiiuGxSUnMyy1KL9O0SuDK6zu5kKfgvWrF7zne2BsZnAl2MnBwSAiYSe6b/ZYWwxSQu
	3FvP1sXIxSEksJRRYs/ep4wQTh+TxNPd11hAqtgE1CQ+NzxiA7FFBFQlPrctYAcpYhZYwCKx
	8dVMIIeDQ1jAU+JtYwFIDQtQzf45newgNq+Ak8S67YfYIbbJSfRue8M8gZF7ASPDKkbR1NLk
	guKk9FwjveLE3OLSvHS95PzcTYyQgPy6g3HpMatDjAIcjEo8vBU7VgQLsSaWFVfmHmKU4GBW
	EuE17V4ZLMSbklhZlVqUH19UmpNafIiRiYNTqoHRQ5UztW6VraEkq8+5b03X5i5w+L0ntfb0
	rjW2AjM+NvtPlr16/o+CbgbrWZE9t4zKo03mzVqXueT8fx8z79BFNfKNhQq/b1X/SrzbPqVL
	1/iKiXXj0hN/DV/t7n13oOKZ8vEN2x7tt/iprJWd7S7IuEttFf/il2qHqzQ/83cITNx01lyI
	+WSSEktxRqKhFnNRcSIAmqRyxCYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On all Exynos SoCs there is a dedicated CLKOUT pin that allows many of
internal SoC clocks to be output from the SoC. The hardware structure
of CLKOUT related clocks looks as follows:

	CMU	|---> clock0 --------->	|	PMU	|
		|			|		|
    several	|---> clock1 ---------> |	mux	|
    muxes	|			|	+	|---> CLKOUT
    dividers	|       ...		|	gate	|
    and gates	|			|		|
		|---> clockN ---------> |		|

Since the block responsible for handling the pin is PMU, not CMU,
a separate driver, that binds to PMU node is required and acquires
all input clocks by standard DT clock look-up. This way we don't need
any cross-IP block drivers and cross-driver register sharing or
nodes for fake devices.

To represent the PMU mux/gate clock, generic composite clock is registered.

Tested on Odroid U3, with HSIC/USB hub using CLKOUT as reference clock,
with some additional patches.

Changes since v1:
(http://www.spinics.net/lists/arm-kernel/msg333276.html)
 - rebased onto next-20140624,
 - fixed #clock-cells values in exynos5250.dtsi and exynos5420.dtsi,
 - temporarily removed ISP CLKOUT clocks on Exynos4x12, until ISP clock
   domain handling gets fixed in Exynos4 clock driver.
Changes since RFC v1:
(https://lkml.org/lkml/2014/5/15/506)
 - rebased onto v5 of "Enable usbphy and hsotg for exynos4" series and
   current HEAD of samsung-clk tree,
 - added handling of suspend/resume in the driver,
 - added missing CPU clocks on Exynos4,
 - added CLK_SET_RATE_PARENT to CMU CLKOUT gates on Exynos4,
 - fixed bit field width on Exynos4,
 - added CLKOUT CMU registers of Exynos4 to save/restore list,
 - added CLK_SET_RATE_PARENT and CLK_SET_RATE_NO_REPARENT to clkout clock,
 - changed the binding to use 1-cell clock specifier to allow extension
   with further PMU clocks in future, if needed.

Tomasz Figa (4):
  clk: samsung: exynos4: Add missing CPU/DMC clock hierarchy
  clk: samsung: exynos4: Add CLKOUT clock hierarchy
  clk: samsung: Add driver to control CLKOUT line on Exynos SoCs
  ARM: dts: exynos: Update PMU node with CLKOUT related data

 .../devicetree/bindings/arm/samsung/pmu.txt        |  30 ++++
 arch/arm/boot/dts/exynos4210.dtsi                  |  10 ++
 arch/arm/boot/dts/exynos4x12.dtsi                  |   7 +
 arch/arm/boot/dts/exynos5250.dtsi                  |   3 +
 arch/arm/boot/dts/exynos5420.dtsi                  |   3 +
 drivers/clk/samsung/Makefile                       |   1 +
 drivers/clk/samsung/clk-exynos-clkout.c            | 153 +++++++++++++++++++
 drivers/clk/samsung/clk-exynos4.c                  | 166 ++++++++++++++++++++-
 include/dt-bindings/clock/exynos4.h                |   5 +
 9 files changed, 374 insertions(+), 4 deletions(-)
 create mode 100644 drivers/clk/samsung/clk-exynos-clkout.c

-- 
1.9.3

