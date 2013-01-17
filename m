Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246Ab3AQLaz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 06:30:55 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:45476 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752070Ab3AQLay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 06:30:54 -0500
From: Roger Quadros <rogerq@ti.com>
To: <balbi@ti.com>, <sameo@linux.intel.com>, <tony@atomide.com>
CC: <kishon@ti.com>, <sshtylyov@mvista.com>, <bjorn@mork.no>,
        <linux@arm.linux.org.uk>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <rogerq@ti.com>
Subject: [PATCH v7 00/22] OMAP USB Host cleanup
Date: Thu, 17 Jan 2013 13:30:09 +0200
Message-ID: <1358422231-24736-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset addresses the following

- Consolidate USB Host platform data.
- Avoid addressing clocks one by one by name and use a for loop + bunch
  of cleanups.
- Get number of channels/ports dynamically either from revision register
  or from platform data. Avoids getting clocks that are not present.
- Add OMAP5 and HSIC mode (Not tested).

v7:
- Updated patch 4 to not hold a spinlock when using clk_get().
- Updated patches 3 and 11 to return -EADDRNOTAVAIL on failure of
  demv_request_and_ioremap().

v6:
- Added USB Host platform data consolidation patch as the first patch.
  based on request from Tony.
- Rebased on v3.8-rc3.

v5:
- Rebased on top of todays arm-soc/for-next.
- Removed the clock merging patch from the list.
- Updated patches 14, 19 and 20 to accomodate the above change.
- Added patch 22 to fix a build warning.

v4:
- Added appropriate maintainers in to/cc.
- minor print message fix in patch 23 to maintain consistency.

v3:
- Rebased on arm-soc/for-next commit f979306c4d38d213c6977aaf3b1115e8ded71e3a.
- Rearranged patch that get rids of cpu_is_omap..() macros.
- Coding style fixes.

v2:
- Clocks are allocated dynamically based on number of ports available
  on the platform.
- Reduced console spam if non critical clocks are not found on the platform.
- Get rid of cpu_is_.. macros from USB host driver.

cheers,
-roger

The following changes since commit 9931faca02c604c22335f5a935a501bb2ace6e20:

  Linux 3.8-rc3 (2013-01-09 18:59:55 -0800)

are available in the git repository at:
  git@github.com:rogerq/linux.git linux-usbhost12-part


Roger Quadros (22):
  mfd: omap-usb-host: Consolidate OMAP USB-HS platform data
  mfd: omap-usb-tll: Fix channel count detection
  mfd: omap-usb-tll: Use devm_kzalloc/ioremap and clean up error path
  mfd: omap-usb-tll: Clean up clock handling
  mfd: omap-usb-tll: introduce and use mode_needs_tll()
  mfd: omap-usb-tll: Check for missing platform data in probe
  mfd: omap-usb-tll: Fix error message
  mfd: omap-usb-tll: serialize access to TLL device
  mfd: omap-usb-tll: Add OMAP5 revision and HSIC support
  mfd: omap_usb_host: Avoid missing platform data checks in
    suspend/resume
  mfd: omap-usb-host: Use devm_kzalloc() and devm_request_and_ioremap()
  mfd: omap-usb-host: know about number of ports from revision register
  mfd: omap-usb-host: override number of ports from platform data
  mfd: omap-usb-host: cleanup clock management code
  mfd: omap-usb-host: Manage HSIC clocks for HSIC mode
  mfd: omap-usb-host: Get rid of unnecessary spinlock
  mfd: omap-usb-host: clean up omap_usbhs_init()
  USB: ehci-omap: Don't free gpios that we didn't request
  ARM: OMAP3: clock data: get rid of unused USB host clock aliases and
    dummies
  ARM: OMAP4: clock data: get rid of unused USB host clock aliases
  mfd: omap-usb-host: Don't spam console on clk_set_parent failure
  mdf: omap-usb-host: get rid of build warning

 arch/arm/mach-omap2/board-3430sdp.c        |    2 +-
 arch/arm/mach-omap2/board-3630sdp.c        |    2 +-
 arch/arm/mach-omap2/board-am3517crane.c    |    2 +-
 arch/arm/mach-omap2/board-am3517evm.c      |    2 +-
 arch/arm/mach-omap2/board-cm-t35.c         |    2 +-
 arch/arm/mach-omap2/board-cm-t3517.c       |    2 +-
 arch/arm/mach-omap2/board-devkit8000.c     |    2 +-
 arch/arm/mach-omap2/board-igep0020.c       |    4 +-
 arch/arm/mach-omap2/board-omap3beagle.c    |    2 +-
 arch/arm/mach-omap2/board-omap3evm.c       |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c   |    2 +-
 arch/arm/mach-omap2/board-omap3stalker.c   |    2 +-
 arch/arm/mach-omap2/board-omap3touchbook.c |    2 +-
 arch/arm/mach-omap2/board-omap4panda.c     |    2 +-
 arch/arm/mach-omap2/board-overo.c          |    2 +-
 arch/arm/mach-omap2/board-zoom.c           |    2 +-
 arch/arm/mach-omap2/cclock3xxx_data.c      |   11 -
 arch/arm/mach-omap2/cclock44xx_data.c      |    7 -
 arch/arm/mach-omap2/usb-host.c             |   29 +--
 arch/arm/mach-omap2/usb.h                  |   20 +-
 drivers/mfd/omap-usb-host.c                |  543 ++++++++++++++++------------
 drivers/mfd/omap-usb-tll.c                 |  245 +++++++------
 drivers/usb/host/ehci-omap.c               |   14 +-
 include/linux/platform_data/usb-omap.h     |   24 +-
 24 files changed, 485 insertions(+), 442 deletions(-)

-- 
1.7.4.1

