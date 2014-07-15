Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbaGODOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 23:14:30 -0400
Received: from mga11.intel.com ([192.55.52.93]:42816 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757125AbaGODO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 23:14:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,662,1400050800"; 
   d="scan'208";a="569861390"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 00/10] ACPI/EC: Add event storm prevention and cleanup command storm prevention.
Date: Tue, 15 Jul 2014 11:14:23 +0800
Message-Id: <cover.1405391678.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1403060601.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on the previous ACPI/EC bug fixes series and the GPE
API enhancement series.

During the bug fix, there is a dmesg showing Linux EC driver doesn't
support EC event storm prevention.
  https://bugzilla.kernel.org/show_bug.cgi?id=70891
The comment 55 contains the dmesg log that shows a 0x0D event storm, for
which there is no _Q0D method provided by the ACPI table to handle. This
becomes a GPE storm and slows down the machine a lot, it tooks longer time
for Linux to boot (see comment 80).

This patchset implements event storm prevention, turning EC driver into
polling mode when the storm happens so that other tasks can be processed
by the CPU without being affected by this GPE storm.
In current EC driver, we only have command storm prevention implemented,
this patch also refines the command storm prevention support.

All of the above storm prevention support are implemented using the ideal
GPE handling model provided by the previous GPE API enhancement series.
The ideal GPE handling model should be able to handle the following cases:

This patchset also contains an EC commands flushing support. This is
required to implement event storm prevention. By utilizing the GPE APIs, we
need to invoke acpi_set_gpe() before invoking acpi_disable_gpe() to prevent
storms. Without implementing flushing, there is no such a point invoking
acpi_disable_gpe() before all commands have been completed.
By implementing EC commands flushing, we now achieve an additional benefit:
Some EC driven ACPI devices may require all submitted EC commands to be
completed before they can be safely suspended or unplugged. Otherwise the
state of such devices will be broken.
When implementing IO flushing, there always need to be 2 flags to indicate
an intermediate state - old IO submissions observe the (STARTED) flag to
continue; new IO submissions observe the (STOPPED) flag to be discarded.
After introducing the 2 flags, a "stop waiter" is implemented for the
suspending/removing operations of the EC driver.

The refined patches are also passed the runtime/suspend tests carried out
on the following platforms:
  "Dell Inspiron Mini 1010" - i386 kernel
  "Dell Latitude 6430u" - x86_64 kernel

This patchset also includes a unit test facility, I used it to test the
hotplug support code in the driver. It's useful for future EC development.

Lv Zheng (10):
  ACPI/EC: Introduce STARTED/STOPPED flags to replace BLOCKED flag.
  ACPI/EC: Add detailed command/query debugging information.
  ACPI/EC: Deploy the new GPE handling model.
  ACPI/EC: Refine command storm prevention support.
  ACPI/EC: Add reference counting for query handlers.
  ACPI/EC: Add a warning message to indicate event storms.
  ACPI/EC: Refine event/query debugging messages.
  ACPI/EC: Add command flushing support.
  ACPI/EC: Add event storm prevention support.
  ACPI/EC: Add unit test support for EC driver hotplug.

 drivers/acpi/ec.c       |  293 ++++++++++++++++++++++++++++++++++++++---------
 drivers/acpi/internal.h |    1 +
 2 files changed, 239 insertions(+), 55 deletions(-)

-- 
1.7.10

