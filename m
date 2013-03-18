Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754461Ab3CRRHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 13:07:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35716 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754429Ab3CRRHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 13:07:06 -0400
Date: Mon, 18 Mar 2013 17:06:49 +0000
From: Will Deacon <will.deacon@arm.com>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Will Deacon <will@willdeacon.co.uk>, Lokesh Vutla <lokeshvutla@ti.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: hw_breakpoint: Enable debug powerdown only if
 system supports 'has_ossr'
Message-ID: <20130318170649.GA29585@mudshark.cambridge.arm.com>
References: <1363157553-21085-1-git-send-email-lokeshvutla@ti.com>
 <51406BA7.8010306@arm.com>
 <51407120.7030709@ti.com>
 <51417E58.5050501@ti.com>
 <20130315050014.GA15706@tiny-lites>
 <5146B972.1010002@ti.com>
 <20130318150724.GC28585@mudshark.cambridge.arm.com>
 <514736D4.4070906@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <514736D4.4070906@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 03:46:28PM +0000, Santosh Shilimkar wrote:
> On Monday 18 March 2013 08:37 PM, Will Deacon wrote:
> > That really sucks :( Does this affect all OMAP-based boards?
> > 
> All OMAP4 based boards..

Brilliant. Is there any way that the secure code can be fixed in future
products?

> >> +	/* Check if we have access to CPU debug features */
> >> +	ARM_DBG_READ(c7, c14, 6, val);
> >> +	if ((val & 0x1) == 0) {
> >> +		pr_warn_once("CPU %d debug is unavailable\n", cpu);
> >> +		cpumask_or(&debug_err_mask, &debug_err_mask, cpumask_of(cpu));
> >> +		return;
> >> +	}
> > 
> > There are a few of problems here:
> > 
> > 	1. That is only checking for non-secure access, which precludes
> > 	   running Linux in secure mode.
> > 
> We can check bit 4 as well to take care linux running in secure mode.

It still doesn't help unless we know whether Linux is running secure or
non-secure.

> > 	2. DBGAUTHSTATUS accesses are UNPREDICTABLE when the double-lock is
> > 	   set for v7.1 processors.
> >
> > 	3. DBGAUTHSTATUS doesn't exist in ARMv6.
> > 
> We cans skip the code for these versions like...
> 	if (!ARM_DEBUG_ARCH_V7_ECP14 == get_debug_arch())
> 		goto skip_dbgsts_read;

Sure, I was just pointing out that the code needs fixing for this.

> > 	4. CPUs without the security extensions have DBGAUTHSTATUS.NSE == 0
> >
> Which bit is that ? I don't find this bit in Cortex-A9 docs. With all
> these checks, may be a separate function like 'is_debug_available()'
> would be better.

NSE is bit 0 (the one you're checking).

>  
> > 	5. Accessing DBGAUTHSTATUS requires DBGEN to be driven high.
> > 	   Assuming that your pr_warn_once is emitted, this implies that
> > 	   DBGEN is driven high from cold boot, yet the NSE bit is low,
> > 	   implying that DBGEN is also low. That's contradictory, so I have
> > 	   no idea what's going on...
> >
> Me neither. The warning is emitted at least.

Any chance you could follow up with your firmware/hardware guys about this
please? I'd really like to understand how we end up in this state in case we
can do something in the architecture to stop it from happening in future.

> > Apart from that, it's fine!
> > 
> If you agree, I can update patch accordingly.
> BTW, do you have any better trick to take care of
> above scenraio ?

Well, we could just add the warn_once prints but that doesn't stop debug
from breaking after the first pm/suspend/hotplug operation.

Will
