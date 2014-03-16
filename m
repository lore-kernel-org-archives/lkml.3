Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220AbaCPRDY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 13:03:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:10561 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219AbaCPRDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 13:03:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,664,1389772800"; 
   d="scan'208";a="501093743"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V3 00/11] ACPI: change the way of enumerating PNPACPI/Platform devices
Date: Mon, 17 Mar 2014 01:03:06 +0800
Message-Id: <1394989397-2733-1-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

Currently, PNP bus is used as the default bus for for enumerating ACPI
devices with _HID/_CID.
For a device that needs to be enumerated to platform bus, we need to add
its id string to the platform scan handler white list explicitly.

This becomes a problem as more and more _HID devices need to be
enumerated to platform bus nowadays, thus the list is continuously growing.

So, a solution that uses platform bus for _HID enumeration by default
is preferred.

In order to do this, this patch set
First (Patch 1~5), changes the way of enumerating PNP devices.
We introduce a white list to create PNP devices instead. The white list contains
all the pnp_device_id strings in all the pnp drivers, thus this change is
transparent to PNP core and all the PNP drivers.
Second (Patch 6~13), changes the code to enumerate ACPI _HID devices to platform
bus by default, unless the device already has a scan handler attached.

The patches of this patch set has been tested on my desktop machine,
I can see that there are four PNP devices disappeared from PNP bus
/sys/bus/pnp/devices/00:01/id:PNP0200
/sys/bus/pnp/devices/00:02/id:INT0800
/sys/bus/pnp/devices/00:03/id:PNP0103
/sys/bus/pnp/devices/00:0a/id:PNP0c04
and all of these devices have no associated drivers in kernel.

At the same time there are 10 more platform devices created,
/sys/bus/platform/devices/INT0800:00  
/sys/bus/platform/devices/PNP0103:00  (HPET)
/sys/bus/platform/devices/PNP0C04:00  (Numeric data processor?)
/sys/bus/platform/devices/PNP0C0B:00  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:01  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:02  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:03  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:04  (ACPI fan)
/sys/bus/platform/devices/PNP0C0C:00  (Power Button)
/sys/bus/platform/devices/PNP0C14:00  (ACPI wmi)

Clarification:
Although it seems that we are introducing a much bigger white list to replace
a small one, the benefit is that
1. without the patch, the acpi_platform scan handler white list is
   continuously growing.
2. with the patch set, the PNPACPI scan handler white list will become
   smaller and smaller by
   a) remove the ids from the PNPACPI white list, for the devices
      that are never enumerated via ACPI
   b) remove the ids from the PNPACPI whilte list and convert the drivers to
      platform bus drivers, for the devices that are not PNP devices in nature.
   which will be done later.

Known Issue:
PNP bus does not check the device resources when adding a new PNP device,
while Platform bus does by invoking insert_resource() in platform_device_add().
This results in failure when creating platform device node for some ACPI
device objects in case there is resource conflict.
In my desktop, I can see that
Creating PNP0200:00 (DMA controller) fails because its resource (IO: 0x81 ~ 0x91)
conflicts with "0080-008f : dma page reg"
and
Creating PNP0C02:02 fails because its resource (IO: 0x72 ~ 0x7f)
conflicts with "0070-0077 : PNP0B00:00" (CMOS RTC).

Known Issue:
Currently, we can't enumerate devices with _CID PNP0C01/PNP0C02 to platform bus
because we need them in PNP bus in order to reserve mother board resources.

thanks,
rui

----------------------------------------------------------------

Changes in V3:
1. rename enumerable_id to platform_id according to Rafael' suggestion.
2. drop two patches to handle devices with _CID PNP0C01/PNP0C02 enumeration
   because the code in drivers/pnp/system.c is still under discussion.
3. make cmos rtc scan handler return 1 so that the device will not be
   enumerated to platform bus.

Changes in V2:
1.move acpi pnp scan handler from drivers/pnp/pnpacpi/core.c to
  drivers/acpi/acpi-pnp.c, because the scan handler needs to be always built
  in to prevent platform devices from being created for those ACPI devices.
2.remove the __init tag for the acpi pnp scan handler because the scan
  handler is still needed after system initialization, for hotplug.
3.introduce enumerable_id flag for devices that can be enumerated to platform
  bus.
4.introduce excluded id list for creating platform devices, because some
  devices have _HID but they will never be associated with a platform driver.
5.introduce dummy lpss/container/memory_hotplug scan handler to prevent
  platform devices from being created for those ACPI device objects.

----------------------------------------------------------------
Zhang Rui (11):
      ACPI: introduce .match() callback for ACPI scan handler
      PNPACPI: use whilte list for pnpacpi device enumeration
      ACPI: remove ids that does not comply with the ACPI PNP id rule
      ACPI: remove unsupported serial PNP ids from acpi pnp scan handler id lsit
      ACPI: check and enumerate CMOS RTC devices explicitly
      ACPI: introduce platform_id flag
      ACPI: use platform bus as the default bus for _HID enumeration
      ACPI: introduce dummy lpss scan handler
      ACPI: introduce acpi platform exclude id list
      ACPI: introduce dummy container scan handler
      ACPI: introduce dummy memory hotplug scan handler

 drivers/acpi/Makefile          |    7 +-
 drivers/acpi/acpi_cmos_rtc.c   |    2 +-
 drivers/acpi/acpi_lpss.c       |   66 +++++--
 drivers/acpi/acpi_memhotplug.c |   45 +++--
 drivers/acpi/acpi_platform.c   |   38 ++--
 drivers/acpi/acpi_pnp.c        |  381 ++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/container.c       |   21 +++
 drivers/acpi/internal.h        |   15 +-
 drivers/acpi/scan.c            |   38 ++--
 drivers/pnp/pnpacpi/core.c     |   28 +--
 include/acpi/acpi_bus.h        |    4 +-
 include/linux/acpi.h           |    2 +
 12 files changed, 534 insertions(+), 113 deletions(-)
 create mode 100644 drivers/acpi/acpi_pnp.c

