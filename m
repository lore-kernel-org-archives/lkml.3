Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaCMO0S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 10:26:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751663AbaCMO0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 10:26:17 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, imammedo@redhat.com,
        bp@suse.de, paul.gortmaker@windriver.com, JBeulich@suse.com,
        prarit@redhat.com, drjones@redhat.com, toshi.kani@hp.com,
        x86@kernel.org, riel@redhat.com, gong.chen@linux.intel.com
Subject: [PATCH 0/3] x86: fix hang when AP bringup is too slow
Date: Thu, 13 Mar 2014 15:25:17 +0100
Message-Id: <1394720720-8484-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Below is detailed description of a more often happening hang:
-----
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


Igor Mammedov (3):
  x86: replace timeouts when booting secondary CPU with infinite wait
    loop
  x86: halt secondary CPU if master doesn't wait on it
  x86: cleanup not needed cpu_initialized_mask

 arch/x86/include/asm/cpumask.h |    1 -
 arch/x86/kernel/cpu/common.c   |   35 ++++++++++++-------
 arch/x86/kernel/smpboot.c      |   70 ++--------------------------------------
 3 files changed, 25 insertions(+), 81 deletions(-)

