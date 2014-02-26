Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaBZJLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:11:24 -0500
Received: from mga01.intel.com ([192.55.52.88]:7547 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750849AbaBZJLS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:11:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="488297784"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH 0/8] ACPI: change the way of enumerating PNPACPI/Platform devices
Date: Wed, 26 Feb 2014 17:11:06 +0800
Message-Id: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

Currently, PNP bus is used as the default bus for for enumerating ACPI
devices with _HID/_CID.
For a device that needs to be enumerated to platform bus, we need to add
its _HID/_CID to the platform scan handler white list explicitly.

This becomes a problem as more and more _HID devices need to be
enumerated to platform bus nowadays, thus the list is continuously growing.

So, a solution that uses platform bus for _HID enumeration by default
is preferred.

In order to do this, this patch set
first, changes the way of enumerating PNP devices. We introduce a white list
to create PNP devices instead. The white list contains all the pnp_device_id
strings in all the pnp drivers, thus this change is transparent to PNP core
and all the PNP drivers.
second, changes the code to enumerate ACPI devices with _HID/_CID to platform
bus by default, unless the device already has a scan handler attached.

The patches of this patch set has been tested on my desktop machine,
I can see that there are four PNP devices disappeared from PNP bus
/sys/bus/pnp/devices/00:01/id:PNP0200
/sys/bus/pnp/devices/00:02/id:INT0800
/sys/bus/pnp/devices/00:03/id:PNP0103
/sys/bus/pnp/devices/00:0a/id:PNP0c04
and all of these devices has no driver attached.

At the same time there are 21 more platform devices created,
/sys/bus/platform/devices/INT0800:00  
/sys/bus/platform/devices/INT3F0D:00  
/sys/bus/platform/devices/LNXSYSTM:00 (ACPI system bus/root node)
/sys/bus/platform/devices/LNXTHERM:00 (ACPI thermal zone)
/sys/bus/platform/devices/LNXTHERM:01 (ACPI thermal zone)
/sys/bus/platform/devices/PNP0000:00  (PIC)
/sys/bus/platform/devices/PNP0100:00  (system timer?)
/sys/bus/platform/devices/PNP0103:00  (HPET)
/sys/bus/platform/devices/PNP0B00:00  (CMOS RTC)
/sys/bus/platform/devices/PNP0C01:00  (system board)
/sys/bus/platform/devices/PNP0C01:00  (system board)
/sys/bus/platform/devices/PNP0C02:00  (General ID for reserving resources)
/sys/bus/platform/devices/PNP0C02:03  (General ID for reserving resources)
/sys/bus/platform/devices/PNP0C04:00  (Numeric data processor?)
/sys/bus/platform/devices/PNP0C0B:00  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:01  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:02  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:03  (ACPI fan)
/sys/bus/platform/devices/PNP0C0B:04  (ACPI fan)
/sys/bus/platform/devices/PNP0C0D:00  (ACPI lid)
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

But anyway, IMO, this specific problem does not mean the proposal of this patch
is wrong, thus I send this patch out for early review to see if I'm in the right
direction.
Any comments are really welcome.

thanks,
rui

----------------------------------------------------------------
Zhang Rui (8):
      ACPI: introduce .match() callback for ACPI scan handler
      PNPACPI: use whilte list for pnpacpi device enumeration
      PNPACPI: remove ids that does not comply with the ACPI PNP id rule
      PNPACPI: remove unsupported serial PNP ids from PNPACPI id list
      PNPACPI: check and enumerate CMOS RTC devices explicitly
      ACPI: use platform bus as the default bus for _HID enumeration
      Revert "ACPI / PNP: skip ACPI device nodes associated with physical nodes already"
      PNPACPI: create both PNP and Platform device nodes for PNP0C01/PNP0C02

 drivers/acpi/acpi_platform.c |   28 ---
 drivers/acpi/scan.c          |   31 ++--
 drivers/pnp/pnpacpi/core.c   |  417 ++++++++++++++++++++++++++++++++++++++----
 include/acpi/acpi_bus.h      |    1 +
 include/linux/pnp.h          |    3 +
 5 files changed, 402 insertions(+), 78 deletions(-)

