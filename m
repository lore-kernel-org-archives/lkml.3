Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab3B1J1v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 04:27:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750768Ab3B1J1s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 04:27:48 -0500
Date: Thu, 28 Feb 2013 06:27:38 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux EDAC Mailing List <linux-edac@vger.kernel.org>,
        Doug Thompson <dougthompson@xmission.com>,
        Len Brown <len.brown@intel.com>, Rafael Wysocki <rjw@sisk.pl>,
        Huang Ying <ying.huang@intel.com>
Subject: [GIT PULL for v3.8] EDAC fixes and ghes-edac
Message-ID: <20130228062738.154b001f@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

For:
	- Some fixes at edac drivers (i7core_edac, sb_edac, i3200_edac);
	- error injection support for i5100, when EDAC debug is enabled;
	- fix edac when it is loaded builtin (early init for the subsystem);
	- a "Firmware First" EDAC driver, allowing ghes to report errors via
	  EDAC (ghes-edac).

With regards to ghes-edac, this fixes a longstanding BZ at Red Hat that
happens with Nehalem and Sandy Bridge CPUs: when both GHES and i7core_edac
or sb_edac are running, the error reports are unpredictable, as both BIOS
and OS race to access the registers. With ghes-edac, the EDAC core will
refuse to register any other concurrent memory error driver.

This patchset moves the ghes struct definitions to a separate header file
(include/acpi/ghes.h) and adds 3 hooks at apei/ghes.c to register/unregister
and to report errors via ghes-edac. Those changes were acked by ghes driver
maintainer (Huang).

Thanks!
Mauro

-

The following changes since commit 836dc9e3fbbab0c30aa6e664417225f5c1fb1c39:

  Linux 3.8-rc7 (2013-02-09 08:20:39 +1100)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git linux_next

for you to fetch changes up to b0769891ba7baa53f270dc70d71934748beb4c5b:

  i5100_edac: convert to use simple_open() (2013-02-26 10:06:18 -0300)

----------------------------------------------------------------
Lans Zhang (1):
      i7core_edac: fix kernel crash on unloading i7core_edac

Mauro Carvalho Chehab (23):
      sb_edac: add a missing /n on a debug message
      Merge tag 'v3.8-rc7' into next
      i3200_edac: Add more debug to the driver
      i3200_edac: Fix the logic that detects filled memories
      edac: only create sdram_scrub_rate where supported
      i5100_edac: Remove two checkpatch warnings
      edac: better report error conditions in debug mode
      edac: initialize the core earlier
      edac: add a new memory layer type
      edac: remove proc_name from mci structure
      edac: lock module owner to avoid error report conflicts
      edac: reduce stack pressure by using a pre-allocated buffer
      edac: add support for raw error reports
      edac: add support for error type "Info"
      ghes: move structures/enum to a header file
      ghes: add the needed hooks for EDAC error report
      ghes_edac: Register at EDAC core the BIOS report
      ghes_edac: add support for reporting errors via EDAC
      ghes_edac: do a better job of filling EDAC DIMM info
      ghes_edac: Don't credit the same memory dimm twice
      ghes_edac: Improve driver's printk messages
      ghes_edac: Make it compliant with UEFI spec 2.3.1
      ghes_edac: Fix RAS tracing

Niklas Söderlund (4):
      i7core_edac: fix erroneous size of static array
      i5100_edac: probe for device 19 function 0
      i5100_edac: add fault injection code
      i5100_edac: connect fault injection to debugfs node

Shaun Ruffell (1):
      edac: edac_mc no longer deals with kobjects directly

Wei Yongjun (2):
      ghes_edac: fix to use list_for_each_entry_safe() when delete list items
      i5100_edac: convert to use simple_open()

 MAINTAINERS                   |   7 +
 drivers/acpi/apei/ghes.c      |  71 ++----
 drivers/edac/Kconfig          |  23 ++
 drivers/edac/Makefile         |   1 +
 drivers/edac/edac_core.h      |   5 +
 drivers/edac/edac_mc.c        | 152 +++++++-----
 drivers/edac/edac_mc_sysfs.c  |  36 ++-
 drivers/edac/edac_module.c    |   2 +-
 drivers/edac/edac_pci_sysfs.c |   2 +-
 drivers/edac/ghes_edac.c      | 537 ++++++++++++++++++++++++++++++++++++++++++
 drivers/edac/i3200_edac.c     |  37 ++-
 drivers/edac/i5100_edac.c     | 178 +++++++++++++-
 drivers/edac/i7core_edac.c    |   8 +-
 drivers/edac/sb_edac.c        |   2 +-
 include/acpi/ghes.h           |  72 ++++++
 include/linux/edac.h          |  79 ++++++-
 include/linux/pci_ids.h       |   1 +
 include/ras/ras_event.h       |   4 +-
 18 files changed, 1077 insertions(+), 140 deletions(-)
 create mode 100644 drivers/edac/ghes_edac.c
 create mode 100644 include/acpi/ghes.h

