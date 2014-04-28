Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbaD1PPw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 11:15:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:50699 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbaD1PP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 11:15:27 -0400
From: Nishanth Menon <nm@ti.com>
To: Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Sricharan R <r.sricharan@ti.com>, Sekhar Nori <nsekhar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>
CC: Peter Ujfalusi <peter.ujfalusi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <nm@ti.com>
Subject: [PATCH V3 00/20] bus: omap_l3_noc: driver cleanups and support for DRA7/AM4372 
Date: Mon, 28 Apr 2014 10:14:40 -0500
Message-ID: <1398698101-25513-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397492726-17203-1-git-send-email-nm@ti.com>
References: <1397492726-17203-1-git-send-email-nm@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following V3 of the series is based on v3.15-rc1 + peter's patch series:
	patch #1: https://patchwork.kernel.org/patch/3923141/
	(drivers: bus: omap_l3: Convert to use devm_kzalloc)

	patch #2: https://patchwork.kernel.org/patch/3923061/
	(drivers: bus: omap_l3: Convert to use devm_ioremap_resource() )

	patch #3: https://patchwork.kernel.org/patch/3923101/
	(drivers: bus: omap_l3: Convert to use devm_request_irq())

	patch #4: https://patchwork.kernel.org/patch/3923081/
	(drivers: bus: omap_l3: Remove the platform driver's remove function)

	patch #5: https://patchwork.kernel.org/patch/3923121/
	(drivers: bus: omap_l3: Change pr_crit() to dev_err() when IRQ request
	fails)

V1 was originally posted here: http://marc.info/?l=linux-omap&m=139749383932575&w=2
V2 was originally posted here: http://marc.info/?l=linux-kernel&m=139776814925544&w=2

V3: has the following changes (w.r.t v2):
	- fixed relaxed commit message and usage.
	- AM437x internal documents showed that:
		- new master information updated into the data
		- masterid register definition is different from OMAP4-DRA7 - some
		  additional parsing is done in hardware to "avoid s/w parsing"
	- Additional testing information showed logic fail for masking "unclearable"
		new patch added to series - patch #15
	- Picked up previous acks and tested by - minor changes verified

This series cleansup omap_l3_noc driver and adds data to support DRA7
and AM437x SoCs.

Patches(including Peter's) is available here:(based on v3.15-rc1):
https://github.com/nmenon/linux-2.6-playground/commits/l3noc/driver-fixes-v3

DTS patches (once this series is integrated and related DRA7 memory map fixes are done):
https://github.com/nmenon/linux-2.6-playground/commits/l3noc/dts-fixes
	(posted here: http://marc.info/?l=linux-omap&m=139750288003978&w=2)
		- no change in dts.

Testing branch: everything integrated:
https://github.com/nmenon/linux-2.6-playground/commits/l3noc/testing-v3

Test log (omap2plus_defconfig + CONFIG_CRYPTO_DEV_OMAP_DES=y):
	am43xx-epos: http://slexy.org/raw/s28LkG186D
	dra7xx-evm: http://slexy.org/raw/s2UV0v7fwn
	pandaboard-es: http://slexy.org/raw/s213lc55PY
	pandaboard-vanilla: http://slexy.org/raw/s20AvyGNrA
	   sdp4430: http://slexy.org/raw/s2E0exblmN
	OMAP5432uEVM: http://slexy.org/raw/s20TRRtKzf

Afzal Mohammed (2):
  bus: omap_l3_noc: ignore masked out unclearable targets
  bus: omap_l3_noc: Add AM4372 interconnect error data

Nishanth Menon (14):
  bus: omap_l3_noc: Fix copyright information
  bus: omap_l3_noc: remove iclk from omap_l3 struct
  bus: omap_l3_noc: populate l3->dev and use it
  bus: omap_l3_noc: switch over to relaxed variants of readl/writel
  bus: omap_l3_noc: un-obfuscate l3_targ address computation
  bus: omap_l3_noc: move L3 master data structure out
  bus: omap_l3_noc: convert target information into a structure
  bus: omap_l3_noc: convert flagmux information into a structure
  bus: omap_l3_noc: fix masterid detection
  bus: omap_l3_noc: make error reporting and handling common
  bus: omap_l3_noc: improve readability by using helper for slave event
    parsing
  bus: omap_l3_noc: add information about the type of operation
  bus: omap_l3_noc: Add information about the context of operation
  bus: omap_l3_noc: introduce concept of submodule

Rajendra Nayak (2):
  bus: omap_l3_noc: Add support for discountinous flag mux input
    numbers
  bus: omap_l3_noc: Add DRA7 interconnect error data

Sricharan R (2):
  bus: omap_l3_noc: rename functions and data to omap_l3
  bus: omap_l3_noc: use of_match_data to pick up SoC information

 .../devicetree/bindings/arm/omap/l3-noc.txt        |    2 +
 drivers/bus/omap_l3_noc.c                          |  322 ++++++++----
 drivers/bus/omap_l3_noc.h                          |  545 +++++++++++++++-----
 3 files changed, 642 insertions(+), 227 deletions(-)

-- 
1.7.9.5

