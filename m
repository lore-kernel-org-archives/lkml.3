Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758279Ab3EQWTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 18:19:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3EQVh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 17:37:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@kernel.org>, fenghua.yu@intel.com,
        xen-devel@lists.xensource.com
Subject: [ 038/102] x86/microcode: Add local mutex to fix physical CPU hot-add deadlock
Date: Fri, 17 May 2013 14:35:53 -0700
Message-Id: <20130517213248.334309022@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130517213244.277411019@linuxfoundation.org>
References: <20130517213244.277411019@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 074d72ff57f65de779e2f70d5906964c0ba1c123 upstream.

This can easily be triggered if a new CPU is added (via
ACPI hotplug mechanism) and from user-space you do:

   echo 1 > /sys/devices/system/cpu/cpu3/online

(or wait for UDEV to do it) on a newly appeared physical CPU.

The deadlock is that the "store_online" in drivers/base/cpu.c
takes the cpu_hotplug_driver_lock() lock, then calls "cpu_up".
"cpu_up" eventually ends up calling "save_mc_for_early"
which also takes the cpu_hotplug_driver_lock() lock.

And here is that lockdep thinks of it:

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

Suggested-and-Acked-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: fenghua.yu@intel.com
Cc: xen-devel@lists.xensource.com
Link: http://lkml.kernel.org/r/1368029583-23337-1-git-send-email-konrad.wilk@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_intel_early.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

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


