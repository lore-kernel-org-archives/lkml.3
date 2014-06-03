Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354AbaFCLUL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:20:11 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:21487 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750892AbaFCLUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:20:08 -0400
X-IronPort-AV: E=Sophos;i="4.98,964,1392134400"; 
   d="scan'208";a="31380577"
Message-ID: <538DB076.4090704@cn.fujitsu.com>
Date: Tue, 3 Jun 2014 19:24:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <jjherne@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sasha.levin@oracle.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <537119EF.2060102@oracle.com> <20140512200135.GL1421@htj.dyndns.org> <53718119.1090000@cn.fujitsu.com> <537180B9.6080407@oracle.com> <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net> <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net> <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com>
In-Reply-To: <53875F09.3090607@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jason

Could you test again after the following command has done.
(if Peter hasn't asked you test with this command before nor he doesn't stop you now) 

echo NO_TTWU_QUEUE > /sys/kernel/debug/sched_features

Thanks a lot.

Hi, Peter,

I found something strange by review (just by review, no test yet)

__migrate_task()
{
...
	/*
	 * If we're not on a rq, the next wake-up will ensure we're
	 * placed properly.
	 */
	if (p->on_rq) {
		dequeue_task(rq_src, p, 0);
		set_task_cpu(p, dest_cpu);
		enqueue_task(rq_dest, p, 0);
		check_preempt_curr(rq_dest, p, 0);
	}
...
}

The comment is incorrect if TTWU_QUEUE is enabled.
The task is waken-up even p->on_rq==0 in this case:
	p->wake_entry is added to the rq,
	p->state is TASK_WAKING
	p->on_rq is 0

In this case __migrate_task() fails to migrate the task!!!.

Go back to workqueue for higher level analysing.

task1				cpu#4			task3
workqueue_cpu_up_callback()
							wake_up_process(worker1)
							  ttwu_queue_remote() #queue worker1 to cpu#4
set_cpus_allowed_ptr()
  set worker's cpuallowed to
  cpumask_of(5)
				#stopper_task
				__migrate_task()
				finds p->on_rq is 0,
				do nothing return
set_cpus_allowed_ptr() return 0

In this case, the WARN_ON() in process_one_work() hit.

Thanks,
Lai


On 05/30/2014 12:23 AM, Jason J. Herne wrote:
> On 05/27/2014 10:26 AM, Peter Zijlstra wrote:
>> On Tue, May 27, 2014 at 10:18:31AM -0400, Jason J. Herne wrote:
>>> On 05/16/2014 12:29 PM, Peter Zijlstra wrote:
>>>> On Sat, May 17, 2014 at 12:18:06AM +0800, Lai Jiangshan wrote:
>>>>> so the scheduler/set_cpus_allowed_ptr()/cpu_active_mask should be the first
>>>>> place to fix.
>>>>
>>>> I'm not arguing about that, not to mention that this is userspace
>>>> exposed and nobody protects that.
>>>>
>>>> But I was expecting kernel stuff that calls it on hotplug to be
>>>> serialized thusly, but apparently not so.
>>>>
>>>
>>> Was a final patch posted for this issue? The discussion made it sound like
>>> there were still a few things to figure out before we could resolve this
>>> bug. I can recreate this as needed and I'm happy to test any patches.
>>
>>
>> https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/commit/?h=sched/urgent&id=6acbfb96976fc3350e30d964acb1dbbdf876d55e
>>
>> which should make its way to Linus soonish I suppose.
>>
> 
> I applied the patch on top of c7208164e66f63e3ec1759b98087849286410741 and I am still hitting the problem.
> Should I have applied to a different branch/commit to pick up any other needed changes?
> 
> Patch applied:
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index a9e710e..247979a 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -726,10 +726,12 @@ void set_cpu_present(unsigned int cpu, bool present)
> void set_cpu_online(unsigned int cpu, bool online)
> {
> - if (online)
> + if (online) {
> cpumask_set_cpu(cpu, to_cpumask(cpu_online_bits));
> - else
> + cpumask_set_cpu(cpu, to_cpumask(cpu_active_bits));
> + } else {
> cpumask_clear_cpu(cpu, to_cpumask(cpu_online_bits));
> + }
> }
> void set_cpu_active(unsigned int cpu, bool active)
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 44e00ab..86f3890 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5076,7 +5076,6 @@ static int sched_cpu_active(struct notifier_block *nfb,
> unsigned long action, void *hcpu)
> {
> switch (action & ~CPU_TASKS_FROZEN) {
> - case CPU_STARTING:
> case CPU_DOWN_FAILED:
> set_cpu_active((long)hcpu, true);
> return NOTIFY_OK;
> 
> Here is the output from the recreation using this patch:
> 
> [ 3634.146233] ------------[ cut here ]------------
> [ 3634.146238] WARNING: at kernel/workqueue.c:2176
> [ 3634.146239] Modules linked in: ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack xt_CHECKSUM iptable_mangle bridge stp llc ip6table_filter ip6_tables ebtable_nat ebtables iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi qeth_l2 tape_3590 tape tape_class vhost_net tun vhost macvtap macvlan eadm_sch qeth ccwgroup zfcp scsi_transport_fc scsi_tgt qdio dasd_eckd_mod dasd_mod dm_multipath [last unloaded: kvm]
> [ 3634.146260] CPU: 6 PID: 28009 Comm: kworker/7:0 Not tainted 3.15.0-rc7 #1
> [ 3634.146263] Workqueue: \xffffff80           (null)
> [ 3634.146264] task: 000000025def32e0 ti: 000000026dca0000 task.ti: 000000026dca0000
> [ 3634.146266] Krnl PSW : 0404c00180000000 000000000015ad1a (process_one_work+0x2e6/0x4c0)
> [ 3634.146272]            R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:3 CC:0 PM:0 EA:3
> Krnl GPRS: 0000000000000000 0000000000bc649a 00000002764b0980 0000000000b94f40
> [ 3634.146275]            0000000000b94f40 0000000000000000 0000000000000000 0000000000bc6496
> [ 3634.146277]            0000000000000000 000000008b65b600 000000008b657000 000000008b657018
> [ 3634.146278]            00000002764b0980 0000000000b94f40 000000026dca3dd0 000000026dca3d70
> [ 3634.146287] Krnl Code: 000000000015ad0e: 95001000        cli    0(%r1),0
>            000000000015ad12: a774fece        brc    7,15aaae
>           #000000000015ad16: a7f40001        brc    15,15ad18
>           >000000000015ad1a: 92011000        mvi    0(%r1),1
>            000000000015ad1e: a7f4fec8        brc    15,15aaae
>            000000000015ad22: e31003180004    lg    %r1,792
>            000000000015ad28: 58301024        l    %r3,36(%r1)
>            000000000015ad2c: a73a0001        ahi    %r3,1
> [ 3634.146299] Call Trace:
> [ 3634.146301] ([<000000000015ace8>] process_one_work+0x2b4/0x4c0)
> [ 3634.146303]  [<000000000015c100>] worker_thread+0x178/0x39c
> [ 3634.146305]  [<0000000000164ba6>] kthread+0x10e/0x128
> [ 3634.146310]  [<000000000072d026>] kernel_thread_starter+0x6/0xc
> [ 3634.146312]  [<000000000072d020>] kernel_thread_starter+0x0/0xc
> [ 3634.146313] Last Breaking-Event-Address:
> [ 3634.146315]  [<000000000015ad16>] process_one_work+0x2e2/0x4c0
> [ 3634.146316] ---[ end trace 03f51c9126c24171 ]---
> 
> I don't think this output provides anything new. Please let me know if I can gather any more data.
> 

