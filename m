Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaAPNrN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 08:47:13 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:46795 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaAPNrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 08:47:11 -0500
MIME-Version: 1.0
In-Reply-To: <20140116125727.GI30257@mudshark.cambridge.arm.com>
References: <1389869123-5884-1-git-send-email-jean.pihet@linaro.org>
	<20140116115634.GE30257@mudshark.cambridge.arm.com>
	<CAFrcx1=eAHsGZDsedGvvNai7Vrnf5p8RKLGFPS+cn5yGp7UQJw@mail.gmail.com>
	<20140116125727.GI30257@mudshark.cambridge.arm.com>
Date: Thu, 16 Jan 2014 14:47:10 +0100
Message-ID: <CAFrcx1npWFs3=rooqiGKSv-p7ivcG1J7SCvcmsz-hd3waXBfdA@mail.gmail.com>
Subject: Re: [PATCH] ARM64: perf: support dwarf unwinding in compat mode
From: Jean Pihet <jean.pihet@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnaldo <acme@ghostprotocols.net>,
        "patches@linaro.org" <patches@linaro.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will,

On 16 January 2014 13:57, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Jan 16, 2014 at 12:26:53PM +0000, Jean Pihet wrote:
>> On 16 January 2014 12:56, Will Deacon <will.deacon@arm.com> wrote:
>> > In your previous series, compat backtracing is actually split out into a
>> > separate function (compat_user_backtrace), so it would be more consistent to
>> > have a compat_user_stack_pointer macro, rather than add this check here.
The compat_user_backtrace function is used to unwind using the frame
pointer, it is not used to unwind using the dwarf info (which uses the
user stack pointer).

>>
>> Do you mean this change instead?
>
> I don't think so...
>
>> diff --git a/kernel/events/internal.h b/kernel/events/internal.h
>> index 569b2187..9b88d2e 100644
>> --- a/kernel/events/internal.h
>> +++ b/kernel/events/internal.h
>> @@ -185,7 +185,8 @@ static inline bool arch_perf_have_user_stack_dump(void)
>>         return true;
>>  }
>>
>> -#define perf_user_stack_pointer(regs) user_stack_pointer(regs)
>> +#define perf_user_stack_pointer(regs) \
>> +       (!compat_user_mode(regs)) ? ((regs)->sp) : ((regs)->compat_sp)
>
> This doesn't belong in core code; compat_user_mode and the fields of regs
> are arm64-specific.
Right.

> So I suppose you need to rework your original patch to
> call compat_user_stack_pointer (which we already define in compat.h for
> arm64) if compat_user_mode(regs)).
The perf core code calls perf_user_stack_pointer(regs) to retrieve the
stack pointer, with perf_user_stack_pointer(regs) defined as
user_stack_pointer(regs).
The problem is that perf is not aware of the compat mode, so every
arch has to implement user_stack_pointer(regs) correctly.

For this reason I think the first patch proposal is the right one
unless the perf core code is redesigned to handle different ABIs. Do
you see a better implementation?

>
> The problem there is the inconsistency with respect to the regs argument:
>
>   user_stack_pointer(regs)      // Returns user stack pointer for regs
>   current_user_stack_pointer()  // Returns current user stack pointer
>   compat_user_stack_pointer()   // Doesn't take a regs argument!
>
> On top of that, x86 treats those last two functions differently when current
> is a compat task.
>
> So the simplest thing would be to make compat_user_stack_pointer expand to
> user_stack_pointer(current_pt_regs()) on arm64 and merge that in with your
> original patch fixing user_stack_pointer.
>
> Will

Thx!
Jean
