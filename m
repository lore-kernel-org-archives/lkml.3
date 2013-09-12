Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999Ab3ILAsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 20:48:16 -0400
Received: from mail.openrapids.net ([64.15.138.104]:43919 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751427Ab3ILAsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 20:48:15 -0400
Date: Wed, 11 Sep 2013 20:48:11 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, lttng-dev@lists.lttng.org
Subject: Re: [RFC PATCH] timekeeping: introduce timekeeping_is_busy()
Message-ID: <20130912004811.GA6096@Krystal>
References: <20130911150853.GA19800@Krystal> <52309D13.3020305@linaro.org> <20130911185441.GC23532@Krystal> <20130911203618.GH3966@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130911203618.GH3966@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://www.efficios.com
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Sep 11, 2013 at 02:54:41PM -0400, Mathieu Desnoyers wrote:
[...]
> > If we can afford a synchronize_rcu_sched() wherever the write seqlock is
> > needed, we could go with the following. Please note that I use
> > synchronize_rcu_sched() rather than call_rcu_sched() here because I try
> > to avoid having too many timekeeper structures hanging around, and I
> > think it can be generally a good think to ensure timekeeping core does
> > not depend on the memory allocator (but I could very well be wrong).
> 
> The issue called out with this the last time I remember it being put
> forward was that grace periods can be delayed for longer than is an
> acceptable gap between timekeeping updates.  But maybe something has
> changed since then -- that was a few years ago.

Assuming we have lockdep support for seqlock, and we ensure there is no
deadlock between timekeeper seqlock and other locks. Also, given our
intent is more or less to allow execution contexts nested over the write
seqlock to read time (e.g. nmi handlers), I think we could do the
following:

updates:
- spinlock irq save
- take a shadow copy of the old timekeeper structure.
- store the CPU number that owns the lock into a variable.
- barrier()     /* store cpu nr before seqlock from nested NMI POV */
- write seqlock begin
- perform timekeeper structure update
- write seqlock end
- barrier()     /* store seqlock before cpu nr from nested NMI POV */
- store -1 into lock owner variable
- spin unlock irqrestore

kernel read-side:
- try read seqlock loop for fast path
- if seqlock read fails, check if we are the CPU owning the lock
  (variable stored by the update). If it is so, fall-back to the shadow
  copy, else, retry seqlock.

This approach would _only_ work if there is no deadlock involving a lock
nested within the write seqlock. Hence the importance of adding lockdep
support if we choose this locking design.

Thoughts ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com
