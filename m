Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007Ab3LBPTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 10:19:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26712 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751024Ab3LBPTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 10:19:50 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 0/3] Add Firmware Info, Warn, and Bug messages
Date: Mon,  2 Dec 2013 10:19:36 -0500
Message-Id: <1385997579-22240-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Logging and tracking firmware bugs in the kernel has long been an issue
for system administrators.  The current kernel does not have a good
uniform method of reporting firmware bugs and the code in the kernel is a
mix of printk's and WARN_ONs.  This causes problems for both system
administrators and QA engineers who attempt to diagnose problems within
the kernel.

Using printk's is somewhat effective but lacks information useful for
reporting a bug such as the system vendor or model, BIOS revision, etc.
Using WARN_ONs is also questionable because the data like the backtrace
and the list of modules is usually unnecessary for firmware issues as the
warning stems from one call path during system or driver initialization.
We have heard many complaints from users about the excess verbosity and
confusing stacktraces for these messages.

I'm proposing with this patch to do something similar to the WARN()
mechanism that is currently implemented in the kernel.  This
patchset introduces FW_* functions which logs output like:

[  230.661137] [Firmware Info]: pci_bus 0000:00: at
/home/prarit_modules/prarit.c:21 Your BIOS is broken because it is
-ENOWORKY.
[  230.671076] [Firmware Info]: Intel Corporation SandyBridge Platform/To
be filled by O.E.M., BIOS RMLCRB.86I.R3.27.D685.1305151733 05/15/2013

instead of the verbose back traces we are currently seeing.  These messages
can be easily gleaned from /var/log/messages, etc., by automatic bug
reporting tools and system administrators to properly report bugs to
hardware vendors.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Prarit Bhargava (3):
  Introduce FW_INFO* functions and messages
  Introduce FW_WARN* functions and messages
  Introduce FW_BUG* functions and messages

 arch/x86/kernel/apic/apic.c              |    8 +--
 arch/x86/kernel/cpu/amd.c                |    9 ++--
 arch/x86/kernel/cpu/mcheck/mce.c         |    2 +-
 arch/x86/kernel/cpu/mcheck/mce_amd.c     |   12 ++---
 arch/x86/kernel/cpu/mtrr/generic.c       |    4 +-
 arch/x86/kernel/cpu/perf_event.c         |    8 ++-
 arch/x86/kernel/cpu/perf_event_amd_ibs.c |   10 ++--
 arch/x86/pci/mmconfig-shared.c           |   18 ++-----
 drivers/acpi/apei/apei-base.c            |   40 +++++++--------
 drivers/acpi/apei/einj.c                 |    9 ++--
 drivers/acpi/apei/erst.c                 |   17 +++----
 drivers/acpi/apei/ghes.c                 |   42 ++++++++--------
 drivers/acpi/apei/hest.c                 |   15 +++---
 drivers/acpi/battery.c                   |   12 +++--
 drivers/acpi/osl.c                       |    6 +--
 drivers/acpi/pci_root.c                  |    4 +-
 drivers/acpi/processor_perflib.c         |   16 +++---
 drivers/acpi/thermal.c                   |    5 +-
 drivers/acpi/video.c                     |   17 +++----
 drivers/acpi/video_detect.c              |    4 +-
 drivers/cpufreq/acpi-cpufreq.c           |    4 +-
 drivers/cpufreq/powernow-k8.c            |   56 +++++++++++----------
 drivers/firmware/dmi_scan.c              |    2 +-
 drivers/firmware/efi/cper.c              |    2 +-
 drivers/iommu/amd_iommu_init.c           |   24 +++++----
 drivers/iommu/dmar.c                     |    3 +-
 drivers/iommu/intel_irq_remapping.c      |    4 +-
 drivers/pci/quirks.c                     |    2 +-
 drivers/pnp/quirks.c                     |    4 +-
 include/asm-generic/bug.h                |   78 ++++++++++++++++++++++++++++++
 include/linux/printk.h                   |   30 +++---------
 kernel/panic.c                           |   42 ++++++++++++++++
 kernel/printk/printk.c                   |   12 +++++
 33 files changed, 305 insertions(+), 216 deletions(-)

-- 
1.7.9.3

