Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbaJAP0z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 11:26:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41068 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429AbaJAP0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 11:26:53 -0400
Message-ID: <542C1D2E.9050005@zytor.com>
Date: Wed, 01 Oct 2014 08:26:38 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Thomas Gleixner <tglx@linutronix.de>, X86 ML <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
CC: Sebastian Lackner <sebastian@fds-team.de>, Anish Bhatt <anish@chelsio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Chuck Ebbert <cebbert.lkml@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86_64,entry: Filter RFLAGS.NT on entry from userspace
References: <cover.1412138935.git.luto@amacapital.net> <0e906bdeba3660c9766248d3d7229e78a423ca5b.1412138935.git.luto@amacapital.net> <542C1C28.9050408@zytor.com>
In-Reply-To: <542C1C28.9050408@zytor.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2014 08:22 AM, H. Peter Anvin wrote:
> On 09/30/2014 09:51 PM, Andy Lutomirski wrote:
>>
>> diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
>> index 4299eb05023c..44d1dd371454 100644
>> --- a/arch/x86/ia32/ia32entry.S
>> +++ b/arch/x86/ia32/ia32entry.S
>> @@ -151,6 +151,18 @@ ENTRY(ia32_sysenter_target)
>>  1:	movl	(%rbp),%ebp
>>  	_ASM_EXTABLE(1b,ia32_badarg)
>>  	ASM_CLAC
>> +
>> +	/*
>> +	 * Sysenter doesn't filter flags, so we need to clear NT
>> +	 * ourselves.  To save a few cycles, we can check whether
>> +	 * NT was set instead of doing an unconditional popfq.
>> +	 */
>> +	testl $X86_EFLAGS_NT,EFLAGS(%rsp)	/* saved EFLAGS match cpu */
>> +	jz 1f
>> +	pushq_cfi $(X86_EFLAGS_IF|X86_EFLAGS_FIXED)
>> +	popfq_cfi
>> +1:
>> +
> 
> I'm wondering if it would be easier to just remove ASM_CLAC and do this
> unconditionally.  On SMAP-enabled hardware then that gives us back some
> of the cycles, may make the branch unnecessary.
> 

Heck, we can drop the CLD and the STI as well (with some tweaking in
ia32_badarg.)

	-hpa


