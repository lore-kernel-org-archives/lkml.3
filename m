Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758267AbaDIGR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 02:17:27 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:53155 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbaDIGRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 02:17:20 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s396GV0K001775, This message is accepted by code: ctloc85258
From: <rogerable@realtek.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Chris Ball <chris@printf.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxim Levitsky <maximlevitsky@gmail.com>, Alex Dubov <oakad@yahoo.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oliver Neukum <oneukum@suse.de>
CC: <rogerable@realtek.com>, <linux-kernel@vger.kernel.org>,
        <linux-mmc@vger.kernel.org>, <driverdev-devel@linuxdriverproject.org>,
        <wei_wang@realsil.com.cn>, <micky_ching@realsil.com.cn>
Subject: [PATCH v6 0/4] Add modules for realtek USB card reader
Date: Wed, 9 Apr 2014 14:15:59 +0800
Message-ID: <1397024163-6643-1-git-send-email-rogerable@realtek.com>
X-Mailer: git-send-email 1.8.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.21.81.189]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Tseng <rogerable@realtek.com>

This patchset adds modules to support Realtek USB vendor specific class flash
card reader: one base module in MFD subsystem and two host modules in both mmc
and memstick subsystems. The architecture is similar to rtsx_pci.

This work is done primarily to replace the staging driver: staging/rts5139,
which doesn't utilize mmc nor memstick subsystems. Once the patchset or its
revision is applied, we may need Greg's help to remove the staging one.

v2:
1. Fix potential buffer overflow in rtsx_usb_seq_write_register()
2. Remove unnecessary casting and messages
3. Revise coding style and white spaces

v3:
1. Fix MMC detection fail when under xhci
2. Minor change of pm_runtime behavior in rtsx_usb_ms to prevent some rare
   freeze due to erroneous Memstick card(not MS-Pro)
3. Further revise coding style as suggested in the thread of v2
4. Using managed resources: devm_*
5. Change license from "GPL v2 and later" to "GPL v2"

v4:
1. Remove invocations to deprecated/removed mmc_suspend|resume_host APIs and
   unnecessary platform device pm routines
2. Support CRC-ignored R1 response for CMD13 in response to commit:
   a27fbf2f067b0cd6f172c8b696b9a44c58bfaa7a: mmc: add ignorance case for 
   CMD13 CRC error
3. Remove unnecessary #ifdef CONFIG_PM_RUNTIME

v5:
1. rtsx_usb_ms.c: adding header inclusion, removing unnecessary NULL checking,
   and add cancel_work_sync in removal handler to wait possible pending
   works.
(Changes only rtsx_usb_ms. Other files remain the same to v4)

v6:
NOTE:since the v3 of patch 1/3 (rtsx_usb) has been merged, only diffs are
submitted and splitted into two.
1. rtsx_usb.c: fix possible race conditions:
   rtsx_usb_bulk_transfer_sglist(): del_timer() => del_timer_sync()
   rtsx_usb_probe(): move setup_timer() before mfd_add_devices() and also
		     remove unnecessary init_timer()
2. rtsx_usb.c: rtsx_usb_suspend(): add comments to LED turn-off
(Changes only rtsx_usb.c. Other files remain the same to v5)

Roger Tseng (4):
  [v6 fix] mfd/rtsx_usb: fix possible race condition
  [v6 fix] mfd/rtsx_usb: add comment in rtsx_usb_suspend
  mmc: Add realtek USB sdmmc host driver
  memstick: Add realtek USB memstick host driver

 drivers/memstick/host/Kconfig       |   10 +
 drivers/memstick/host/Makefile      |    1 +
 drivers/memstick/host/rtsx_usb_ms.c |  839 ++++++++++++++++++++
 drivers/mfd/rtsx_usb.c              |   14 +-
 drivers/mmc/host/Kconfig            |    7 +
 drivers/mmc/host/Makefile           |    1 +
 drivers/mmc/host/rtsx_usb_sdmmc.c   | 1462 +++++++++++++++++++++++++++++++++++
 7 files changed, 2330 insertions(+), 4 deletions(-)
 create mode 100644 drivers/memstick/host/rtsx_usb_ms.c
 create mode 100644 drivers/mmc/host/rtsx_usb_sdmmc.c

-- 
1.8.2

