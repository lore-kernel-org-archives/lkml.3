Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3FTJHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 05:07:36 -0400
Received: from www.linutronix.de ([62.245.132.108]:59766 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab3FTJHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 05:07:33 -0400
Date: Thu, 20 Jun 2013 11:07:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chen Gang <gang.chen@asianux.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/timer.c: using spin_lock_irqsave instead of
 spin_lock + local_irq_save, especially when CONFIG_LOCKDEP not defined
In-Reply-To: <51C2BF3C.8020804@asianux.com>
Message-ID: <alpine.DEB.2.02.1306201102330.4013@ionos.tec.linutronix.de>
References: <51C11E83.8030902@asianux.com> <alpine.DEB.2.02.1306191029530.4013@ionos.tec.linutronix.de> <51C17D01.2060208@asianux.com> <alpine.DEB.2.02.1306191151390.4013@ionos.tec.linutronix.de> <51C1861A.6030901@asianux.com>
 <alpine.DEB.2.02.1306191249260.4013@ionos.tec.linutronix.de> <51C2BF3C.8020804@asianux.com>
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
> On 06/19/2013 06:53 PM, Thomas Gleixner wrote:
> > So
> > 	local_irq_save(flags);
> > 	spin_lock(&lock);
> > 
> > is semantically the same as 
> > 
> > 	spin_lock_irqsave(&lock, flags);
> > 
> 
> Yes (but reverse is NO).
> 
> > And this is completely independent of LOCKDEP.
> 
> NO.
> 
>  	spin_lock_irqsave(&lock, flags);
> 
>  is not semantically the same as
> 
>  	local_irq_save(flags);
>  	spin_lock(&lock);

If A is semantically the same as B, then B is semantically the same as
A. At least that's the common understanding.

You seem to have a different definition of semantics, but I prefer the
common one.
 
> It depend on the spin_lock_irqsave() implementation, if the parameters
> has no relation ship with each other, semantically the same.

Yes, it depends on the implementation, but all implementations do:

     local_irq_save(flags);
     arch_spin_lock_flags(l, flags);

And whether that maps to a reenable interrupts while spinning or not,
has nothing to do with the spinlock semantics.

If you find a single architecture specific implementation, which is
wrong, then fix it and send a patch for it.

The core implementation _IS_ correct. Period.

Thanks,

	tglx
