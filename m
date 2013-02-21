Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab3BUSWH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:22:07 -0500
Received: from www.linutronix.de ([62.245.132.108]:51051 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab3BUSWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:22:04 -0500
Date: Thu, 21 Feb 2013 19:21:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] nohz: Make tick_nohz_irq_exit() irq safe
In-Reply-To: <CA+55aFwTFOsRTX3pHeZ+664rAms-Liwco3scEPJum6=C3BCoEQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1302211920440.22263@ionos>
References: <1361373336-11337-1-git-send-email-fweisbec@gmail.com> <alpine.LFD.2.02.1302202155320.22263@ionos> <CA+55aFwTFOsRTX3pHeZ+664rAms-Liwco3scEPJum6=C3BCoEQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013, Linus Torvalds wrote:

> On Wed, Feb 20, 2013 at 1:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >   */
> >  void irq_exit(void)
> >  {
> > +#ifndef __ARCH_IRQ_EXIT_IRQS_DISABLED
> > +       unsigned long flags;
> > +
> > +       local_irq_save(flags);
> > +#else
> > +       BUG_ON(!irqs_disabled();
> > +#endif
> 
> Guys, STOP DOING THIS!
> 
> Adding BUG_ON()'s just makes things much much much worse. There is
> *never* a reason to add a BUG_ON(). And doing it in an interrupt path
> is totally unacceptable. BUG_ON() makes it almost impossible to debug
> something, because you just killed the machine. So using BUG_ON() for
> "please notice this" is stupid as hell, because the most common end
> result is: "Oh, the machine just hung with no messages".
> 
> Make it WARN_ON_ONCE() if you absolutely have to let people know, but
> for something like this, why would you do even that?

This was a draft patch. I made it a WARN_ON_ONCE() already. 

We really want to enforce that irq_exit() is called with interrupts
disabled.

Thanks,

	tglx
