Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002Ab3HHQyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 12:54:36 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43783 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757864Ab3HHQye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 12:54:34 -0400
Date: Thu, 8 Aug 2013 18:54:30 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
Message-ID: <20130808165427.GC32049@somewhere>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
 <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
 <20130806154314.GA398@redhat.com>
 <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com>
 <CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com>
 <20130807192734.GA8395@redhat.com>
 <CA+55aFw7P7LYNFQzy6nrn9DDn5a0UdYYQNx_7sibShvZPLEcmg@mail.gmail.com>
 <20130808154107.GA28971@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130808154107.GA28971@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 08, 2013 at 05:41:07PM +0200, Oleg Nesterov wrote:
> On 08/07, Linus Torvalds wrote:
> >
> > Now, I do agree that the debug registers are *much* less likely to
> > have those kinds of really subtle issues, so maybe relaxing some of
> > the tests might be reasonable. I'd be a bit nervous about it, but if
> > it's *only* the length/alignment, and Intel people can be convinced
> > that it doesn't result in any nasty undefined behavior (as long as the
> > address is in user space), maybe we could make that change just to
> > make it easier for Wine.
> 
> Oh, I do not know. And again, this way a user can't notice the problem
> if the arguments are wrong.
> 
> But personally I think it would be nice to cleanup the perf interface,
> although probably it is too later.
> 
> On x86 execute breakpoints are only a single byte, which has to be
> the first byte of the instruction. IOW the hardware requires len = 1
> in dr7 or it doesn't work (iirc).
> 
> But for some reason perf requires bp_len = sizeof(long), not 1. And
> note that it sets info->len = X86_BREAKPOINT_LEN_X. The comment says:
> 
> 	x86 inst breakpoints need to have a specific undefined len
> 
> but despite its "special" name LEN_X is simply LEN_1, and other code
> relies on this fact.
> 
> Now, ptrace correctly requires DR_LEN_1. So arch_bp_generic_fields()
> translates this into "gen_len = sizeof(long)" for validation.
> 
> arch_build_bp_info() thinks that X86_BREAKPOINT_EXECUTE should have
> ->bp_len == sizeof(long), so we translate it back into LEN_1 internally.

I did this interface and I'm sorry about it.

This bp_len == sizeof(long) requirement comes from a very buggy conception
I had at the time I wrote that. I thought it would be pretty intuitive to
assume that instruction breakpoints should be the size of the instruction
itself as a generic interface for all archs. But at least x86 instructions
size aren't static. That sizeof(long) assumption just popped up from nowhere
at 5 am two years ago I guess :-(

And worse: I realized that mistake later but never moved it in the top of the
TODO-list pile because I had the feeling that nobody was using the perf breakpoint
interface anyway.

I'm all for fixing this. May be we can start by backporting a patch that
ignores the value of gen_len for instruction breakpoints in x86?

I don't know how other archs use it. I need to check. But this bp_len
should rather be used for range breakpoints on archs that support it. I
hope we can still reuse it if the damage of my initial misconception
isn't too widely expanded.

What do you think?

> 
> This looks confusing, imho. And imho X86_BREAKPOINT_LEN_X should die.

Yep.

Thanks.
