Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935771Ab3BOLvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 06:51:46 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49486
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932583Ab3BOLvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 06:51:45 -0500
Message-ID: <1360929080.27535.9.camel@laptop>
Subject: Re: [PATCH 2/3] sched: Move idle_balance() to post_schedule
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Date: Fri, 15 Feb 2013 12:51:20 +0100
In-Reply-To: <1360782338.23152.22.camel@gandalf.local.home>
References: <20130212225412.781044738@goodmis.org>
	 <20130212230017.625583020@goodmis.org> <1360780981.8957.3.camel@laptop>
	 <1360782338.23152.22.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 14:05 -0500, Steven Rostedt wrote:
> That is, the CPU is about to go idle, thus a load balance is done, and
> perhaps a task is pulled to the current queue. To do this, rq locks
> and
> such need to be grabbed across CPUs.

Right, grabbing the rq locks and all isn't my main worry, we do that
either case, but my worry was the two extra switches we do for no good
reason at all. 

Now its not as if we'll actually run the idle thread, that would be very
expensive indeed, so its just the two context_switch() calls, but still,
I somehow remember us spending quite a lot of effort to keep
idle_balance where it is now, if only I could remember the benchmark we
had for it :/

Can't you do the opposite and fold post_schedule() into idle_balance()?

/me goes stare at code to help remember what the -rt requirements were
again..

Ah, so that's push_rt_task() which wants to move extra rt tasks to other
cpus. Doing that from where we have idle_balance() won't actually work I
think since we might need to move current, which we cannot at that point
-- I'm thinking a higher prio task (than current) waking to this cpu and
then cascading current to another cpu, can that happen?

If we never need to migrate current because we don't do the cascade by
ensuring we wake the higher prio task to the approriate cpu we might
just get away with it.

