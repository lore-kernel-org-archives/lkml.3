Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398AbaG1RXt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 13:23:49 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:31266 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbaG1RXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 13:23:45 -0400
Message-ID: <53D686F9.6000700@fb.com>
Date: Mon, 28 Jul 2014 13:23:05 -0400
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <x86@kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH] x86: don't check numa topology when setting up
 core siblings
References: <1406564919-19283-1-git-send-email-jbacik@fb.com> <20140728163909.GR19379@twins.programming.kicks-ass.net>
In-Reply-To: <20140728163909.GR19379@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-07-28_03:2014-07-28,2014-07-28,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 kscore.is_bulkscore=0
 kscore.compositescore=0 circleOfTrustscore=12.8739912268157
 compositescore=0.997700811770388 urlsuspect_oldscore=0.997700811770388
 suspectscore=0 recipient_domain_to_sender_totalscore=0 phishscore=0
 bulkscore=0 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.997700811770388 spamscore=0
 recipient_to_sender_domain_totalscore=46 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1407280204
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2014 12:39 PM, Peter Zijlstra wrote:
> On Mon, Jul 28, 2014 at 12:28:39PM -0400, Josef Bacik wrote:
>> We have these processors with this Cluster on die feature which shares numa
>> nodes between cores on different sockets.
>
> Uhm, what?! I know AMD has chips that have two nodes per package, but
> what you say doesn't make sense.
>
>> When booting up we were getting this
>> error with COD enabled (this is a 4 socket 12 core per CPU box)
>>
>>   smpboot: Booting Node   0, Processors  #1 #2 #3 #4 #5 OK
>>   ------------[ cut here ]------------
>>   WARNING: at arch/x86/kernel/smpboot.c:324 topology_sane.isra.2+0x6f/0x82()
>>   sched: CPU #6's mc-sibling CPU #0 is not on the same node! [node: 1 != 0]. Ignoring dependency.
>>   smpboot: Booting Node   1, Processors  #6
>>   Modules linked in:
>>   CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.10.39-31_fbk12_01013_ga2de9bf #1
>>   Hardware name: Quanta Leopard-DDR3/Leopard-DDR3, BIOS F06_3A03.08 05/24/2014
>>    ffffffff810971d4 ffff8802748d3e48 0000000000000009 ffff8802748d3df8
>>    ffffffff815bba59 ffff8802748d3e38 ffffffff8103b02b ffff8802748d3e28
>>    0000000000000001 000000000000b010 0000000000012580 0000000000000000
>>   Call Trace:
>>    [<ffffffff810971d4>] ? print_modules+0x54/0xa0
>>    [<ffffffff815bba59>] dump_stack+0x19/0x1b
>>    [<ffffffff8103b02b>] warn_slowpath_common+0x6b/0xa0
>>    [<ffffffff8103b101>] warn_slowpath_fmt+0x41/0x50
>>    [<ffffffff815ada56>] topology_sane.isra.2+0x6f/0x82
>>    [<ffffffff815ade23>] set_cpu_sibling_map+0x380/0x42c
>>    [<ffffffff815adfe7>] start_secondary+0x118/0x19a
>>   ---[ end trace 755dbfb52f761180 ]---
>>    #7 #8 #9 #10 #11 OK
>>
>> and then the /proc/cpuinfo would show "cores: 6" instead of "cores: 12" because
>> the sibling map doesn't get set right.
>
> Yeah, looks like your topology setup is wrecked alright.
>
>> This patch fixes this.
>
> No, as you say, this patch just makes the warning go away, you still
> have a royally fucked topology setup.

Fastest way to get usefull feedback is to send broken patches ;).

>
>> Now I realize
>> this is probably not the correct fix but I'm an FS guy and I don't understand
>> this stuff.
>
> :-)
>
>> Looking at the cpuflags with COD on and off there appears to be no
>> difference.  The only difference I can spot is with it on we have 4 numa nodes
>> and with it off we have 2, but that seems like a flakey check at best to add.
>> I'm open to suggestions on how to fix this properly.  Thanks,
>
> Got a link that explains this COD nonsense?
>
> Google gets me something about Intel SSSC, but nothing that explains
> your BIOS? knob.
>
> I suspect your BIOS is buggy and doesn't properly modify the CPUID
> topology data.
>


I'm asking for more info, I just got a box and was told 3.2 showed the correct
number of cores and 3.10 didn't, so you know exactly as much as I do :).  I can
tell you where in the BIOS I turn it on and off but I'm not sure how much help
that is, here is cpuinfo

processor       : 47
vendor_id       : GenuineIntel
cpu family      : 6
model           : 63
model name      : Intel(R) Xeon(R) CPU E5-2673 v3 @ 2.40GHz
stepping        : 2
microcode       : 0x1d
cpu MHz         : 2401.000
cache size      : 15360 KB
physical id     : 1
siblings        : 24
core id         : 13
cpu cores       : 12
apicid          : 59
initial apicid  : 59
fpu             : yes
fpu_exception   : yes
cpuid level     : 15
wp              : yes
flags           : fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush dts acpi mmx fxsr sse sse2 ss ht tm pbe syscall nx pdpe1gb rdtscp lm constant_tsc arch_perfmon pebs bts rep_good nopl xtopology nonstop_tsc aperfmperf eagerfpu pni pclmulqdq dtes64 monitor ds_cpl vmx smx est tm2 ssse3 fma cx16 xtpr pdcm pcid dca sse4_1 sse4_2 x2apic movbe popcnt tsc_deadline_timer aes xsave avx f16c rdrand lahf_lm abm ida arat epb xsaveopt pln pts dtherm tpr_shadow vnmi flexpriority ept vpid fsgsbase tsc_adjust bmi1 hle avx2 smep bmi2 erms invpcid rtm
bogomips        : 4795.40
clflush size    : 64
cache_alignment : 64
address sizes   : 46 bits physical, 48 bits virtual
power management:

This is with my patch applied btw so the cores count comes out correctly.  The
BIOS knob is under QPI Configuration, not sure if that helps any, it sure as
shit means nothing to me.

There is also some weirdness with the NUMA init stuff with this feature enabled.
The slit table (whatever the hell that is) has a locality count of 8, even
though there are only 4 nodes, so when it sets up the distances between nodes it
spits out another warning.  I guess that points to the BIOS being a steaming
pile.  Here is the relevant part of the logs

  SRAT: Node 0 PXM 0 [mem 0x00000000-0x7fffffff]
  SRAT: Node 0 PXM 0 [mem 0x100000000-0x27fffffff]
  SRAT: Node 1 PXM 1 [mem 0x280000000-0x47fffffff]
  SRAT: Node 2 PXM 2 [mem 0x480000000-0x67fffffff]
  SRAT: Node 3 PXM 3 [mem 0x680000000-0x87fffffff]
  NUMA: Initialized distance table, cnt=4
  NUMA: Warning: node ids are out of bound, from=0 to=-1 distance=31
  NUMA: Node 0 [mem 0x00000000-0x7fffffff] + [mem 0x100000000-0x27fffffff] -> [mem 0x00000000-0x27fffffff]
  Initmem setup node 0 [mem 0x00000000-0x27fffffff]
    NODE_DATA [mem 0x27fffb000-0x27fffffff]
  Initmem setup node 1 [mem 0x280000000-0x47fffffff]
    NODE_DATA [mem 0x47fffb000-0x47fffffff]
  Initmem setup node 2 [mem 0x480000000-0x67fffffff]
    NODE_DATA [mem 0x67fffb000-0x67fffffff]
  Initmem setup node 3 [mem 0x680000000-0x87fffffff]
    NODE_DATA [mem 0x87fff8000-0x87fffcfff]
   [ffffea0000000000-ffffea0009ffffff] PMD -> [ffff880277e00000-ffff88027fdfffff] on node 0
   [ffffea000a000000-ffffea0011ffffff] PMD -> [ffff880477e00000-ffff88047fdfffff] on node 1
   [ffffea0012000000-ffffea0019ffffff] PMD -> [ffff880677e00000-ffff88067fdfffff] on node 2
   [ffffea001a000000-ffffea0021ffffff] PMD -> [ffff880877600000-ffff88087f5fffff] on node 3

So I guess in summary thank you for not flying here to kick my ass personally, I
will try and get more info from the box owner/intel, and maybe come back with a
real patch once we get to the bottom of the problem.  Thanks,

Josef
