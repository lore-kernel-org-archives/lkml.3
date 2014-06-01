Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755AbaFAXU0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 19:20:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752411AbaFAXUZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 19:20:25 -0400
Message-ID: <538BB511.1020709@redhat.com>
Date: Sun, 01 Jun 2014 19:19:45 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131028 Thunderbird/17.0.10
MIME-Version: 1.0
To: Oren Twaig <oren@scalemp.com>
CC: linux-kernel@vger.kernel.org, pbonzini@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Borislav Petkov <bp@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Dave Jones <davej@redhat.com>,
        Torsten Kaiser <just.for.lkml@googlemail.com>,
        Jan Beulich <JBeulich@suse.com>, Jan Kiszka <jan.kiszka@siemens.com>,
        Toshi Kani <toshi.kani@hp.com>, Andrew Jones <drjones@redhat.com>,
        "Shai (Shai@ScaleMP.com)" <Shai@scalemp.com>
Subject: Re: [PATCH 1/2] x86, Clean up smp_num_siblings calculation
References: <1401450185-23061-1-git-send-email-prarit@redhat.com> <1401450185-23061-2-git-send-email-prarit@redhat.com> <538AF11F.8060802@scalemp.com>
In-Reply-To: <538AF11F.8060802@scalemp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/01/2014 05:23 AM, Oren Twaig wrote:
> Hi Prarit,
> 
> See below,
> 
> On 05/30/2014 02:43 PM, Prarit Bhargava wrote:
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
>> >From my understanding of the other ares of kernel that use
>> smp_num_siblings, the value is supposed to be the the number of threads
>> per core.
>>
>> The value of smp_num_siblings is incorrect.  In theory, it should be 1 but it
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
>>                                         ...            (sets value)
>>                                         detect_ht()
>>                                         (also sets value)
>>
>> ie) it is set three times in some cases and is overwritten by the call
>> to detect_ht() from identify_cpu() in all cases.
>>
>> It should be noted that nothing in the identify_cpu() path or the cpu_up()
>> path requires smp_num_siblings to be set, prior to the final call to
>> detect_ht().
>>
>> For x86 boxes, smp_num_siblings is set to a value read in a CPUID call in
>> detect_ht(). This value is the *factory defined* value in all cases; even
>> if HT is disabled in BIOS the value still returns 2 if the CPU supports
>> HT.  AMD also reports the factory defined value in all cases.
> 
> The above is incorrect in case of X-TOPOLOGY mode. I such a case the information
> about number of siblings comes from the LEVEL_MAX_SIBLINGS() macro and the
> X86_FEATURE_XTOPOLOGY flag is set to skip detect_ht() work :
> void detect_ht(struct cpuinfo_x86 *c)
> ...
>     if (cpu_has(c, X86_FEATURE_XTOPOLOGY))
>             return;
> 
> In addition, the information about the number of sibling no longer comes from
> CPUID(0x1)->ebx but rather from the 0xb leaf of CPUID.
> 
> I've marked below the problematic code change.

I will do a [v2] of the patchset that omits this change

>> -    core_level_siblings = smp_num_siblings = LEVEL_MAX_SIBLINGS(ebx);
>> +    core_level_siblings = LEVEL_MAX_SIBLINGS(ebx);

and then removes the setting of smp_num_siblings in 2/2.

Thanks,

P.
