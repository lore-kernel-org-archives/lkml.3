Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104AbaEPVyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 17:54:35 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44848 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbaEPVyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 17:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0inpqY5w-FE4Wvaj2W_tG3AMHNoRQfdK8iSgJUQ798O-g@mail.gmail.com>
References: <CAJZ5v0inpqY5w-FE4Wvaj2W_tG3AMHNoRQfdK8iSgJUQ798O-g@mail.gmail.com>
Date: Fri, 16 May 2014 23:54:32 +0200
X-Google-Sender-Auth: XSOJEzV7sseovhh044V-dsz5DN8
Message-ID: <CAJZ5v0iZ6eREK24fWAw7ixz=BJXMiMBcTAOJ1MdBq+pfR4zcHA@mail.gmail.com>
Subject: Re: [GIT PULL] ACPI and power management fixes for v3.15-rc6
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Sorry for this last-minute update, but it's just turned out that
one of the new ACPI video blacklist entries was added overzealously
and added is a commit reverting it.

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.15-rc6

to receive ACPI and power management fixes for v3.15-rc6
with top-most commit 658a0f4e661a6c07395de318a58f9058ba2faf8f

  Merge branch 'acpi-video'

on top of commit d6d211db37e75de2ddc3a4f979038c40df7cc79c

  Linux 3.15-rc5

Still fixing regressions (partly by reverting commits that broke
things for people), fixing other stable-candidate bugs and adding
some blacklist entries for ACPI video and _OSI.  Two ACPICA regression
fixes (one recent and one for a 3.14 commit), a fix for an ACPI-related
regression in TPM (introduced in 3.14), a revert of the ACPI AC
driver conversion in 3.13 that went wrong for an unknown reason,
two reverts of commits that attempted to remove an old user space
interface in /proc and broke some utilities, in 3.13 too, a fix for
a CPU hotplug bug in the ACPI processor driver (stable material),
two (stable candidate) fixes for intel_pstate and a few new blacklist
entries, mostly for systems that shipped with Windows 8.

Specifics:

 - ACPICA fix for a stale pointer access introduced by a recent
   commit in the XSDT validation code from Lv Zheng.

 - ACPICA fix for the default value of the command line switch
   to favor 32-bit FADT addresses (in case there's a conflict
   between a 64-bit and a 32-bit address).  The previous default
   was that the 32-bit version would take precedence and we tried
   to change it to the other way around and it didn't work.
   From Lv Zheng.

 - A TPM commit related to ACPI _DSM in 3.14 caused the driver to
   refuse to load if a specific _DSM was missing and that broke
   resume from system suspend on Chromebooks that require the TPM
   hardware to be restored to a working state during resume by the
   OS.  Restore the old behavior to load the driver if the _DSM
   in question is not present, but prevent it from using the
   feature the _DSM is for.

 - ACPI AC driver conversion in 3.13 broke thermal management on
   at least one machine and has to be reverted.  From Guenter Roeck.

 - Two reverts of 3.13 commits that attempted to remove the old ACPI
   battery interface in /proc, but turned out to break some utilities
   still using that interface.  From Lan Tianyu.

 - ACPI processor driver fix to prevent acpi_processor_add() from
   modifying the CPU device's .offline field which leads to breakage
   if the initial online of the CPU fails.  From Igor Mammedov.

 - Two intel_pstate fixes, one to take a BayTrail documentation update
   into account and one to avoid forcing the maximum P-state on init
   which causes CPU PM trouble on systems with P-states coordination
   when one of the CPU cores is initialized after an offline/online
   cycle triggered by user space.  Both stable candidates, from
   Dirk Brandewie.

 - Fix for the ACPI video DMI blacklist entry for Dell Inspiron 7520
   from Aaron Lu.

 - Two new ACPI video blacklist entries for machines shipping with
   Win8 that need to use native backlight so that it can be controlled
   in a usual way (which doesn't work otherwise due bugs in the ACPI
   tables) from Hans de Goede.

 - Two ACPI _OSI quirks for systems that need them to work correctly
   with Linux from Edward Lin and Hans de Goede.

Thanks!


---------------

Aaron Lu (1):
      ACPI / video: correct DMI tag for Dell Inspiron 7520

Dirk Brandewie (2):
      intel_pstate: Set turbo VID for BayTrail
      intel_pstate: remove setting P state to MAX on init

Edward Lin (1):
      ACPI: blacklist win8 OSI for Dell Inspiron 7737

Guenter Roeck (1):
      ACPI: Revert "ACPI / AC: convert ACPI ac driver to platform bus"

Hans de Goede (3):
      ACPI / video: Add use_native_backlight quirks for more systems
      ACPI / blacklist: Add dmi_enable_osi_linux quirk for Asus EEE PC 1015PX
      ACPI / video: Revert native brightness quirk for ThinkPad T530

Igor Mammedov (1):
      ACPI / processor: do not mark present at boot but not onlined
CPU as onlined

Lan Tianyu (2):
      ACPI: Revert "ACPI: Remove CONFIG_ACPI_PROCFS_POWER and cm_sbsc.c"
      ACPI: Revert "ACPI / Battery: Remove battery's proc directory"

Lv Zheng (2):
      ACPICA: Tables: Fix invalid pointer accesses in
acpi_tb_parse_root_table().
      ACPICA: Tables: Restore old behavor to favor 32-bit FADT addresses.

Rafael J. Wysocki (2):
      ACPI / proc: Do not say when /proc interfaces will be deleted in Kconfig
      ACPI / TPM: Fix resume regression on Chromebooks

---------------

 drivers/acpi/Kconfig           |  17 +++
 drivers/acpi/Makefile          |   1 +
 drivers/acpi/ac.c              | 117 ++++++++-------
 drivers/acpi/acpi_platform.c   |   1 -
 drivers/acpi/acpi_processor.c  |   1 -
 drivers/acpi/acpica/acglobal.h |   4 +-
 drivers/acpi/acpica/tbutils.c  |   7 +-
 drivers/acpi/battery.c         | 329 ++++++++++++++++++++++++++++++++++++++++-
 drivers/acpi/blacklist.c       |  21 +++
 drivers/acpi/cm_sbs.c          | 105 +++++++++++++
 drivers/acpi/video.c           |  16 +-
 drivers/char/tpm/tpm_ppi.c     |   8 +-
 drivers/cpufreq/intel_pstate.c |  34 ++---
 13 files changed, 568 insertions(+), 93 deletions(-)
