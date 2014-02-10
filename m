Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaBJPUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 10:20:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:50930 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751889AbaBJPUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 10:20:20 -0500
Date: Mon, 10 Feb 2014 10:19:43 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, fweisbec@gmail.com,
        mingo@redhat.com, catalin.marinas@arm.com, will.deacon@arm.com,
        gkulkarni@caviumnetworks.com, tim.bird@sonymobile.com, arndb@arndb.de,
        linux-arm-kernel@lists.infradead.org, linaro-kernel@lists.linaro.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH v3 1/6] arm64: Add ftrace support
Message-ID: <20140210101943.7ee004f6@gandalf.local.home>
In-Reply-To: <201402101603.21791.arnd@arndb.de>
References: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org>
	<1391768336-5642-1-git-send-email-takahiro.akashi@linaro.org>
	<1391768336-5642-2-git-send-email-takahiro.akashi@linaro.org>
	<201402101603.21791.arnd@arndb.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Feb 2014 16:03:21 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> On Friday 07 February 2014, AKASHI Takahiro wrote:
> > @@ -0,0 +1,23 @@
> 
> > +
> > +#ifdef CONFIG_FUNCTION_TRACER
> > +#define MCOUNT_ADDR		((unsigned long)_mcount)
> > +#define MCOUNT_INSN_SIZE	4 /* sizeof mcount call */
> > +
> > +#ifndef __ASSEMBLY__
> > +extern void _mcount(unsigned long);
> > +#endif /* __ASSEMBLY__ */
> > +#endif /* CONFIG_FUNCTION_TRACER */
> 
> We generally like to have as few #ifdef as possible, and I think the
> #ifdef CONFIG_FUNCTION_TRACER here is not needed.
> 
> > +#endif /* __ASM_FTRACE_H */
> > diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> > index 2d4554b..ca921fb 100644
> > --- a/arch/arm64/kernel/Makefile
> > +++ b/arch/arm64/kernel/Makefile
> > @@ -5,6 +5,11 @@
> >  CPPFLAGS_vmlinux.lds	:= -DTEXT_OFFSET=$(TEXT_OFFSET)
> >  AFLAGS_head.o		:= -DTEXT_OFFSET=$(TEXT_OFFSET)
> >  
> > +ifdef CONFIG_FUNCTION_TRACER
> > +CFLAGS_REMOVE_ftrace.o = -pg
> > +CFLAGS_REMOVE_insn.o = -pg
> > +endif
> 
> Same here. It never hurts to have the CFLAGS_REMOVE_* statements here, since
> you will not want to build these files for profiling.

I agree to this. I will admit, this was probably just a copy from my
code as I did the same in other Makefiles. I think I added the ifdef
statements as more of documenting what the REMOVE was for, when ftrace
was just being added to the kernel, and not well known.

I should probably go back and remove the ifdef's from other Makefiles
too.

A comment about what the -pg is for wouldn't hurt, though:

 # For files that should not have any function tracing done to them,
 # we must remove the -pg flag.

Something like that.

> 
> > diff --git a/arch/arm64/kernel/arm64ksyms.c b/arch/arm64/kernel/arm64ksyms.c
> > index 338b568..7f0512f 100644
> > --- a/arch/arm64/kernel/arm64ksyms.c
> > +++ b/arch/arm64/kernel/arm64ksyms.c
> > @@ -56,3 +56,7 @@ EXPORT_SYMBOL(clear_bit);
> >  EXPORT_SYMBOL(test_and_clear_bit);
> >  EXPORT_SYMBOL(change_bit);
> >  EXPORT_SYMBOL(test_and_change_bit);
> > +
> > +#ifdef CONFIG_FUNCTION_TRACER
> > +EXPORT_SYMBOL(_mcount);
> > +#endif
> 
> This one is clearly needed of course.
> 
> > +/*
> > + * Gcc with -pg will put the following code in the beginning of each function:
> > + *      mov x0, x30
> > + *      bl _mcount
> > + *	[function's body ...]
> > + * "bl _mcount" may be replaced to "bl ftrace_caller" or NOP if dynamic
> > + * ftrace is enabled.
> 
> Unrelated to your patch, I have run into problems with this on arm32, maybe
> someone on Cc to this mail has an idea what to do about it:
> 
> If I build a large "randconfig" kernel or "allyesconfig", the kernel image
> size exceeds 32MB, which means I can no longer link callers with a 26
> bit signed immediate argument like the "bl _mcount" here. For any other
> function calls, "gcc -mlong-calls" can be used to work around this, but
> this particular instance is created by inserting assembly statements
> into the output without considering the long-call options. Is there
> a way to get the kernel to link anyway?

I wonder if we play linker games and move the _mcount and ftrace_caller
and friends into the middle of the kernel? If it is only missing it by
a slight overflow of a 32bit jump, then maybe moving it will work.

> 
> > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> 
> Here, again, you an remove the #ifdef by making the entire file built
> only for CONFIG_FUNCTION_GRAPH_TRACER.

Interesting. Other archs (at least x86 and powerpc) required this file
for function tracing too. Seems this is only needed for function graph
tracer.

-- Steve

