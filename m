Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935641Ab3DJLrW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 07:47:22 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52740 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3DJLrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 07:47:21 -0400
Message-ID: <1365594427.30071.61.camel@laptop>
Subject: Re: [PATCH 2/7] sched: Update rq clock on nohz CPU before setting
 fair group shares
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
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
Date: Wed, 10 Apr 2013 13:47:07 +0200
In-Reply-To: <20130410110650.GD28828@gmail.com>
References: <1365266760-24725-1-git-send-email-fweisbec@gmail.com>
	 <1365266760-24725-3-git-send-email-fweisbec@gmail.com>
	 <1365499591.30071.3.camel@laptop>
	 <CAFTL4hxcQyv_J4ky8wL0rzVemWPpBcjuCV=FeHBvXn5Bht-3OA@mail.gmail.com>
	 <1365577512.30071.11.camel@laptop> <20130410100620.GA28402@gmail.com>
	 <1365591767.30071.45.camel@laptop> <20130410110650.GD28828@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 13:06 +0200, Ingo Molnar wrote:

> There's just a handful of high level entry points, right? schedule(), wakeup, 
> scheduler tick, maybe notifiers - anything else? 

I suppose there's some cgroup muck and the various system calls; most
of them should be covered if we take some lower level primitives or so.

We could 'simply' hijack rq->lock and clear the state every time we
acquire or release it.. maybe have an exemption for the balance double
lock ops.

> Documenting/listing those would 
> be nice anyway, near the top of kernel/sched/core.c or so.

Sure and it might have to do.. I just prefer an option that's less
prone to human failure; being both paranoid and lazy :-)

> The other approach would be to periodically clear the flag from the timer tick. 
> That would catch invalid rq->clock use probabilistically.

Right, but once we have the most common paths covered it is very very
unlikely we'll hit the weird corner cases like this. But it is an
option.

> > I'd clear at the beginning, but that's more or less the same thing.
> > 
> > We have the .sched.text section but I'm not sure we've been consistent enough 
> > with that to be useful. But otherwise we'd be able to clear on section 
> > entry/exit or so.
> 
> Hm, I'm not sure that can be made to work sanely.

Yeah.. one option is to make all code in kernel/sched/ part of
.sched.text but that might be overkill -- not to mention we'd have to
peel things like completions and wait_queues out of sched/kernel/core.c
but that seems like a good idea anyway.

