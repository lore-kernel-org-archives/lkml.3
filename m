Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503AbaE1TgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 15:36:13 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62363 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaE1TgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 15:36:11 -0400
Date: Wed, 28 May 2014 12:35:51 -0700
From: Larry Bassel <larry.bassel@linaro.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Larry Bassel <larry.bassel@linaro.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "khilman@linaro.org" <khilman@linaro.org>
Subject: Re: [PATCH v5 1/2] arm64: adjust el0_sync so that a function can
 be called
Message-ID: <20140528193542.GD7953@ubuette>
References: <1401130573-7443-1-git-send-email-larry.bassel@linaro.org>
 <1401130573-7443-2-git-send-email-larry.bassel@linaro.org>
 <20140528112738.GE15222@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140528112738.GE15222@arm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 May 14 12:27, Will Deacon wrote:
> Hi Larry,
> 
> On Mon, May 26, 2014 at 07:56:12PM +0100, Larry Bassel wrote:
> > To implement the context tracker properly on arm64,
> > a function call needs to be made after debugging and
> > interrupts are turned on, but before the lr is changed
> > to point to ret_to_user(). If the function call
> > is made after the lr is changed the function will not
> > return to the correct place.
> > 
> > For similar reasons, defer the setting of x0 so that
> > it doesn't need to be saved around the function call
> > (save far_el1 in x26 temporarily instead).
> > 
> > Signed-off-by: Larry Bassel <larry.bassel@linaro.org>
> 
> [...]
> 
> 
> Why have you added this mov instruction?

I believe (please correct me if I'm wrong) that it is necessary.
Here is why:

> > @@ -476,23 +481,27 @@ el0_undef:
> >  	// enable interrupts before calling the main handler
> >  	enable_dbg_and_irq
> >  	mov	x0, sp
> > +	adr	lr, ret_to_user
> >  	b	do_undefinstr
> >  el0_dbg:
> >  	/*
> >  	 * Debug exception handling
> >  	 */
> >  	tbnz	x24, #0, el0_inv		// EL0 only
> > -	mrs	x0, far_el1
> > +	mrs	x26, far_el1

needed because do_debug_exception may clobber x0, so save far_el1
in x26 (as other parts of this patch do)

> > +	mov	x0, x26

needed because far_el1 is expected to be in x0 here

> >  	mov	x1, x25
> >  	mov	x2, sp
> >  	bl	do_debug_exception
> >  	enable_dbg

[call to ct_user_exit will go here in the next patch, this may re-clobber x0]

> > +	mov	x0, x26

needed because far_el1 is expected to be in x0 here

Since the purpose of this patch is to make calling a function
possible in this code path, the "extra" mov instruction above
is necessary and IMHO should be added in this patch and not in the
next one whose purpose is to define the ct_user_* macros and
add calls to them in the proper places.

> >  	b	ret_to_user
> 
> Will

Larry
