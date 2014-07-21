Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbaGUGFg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 02:05:36 -0400
Received: from mga14.intel.com ([192.55.52.115]:52690 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285AbaGUGFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 02:05:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="564766858"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH v3 00/14] ACPI/EC: Add event storm prevention and cleanup command storm prevention.
Date: Mon, 21 Jul 2014 14:04:51 +0800
Message-Id: <cover.1405922585.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1403060601.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note that this patchset is very stable now, it is sent as RFC because it
depends on an ACPICA GPE enhancement series which might be merged from
ACPICA upstream.

This patchset is based on the previous ACPI/EC bug fixes series and the GPE
API enhancement series.

For the EC driver, GPE must be disabled to prevent the following storms:
1. Command errors:
   If there are too many IRQs coming during a command processing period and
   such IRQs are not related to the event (EVT_SCI),
   acpi_set_gpe(ACPI_GPE_DISABLE) is invoked to prevent further storms
   during the same command transaction. This is not implemented in a good
   style. Ideally, we should only enable storm prevention for the current
   command so that the next command can try the efficient interrupt mode
   again.
   This patchset enhances this storm prevention (PATCH 01, 03-04).
2. Event errors:
   There are cases that BIOS doesn't provide a _Qxx method for the returned
   xx query value, in this case, acpi_set_gpe(ACPI_GPE_DISABLE) need to be
   invoked to prevent event IRQ storms. This case is detected during the EC
   bug fix:
     https://bugzilla.kernel.org/show_bug.cgi?id=70891
   There is a dmesg showing a 0x0D query storm, for which there is no _Q0D
   method provided by the ACPI table to handle (comment 55), this becomes a
   GPE storm and slows down the machine a lot, it takes longer time for
   Linux to complete the bootup (comment 80).
   This patchset implements such storm prevention (PATCH 06-07 10-11),
   turning EC driver into the polling mode when the storm happens so that
   other tasks can be processed by the CPU without being affected by this
   GPE storm.
3. Pending events:
   Though GPE is edge triggered, the underlying firmware may maliciously
   trigger GPE when IRQ is indicated. This makes EC GPE more like a level
   triggered interrupt. In case of event (EVT_SCI), since the Linux EC
   driver responses it (using QR_EC command) in the task context with the
   GPE enabled, there are chances for a GPE storm to occur before QR_EC is
   executed.
   A common solution is to implement an IRQ context QR_EC issuing, this is
   also a must-take step to convert the EC GPE handler into the threaded
   IRQ model. The above bug link contains a prototype to achieve this, but
   it fails to pass the suspend/resume tests. And the reporter shows a case
   that user commands need to be executed while EVT_SCI is indicated
   because _Qxx method evaluation requires normal EC command to be executed
   by the EC driver to complete the event (EVT_SCI) handling. Without
   further investigation in ACPICA to see if this evaluation will block the
   event handler, it is better to keep the current proven task context
   style QR_EC issuing to allow user commands to compete with QR_EC to be
   executed. I'll try IRQ mode QR_EC issuing later using another patch
   series.
   If we still want to keep the task context responding logic, for such EC
   hardware/firmware, acpi_set_gpe(ACPI_GPE_DISABLE) should be invoked
   after EVT_SCI interrupt is indicated and acpi_set_gpe(ACPI_GPE_ENABLE)
   should be invoked before the first step of QR_EC has taken place.
   Since there is no real cases are reported, this patchset doesn't
   introduce such storm prevention, but only makes it possible to implement
   this for such platform by invoking acpi_enable_gpe() when EVT_SCI is
   detected and decreasing the GPE reference after QR_EC command is issued
   (PATCH 10), acpi_set_gpe() can be invoked between them as a quirk for
   such platforms. This facility has passed the unit tests of system
   suspend/resume flushing, in such cases all EC IRQs are polled by the
   task context waiters.

All of the above storm prevention supports are implemented using the ideal
GPE handling model provided by the previous GPE API enhancement series.

This patchset also contains an EC commands flushing support. By
implementing EC commands flushing, we now achieve an additional benefit:
Some EC driven ACPI devices may require all submitted EC commands to be
completed before they can be safely suspended or unplugged. Otherwise the
state of such devices will be broken.

The refined patches are also passed the runtime/suspend tests carried out
on the following platforms:
  "Dell Inspiron Mini 1010" - i386 kernel
  "Dell Latitude 6430u" - x86_64 kernel

This patchset also includes a unit test facility, I used it to test the
hotplug support code in the driver. It's useful for future EC development.

Lv Zheng (14):
  ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
  ACPI/EC: Add detailed command/query debugging information.
  ACPI/EC: Cleanup command storm prevention using the new GPE handling
    model.
  ACPI/EC: Refine command storm prevention support.
  ACPI/EC: Add reference counting for query handlers.
  ACPI/EC: Add command flushing support.
  ACPI/EC: Add a warning message to indicate event storms.
  ACPI/EC: Refine event/query debugging messages.
  ACPI/EC: Add CPU ID to debugging messages.
  ACPI/EC: Cleanup QR_SC command processing by adding a kernel thread
    to poll EC events.
  ACPI/EC: Add event storm prevention support.
  ACPI/EC: Add GPE reference counting debugging messages.
  ACPI/EC: Add unit test support for EC driver hotplug.
  ACPI/EC: Cleanup coding style.

 drivers/acpi/ec.c       |  566 ++++++++++++++++++++++++++++++++++++++---------
 drivers/acpi/internal.h |    3 +
 2 files changed, 462 insertions(+), 107 deletions(-)

-- 
1.7.10

