Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751884AbaFBRVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:21:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaFBRVj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:21:39 -0400
Message-ID: <538CB249.4030008@redhat.com>
Date: Mon, 02 Jun 2014 13:20:09 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: linux-kernel@vger.kernel.org, Oren Twaig <oren@scalemp.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jan Beulich <JBeulich@suse.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH] x86, Clean up smp_num_siblings calculation
References: <1401709892-9586-1-git-send-email-prarit@redhat.com> <538CA69F.1020305@windriver.com>
In-Reply-To: <538CA69F.1020305@windriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/02/2014 12:30 PM, Paul Gortmaker wrote:
> On 14-06-02 07:51 AM, Prarit Bhargava wrote:
>> I have a system on which I have disabled threading in the BIOS, and I am booting
>> the kernel with the option "idle=poll".
>>
>> The kernel displays
>>
>> process: WARNING: polling idle and HT enabled, performance may degrade
>>
>> which is incorrect -- I've already disabled HT.
>>
>> This warning is issued here:
>>
>> void select_idle_routine(const struct cpuinfo_x86 *c)
>> {
>>         if (boot_option_idle_override == IDLE_POLL && smp_num_siblings > 1)
>>                 pr_warn_once("WARNING: polling idle and HT enabled, performance may degrade\n");
>>
>> From my understanding of the other areas of kernel that use smp_num_siblings,
>> the value is supposed to be the actual number of threads per core, and
>> this value of smp_num_siblings is incorrect.  In theory, it should be 1 but it
>> is reported as 2.  When I looked into how smp_num_siblings is calculated I
>> found the following call sequence in the kernel:
>>
>> start_kernel ->
>>         check_bugs ->
>>                 identify_boot_cpu ->
>>                                 identify_cpu ->
>>                                         c_init = init_intel
>>                                                 init_intel ->
>>                                                         detect_extended_topology
>>                                                         (sets value)
>>
>>                                         OR
>>
>>                                         c_init = init_amd
>>                                                 init_amd -> amd_detect_cmp
>>                                                              -> amd_get_topology
>>                                                                 (sets value)
>>                                                          -> detect_ht()
>>                                         ...		    (sets value)
>>                                         detect_ht()
>>                                         (also sets value)
>>
>> ie) it is set three times in some cases and overwritten in other cases.
>>
>> It should be noted that nothing in the identify_cpu() path or the cpu_up()
>> path requires smp_num_siblings to be set, prior to the final call to
>> detect_ht().
>>
>> For x86 boxes without X86_FEATURE_XTOPOLOGY, smp_num_siblings is set to a
>> value read in a CPUID call in detect_ht().  This value is the *factory
>> defined* value in all cases; even if HT is disabled in BIOS the value
>> still returns 2 if the CPU supports HT.  AMD also reports the factory
>> defined value in all cases.
>>
>> For Intel x86 boxes with X86_FEATURE_XTOPOLOGY, smp_num_siblings is set to a
>> value read from the 0xb leaf of CPUID.  This value is also the *factory
>> defined* value in all cases.
>>
>> For new-ish AMD x86 boxes, smp_num_siblings is also set to the *factory*
>> defined value.
>>
>> That is, even with threading disabled in BIOSes on these systems,
>>
>> crash> p smp_num_siblings
>> smp_num_siblings = $1 = 0x2
>>
>> smp_num_siblings should be calculated a single time on cpu 0 to determine
>> whether or not the system is multi-threaded or not.  We can easily do
>> this by examining the boot cpu's cpu_sibling_mask after the mask has been
>> setup in the boot up code path.
>>
>> After the patch, on a system with HT enabled,
>>
>> crash> p smp_num_siblings
>> smp_num_siblings = $1 = 0x2
>>
>> On a system with HT disabled,
>>
>> crash> p smp_num_siblings
>> smp_num_siblings = $1 = 0x1
>>
>> Other uses of smp_num_siblings involve oprofile (used after boot), and
>> the perf code which is done well after the initial cpus are brought online.
>>
>> [v2]: After comment from Oren Twaig, rework to single patch.
>> Unfortunately there was no easy way to take into account the various
>> settings of smp_num_siblings and fix it in two patches.
>>
>> Cc: Oren Twaig <oren@scalemp.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: Borislav Petkov <bp@suse.de>
>> Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Andi Kleen <ak@linux.intel.com>
>> Cc: Dave Jones <davej@redhat.com>
>> Cc: Torsten Kaiser <just.for.lkml@googlemail.com>
>> Cc: Jan Beulich <JBeulich@suse.com>
>> Cc: Jan Kiszka <jan.kiszka@siemens.com>
>> Cc: Toshi Kani <toshi.kani@hp.com>
>> Cc: Andrew Jones <drjones@redhat.com>
>> ---
>>  arch/x86/kernel/cpu/amd.c      |    1 -
>>  arch/x86/kernel/cpu/common.c   |   23 +++++++++++------------
>>  arch/x86/kernel/cpu/topology.c |    2 +-
>>  arch/x86/kernel/smpboot.c      |   10 +++++++---
>>  4 files changed, 19 insertions(+), 17 deletions(-)
>>
>> diff --git a/arch/x86/kernel/cpu/amd.c b/arch/x86/kernel/cpu/amd.c
>> index ce8b8ff..6aca2b6 100644
>> --- a/arch/x86/kernel/cpu/amd.c
>> +++ b/arch/x86/kernel/cpu/amd.c
>> @@ -304,7 +304,6 @@ static void amd_get_topology(struct cpuinfo_x86 *c)
>>  		node_id = ecx & 7;
>>  
>>  		/* get compute unit information */
>> -		smp_num_siblings = ((ebx >> 8) & 3) + 1;
>>  		c->compute_unit_id = ebx & 0xff;
>>  		cores_per_cu += ((ebx >> 8) & 3);
>>  	} else if (cpu_has(c, X86_FEATURE_NODEID_MSR)) {
>> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
>> index a135239..81a5aac 100644
>> --- a/arch/x86/kernel/cpu/common.c
>> +++ b/arch/x86/kernel/cpu/common.c
>> @@ -507,42 +507,41 @@ void detect_ht(struct cpuinfo_x86 *c)
>>  	u32 eax, ebx, ecx, edx;
>>  	int index_msb, core_bits;
>>  	static bool printed;
>> +	int threads_per_core;
>>  
>>  	if (!cpu_has(c, X86_FEATURE_HT))
>>  		return;
>>  
>> -	if (cpu_has(c, X86_FEATURE_CMP_LEGACY))
>> +	if (cpu_has(c, X86_FEATURE_CMP_LEGACY)) {
>> +		threads_per_core = 1;
>>  		goto out;
>> +	}
>>  
>>  	if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
>>  		return;
>>  
>>  	cpuid(1, &eax, &ebx, &ecx, &edx);
>>  
>> -	smp_num_siblings = (ebx & 0xff0000) >> 16;
>> +	threads_per_core = (ebx & 0xff0000) >> 16;
> 
> I wonder if this code is in need of an update?  I recall reading
> this thread:
> 
> http://forum.osdev.org/viewtopic.php?f=1&t=23445
> 
> which suggests that we try CPUID with 0xb, and then 0x4 _before_
> relying on the EBX[23:16] of the older CPUID 0x1.
> 
> AFAICT, the 0xb and 0x4 didn't exist when AP-485 was written ~2002.

I think the first case (0xb leaf) is done when cpu_has(c, X86_FEATURE_XTOPOLOGY)
is true.  I don't think we've been doing the latter though and it could be
something introduced in a new patch?

> 
> http://datasheets.chipdb.org/Intel/x86/CPUID/24161821.pdf
> 
> Also, there was a discussion of masking the "ht" flag in /proc/cpuinfo
> for when it is "off" -- since the common sense interpretation of it
> doesn't match the implementation in the specification:
> 
> http://codemonkey.org.uk/2009/11/10/common-hyperthreading-misconception/
> https://lkml.org/lkml/2009/11/13/33

Yeah -- I was actually debating about masking it off when smp_num_siblings == 1,
but wasn't sure how we felt about that these days.  The problem with mucking
around with /proc/cpuinfo is that we're never clear if the values are the values
read from the hardware, or the interpreted software values.

I can certainly retest the ht flag masking if one of the x86@kernel.org people
give me an ack to do so.

hpa?  tglx?  Ingo?

P.
