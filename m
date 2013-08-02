Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab3HBOTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 10:19:22 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52157 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452Ab3HBOTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 10:19:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: [GIT PULL] ACPI and power management fixes for v3.11-rc4
Date: Fri, 02 Aug 2013 16:29:31 +0200
Message-ID: <2052880.bHfzt6NKt5@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from the git repository at

  git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git pm+acpi-3.11-rc4

to receive ACPI and power management fixes for v3.11-rc4 with
top-most commit 2b44c4db2e2f1765d35163a861d301038e0c8a75

  freezer: set PF_SUSPEND_TASK flag on tasks that call freeze_processes

on top of commit 5ae90d8e467e625e447000cb4335c4db973b1095

  Linux 3.11-rc3

These revert two cpuidle commits from 3.8 that turn out to hurt performance,
fix a recent s2disk regression related to the freezer, fix cpufreq reference
couting problem uncovered by one of the recent reverts and fix a particularly
embarrassing bug in the ACPI battery driver.

Specifics:

- Revert two cpuidle commits added during the 3.8 development cycle that
  turn out to have introduced a significant performance regression as
  requested by Jeremy Eder.

- The recent patches that made the freezer less heavy-weight introduced
  a regression causing user-space-driven hibernation using the ioctl()
  interface to block indefinitely when the hibernate process executes
  try_to_freeze().  Fix from Colin Cross addresses this by adding a
  process flag to mark the hibernate/suspend process to inform the
  freezer that that process should be ignored.

- One of the recent cpufreq reverts uncovered a problem in the core
  causing the cpufreq driver module refcount to become negative after
  a system suspend-resume cycle.  Fix from yours truly.

- The evaluation of the ACPI battery _BIX method has never worked
  correctly, because the commit that added support for it forgot to
  take the "Revision" field in the return package into account.  As
  a result, the reading of battery info doesn't work at all on some
  systems, which is addressed by a fix from Lan Tianyu.

Thanks!


---------------

Colin Cross (1):
      freezer: set PF_SUSPEND_TASK flag on tasks that call freeze_processes

Lan Tianyu (1):
      ACPI / battery: Fix parsing _BIX return value

Rafael J. Wysocki (3):
      Revert "cpuidle: Quickly notice prediction failure in general case"
      Revert "cpuidle: Quickly notice prediction failure for repeat mode"
      cpufreq: Fix cpufreq driver module refcount balance after suspend/resume

---------------

 drivers/acpi/battery.c           |    2 +
 drivers/cpufreq/cpufreq.c        |   19 +++++----
 drivers/cpuidle/governors/menu.c |  106 ++--------------------------------------------
 include/linux/sched.h            |    1 +
 include/linux/tick.h             |    6 ---
 kernel/freezer.c                 |    2 +-
 kernel/power/process.c           |   11 +++++
 kernel/time/tick-sched.c         |    9 +---
 8 files changed, 31 insertions(+), 125 deletions(-)

