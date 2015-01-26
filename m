Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbbAZQQ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 11:16:56 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:34092 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756267AbbAZQQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 11:16:38 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Kevin Hilman <khilman@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Felipe Balbi <balbi@ti.com>
Cc: Olof Johansson <olof@lixom.net>, Simon Horman <horms+renesas@verge.net.au>,
        Magnus Damm <magnus.damm@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH v4 0/5] drivers: bus: Add Simple Power-Managed Bus
Date: Mon, 26 Jan 2015 17:16:12 +0100
Message-Id: <1422288977-20353-1-git-send-email-geert+renesas@glider.be>
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
compatibility seems suitable.  However, the BSC is special in two
ways:
  1. It is part of a PM domain (A4S on sh73a0),
  2. It has a gateable functional clock (ZB).
Before a device connected to the BSC can be accessed, the PM domain
containing the BSC must be powered on, and the functional clock
driving the BSC must be enabled.

Both special properties can be described in DT in a standardized way
("power-domains = <&pd_a4s>" and "clocks = <&zb_clk>", cfr. the
example in the DT binding documentation).  Externally connected
devices are described as children of the BSC node.

Unfortunately this doesn't mean everything will work out-of-the-box.
There are two problems:
  1. Without a device driver bound to the bus device, this device is
     not attached to the PM domain. And although a child device is
     present and active, the PM domain may be powered down, as it's
     considered unused by the PM domain core.
  2. Without a device driver calling pm_runtime_enable(), its
     functional clock is not enabled. Once runtime PM is enabled, the
     R-Mobile PM domain platform driver manages the functional clock
     using runtime PM.

As none of the above is really bus hardware-specific (PM domains and
functional clocks in clock domains are handled from genpd and platform
code), this series adds a Simple Power-Managed Bus driver for
transparent busses, which matches against "simple-pm-bus", enables
runtime PM for the bus device, and calls of_platform_populate() to
probe for child devices.
Due to the child-parent relationship of devices connected to the bus,
as long as the device drivers for the child devices are runtime PM
enabled, the bus's PM domain will be powered, and the bus's clock will
be enabled automatically when needed, for both runtime PM and s2ram.

This was tested on sh73a0/kzm9g-multiplatform (by me), and (v3) on
r8a73a4/ape6evm-multiplatform (by Ulrich Hecht). Without this,
Ethernet doesn't work, as the ZB clock is disabled by
clk_disable_unused().

Felipe: It looks like drivers/usb/musb/musb_am335x.c can be removed, if
"ti,am33xx-usb" claims compatibility with "simple-pm-bus"?

As drivers/bus doesn't have a maintainer, and this driver is needed to
move two shmobile platforms away from legacy to multiplatform, I think
this can go in through Simon's shmobile tree.

Changes compared to v3:
  - Replace "simple-bus" by "simple-pm-bus" in the bindings,
  - Move the "renesas,bsc" bindings to a separate document,
  - Bind against the generic "simple-pm-bus" instead of "renesas,bsc",
  - Explicitly call of_platform_populate() after pm_runtime_enable() to
    enforce ordering, instead of depending on claimed compatibility with
    "simple-bus".

Changes compared to v2:
  - Document required properties inherited from "simple-bus",
  - Document required "reg" property for "renesas,bsc",
  - Move "ranges" before "reg" in the example,
  - Add Tested-by,
  - Split-off sh73a0/kzm9g and r8a73a4/ape6evm DTS updates.

Changes compared to v1 (more detailed change logs in the individual
patches):
  - Added sorting of drivers/bus Kconfig and Makefile entries,
  - Added DT binding documentation,
  - Rename from "Renesas Bus State Controller Driver" (renesas-bsc) to
    "Simple Power-Managed Bus Driver" (simple-pm-bus),
  - Postponed adding power-domains properties to the dtsi,
  - Added updates for r8a73a4/ape6evm.

Thanks for your comments!

Geert Uytterhoeven (5):
  drivers: bus: Sort Kconfig entries alphabetically
  drivers: bus: Sort Makefile entries alphabetically
  drivers: bus: Add Simple Power-Managed Bus DT Bindings
  drivers: bus: Add Renesas Bus State Controller (BSC) DT Bindings
  drivers: bus: Add Simple Power-Managed Bus Driver

 .../devicetree/bindings/bus/renesas,bsc.txt        | 46 +++++++++++++++++
 .../devicetree/bindings/bus/simple-pm-bus.txt      | 41 +++++++++++++++
 drivers/bus/Kconfig                                | 53 ++++++++++++--------
 drivers/bus/Makefile                               | 15 +++---
 drivers/bus/simple-pm-bus.c                        | 58 ++++++++++++++++++++++
 5 files changed, 186 insertions(+), 27 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/bus/renesas,bsc.txt
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
