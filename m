Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaGJUO1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 16:14:27 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:40177 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaGJUOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 16:14:25 -0400
MIME-Version: 1.0
Date: Thu, 10 Jul 2014 22:14:24 +0200
X-Google-Sender-Auth: LC2Mv2DxV-yKaomT4JEOKWRpMFM
Message-ID: <CAJZ5v0ifZDGWPtu0GF0ddKGXJPujV34_-R2++1R_PfeV0fcRbA@mail.gmail.com>
Subject: [GIT PULL] ACPI and power management fixes for v3.16-rc5
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from

 git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git \
 pm+acpi-3.16-rc5

to receive ACPI and power management fixes for v3.16-rc5
with top-most commit 2091044299e9bc3340d845301b13bd92d6c10993

 Merge branch 'pm-cpufreq'

on top of commit cd3de83f147601356395b57a8673e9c5ff1e59d1

 Linux 3.16-rc4

These are a few regression fixes for ACPI device enumeration and
resources management, intel_pstate and cpufreq, a revert of an
ACPI commit removing user space interfaces in /proc that we
incorrectly thought were not used any more, fixes for some
long-standing concurrency issues in the ACPI EC driver, two ACPI
battery driver fixes, stable-candidate fixes for intel_pstate, an
ACPI-related fix for i915 and two new ACPI video blacklist entries
for Win8-oriented BIOSes.

Specifics:

 - Missing device ID for ACPI enumeration of PNP devices that we
   overlooked during the recent rework of that code from Zhang Rui.

 - Fix for a problem introduced during the 3.14 cycle in the ACPI
   device resources management code and causing it to reject all
   resources of length 0 although some of them are actually valid
   which affects serial ports detection on a number of systems.
   From Andy Whitcroft.

 - intel_pstate fix for a boot problem on some BayTrail-based
   systems introduced by a previous fix related to that platform
   during the 3.13 cycle from Dirk Brandewie.

 - Revert of a 3.13 commit that removed the ACPI AC /proc interface
   which turns out to be still needed by some old utilities (kpowersave
   from kde 3.5.10 in particular) from Lan Tianyu.

 - cpufreq build fix for the davinci ARM platform from Prabhakar Lad
   (the breakage was introduced during the 3.10 cycle).

 - ACPI-related i915 fix preventing firmware on some Thinkpad laptops
   from setting backlight levels incorrectly during AC plug/unplug.
   From Aaron Lu.

 - Fixes for two nasty race conditions in the ACPI embedded controller
   driver that may be responsible for a number of past bug reports
   related to the EC from Lv Zhang and a fix for two memory leaks in
   error code paths in that driver from Colin Ian King.

 - Fixes for a couple of corner-case issues in the intel_pstate
   driver (all candidates for -stable) from Dirk Brandewie and
   Vincent Minet.

 - Fixes for two corner-case issues in the ACPI battery driver
   from Josef Gajdusek and Lan Tianyu.

 - Two new ACPI video blacklist entries for Acer TravelMate B113
   and Dell Inspiron 5737 from Edward Lin and Martin Kepplinger.

Thanks!


---------------

Aaron Lu (1):
      ACPI / i915: ignore firmware requests for backlight change

Andy Whitcroft (1):
      ACPI / resources: only reject zero length resources based at address zero

Colin Ian King (1):
      ACPI / EC: Free saved_ec on error exit path

Dirk Brandewie (3):
      intel_pstate: Fix setting VID
      intel_pstate: don't touch turbo bit if turbo disabled or unavailable.
      intel_pstate: Update documentation of {max,min}_perf_pct sysfs files

Edward Lin (1):
      ACPI / video: Add Dell Inspiron 5737 to the blacklist

Josef Gajdusek (1):
      ACPI / battery: fix wrong value of capacity_now reported when
fully charged

Lan Tianyu (2):
      Revert "ACPI / AC: Remove AC's proc directory."
      ACPI / battery: Retry to get battery information if failed during probing

Lv Zheng (6):
      ACPI / EC: Avoid race condition related to advance_transaction()
      ACPI / EC: Add asynchronous command byte write support
      ACPI / EC: Remove duplicated ec_wait_ibf0() waiter
      ACPI / EC: Fix race condition in ec_transaction_completed()
      ACPI / EC: Update revision due to recent changes
      ACPI / EC: Add detailed fields debugging support of EC_SC(R).

Martin Kepplinger (1):
      ACPI / video: Add Acer TravelMate B113 to native backlight blacklist

Prabhakar Lad (1):
      cpufreq: Makefile: fix compilation for davinci platform

Vincent Minet (1):
      intel_pstate: Set CPU number before accessing MSRs

Zhang Rui (1):
      ACPI / PNP: add soc_button_array device ID to PNP IDs list

---------------

 Documentation/cpu-freq/intel-pstate.txt |   7 +-
 drivers/acpi/ac.c                       | 130 ++++++++++++++++++++++++-
 drivers/acpi/acpi_pnp.c                 |   2 +
 drivers/acpi/battery.c                  |  41 +++++++-
 drivers/acpi/ec.c                       | 164 +++++++++++++++++---------------
 drivers/acpi/resource.c                 |  10 +-
 drivers/acpi/video.c                    |  11 ++-
 drivers/acpi/video_detect.c             |   8 ++
 drivers/cpufreq/Makefile                |   2 +-
 drivers/cpufreq/intel_pstate.c          |  35 ++++---
 drivers/gpu/drm/i915/intel_opregion.c   |   9 ++
 include/acpi/video.h                    |   2 +
 12 files changed, 317 insertions(+), 104 deletions(-)
