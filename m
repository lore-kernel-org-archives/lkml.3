Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaEWOvQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:51:16 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:21877 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752638AbaEWOvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:51:15 -0400
Date: Fri, 23 May 2014 15:51:07 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Christopher Covington <cov@codeaurora.org>,
        Larry Bassel <larry.bassel@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>
Subject: Re: [PATCH v4 2/2] arm64: enable context tracking
Message-ID: <20140523145107.GO9252@arm.com>
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
 <1400786855-32656-3-git-send-email-larry.bassel@linaro.org>
 <537E5E1F.3050605@codeaurora.org>
 <7hd2f5icat.fsf@paris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hd2f5icat.fsf@paris.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 01:11:38AM +0100, Kevin Hilman wrote:
> Christopher Covington <cov@codeaurora.org> writes:
> > On 05/22/2014 03:27 PM, Larry Bassel wrote:
> >> Make calls to ct_user_enter when the kernel is exited
> >> and ct_user_exit when the kernel is entered (in el0_da,
> >> el0_ia, el0_svc, el0_irq and all of the "error" paths).
> >> 
> >> These macros expand to function calls which will only work
> >> properly if el0_sync and related code has been rearranged
> >> (in a previous patch of this series).
> >> 
> >> The calls to ct_user_exit are made after hw debugging has been
> >> enabled (enable_dbg_and_irq).
> >> 
> >> The call to ct_user_enter is made at the beginning of the
> >> kernel_exit macro.
> >> 
> >> This patch is based on earlier work by Kevin Hilman.
> >> Save/restore optimizations were also done by Kevin.
> >
> >> --- a/arch/arm64/kernel/entry.S
> >> +++ b/arch/arm64/kernel/entry.S
> >> @@ -30,6 +30,44 @@
> >>  #include <asm/unistd32.h>
> >>  
> >>  /*
> >> + * Context tracking subsystem.  Used to instrument transitions
> >> + * between user and kernel mode.
> >> + */
> >> +	.macro ct_user_exit, restore = 0
> >> +#ifdef CONFIG_CONTEXT_TRACKING
> >> +	bl	context_tracking_user_exit
> >> +	.if \restore == 1
> >> +	/*
> >> +	 * Save/restore needed during syscalls.  Restore syscall arguments from
> >> +	 * the values already saved on stack during kernel_entry.
> >> +	 */
> >> +	ldp	x0, x1, [sp]
> >> +	ldp	x2, x3, [sp, #S_X2]
> >> +	ldp	x4, x5, [sp, #S_X4]
> >> +	ldp	x6, x7, [sp, #S_X6]
> >> +	.endif
> >> +#endif
> >> +	.endm
> >> +
> >> +	.macro ct_user_enter, save = 0
> >> +#ifdef CONFIG_CONTEXT_TRACKING
> >> +	.if \save == 1
> >> +	/*
> >> +	 * Save/restore only needed on syscall fastpath, which uses
> >> +	 * x0-x2.
> >> +	 */
> >> +	push    x2, x3
> >
> > Why is x3 saved?
> 
> I'll respond here since I worked with Larry on the context save/restore
> part.
> 
> [insert rather embarassing disclamer of ignorance of arm64 assembly]
> 
> Based on my reading of the code, I figured only x0-x2 needed to be
> saved.  However, based on some experiments with intentionally clobbering
> the registers[1] (as suggested by Mark Rutland) in order to make sure
> we're saving/restoring the right things, I discovered x3 was needed too
> (I missed updating the comment to mention x0-x3.)
> 
> Maybe Will/Catalin/Mark R. can shed some light here?

I haven't checked all the code paths but at least for pushing onto the
stack we must keep it 16-bytes aligned (architecture requirement).

-- 
Catalin
