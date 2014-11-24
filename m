Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991AbaKXUKZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 15:10:25 -0500
Received: from xavier.telenet-ops.be ([195.130.132.52]:59915 "EHLO
	xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754443AbaKXUKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 15:10:21 -0500
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Ulrich Hecht <ulrich.hecht+renesas@gmail.com>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH RFC 0/3] Add "Simple" / Renesas Bus State Controller Driver
Date: Mon, 24 Nov 2014 21:10:05 +0100
Message-Id: <1416859808-18503-1-git-send-email-geert+renesas@glider.be>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi all,

The Renesas Bus State Controller (BSC) provides an external bus for
connecting multiple external devices to an SoC, driving several chip
select lines, for e.g. NOR FLASH, Ethernet and USB.
On the kzm9g development board, an smsc9220 Ethernet controller is
connnected to the BSC of the SH-Mobile AG5 (sh73a0) SoC.

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
  1. Without a device driver bound to the BSC device, this device is not
     attached to the PM domain. And although a child device is present
     and active, the PM domain may be powered down, as it's considered
     unused by the PM domain core.
  2. Without a device driver calling pm_runtime_enable(), its functional
     clock is not enabled. Once runtime PM is enabled, the R-Mobile PM
     domain platform driver manages the functional clock using runtime
     PM.

Hence patch 3 adds a very simple BSC driver, matching against
"renesas-bsc", and enabling runtime PM for the BSC device.

Due to the child-parent relationship of devices connected to the BSC, as
long as the device drivers for the child devices are runtime PM enabled
(see dependency 1), the BSC's PM domain will be powered, and the BSC's
clock will be enabled automatically when needed.
If any child device driver lacks runtime PM support, the BSC driver also
has to call pm_runtime_get_sync() in its .probe() function.
System suspend and resume (s2ram) also works fine.

As this minimal BSC driver isn't hardware-specific at all, I'm wondering
if there's a simpler way to do this?
  - Should the driver be renamed to "simple-bus", and match "simple-bus"?
  - Should this be moved to core code, without an explicit driver for
    "simple-bus"? I.e. should the driver core just enable runtime PM for
    all devices not bound to a driver, as they may represent buses with
    child devices that do rely on runtime PM?

Thanks for your comments and suggestions!

Dependencies:
  1. [PATCH] net/smsc911x: Add minimal runtime PM support
     (https://lkml.org/lkml/2014/11/24/610),
  2. [PATCH] clk: shmobile: div6: Avoid changing divisor in .disable()
     (http://marc.info/?l=linux-sh&m=141684607012727&w=2),
  3. [PATCH v6 0/6] sh73a0 common clock framework implementation
     (http://marc.info/?l=linux-sh&m=141650048308960&w=2),
  4. sh73a0 DT PM domain support (not yet posted),
  5. Alphabetical sorting of drivers/bus/{Kconfig,Makefile) (not yet
     posted).

References:
  1. [PATCH v3 7/7] ARM: shmobile: kzm9g-reference: require ZB clock for
     Ethernet controller (http://www.spinics.net/lists/linux-sh/msg36601.html)
     is an earlier workaround for getting the functional clock enabled, by
     letting the smc911x driver handle it. This predates sh73a0 PM domain
     support.

Patches:
  1. ARM: shmobile: sh73a0 dtsi: Add Bus State Controller node
  2. ARM: shmobile: kzm9g-reference dts: Move Ethernet node to BSC
  3. drivers: bus: Add Renesas Bus State Controller Driver

 arch/arm/boot/dts/sh73a0-kzm9g.dts | 28 +++++++++++----------
 arch/arm/boot/dts/sh73a0.dtsi      | 11 ++++++++
 drivers/bus/Kconfig                |  8 ++++++
 drivers/bus/Makefile               |  1 +
 drivers/bus/renesas-bsc.c          | 51 ++++++++++++++++++++++++++++++++++++++
 5 files changed, 86 insertions(+), 13 deletions(-)
 create mode 100644 drivers/bus/renesas-bsc.c

-- 
1.9.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
