Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaHNMhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 08:37:23 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:50023 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754593AbaHNMhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 08:37:14 -0400
Date: Thu, 14 Aug 2014 13:36:55 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v8 4/4] ARM: Add KGDB/KDB FIQ debugger generic code
Message-ID: <20140814123655.GT30401@n2100.arm.linux.org.uk>
References: <1404118391-3850-1-git-send-email-daniel.thompson@linaro.org> <1404979427-12943-1-git-send-email-daniel.thompson@linaro.org> <1404979427-12943-5-git-send-email-daniel.thompson@linaro.org> <20140813214525.GQ30401@n2100.arm.linux.org.uk> <53EC9404.5010908@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53EC9404.5010908@linaro.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2014 at 11:48:36AM +0100, Daniel Thompson wrote:
> Don't worry, you certainly did make it clear!
> 
> I actually went as far as removing the trace_* calls before having a
> change of heart. As a result I spent some time looking at the
> trace_hardirqs_on() code and, as far as I remember, I couldn't find a
> lock in the code that wasn't bypassed when in_nmi() returned true.
> 
> However the code is pretty complex and its certainly possible that I
> missed something. Are you in a position to point any particular lock to
> show I messed this up or are you working from memory?

The complexity alone is an argument against calling it from FIQ context,
because there's no guarantee that what's there will stay that way.

trace_hardirqs_on() is made more complex because there's not one function
with that name, but two.  One is in the trace code, the other is in the
lockdep code.  Here's the trace code, which has at least two problems:

trace_hardirqs_on
 -> stop_critical_timing
  -> check_critical_timing
   -> raw_spin_lock_irqsave(&max_trace_lock, flags);
   -> __trace_stack
    -> __ftrace_trace_stack
     -> save_stack_trace
      -> __save_stack_trace
       -> walk_stackframe
        -> unwind_frame
         -> unwind_find_idx
          -> spin_lock_irqsave(&unwind_lock, flags);

> > So, how about moving the FIQ assembly code to entry-armv.S and making
> > it less kgdb specific?  (Though... we do want to keep a /very/ close
> > eye on users to ensure that they don't do silly stuff with locking.)
> 
> I think I can do that.
> 
> Something like this?
> 
> 1. Install the current trap handler code by default (either with or
>    without trace_* calls).

Without trace_* calls.  The FIQ should be transparent to tracing -
tracing and lockdep is too much of an unknown (due to size and
complexity) to ensure that it always follows the rules.

> 2. Have default trap handler call an RCU notifier chain to allow it to
>    hook up with "normal" code without any hard coding (kgdb, IPI
>    handling, etc)

Maybe... that sounds like it opens up FIQ for general purpose use which
is something I want to avoid - I've little motivation to ensure that
everyone plays by the rules.  Given the choice, I'd rather maintain our
present stance that using FIQs is hard and requires a lot of thought.

> 3. Retain existing install_fiq() behaviour for people who want FIQ
>    to be a fast-interrupt rather than an NMI (for example, the
>    Raspberry pi USB optimizations).

Yes, arch/arm/kernel/fiq.c should be relatively untouched by the core
mods I suggested - we're just replacing the default "subs" instruction
(which just ignores the FIQ) with something which can do something
with it.

It should be noted that using arch/arm/kernel/fiq.c would override this
default FIQ handler - and that's a feature of it - fiq.c is based on
the premise that there is only one single owner of the FIQ at any one
time and there is no sharing of it, and that's something we want to
retain.

> 4. Ensure default handler is an exported symbol to allow the meths
>    drinkers from #3 to chain to logic for NMI/debug features
>    if they want to.

That's not something I particularly want to permit - especially as the
requirements for each "handler" are different - this new default code
relies upon r13 pointing at some storage to save some registers, which
may not be true of other FIQ handlers.  Chaining it means that we
force that use of r13 on others, and we then have to also come up with
some way to export the correct r13 value.

Given that fiq.c doesn't work with SMP, this isn't something I want to
encourage.

Further more, I can't get excited about Raspberry Pi "optimisations"
using FIQ until I see the code, and I see no reason to think about
catering for such stuff until the patches become visible here.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
