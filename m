Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752091AbaEVSCm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 14:02:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:39528 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaEVSCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 14:02:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,888,1392192000"; 
   d="scan'208";a="516171437"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        mika.westerberg@linux.intel.com, Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V7 00/11] ACPI: ACPI enumeration rework
Date: Fri, 23 May 2014 02:02:22 +0800
Message-Id: <1400781753-2682-1-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
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
First (Patch 1~4), changes the way of enumerating PNP devices.
We introduce a white list to create PNP devices instead. The white list contains
all the pnp_device_id strings in all the pnp drivers, thus this change is
transparent to PNP core and all the PNP drivers.
Second (Patch 5~11), changes the code to enumerate ACPI _HID devices to platform
bus by default.

Tis patch set has been tested on my desktop machine,
and a TOSHIBA PORTEGE Z830 ultrabook.

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
Creating PNP0C02:02 fails because its resource (IO: 0x72 ~ 0x7f)
conflicts with "0070-0077 : PNP0B00:00" (CMOS RTC).

Known Issue:
Currently, we can't enumerate devices with _CID PNP0C01/PNP0C02 to platform bus
because we need them in PNP bus in order to reserve mother board resources.

thanks,
rui

----------------------------------------------------------------
Changes in V7:
1. always registering the same scan handler, but with an optional NULL .attach() callback
   instead of registering a dummy handler.
2. avoid enumerting SPB slave devices by checking the SPB resources
   instead of introduing & setting & checking a flag in the SPB master device.

Changes in V6:
1. Patch re-ordering to avoid bisect breakage.
2. rework the patch for fixing the "redudent platform devices created for lpss
   slaves" issue according to Rafael' comments.

Changes in V5:
1. fix a problem that ACPI tries to enumerate lpss slaves to platform bus
2. rebased on 3.14 kernel

Changes in V4:
1. coding style cleanups, fix checkpatch warnings/errors.

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
      ACPI: allow scan handlers without .attach() callback
      ACPI: always register container scan handler even if CONFIG_ACPI_CONTAINER is cleared
      ACPI: always register memory hotplug scan handler even if CONFIG_ACPI_HOTPLUG_MEMORY is cleared
      ACPI: always register memory hotplug scan handler even if CONFIG_X86_INTEL_LPSS is cleared
      ACPI: introduce platform_id flag
      ACPI: use platform bus as the default bus for _HID enumeration
      ACPI: introduce acpi platform exclude id list

 drivers/acpi/Makefile          |   7 ++--
 drivers/acpi/acpi_cmos_rtc.c   |   2 +-
 drivers/acpi/acpi_lpss.c       |  63 ++++++++++++++++++----------
 drivers/acpi/acpi_memhotplug.c |  46 ++++++++++----------
 drivers/acpi/acpi_platform.c   |  39 ++++++-----------
 drivers/acpi/acpi_pnp.c        | 382 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/acpi/container.c       |  18 +++++---
 drivers/acpi/internal.h        |  15 +------
 drivers/acpi/scan.c            |  83 +++++++++++++++++++++++++++++++-----
 drivers/pnp/pnpacpi/core.c     |  28 ++-----------
 include/acpi/acpi_bus.h        |   4 +-
 include/linux/acpi.h           |   2 +
 12 files changed, 560 insertions(+), 129 deletions(-)
 create mode 100644 drivers/acpi/acpi_pnp.c
