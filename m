Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaEPDqf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 23:46:35 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:22002 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753333AbaEPDqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 23:46:33 -0400
X-IronPort-AV: E=Sophos;i="4.97,1064,1389715200"; 
   d="scan'208";a="30600656"
Message-ID: <53758B12.8060609@cn.fujitsu.com>
Date: Fri, 16 May 2014 11:50:42 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <jjherne@linux.vnet.ibm.com>, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com>
In-Reply-To: <53739F3B.4060608@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/15/2014 12:52 AM, Jason J. Herne wrote:
> On 05/12/2014 10:17 PM, Sasha Levin wrote:
>> I don't have an easy way to reproduce it as I only saw the bug once, but
>> it happened when I started pressuring CPU hotplug paths by adding and removing
>> CPUs often. Maybe it has anything to do with that?
> 
> As per the original report (http://article.gmane.org/gmane.linux.kernel/1643027)
> I am able to reproduce the problem.
> 
> The workload is (on S390 architecture):
> 2 processes onlining random cpus in a tight loop by using 'echo 1 >
> /sys/bus/cpu.../online'
> 2 processes offlining random cpus in a tight loop by using 'echo 0 >
> /sys/bus/cpu.../online'
> Otherwise, fairly idle system. load average: 5.82, 6.27, 6.27
> 
> The machine has 10 processors.
> The warning message some times hits within a few minutes on starting the
> workload. Other times it takes several hours.
> 
> 
> -- Jason J. Herne (jjherne@linux.vnet.ibm.com)
> 
> 


Hi, Peter and other scheduler Gurus:

When I was trying to test wq-VS-hotplug, I always hit a problem in scheduler
with the following WARNING:

[   74.765519] WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x2d/0x4b()
[   74.765520] Modules linked in: wq_hotplug(O) fuse cpufreq_ondemand ipv6 kvm_intel kvm uinput snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi e1000e snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer ptp iTCO_wdt iTCO_vendor_support lpc_ich snd mfd_core pps_core soundcore acpi_cpufreq i2c_i801 microcode wmi radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
[   74.765545] CPU: 1 PID: 13 Comm: migration/1 Tainted: G           O  3.15.0-rc3+ #153
[   74.765546] Hardware name: LENOVO ThinkCentre M8200T/  , BIOS 5JKT51AUS 11/02/2010
[   74.765547]  000000000000007c ffff880236199c88 ffffffff814d7d2c 0000000000000000
[   74.765550]  0000000000000000 ffff880236199cc8 ffffffff8103add4 ffff880236199cb8
[   74.765552]  ffffffff81023e1b ffff8802361861c0 0000000000000001 ffff88023fd92b40
[   74.765555] Call Trace:
[   74.765559]  [<ffffffff814d7d2c>] dump_stack+0x51/0x75
[   74.765562]  [<ffffffff8103add4>] warn_slowpath_common+0x81/0x9b
[   74.765564]  [<ffffffff81023e1b>] ? native_smp_send_reschedule+0x2d/0x4b
[   74.765566]  [<ffffffff8103ae08>] warn_slowpath_null+0x1a/0x1c
[   74.765568]  [<ffffffff81023e1b>] native_smp_send_reschedule+0x2d/0x4b
[   74.765571]  [<ffffffff8105c2ea>] smp_send_reschedule+0xa/0xc
[   74.765574]  [<ffffffff8105fe46>] resched_task+0x5e/0x62
[   74.765576]  [<ffffffff81060238>] check_preempt_curr+0x43/0x77
[   74.765578]  [<ffffffff81060680>] __migrate_task+0xda/0x100
[   74.765580]  [<ffffffff810606a6>] ? __migrate_task+0x100/0x100
[   74.765582]  [<ffffffff810606c3>] migration_cpu_stop+0x1d/0x22
[   74.765585]  [<ffffffff810a33c6>] cpu_stopper_thread+0x84/0x116
[   74.765587]  [<ffffffff814d8642>] ? __schedule+0x559/0x581
[   74.765590]  [<ffffffff814dae3c>] ? _raw_spin_lock_irqsave+0x12/0x3c
[   74.765592]  [<ffffffff8105bd75>] ? __smpboot_create_thread+0x109/0x109
[   74.765594]  [<ffffffff8105bf46>] smpboot_thread_fn+0x1d1/0x1d6
[   74.765598]  [<ffffffff81056665>] kthread+0xad/0xb5
[   74.765600]  [<ffffffff810565b8>] ? kthread_freezable_should_stop+0x41/0x41
[   74.765603]  [<ffffffff814e0e2c>] ret_from_fork+0x7c/0xb0
[   74.765605]  [<ffffffff810565b8>] ? kthread_freezable_should_stop+0x41/0x41
[   74.765607] ---[ end trace 662efb362b4e8ed0 ]---

After debugging, I found the hotlug-in cpu is atctive but !online in this case.
the problem was introduced by 5fbd036b.
Some code assumes that any cpu in cpu_active_mask is also online, but 5fbd036b breaks
this assumption, so the corresponding code with this assumption should be changed too.


Hi, Jason J. Herne and Sasha Levin

Thank you for testing wq-VS-hotplug.

The following patch is just a workaround. After it is applied, the above WARNING
is gone, but I can't hit the wq problem that you found.

You can use the following workaround patch to test wq-VS-hotplug again or just
wait the scheduler guys give us a proper patch.
(A interesting thing, 5fbd036b also touches the arch s390).

Thanks,
Lai
---
diff --git a/kernel/cpu.c b/kernel/cpu.c
index a9e710e..253a129 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -726,9 +726,10 @@ void set_cpu_present(unsigned int cpu, bool present)
 
 void set_cpu_online(unsigned int cpu, bool online)
 {
-	if (online)
+	if (online) {
 		cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
-	else
+		cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
+	} else
 		cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
 }
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 268a45e..c1a712d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5043,7 +5043,6 @@ static int sched_cpu_active(struct notifier_block *nfb,
 				      unsigned long action, void *hcpu)
 {
 	switch (action & ~CPU_TASKS_FROZEN) {
-	case CPU_STARTING:
 	case CPU_DOWN_FAILED:
 		set_cpu_active((long)hcpu, true);
 		return NOTIFY_OK;
