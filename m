Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967137Ab3DRLAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:00:52 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33770 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965199Ab3DRLAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:00:49 -0400
Date: Thu, 18 Apr 2013 12:00:24 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, Rabin Vincent <rabin@rab.in>,
        linus.walleij@stericsson.com, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, Per Forlin <per.forlin@stericsson.com>,
        Dan Williams <djbw@fb.com>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 08/32] dmaengine: ste_dma40: Optimise local MAX() macro
Message-ID: <20130418110024.GP14496@n2100.arm.linux.org.uk>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org> <1366279934-30761-9-git-send-email-lee.jones@linaro.org> <201304181246.03357.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304181246.03357.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 12:46:03PM +0200, Arnd Bergmann wrote:
> On Thursday 18 April 2013, Lee Jones wrote:
> > The current implementation of the DMA40's local MAX() macro evaluates
> > its arguments more times than is necessary. This patch strips it
> > optimises it to only evaluate what's appropriate.
> 
> No, it does not.
> 
> > index b21a8a3..7b451b2 100644
> > --- a/drivers/dma/ste_dma40.c
> > +++ b/drivers/dma/ste_dma40.c
> > @@ -53,7 +53,7 @@
> >  #define D40_ALLOC_PHY          BIT(30)
> >  #define D40_ALLOC_LOG_FREE     BIT(0)
> >  
> > -#define MAX(a, b) (((a) < (b)) ? (b) : (a))
> > +#define MAX(a, b) ((a > b) ? a : b)
> 
> This just makes the macro worse in case you pass a complex expression
> in, which can now have additional unwanted effects. Just drop this patch.

Never got the original patch...

A much better idea is to get rid of that buggy MAX() macro altogether
and use the macros already provided by the kernel, which are safe from
side effects - but more importantly are _type_ _safe_.  The above goes
wrong when you consider 'a' and 'b' may have different signed-ness.

Consider:

	int val_in = -5;
	unsigned val = MAX(val_in, 5U);

The resulting value is (unsigned)-5, not (unsigned)5.

Best use the kernel's max() or max_t() _everywhere_.
