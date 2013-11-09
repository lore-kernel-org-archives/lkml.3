Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab3KIOxJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 09:53:09 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:59560 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab3KIOxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 09:53:03 -0500
Date: Sat, 9 Nov 2013 15:52:59 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Dave Jones <davej@redhat.com>
Subject: Re: perf/tracepoint: another fuzzer generated lockup
Message-ID: <20131109145258.GB26079@localhost.localdomain>
References: <alpine.DEB.2.10.1311081440440.7281@vincent-weaver-1.um.maine.edu>
 <alpine.DEB.2.10.1311081504400.7281@vincent-weaver-1.um.maine.edu>
 <20131108200244.GB14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081515210.16519@vincent-weaver-1.um.maine.edu>
 <20131108204839.GD14606@localhost.localdomain>
 <alpine.DEB.2.10.1311081612190.16519@vincent-weaver-1.um.maine.edu>
 <20131108223657.GF14606@localhost.localdomain>
 <20131109141039.GM16117@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131109141039.GM16117@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 03:10:39PM +0100, Peter Zijlstra wrote:
> On Fri, Nov 08, 2013 at 11:36:58PM +0100, Frederic Weisbecker wrote:
> > [  237.627769] perf samples too long (3397569 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
> > [  237.637124] INFO: NMI handler (perf_event_nmi_handler) took too long to run: 444.233 msecs
> > 
> > 444 msecs is huge.
> 
> Be glad your system lived to tell about it ;-) Calling printk() from NMI
> context is Russian roulette; I'm still waiting for the first report it
> actually locked up :-)
> 
> That said, I'm not sure what kernel you're running, but there were some
> issues with time-keeping hereabouts, but more importantly that second
> timing includes the printk() call of the first -- so that's always going
> to be fucked.

So, an idea of what may be happening: an event overflows while FASYNC flag is set so it triggers an irq work
to send the signal (kill_fasync).
After the irq work triggers, it generates an irq_work_exit event, which in turn overflows and,
if it has FASYNC, triggers a new irq work. The irq work triggers and generates an irq work exit event which
has FASYNC flag, etc...

Looks like a nice way to deadlock with an infinite loop of irq work.
