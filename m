Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934302Ab3BMPrR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 10:47:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:37642 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934212Ab3BMPrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 10:47:11 -0500
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
Subject: [PATCH v9 0/4] Add generic driver for on-chip SRAM
Date: Wed, 13 Feb 2013 16:46:38 +0100
Message-Id: <1360770402-23091-1-git-send-email-p.zabel@pengutronix.de>
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

The on-chip SRAM on i.MX53 and i.MX6q can be registered via device tree
and changed to use the simple generic SRAM driver:

                ocram: ocram@00900000 {
                        compatible = "fsl,imx-ocram", "mmio-sram";
                        reg = <0x00900000 0x3f000>;
                };

A driver that needs to allocate SRAM buffers, like the video processing
unit on i.MX53, can retrieve the genalloc pool from a phandle in the
device tree using of_get_named_gen_pool(node, "iram", 0) from patch 1:

                vpu@63ff4000 {
                        /* ... */
                        iram = <&ocram>;
                };

Changes since v8:
 - The sram driver now matches against the "mmio-sram" compatible string.
 - Removed a whitespace error in the device tree binding documentation.

regards
Philipp

---
 Documentation/devicetree/bindings/media/coda.txt |   30 ++++++
 Documentation/devicetree/bindings/misc/sram.txt  |   16 +++
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
 12 files changed, 333 insertions(+), 15 deletions(-)

