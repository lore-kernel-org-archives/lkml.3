Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab3BDLcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 06:32:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49531 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab3BDLcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 06:32:31 -0500
From: Philipp Zabel <p.zabel@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        Richard Zhao <richard.zhao@freescale.com>,
        Huang Shijie <shijie8@gmail.com>,
        Dong Aisheng <dong.aisheng@linaro.org>, Matt Porter <mporter@ti.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Javier Martin <javier.martin@vista-silicon.com>, kernel@pengutronix.de,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v8 0/4] Add generic driver for on-chip SRAM
Date: Mon,  4 Feb 2013 12:32:14 +0100
Message-Id: <1359977538-5859-1-git-send-email-p.zabel@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 10.1.0.7
X-SA-Exim-Mail-From: p.zabel@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches add support to configure on-chip SRAM via device-tree
node or platform data and to obtain the resulting genalloc pool from
the struct device pointer or a phandle pointing at the device tree node.
This allows drivers to allocate SRAM with the genalloc API without
hard-coding the genalloc pool pointer.

I changed the implementation in genalloc.c since v7. To avoid the global
pool list, a devres managed version of gen_pool_create is added, and
gen_pool_find_by_phys of the previous versions is replaced by dev_get_gen_pool,
that retrieves a gen_pool created with devm_gen_pool_create from the
corresponding device pointer. of_get_named_gen_pool is called unchanged.

The on-chip SRAM on i.MX53 and i.MX6q can be registered via device tree
and changed to use the simple generic SRAM driver:

		ocram: ocram@00900000 {
			compatible = "fsl,imx-ocram", "sram";
			reg = <0x00900000 0x3f000>;
 		};

A driver that needs to allocate SRAM buffers, like the video processing
unit on i.MX53, can retrieve the genalloc pool from a phandle in the
device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:

		vpu@63ff4000 {
			/* ... */
			iram = <&ocram>;
 		};

Changes since v7:
- Removed the global pool list in genalloc. Instead, added a devres managed
  version of gen_pool_create, replacing gen_pool_find_by_phys with
  dev_get_gen_pool (and made of_get_named_gen_pool use that)
- In the coda driver, switched to dev_get_gen_pool and added a platform_data
  struct to pass the SRAM device pointer (instead of using a second IO memory
  resource). Added device tree binding documentation.

regards
Philipp

---
 Documentation/devicetree/bindings/media/coda.txt |   30 ++++++
 Documentation/devicetree/bindings/misc/sram.txt  |   17 +++
 arch/arm/boot/dts/imx53.dtsi                     |    5 +
 arch/arm/boot/dts/imx6q.dtsi                     |    6 ++
 drivers/media/platform/Kconfig                   |    1 -
 drivers/media/platform/coda.c                    |   45 +++++---
 drivers/misc/Kconfig                             |    9 ++
 drivers/misc/Makefile                            |    1 +
 drivers/misc/sram.c                              |  121 ++++++++++++++++++++++
 include/linux/genalloc.h                         |   15 +++
 include/linux/platform_data/coda.h               |   18 ++++
 lib/genalloc.c                                   |   81 +++++++++++++++
 12 files changed, 334 insertions(+), 15 deletions(-)

