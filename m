Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3LTIyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:54:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:49640 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589Ab3LTIyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:54:51 -0500
Date: Fri, 20 Dec 2013 09:54:26 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
Message-ID: <20131220085426.GZ21999@twins.programming.kicks-ass.net>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
 <1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
 <1387506141.8363.47.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFyrZmG6rNpY22OK3UQi18e=4UQyh8a3tpxY+QVCbNxXkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyrZmG6rNpY22OK3UQi18e=4UQyh8a3tpxY+QVCbNxXkw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 07:13:09PM -0800, Linus Torvalds wrote:
> I think we might have to order the two reads with an smp_rmb - making
> sure that we check the lock state first - but I think it should be
> otherwise pretty solid.

> Yeah, I said "spin_contended()" myself initially, but it needs to be
> "spin_is_locked()". It's hopefully unlikely to ever actually be
> contended (which in ticket lock terms is "head is _more_ than one away
> from the tail").


Right, which would give us something like:

  LOCK m		is_locked m
  list_{add,del}	RMB
  UNLOCK m		list_empty

Where the rmb matches the release/unlock. This guarantees that when we
see the unlock we must also see the list modification.


