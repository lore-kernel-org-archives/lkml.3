Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776Ab3FZMwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 08:52:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:51823 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab3FZMwo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 08:52:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>
Subject: [GIT PULL] Late power management and ACPI fixes for v3.10
Date: Wed, 26 Jun 2013 15:02:12 +0200
Message-ID: <1540341.1JlJme4nI6@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.10-late

to receive late power management and ACPI fixes for v3.10 with top-most commit
45e00374db944b1c12987b501bcaa279b3e36d93

  Merge branch 'pm-fixes'

on top of commit 9e895ace5d82df8929b16f58e9f515f6d54ab82d

  Linux 3.10-rc7

Sorry about the timing of this, but ACPI-based docking stations with PCI
devices on them and ATA bays would be hardly usable with 3.10 without it.
We've been working on these fixes for the last couple of weeks and
everyone involved appears to be reasonably comfortable with them now.

The PM part is one fix for a cpufreq regression introduced recently.

Specifics:

- Fix for an ACPI dock regression introduced by the recent rework of
  the ACPI-based PCI hotplug code (acpiphp) that caused it to be
  initialized before the ACPI dock driver, which is incorrect (ACPI
  dock has to be initialized before acpiphp so that acpiphp can
  register PCI devices on docking stations with it for PCI hotplug on
  re-dock to work).  From Jiang Liu.

- Fix for PCI resources allocation in the ACPI-based PCI hotplug code
  (acpiphp) that makes it use the same PCI resources assignment rules
  during runtime hotplug that are used during boot (the BIOS' choices
  are now respected in both cases).  This prevents PCI resource
  allocation failures during hotplug from happening in some cases.
  From Jiang Liu.

- Fix for ordering and synchronization issues during hot-removal of
  PCI devices on docking stations.  It makes the ACPI dock code carry
  out the PCI devices removal synchronously during undock instead of
  spawning a separate asynchronous work item to remove each of them
  without even bothering to wait for all those work items to complete.
  The hot-addition part is changed analogously.

- Fix for a regression (introduced a few releases ago) that removed
  the code to register a hotplug notificaion handler for for ATA
  ports/devices inadvertently which prevented ATA bays hotplug from
  working.  The missing code is added back with some improvements.
  From Aaron Lu.

- Fix for a recent cpufreq regression causing a NULL pointer
  dereference to trigger in od_set_powersave_bias() in some
  situations from Jacob Shin.

Thanks!


---------------

Aaron Lu (1):
      libata-acpi: add back ACPI based hotplug functionality

Jacob Shin (1):
      cpufreq: fix NULL pointer deference at od_set_powersave_bias()

Jiang Liu (2):
      ACPI / dock: Initialize ACPI dock subsystem upfront
      PCI / ACPI: Use boot-time resource allocation rules during hotplug

Rafael J. Wysocki (1):
      ACPI / dock / PCI: Synchronous handling of dock events for PCI devices

---------------

 drivers/acpi/dock.c                |  179 ++++++++++++++++++++++++--------------------
 drivers/acpi/internal.h            |    5 ++
 drivers/acpi/scan.c                |    1 +
 drivers/ata/libata-acpi.c          |   37 ++++++++-
 drivers/ata/libata-core.c          |    2 +
 drivers/ata/libata.h               |    2 +
 drivers/cpufreq/cpufreq_ondemand.c |   17 ++++-
 drivers/pci/hotplug/acpiphp_glue.c |   53 +++++++++----
 drivers/pci/pci.h                  |    5 ++
 drivers/pci/setup-bus.c            |    8 +-
 include/acpi/acpi_drivers.h        |    8 +-
 11 files changed, 207 insertions(+), 110 deletions(-)

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
