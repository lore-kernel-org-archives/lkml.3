Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab3LCM6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 07:58:12 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51003 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752827Ab3LCM6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 07:58:08 -0500
Date: Tue, 3 Dec 2013 12:57:18 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Anurag Aggarwal <anurag19aggarwal@gmail.com>
Cc: "naveen.sel@samsung.com" <naveen.sel@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "narendra.m1@samsung.com" <narendra.m1@samsung.com>,
        "nico@linaro.org" <nico@linaro.org>,
        Anurag Aggarwal <a.anurag@samsung.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ashish.kalra@samsung.com" <ashish.kalra@samsung.com>,
        "cpgs@samsung.com" <cpgs@samsung.com>,
        "naveenkrishna.ch@gmail.com" <naveenkrishna.ch@gmail.com>,
        "rajat.suri@samsung.com" <rajat.suri@samsung.com>,
        "poorva.s@samsung.com" <poorva.s@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "mohammad.a2@samsung.com" <mohammad.a2@samsung.com>
Subject: Re: [PATCH V2] ARM : unwinder : Prevent data abort due to stack
 overflow while executing unwind instructions Signed-off-by: Anurag Aggarwal
 <a.anurag@samsung.com>
Message-ID: <20131203125718.GB2281@e103592.cambridge.arm.com>
References: <1385717671-28953-1-git-send-email-a.anurag@samsung.com>
 <20131129125953.GG4634@e103592.cambridge.arm.com>
 <CAPoNrttZfHLa9WDJihChbMGNBmdtPa+TOS=HEd2Ro-3hcuVxNA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPoNrttZfHLa9WDJihChbMGNBmdtPa+TOS=HEd2Ro-3hcuVxNA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 30, 2013 at 08:39:02PM +0530, Anurag Aggarwal wrote:
> > Looks like you still need to move your S-o-B line.  It needs to be at
> > the end of the commit message.
> >
> > On Fri, Nov 29, 2013 at 09:34:31AM +0000, Anurag Aggarwal wrote:
> >> While unwinding backtrace, stack overflow is possible. This stack overflow can sometimes
> >> lead to data abort in system if the area after stack is not mapped to physical memory.
> >>
> >> To prevent this problem from happening execute the instructions that can cause data
> >> abort in there seperate functions instead of unwind_exec_insn, where a check for there
> >> feasibility is made first.
> >
> > Minor nit, but please wrap the commit message lines to 72 chars or less.
> > This helps the patch message to be listed nicely in git log.
> >
> >
> > If you agree with the changes I suggest below, the second paragraph
> > could be reworded something like:
> >
> > --snip--
> >
> > To prevent this problem from happening, execute the instructions that
> > can cause a data abort in separate helper functions, where a check for
> > feasibility is made before reading each word from the stack.
> >
> > --snip--
> >
> >
> >> ---
> >>  arch/arm/kernel/unwind.c |  197 ++++++++++++++++++++++++++++++++++------------
> >>  1 files changed, 148 insertions(+), 49 deletions(-)
> >>
> >> diff --git a/arch/arm/kernel/unwind.c b/arch/arm/kernel/unwind.c
> >> index 00df012..150e0fc 100644
> >> --- a/arch/arm/kernel/unwind.c
> >> +++ b/arch/arm/kernel/unwind.c
> >> @@ -49,6 +49,8 @@
> >>  #include <asm/traps.h>
> >>  #include <asm/unwind.h>
> >>
> >> +#define TOTAL_REGISTERS 16
> >> +
> >>  /* Dummy functions to avoid linker complaints */
> >>  void __aeabi_unwind_cpp_pr0(void)
> >>  {
> >> @@ -66,7 +68,7 @@ void __aeabi_unwind_cpp_pr2(void)
> >>  EXPORT_SYMBOL(__aeabi_unwind_cpp_pr2);
> >>
> >>  struct unwind_ctrl_block {
> >> -     unsigned long vrs[16];          /* virtual register set */
> >> +     unsigned long vrs[TOTAL_REGISTERS];     /* virtual register set */
> >>       const unsigned long *insn;      /* pointer to the current instructions word */
> >>       int entries;                    /* number of entries left to interpret */
> >>       int byte;                       /* current byte number in the instructions word */
> >> @@ -235,6 +237,148 @@ static unsigned long unwind_get_byte(struct unwind_ctrl_block *ctrl)
> >>       return ret;
> >>  }
> >>
> >> +static int unwind_exec_insn_0x80(struct unwind_ctrl_block *ctrl,
> >> +                             unsigned long insn)
> >
> > Since these are now split out as named functions, it's useful to have
> > human readable names.
> >
> > Maybe something like:
> >
> >         unwind_exec_pop_subset_r4_to_r13
> >
> > What do you think?
> >
> >> +{
> >> +     unsigned long high, low;
> >> +     unsigned long mask;
> >> +     unsigned long *vsp = (unsigned long *)ctrl->vrs[SP];
> >> +     int load_sp, reg = 4;
> >> +
> >> +     low = ctrl->vrs[SP];
> >> +     high = ALIGN(low, THREAD_SIZE);
> >
> > You can calculate low, high and high - low once and store them in
> > unwind_ctrl_block.  No need to recalculate them every time.
> 
> I don't think it is feasible to store high and low in unwind_ctrl_block,
> we will have to recalculate them every time in this case also as the
> value of sp is which change every time and depending on the value
> of sp the value of high and low will also change.

Actually, low is only a stepping stone for computing high, so we don't
need to store it (looks like you didn't, in your next version of the
patch).

high doesn't need to be calculated per frame: it should be fixed for
the whole backtrace.  However, taking advantage of that would involve
a bit of extra refactoring that is not really pert of this patch.
Probably not worth it for now.

> 
> 
> >
> > Field names like "low" may be confusing though.  "sp_low" etc. may be
> > clearer.
> >
> >> +
> >> +     insn = (insn << 8) | unwind_get_byte(ctrl);
> >> +     mask = insn & 0x0fff;
> >> +     if (mask == 0) {
> >> +             pr_warning("unwind: 'Refuse to unwind' instruction %04lx\n",
> >> +                     insn);
> >> +             return -URC_FAILURE;
> >> +     }
> >> +
> >> +     /*
> >> +      *  Check whether there is enough space
> >> +      *  on stack to execute the instruction
> >> +      *  if not then return failure
> >> +      */
> >> +     if ((high - low) < TOTAL_REGISTERS) {
> >
> > I'm still not sure we are optimising something valuable by factoring out
> > this check.
> 
> Even I am confused as to you why you are not sure. From the documentation
> and the original source code, it seems clear that only the last set of registers
> can create a stack overflow for these three instructions, so why waste cpu
> cycles in calculations that are unnecessary

Can you give me an example of where the optimisation brings a measurable
benefit?

For example, you could try

time /bin/bash -c 'for ((x=0; x<1000; ++x)); ps -Al; done >/dev/null'

Computing the wchan for each process involves invoking the backtracer a
few times per process to find where the scheduler was invoked from.


Even so, ps has huge overheads because it must stat and read thousands
of files from /proc.  It's horrendously slow even on by x86 box.

Maybe there's something in the kernel that's more performance-critical
on the backtracer, but I can't think of one of the top of my head.
ftrace doesn't rely on the backtracer IIUC because it adds its own
instrumentation for tracking call graphs.

Cheers
---Dave
