Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbaHVEzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 00:55:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60792 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755855AbaHVEzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 00:55:20 -0400
Date: Fri, 22 Aug 2014 06:55:16 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chip <chip.programmer@att.net>, Robert Richter <rric@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: amd_mce.c redundant if check?
Message-ID: <20140822045516.GC11381@nazgul.tnic>
References: <A94C429ECA0745D9802830213B114DFE@chip>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <A94C429ECA0745D9802830213B114DFE@chip>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

first of all, please remember to hit Reply-to-all when replying to mails
on lkml otherwise your note might get lost in the flood.

On Wed, Aug 20, 2014 at 10:08:18PM -0600, Chip wrote:
> On Wed, Aug 20, 2014 at 11:18:21AM -0600, Adam Duskett wrote:
> 
> >I have recently come upon this section of code in
> >arch/x86/kernel/cpu/mcheck/mce_amd.c that seems to be a redundant
> >unnecessary if check.
> >
> >
> >From line 170 - 176:
> >
> >if (tr->set_lvt_off) {
> >if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
> >/* set new lvt offset */
> >hi &= ~MASK_LVTOFF_HI;
> >hi |= tr->lvt_off << 20;
> >}
> >}
> >
> >
> >This seems like it's not actually doing anything because it's setting
> >the same value that the bit-field already has to itself.
> 
> I brought this up to Adam the other day, so he posted the question
> to this list today to elicit a response from the original
> developer(s).  I realize the quickest response is to ask the
> original poster (Adam) to investigate further, such as with pen and
> paper, but that is not a proper response to a legitimate question.
> Here is the #define that is referenced, and the two routines in
> question.  This is current in kernel version 3.16 in
> arch/x86/kernel/cpu/mcheck/mce_amd.c.
> 
> #define MASK_LVTOFF_HI    0x00F00000
> 
> static int lvt_off_valid(struct threshold_block *b, int apic, u32
> lo, u32 hi)
> {
>        int msr = (hi & MASK_LVTOFF_HI) >> 20;
> 
>        if (apic < 0) {
>                pr_err(FW_BUG "cpu %d, failed to setup threshold interrupt "
>                       "for bank %d, block %d (MSR%08X=0x%x%08x)\n", b->cpu,
>                       b->bank, b->block, b->address, hi, lo);
>                return 0;
>        }
> 
>        if (apic != msr) {
>                pr_err(FW_BUG "cpu %d, invalid threshold interrupt
> offset %d "
>                       "for bank %d, block %d (MSR%08X=0x%x%08x)\n",
>                       b->cpu, apic, b->bank, b->block, b->address, hi, lo);
>                return 0;
>        }
> 
>        return 1;
> };
> 
> /*
> * Called via smp_call_function_single(), must be called with correct
> * cpu affinity.
> */
> static void threshold_restart_bank(void *_tr)
> {
>        struct thresh_restart *tr = _tr;
>        u32 hi, lo;
> 
>        rdmsr(tr->b->address, lo, hi);
> 
>        if (tr->b->threshold_limit < (hi & THRESHOLD_MAX))
>                tr->reset = 1;  /* limit cannot be lower than err count */
> 
>        if (tr->reset) {                /* reset err count and
> overflow bit */
>                hi =
>                    (hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
>                    (THRESHOLD_MAX - tr->b->threshold_limit);
>        } else if (tr->old_limit) {     /* change limit w/o reset */
>                int new_count = (hi & THRESHOLD_MAX) +
>                    (tr->old_limit - tr->b->threshold_limit);
> 
>                hi = (hi & ~MASK_ERR_COUNT_HI) |
>                    (new_count & THRESHOLD_MAX);
>        }
> 
>        /* clear IntType */
>        hi &= ~MASK_INT_TYPE_HI;
> 
>        if (!tr->b->interrupt_capable)
>                goto done;
> 
>        if (tr->set_lvt_off) {
>                if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
>                        /* set new lvt offset */
>                        hi &= ~MASK_LVTOFF_HI;
>                        hi |= tr->lvt_off << 20;
>                }
>        }
> 
>        if (tr->b->interrupt_enable)
>                hi |= INT_TYPE_APIC;
> 
> done:
> 
>        hi |= MASK_COUNT_EN_HI;
>        wrmsr(tr->b->address, lo, hi);
> }
> 
> 
> If one were to actually analyze the source file from which this
> snippet comes (lines 117 - 185), one would realize the call to
> lvt_off_valid() is given tr->lvt_off as the input "apic" value that
> is compared to the content in "hi" at bit positions 23:20 (MSR bits
> 55:52); this field is called LVT Offset (LVTOFF).  The value for
> tr->lvt_off is usually from 0 to 4, inclusive.  If this value is
> equal to the LVTOFF value in "hi", then lvt_off_valid() returns 1
> for true.  If the value for tr->lvt_off differs from the LVTOFF
> value in "hi", then lvt_off_valid() returns 0 for false.
> 
> Now, if the return from lvt_off_valid() is false, then nothing is
> changed in "hi".  However, if the return is true, which means the
> value in tr->lvt_off is equal to the LVTOFF value in "hi", then the
> LVTOFF value in "hi" is replaced with the value in tr->lvt_off.  One
> has to wonder, then, why bother actually calling lvt_off_valid() in
> the first place when the end result is that "hi" does not change.
> What is the rationale for having the code snippet at lines 170 - 176
> when that condition check does nothing to change "hi"?

Right, I see what you mean now. This is

bbaff08dca3c ("mce, amd: Add helper functions to setup APIC")

Frankly, I'm not too worried about the overwriting the LVT offset with
the same value in the success case - that doesn't hurt anyone.

What is more interesting is what we do in the !lvt_off_valid case... I
don't think we should be writing the MSR at all at the end but just exit
early. But I've long forgotten the details of the whole APIC vectors
deal we thought up at the time.

Bob, can you please take a look?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
