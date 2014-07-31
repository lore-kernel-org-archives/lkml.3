Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632AbaGaL5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 07:57:18 -0400
Received: from service87.mimecast.com ([91.220.42.44]:50414 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbaGaL5N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 07:57:13 -0400
Message-ID: <53DA2F15.1070605@arm.com>
Date: Thu, 31 Jul 2014 12:57:09 +0100
From: Dietmar Eggemann <dietmar.eggemann@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        "peterz@infrdead.org" <peterz@infrdead.org>,
        "bruno@wolff.to" <bruno@wolff.to>,
        "jwboyer@redhat.com" <jwboyer@redhat.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: scheduler crash on Power
References: <20140730072242.GA21516@us.ibm.com>
In-Reply-To: <20140730072242.GA21516@us.ibm.com>
X-OriginalArrivalTime: 31 Jul 2014 11:57:08.0736 (UTC) FILETIME=[8E3C1000:01CFACB6]
X-MC-Unique: 114073112571003101
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sukadev,

On 30/07/14 08:22, Sukadev Bhattiprolu wrote:
> 
> I am getting this crash on a Powerpc system using 3.16.0-rc7 kernel plus
> some patches related to perf (24x7 counters) that Cody Schafer posted here:
> 
> 	https://lkml.org/lkml/2014/5/27/768
> 
> I don't get the crash on an unpatched kernel though.
> 
> I have been staring at the perf event patches, but can't find anything
> impacting the scheduler. Besides the patches had worked on 3.16.0-rc2
> kernel on a different Power system.
> 
> The crash occurs on an idle system, a minute or two after booting to
> runlevel 3.
> 
> kernel/sched/core.c:
> 
> ---
> 5877 static void init_sched_groups_capacity(int cpu, struct sched_domain *sd)
> 5878 {
> 5879         struct sched_group *sg = sd->groups;
> 5880 
> 5881         WARN_ON(!sg);
> 5882 
> 5883         do {
> 5884                 sg->group_weight = cpumask_weight(sched_group_cpus(sg));
> 
> ---
> 
> 
> I tried applying the patch discussed in https://lkml.org/lkml/2014/7/16/386
> but doesn't seem to help.
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index bc1638b..50702a8 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5842,6 +5842,8 @@ build_sched_groups(struct sched_domain *sd, int cpu)
>                         continue;
>  
>                 group = get_group(i, sdd, &sg);
> +               cpumask_clear(sched_group_cpus(sg));
> +               sg->sgc->capacity = 0;
>                 cpumask_setall(sched_group_mask(sg));
>  
>                 for_each_cpu(j, span) {

I don't think your problem is related to this one. None of the
'build_sched_groups: got group x with cpus:' show that a sched_group got
reused.

> 
> 
> I am also attaching the debug messages that Peterz added
> here: https://lkml.org/lkml/2014/7/17/288
> 
> Appreciate any debug suggestions.
> 
> Sukadev
> 
> 
> ----
> Red Hat Enterprise Linux Server 7.0 (Maipo)
> Kernel 3.16.0-rc7-24x7+ on an ppc64
> 
> ltcbrazos2-lp07 login: 
> 
> Red Hat Enterprise Linux Server 7.0 (Maipo)
> Kernel 3.16.0-rc7-24x7+ on an ppc64
> 
> ltcbrazos2-lp07 login: [  181.915974] ------------[ cut here ]------------
> [  181.915991] WARNING: at ../kernel/sched/core.c:5881

This warning indicates the problem. One of the struct sched_domains does
not have it's groups member set.

And its happening during a rebuild of the sched domain hierarchy, not
during the initial build.

You could run your system with the following patch-let (on top of
https://lkml.org/lkml/2014/7/17/288)  w/ and w/o the perf related
patches (w/ CONFIG_SCHED_DEBUG enabled).

@@ -5882,6 +5882,9 @@ static void init_sched_groups_capacity(int cpu,
struct sched_domain *sd)
 {
        struct sched_group *sg = sd->groups;

+#ifdef CONFIG_SCHED_DEBUG
+       printk("sd name: %s span: %pc\n", sd->name, sd->span);
+#endif
        WARN_ON(!sg);

        do {

This will show if the rebuild of the sched domain hierarchy happens on
both systems and hopefully indicate for which sched_domain the
sd->groups is not set.

> [  181.915994] Modules linked in: sg cfg80211 rfkill nx_crypto ibmveth pseries_rng xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
> [  181.916024] CPU: 4 PID: 1087 Comm: kworker/4:2 Not tainted 3.16.0-rc7-24x7+ #15
> [  181.916034] Workqueue: events .topology_work_fn
> [  181.916038] task: c0000000dbd40000 ti: c0000000da400000 task.ti: c0000000da400000
> [  181.916043] NIP: c0000000000d7528 LR: c0000000000d7578 CTR: 0000000000000000
> [  181.916047] REGS: c0000000da403580 TRAP: 0700   Not tainted  (3.16.0-rc7-24x7+)
> [  181.916051] MSR: 8000000100029032 <SF,EE,ME,IR,DR,RI>  CR: 28484c24  XER: 00000000
> [  181.916063] CFAR: c0000000000d74f4 SOFTE: 1 
> GPR00: c0000000000d7578 c0000000da403800 c000000000eaa7f0 0000000000000800 
> GPR04: 0000000000000800 0000000000000800 0000000000000000 c0000000009cf878 
> GPR08: c0000000009cf880 0000000000000001 0000000000000010 0000000000000000 
> GPR12: 0000000000000000 c00000000ebe1200 0000000000000800 c0000000cc2f0000 
> GPR16: c000000000ef0a68 0000000000000078 c0000000e5000000 0000000000000078 
> GPR20: 0000000000000000 0000000000000001 c0000000cc2f0000 0000000000000001 
> GPR24: c000000000db4402 000000000000000f 0000000000000000 c0000000dea39300 
> GPR28: c000000000ef0ae0 c0000000e5440000 0000000000000000 c000000000ef4f7c 
> [  181.916146] NIP [c0000000000d7528] .build_sched_domains+0xc28/0xd90
> [  181.916151] LR [c0000000000d7578] .build_sched_domains+0xc78/0xd90
> [  181.916155] Call Trace:
> [  181.916159] [c0000000da403800] [c0000000000d7578] .build_sched_domains+0xc78/0xd90 (unreliable)
> [  181.916166] [c0000000da403950] [c0000000000d7950] .partition_sched_domains+0x260/0x3f0
> [  181.916175] [c0000000da403a30] [c000000000141704] .rebuild_sched_domains_locked+0x54/0x70
> [  181.916182] [c0000000da403ab0] [c000000000143a98] .rebuild_sched_domains+0x28/0x50
> [  181.916188] [c0000000da403b30] [c00000000004f250] .topology_work_fn+0x10/0x30
> [  181.916194] [c0000000da403ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
> [  181.916199] [c0000000da403c40] [c0000000000b7970] .worker_thread+0x180/0x630
> [  181.916205] [c0000000da403d30] [c0000000000bfc88] .kthread+0x108/0x130
> [  181.916214] [c0000000da403e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
> [  181.916220] Instruction dump:
> [  181.916223] 7f47492a e93c0000 e90a0010 7d0a4378 7d4a482a 814a0000 2f8a0000 419e0008 
> [  181.916235] 7f48492a ebdd0010 7fc90074 7929d182 <0b090000> 48000014 60000000 60000000 
> [  181.916245] ---[ end trace 6e9d20016598c36c ]---
> [  181.916253] Unable to handle kernel paging request for data at address 0x00000018
> [  181.916257] Faulting instruction address: 0xc00000000039d1c0
> [  181.916263] Oops: Kernel access of bad area, sig: 11 [#1]
> [  181.916267] SMP NR_CPUS=2048 NUMA pSeries
> [  181.916271] Modules linked in: sg cfg80211 rfkill nx_crypto ibmveth pseries_rng xfs libcrc32c sd_mod crc_t10dif crct10dif_common ibmvscsi scsi_transport_srp scsi_tgt dm_mirror dm_region_hash dm_log dm_mod
> [  181.916293] CPU: 4 PID: 1087 Comm: kworker/4:2 Tainted: G        W     3.16.0-rc7-24x7+ #15
> [  181.916299] Workqueue: events .topology_work_fn
> [  181.916303] task: c0000000dbd40000 ti: c0000000da400000 task.ti: c0000000da400000
> [  181.916309] NIP: c00000000039d1c0 LR: c0000000000d754c CTR: 0000000000000000
> [  181.916313] REGS: c0000000da4034d0 TRAP: 0300   Tainted: G        W      (3.16.0-rc7-24x7+)
> [  181.916317] MSR: 8000000100009032 <SF,EE,ME,IR,DR,RI>  CR: 28484c24  XER: 00000000
> [  181.916327] CFAR: c000000000009358 DAR: 0000000000000018 DSISR: 40000000 SOFTE: 1 
> GPR00: c0000000000d754c c0000000da403750 c000000000eaa7f0 0000000000000018 
> GPR04: 0000000000000800 0000000000000800 0000000000000000 c0000000009cf878 
> GPR08: c0000000009cf880 0000000000000001 0000000000000010 0000000000000000 
> GPR12: 0000000000000000 c00000000ebe1200 0000000000000800 c0000000cc2f0000 
> GPR16: c000000000ef0a68 0000000000000078 c0000000e5000000 0000000000000078 
> GPR20: 0000000000000000 0000000000000001 c0000000cc2f0000 0000000000000001 
> GPR24: c000000000db4402 0000000000000020 0000000000000018 0000000000000800 
> GPR28: 0000000000000020 0000000000000110 0000000000000000 0000000000000010 
> [  181.916406] NIP [c00000000039d1c0] .__bitmap_weight+0x70/0x100
> [  181.916411] LR [c0000000000d754c] .build_sched_domains+0xc4c/0xd90
> [  181.916415] Call Trace:
> [  181.916418] [c0000000da403750] [c0000000da403800] 0xc0000000da403800 (unreliable)
> [  181.916424] [c0000000da403800] [c0000000000d754c] .build_sched_domains+0xc4c/0xd90
> [  181.916430] [c0000000da403950] [c0000000000d7950] .partition_sched_domains+0x260/0x3f0
> [  181.916436] [c0000000da403a30] [c000000000141704] .rebuild_sched_domains_locked+0x54/0x70
> [  181.916442] [c0000000da403ab0] [c000000000143a98] .rebuild_sched_domains+0x28/0x50
> [  181.916448] [c0000000da403b30] [c00000000004f250] .topology_work_fn+0x10/0x30
> [  181.916453] [c0000000da403ba0] [c0000000000b7100] .process_one_work+0x1a0/0x4c0
> [  181.916458] [c0000000da403c40] [c0000000000b7970] .worker_thread+0x180/0x630
> [  181.916463] [c0000000da403d30] [c0000000000bfc88] .kthread+0x108/0x130
> [  181.916468] [c0000000da403e30] [c00000000000a3e4] .ret_from_kernel_thread+0x58/0x74
> [  181.916472] Instruction dump:
> [  181.916475] 409d00b4 3bbcffff 3be3fff8 7bbd1f48 3bc00000 7fa3ea14 48000018 60000000 
> [  181.916484] 60000000 60000000 60000000 60420000 <e87f0009> 4bcb74e9 60000000 7fbfe840 
> [  181.916493] ---[ end trace 6e9d20016598c36d ]---
> [  181.924408] 
> [  183.931081] Kernel panic - not syncing: Fatal exception
> [  183.954314] Rebooting in 10 seconds..
> 


