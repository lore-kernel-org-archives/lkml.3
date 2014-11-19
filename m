Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809AbaKSXQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 18:16:01 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:61679 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755655AbaKSXP4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 18:15:56 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: James Hogan <james.hogan@imgtec.com>,
        =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>,
        Heiko Stuebner <heiko@sntech.de>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>, Shawn Guo <shawn.guo@linaro.org>,
        Tero Kristo <t-kristo@ti.com>, linux-omap@vger.kernel.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH 00/15] tz1090: add clock components
Date: Wed, 19 Nov 2014 23:15:28 +0000
Message-Id: <1416438943-11429-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds common clock framework support for the TZ1090 SoC.

Patches 1 and 2 are generic and switch clk-divider to use masks
internally instead of shifts and width. Patch 1 came from Mike's divider
DT bindings patchset from a while back. This is required by the TZ1090
divider binding (patch 13).

Patches 3 to 14 add TZ1090 clock types and associated DT bindings,
specifically:
* PLLs (True Circuits, but TZ1090 specific register interface)
* Gate banks (a register containing clock gate bits)
* Mux banks (a register containing clock mux bits)
* Clock deleters (delete up to 1023 out of every 1024 clocks)
* PDC clock (combined divider and mux)
* Divider clock (pretty basic divider, but specific to TZ1090)

Finally patch 15 defines most of the TZ1090 clocks using these
components, with a few placeholders for less interesting clocks from
more complex components. This is mostly for reference to give an idea
how the clock components are intended to be used, and I'll take this one
through the metag tree when the drivers/clk/ stuff is accepted.

James Hogan (14):
  clk: divider: expose new clk_register_divider_mask
  dt: binding: add binding for tz1090-pll clock
  clk: tz1090: add PLL clock driver
  dt: binding: add binding for TZ1090 gate bank
  clk: tz1090: add gate bank clock driver
  dt: binding: add binding for TZ1090 mux bank
  clk: tz1090: add mux bank clock driver
  dt: binding: add binding for TZ1090 clock deleter
  clk: tz1090: add deleter clock driver
  dt: binding: add binding for TZ1090 PDC clock
  clk: tz1090: add PDC clock driver
  dt: binding: add binding for TZ1090 divider clock
  clk: tz1090: add divider clock driver
  metag: tz1090: add TZ1090 clocks to device tree

Mike Turquette (1):
  clk: divider: replace bitfield width with mask

 .../bindings/clock/img,tz1090-deleter.txt          |  40 ++
 .../bindings/clock/img,tz1090-divider.txt          |  37 +
 .../bindings/clock/img,tz1090-gate-bank.txt        |  52 ++
 .../bindings/clock/img,tz1090-mux-bank.txt         |  56 ++
 .../bindings/clock/img,tz1090-pdc-clock.txt        |  44 ++
 .../devicetree/bindings/clock/img,tz1090-pll.txt   |  33 +
 arch/arm/mach-imx/clk-busy.c                       |   2 +-
 arch/arm/mach-imx/clk-fixup-div.c                  |   2 +-
 arch/metag/Kconfig.soc                             |   1 +
 arch/metag/boot/dts/tz1090.dtsi                    |   4 +
 arch/metag/boot/dts/tz1090_clk.dtsi                | 784 +++++++++++++++++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/clk-divider.c                          |  58 +-
 drivers/clk/mxs/clk-div.c                          |   2 +-
 drivers/clk/rockchip/clk.c                         |   2 +-
 drivers/clk/st/clk-flexgen.c                       |   4 +-
 drivers/clk/st/clkgen-mux.c                        |   4 +-
 drivers/clk/st/clkgen-pll.c                        |   2 +-
 drivers/clk/sunxi/clk-sunxi.c                      |   2 +-
 drivers/clk/ti/divider.c                           |   2 +-
 drivers/clk/tz1090/Makefile                        |   7 +
 drivers/clk/tz1090/clk-tz1090-deleter.c            | 188 +++++
 drivers/clk/tz1090/clk-tz1090-divider.c            |  96 +++
 drivers/clk/tz1090/clk-tz1090-gate-bank.c          | 199 ++++++
 drivers/clk/tz1090/clk-tz1090-mux-bank.c           | 191 +++++
 drivers/clk/tz1090/clk-tz1090-pdc.c                | 185 +++++
 drivers/clk/tz1090/clk-tz1090-pll.c                | 305 ++++++++
 include/linux/clk-private.h                        |   2 +-
 include/linux/clk-provider.h                       |   7 +-
 29 files changed, 2282 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-deleter.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-divider.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-gate-bank.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-mux-bank.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-pdc-clock.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-pll.txt
 create mode 100644 arch/metag/boot/dts/tz1090_clk.dtsi
 create mode 100644 drivers/clk/tz1090/Makefile
 create mode 100644 drivers/clk/tz1090/clk-tz1090-deleter.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-divider.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-gate-bank.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-mux-bank.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pdc.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pll.c

Cc: "Emilio López" <emilio@elopez.com.ar>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Sascha Hauer <kernel@pengutronix.de>
Cc: Shawn Guo <shawn.guo@linaro.org>
Cc: Tero Kristo <t-kristo@ti.com>
Cc: linux-omap@vger.kernel.org
Cc: linux-rockchip@lists.infradead.org
-- 
2.0.4

