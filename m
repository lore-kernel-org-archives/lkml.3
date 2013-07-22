Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757473Ab3GVPt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:49:56 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27285 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab3GVPtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:49:55 -0400
Date: Mon, 22 Jul 2013 11:49:34 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] irq: enable suspended EARLY_RESUME irqs forcefully if
 not resumed
Message-ID: <20130722154934.GD30300@phenom.dumpdata.com>
References: <1373380343-10143-1-git-send-email-ldewangan@nvidia.com>
 <alpine.DEB.2.02.1307191649080.4089@ionos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1307191649080.4089@ionos.tec.linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 05:29:16PM +0200, Thomas Gleixner wrote:
> On Tue, 9 Jul 2013, Laxman Dewangan wrote:
> > When system enters into suspend, it disable all irqs in single
> > function call. This disables EARLY_RESUME irqs also along with
> > normal irqs.
> > 
> > The EARLY_RESUME irqs get enabled in sys_core_ops->resume and
> > non-EARLY_RESUME irqs get enabled in normal system resume path.
> > 
> > When suspend_noirq failed or suspend is aborted for any reason,
> > the EARLY_RESUME irqs do not get enabled as sys_core_ops->resume()
> > call did not happen. It only enables the non-EARLY_RESUME irqs in normal
> > disable for remaining life of system.
> > 
> > Add checks on normal irq_resume() whether EARLY_RESUME irqs have been
> > enabled or not and if not then enable it forcefully.
>  
> >  
> > +static bool early_resume_irq_suspended;
> > +
> 
> Instead of doing that status dance, we could simply reenable all
> interrupts in irq_resume(). There's nothing wrong to unmask the few
> IRQF_EARLY_RESUME interrupts again.
> 
> Just the XEN ones might be upset. Konrad ?

It should not. I did test it and it ran just fine throught the
gauntlet test - but let me check it with me looking at the console.

> 
> Thanks,
> 
> 	tglx
> 
> Index: linux-2.6/kernel/irq/pm.c
> ===================================================================
> --- linux-2.6.orig/kernel/irq/pm.c
> +++ linux-2.6/kernel/irq/pm.c
> @@ -50,7 +50,7 @@ static void resume_irqs(bool want_early)
>  		bool is_early = desc->action &&
>  			desc->action->flags & IRQF_EARLY_RESUME;
>  
> -		if (is_early != want_early)
> +		if (!is_early && want_early)
>  			continue;
>  
>  		raw_spin_lock_irqsave(&desc->lock, flags);
