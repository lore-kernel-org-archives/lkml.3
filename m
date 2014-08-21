Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaHUEIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 00:08:17 -0400
Received: from nm7.access.bullet.mail.gq1.yahoo.com ([216.39.62.38]:28681 "EHLO
	nm7.access.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbaHUEIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 00:08:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=s2048; d=att.net;
	b=Jf8sOMUkrqVg4LqRWVVEJHa8Xyn4Tpp+u/y3Tjzy5GZ1+QhsbYnZaU0U/H09QBKIcW3xrEqp7d1WrQm5jPAbifCa+VqELk9jtBZBzBwTljUvqCurMTL1aYLGHZB2bD5r/Hzu6fze7KxPPXZdMj0z3eou4wQsgANaTahwY6A7CCYev3JZLsD5fuXb0YQrAbBQ1L53I3BfhvqVwsRuXcbtUEIczsSg0GwaqSazF4do2tQWB+RxpLI9UnenlLB/cj6dZ/QuH3ew10FPnMdJH6FYbTcSBM3UH9OQlEwN6fVb4oJ2jGOuJ3uRBdk/dvTkvHGQvuEdNAxgWpC4TXQd9ebVFA==;
X-Yahoo-Newman-Id: 157154.31924.bm@smtp113.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: zRGfE9QVM1n17aZEShdUfEkpByBi4k9Ej_s4VefAhXN8kNX
 6S7ovCuETXp9vqhZdQp5ftEaZBtBvu7k7Q.h.kX2oP4f8FRYJCWtZ2DuQQL_
 HTx9hKTrkv50AQ2LZDVuzFdeH5SK2YtYyHoWm1FyJjdVSBj_GVYLe4mTOrAh
 uvGdNChwmq4Mf.H9e9vEZSbmbSrd4n7vo6QvkRU0Ng4d.n.3_WgDU9qr4xLX
 KbZvR0XAavCcsKI3JBMgEO4GLhX5LfottkR.6ciCVqLJnp8t3jzwFRdqjPiX
 V2c8OvRYhOrQXMog7rgtVpKKi1PqRV4tppFHp4mrG4oKZWIc7IegDgyaagW5
 GqlwvZuOmuUSCMfZW90DUL.SUTzmlNrlh33rQmkK7d2wQ3YQ3KO5j8PKVDYb
 5uiryhoX9pRBaMfTIWm9ix9roKIDNWmUshO1.vwPK7ht7y9jufqu3fz05hQC
 htWKw4rTuxd9Cb_Sy7sl6woZmRIZA6u7boDJWjXXdhzki3SwIpped91mY_Qu
 UA64TK957eR4L8KkKni5eeK68iQODUMC8ESs2cNUxiHUrKQE-
X-Yahoo-SMTP: reHTccOswBCBVGMHbMNbu3eCkRAaRDbSk_g_4yKoBfxXlh26
Message-ID: <A94C429ECA0745D9802830213B114DFE@chip>
From: "Chip" <chip.programmer@att.net>
To: <linux-kernel@vger.kernel.org>
Subject: Re: amd_mce.c redundant if check?
Date: Wed, 20 Aug 2014 22:08:18 -0600
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 16.4.3528.331
X-MimeOLE: Produced By Microsoft MimeOLE V16.4.3528.331
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 11:18:21AM -0600, Adam Duskett wrote:

> I have recently come upon this section of code in
> arch/x86/kernel/cpu/mcheck/mce_amd.c that seems to be a redundant
> unnecessary if check.
>
>
> From line 170 - 176:
>
> if (tr->set_lvt_off) {
> if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
> /* set new lvt offset */
> hi &= ~MASK_LVTOFF_HI;
> hi |= tr->lvt_off << 20;
> }
> }
>
>
> This seems like it's not actually doing anything because it's setting
> the same value that the bit-field already has to itself.

I brought this up to Adam the other day, so he posted the question to this 
list today to elicit a response from the original developer(s).  I realize 
the quickest response is to ask the original poster (Adam) to investigate 
further, such as with pen and paper, but that is not a proper response to a 
legitimate question.  Here is the #define that is referenced, and the two 
routines in question.  This is current in kernel version 3.16 in 
arch/x86/kernel/cpu/mcheck/mce_amd.c.

#define MASK_LVTOFF_HI    0x00F00000

static int lvt_off_valid(struct threshold_block *b, int apic, u32 lo, u32 
hi)
{
        int msr = (hi & MASK_LVTOFF_HI) >> 20;

        if (apic < 0) {
                pr_err(FW_BUG "cpu %d, failed to setup threshold interrupt "
                       "for bank %d, block %d (MSR%08X=0x%x%08x)\n", b->cpu,
                       b->bank, b->block, b->address, hi, lo);
                return 0;
        }

        if (apic != msr) {
                pr_err(FW_BUG "cpu %d, invalid threshold interrupt offset %d 
"
                       "for bank %d, block %d (MSR%08X=0x%x%08x)\n",
                       b->cpu, apic, b->bank, b->block, b->address, hi, lo);
                return 0;
        }

        return 1;
};

/*
* Called via smp_call_function_single(), must be called with correct
* cpu affinity.
*/
static void threshold_restart_bank(void *_tr)
{
        struct thresh_restart *tr = _tr;
        u32 hi, lo;

        rdmsr(tr->b->address, lo, hi);

        if (tr->b->threshold_limit < (hi & THRESHOLD_MAX))
                tr->reset = 1;  /* limit cannot be lower than err count */

        if (tr->reset) {                /* reset err count and overflow bit 
*/
                hi =
                    (hi & ~(MASK_ERR_COUNT_HI | MASK_OVERFLOW_HI)) |
                    (THRESHOLD_MAX - tr->b->threshold_limit);
        } else if (tr->old_limit) {     /* change limit w/o reset */
                int new_count = (hi & THRESHOLD_MAX) +
                    (tr->old_limit - tr->b->threshold_limit);

                hi = (hi & ~MASK_ERR_COUNT_HI) |
                    (new_count & THRESHOLD_MAX);
        }

        /* clear IntType */
        hi &= ~MASK_INT_TYPE_HI;

        if (!tr->b->interrupt_capable)
                goto done;

        if (tr->set_lvt_off) {
                if (lvt_off_valid(tr->b, tr->lvt_off, lo, hi)) {
                        /* set new lvt offset */
                        hi &= ~MASK_LVTOFF_HI;
                        hi |= tr->lvt_off << 20;
                }
        }

        if (tr->b->interrupt_enable)
                hi |= INT_TYPE_APIC;

done:

        hi |= MASK_COUNT_EN_HI;
        wrmsr(tr->b->address, lo, hi);
}


If one were to actually analyze the source file from which this snippet 
comes (lines 117 - 185), one would realize the call to lvt_off_valid() is 
given tr->lvt_off as the input "apic" value that is compared to the content 
in "hi" at bit positions 23:20 (MSR bits 55:52); this field is called LVT 
Offset (LVTOFF).  The value for tr->lvt_off is usually from 0 to 4, 
inclusive.  If this value is equal to the LVTOFF value in "hi", then 
lvt_off_valid() returns 1 for true.  If the value for tr->lvt_off differs 
from the LVTOFF value in "hi", then lvt_off_valid() returns 0 for false.

Now, if the return from lvt_off_valid() is false, then nothing is changed in 
"hi".  However, if the return is true, which means the value in tr->lvt_off 
is equal to the LVTOFF value in "hi", then the LVTOFF value in "hi" is 
replaced with the value in tr->lvt_off.  One has to wonder, then, why bother 
actually calling lvt_off_valid() in the first place when the end result is 
that "hi" does not change.  What is the rationale for having the code 
snippet at lines 170 - 176 when that condition check does nothing to change 
"hi"?

-- 
Chip 

