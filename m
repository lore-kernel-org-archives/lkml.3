Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaGaUpk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 16:45:40 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59146 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750836AbaGaUpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 16:45:38 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup interrupts
Date: Thu, 31 Jul 2014 23:04:10 +0200
Message-ID: <1483885.6aPDiGeI4u@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <Pine.LNX.4.44L0.1407311552530.885-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1407311552530.885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 31, 2014 04:12:55 PM Alan Stern wrote:
> On Thu, 31 Jul 2014, Rafael J. Wysocki wrote:
> 
> > And before we enter the wakeup handling slippery slope, let me make a note
> > that this problem is bothering me quite a bit at the moment.  In my opinion
> > we need to address it somehow regardless of the wakeup issues and I'm not sure
> > if failing __setup_irq() when there's a mismatch (that is, there are existing
> > actions for the given irq_desc and their IRQF_NO_SUSPEND settings are not
> > consistent with the new one) is the right way to do that, because it may make
> > things behave a bit randomly (it will always fail the second guy, but that need
> > not be the one who's requested IRQF_NO_SUSPEND and it depends on the ordering
> > between them).
> 
> Pardon me for sticking my nose into the middle of the conversation, but
> here's what it looks like to me:
> 
> The entire no_irq phase of suspend/resume is starting to seem like a
> mistake.  We should never have done it.

In hindsight, I totally agree.  Question is what we can do about it now.

> Alternatively, it might be
> okay to disable _all_ interrupts during the no_irq phase provided they
> are then _all_ enabled again before entering the sysdev and
> platform-specific parts of suspend (or the final freeze).
> 
> As I understand it, the idea behind the no_irq phase was to make life 
> easier for drivers.  They wouldn't have to worry about strange things 
> cropping up while they're in the middle of powering down their devices 
> or afterward.

Actually, it was done to prevent bugs in PCI drivers from crashing boxes
during suspend and resume IIRC.

When we were debugging PME with Peter a couple of days ago I asked him to
comment out suspend/resume_device_irqs() experimentally and see what
happens and it turned out that the system didn't resume any more.  It looks
like it still prevents problems from happening, then.

> Well, guess what?  It turns out that they do have to worry about it
> after all.  Timers can still fire during suspend transitions, and if an
> IRQ line is shared with a wakeup source then it won't be disabled.

OK, that's where it starts to get really messy.  If people were not using
IRQF_NO_SUSPEND excessively, the situation would be that almost all IRQ
lines, including the ones of wakeup sources, would be disabled by
suspend_device_irqs() (the exceptions being really low-level stuff that
needs to run during suspend/resume and not sharing IRQ lines).

The wakeup would then be handled with the help of the lazy disable mechanism,
that is, enable_irq_wake() from the driver and then check_wakeup_irqs() in
syscore_suspend().

However, what we have now is a mixture of different mechanisms often used
for things they had not been intended for.

But I agree that we'd probably have avoided it if suspend_device_irqs() hadn't
existed.

> The fact is, drivers should not rely on disabled interrupts to prevent
> untimely interrupt requests or wakeups.  They should configure their
> devices not to generate any interrupt requests at all, apart from
> wakeup requests.  And their interrupt handlers shouldn't mind being
> invoked for a shared IRQ, even after their devices are turned off.
> 
> Any driver that leaves its device capable of generating non-wakeup
> interrupt requests during suspend, and relies on interrupts being
> globally disabled to avoid problems, is most likely broken.  Yes, it
> may be acceptable in cases where the IRQ line isn't shared, but it's
> still a bad design.

Totally agreed.

So how can we eliminate the noirq phase in a workable way?

Rafael

