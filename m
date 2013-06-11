Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab3FKRJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 13:09:37 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48184 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755685Ab3FKRJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 13:09:33 -0400
From: Illia Smyrnov <illia.smyrnov@ti.com>
To: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Mark Brown <broonie@kernel.org>
CC: Illia Smyrnov <illia.smyrnov@ti.com>, Daniel Mack <zonque@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <spi-devel-general@lists.sourceforge.net>,
        <linux-omap@vger.kernel.org>
Subject: [PATCH v2 0/2] spi: omap2-mcspi: add FIFO buffer support
Date: Tue, 11 Jun 2013 20:09:13 +0300
Message-ID: <1370970556-11713-1-git-send-email-illia.smyrnov@ti.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches introduce FIFO support for TI OMAP4/OMAP5 MCSPI controller.
Using FIFO unload the DMA and improve data throughput. On Blaze (OMAP 4460) 
ethernet throughput with MTU 1500 was increased:
* for TX from 6.9476 Mbps (FIFO disabled) to 7.7982 Mbps (FIFO enabled),
* for RX from 6.5120 Mbps (FIFO disabled) to 7.5461 Mbps (FIFO enabled).

The FIFO sanity test on OMAP5 Panda board also has been done. 

The FIFO could be enabled for MCSPI by "ti,spi-fifo-enabled" in DT. If enabled,
driver will calculate the largest possible FIFO buffer size taking into account
MCSPI FIFO constraints for each SPI transfer.

The MCSPI FIFO constraints are:
* FIFO depth size defined as a multiple of the SPI word length;
* transfer's data size is a multiple of FIFO depth;
* transfer's words count less or equal 65535.

Also FIFO buffer with 1 byte size is insignificant, so driver will setup FIFO if
calculated size is within the 2 to 64 bytes range.

--------------------
v2:
* driver calculate and setup optimal FIFO size for each SPI transfer;
* "ti,spi-fifo-enabled" parameter in MCSPI DT node to enable FIFO;
* no FIFO settings in SPI slaves nodes in DT;
* Matthias Brugger patch was excluded from patch set.

Illia Smyrnov (2):
  spi: omap2-mcspi: Move bytes per word calculation to the function
  spi: omap2-mcspi: Add FIFO buffer support

 Documentation/devicetree/bindings/spi/omap-spi.txt |    8 +
 drivers/spi/spi-omap2-mcspi.c                      |  173 +++++++++++++++++---
 2 files changed, 158 insertions(+), 23 deletions(-)

