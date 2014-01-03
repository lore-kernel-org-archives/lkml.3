Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103AbaACNXz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:23:55 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64006 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751926AbaACNXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:23:52 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.13-rc7
Date: Fri, 03 Jan 2014 14:37:33 +0100
Message-ID: <4606291.Jt1hNa9vKs@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.13.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.13-rc7

to receive ACPI and power management fixes for 3.13-rc7
with top-most commit 0a405fe97fd54d5e89560c6d0f4070ff43862a49

  Merge branches 'pm-cpufreq' and 'pm-cpuidle'

on top of commit 802eee95bde72fd0cd0f3a5b2098375a487d1eda

  Linux 3.13-rc6

These commits, except for one, are regression fixes and the remaining
one fixes a divide error leading to a kernel panic.  The majority of
the regressions fixed here were introduced during the 3.12 cycle, one
of them is from this cycle and one is older.

Specifics:

- VGA switcheroo was broken for some users as a result of the ACPI-based
  PCI hotplug (ACPIPHP) changes in 3.12, because some previously ignored
  hotplug events started to be handled.  The fix causes them to be
  ignored again.

- There are two more issues related to cpufreq's suspend/resume handling
  changes from the 3.12 cycle addressed by Viresh Kumar's fixes.

- intel_pstate triggers a divide error in a timer function if the P-state
  information it needs is missing during initialization.  This leads to
  kernel panics on nested KVM clients and is fixed by failing the
  initialization cleanly in those cases.

- PCI initalization code changes during the 3.9 cycle uncovered BIOS
  issues related to ACPI wakeup notifications (some BIOSes send them
  for devices that aren't supposed to support ACPI wakeup).  Work around
  them by installing an ACPI wakeup notify handler for all PCI devices
  with ACPI support.

- The Calxeda cpuilde driver's probe function is tagged as __init, which
  is incorrect and causes a section mismatch to occur during build.  Fix
  from Andre Przywara removes the __init tag from there.

- During the 3.12 cycle ACPIPHP started to print warnings about missing
  _ADR for devices that legitimately don't have it.  Fix from Toshi Kani
  makes it only print the warnings where they make sense.

All the best in 2014 and thanks!


---------------

Andre Przywara (1):
      ARM/cpuidle: remove __init tag from Calxeda cpuidle probe function

Rafael J. Wysocki (4):
      cpufreq: Clean up after a failing light-weight initialization
      PCI / ACPI: Install wakeup notify handlers for all PCI devs with ACPI
      intel_pstate: Fail initialization if P-state information is missing
      ACPIPHP / radeon / nouveau: Fix VGA switcheroo problem related to hotplug

Toshi Kani (1):
      ACPI / PCI / hotplug: Avoid warning when _ADR not present

Viresh Kumar (1):
      cpufreq: preserve user_policy across suspend/resume

---------------

 drivers/acpi/bus.c                           | 10 ++++++++
 drivers/cpufreq/cpufreq.c                    | 37 +++++++++++++++++-----------
 drivers/cpufreq/intel_pstate.c               |  5 ++++
 drivers/cpuidle/cpuidle-calxeda.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_acpi.c       | 16 ++++++++++--
 drivers/gpu/drm/radeon/radeon_atpx_handler.c | 16 ++++++++++--
 drivers/pci/hotplug/acpiphp_glue.c           | 30 +++++++++++++++++++---
 drivers/pci/pci-acpi.c                       | 21 +++++++++-------
 include/acpi/acpi_bus.h                      |  4 ++-
 9 files changed, 108 insertions(+), 33 deletions(-)

