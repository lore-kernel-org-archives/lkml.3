Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752645AbaHABFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 21:05:32 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63137 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750907AbaHABFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 21:05:30 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Dmitry Torokhov <dtor@google.com>
Subject: Re: [PATCH 1/3] irq / PM: New driver interface for wakeup interrupts
Date: Fri, 01 Aug 2014 03:24:04 +0200
Message-ID: <1918133.CZQNkLMFlz@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1624300.2IhdzCt5pu@vostro.rjw.lan>
References: <20140724212620.GO3935@laptop> <alpine.DEB.2.10.1407312103190.4997@nanos> <1624300.2IhdzCt5pu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 01, 2014 02:08:12 AM Rafael J. Wysocki wrote:
> On Friday, August 01, 2014 12:16:23 AM Thomas Gleixner wrote:
> > On Thu, 31 Jul 2014, Rafael J. Wysocki wrote:
> > > On Thursday, July 31, 2014 12:44:24 PM Thomas Gleixner wrote:

[cut]

> Except for a couple of points where I'm not sure I understand you correctly
> (commented above), all of that sounds good to me.
> 
> I'm not sure about the ordering, though.  It would be good to have a working
> replacement for the IRQF_NO_SUSPEND things that we'll be removing in 1, for
> example.  So since we need to do 3) IRQF_SHARED for both IRQF_NO_SUSPEND and
> wakeup, as you said, would it be practical to start with that one?

I forgot about one case which in my opinion would be good to take into account
from the outset.  That is the case of runtime-suspended devices that we don't
want to touch during system suspend/resume.  If those are system wakeup
devices, their drivers should be able to configure them for system wakeup
at the runtime suspend time rather than during system suspend.  Also if their
interrupts are going to be used as system wakeup interrupts, the interface
that we're going to provide needs to handle that case.  That is, it should
be possible to use that interface at the runtime suspend time and it should
take care of all things going forward.

Triggering a lazy disable right at the runtime suspend time may not work,
because the interrupt will also be used for the device's runtime remote wakeup
in that case, so it has to be functional until system suspend is started and
the core decides to leave the device in its current state.  This means that
the core will need to trigger the lazy disable for it at one point during
system suspend.

Rafael

