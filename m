Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751605Ab3KROUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 09:20:10 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40587 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab3KROUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 09:20:04 -0500
Date: Mon, 18 Nov 2013 15:19:56 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Christian Engelmayer <cengelma@gmx.at>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PROBLEM] possible divide by 0 in kernel/sched/cputime.c
 scale_stime()
Message-ID: <20131118141956.GB10022@twins.programming.kicks-ass.net>
References: <20131116223740.3cd579cb@spike>
 <20131118140224.GA3330@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131118140224.GA3330@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 18, 2013 at 03:02:24PM +0100, Stanislaw Gruszka wrote:
> > The x86 init check whether all booted CPUs have their TSC's synchronized, never
> > failed so far, however, the tsc clocksource is sporadically marked unstable.
> > 
> >    Clocksource tsc unstable (delta = -74994678 ns)

> >    Version 00020652:
> >    Type 0 - Original OEM
> >    Family 6 - Pentium Pro
> >    Model 5 - Pentium II Model 5/Xeon/Celeron
> >    Extended brand string: "Intel(R) Core(TM) i5 CPU         650  @ 3.20GHz"

I'm not sure what tool you used to generate that, but its broken, that's
model 0x25 (37), it somehow truncates the upper model bits.

That said, its a westmere core and I've seen wsm-ep (dual socket)
machines loose their TSC sync quite regularly, but this would be the
first case a single socket wsm would loose its TSC sync.

That leads me to believe your BIOS is screwing you over with SMIs or the
like.

I would be tempted to say you should simply mark the tsc unstable on
boot and live with that -- we fully assume the sched_clock stuff is not
going backwards in an 'observable' way.

That said, it might be nice to not crash either.. 

