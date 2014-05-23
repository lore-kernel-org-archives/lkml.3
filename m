Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825AbaEWOpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 10:45:17 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:10839 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752757AbaEWOpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 10:45:13 -0400
Date: Fri, 23 May 2014 15:44:57 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Larry Bassel <larry.bassel@linaro.org>
Cc: Christopher Covington <cov@codeaurora.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "khilman@linaro.org" <khilman@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v4 1/2] arm64: adjust el0_sync so that a function can be
 called
Message-ID: <20140523144457.GN9252@arm.com>
References: <1400786855-32656-1-git-send-email-larry.bassel@linaro.org>
 <1400786855-32656-2-git-send-email-larry.bassel@linaro.org>
 <537E5CD9.80501@codeaurora.org>
 <20140522223520.GA7953@ubuette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140522223520.GA7953@ubuette>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 11:35:20PM +0100, Larry Bassel wrote:
> > On 05/22/2014 03:27 PM, Larry Bassel wrote:
> > > To implement the context tracker properly on arm64,
> > > a function call needs to be made after debugging and
> > > interrupts are turned on, but before the lr is changed
> > > to point to ret_to_user(). If the function call
> > > is made after the lr is changed the function will not
> > > return to the correct place.
> > > 
> > > For similar reasons, defer the setting of x0 so that
> > > it doesn't need to be saved around the function call
> > > (save far_el1 in x26 temporarily instead).
> > > 
> > > Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
> > > ---
> > >  arch/arm64/kernel/entry.S | 24 +++++++++++++++++-------
> > >  1 file changed, 17 insertions(+), 7 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> > > index e8b23a3..20b336e 100644
> > > --- a/arch/arm64/kernel/entry.S
> > > +++ b/arch/arm64/kernel/entry.S
> > > @@ -354,7 +354,6 @@ el0_sync:
> > >  	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
> > >  	cmp	x24, #ESR_EL1_EC_SVC64		// SVC in 64-bit state
> > >  	b.eq	el0_svc
> > > -	adr	lr, ret_to_user
> > >  	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
> > >  	b.eq	el0_da
> > >  	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
> > > @@ -383,7 +382,6 @@ el0_sync_compat:
> > >  	lsr	x24, x25, #ESR_EL1_EC_SHIFT	// exception class
> > >  	cmp	x24, #ESR_EL1_EC_SVC32		// SVC in 32-bit state
> > >  	b.eq	el0_svc_compat
> > > -	adr	lr, ret_to_user
> > >  	cmp	x24, #ESR_EL1_EC_DABT_EL0	// data abort in EL0
> > >  	b.eq	el0_da
> > >  	cmp	x24, #ESR_EL1_EC_IABT_EL0	// instruction abort in EL0
> > > @@ -426,22 +424,26 @@ el0_da:
> > >  	/*
> > >  	 * Data abort handling
> > >  	 */
> > > -	mrs	x0, far_el1
> > > -	bic	x0, x0, #(0xff << 56)
> > > +	mrs	x26, far_el1
> > >  	// enable interrupts before calling the main handler
> > >  	enable_dbg_and_irq
> > > +	mov	x0, x26
> > > +	bic	x0, x0, #(0xff << 56)
> > 
> > Nit: I believe you can bit clear with x26 as the source register and omit the
> > move instruction.
> 
> Is that really an improvement (assuming it works)? Are we saving
> any cycles here? If so, does it matter? It is easy to see what
> the move instruction is doing.

Even if it's not noticeable, I would still reduce the number of lines by
one. BIC with immediate is just an alias for AND and it supports
different source and destination.

-- 
Catalin
