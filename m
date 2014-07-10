Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaGJIua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 04:50:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37278 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbaGJIuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 04:50:25 -0400
From: Harini Katakam <harinik@xilinx.com>
To: broonie@kernel.org, grant.likely@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        dwmw2@infradead.org, computersforpeace@gmail.com, marex@denx.de,
        artem.bityutskiy@linux.intel.com, geert+renesas@linux-m68k.org,
        s.hauer@pengutronix.de, jg1.han@samsung.com, sourav.poddar@ti.com
Cc: michals@xilinx.com, punnaia@xilinx.com, harinikatakamlinux@gmail.com,
        Harini Katakam <harinik@xilinx.com>
Subject: [RFC PATCH 0/2] Zynq QSPI RFC
Date: Thu, 10 Jul 2014 14:20:05 +0530
Message-Id: <1404982207-4707-1-git-send-email-harinik@xilinx.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xilinx Zynq uses a QSPI controller that is based on the Cadence SPI IP.
This controller implements all the functionality required to support
Quad SPI NOR flash devices.
This driver along with the MTD layer is used to support flash devices.

This series is for the following purposes:
- RFC of the Quad SPI driver.
- We currently use a custom MTD layer and would like to get inputs on
  dual stacked/dual parallel handling (described below).

The flash device(s) can be connected in the three configurations:
1. Single - One flash device with 1 CS, 1 Clock and 4 IO lines.
2. Dual Parallel - Two flash devices connected with common CS and
   separate IO lines (resulting in 8 IO lines).
   In this configuration, the controller
   a) Duplicates commands, address etc. sent on both sets of 4 IO lines.
   b) Stripes data both transmitted and received i.e.
      4 bits of data is sent to the first flash and the other 4 bits
      to the second flash. Similarly read data is also consolidated.
   Due to this, TX and RX data handling in the driver need special
   handling for parallel mode.
3. Dual Stacked - Two flash devices connected with separate CS and
   4 common IO lines. This is largely similar to single, except for
   the slave selection logic.
The above configuration is conveyed to the QSPI driver through a
devicetree property.

The QSPI driver differs from the existing Cadence SPI driver in
the following respects majorly:
1. TX and RX handling: Different TX registers are used to write into
   the TX FIFO. TXD0, TXD1, TXD2 and TXD3 are used write 4, 1, 2 and 3
   bytes respectively. Depending on the TXD register used, the received
   bytes also need to be handled separately.
2. Depending on the configuration in which flash devices are connected
   (single, parallel or stacked), QSPI controller configuration registers
   need to be modified.
3. There is no support for extended slave select in QSPI, as opposed to
   SPI. In case of stacked configuration, the slave select field remains
   the same and a different configuration bit is used to select between
   the two flash devices.
4. Handling of dual parallel configuration.

MTD layer:
The Xilinx Zynq MTD layer by far makes use of the mainline version with
some differences. The primary flash families supported are
Spansion, Winbond and Micron.
- Probe:
  - In dual configurations, both flash devices are recognized as one
    continuous memory. (ID is read only from one flash and it is a 
    pre-stated assumption that both flash devices have the same flash
    make and size.)
- Addressing:
  a) In dual stacked mode, the address passed to the MTD layer can be
     between 0x0 to 2*(one flash size). Hence the MTD layer has to recognize
     whether the address belongs to the first flash or the second flash
     subtract the offset and indicate the same to the QSPI driver.
  b) In dual stacked mode too the address can range between
     0 to 2*(one flash size). But, when an 8 bit word is written,
     4 bits are written to the first and 4 bits are written to the
     second flash. Hence the address sent is always halved and checks
     are in place for even address and even length.
- 4 byte addressing is not supported and hence bank selection logic is used
  along with the addressing system described above.
- Flash register read/writes, for example, lock/unlock, quad enable etc.
  are handled differently in dual stacked and parallel modes.

I'm sorry for the long  cover letter. Hope it helps.

Harini Katakam (2):
  spi: Add support for Zynq QSPI controller
  devicetree: Add devicetree bindings documentation for Zynq QSPI

 .../devicetree/bindings/spi/spi-zynq-qspi.txt      |   28 +
 drivers/spi/Kconfig                                |    6 +
 drivers/spi/Makefile                               |    1 +
 drivers/spi/spi-zynq-qspi.c                        |  854 ++++++++++++++++++++
 4 files changed, 889 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/spi/spi-zynq-qspi.txt
 create mode 100644 drivers/spi/spi-zynq-qspi.c

-- 
1.7.9.5

