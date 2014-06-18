Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403AbaFRDRm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:17:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:13090 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058AbaFRDRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:17:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,498,1400050800"; 
   d="scan'208";a="549553875"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH 0/9] ACPI/EC: Improve GPE handling model.
Date: Wed, 18 Jun 2014 11:17:10 +0800
Message-Id: <cover.1403060601.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on the previous ACPI/EC bug fixes series.

This patchset has fixed the following issues:
1. Enables the ideal GPE handling model.
   The ideal GPE handling model should be able to handle the following
   cases:
   1. When upper layers (the users of the driver) submit requests to the
      drivers, it means they care about the underlying hardware. For this
      case, acpi_enable_gpe() should be invoked. When the reference count
      is increased from 0 to 1, driver enables the hardware IRQ. And
      acpi_disable_gpe() is used as the reversal when the users have
      completed the submitted requests.
   2. Driver may temporarily disables the IRQ and wants to re-enable it
      later, this case is normally used in order to prevent IRQ storm.
      When a driver cannot fully solve the condition that triggered the IRQ
      in the IRQ context, in order not to trigger IRQ storm, driver has to
      disable IRQ and re-enables it in the deferred execution environment
      - which should be in a task context. The acpi_set_gpe() API should be
      used exactly for this purpose.
   The reason why this model hasn't been enabled for the current Linux ACPI
   drivers is:
     In ACPICA, the same GPE lock is held while invoking the GPE handler
     callback, it's thus impossible to invoke GPE APIs in the GPE handler
     because the APIs requires to hold the GPE lock. The recursive locking
     leads to dead locks. This is a simple design defect, callbacks should
     always be invoked in a lockless environment, normally in Linux, this
     is achieved by RCU locking, and in ACPICA, we achieve this using
     reference counting.
   After fixing the above bug and doing necessary cleanups in the ACPICA
   GPE handling code, we now can enable this ideal GPE handling model for
   the EC driver to use.
2. Enables the EC commands flushing.
   This is quite important for ACPI platforms. Some EC driven ACPI devices
   may require all submitted EC commands to be completed before they can
   be safely suspended or unplugged. Otherwise the state of such devices
   will be broken.
   When implementing IO flushing, there always need to be 2 flags to
   indicate an intermediate state - old IO submissions observe the
   (STARTED) flag to continue; new IO submissions observe the (STOPPED)
   flag to be discarded. After introducing the 2 flags, a "stop waiter"
   is implemented for the suspending/removing operations of the EC driver.

The refined patches are passed the runtime/suspend tests carried out on the
following platforms:
  "Dell Inspiron Mini 1010" - i386 kernel
  "Dell Latitude 6430u" - x86_64 kernel
In this patchset, a unit test facility is also implemented. Test results
show that the GPE APIs and EC GPE model are now safe for hotplug support.

Lv Zheng (9):
  ACPICA: Events: Reduce indent divergences of events files.
  ACPICA: Events: Fix an issue that GPE APIs cannot be invoked in
    atomic context.
  ACPICA: Events: Introduce acpi_set_gpe()/acpi_finish_gpe() to reduce
    divergences.
  ACPICA: Events: Remove acpi_ev_enable_gpe().
  ACPICA: Events: Reduce divergences to honor notify handler enabled
    GPEs.
  ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
  ACPI/EC: Add detailed command/query debugging information.
  ACPI/EC: Deploy the new GPE handling model.
  ACPI/EC: Add unit test support for EC driver hotplug.

 drivers/acpi/acpica/acevents.h |    1 +
 drivers/acpi/acpica/aclocal.h  |    5 +-
 drivers/acpi/acpica/evgpe.c    |  130 ++++++++++++++++--------------
 drivers/acpi/acpica/evxface.c  |   41 +++++++---
 drivers/acpi/acpica/evxfgpe.c  |  105 ++++++++++++++++++++++++
 drivers/acpi/ec.c              |  174 +++++++++++++++++++++++++++++++++-------
 6 files changed, 350 insertions(+), 106 deletions(-)

-- 
1.7.10

