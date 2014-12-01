Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932772AbaLAXUn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:20:43 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:57835 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932408AbaLAXUj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:20:39 -0500
From: James Hogan <james.hogan@imgtec.com>
To: Mike Turquette <mturquette@linaro.org>, linux-metag@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Heiko Stuebner <heiko@sntech.de>, James Hogan <james.hogan@imgtec.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>
Subject: [PATCH v2 00/16] tz1090: add clock components
Date: Mon,  1 Dec 2014 23:19:50 +0000
Message-Id: <1417476006-10407-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 2.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds common clock framework support for the TZ1090 SoC.

Patch 1 adds common code to simplify TZ1090 clock providers.

Patches 2 to 6 add TZ1090 clock types, specifically:
* Gate banks (a register containing clock gate bits)
* Mux banks (a register containing clock mux bits)
* Clock deleters (delete up to 1023 out of every 1024 clocks)
* PLLs (True Circuits, but TZ1090 specific register interface)
* Divider clock (pretty basic divider, but specific to TZ1090)

Patches 7 to 14 add clock providers and DT bindings:
* Top level register  (TOP) clocks
* High end peripheral (HEP) clocks
* Peripheral (PERIP) clocks
* PowerDown Controller (PDC) clocks

Finally patch 15 defines most of the TZ1090 clocks in DT using these
clock providers, with a few placeholders for less interesting clocks
from more complex components, and patch 16 hooks up the Meta core clock
so that the precise frequency of the Meta clock source can be
determined. These are mostly for reference to give an idea how the clock
components are intended to be used, and I'll take this one through the
metag tree when the drivers/clk/ stuff is accepted.

Changes since v1:

Rework (the main change):
- Convert explicit DT representation of clock infrastructure using
  generic bindings for individual components to several TZ1090 specific
  bindings representing groups of TZ1090 clocks (thanks Heiko). This
  results in more lines of code overall, but it is nicer and more
  maintainable.
- Add common code for allocating and registering TZ1090 specific clock
  providers. Various tz1090_clk_register_*() helper functions are
  provided to conveniently register various low level TZ1090 clocks in a
  clock provider from static initialisation data, which can be
  initialised statically using provided macros.
- Drop DT bindings for TZ1090 gate banks, mux banks, deleters, dividers
  and PLLs as they will be instantiated directly from a larger clock
  provider rather than individually from DT.
- Switch back to using clk_divider::width rather than clk_divider::mask.
  Mask was only added to make it easier to be exposed in a DT binding,
  which is no longer required.
- Add DT bindings and clock providers for TZ1090 top level register
  clocks (TOP), high end peripheral clocks (HEP), peripheral (PERIP)
  clocks, and powerdown controller clocks (PDC).
- Add headers in <dt-bindings/clock/> to enumerate provided clocks.
- Move divider specific flags (policy) to clock providers as dividers
  will be instantiated by a provider rather than directly from DT.

Functional changes and corrections:
- Tweak various clock names. A couple were wrong, some had the slightly
  redundant text "clk" in them, and others were output clocks so were
  better named without the "_en" which the output of clock gates tend to
  be called.
- Add TOP_CLKEN register to top clocks, which gates system clock to PDC.
- Combine unrepresented AFE block clocks into single fixed-clock
  placeholder.

Other cleanups and refactorings:
- Split out wrapped (meta exclusive locked) divider driver from PDC
  clock driver to clk-tz1090-divider.c.
- Change the PDC clocks DT bindings and driver to conceptually represent
  all clocks provided by the PDC in TZ1090 rather than the same generic
  arrangement of clocks as the PDC in TZ1090, since the driver will use
  the common TZ1090 specific clock provider helpers to provide specific
  clocks.
- Change PDC clocks compatible string from "img,tz1090-pdc-clock" to
  "img,tz1090-pdc-clocks" to match the intended purpose.
- Add clock-names as required property to PDC clocks DT binding as used
  by common TZ1090 clock provider code.
- Mention standard clock-indices and clock-output-names in PDC clocks DT
  binding as optional properties for when the clocks may be used by
  other clock providers and should match the names used in the driver.
- Split out use of Meta core clock into separate patch 16.
- Renamed function prefixes from clk_tz1090_ to tz1090_clk_ for
  consistency with the rest.
- Tweak ascii art clock diagrams a little.

Cc: Mike Turquette <mturquette@linaro.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Heiko Stuebner <heiko@sntech.de>
Cc: linux-metag@vger.kernel.org
Cc: devicetree@vger.kernel.org

James Hogan (16):
  clk: tz1090: add clock provider common code
  clk: tz1090: add gate bank clock driver
  clk: tz1090: add mux bank clock driver
  clk: tz1090: add deleter clock driver
  clk: tz1090: add divider clock driver
  clk: tz1090: add PLL clock driver
  dt: binding: add binding for TZ1090 PDC clocks
  clk: tz1090: add PDC clock provider driver
  dt: binding: add binding for TZ1090 TOP clocks
  clk: tz1090: add TOP clock provider driver
  dt: binding: add binding for TZ1090 HEP clocks
  clk: tz1090: add HEP clock provider driver
  dt: binding: add binding for TZ1090 PERIP clocks
  clk: tz1090: add PERIP clock provider driver
  metag: tz1090: add TZ1090 clocks to device tree
  metag: tz1090: connect Meta core clock

 .../bindings/clock/img,tz1090-hep-cru.txt          |  53 +++
 .../bindings/clock/img,tz1090-pdc-clocks.txt       |  59 ++++
 .../bindings/clock/img,tz1090-perip-cru.txt        |  49 +++
 .../bindings/clock/img,tz1090-top-clocks.txt       |  68 ++++
 arch/metag/Kconfig.soc                             |   1 +
 arch/metag/boot/dts/tz1090.dtsi                    |   4 +
 arch/metag/boot/dts/tz1090_clk.dtsi                | 143 ++++++++
 drivers/clk/Makefile                               |   1 +
 drivers/clk/tz1090/Makefile                        |  13 +
 drivers/clk/tz1090/clk-tz1090-deleter.c            | 132 ++++++++
 drivers/clk/tz1090/clk-tz1090-divider.c            | 151 +++++++++
 drivers/clk/tz1090/clk-tz1090-gate-bank.c          | 149 +++++++++
 drivers/clk/tz1090/clk-tz1090-hep.c                |  46 +++
 drivers/clk/tz1090/clk-tz1090-mux-bank.c           | 139 ++++++++
 drivers/clk/tz1090/clk-tz1090-pdc.c                |  52 +++
 drivers/clk/tz1090/clk-tz1090-perip.c              |  57 ++++
 drivers/clk/tz1090/clk-tz1090-pll.c                | 276 ++++++++++++++++
 drivers/clk/tz1090/clk-tz1090-top.c                | 364 +++++++++++++++++++++
 drivers/clk/tz1090/clk.c                           |  89 +++++
 drivers/clk/tz1090/clk.h                           | 254 ++++++++++++++
 include/dt-bindings/clock/tz1090-hep.h             |  19 ++
 include/dt-bindings/clock/tz1090-pdc.h             |  18 +
 include/dt-bindings/clock/tz1090-perip.h           |  30 ++
 include/dt-bindings/clock/tz1090-top.h             | 118 +++++++
 24 files changed, 2285 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-hep-cru.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-pdc-clocks.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-perip-cru.txt
 create mode 100644 Documentation/devicetree/bindings/clock/img,tz1090-top-clocks.txt
 create mode 100644 arch/metag/boot/dts/tz1090_clk.dtsi
 create mode 100644 drivers/clk/tz1090/Makefile
 create mode 100644 drivers/clk/tz1090/clk-tz1090-deleter.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-divider.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-gate-bank.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-hep.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-mux-bank.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pdc.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-perip.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-pll.c
 create mode 100644 drivers/clk/tz1090/clk-tz1090-top.c
 create mode 100644 drivers/clk/tz1090/clk.c
 create mode 100644 drivers/clk/tz1090/clk.h
 create mode 100644 include/dt-bindings/clock/tz1090-hep.h
 create mode 100644 include/dt-bindings/clock/tz1090-pdc.h
 create mode 100644 include/dt-bindings/clock/tz1090-perip.h
 create mode 100644 include/dt-bindings/clock/tz1090-top.h

-- 
2.0.4

