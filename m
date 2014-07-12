Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbaGLTbs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2014 15:31:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:33292 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752191AbaGLTbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2014 15:31:47 -0400
Date: Sat, 12 Jul 2014 21:31:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [patch 54/55] timekeeping: Provide fast and NMI safe access to
 CLOCK_MONOTONIC[_RAW]
In-Reply-To: <1321708462.13569.1405173585327.JavaMail.zimbra@efficios.com>
Message-ID: <alpine.DEB.2.10.1407122130370.4357@nanos>
References: <20140711133623.530368377@linutronix.de> <20140711133709.835700036@linutronix.de> <743517199.13168.1405109080248.JavaMail.zimbra@efficios.com> <alpine.DEB.2.10.1407121002540.4357@nanos>
 <1321708462.13569.1405173585327.JavaMail.zimbra@efficios.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 12 Jul 2014, Mathieu Desnoyers wrote:
> ----- Original Message -----
> > From: "Thomas Gleixner" <tglx@linutronix.de>
> > On Fri, 11 Jul 2014, Mathieu Desnoyers wrote:
> > > Any reason why the updater wouldn't do:
> > > 
> > > tkf->seq++;
> > > smp_wmb();
> > > update(tkf->base[1 - (tkf->seq & 0x01)], tk);
> > > 
> > > instead of updating both array entries each time ?
> > 
> >   base[0];   	      <- Current active
> >   seq++;	      -> Makes base[1] the active one for readers
> >   update(base[0]);
> > 
> > So readers are always one update cycle behind. Probably not an issue
> > most of the time, but think about fast wrapping clocksources and
> > NOHZ....
> 
> Ah, yep, got it.
> 
> So instead of calling update() twice per update, could we do
> the following instead ?
> 
> tkf->seq++;
> smp_wmb();
> update(tkf->base[0], tk);
> tkf->seq++;
> smp_wmb();
> memcpy(tkf->base[1], tkf->base[0], sizeof(tkf->base[1]);
> 
> just in case "update" would happen to be expensive for
> some clock implementation.

Sure, same end result ...

Thanks,

	tglx
