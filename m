Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbbALWsr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:48:47 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:48231 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbbALWsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:48:46 -0500
MIME-Version: 1.0
In-Reply-To: <54AD6B6A.4000701@linux.intel.com>
References: <cover.1419900414.git.luto@amacapital.net> <8207ea76edd142f4a118ad3093b28ec422d92e53.1419900414.git.luto@amacapital.net>
 <54AD6B6A.4000701@linux.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 12 Jan 2015 14:48:24 -0800
Message-ID: <CALCETrWazCZ6a4UKEUqzSUFDyyibhXkgiBQcXSdMci97RTtGuA@mail.gmail.com>
Subject: Re: [PATCH 3.19 1/3] x86, mpx: Check user mode bitness correctly when
 decoding instructions
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 9:22 AM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
> On 12/29/2014 04:52 PM, Andy Lutomirski wrote:
>> --- a/arch/x86/mm/mpx.c
>> +++ b/arch/x86/mm/mpx.c
>> @@ -217,7 +217,7 @@ static int mpx_insn_decode(struct insn *insn,
>>                          struct pt_regs *regs)
>>  {
>>       unsigned char buf[MAX_INSN_SIZE];
>> -     int x86_64 = !test_thread_flag(TIF_IA32);
>> +     int x86_64 = user_64bit_mode(regs);
>>       int not_copied;
>>       int nr_copied;
>
> There are (at least) 3 other uses of the instruction decoder that use
> some form of a check on TIF_IA32:
>
>> perf_event_intel_ds.c  intel_pmu_pebs_fixup_ip 785 insn_init(&insn, kaddr, size, is_64bit);
>> perf_event_intel_lbr.c branch_type             532 insn_init(&insn, addr, bytes_read, is64);
>> uprobes.c              uprobe_init_insn        222 insn_init(insn, auprobe->insn, sizeof(auprobe->insn), x86_64);
>
> Basically doing this:
>
>                 is_64bit = kernel_ip(to) || !test_thread_flag(TIF_IA32);
>
> So this method *must* work, at least in practice.
>
> If userspace has MPX on and switches between 32 and 64-bit itself, the
> kernel *and* the hardware will suddenly be trying to walk the bounds
> tables in the wrong format.  I just don't see an application surviving
> very long in that situation.
>
> So I don't have a problem with doing this, long term, as long as we do
> it for all of these locations and we do it in a consistent way.  For
> MPX, we may even want to enforce that:
>
>         !test_thread_flag(TIF_IA32) == user_64bit_mode(regs)
>
> and freak out if that fails.
>
> But I don't think it's 3.19 material.

Fair enough.  Will send for 3.20 instead.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
