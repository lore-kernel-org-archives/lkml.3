Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab3EURqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:46:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18209 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab3EURqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:46:33 -0400
X-Authority-Analysis: v=2.0 cv=UY7TuduN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=QFzVRBl5zaQA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=8_-nLGVFUTIA:10 a=SX6bkkYZ9Ud0koh1d2EA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=ScbTpXqmzOqvSBLO:21 a=cgGRVd5bZZdwEqfE:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1369158390.6828.148.camel@gandalf.local.home>
Subject: [PATCH][3.10] nohz: Fix lockup on restart from wrong error code
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Tejun Heo <tj@kernel.org>
Date: Tue, 21 May 2013 13:46:30 -0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit a382bf934449 "nohz: Assign timekeeping duty to a CPU outside the
full dynticks range" added a cpu notifier callback that would prevent
the time keeping CPU from going offline if the have_nohz_full_mask was
set.

This also prevents the CPU from going offline on system reboot.

Worse yet, the return code was -EINVAL, but the notifier does not
recognize error codes, and it must be wrapped by a notifier_from_errno()
function. This means that even though the CPU would fail to go down, the
notifier would think it succeeded, and the cpu down process would
continue.

This caused two different problems. One, the migration thread after
moving tasks from the CPU would park itself and then a task, namely the
reboot task, could migrate onto that CPU. Then the reboot task spins
waiting for the cpu to go idle. But because the reboot task happens to
be spinning on the cpu its waiting for, the system hangs.

The other error that happened was that the sched_domain re-setup would
get confused, and in get_group() the cpu = cpumask_first() would process
a mask that had nothing set, and return cpu > nr_cpu_ids. Later it would
reference the per_cpu sg with this CPU and get a bogus pointer and
crash.

This fix simply fixes the issue with the return code of the cpu
notifier. This prevents all non-boot CPUs from going down, but that only
gives us the following warnings and does not crash or lockup the system.

[   73.655698] _cpu_down: attempt to take down CPU 2 failed
[   73.661874] Error taking CPU2 down: -22
[   73.665727] Non-boot CPUs are not disabled
[   73.669853] Restarting system.

And because of this, we get this warning too. But at least the system
reboots.

[   73.432740] ------------[ cut here ]------------
[   73.433003] WARNING: at /home/rostedt/work/git/linux-trace.git/kernel/workqueue.c:4584 workqueue_cpu_up_callback+0x24b/0x48c()
[   73.433003] Modules linked in: ebtables ipt_MASQUERADE sunrpc bridge stp llc ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ipv6 uinput snd_hda_codec_idt snd_hda_intel snd_hda_codec kvm_intel kvm snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer snd soundcore snd_page_alloc shpchp i2c_i801 microcode pata_acpi firewire_ohci firewire_core crc_itu_t ata_generic i915 drm_kms_helper drm i2c_algo_bit i2c_core video [last unloaded: ip6_tables]
[   73.433003] CPU: 0 PID: 2765 Comm: reboot Not tainted 3.10.0-rc2-test+ #124
[   73.433003] Hardware name: To Be Filled By O.E.M. To Be Filled By O.E.M./To be filled by O.E.M., BIOS SDBLI944.86P 05/08/2007
[   73.433003]  ffffffff817d0b08 ffff88006a95bc28 ffffffff814ca368 ffff88006a95bc68
[   73.433003]  ffffffff81035267 0000000000000002 0000000000000000 ffff88007d512e00
[   73.433003]  0000000000000002 ffff88007a809cc0 ffff88007d513260 ffff88006a95bc78
[   73.433003] Call Trace:
[   73.433003]  [<ffffffff814ca368>] dump_stack+0x19/0x1b
[   73.433003]  [<ffffffff81035267>] warn_slowpath_common+0x67/0x80
[   73.433003]  [<ffffffff8103529a>] warn_slowpath_null+0x1a/0x1c
[   73.433003]  [<ffffffff814bee83>] workqueue_cpu_up_callback+0x24b/0x48c
[   73.433003]  [<ffffffff810679fd>] ? cpumask_weight+0x13/0x14
[   73.433003]  [<ffffffff814d22dd>] notifier_call_chain+0x37/0x63
[   73.433003]  [<ffffffff8105c19a>] __raw_notifier_call_chain+0xe/0x10
[   73.433003]  [<ffffffff810383d8>] __cpu_notify+0x20/0x32
[   73.433003]  [<ffffffff814b3122>] _cpu_down+0x90/0x229
[   73.433003]  [<ffffffff81038687>] disable_nonboot_cpus+0x5a/0xfb
[   73.433003]  [<ffffffff81049d87>] kernel_restart+0x18/0x5a
[   73.433003]  [<ffffffff81049f52>] SYSC_reboot+0x177/0x1d9
[   73.433003]  [<ffffffff810ca70a>] ? trace_preempt_on+0x1b/0x2f
[   73.433003]  [<ffffffff81085eac>] ? trace_hardirqs_on+0xd/0xf
[   73.433003]  [<ffffffff810e571e>] ? user_exit+0x69/0x70
[   73.433003]  [<ffffffff810e571e>] ? user_exit+0x69/0x70
[   73.433003]  [<ffffffff81085e68>] ? trace_hardirqs_on_caller+0x160/0x197
[   73.433003]  [<ffffffff81085eac>] ? trace_hardirqs_on+0xd/0xf
[   73.433003]  [<ffffffff8100c7b7>] ? syscall_trace_enter+0xdb/0x1b3
[   73.433003]  [<ffffffff81049fc2>] SyS_reboot+0xe/0x10
[   73.433003]  [<ffffffff814d5814>] tracesys+0xdd/0xe2
[   73.433003] ---[ end trace 1a5fc10dcbddf506 ]---

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f420813..7e8e208 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -306,7 +306,7 @@ static int __cpuinit tick_nohz_cpu_down_callback(struct notifier_block *nfb,
 		 * we can't safely shutdown that CPU.
 		 */
 		if (have_nohz_full_mask && tick_do_timer_cpu == cpu)
-			return -EINVAL;
+			return notifier_from_errno(-EINVAL);
 		break;
 	}
 	return NOTIFY_OK;


