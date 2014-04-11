Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422705AbaDKAZb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 20:25:31 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:37577 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811AbaDKAZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 20:25:30 -0400
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Daniel J Blueman <daniel@quora.org>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>
Subject: [Patch v2 00/14] Thunderbolt support for Apple MBP
Date: Fri, 11 Apr 2014 02:24:47 +0200
Message-Id: <1397175901-4023-1-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.9.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

This is version 2 of my Thunderbolt driver for Apple hardware (see [1] for v1).
The short story is that Apple decided to implement hotplug support in a driver
instead of the firmware. The firmware will only initialize coldplugged devices.
Hotplugged devices do not work.

This series adds support for single device hotplug (no chaining) for the Cactus
Ridge C4 Thunderbolt controller (device id 0x1547, present on MacBookPro10,1).
As far as I can tell newer generations work quite similar and it should be
possible to add support for more controllers with some work.

Changes from v1:
 - suspend/hibernate support (yeah)
 - general cleanups and refactoring

>From my perspective the driver is working quite well and is ready for merging
(maybe someone can tell me whom I should ask to get a review?). I have taken
some care to not stomp on tunnels setup by the firmware for coldplugged
devices. If this works as intendend then there should be no regressions
(coldplugged devices continue to work and simple hotplugged devices will start
working). In particular the Apple Ethernet adapter works very well (and this is
probably the most used TB device out there).

Some notes:
 - The patch requires Matthew's acpi_osi fix [2]
 - @pci, Bjorn: I hope patch 12 is acceptable. If there is a better way to do
   this please let me know.
 - Thunderbolt displays: I have a pretty good idea on how they should work, but
   I did not yet write any code to support them. Also judging by the replies I
got for v1 of the patch it seems that there are some graphics driver problems
even with coldplugged tb displays (at least on MBP models with discrete
graphics cards).
 - Hibernate gotcha: The amount of available memory reported by the firmware
   depends on whether a tb device is connected. This makes Linux refuse to
restore the saved image. This has nothing to do with this driver, but you might
run into it during testing.

Thanks,
Andreas


Andreas Noever (14):
  thunderbolt: Add initial cactus ridge NHI support
  thunderbolt: Add control channel interface
  thunderbolt: Setup control channel
  thunderbolt: Add tb_regs.h
  thunderbolt: Initialize root switch and ports
  thunderbolt: Add thunderbolt capability handling
  thunderbolt: Enable plug events
  thunderbolt: Scan for downstream switches
  thunderbolt: Handle hotplug events
  thunderbolt: Add path setup code.
  thunderbolt: Add support for simple pci tunnels.
  pci: Suspend/resume support for appel thunderbolt
  thunderbolt: Read switch uid from EEPROM
  thunderbolt: Add suspend/hibernate support

 drivers/Kconfig                  |   2 +
 drivers/Makefile                 |   1 +
 drivers/pci/pcie/portdrv_pci.c   | 117 +++++++
 drivers/thunderbolt/Kconfig      |  12 +
 drivers/thunderbolt/Makefile     |   3 +
 drivers/thunderbolt/cap.c        | 116 +++++++
 drivers/thunderbolt/ctl.c        | 731 +++++++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/ctl.h        |  75 ++++
 drivers/thunderbolt/eeprom.c     | 189 ++++++++++
 drivers/thunderbolt/nhi.c        | 671 +++++++++++++++++++++++++++++++++++
 drivers/thunderbolt/nhi.h        | 114 ++++++
 drivers/thunderbolt/nhi_regs.h   | 101 ++++++
 drivers/thunderbolt/path.c       | 215 ++++++++++++
 drivers/thunderbolt/switch.c     | 492 ++++++++++++++++++++++++++
 drivers/thunderbolt/tb.c         | 431 +++++++++++++++++++++++
 drivers/thunderbolt/tb.h         | 266 ++++++++++++++
 drivers/thunderbolt/tb_regs.h    | 213 ++++++++++++
 drivers/thunderbolt/tunnel_pci.c | 232 +++++++++++++
 drivers/thunderbolt/tunnel_pci.h |  30 ++
 19 files changed, 4011 insertions(+)
 create mode 100644 drivers/thunderbolt/Kconfig
 create mode 100644 drivers/thunderbolt/Makefile
 create mode 100644 drivers/thunderbolt/cap.c
 create mode 100644 drivers/thunderbolt/ctl.c
 create mode 100644 drivers/thunderbolt/ctl.h
 create mode 100644 drivers/thunderbolt/eeprom.c
 create mode 100644 drivers/thunderbolt/nhi.c
 create mode 100644 drivers/thunderbolt/nhi.h
 create mode 100644 drivers/thunderbolt/nhi_regs.h
 create mode 100644 drivers/thunderbolt/path.c
 create mode 100644 drivers/thunderbolt/switch.c
 create mode 100644 drivers/thunderbolt/tb.c
 create mode 100644 drivers/thunderbolt/tb.h
 create mode 100644 drivers/thunderbolt/tb_regs.h
 create mode 100644 drivers/thunderbolt/tunnel_pci.c
 create mode 100644 drivers/thunderbolt/tunnel_pci.h

-- 
1.9.2

