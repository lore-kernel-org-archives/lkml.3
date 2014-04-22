Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbaDVRsI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:48:08 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:14530 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932927AbaDVRsG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:48:06 -0400
Date: Tue, 22 Apr 2014 13:48:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Stanislav Meduna <stano@meduna.org>,
        "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: BUG: spinlock trylock failure on UP, i.MX28 3.12.15-rt25
Message-ID: <20140422134802.73fc1fa4@gandalf.local.home>
In-Reply-To: <53569E05.8010600@linutronix.de>
References: <534C3606.7010206@meduna.org>
	<534C731F.1050406@meduna.org>
	<534DADF1.6060608@meduna.org>
	<20140422115439.GA20669@linutronix.de>
	<20140422094657.5b6ca1e2@gandalf.local.home>
	<53569E05.8010600@linutronix.de>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 18:51:17 +0200
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> On 04/22/2014 03:46 PM, Steven Rostedt wrote:
> > [ added Peter ]
> > 
> > On Tue, 22 Apr 2014 13:54:39 +0200
> > Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
> >  
> >> this is, erm, harmless. We grab the timer lock via trylock in hardirq
> >> context. If the lock is already taken then we fail to get it we go for
> >> plan B. According to lockdep a trylock should not fail on UP. This is
> >> true in general except for this timer case. I was thinking abour
> >> disabling this lockdep check…
> > 
> > trylock not failing on UP, can that be an issue? I mean, if a hardirq
> > does a trylock to see if it can grab a lock that is not protected by
> > disabling irqs, and will go to plan B if it fails, on UP, it will
> > always get it.  But the issue is still there. That would mean that a
> > hardirq could have preempted a critical section and doing a trylock
> > here would succeed when it really should have failed.
> 
> If you take a lock with irqs enabled and disabled then lockdep should
> complain about it.

There's nothing wrong with taking locks with irqs enabled and disabled.
It's only wrong if that lock (or a lock that is held when the lock is
taken) is also taking in interrupt *context*.

> 
> This is the ->wait_lock of the timer base lock. This (sleeping) lock is
> usually taken with interrupts enabled. Except here, in the timer
> callback, we check if the lock is available or not. And this lock may
> be a) taken (and the ->wait_lock unlocked) or b) in process to be taken
> but the caller only succeeded to acquire the ->wait_lock before the
> interrupt occurred. This is the case here and we can't acquire the
> ->wait_lock a second time the check if the lock is really taken. But
> since the wait_lock is occupied it is likely that the lock itself is
> occupied as well.

I need to take a deeper look into the actual code. But as trylocks on
UP are nops (always succeed), and if it expects to be able to do
something in a critical section that is protected by spinlocks (again
nops on UP), this would be broken for UP.

-- Steve

