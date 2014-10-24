Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756646AbaJXM24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:28:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:25994 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561AbaJXM2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:28:53 -0400
Message-ID: <544A45F8.2030207@oracle.com>
Date: Fri, 24 Oct 2014 08:28:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        htejun@gmail.com
Subject: Re: rcu_preempt detected stalls.
References: <20141013173504.GA27955@redhat.com> <543DDD5E.9080602@oracle.com> <20141023183917.GX4977@linux.vnet.ibm.com> <54494F2F.6020005@oracle.com> <20141023195808.GB4977@linux.vnet.ibm.com>
In-Reply-To: <20141023195808.GB4977@linux.vnet.ibm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2014 03:58 PM, Paul E. McKenney wrote:
> On Thu, Oct 23, 2014 at 02:55:43PM -0400, Sasha Levin wrote:
>> > On 10/23/2014 02:39 PM, Paul E. McKenney wrote:
>>> > > On Tue, Oct 14, 2014 at 10:35:10PM -0400, Sasha Levin wrote:
>>>> > >> On 10/13/2014 01:35 PM, Dave Jones wrote:
>>>>> > >>> oday in "rcu stall while fuzzing" news:
>>>>> > >>>
>>>>> > >>> INFO: rcu_preempt detected stalls on CPUs/tasks:
>>>>> > >>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
>>>>> > >>> 	Tasks blocked on level-0 rcu_node (CPUs 0-3): P766 P646
>>>>> > >>> 	(detected by 0, t=6502 jiffies, g=75434, c=75433, q=0)
>>>> > >>
>>>> > >> I've complained about RCU stalls couple days ago (in a different context)
>>>> > >> on -next. I guess whatever causing them made it into Linus's tree?
>>>> > >>
>>>> > >> https://lkml.org/lkml/2014/10/11/64
>>> > > 
>>> > > And on that one, I must confess that I don't see where the RCU read-side
>>> > > critical section might be.
>>> > > 
>>> > > Hmmm...  Maybe someone forgot to put an rcu_read_unlock() somewhere.
>>> > > Can you reproduce this with CONFIG_PROVE_RCU=y?
>> > 
>> > Paul, if that was directed to me - Yes, I see stalls with CONFIG_PROVE_RCU
>> > set and nothing else is showing up before/after that.
> Indeed it was directed to you.  ;-)
> 
> Does the following crude diagnostic patch turn up anything?

Nope, seeing stalls but not seeing that pr_err() you added.

[ 5107.395916] INFO: rcu_preempt detected stalls on CPUs/tasks:
[ 5107.395916]  0: (776 ticks this GP) idle=a8d/140000000000002/0 softirq=16356/16356 last_accelerate: f5b7/55e5, nonlazy_posted: 24252, ..
[ 5107.395916]  (detected by 1, t=20502 jiffies, g=13949, c=13948, q=0)
[ 5107.395916] Task dump for CPU 0:
[ 5107.395916] trinity-c0      R  running task    12848 20357   9041 0x0008000e
[ 5107.395916]  0000000000000000 ffff88006bfd76c0 ffff88065722b988 ffffffffa10af964
[ 5107.395916]  ffff88065722b998 ffffffffa106ad23 ffff88065722b9c8 ffffffffa119dce5
[ 5107.395916]  00000000001d76c0 ffff88006bfd76c0 00000000001d76c0 ffff8806473cbd10
[ 5107.395916] Call Trace:
[ 5107.395916]  [<ffffffffa10af964>] ? kvm_clock_read+0x24/0x40
[ 5107.395916]  [<ffffffffa106ad23>] ? sched_clock+0x13/0x30
[ 5107.395916]  [<ffffffffa119dce5>] ? sched_clock_local+0x25/0x90
[ 5107.395916]  [<ffffffffa1303dfb>] ? __slab_free+0xbb/0x3a0
[ 5107.395916]  [<ffffffffa1b71167>] ? debug_smp_processor_id+0x17/0x20
[ 5107.395916]  [<ffffffffa451cb64>] ? _raw_spin_unlock_irqrestore+0x64/0xa0
[ 5107.395916]  [<ffffffffa1303dfb>] ? __slab_free+0xbb/0x3a0
[ 5107.395916]  [<ffffffffa1b71bce>] ? __debug_check_no_obj_freed+0x10e/0x210
[ 5107.395916]  [<ffffffffa1305871>] ? kmem_cache_free+0xb1/0x4f0
[ 5107.395916]  [<ffffffffa1305883>] ? kmem_cache_free+0xc3/0x4f0
[ 5107.395916]  [<ffffffffa1305bb2>] ? kmem_cache_free+0x3f2/0x4f0
[ 5107.395916]  [<ffffffffa12e0cbe>] ? unlink_anon_vmas+0x10e/0x180
[ 5107.395916]  [<ffffffffa12e0cbe>] ? unlink_anon_vmas+0x10e/0x180
[ 5107.395916]  [<ffffffffa12cfbdf>] ? free_pgtables+0x3f/0x130
[ 5107.395916]  [<ffffffffa12dc1a4>] ? exit_mmap+0xc4/0x180
[ 5107.395916]  [<ffffffffa13143fe>] ? __khugepaged_exit+0xbe/0x120
[ 5107.395916]  [<ffffffffa115bbb3>] ? mmput+0x73/0x110
[ 5107.395916]  [<ffffffffa1162eb7>] ? do_exit+0x2c7/0xd30
[ 5107.395916]  [<ffffffffa1173fb9>] ? get_signal+0x3c9/0xaf0
[ 5107.395916]  [<ffffffffa1b71167>] ? debug_smp_processor_id+0x17/0x20
[ 5107.395916]  [<ffffffffa11bccbe>] ? put_lock_stats.isra.13+0xe/0x30
[ 5107.395916]  [<ffffffffa451c810>] ? _raw_spin_unlock_irq+0x30/0x70
[ 5107.395916]  [<ffffffffa11639c2>] ? do_group_exit+0x52/0xe0
[ 5107.395916]  [<ffffffffa1173ef6>] ? get_signal+0x306/0xaf0
[ 5107.395916]  [<ffffffffa119dce5>] ? sched_clock_local+0x25/0x90
[ 5107.395916]  [<ffffffffa105f2f0>] ? do_signal+0x20/0x130
[ 5107.395916]  [<ffffffffa1298558>] ? context_tracking_user_exit+0x78/0x2d0
[ 5107.395916]  [<ffffffffa1b71183>] ? __this_cpu_preempt_check+0x13/0x20
[ 5107.395916]  [<ffffffffa11c04cb>] ? trace_hardirqs_on_caller+0xfb/0x280
[ 5107.395916]  [<ffffffffa11c065d>] ? trace_hardirqs_on+0xd/0x10
[ 5107.395916]  [<ffffffffa105f469>] ? do_notify_resume+0x69/0xb0
[ 5107.395916]  [<ffffffffa451d74f>] ? int_signal+0x12/0x17


Thanks,
Sasha
