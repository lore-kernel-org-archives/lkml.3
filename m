Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab3GCOCK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 10:02:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:7914 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab3GCOCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 10:02:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,988,1363158000"; 
   d="scan'208";a="359952432"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Yinghai Lu <yinghai@kernel.org>,
        john.ronciak@intel.com, miles.j.penner@intel.com,
        bruce.w.allan@intel.com,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, x86@kernel.org
Subject: [PATCH v2 0/8] Thunderbolt workarounds
Date: Wed,  3 Jul 2013 17:04:47 +0300
Message-Id: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's the next revision of the workarounds for Thunderbolt machines. The
previous revision can be found here:

  https://lkml.org/lkml/2013/6/25/400

The series fixes problems seen in ACPI hotplug driver and resource
re-allocation issue in pcibios_resource_survey_bus(). With these applied we
have been able to connect Thunderbolt chain as long as:

  PC +--+ eSata Hub #0 +--+ eSata Hub #1 +--+ Apple Thunderbolt display +--+ Apple ethernet dongle

That's all Thunderbolt devices we have for testing. This results the
following PCIe tree (output of lspci -tv):

  +-1c.4-[06-80]----00.0-[07-80]--+-00.0-[08]--
  |                               +-03.0-[09-7d]----00.0-[0a-7d]--+-03.0-[0b]----00.0  Marvell Technology Group Ltd. Device 9182
  |                               |                               +-04.0-[0c-7c]----00.0-[0d-7c]--+-03.0-[0e]----00.0  Marvell Technology Group Ltd. Device 9182
  |                               |                               |                               +-04.0-[0f-7b]----00.0-[10-7b]--+-00.0-[11-13]----00.0-[12-13]----03.0-[13]--+-00.0  Pericom Semiconductor Device 400e
  |                               |                               |                               |                               |                                            +-00.1  Pericom Semiconductor Device 400e
  |                               |                               |                               |                               |                                            \-00.2  Pericom Semiconductor Device 400f
  |                               |                               |                               |                               +-01.0-[14]----00.0  Broadcom Corporation NetXtreme BCM57761 Gigabit Ethernet PCIe
  |                               |                               |                               |                               +-02.0-[15]----00.0  Agere Systems FW643 PCI Express 1394b Controller (PHY/Link)
  |                               |                               |                               |                               +-03.0-[16]--
  |                               |                               |                               |                               +-04.0-[17-7a]----00.0-[18-7a]----00.0-[19]----00.0  Broadcom Corporation Device 1682
  |                               |                               |                               |                               \-05.0-[7b]--
  |                               |                               |                               \-05.0-[7c]--
  |                               |                               \-05.0-[7d]--
  |                               +-04.0-[7e]--
  |                               +-05.0-[7f]--
  |                               \-06.0-[80]--


There are still problems with individual device drivers not handling the
surprise hotplug nature of Thunderbolt devices correctly but that can be
handled per driver later on.

This has been tested on Acer Aspire S5 ultrabook and in addition to that on
Intel DZ77RE-75K desktop.

Changes to the previous version:
  [1/8] A new patch that fixes pcibios_resource_survey_bus() to handle
        re-allocation of resources properly. This patch should be first one
	in the series because the following patches then enable things that
	depend on this one.
  [3/8] Dropped !dev->subordinate->is_added check. This is handled in [1/6].
  [4/8] Removed 'continue' and call directly pci_trim_stale_devices() and
        fold the pci_trim_stale_devices() to this patch.
  [5/8] A new patch that removes SLOT_ENABLED flag completely from the
        acpiphp driver. This is a separate patch to make reverting easy
	in case there appears regressions but still make Thunderbolt
	working.
  [6/8] Use the original Kirill's workaround for Acer Aspire S5.
  [7,8/8] New cleanups for acpiphp that were found during development.

The series applies on top of v3.10.

Kirill A. Shutemov (4):
  PCI: acpiphp: do not check for SLOT_ENABLED in enable_device()
  PCI: acpiphp: enable_device(): rescan even if no new devices on slot
  PCI: acpiphp: check for new devices on enabled host
  PCI: acpiphp: workaround for Thunderbolt on Acer Aspire S5

Mika Westerberg (4):
  x86/PCI: prevent re-allocation of already existing bridge and ROM
    resources
  PCI: acpiphp: kill SLOT_ENABLED in favor of always re-enumerating the
    devices
  PCI: acpiphp: get rid of unused constants in acpiphp.h
  PCI: acpiphp: sanitize acpiphp_get_[latch|adapter]_status()

 arch/x86/pci/i386.c                |  4 ++
 drivers/pci/hotplug/acpi_pcihp.c   | 13 +++++
 drivers/pci/hotplug/acpiphp.h      |  5 --
 drivers/pci/hotplug/acpiphp_glue.c | 97 ++++++++++++--------------------------
 drivers/pci/remove.c               | 20 ++++++++
 include/linux/pci.h                |  1 +
 6 files changed, 69 insertions(+), 71 deletions(-)

-- 
1.8.3.2

