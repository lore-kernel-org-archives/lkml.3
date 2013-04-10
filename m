Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757Ab3DJLG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:06:56 -0400
Received: from mail-ea0-f170.google.com ([209.85.215.170]:51127 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655Ab3DJLGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:06:54 -0400
Date: Wed, 10 Apr 2013 13:06:50 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 2/7] sched: Update rq clock on nohz CPU before setting
 fair group shares
Message-ID: <20130410110650.GD28828@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
 <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
 <1365499591.30071.3.camel@laptop>
 <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
 <1365577512.30071.11.camel@laptop>
 <20130410100620.GA28402@gmail.com>
 <1365591767.30071.45.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365591767.30071.45.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, 2013-04-10 at 12:06 +0200, Ingo Molnar wrote:
> > * Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> > > I think Mike once tried something along the lines of keeping a per rq state that 
> > > got cleared at the end of schedule() but that doesn't catch things like the 
> > > migrate handlers I think.
> > 
> > We'd need a rq->clock.valid debug flag, which is set by a sched-clock update, and 
> > cleared by the end of all scheduler operations, not just schedule().
> > 
> > Then sched_clock() could have a pretty efficient assert in it. Are there bugs that 
> > such an approach would not catch?
> 
> It requires manual iteration of all scheduler operations which is prone
> to 'accidents'.

There's just a handful of high level entry points, right? schedule(), wakeup, 
scheduler tick, maybe notifiers - anything else? Documenting/listing those would 
be nice anyway, near the top of kernel/sched/core.c or so.

The other approach would be to periodically clear the flag from the timer tick. 
That would catch invalid rq->clock use probabilistically.

> I'd clear at the beginning, but that's more or less the same thing.
> 
> We have the .sched.text section but I'm not sure we've been consistent enough 
> with that to be useful. But otherwise we'd be able to clear on section 
> entry/exit or so.

Hm, I'm not sure that can be made to work sanely.

Thanks,

	Ingo
