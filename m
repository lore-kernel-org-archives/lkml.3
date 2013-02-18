Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996Ab3BRQeE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:34:04 -0500
Received: from miso.sublimeip.com ([203.12.5.51]:21395 "EHLO
	miso.sublimeip.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab3BRQeC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:34:02 -0500
Subject: Re: prctl(PR_SET_MM)
To: rostedt@goodmis.org (Steven Rostedt)
Date: Tue, 19 Feb 2013 03:33:59 +1100 (EST)
Cc: u3557@dialix.com.au, oleg@redhat.com (Oleg Nesterov),
        palves@redhat.com (Pedro Alves), dvlasenk@redhat.com (Denys Vlasenko),
        jan.kratochvil@redhat.com (Jan Kratochvil),
        gorcunov@openvz.org (Cyrill Gorcunov),
        xemul@parallels.com (Pavel Emelyanov),
        fweisbec@gmail.com (Frederic Weisbecker),
        mingo@redhat.com (Ingo Molnar),
        a.p.zijlstra@chello.nl (Peter Zijlstra), linux-kernel@vger.kernel.org
Reply-To: u3557@dialix.com.au
In-Reply-To: <1361200876.23152.149.camel@gandalf.local.home>
X-Mailer: ELM [version 2.5 PL8]
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20130218163359.25760592076@miso.sublimeip.com>
From: u3557@miso.sublimeip.com (Amnon Shiloh)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:

> On Mon, 2013-02-18 at 12:39 +1100, Amnon Shiloh wrote:
> > Hello,
> > 
> > The code in "kernel/sys.c" provides the "prctl(PR_SET_MM)" function,
> > which is the only way a process can set or modify the following 11
> > per-process fields:
> > 
> >  	start_code, end_code, start_data, end_data, start_brk, brk,
> >  	start_stack, arg_start, arg_end, env_start, env_end.
> > 
> > Being able to set those fields is important, even crucial,
> > for any conceivable user-level checkpointing software, as
> > well as for migrating processes between different computers.
> 
> You're saying that this is useful for code not needing a kernel with
> CHECKPOINT_RESTORE enabled. Correct?

Correct, this is an important feature that is useful for a whole
general class of applications, not only those needing CHECKPOINT_RESTORE.

Had this not been done as part of the CHECKPOINT_RESTORE project, it
would have certainly been done, sooner or later, by some other developers:
it just so happened that the CHECKPOINT_RESTORE people were the first to
(publically) fill this gap, but in fact this code in "kernel/sys.c" should
be general kernel code, not part of CHECKPOINT_RESTORE.

> 
> > 
> > Unfortunately, this code (essentially "prctl_set_mm()") is presently
> > enclosed in "#ifdef CONFIG_CHECKPOINT_RESTORE" which is configured
> > as "default n" in "init/Kconfig".  Many system-administrators who
> > may like to have a checkpoint/restore or process-migration facility,
> > but use standard pre-packaged kernels, find the requirement to
> > configure and compile their own non-standard kernel difficult or
> > too prohibitive.
> > 
> > Would it be possible to have this code enabled by default?
> > 
> > This could be done in one of 4 ways:
> > 1) Having CONFIG_CHECKPOINT_RESTORE enabled by default; or
> 
> Nope, that wont due. Kernel policy is to have things default n. Have an
> issue with a config, talk with the distribution you are dealing with.
> They set the policy of what configs get set for their kernels.

Yes, Randy Dunlap already raised this point, but I have no dealings with
any particular Linux distribution or the right connections to chase them
all, one by one - I develop generic software for the general Linux community,
that is intended to work distribution-independently.  Even if I had access
to all distributions, it may be hard to convince them to configure
CONFIG_CHECKPOINT_RESTORE as a whole since it contains so much other code.

BTW, Can anyone explain this policy of "have things default n"?
When I go over "init/Kconfig" or most other Kconfig's, I can
actually see lots of "default y".

> 
> > 2) Releasing this code from the "#ifdef CONFIG_CHECK_RESTORE"; or
> > 3) Placing this code within a different kernel-configuration option
> >    (say "CONFIG_BASIC_CHECKPOINTING") that is enabled by default; or
> > 4) Placing this code under a dual #if, so instead of:
> >    #ifdef CONFIG_CHECKPOINT_RESTORE
> > 	   have:
> >    #if defined(CONFIG_CHECKPOINT_RESTORE) || defined(CONFIG_BASIC_CHECKPOINTING)
> 
> One of the above 3 can probably be worked out.
> 
> -- Steve

Great!

Naturally I prefer option 2 (but the other two will do as well).

Thanks,
Amnon.
