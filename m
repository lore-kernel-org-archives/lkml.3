Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaE0R1l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 13:27:41 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:53673 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaE0R1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 13:27:33 -0400
From: Lv Zheng <zetalog@gmail.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <zetalog@gmail.com>, Lv Zheng <lv.zheng@intel.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [RFC PATCH 0/6] ACPICA: 64bit FADT addresses enabling.
Date: Wed, 28 May 2014 01:27:15 +0800
Message-Id: <cover.1401210684.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <38907770.bupFXhytsS@vostro.rjw.lan>
References: <38907770.bupFXhytsS@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lv Zheng <lv.zheng@intel.com>

This series enable 64-bit addresses on top of linux-pm.git/linux-next.

Commit 0249ed2444d6 (ACPICA: Add option to favor 32-bit FADT addresses.)
breaks resuming from system-suspend on the Intel DP45SG board.

This is because the commit has changed the default behavior of original
Linux.  And the root cause is:
1. BIOS may favor the FACS reported via the "FIRMWARE_CTRL" field in the
   FADT while the commit doesn't set the firmware waking vector address of
   the FACS reported by "FIRMWARE_CTRL", it only sets the firware waking
   vector address of the FACS reported by "X_FIRMWARE_CTRL" or
2. BIOS may favor the 64-bit FACS waking vector address when the version of
   the FACS is greater than 0 while Linux currently only supports resuming
   from the real mode, so the 64-bit firmware waking vector is not tested
   and set to 0.

This patchset fixes this issue by excluding the above 2 cases and
re-enables 64-bit FADT addresses again using the following smarter way:
1. Restore old behavior of 32-bit favor for FADT;
2. To exclude cause 1:
   Add 64-bit firmware waking vector setting support for selected FACS,
   the 64-bit firmware waking vector favor is also controlled by the new
   acpi_set_firmware_waking_vector() parameter. OSPM that supports 32-bit
   waking environment can set a valid physical address here. For Linux
   which only supports real mode waking environment, this should be 0.
3. Fix 32-bit FACS favor by loading both 32-bit and 64-bit FACS, the
   selection of FACS is controlled by a new global option -
   acpi_gbl_use32_bit_facs_addresses, which is set to TRUE to select the
   FACS reported by "FIRMWARE_CTRL" field. Add firmware waking vector
   setting support for both 32-bit and 64-bit FACS. This is used to work
   around the reported platform where 2 FACS is reported in the FADT;
4. Restore new behavior of 64-bit favor for FADT.
So that it is ensured that the 32-bit firmware waking vector address of the
FACS reported by "FIRMWARE_CTRL" filed is still set after enabling 64-bit
FADT addresses favor.
To enable X_FIRMWARE_CTRL favor and 64-bit firmware waking vector favor,
OSPMs are required to set acpi_gbl_use32_bit_facs_addresses to FALSE and
pass a valid 64-bit firmware waking vector address for
acpi_set_firmware_waking_vector() invocations, thus now the FACS favor and
the 64-bit firmware waking vector support can be completely controlled by
OSPMs and ACPICA does not make any decision silently.

Lv Zheng (6):
  ACPICA: Hardware: Reduce divergences for sleep functions.
  ACPICA: Hardware: Enable 64-bit firmware waking vector for selected
    FACS.
  ACPI: sleep: Update acpi_set_firmware_waking_vector() invocations to
    favor 32-bit firmware waking vector.
  ACPICA: Tables: Enable both 32-bit and 64-bit FACS.
  ACPICA: Hardware: Enable firmware waking vector for both 32-bit and
    64-bit FACS.
  ACPICA: Tables: Enable default 64-bit FADT addresses favor.

 arch/ia64/include/asm/acpi.h    |    1 +
 arch/x86/include/asm/acpi.h     |    3 +-
 drivers/acpi/acpica/acglobal.h  |    2 +
 drivers/acpi/acpica/aclocal.h   |    1 +
 drivers/acpi/acpica/hwxfsleep.c |   83 +++++++++++++++++++++++++--------------
 drivers/acpi/acpica/tbfadt.c    |   21 ++++++----
 drivers/acpi/acpica/tbutils.c   |   37 +++++++++++------
 drivers/acpi/acpica/tbxfload.c  |    3 +-
 drivers/acpi/sleep.c            |    8 +++-
 include/acpi/acpixf.h           |   24 ++++++-----
 10 files changed, 121 insertions(+), 62 deletions(-)

-- 
1.7.10

