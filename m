Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaG1VJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:09:06 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56527 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751412AbaG1VJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:09:03 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [RFC][PATCH] irq: Rework IRQF_NO_SUSPENDED
Date: Mon, 28 Jul 2014 23:27:33 +0200
Message-ID: <1987868.rhLQi9p5LS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140728064913.GH6758@twins.programming.kicks-ass.net>
References: <20140724212620.GO3935@laptop> <2368056.cLoWQWpTSo@vostro.rjw.lan> <20140728064913.GH6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 28, 2014 08:49:13 AM Peter Zijlstra wrote:
> On Sat, Jul 26, 2014 at 01:49:17PM +0200, Rafael J. Wysocki wrote:
> > One more idea, on top of the prototype patch that I posted
> > (https://patchwork.kernel.org/patch/4625921/).
> > 
> > The problem with enable_irq_wake() is that it only takes one argument, so
> > if that's a shared interrupt, we can't really say which irqaction is supposed
> > to handle wakeup interrupts should they occur.
> 
> Right.
> 
> > To address this we can introduce enable_device_irq_wake() that will take
> > an additional dev_id argument (that must be the one passed to request_irq() or
> > the operation will fail) that can be used to identify the irqaction for
> > handling the wakeup interrupts.  It can work by setting IRQF_NO_SUSPEND
> > for the irqaction in question and doing the rest along the lines of
> > irq_set_irq_wake(irq, 1).  disable_device_irq_wake() will then clear
> > IRQF_NO_SUSPEND (it also has to be passed the dev_id argument).
> > 
> > If we have that, the guys who need to set up device interrupts (ie. interrupts
> > normally used for signaling input events etc) for system wakeup will need to
> > use enable_device_irq_wake() and that should just work.
> 
> So in the patch I posted I described why NO_SUSPEND is useful, I still
> have to hear a solid reason for why we also need enable_irq_wake()? What
> does it do that cannot be achieved with NO_SUSPEND?
> 
> I realize its dynamic, but that's crap, at device registration time it
> pretty much already knows if its a wakeup source or not, right?

It knows that it can be a wakeup source, but it doesn't know if it will be
use that way (user space may not want that, for example).

It still makes sense to use IRQF_NO_SUSPEND for it, but people were complaining
about having to do that in addition to using enable_irq_wake().  Quite
understandably, because usually you want both or at least "wakeup" should
imply "no suspend".

Rafael

