Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754341Ab3I1BCu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 21:02:50 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:36838 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753649Ab3I1BCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 21:02:47 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org
Cc: Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rui Wang <ruiv.wang@gmail.com>, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5 0/4] iMC SMBUS and DIMM bus probing
Date: Fri, 27 Sep 2013 18:02:39 -0700
Message-Id: <cover.1380315959.git.luto@amacapital.net>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel LGA2011 machines have dedicated SMBUS controllers for DIMM
sockets.  Because they're dedicated, they can be safely and accurately
probed, since all devices on them are known to be attached to DIMMs.
The devices found are:
 - SPD EEPROMs
 - TSODs (Temperature Sensor on DIMMs)
 - Other interesting things, with drivers hopefully to follow...

This patch series adds a simple generic layer for probing for DIMMs over
SMBUS and an i2c bus driver for the iMC controller found on Intel
LGA2011 chips.

It now uses only modern infrastructure -- new-style I2C probing and the
at24 (instead of eeprom) driver.

I've tested this on a Core i7 Extreme and on a Xeon E5 server.

Patches 1-3 are useful even without patch 4.  I'm still hoping for feedback
on patch 4.

Changes from v4:
 - Added the sb_edac changes -- i2c_imc and sb_edac can now coexist
 - Added some paranoid race detection.
 - The driver now confirms its ability to claim software control of the SMBUS
   master.  This prevents unpleasant problems on systems that enable CLTT
   (closed loop thermal throttling).
 - Reordered the patches so that the DIMM bus code is last.

Changes from v3:
 - Dropped redundant "tsod" driver
 - Dropped eeprom modalias
 - Switched to probing for the "eeprom" and "jc42"

Andy Lutomirski (4):
  Move Intel SNB device ids from sb_edac to pci_ids.h
  sb_edac: Claim a different PCI device
  i2c_imc: New driver for Intel's iMC, found on LGA2011 chips
  i2c, i2c_imc: Add DIMM bus code

 drivers/edac/sb_edac.c        |  32 +--
 drivers/i2c/busses/Kconfig    |  19 ++
 drivers/i2c/busses/Makefile   |   5 +
 drivers/i2c/busses/dimm-bus.c |  97 ++++++++
 drivers/i2c/busses/i2c-imc.c  | 562 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/i2c/dimm-bus.h  |  24 ++
 include/linux/pci_ids.h       |  15 ++
 7 files changed, 723 insertions(+), 31 deletions(-)
 create mode 100644 drivers/i2c/busses/dimm-bus.c
 create mode 100644 drivers/i2c/busses/i2c-imc.c
 create mode 100644 include/linux/i2c/dimm-bus.h

-- 
1.8.3.1

