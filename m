Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab3KIP1K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:27:10 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:64084 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab3KIP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:27:04 -0500
Date: Sat, 9 Nov 2013 16:27:01 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131109152659.GD26079@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109141039.GM16117@laptop.programming.kicks-ass.net>
 <20131109145258.GB26079@localhost.localdomain>
 <20131109151356.GA4971@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109151356.GA4971@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 04:13:56PM +0100, Peter Zijlstra wrote:
> On Sat, Nov 09, 2013 at 03:52:59PM +0100, Frederic Weisbecker wrote:
> > So, an idea of what may be happening: an event overflows while FASYNC flag is set so it triggers an irq work
> > to send the signal (kill_fasync).
> > After the irq work triggers, it generates an irq_work_exit event, which in turn overflows and,
> > if it has FASYNC, triggers a new irq work. The irq work triggers and generates an irq work exit event which
> > has FASYNC flag, etc...
> > 
> > Looks like a nice way to deadlock with an infinite loop of irq work.
> 
> 
> Yep, exactly, see the email I just send.

In fact, raising an irq work from an irq work should simply be prohibited. That's not a sane
behaviour.

It's natural for async stuffs that have reasonable delays between each pass allow re-enqueuing,
like workqueue or rcu callbacks, or timers. But with irq work that doesn't look right, expect for
lazy irq works though. But lets just not allow it at all :)
