Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab3KUKKg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:10:36 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42366 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab3KUKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:10:34 -0500
Date: Thu, 21 Nov 2013 11:10:18 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, Chris Leech <christopher.leech@intel.com>,
        David Miller <davem@davemloft.net>, rui.zhang@intel.com,
        jacob.jun.pan@linux.intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, hpa@zytor.com,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 6/7] sched: Clean up preempt_enable_no_resched() abuse
Message-ID: <20131121101018.GX10022@twins.programming.kicks-ass.net>
References: <20131120160450.072555619@infradead.org>
 <20131120162736.691879744@infradead.org>
 <528CF94E.8020300@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <528CF94E.8020300@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 08:02:54PM +0200, Eliezer Tamir wrote:
> IMHO This has been reviewed thoroughly.
> 
> When Ben Hutchings voiced concerns I rewrote the code to use time_after,
> so even if you do get switched over to a CPU where the time is random
> you will at most poll another full interval.
> 
> Linus asked me to remove this since it makes us use two time values
> instead of one. see https://lkml.org/lkml/2013/7/8/345.

I'm not sure I see how this would be true.

So the do_select() code basically does:

  for (;;) {

    /* actual poll loop */

    if (!need_resched()) {
      if (!busy_end) {
	busy_end = now() + busypoll;
	continue;
      }
      if (!((long)(busy_end - now()) < 0))
	continue;
    }

    /* go sleep */

  }

So imagine our CPU0 timebase is 1 minute ahead of CPU1 (60e9 vs 0), and we start by:

  busy_end = now() + busypoll; /* CPU0: 60e9 + d */

but then we migrate to CPU1 and do:

  busy_end - now() /* CPU1: 60e9 + d' */

and find we're still a minute out; and in fact we'll keep spinning for
that entire minute barring a need_resched().

Surely that's not intended and desired?
