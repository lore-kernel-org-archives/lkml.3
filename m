Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaGaXlj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 19:41:39 -0400
Received: from www.linutronix.de ([62.245.132.108]:38061 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaGaXlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 19:41:37 -0400
Date: Fri, 1 Aug 2014 01:41:31 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
cc: Alan Stern <stern@rowland.harvard.edu>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup
 interrupts
In-Reply-To: <1483885.6aPDiGeI4u@vostro.rjw.lan>
Message-ID: <alpine.DEB.2.10.1408010134440.4997@nanos>
References: <Pine.LNX.4.44L0.1407311552530.885-100000@iolanthe.rowland.org> <1483885.6aPDiGeI4u@vostro.rjw.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Jul 2014, Rafael J. Wysocki wrote:
> On Thursday, July 31, 2014 04:12:55 PM Alan Stern wrote:
> > Pardon me for sticking my nose into the middle of the conversation, but
> > here's what it looks like to me:
> > 
> > The entire no_irq phase of suspend/resume is starting to seem like a
> > mistake.  We should never have done it.
> 
> In hindsight, I totally agree.  Question is what we can do about it now.

<SNIP>

> So how can we eliminate the noirq phase in a workable way?

The straight way to do that is breaking the world and some more and
then fix up a gazillion of device drivers by doing a massive voodoo
debugging effort simply because in most cases we do not get any useful
information out of the system once the shit hits the fan.

We could add instrumentation to the core code about interrupts which
are coming in unexpectedly during suspend, but that does not solve
anything.

We really cannot call any device handler at that point as clocks might
be turned off already and any access to a device register might simply
cause a full undebuggable stall of the CPU.

And there is no way to prove that there is no chance of a spurious
interrupt for a given device. 

So if we cannot handle it at the infrastructure level, we need to make
sure that every fricking device driver interrupt handler has a 

     if (dev->suspended)
     	return CRAP;

conditional as the first line of code in it.

What is that buying us? 

Nothing than a shitload of hard to understand problems, really. The
only sensible way to handle this is at the core level.

#1 There is no way that you can rely on random drivers to do the Right
   Thing. 

#2 There is no way that all hardware is implemented in a sane way.

#3 You CANNOT educate the people who are tasked to implement something
   which "does the job" to understand all the subtle details of
   suspend/resume or whatever.

In fact such an approach would take the general aims of consolidating
repeating patterns into core infrastructure and hiding complexity from
the driver developers ad absurdum. No thanks. We have enough
uncomprehensible shite in drivers/* already. We really can do without
adding more reasons for voodoo programming.

This is a classic core infrastructure problem and we need to get the
semantics and the implementation straight by considering the
challenges of new fangled hardware and the incompentent usage of
that. Once we have that we need to fix the few offending drivers, but
that's a task which can be handled with grep and some brain applied.

Anyone who thinks that this can and should be solved at the driver
level is simply taking the wrong drugs or ran out of supply of the
proper ones. Either call your shrink or your drug dealer to get out of
that.

Thanks,

	tglx




