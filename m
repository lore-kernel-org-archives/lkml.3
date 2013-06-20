Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab3FTJC0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:02:26 -0400
Received: from www.linutronix.de ([62.245.132.108]:59703 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3FTJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:02:23 -0400
Date: Thu, 20 Jun 2013 11:02:23 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
In-Reply-To: <51C2C077.2050900@asianux.com>
Message-ID: <alpine.DEB.2.02.1306201055580.4013@ionos.tec.linutronix.de>
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C182EE.5070500@asianux.com>
 <alpine.DEB.2.02.1306191228030.4013@ionos.tec.linutronix.de> <51C28193.3080106@asianux.com> <alpine.DEB.2.02.1306200903520.4013@ionos.tec.linutronix.de> <51C2C077.2050900@asianux.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jun 2013, Chen Gang wrote:
> On 06/20/2013 03:36 PM, Thomas Gleixner wrote:
> > On Thu, 20 Jun 2013, Chen Gang wrote:
> >> > On 06/19/2013 06:49 PM, Thomas Gleixner wrote:
> >>> > > We must do this because some architectures implement
> >>> > > do_raw_spin_lock_flags() in the following way:
> >>> > > 
> >>> > > do_raw_spin_lock_flags(l, flags)
> >>> > > {
> >>> > > 	while (!arch_spin_trylock(l)) {
> >>> > > 	      if (!irq_disabled_flags(flags)) {
> >>> > > 	      	      arch_irq_restore(flags);
> >>> > > 		      cpu_relax();
> >>> > > 		      arch_irq_disable();
> >>> > > 	      }
> >>> > > 	}
> >>> > > }
> >>> > > 
> >> > 
> >> > For mn10300 and sparc64 (not space32), it doesn't like your demo above.
> > Sigh. You're an sparc64 and mn10300 assembler expert, right?
> >  
> 
> No, do you mean: "only the related expert can discuss about it" ?

A discussion requires that the people who are discussing something are
familiar with the matter.

> >> > For API definition, it has no duty to make it correct if the user call
> >> > them with informal ways, especially, the implementation is related with
> >> > various architectures.
> > Nonsense.
> >
> 
> The word 'Nonsense' seems not quite polite.  ;-)

It might be not polite, but it's correct. And I really start to get
annoyed.
 
> At least, when some one see this usage below:
> 
>    spin_lock_irqsave(&l1, flags);
>    spin_unlock(&l1);
>    spin_lock(&l2);
>    spin_unlock_irqrestore(&l2, flags);
> 
> most of them will be amazing.

What's amazing about this?

It's the equivivalent to:

     local_irq_save(flags);
     spin_lock(&l1);
     spin_unlock(&l1);
     spin_lock(&l2);
     spin_unlock(&l2);
     local_irq_restore(flags);

The only difference is, that spin_lock_irqsave() implementations are
allowed to reenable interrupts while spinning, but again that's an
implementation detail which does not matter at all.

Thanks,

	tglx


