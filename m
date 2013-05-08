Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab3EHQNu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 12:13:50 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:27583 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3EHQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 12:13:48 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, x86@kernel.org, hpa@zytor.com, bp@alien8.de,
        mingo@redhat.com, fenghua.yu@intel.com, tglx@linutronix.de,
        xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, stable@vger.kernel.org,
        konrad.wilk@oracle.com, konrad.wilk@oracle.com, konrad.wilk@oracle.com
Subject: [PATCH] x86, microcode: Add local mutex to not hit a deadlock.
Date: Wed,  8 May 2013 12:13:03 -0400
Message-Id: <1368029583-23337-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can easily be triggered if a new CPU is added (via
ACPI hotplug mechanism) and from user-space do:

echo 1 > /sys/devices/system/cpu/cpu3/online

(or wait for UDEV to do it) on a newly appeared CPU.

The deadlock is that the "store_online" in drivers/base/cpu.c
takes the cpu_hotplug_driver_lock() lock, then calls "cpu_up".
"cpu_up" eventually ends up calling "save_mc_for_early"
which also takes the cpu_hotplug_driver_lock() lock.

And here is that kernel thinks of it:

smpboot: Stack at about ffff880075c39f44
smpboot: CPU3: has booted.
microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x25

=============================================
[ INFO: possible recursive locking detected ]
3.9.0upstream-10129-g167af0e #1 Not tainted
---------------------------------------------
sh/2487 is trying to acquire lock:
 (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20

but task is already holding lock:
 (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(x86_cpu_hotplug_driver_mutex);
  lock(x86_cpu_hotplug_driver_mutex);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

6 locks held by sh/2487:
 #0:  (sb_writers#5){.+.+.+}, at: [<ffffffff811ca48d>] vfs_write+0x17d/0x190
 #1:  (&buffer->mutex){+.+.+.}, at: [<ffffffff812464ef>] sysfs_write_file+0x3f/0x160
 #2:  (s_active#20){.+.+.+}, at: [<ffffffff81246578>] sysfs_write_file+0xc8/0x160
 #3:  (x86_cpu_hotplug_driver_mutex){+.+.+.}, at: [<ffffffff81075512>] cpu_hotplug_driver_lock+0x12/0x20
 #4:  (cpu_add_remove_lock){+.+.+.}, at: [<ffffffff810961c2>] cpu_maps_update_begin+0x12/0x20
 #5:  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff810962a7>] cpu_hotplug_begin+0x27/0x60

Suggested-by: Borislav Petkov <bp@alien8.de>
CC: stable@vger.kernel.org # for v3.9
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/kernel/microcode_intel_early.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/microcode_intel_early.c b/arch/x86/kernel/microcode_intel_early.c
index d893e8e..2e9e128 100644
--- a/arch/x86/kernel/microcode_intel_early.c
+++ b/arch/x86/kernel/microcode_intel_early.c
@@ -487,6 +487,7 @@ static inline void show_saved_mc(void)
 #endif
 
 #if defined(CONFIG_MICROCODE_INTEL_EARLY) && defined(CONFIG_HOTPLUG_CPU)
+static DEFINE_MUTEX(x86_cpu_microcode_mutex);
 /*
  * Save this mc into mc_saved_data. So it will be loaded early when a CPU is
  * hot added or resumes.
@@ -507,7 +508,7 @@ int save_mc_for_early(u8 *mc)
 	 * Hold hotplug lock so mc_saved_data is not accessed by a CPU in
 	 * hotplug.
 	 */
-	cpu_hotplug_driver_lock();
+	mutex_lock(&x86_cpu_microcode_mutex);
 
 	mc_saved_count_init = mc_saved_data.mc_saved_count;
 	mc_saved_count = mc_saved_data.mc_saved_count;
@@ -544,7 +545,7 @@ int save_mc_for_early(u8 *mc)
 	}
 
 out:
-	cpu_hotplug_driver_unlock();
+	mutex_unlock(&x86_cpu_microcode_mutex);
 
 	return ret;
 }
-- 
1.7.7.6

