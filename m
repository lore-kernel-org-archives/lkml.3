Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbaG2HFN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 03:05:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:61803 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751647AbaG2HFK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 03:05:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,755,1400050800"; 
   d="txt'?scan'208";a="568762775"
Date: Tue, 29 Jul 2014 15:06:26 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Borislav Petkov <bp@alien8.de>, David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Yong Wang <yong.y.wang@linux.intel.com>
Subject: Re: [PATCH v2] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140729070626.GA9635@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1406016292-55968-1-git-send-email-wanpeng.li@linux.intel.com>
 <53CF78A7.5070302@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Content-Disposition: inline
In-Reply-To: <53CF78A7.5070302@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Yasuaki,
On Wed, Jul 23, 2014 at 05:56:07PM +0900, Yasuaki Ishimatsu wrote:
>(2014/07/22 17:04), Wanpeng Li wrote:
>> [  220.262093] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
>> [  220.262104] IP: [<ffffffff810e7ac9>] find_busiest_group+0x2b9/0xa30
>> [  220.262111] PGD 5a9d5067 PUD 13067 PMD 0
>> [  220.262117] Oops: 0000 [#3] SMP
>> [...]
>> [  220.262245] Call Trace:
>> [  220.262252]  [<ffffffff810e8396>] load_balance+0x156/0x980
>> [  220.262259]  [<ffffffff816eeffe>] ? _raw_spin_unlock_irqrestore+0x2e/0xa0
>> [  220.262266]  [<ffffffff810e9aa3>] idle_balance+0xe3/0x150
>> [  220.262270]  [<ffffffff816ec4e7>] __schedule+0x797/0x8d0
>> [  220.262277]  [<ffffffff816ec934>] schedule+0x24/0x70
>> [  220.262283]  [<ffffffff816e9cd9>] schedule_timeout+0x119/0x1f0
>> [  220.262294]  [<ffffffff810bb6e0>] ? lock_timer_base+0x70/0x70
>> [  220.262301]  [<ffffffff816e9dc9>] schedule_timeout_uninterruptible+0x19/0x20
>> [  220.262308]  [<ffffffff810bd3e8>] msleep+0x18/0x20
>> [  220.262317]  [<ffffffff813aa11a>] lock_device_hotplug_sysfs+0x2a/0x50
>> [  220.262323]  [<ffffffff813aa16e>] online_store+0x2e/0x80
>> [  220.262358]  [<ffffffff813a873b>] dev_attr_store+0x1b/0x20
>> [  220.262366]  [<ffffffff812292fd>] sysfs_write_file+0xdd/0x160
>> [  220.262377]  [<ffffffff811b7e78>] vfs_write+0xc8/0x170
>> [  220.262384]  [<ffffffff811b83ca>] SyS_write+0x5a/0xa0
>> [  220.262388]  [<ffffffff816f76b9>] system_call_fastpath+0x16/0x1b
>> 
>> Last level cache shared map is built during cpu up and build sched domain
>> routine takes advantage of it to setup sched domain cpu topology, however,
>> llc shared map is unreleased during cpu disable which lead to invalid sched
>> domain cpu topology. This patch fix it by release llc shared map correctly
>> during cpu disable.
>> 
>
>I posted a latest patch as follows:
>https://lkml.org/lkml/2014/7/22/1018
>
>Could you confirm the patch fixes your issue?

Sorry for the late, there is still call trace w/ your patch applied. The
call trace is in attachment.

Regards,
Wanpeng Li 

>
>Thanks,
>Yasuaki Ishimatsu
>
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>> v1 -> v2:
>>   * fix subject line
>> 
>>   arch/x86/kernel/smpboot.c | 3 +++
>>   1 file changed, 3 insertions(+)
>> 
>> diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
>> index 5492798..0134ec7 100644
>> --- a/arch/x86/kernel/smpboot.c
>> +++ b/arch/x86/kernel/smpboot.c
>> @@ -1292,6 +1292,9 @@ static void remove_siblinginfo(int cpu)
>>   
>>   	for_each_cpu(sibling, cpu_sibling_mask(cpu))
>>   		cpumask_clear_cpu(cpu, cpu_sibling_mask(sibling));
>> +	for_each_cpu(sibling, cpu_llc_shared_mask(cpu))
>> +		cpumask_clear_cpu(cpu, cpu_llc_shared_mask(sibling));
>> +	cpumask_clear(cpu_llc_shared_mask(cpu));
>>   	cpumask_clear(cpu_sibling_mask(cpu));
>>   	cpumask_clear(cpu_core_mask(cpu));
>>   	c->phys_proc_id = 0;
>> 
>

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="call trace.txt"

when run "xl vcpu-set 0 2", the dom0 only report "broke affinity ..."
when run "xl vcpu-set 0 26", the call trace happens.

the dom0 call trace log as following:

[  295.464489] Broke affinity for irq 298
[  295.756205] Broke affinity for irq 299
[  295.767177] Broke affinity for irq 301
[  295.779177] Broke affinity for irq 303
[  366.283682] installing Xen timer for CPU 2
[  366.283749] cpu 2 spinlock event irq 103
[  366.310290] installing Xen timer for CPU 14
[  366.310347] cpu 14 spinlock event irq 110
[  366.312432] divide error: 0000 [#1] SMP
[  366.312449] Modules linked in: nfsv3 nfs_acl auth_rpcgss oid_registry nfsv4
d
[  366.312583] CPU: 14 PID: 63 Comm: ksoftirqd/14 Not tainted 3.15.6 #2
[  366.312598] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS
GRNDSDP4
[  366.312623] task: ffff88017c8d2c10 ti: ffff88017c8f0000 task.ti:
ffff88017c80
[  366.312647] RIP: e030:[<ffffffff810ea5f9>]  [<ffffffff810ea5f9>]
find_busies0
[  366.312681] RSP: e02b:ffff88017c8f3ac8  EFLAGS: 00010046
[  366.312694] RAX: 0000000000000000 RBX: ffff88017c8f3bc8 RCX:
0000000000000000
[  366.312708] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[  366.312724] RBP: ffff88017c8f3c38 R08: ffff880003fb3d00 R09:
0000000000000040
[  366.312742] R10: 0000000000000000 R11: 0000000000000000 R12:
0000000000013e00
[  366.312757] R13: ffff88017c8f3cb8 R14: ffff880003fb3ce0 R15:
0000000000000000
[  366.312783] FS:  0000000000000000(0000) GS:ffff880181bc0000(0000)
knlGS:00000
[  366.312803] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  366.312817] CR2: 00007fad200d5000 CR3: 0000000001c14000 CR4:
0000000000042660
[  366.312836] Stack:
[  366.312843]  0000000000000000 ffff88017c8f3b18 0000000000002e7b
0000000000000
[  366.312868]  ffff880003fb3ce0 0000000000013df8 0000000000000200
0000000000010
[  366.312890]  0000000000000000 ffff880003fb3cf8 0000000000000000
0000000000000
[  366.312911] Call Trace:
[  366.312932]  [<ffffffff810eae37>] load_balance+0x177/0x9d0
[  366.312954]  [<ffffffff810df56b>] ? update_rq_clock+0x2b/0x50
[  366.312976]  [<ffffffff81058ea0>] ? xen_clocksource_read+0x20/0x30
[  366.312997]  [<ffffffff810edb8d>] pick_next_task_fair+0x1ed/0x430
[  366.313019]  [<ffffffff816ff0d3>] __schedule+0x113/0x870
[  366.313039]  [<ffffffff816ff9b4>] ? schedule+0x24/0x70
[  366.313059]  [<ffffffff816ff9b4>] schedule+0x24/0x70
[  366.313095]  [<ffffffff810dcd7c>] smpboot_thread_fn+0xbc/0x190
[  366.313112]  [<ffffffff810dccc0>] ? smpboot_create_threads+0x80/0x80
[  366.313135]  [<ffffffff810d565e>] kthread+0xce/0xf0
[  366.313155]  [<ffffffff810d5590>] ? kthread_freezable_should_stop+0x70/0x70
[  366.313174]  [<ffffffff8170c54c>] ret_from_fork+0x7c/0xb0
[  366.313190]  [<ffffffff810d5590>] ? kthread_freezable_should_stop+0x70/0x70
[  366.313204] Code: 0f 47 d1 eb 95 0f 1f 44 00 00 4d 89 ec 4d 89 f5 4c 8b b5 b
[  366.313372] RIP  [<ffffffff810ea5f9>] find_busiest_group+0x239/0x900
[  366.313391]  RSP <ffff88017c8f3ac8>
[  366.313406] ---[ end trace 42d3248df75182f3 ]---
[  366.313758] divide error: 0000 [#2] SMP
[  366.313776] Modules linked in: nfsv3 nfs_acl auth_rpcgss oid_registry nfsv4
d
[  366.313883] CPU: 14 PID: 63 Comm: ksoftirqd/14 Tainted: G      D      
3.15.2
[  366.313898] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS
GRNDSDP4
[  366.313922] task: ffff88017c8d2c10 ti: ffff88017c8f0000 task.ti:
ffff88017c80
[  366.313940] RIP: e030:[<ffffffff810ea5f9>]  [<ffffffff810ea5f9>]
find_busies0
[  366.313966] RSP: e02b:ffff88017c8f3468  EFLAGS: 00010046
[  366.313979] RAX: 0000000000000000 RBX: ffff88017c8f3568 RCX:
0000000000000000
[  366.313993] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[  366.314008] RBP: ffff88017c8f35d8 R08: ffff880003fb3d00 R09:
0000000000000040
[  366.314023] R10: 0000000000000000 R11: ffff880186148410 R12:
0000000000013e00
[  366.314042] R13: ffff88017c8f3658 R14: ffff880003fb3ce0 R15:
0000000000000000
[  366.314067] FS:  0000000000000000(0000) GS:ffff880181bc0000(0000)
knlGS:00000
[  366.314090] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  366.314103] CR2: 00007fad200d5000 CR3: 0000000001c14000 CR4:
0000000000042660
[  366.314119] Stack:
[  366.314125]  ffff8801fc8f35c9 ffff88017c8f34b8 0000000000002e7b
00000000812ce
[  366.314150]  ffff880003fb3ce0 0000000000013df8 0000000000000200
0000000000010
[  366.314175]  000000006c106009 ffff880003fb3cf8 0000000000000000
0000000000000
[  366.314196] Call Trace:
[  366.314215]  [<ffffffff810eae37>] load_balance+0x177/0x9d0
[  366.314232]  [<ffffffff810df56b>] ? update_rq_clock+0x2b/0x50
[  366.314252]  [<ffffffff81058ea0>] ? xen_clocksource_read+0x20/0x30
[  366.314269]  [<ffffffff810edb8d>] pick_next_task_fair+0x1ed/0x430
[  366.314288]  [<ffffffff816ff0d3>] __schedule+0x113/0x870
[  366.314307]  [<ffffffff810b3a34>] ? release_task+0x304/0x480
[  366.314324]  [<ffffffff816ff9b4>] schedule+0x24/0x70
[  366.314340]  [<ffffffff810b42ac>] do_exit+0x6fc/0xac0
[  366.314356]  [<ffffffff81705008>] oops_end+0xa8/0x170
[  366.314371]  [<ffffffff810663b6>] die+0x56/0x90
[  366.314385]  [<ffffffff81704a23>] do_trap+0xc3/0x170
[  366.314402]  [<ffffffff8170812d>] ? __atomic_notifier_call_chain+0xd/0x10
[  366.314422]  [<ffffffff8106395b>] do_divide_error+0x9b/0xb0
[  366.314439]  [<ffffffff810ea5f9>] ? find_busiest_group+0x239/0x900
[  366.314456]  [<ffffffff8170dc0e>] divide_error+0x1e/0x30
[  366.314473]  [<ffffffff810ea5f9>] ? find_busiest_group+0x239/0x900
[  366.314491]  [<ffffffff810ea513>] ? find_busiest_group+0x153/0x900
[  366.314511]  [<ffffffff810eae37>] load_balance+0x177/0x9d0
[  366.314526]  [<ffffffff810df56b>] ? update_rq_clock+0x2b/0x50
[  366.314547]  [<ffffffff81058ea0>] ? xen_clocksource_read+0x20/0x30
[  366.314563]  [<ffffffff810edb8d>] pick_next_task_fair+0x1ed/0x430
[  366.314581]  [<ffffffff816ff0d3>] __schedule+0x113/0x870
[  366.314597]  [<ffffffff816ff9b4>] ? schedule+0x24/0x70
[  366.314613]  [<ffffffff816ff9b4>] schedule+0x24/0x70
[  366.314628]  [<ffffffff810dcd7c>] smpboot_thread_fn+0xbc/0x190
[  366.314650]  [<ffffffff810dccc0>] ? smpboot_create_threads+0x80/0x80
[  366.314668]  [<ffffffff810d565e>] kthread+0xce/0xf0
[  366.314684]  [<ffffffff810d5590>] ? kthread_freezable_should_stop+0x70/0x70
[  366.314701]  [<ffffffff8170c54c>] ret_from_fork+0x7c/0xb0
[  366.314717]  [<ffffffff810d5590>] ? kthread_freezable_should_stop+0x70/0x70
[  366.314735] Code: 0f 47 d1 eb 95 0f 1f 44 00 00 4d 89 ec 4d 89 f5 4c 8b b5 b
[  366.314891] RIP  [<ffffffff810ea5f9>] find_busiest_group+0x239/0x900
[  366.314909]  RSP <ffff88017c8f3468>
[  366.314927] ---[ end trace 42d3248df75182f4 ]---
[  366.314932] BUG: unable to handle kernel NULL pointer dereference at
0000000c
[  366.314938] IP: [<ffffffff810e86e7>] select_task_rq_fair+0x337/0x8c0
[  366.314942] PGD 0
[  366.314943] Oops: 0000 [#3] SMP
[  366.314960] Modules linked in: nfsv3 nfs_acl auth_rpcgss oid_registry nfsv4
d
[  366.314962] CPU: 1 PID: 8225 Comm: udevd Tainted: G      D       3.15.6 #2
[  366.314965] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS
GRNDSDP4
[  366.314966] task: ffff8801771634e0 ti: ffff880002598000 task.ti:
ffff88000250
[  366.314972] RIP: e030:[<ffffffff810e86e7>]  [<ffffffff810e86e7>]
select_task0
[  366.314973] RSP: e02b:ffff88000259bd48  EFLAGS: 00010046
[  366.314974] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000019
[  366.314975] RDX: 0000000000000008 RSI: 0000000000000040 RDI:
0000000000000040
[  366.314979] RBP: ffff88000259be28 R08: ffff880003fb33f8 R09:
0000000000000000
[  366.314980] R10: 0000000000000000 R11: ffff88017cfe4338 R12:
0000000000000000
[  366.314981] R13: ffff880003fb33f8 R14: ffff880003fb33e0 R15:
0000000000000000
[  366.314988] FS:  00007fad200bb7a0(0000) GS:ffff880181a20000(0000)
knlGS:00000
[  366.314989] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  366.314990] CR2: 000000000000000c CR3: 00000000030f2000 CR4:
0000000000042660
[  366.314991] Stack:
[  366.314993]  ffff88017c7de000 00000000ffffff9c ffff88000259be38
ffffffff811d5
[  366.314995]  0000000000013e00 0000000000013e00 ffff8801771637d8
000000000000d
[  366.314997]  ffff880003fb3420 0000000000001ade 0000000000013e00
0000000000018
[  366.314998] Call Trace:
[  366.315003]  [<ffffffff811d6a45>] ? do_filp_open+0x45/0xa0
[  366.315005]  [<ffffffff810dedd7>] sched_exec+0x47/0xc0
[  366.315009]  [<ffffffff811ccaca>] ? do_open_exec+0xaa/0xe0
[  366.315014]  [<ffffffff811cccee>] do_execve_common+0x1be/0x640
[  366.315019]  [<ffffffff811b5b77>] ? kmem_cache_alloc+0x37/0x120
[  366.315021]  [<ffffffff811cd202>] do_execve+0x32/0x40
[  366.315026]  [<ffffffff811cd23a>] SyS_execve+0x2a/0x40
[  366.315029]  [<ffffffff8170cba9>] stub_execve+0x69/0xa0
[  366.315055] Code: 48 8b 55 c0 4d 8b 36 4c 3b 72 10 74 43 48 89 45 b0 e9 6e f
[  366.315058] RIP  [<ffffffff810e86e7>] select_task_rq_fair+0x337/0x8c0
[  366.315058]  RSP <ffff88000259bd48>
[  366.315059] CR2: 000000000000000c
[  366.315060] ---[ end trace 42d3248df75182f5 ]---
[  366.315418] Fixing recursive fault but reboot is needed!
[  366.315538] BUG: unable to handle kernel NULL pointer dereference at
0000000c
[  366.315580] IP: [<ffffffff810e86e7>] select_task_rq_fair+0x337/0x8c0
[  366.315609] PGD 0
[  366.315616] Oops: 0000 [#4] SMP
[  366.315620] Modules linked in: nfsv3 nfs_acl auth_rpcgss oid_registry nfsv4
d
[  366.315660] CPU: 0 PID: 8220 Comm: udevd Tainted: G      D       3.15.6 #2
[  366.315666] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS
GRNDSDP4
[  366.315673] task: ffff88017c680000 ti: ffff88007274c000 task.ti:
ffff88007270
[  366.315678] RIP: e030:[<ffffffff810e86e7>]  [<ffffffff810e86e7>]
select_task0
[  366.315687] RSP: e02b:ffff88007274fd48  EFLAGS: 00010046
[  366.315693] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
0000000000000019
[  366.315699] RDX: 0000000000000008 RSI: 0000000000000040 RDI:
0000000000000040
[  366.315704] RBP: ffff88007274fe28 R08: ffff880003fb33f8 R09:
0000000000000000
[  366.315710] R10: 0000000000000000 R11: ffff88017cfe4338 R12:
0000000000000000
[  366.315715] R13: ffff880003fb33f8 R14: ffff880003fb33e0 R15:
0000000000000000
[  366.315724] FS:  00007fad200bb7a0(0000) GS:ffff880181a00000(0000)
knlGS:00000
[  366.315730] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  366.315735] CR2: 000000000000000c CR3: 00000000725d7000 CR4:
0000000000042660
[  366.315740] Stack:
[  366.315743]  ffff88017c6e5000 00000000ffffff9c ffff88007274fe38
ffffffff811d5
[  366.315751]  0000000000013e00 0000000000013e00 ffff88017c6802f8
000000000000d
[  366.315759]  ffff880003fb3420 000000000000163e 0000000000013e00
0000000000018
[  366.315766] Call Trace:
[  366.315772]  [<ffffffff811d6a45>] ? do_filp_open+0x45/0xa0
[  366.315779]  [<ffffffff810dedd7>] sched_exec+0x47/0xc0
[  366.315787]  [<ffffffff811ccaca>] ? do_open_exec+0xaa/0xe0
[  366.315793]  [<ffffffff811cccee>] do_execve_common+0x1be/0x640
[  366.315801]  [<ffffffff811b5b77>] ? kmem_cache_alloc+0x37/0x120
[  366.315808]  [<ffffffff811cd202>] do_execve+0x32/0x40
[  366.315813]  [<ffffffff811cd23a>] SyS_execve+0x2a/0x40
[  366.315819]  [<ffffffff8170cba9>] stub_execve+0x69/0xa0
[  366.315824] Code: 48 8b 55 c0 4d 8b 36 4c 3b 72 10 74 43 48 89 45 b0 e9 6e f
[  366.315882] RIP  [<ffffffff810e86e7>] select_task_rq_fair+0x337/0x8c0
[  366.315890]  RSP <ffff88007274fd48>
[  366.315894] CR2: 000000000000000c
[  366.315899] ---[ end trace 42d3248df75182f6 ]---
[  366.317854] divide error: 0000 [#5] SMP
[  366.317869] Modules linked in: nfsv3 nfs_acl auth_rpcgss oid_registry nfsv4
d
[  366.317967] CPU: 14 PID: 6370 Comm: rsyslogd Tainted: G      D       3.15.6
2
[  366.317982] Hardware name: Intel Corporation S2600WTT/S2600WTT, BIOS
GRNDSDP4
[  366.318002] task: ffff880003098000 ti: ffff88017c04c000 task.ti:
ffff88017c00
[  366.318017] RIP: e030:[<ffffffff810ea5f9>]  [<ffffffff810ea5f9>]
find_busies0
[  366.318040] RSP: e02b:ffff88017c04fa78  EFLAGS: 00010046
[  366.318052] RAX: 0000000000000000 RBX: ffff88017c04fb78 RCX:
0000000000000000
[  366.318067] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
0000000000000000
[  366.318082] RBP: ffff88017c04fbe8 R08: ffff880003fb3d00 R09:
0000000000000040
[  366.318096] R10: 0000000000000000 R11: 0000000000000293 R12:
0000000000013e00
[  366.318111] R13: ffff88017c04fc68 R14: ffff880003fb3ce0 R15:
0000000000000000
[  366.318135] FS:  00007f348d764700(0000) GS:ffff880181bc0000(0000)
knlGS:00000
[  366.318151] CS:  e033 DS: 0000 ES: 0000 CR0: 0000000080050033
[  366.318164] CR2: 00007fad200d5000 CR3: 0000000003271000 CR4:
0000000000042660
[  366.318179] Stack:
[  366.318186]  0000000000000001 ffff88017c04fac8 0000000000002e7b
00000000ffffc
[  366.318212]  ffff880003fb3ce0 0000000000013df8 0000000000000200
0000000000010
[  366.318236]  0000000085f9a800 ffff880003fb3cf8 0000000000000000
0000000000000
[  366.318258] Call Trace:
[  366.318274]  [<ffffffff810eae37>] load_balance+0x177/0x9d0
[  366.318290]  [<ffffffff810df56b>] ? update_rq_clock+0x2b/0x50
[  366.318306]  [<ffffffff81058ea0>] ? xen_clocksource_read+0x20/0x30
[  366.318323]  [<ffffffff810edb8d>] pick_next_task_fair+0x1ed/0x430
[  366.318342]  [<ffffffff816ff0d3>] __schedule+0x113/0x870
[  366.318357]  [<ffffffff81703ace>] ? _raw_spin_unlock_irqrestore+0x2e/0xa0
[  366.318375]  [<ffffffff816ff9b4>] schedule+0x24/0x70
[  366.318391]  [<ffffffff810fbb1a>] do_syslog+0x4ba/0x640
[  366.318406]  [<ffffffff810f2d00>] ? bit_waitqueue+0xe0/0xe0
[  366.318424]  [<ffffffff81235ea2>] kmsg_read+0x32/0x70
[  366.318439]  [<ffffffff812294de>] proc_reg_read+0x3e/0x70
[  366.318454]  [<ffffffff811c7405>] vfs_read+0xa5/0x180
[  366.318469]  [<ffffffff811c75c1>] SyS_read+0x51/0xc0
[  366.318484]  [<ffffffff8170c5f9>] system_call_fastpath+0x16/0x1b
[  366.318496] Code: 0f 47 d1 eb 95 0f 1f 44 00 00 4d 89 ec 4d 89 f5 4c 8b b5 b
[  366.318699] RIP  [<ffffffff810ea5f9>] find_busiest_group+0x239/0x900
[  366.318718]  RSP <ffff88017c04fa78>
[  366.318728] ---[ end trace 42d3248df75182f7 ]---
--HlL+5n6rz5pIUxbD--
