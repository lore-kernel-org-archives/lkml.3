Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760995Ab3BOMWM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:22:12 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49604
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751135Ab3BOMWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:22:10 -0500
Message-ID: <1360930908.2739.1.camel@laptop>
Subject: Re: [RFC] sched: The removal of idle_balance()
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Clark Williams <clark@redhat.com>,
        Andrew Theurer <habanero@us.ibm.com>
Date: Fri, 15 Feb 2013 13:21:48 +0100
In-Reply-To: <1360913172.4736.20.camel@marge.simpson.net>
References: <1360908819.23152.97.camel@gandalf.local.home>
	 <1360913172.4736.20.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2013-02-15 at 08:26 +0100, Mike Galbraith wrote:
> 
> (the throttle is supposed to keep idle_balance() from doing severe
> damage, that may want a peek/tweak)

Right, as it stands idle_balance() can do a lot of work and if the avg
idle time is less than the time we spend looking for a suitable task we
loose.

I've wanted to make this smarter by having the cpufreq/cpuidle avg idle
time guestimator in the scheduler core so we actually know how log we
expect to be idle and couple that with a cache refresh cost per sched
domain (something we used to have pre 2.6.21 or so) so we can auto-limit
the domain traversal for idle_balance.

So far that's all fantasy though..

Related, I wanted to use the idle time guestimate to 'optimize' the idle
loop, currently that stuff is stupid expensive and pokes at timer
hardware etc.. if we know we won't be idle longer than it takes to poke
at timer hardware, don't go into nohz mode etc.

Anyway, that all is independent of the exact location of where we call
that stuff.

