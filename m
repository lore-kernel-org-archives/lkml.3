Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab3GWIKP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 04:10:15 -0400
Received: from mga11.intel.com ([192.55.52.93]:3476 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754383Ab3GWIJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 04:09:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,725,1367996400"; 
   d="scan'208";a="374543142"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Corey Minyard <minyard@acm.org>,
        Zhao Yakui <yakui.zhao@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, linux-acpi@vger.kernel.org,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH 00/13] ACPI/IPMI: Fix several issues in the current codes
Date: Tue, 23 Jul 2013 16:08:32 +0800
Message-Id: <cover.1374566394.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1370652213.git.lv.zheng@intel.com>
References: <cover.1370652213.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset tries to fix the following kernel bug:
Buglink: https://bugzilla.kernel.org/show_bug.cgi?id=46741
This is fixed by [PATCH 05].

The bug shows IPMI operation region may appear in a device not under the
IPMI system interface device's scope, thus it's required to install the
ACPI IPMI operation region handler from the root of the ACPI namespace.

The original acpi_ipmi implementation includes several issues that break
the test process.  This patchset also includes a re-design of acpi_ipmi
module to make the test possible.
 
[PATCH 01-05] are bug-fix patches that can be applied to the kernels whose
              version is > 2.6.38.  This can be confirmed with:
              # git tag --contains e92b297c
[PATCH 06] is also a bug-fix patch.
           The drivers/acpi/osl.c part can be back ported to the kernels
           whose version > 2.6.14.  This can be confirmed with:
           # git tag --contains 4be44fcd
           The drivers/acpi/acpi_ipmi.c part can be applied on top of
           [PATCH 01-05].
[PATCH 07] is a tuning patch for acpi_ipmi.c.
[PATCH 08-10] are cleanup patches for acpi_ipmi.c.
[PATCH 11] is a cleanup patch not for acpi_ipmi.c.
[PATCH 12-13] are test patches.
              [PATCH 12] may be accepted by upstream kernel as a useful
                         facility to test the loading/unloading of the
                         modules.
              [PATCH 13] should not be merged by any published kernel as it
                         is a driver for a pseudo device with a PnP ID that
                         does not exist in the real machines.

This patchset has passed the test around a fake device accessing IPMI
operation region fields on an IPMI capable platform.  A stress test of
module(acpi_ipmi) load/unload has been performed on such platform.  No
races can be found and the IPMI operation region handler is functioning
now.  It is not possible to test module(ipmi_si) load/unload as it can't be
unloaded due to its' transfer flushing implementation.

Lv Zheng (13):
  ACPI/IPMI: Fix potential response buffer overflow
  ACPI/IPMI: Fix atomic context requirement of ipmi_msg_handler()
  ACPI/IPMI: Fix race caused by the unprotected ACPI IPMI transfers
  ACPI/IPMI: Fix race caused by the unprotected ACPI IPMI user
  ACPI/IPMI: Fix issue caused by the per-device registration of the
    IPMI operation region handler
  ACPI/IPMI: Add reference counting for ACPI operation region handlers
  ACPI/IPMI: Add reference counting for ACPI IPMI transfers
  ACPI/IPMI: Cleanup several acpi_ipmi_device members
  ACPI/IPMI: Cleanup some initialization codes
  ACPI/IPMI: Cleanup some inclusion codes
  ACPI/IPMI: Cleanup some Kconfig codes
  Testing: Add module load/unload test suite
  ACPI/IPMI: Add IPMI operation region test device driver

 drivers/acpi/Kconfig                          |   71 +++-
 drivers/acpi/Makefile                         |    1 +
 drivers/acpi/acpi_ipmi.c                      |  513 +++++++++++++++----------
 drivers/acpi/ipmi_test.c                      |  254 ++++++++++++
 drivers/acpi/osl.c                            |  224 +++++++++++
 include/acpi/acpi_bus.h                       |    5 +
 tools/testing/module-unloading/endless_cat.sh |   32 ++
 tools/testing/module-unloading/endless_mod.sh |   81 ++++
 8 files changed, 977 insertions(+), 204 deletions(-)
 create mode 100644 drivers/acpi/ipmi_test.c
 create mode 100755 tools/testing/module-unloading/endless_cat.sh
 create mode 100755 tools/testing/module-unloading/endless_mod.sh

-- 
1.7.10

