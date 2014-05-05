Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755615AbaEEUvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:51:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754608AbaEEUvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:51:09 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        imammedo@redhat.com, bp@suse.de, paul.gortmaker@windriver.com,
        JBeulich@suse.com, prarit@redhat.com, drjones@redhat.com,
        toshi.kani@hp.com, riel@redhat.com, gong.chen@linux.intel.com,
        andi@firstfloor.org, lenb@kernel.org, rjw@rjwysocki.net,
        linux-acpi@vger.kernel.org
Subject: [PATCH v5 0/4] x86: fix hang when AP bringup is too slow
Date: Mon,  5 May 2014 22:49:47 +0200
Message-Id: <1399322991-19329-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

changes since v4:
 * merge "[PATCH v4 1/5] x86: fix list corruption on CPU hotplug"
   and "[PATCH v4 2/5] x86: fix memory corruption in acpi_unmap_lsapic()"
   together
 * "x86: initialize secondary CPU only if master CPU will wait for it:
    - add 10 seconds timeout description into commit message
    - add smp_mb() after clearing cpu_initialized_mask

changes since v3:
 * put simple bugfixes first
 * move common part of syncing with master CPU in cpu_init()
   for x32/64 variant into helper function
 * cpu_init(): WARN_ON if cpu_initialized_mask is set
 * fix panic on CPU unplug, caused by erroneous removing
   of "pr->dev = dev;" in drivers/acpi/acpi_processor.c

--
Hang is observed on virtual machines during CPU hotplug,
especially in big guests with many CPUs. (It happens more
often if host is over-committed).

Hang happens because master CPU timeouts on waiting till
AP boots and 'cancels' CPU online operation assuming AP
is not functional but AP may continue run wild later
causing various hangs or panics in running kernel that
is assuming that AP was offline.

This is an alternative approach, that instead of canceling
in-progress AP bringup (https://lkml.org/lkml/2014/3/6/257),
removes timeouts so that AP bringup won't be affected by
poor timing and syncs AP with master CPU at early startup
making sure that AP won't run wild if master CPU doesn't
expect AP to come online.

Series also fixes 3 bugs found during testing CPU bringup
failure case.

--
Below is the detailed description of a more often happening hang:
---
Master CPU may timeout before cpu_callin_mask is set and cancel
booting CPU, but being onlined CPU still continues to boot, sets
cpu_active_mask (CPU_STARTING notifiers) and spins in
check_tsc_sync_target() for master cpu to arrive. Following attempt
to online another cpu hangs in stop_machine, initiated from here:
smp_callin ->
  smp_store_cpu_info ->
    identify_secondary_cpu ->
      mtrr_ap_init -> set_mtrr_from_inactive_cpu

stop_machine waits on completion of stop_work on all CPUs from
cpu_active_mask including a failed CPU that spins in check_tsc_sync_target().

Igor Mammedov (4):
  x86: fix list/memory corruption on CPU hotplug
  acpi_processor: do not mark present at boot but not onlined CPU as
    onlined
  x86: log error on secondary CPU wakeup failure at ERR level
  x86: initialize secondary CPU only if master CPU will wait for it

 arch/x86/kernel/cpu/common.c  |   27 ++++++----
 arch/x86/kernel/smpboot.c     |  104 +++++++++++++----------------------------
 drivers/acpi/acpi_processor.c |    1 -
 3 files changed, 48 insertions(+), 84 deletions(-)

