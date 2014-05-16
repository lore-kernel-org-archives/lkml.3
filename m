Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbaEPQSJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:18:09 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:55607 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757306AbaEPQSH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:18:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140516115737.GP11096@twins.programming.kicks-ass.net>
References: <537119EF.2060102@oracle.com>
	<20140512200135.GL1421@htj.dyndns.org>
	<53718119.1090000@cn.fujitsu.com>
	<537180B9.6080407@oracle.com>
	<53739F3B.4060608@linux.vnet.ibm.com>
	<53758B12.8060609@cn.fujitsu.com>
	<20140516115737.GP11096@twins.programming.kicks-ass.net>
Date: Sat, 17 May 2014 00:18:06 +0800
X-Google-Sender-Auth: RYVjzXXcEJl4RIk8Z7AZmq7twnU
Message-ID: <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: jjherne@linux.vnet.ibm.com, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 7:57 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 16, 2014 at 11:50:42AM +0800, Lai Jiangshan wrote:
>> Hi, Peter and other scheduler Gurus:
>>
>> When I was trying to test wq-VS-hotplug, I always hit a problem in scheduler
>> with the following WARNING:
>>
>> [   74.765519] WARNING: CPU: 1 PID: 13 at arch/x86/kernel/smp.c:124 native_smp_send_reschedule+0x2d/0x4b()
>> [   74.765520] Modules linked in: wq_hotplug(O) fuse cpufreq_ondemand ipv6 kvm_intel kvm uinput snd_hda_codec_realtek snd_hda_codec_generic snd_hda_codec_hdmi e1000e snd_hda_intel snd_hda_controller snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer ptp iTCO_wdt iTCO_vendor_support lpc_ich snd mfd_core pps_core soundcore acpi_cpufreq i2c_i801 microcode wmi radeon ttm drm_kms_helper drm i2c_algo_bit i2c_core
>> [   74.765545] CPU: 1 PID: 13 Comm: migration/1 Tainted: G           O  3.15.0-rc3+ #153
>> [   74.765546] Hardware name: LENOVO ThinkCentre M8200T/  , BIOS 5JKT51AUS 11/02/2010
>> [   74.765547]  000000000000007c ffff880236199c88 ffffffff814d7d2c 0000000000000000
>> [   74.765550]  0000000000000000 ffff880236199cc8 ffffffff8103add4 ffff880236199cb8
>> [   74.765552]  ffffffff81023e1b ffff8802361861c0 0000000000000001 ffff88023fd92b40
>> [   74.765555] Call Trace:
>> [   74.765559]  [<ffffffff814d7d2c>] dump_stack+0x51/0x75
>> [   74.765562]  [<ffffffff8103add4>] warn_slowpath_common+0x81/0x9b
>> [   74.765564]  [<ffffffff81023e1b>] ? native_smp_send_reschedule+0x2d/0x4b
>> [   74.765566]  [<ffffffff8103ae08>] warn_slowpath_null+0x1a/0x1c
>> [   74.765568]  [<ffffffff81023e1b>] native_smp_send_reschedule+0x2d/0x4b
>> [   74.765571]  [<ffffffff8105c2ea>] smp_send_reschedule+0xa/0xc
>> [   74.765574]  [<ffffffff8105fe46>] resched_task+0x5e/0x62
>> [   74.765576]  [<ffffffff81060238>] check_preempt_curr+0x43/0x77
>> [   74.765578]  [<ffffffff81060680>] __migrate_task+0xda/0x100
>> [   74.765580]  [<ffffffff810606a6>] ? __migrate_task+0x100/0x100
>> [   74.765582]  [<ffffffff810606c3>] migration_cpu_stop+0x1d/0x22
>> [   74.765585]  [<ffffffff810a33c6>] cpu_stopper_thread+0x84/0x116
>> [   74.765587]  [<ffffffff814d8642>] ? __schedule+0x559/0x581
>> [   74.765590]  [<ffffffff814dae3c>] ? _raw_spin_lock_irqsave+0x12/0x3c
>> [   74.765592]  [<ffffffff8105bd75>] ? __smpboot_create_thread+0x109/0x109
>> [   74.765594]  [<ffffffff8105bf46>] smpboot_thread_fn+0x1d1/0x1d6
>> [   74.765598]  [<ffffffff81056665>] kthread+0xad/0xb5
>> [   74.765600]  [<ffffffff810565b8>] ? kthread_freezable_should_stop+0x41/0x41
>> [   74.765603]  [<ffffffff814e0e2c>] ret_from_fork+0x7c/0xb0
>> [   74.765605]  [<ffffffff810565b8>] ? kthread_freezable_should_stop+0x41/0x41
>> [   74.765607] ---[ end trace 662efb362b4e8ed0 ]---
>>
>> After debugging, I found the hotlug-in cpu is atctive but !online in this case.
>> the problem was introduced by 5fbd036b.
>> Some code assumes that any cpu in cpu_active_mask is also online, but 5fbd036b breaks
>> this assumption, so the corresponding code with this assumption should be changed too.
>>
>
> This of course leaves the question how the workqueue code manages to
> call set_cpu_allowed_ptr() on a cpu _before_ its online.

create_worker().

>
> That too sounds fishy.. with the proposed patch the
> set_cpus_allowed_ptr() will 'gracefully' fail, but calling it in the
> first place is of course dubious too.

Not all set_cpus_allowed_ptr() in the kernel is protected by get_cpu_online(),
these set_cpus_allowed_ptr()s can also hit this problem when race.

so the scheduler/set_cpus_allowed_ptr()/cpu_active_mask should be the first
place to fix.
