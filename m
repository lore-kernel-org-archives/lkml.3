Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256AbaEXADl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:03:41 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:52013 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaEXADk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:03:40 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        Christopher Covington <cov@codeaurora.org>,
        Larry Bassel <larry.bassel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel\@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel\@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 2/2] arm64: enable context tracking
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
	<1400786855-32656-3-git-send-email-larry.bassel@linaro.org>
	<537E5E1F.3050605@codeaurora.org> <7hd2f5icat.fsf@paris.lan>
	<20140523145107.GO9252@arm.com> <20140523155544.GA24994@leverpostej>
Date: Fri, 23 May 2014 17:03:37 -0700
In-Reply-To: <20140523155544.GA24994@leverpostej> (Mark Rutland's message of
	"Fri, 23 May 2014 16:55:44 +0100")
Message-ID: <7hlhtscaau.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Rutland <mark.rutland@arm.com> writes:

> On Fri, May 23, 2014 at 03:51:07PM +0100, Catalin Marinas wrote:
>> On Fri, May 23, 2014 at 01:11:38AM +0100, Kevin Hilman wrote:
>> > Christopher Covington <cov@codeaurora.org> writes:
>> > > On 05/22/2014 03:27 PM, Larry Bassel wrote:
>> > >> Make calls to ct_user_enter when the kernel is exited
>> > >> and ct_user_exit when the kernel is entered (in el0_da,
>> > >> el0_ia, el0_svc, el0_irq and all of the "error" paths).
>> > >> 
>> > >> These macros expand to function calls which will only work
>> > >> properly if el0_sync and related code has been rearranged
>> > >> (in a previous patch of this series).
>> > >> 
>> > >> The calls to ct_user_exit are made after hw debugging has been
>> > >> enabled (enable_dbg_and_irq).
>> > >> 
>> > >> The call to ct_user_enter is made at the beginning of the
>> > >> kernel_exit macro.
>> > >> 
>> > >> This patch is based on earlier work by Kevin Hilman.
>> > >> Save/restore optimizations were also done by Kevin.
>> > >
>> > >> --- a/arch/arm64/kernel/entry.S
>> > >> +++ b/arch/arm64/kernel/entry.S
>> > >> @@ -30,6 +30,44 @@
>> > >>  #include <asm/unistd32.h>
>> > >>  
>> > >>  /*
>> > >> + * Context tracking subsystem.  Used to instrument transitions
>> > >> + * between user and kernel mode.
>> > >> + */
>> > >> +	.macro ct_user_exit, restore = 0
>> > >> +#ifdef CONFIG_CONTEXT_TRACKING
>> > >> +	bl	context_tracking_user_exit
>> > >> +	.if \restore == 1
>> > >> +	/*
>> > >> +	 * Save/restore needed during syscalls.  Restore syscall arguments from
>> > >> +	 * the values already saved on stack during kernel_entry.
>> > >> +	 */
>> > >> +	ldp	x0, x1, [sp]
>> > >> +	ldp	x2, x3, [sp, #S_X2]
>> > >> +	ldp	x4, x5, [sp, #S_X4]
>> > >> +	ldp	x6, x7, [sp, #S_X6]
>> > >> +	.endif
>> > >> +#endif
>> > >> +	.endm
>> > >> +
>> > >> +	.macro ct_user_enter, save = 0
>> > >> +#ifdef CONFIG_CONTEXT_TRACKING
>> > >> +	.if \save == 1
>> > >> +	/*
>> > >> +	 * Save/restore only needed on syscall fastpath, which uses
>> > >> +	 * x0-x2.
>> > >> +	 */
>> > >> +	push    x2, x3
>> > >
>> > > Why is x3 saved?
>> > 
>> > I'll respond here since I worked with Larry on the context save/restore
>> > part.
>> > 
>> > [insert rather embarassing disclamer of ignorance of arm64 assembly]
>> > 
>> > Based on my reading of the code, I figured only x0-x2 needed to be
>> > saved.  However, based on some experiments with intentionally clobbering
>> > the registers[1] (as suggested by Mark Rutland) in order to make sure
>> > we're saving/restoring the right things, I discovered x3 was needed too
>> > (I missed updating the comment to mention x0-x3.)
>> > 
>> > Maybe Will/Catalin/Mark R. can shed some light here?
>> 
>> I haven't checked all the code paths but at least for pushing onto the
>> stack we must keep it 16-bytes aligned (architecture requirement).
>
> Sure -- if modifying the stack we need to push/pop pairs of registers to
> keep it aligned. It might be better to use xzr as the dummy value in
> that case to make it clear that the value doesn't really matter.
>
> That said, ct_user_enter is only called in kernel_exit before we restore
> the values off the stack, and the only register I can spot that we need
> to preserve is x0 for the syscall return value. I can't see x1 or x2
> being used any more specially than the rest of the remaining registers.
> Am I missing something,

I don't think you're missing something.  I had thought my experiment in
clobbering registers uncovered that x1-x3 were also in use somewhere,
but in trying to reproduce that now, it's clear only x0 is important.

> or would it be sufficient to do the following?
> push	x0, xzr
> bl	context_tacking_user_enter
> pop	x0, xzr

Yes, this seems to work.

Following Will's suggestion of using a callee-saved register to save x0,
the updated version now looks like this:

	.macro ct_user_enter, save = 0
#ifdef CONFIG_CONTEXT_TRACKING
	.if \save == 1
	/*
	 * We only have to save/restore x0 on the fast syscall path where
	 * x0 contains the syscall return.
	 */
	mov	x19, x0
	.endif
	bl	context_tracking_user_enter
	.if \save == 1
	mov	x0, x19
	.endif
#endif
	.endm


We'll update this as well as address the comments on PATCH 1/2 and send
a v5.

Thanks guys for the review and guidance as I'm wandering a bit in the
dark here in arm64 assembler land.

Cheers,

Kevin
