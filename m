Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364AbaDBArQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:47:16 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:64668 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756913AbaDBArO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:47:14 -0400
MIME-Version: 1.0
Date: Wed, 2 Apr 2014 02:47:12 +0200
X-Google-Sender-Auth: 6nMgZXxkY9pzJ6R01WqdhEiF4k8
Message-ID: <CAJZ5v0htHJ6_eX4eNKB5PrKXx+1BebcEeO9Jt-EQXiEj9hNuEw@mail.gmail.com>
Subject: [GIT PULL] More ACPI and power management updates for v3.15-rc1
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.15-rc1-2

to receive more ACPI and power management updates for v3.15-rc1 with
top-most commit 7b5c39389c86063e86fe8f2e0093c7197ddfa60a

 Merge branch 'pm-runtime'

on top of commit 0ecfe310f4517d7505599be738158087c165be7c

 Merge branch 'pm-devfreq'

These are commits that were not quite ready when I sent the original pull
request for 3.15-rc1 several days ago, but they have spent some time in
linux-next since then and appear to be good to go.  All of them are fixes
and cleanups.

Specifics:

 - Remaining changes from upstream ACPICA release 20140214 that introduce
   code to automatically serialize the execution of methods creating any
   named objects which really cannot be executed in parallel with each
   other anyway (previously ACPICA attempted to address that by aborting
   methods upon conflict detection, but that wasn't reliable enough and
   led to other issues).  From Bob Moore and Lv Zheng.

 - intel_pstate fix to use del_timer_sync() instead of del_timer() in
   the exit path before freeing the timer structure from Dirk Brandewie
   (original patch from Thomas Gleixner).

 - cpufreq fix related to system resume from Viresh Kumar.

 - Serialization of frequency transitions in cpufreq that involve
   PRECHANGE and POSTCHANGE notifications to avoid ordering issues
   resulting from race conditions.  From Srivatsa S Bhat and Viresh Kumar.

 - Revert of an ACPI processor driver change that was based on a specific
   interpretation of the ACPI spec which may not be correct (the relevant
   part of the spec appears to be incomplete).  From Hanjun Guo.

 - Runtime PM core cleanups and documentation updates from Geert Uytterhoeven.

 - PNP core cleanup from Michael Opdenacker.

Thanks!

---------------

Bob Moore (2):
      ACPICA: Add auto-serialization support for ill-behaved control methods.
      ACPICA: Ignore sync_level for methods that have been auto-serialized.

Dirk Brandewie (1):
      intel_pstate: Use del_timer_sync in intel_pstate_cpu_stop

Geert Uytterhoeven (6):
      PM / Runtime: dev_pm_info.runtime_error is signed
      PM / Runtime: Split line longer than 80 characters
      PM / Runtime: Correct documented return values for generic PM callbacks
      PM / Runtime: GENERIC_SUBSYS_PM_OPS is gone
      PM / Runtime: s/foo_process_requests/foo_process_next_request/
      PM / Runtime: Spelling s/competing/completing/

Hanjun Guo (1):
      Revert "ACPI / processor: Make it possible to get APIC ID via GIC"

Lv Zheng (3):
      ACPICA: Remove global option to serialize all control methods.
      ACPICA: Add additional named objects for the auto-serialize method scan.
      ACPICA: Enable auto-serialization as a default kernel behavior.

Michael Opdenacker (1):
      PNP: remove deprecated IRQF_DISABLED

Srivatsa S. Bhat (1):
      cpufreq: Make sure frequency transitions are serialized

Viresh Kumar (3):
      cpufreq: resume drivers before enabling governors
      cpufreq: Convert existing drivers to use
cpufreq_freq_transition_{begin|end}
      cpufreq: Make cpufreq_notify_transition &
cpufreq_notify_post_transition static

---------------

 Documentation/kernel-parameters.txt  |  10 ++-
 Documentation/power/runtime_pm.txt   |  29 +++----
 drivers/acpi/acpica/acdispat.h       |  13 +--
 drivers/acpi/acpica/acglobal.h       |  11 +--
 drivers/acpi/acpica/acinterp.h       |   4 -
 drivers/acpi/acpica/acobject.h       |   3 +-
 drivers/acpi/acpica/acstruct.h       |   3 +
 drivers/acpi/acpica/dsinit.c         |  59 ++++++++++---
 drivers/acpi/acpica/dsmethod.c       | 156 +++++++++++++++++++++++++++++++++--
 drivers/acpi/acpica/dswload.c        |  16 ++++
 drivers/acpi/acpica/exsystem.c       |  12 +--
 drivers/acpi/acpica/exutils.c        |  80 +++---------------
 drivers/acpi/acpica/nsinit.c         |   5 +-
 drivers/acpi/acpica/nsload.c         |   4 +-
 drivers/acpi/acpica/psloop.c         |   4 +
 drivers/acpi/acpica/psobject.c       |   7 +-
 drivers/acpi/osl.c                   |  16 ++--
 drivers/acpi/processor_core.c        |  27 ------
 drivers/base/power/generic_ops.c     |   2 +-
 drivers/cpufreq/cpufreq-nforce2.c    |   4 +-
 drivers/cpufreq/cpufreq.c            |  61 ++++++++++----
 drivers/cpufreq/exynos5440-cpufreq.c |   4 +-
 drivers/cpufreq/gx-suspmod.c         |   4 +-
 drivers/cpufreq/integrator-cpufreq.c |   4 +-
 drivers/cpufreq/intel_pstate.c       |   2 +-
 drivers/cpufreq/longhaul.c           |   4 +-
 drivers/cpufreq/pcc-cpufreq.c        |   4 +-
 drivers/cpufreq/powernow-k6.c        |   4 +-
 drivers/cpufreq/powernow-k7.c        |   4 +-
 drivers/cpufreq/powernow-k8.c        |   4 +-
 drivers/cpufreq/s3c24xx-cpufreq.c    |   4 +-
 drivers/cpufreq/sh-cpufreq.c         |   4 +-
 drivers/cpufreq/unicore2-cpufreq.c   |   4 +-
 drivers/pnp/resource.c               |   2 +-
 include/acpi/acpixf.h                |   2 +-
 include/linux/cpufreq.h              |  12 ++-
 36 files changed, 377 insertions(+), 211 deletions(-)
