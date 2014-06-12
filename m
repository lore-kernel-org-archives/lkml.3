Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933537AbaFLRHL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 13:07:11 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:59017 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933339AbaFLRHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 13:07:08 -0400
MIME-Version: 1.0
Date: Thu, 12 Jun 2014 19:07:07 +0200
X-Google-Sender-Auth: sNlPkqMg8GNLObPaxDR9XEzpJJU
Message-ID: <CAJZ5v0i15+y9+4vp2Unp=fgKMV1PEe4D4SFYMQjG8rMPOOJC2g@mail.gmail.com>
Subject: [GIT PULL] More ACPI and power management updates for v3.16-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.16-rc1-2

to receive additional ACPI and power management updates for v3.16-rc1
with top-most commit d715a226b0b3dae48865d05e8c36175a8f75a809

 Merge branch 'pm-sleep'

on top of commit 4dc4226f994db264c844a5fcf556935c66f963a5

 Merge tag 'pm+acpi-3.16-rc1' of
git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm into
next

These are fixups on top of the previous PM+ACPI pull request,
regression fixes (ACPI hotplug, cpufreq ppc-corenet), other bug
fixes (ACPI reset, cpufreq), new PM trace points for system suspend
profiling and a copyright notice update.

Specifics:

 - I didn't remember correctly that the Hans de Goede's ACPI video
   patches actually didn't flip the video.use_native_backlight
   default, although we had discussed that and decided to do that.
   Since I said we would do that in the previous PM+ACPI pull
   request, make that change for real now.

 - ACPI bus check notifications for PCI host bridges don't cause
   the bus below the host bridge to be checked for changes as they
   should because of a mistake in the ACPI-based PCI hotplug (ACPIPHP)
   subsystem that forgets to add hotplug contexts to PCI host bridge
   ACPI device objects.  Create hotplug contexts for PCI host bridges
   too as appropriate.

 - Revert recent cpufreq commit related to the big.LITTLE cpufreq
   driver that breaks arm64 builds.

 - Fix for a regression in the ppc-corenet cpufreq driver introduced
   during the 3.15 cycle and causing the driver to use the remainder
   from do_div instead of the quotient.  From Ed Swarthout.

 - Resets triggered by panic activate a BUG_ON() in vmalloc.c on
   systems where the ACPI reset register is located in memory address
   space.  Fix from Randy Wright.

 - Fix for a problem with cpufreq governors that decisions made by
   them may be suboptimal due to the fact that deferrable timers are
   used by them for CPU load sampling.  From Srivatsa S Bhat.

 - Fix for a problem with the Tegra cpufreq driver where the CPU
   frequency is temporarily switched to a "stable" level that
   is different from both the initial and target frequencies
   during transitions which causes udelay() to expire earlier than
   it should sometimes.  From Viresh Kumar.

 - New trace points and rework of some existing trace points for
   system suspend/resume profiling from Todd Brandt.

 - Assorted cpufreq fixes and cleanups from Stratos Karafotis and
   Viresh Kumar.

 - Copyright notice update for suspend-and-cpuhotplug.txt from
   Srivatsa S Bhat.

Thanks!


---------------

Ed Swarthout (1):
      cpufreq: ppc-corenet-cpu-freq: do_div use quotient

Rafael J. Wysocki (3):
      ACPI / video: Change the default for video.use_native_backlight to 1
      Revert "cpufreq: Enable big.LITTLE cpufreq driver on arm64"
      ACPI / hotplug / PCI: Add hotplug contexts to PCI host bridges

Randy Wright (1):
      ACPI: Fix bug when ACPI reset register is implemented in system memory

Srivatsa S. Bhat (2):
      cpufreq: governor: Be friendly towards latency-sensitive bursty workloads
      PM / Documentation: Update copyright in suspend-and-cpuhotplug.txt

Stratos Karafotis (1):
      cpufreq: intel_pstate: Remove duplicate CPU ID check

Todd E Brandt (2):
      PM / sleep: trace events for suspend/resume
      PM / sleep: trace events for device PM callbacks

Viresh Kumar (6):
      cpufreq: add support for intermediate (stable) frequencies
      cpufreq: Tegra: implement intermediate frequency callbacks
      cpufreq: governor: remove copy_prev_load from 'struct cpu_dbs_common_info'
      cpufreq: Mark CPU0 driver with CPUFREQ_NEED_INITIAL_FREQ_CHECK flag
      cpufreq: tegra: update comment for clarity
      cpufreq: cpufreq-cpu0: remove dependency on THERMAL and REGULATOR

---------------

 Documentation/cpu-freq/cpu-drivers.txt         |  29 ++++++-
 Documentation/power/suspend-and-cpuhotplug.txt |   2 +-
 drivers/acpi/osl.c                             |  12 +++
 drivers/acpi/sleep.c                           |   3 +
 drivers/acpi/video.c                           |   2 +-
 drivers/base/power/main.c                      |  30 +++++++-
 drivers/base/syscore.c                         |   5 ++
 drivers/cpufreq/Kconfig                        |   2 +-
 drivers/cpufreq/Kconfig.arm                    |   3 +-
 drivers/cpufreq/cpufreq-cpu0.c                 |   2 +-
 drivers/cpufreq/cpufreq.c                      |  67 +++++++++++++++--
 drivers/cpufreq/cpufreq_governor.c             |  67 ++++++++++++++++-
 drivers/cpufreq/cpufreq_governor.h             |   7 ++
 drivers/cpufreq/intel_pstate.c                 |   6 --
 drivers/cpufreq/ppc-corenet-cpufreq.c          |   9 ++-
 drivers/cpufreq/tegra-cpufreq.c                | 100 ++++++++++++++++---------
 drivers/pci/hotplug/acpiphp.h                  |  10 +++
 drivers/pci/hotplug/acpiphp_glue.c             |  60 ++++++++++-----
 include/linux/cpufreq.h                        |  25 +++++++
 include/trace/events/power.h                   |  84 ++++++++++++++-------
 kernel/cpu.c                                   |   5 ++
 kernel/power/hibernate.c                       |   3 +
 kernel/power/process.c                         |   3 +
 kernel/power/suspend.c                         |  14 +++-
 24 files changed, 437 insertions(+), 113 deletions(-)
