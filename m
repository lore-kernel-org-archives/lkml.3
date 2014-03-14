Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbaCNQRx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 12:17:53 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:34247 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756081AbaCNQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 12:17:50 -0400
MIME-Version: 1.0
Date: Fri, 14 Mar 2014 17:17:48 +0100
X-Google-Sender-Auth: iPxJuJfzWjYccSwJUkUudTkT6w0
Message-ID: <CAJZ5v0jzME8pYhfRLheOKVgo9beeYk9wnG6-N=kdVNM2e9LJCA@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.14-rc7
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.14-rc7

to receive ACPI and power management fixes for v3.14-rc7
with top-most commit d5af40d6b34d9d1ba39a27f657948cbce4e0b0e7

  Merge branches 'pnp', 'acpi-init', 'acpi-sleep' and 'pm-cpufreq'

on top of commit fa389e220254c69ffae0d403eac4146171062d08

  Linux 3.14-rc6

Three of these are regression fixes, for two recent regressions and one
introduced during the 3.13 cycle, and the fourth one is a working version
of the fix that had to be reverted last time.

Specifics:

 - A recent ACPI resources handling fix overlooked the fact that it had
   to update the ACPI PNP subsystem's resources parsing too and caused
   confusing warning messages to be printed during system intialization
   on some systems (with arguably buggy ACPI tables).  Fix from Zhang Rui.

 - Moving the early ACPI initialization before timekeeping_init() earlier
   in this cycle broke fast TSC calibration on at least one system, so it
   needs to be done later, but still before efi_enter_virtual_mode() to
   allow the EFI initialization to refer to ACPI.

 - A change related to code duplication reduction in the cpufreq core
   inadvertently caused cpufreq intialization to fail for some CPUs
   handled by intel_pstate by adding checks that may fail for that
   driver, but aren't even necessary when it is used.  The issue is
   addressed by preventing those checks from run in the configurations
   in which they aren't needed.

 - If the Hardware Reduced ACPI flag is set in the ACPI tables, system
   suspend, hibernation and ACPI power off will only work when special
   sleep control and sleep status registeres are provided (their
   addresses in the ACPI tables are not zero).  If those registers are
   not available, the features in question have no chances to work,
   so they shouldn't even be regarded as supported.  That helps with
   power off in particular, because alternative power off methods may
   be used then and they may actually work.

Thanks!


---------------

Rafael J. Wysocki (3):
      cpufreq: Skip current frequency initialization for ->setpolicy drivers
      ACPI / init: Invoke early ACPI initialization later
      ACPI / sleep: Add extra checks for HW Reduced ACPI mode sleep states

Zhang Rui (1):
      PNP / ACPI: proper handling of ACPI IO/Memory resource parsing failures

---------------

 drivers/acpi/sleep.c           | 32 +++++++++++++++-----------------
 drivers/cpufreq/cpufreq.c      |  4 ++--
 drivers/pnp/pnpacpi/rsparser.c | 15 ++++++++++++---
 init/main.c                    |  2 +-
 4 files changed, 30 insertions(+), 23 deletions(-)
