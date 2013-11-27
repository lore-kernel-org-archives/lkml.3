Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3K0OR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:17:28 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:47960 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3K0ORZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:17:25 -0500
Date: Wed, 27 Nov 2013 15:17:21 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@gmail.com>, tglx@linutronix.de, mingo@redhat.com,
        rostedt@goodmis.org, oleg@redhat.com, fweisbec@gmail.com,
        darren@dvhart.com, johan.eker@ericsson.com, p.faure@akatech.ch,
        linux-kernel@vger.kernel.org, claudio@evidence.eu.com,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        tommaso.cucinotta@sssup.it, nicola.manica@disi.unitn.it,
        luca.abeni@unitn.it, dhaval.giani@gmail.com, hgu1972@gmail.com,
        paulmck@linux.vnet.ibm.com, raistlin@linux.it, insop.song@gmail.com,
        liming.wang@windriver.com, jkacur@redhat.com,
        harald.gustafsson@ericsson.com, vincent.guittot@linaro.org,
        bruce.ashfield@windriver.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 02/14] sched: add extended scheduling interface. (new ABI)
Message-ID: <20131127141721.GA24979@gmail.com>
References: <1383831828-15501-1-git-send-email-juri.lelli@gmail.com>
 <1383831828-15501-3-git-send-email-juri.lelli@gmail.com>
 <20131127132354.GA18422@gmail.com>
 <20131127133027.GE10022@twins.programming.kicks-ass.net>
 <20131127140143.GB24403@gmail.com>
 <20131127141334.GA13532@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131127141334.GA13532@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Nov 27, 2013 at 03:01:43PM +0100, Ingo Molnar wrote:
> > > So the problem I see with this one is that because you're allowed to 
> > > call sched_setparam() or whatever it will be called next on another 
> > > task; a task can very easily fail its sched_getparam() call.
> > > 
> > > Suppose the application is 'old' and only supports a subset of the 
> > > fields; but its wants to get, modify and set its params. This will 
> > > work as long nothing will set anything it doesn't know about.
> > > 
> > > As soon as some external entity -- say a sysad using schedtool -- 
> > > sets a param field it doesn't support the get, modify, set routing 
> > > completely fails.
> > 
> > There are two approaches to this that I can see:
> > 
> > 1)
> > 
> > allow partial information to be returned to user-space, for existing 
> > input parameters. The new fields won't be displayed, but the tool 
> > doesn't know about them anyway so it's OK. The tool can still display 
> > all the other existing parameters.
> 
> But suppose a task simply wants to lower/raise its static (FIFO)
> priority and does:
> 
> sched_getparam(&params);
> params.prio += 1;
> sched_setparam(&params);
> 
> If anything outside of the known param fields was set, we just silently
> lost it, for the setparam() call will fill out 0s for the unprovided
> fields.
> 
> > 2)
> > 
> > Return -ENOSYS if the 'extra' fields are nonzero. In this case the 
> > usual case of old tooling + new kernel will still work just fine, 
> > because old tooling won't set the new fields to any non-default 
> > (nonzero) values. In the 'mixed' case old tooling will not be able to 
> > change/display those fields.
> > 
> > I tend to lean towards #1. What do you think?
> 
> As per the above that can result in silent unexpected behavioural
> changes.
> 
> I'd much rather be explicit and break hard; so 2).
> 
> So mixing new tools (schedtool, chrt etc) and old apps will give pain,
> but at least not silent surprises.

You are right, I concur.

Thanks,

	Ingo
