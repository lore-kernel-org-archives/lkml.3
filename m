Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaB1XfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 18:35:20 -0500
Received: from mail-qa0-f49.google.com ([209.85.216.49]:61271 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751911AbaB1XfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 18:35:18 -0500
From: Soren Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Gerhard Sittig <gsi@denx.de>
Cc: Michal Simek <michal.simek@xilinx.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: [PATCH RFC 0/3] clk: CCF clock primitives + custom IO accessors
Date: Fri, 28 Feb 2014 15:34:52 -0800
Message-Id: <1393630495-29689-1-git-send-email-soren.brinkmann@xilinx.com>
X-Mailer: git-send-email 1.9.0.1.g4196000
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I recently ran into a problem which seems to become common. I was trying
to write a driver for the TI CDCE913, a programmable clock synthesizer
on the I2C bus. Internally that device consists of a PLL and a bunch of
muxes, gates and dividers that eventually end up in three clock outputs.
Looking at that device, it seems rather easy to model it with the
available clock primitives, the problem though is, the clock
primitives assume accesses via memory mapped IO.

To overcome a similar problem the PPC folks introduced the
clk_(read|write)l wrappers, which seems to go into the right direction,
but that also only allows per ARCH overrides. I.e. wouldn't allow
mixing of MMIO clocks and clocks using I2C via regmap or similar.

So, the first thing I did, was essentially duplicating the clock
primitives I need and simply replacing the readl/writel with
regmap_read/write. So there is a lot of code duplication to use all the
fancy features the clk-mux and clk-div primitives provide, just to
replace the IO access.

In the next step, I encountered a divider clock whose divider is stored
in 2 I2C registers. So now, the simple IO access replacement doesn't
work anymore either since this clock needs 2 registers to be read and
then shifting around the bitfields accordingly.

Does anybody have a good idea how we could avoid all this code
duplication while enabling usage of the clock primitives with different
IO accessors?
Especially the divider and mux primitive have a lot of code that would
be painful to maintain twice.

	Thanks,
	Sören

Soren Brinkmann (3):
  clk: Introduce I2C clock primitives
  clk/i2c-div: Allow custom divider accessors
  clk: Add driver for TI CDCE913

 .../devicetree/bindings/clock/ti,cdce913.txt       |  32 +
 drivers/clk/Kconfig                                |  15 +
 drivers/clk/Makefile                               |   6 +
 drivers/clk/clk-cdce913.c                          | 841 +++++++++++++++++++++
 drivers/clk/clk-i2c-divider.c                      | 375 +++++++++
 drivers/clk/clk-i2c-mux.c                          | 173 +++++
 drivers/clk/clk-i2c.c                              |  22 +
 include/linux/clk-provider.h                       | 104 +++
 8 files changed, 1568 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/ti,cdce913.txt
 create mode 100644 drivers/clk/clk-cdce913.c
 create mode 100644 drivers/clk/clk-i2c-divider.c
 create mode 100644 drivers/clk/clk-i2c-mux.c
 create mode 100644 drivers/clk/clk-i2c.c

-- 
1.9.0.1.g4196000

