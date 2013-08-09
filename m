Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934303Ab3HIOzt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 10:55:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34020 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934148Ab3HIOzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 10:55:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.11-rc5
Date: Fri, 09 Aug 2013 17:06:04 +0200
Message-ID: <4211268.BVlRV6dqfO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc4+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.11-rc5

to receive ACPI and power management fixes for v3.11-rc5 with
top-most commit 69fdadfd2200e0bf3d10a7a7925db8e9fc5a46fd

  Merge branch 'pm-fixes'

on top of commit c095ba7224d8edc71dcef0d655911399a8bd4a3f

  Linux 3.11-rc4

These fix a couple of recent regressions introduced during this cycle,
a few regressions introduced in 3.9 and 3.10 and one locking bug
that's always been there.
 
Specifics:

- ACPI-based memory hotplug stopped working after a recent change,
  because it's not possible to associate sufficiently many "physical"
  devices with one ACPI device object due to an artificial limit.
  Fix from yours truly removes that limit and makes memory hotplug
  work again.

- A change made in 3.9 uncovered a bug in the ACPI processor driver
  preventing NUMA nodes from being put offline due to an ordering
  issue.  Fix from Yasuaki Ishimatsu changes the ordering to make
  things work again.

- One of the recent ACPI video commits (that hasn't been reverted
  so far) uncovered a bug in the code handling quirky BIOSes that
  caused some Asus machines to boot with backlight completely off
  which made it quite difficult to use them afterward.  Fix from
  Felipe Contreras improves the quirk to cover this particular
  case correctly.

- A cpufreq user space interface change made in 3.10 inadvertently
  renamed ignore_nice_load to ignore_nice which resulted in some
  confusion.  Fix from Viresh Kumar changes the name back to
  ignore_nice_load.

- An initialization ordering change made in 3.9 broke cpufreq on
  loongson2 boards.  Fix from Aaro Koskinen restores the correct
  initialization ordering there.

- Another chapter from "ACPI Horror Stories".  Some BIOS writers
  apparently expect us to always be able to handle the unbelievable
  garbage they put into their ACPI tables.  Well, we do our best,
  but sometimes we break one of these cases when we try to address
  another one.

  In this particular case the breakage resulted from a mistake made
  in 3.9 and caused the detection of some graphics adapters (that were
  detected successfully before) to fail.  It turned out that there
  were two objects representing the same PCIe port in the ACPI tables
  of the affected systems.  Both appeared as "enabled" and we were
  expected to guess which one to use.  We used to choose the right one
  before by pure luck, but when we tried to address another similar
  corner case, the luck went away.  This time we try to make our
  guessing a bit more educated which is reported to work on those
  systems.

- The /proc/acpi/wakeup interface code is missing some locking
  which may lead to breakage if that file is written or read during
  hotplug of wakeup devices.  That should be rare but still possible,
  so it's better to start using the appropriate locking there.

Thanks!


---------------

Aaro Koskinen (1):
      cpufreq: loongson2: fix regression related to clock management

Felipe Contreras (1):
      ACPI / video: improve quirk check in acpi_video_bqc_quirk()

Rafael J. Wysocki (3):
      ACPI / PM: Walk physical_node_list under physical_node_lock
      ACPI: Drop physical_node_id_bitmap from struct acpi_device
      ACPI: Try harder to resolve _ADR collisions for bridges

Viresh Kumar (1):
      cpufreq: rename ignore_nice as ignore_nice_load

Yasuaki Ishimatsu (1):
      ACPI / processor: move try_offline_node() after acpi_unmap_lsapic()

---------------

 drivers/acpi/acpi_processor.c          |    3 +-
 drivers/acpi/glue.c                    |  133 ++++++++++++++++++++++++--------
 drivers/acpi/proc.c                    |    8 ++
 drivers/acpi/video.c                   |    2 +-
 drivers/cpufreq/cpufreq_conservative.c |   20 ++---
 drivers/cpufreq/cpufreq_governor.c     |    8 +-
 drivers/cpufreq/cpufreq_governor.h     |    4 +-
 drivers/cpufreq/cpufreq_ondemand.c     |   20 ++---
 drivers/cpufreq/loongson2_cpufreq.c    |   11 +--
 drivers/pci/pci-acpi.c                 |   15 +++-
 include/acpi/acpi_bus.h                |   14 ++--
 11 files changed, 162 insertions(+), 76 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
