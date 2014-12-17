Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977AbaLQSuo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 13:50:44 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:41110 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbaLQStZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 13:49:25 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-pm@vger.kernel.org
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@kernel.org>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v2 0/8] Add Simple Power-Managed Bus Support
Date: Wed, 17 Dec 2014 19:49:05 +0100
Message-Id: <1418842153-17113-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

The Renesas Bus State Controller (BSC) provides an external bus for
connecting multiple external devices to an SoC, driving several chip
select lines, for e.g. NOR FLASH, Ethernet and USB.
On the kzm9g and ape6evm development boards, an smsc9220 Ethernet
controller is connnected to the BSC of an SH-Mobile AG5 (sh73a0) resp.
R-Mobile APE6 (r8a73a4) SoC.

The BSC is a fairly simple memory-mapped bus, hence a "simple-bus"
compatibility seems suitable.  However, the BSC is special in two ways:
  1. It is part of a PM domain (A4S),
  2. It has a gateable functional clock (ZB).
Before a device connected to the BSC can be accessed, the PM domain
containing the BSC must be powered on, and the functional clock driving
the BSC must be enabled.

Both special properties can be described in DT in a standardized way
("power-domains = <&pd_a4s>" and "clocks = <&zb_clk>", cfr. patch 1).
Externally connected devices are described as children of the BSC node
(cfr. patch 2).

Unfortunately this doesn't mean everything will work out-of-the-box.
There are two problems:
  1. Without a device driver bound to the bus device, this device is not
     attached to the PM domain. And although a child device is present
     and active, the PM domain may be powered down, as it's considered
     unused by the PM domain core.
  2. Without a device driver calling pm_runtime_enable(), its functional
     clock is not enabled. Once runtime PM is enabled, the R-Mobile PM
     domain platform driver manages the functional clock using runtime
     PM.

As none of the above is really bus hardware-specific (PM domains and
functional clocks in clock domains are handled from genpd and platform
code), this series adds a Simple Power-Managed Bus driver for
transparent busses, which just enables runtime PM for the bus device.
Due to the child-parent relationship of devices connected to the bus, as
long as the device drivers for the child devices are runtime PM enabled,
the bus's PM domain will be powered, and the bus's clock will be enabled
automatically when needed, for both runtime PM and s2ram.

Currently this driver supports the Renesas Bus State Controller only,
but support for other SoCs and other bus controllers can easily be added
later by adding more compatible values.
Note that this driver cannot just bind against "simple-bus", as that
may prevent a device-specific driver from taking precedence.

The last 4 patches add support in the DTSes for the sh73a0/kzm9g and
r8a73a4/ape6evm development boards.

This was tested on sh73a0/kzm9g-multiplatform. Without this, Ethernet
doesn't work, as the ZB clock is disabled by clk_disable_unused().
Testing on r8a73a4/ape6evm-multiplatform would be appreciated.

Changes compared to v1 (more detailed change logs in the individual
patches):
  - Added sorting of drivers/bus Kconfig and Makefile entries,
  - Added DT binding documentation,
  - Rename from "Renesas Bus State Controller Driver" (renesas-bsc) to
    "Simple Power-Managed Bus Driver" (simple-pm-bus),
  - Postponed adding power-domains properties to the dtsi,
  - Added updates for r8a73a4/ape6evm.

Dependencies:
  1. The shmobile DTS updates depend on the following series:
       - [PATCH v7 0/6] sh73a0 common clock framework implementation
       - [PATCH v2 00/05] ARM: shmobile: sh73a0 and kzm9g Multiplatform revisit
       - [PATCH v4 0/6] clk: shmobile: r8a73a4 common clock framework
	implementation
       - [PATCH v3 0/9] ARM: shmobile: ape6evm: multiplatform support
  2. [PATCH] net/smsc911x: Add minimal runtime PM support
     (https://lkml.org/lkml/2014/11/24/610, now upstream),
  3. [PATCH] clk: shmobile: div6: Avoid changing divisor in .disable()
     (http://marc.info/?l=linux-sh&m=141684607012727&w=2),

References:
  1. This is v2 of the series "[PATCH RFC 0/3] Add "Simple" / Renesas Bus
     State Controller Driver" (https://lkml.org/lkml/2014/11/24/661).
  2. [PATCH v3 7/7] ARM: shmobile: kzm9g-reference: require ZB clock for
     Ethernet controller (http://www.spinics.net/lists/linux-sh/msg36601.html)
     is an earlier workaround for getting the functional clock enabled, by
     letting the smc911x driver handle it. This predates sh73a0 PM domain
     support.

Thanks!

Geert Uytterhoeven (8):
  drivers: bus: Sort Kconfig entries alphabetically
  drivers: bus: Sort Makefile entries alphabetically
  drivers: bus: Add Simple Power-Managed Bus DT Bindings
  drivers: bus: Add Simple Power-Managed Bus Driver
  ARM: shmobile: sh73a0 dtsi: Add Bus State Controller node
  ARM: shmobile: kzm9g dts: Move Ethernet node to BSC
  ARM: shmobile: r8a73a4 dtsi: Add Bus State Controller node
  ARM: shmobile: ape6evm dts: Move Ethernet node to BSC

 .../devicetree/bindings/bus/simple-pm-bus.txt      | 49 ++++++++++++++++++++
 arch/arm/boot/dts/r8a73a4-ape6evm.dts              | 35 ++++++--------
 arch/arm/boot/dts/r8a73a4.dtsi                     |  9 ++++
 arch/arm/boot/dts/sh73a0-kzm9g.dts                 | 28 ++++++------
 arch/arm/boot/dts/sh73a0.dtsi                      | 10 ++++
 drivers/bus/Kconfig                                | 53 ++++++++++++++--------
 drivers/bus/Makefile                               | 15 +++---
 drivers/bus/simple-pm-bus.c                        | 51 +++++++++++++++++++++
 8 files changed, 190 insertions(+), 60 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/simple-pm-bus.txt
 create mode 100644 drivers/bus/simple-pm-bus.c

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
