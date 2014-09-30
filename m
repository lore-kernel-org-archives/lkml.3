Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaI3VCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:02:48 -0400
Received: from outbound-smtp02.blacknight.com ([81.17.249.8]:33642 "EHLO
	outbound-smtp02.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbaI3VCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:02:46 -0400
Message-ID: <542B1A74.9000909@nexus-software.ie>
Date: Tue, 30 Sep 2014 22:02:44 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Reply-To: pure.logic@nexus-software.ie
Organization: Nexus Software
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: mingo@redhat.com, davej@redhat.com, hpa@zytor.com, hmh@hmh.eng.br,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: Bugfix bit-rot in the calling of legacy_cache_size
References: <1412046710-2686-1-git-send-email-pure.logic@nexus-software.ie> <1412046710-2686-2-git-send-email-pure.logic@nexus-software.ie> <alpine.DEB.2.11.1409302211560.4455@nanos>
In-Reply-To: <alpine.DEB.2.11.1409302211560.4455@nanos>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/14 21:28, Thomas Gleixner wrote:
> On Tue, 30 Sep 2014, Bryan O'Donoghue wrote:
>>   static void default_init(struct cpuinfo_x86 *c)
>>   {
>> -#ifdef CONFIG_X86_64
>>   	cpu_detect_cache_sizes(c);
>> -#else
>> +
>>   	/* Not much we can do here... */
>>   	/* Check if at least it has cpuid */
>>   	if (c->cpuid_level == -1) {
>> @@ -79,7 +78,6 @@ static void default_init(struct cpuinfo_x86 *c)
>>   		else if (c->x86 == 3)
>>   			strcpy(c->x86_model_id, "386");
>>   	}
>> -#endif
>
> What's the exact point of this? This is the default init function
> which is for X86_VENDOR_UNKNOWN, right?

Correct

>>   }
>>
>>   static const struct cpu_dev default_cpu = {
>> @@ -874,6 +872,15 @@ static void identify_cpu(struct cpuinfo_x86 *c)
>>   #endif
>>
>>   	/*
>> +	 * If c_x86_vendor != X86_VENDOR_UNKNOWN i.e. a known vendor then
>> +	 * there's a vendor specific c_init()
>> +	 *
>> +	 * Even still Intel, AMD and VIA make use of legacy_cache_size which
>> +	 * is reachable only through default_init right now
>
> That's nonsense. It's called from cpu_detect_cache_sizes() and that is
> called from:
>
> arch/x86/kernel/cpu/amd.c:      cpu_detect_cache_sizes(c);
> arch/x86/kernel/cpu/centaur.c:  cpu_detect_cache_sizes(c);
> arch/x86/kernel/cpu/common.c:   cpu_detect_cache_sizes(c);
> arch/x86/kernel/cpu/cyrix.c:            cpu_detect_cache_sizes(c);
> arch/x86/kernel/cpu/transmeta.c:        cpu_detect_cache_sizes(c);

/uses grep

Yes I see for everybody except Intel that'll get called. I mised that.

> So we have 4 callsites outside of default_init() already. Now you're
> adding another one into identify_cpu()
>
>> +	 */
>> +	if (this_cpu->c_x86_vendor != X86_VENDOR_UNKNOWN)
>> +		default_init(c);
>
> With the consequence that for amd/centaur/cyrix/transmeta
> cpu_detect_cache_sizes() is invoked twice for nothing.

Yes - I see what's needed here is for cpu_detect_cache_sizes to get 
called for Intel only - so the bit rot is really only limited to

1. PIII Tualatin
2. New Intel additions on this path like Quark


> So the only CPU vendor c_init() callback which does not call
> cpu_detect_cache_sizes() is the Intel one. And therefor we inflict
> that call on all others twice. Brilliant solution!

Haha. When you put it like that you make it sound mad and unreasonable.

> So the proper solution is to add the call to identify_cpu()
> unconditionally and remove it from _all_ other call sites, make it
> static and be done with it.

Agree I'll make that update.

Thanks for your review.

--
BOD
