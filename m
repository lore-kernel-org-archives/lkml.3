Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617Ab3LSXmw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:42:52 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:30394 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab3LSXmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:42:51 -0500
Message-ID: <1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Thu, 19 Dec 2013 15:42:49 -0800
In-Reply-To: <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	 <1387478746-5436-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-19 at 15:14 -0800, Linus Torvalds wrote:
> On Thu, Dec 19, 2013 at 10:45 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > - increment the counter at queue_lock() as we always end up calling
> >   queue_me() which adds the element to the list. Upon any error,
> >   queue_unlock() is called for housekeeping, for which we decrement
> >   to mach the increment done in queue_lock().
> >
> > - decrement the counter at __unqueue_me() to reflect when an element is
> >   removed from the queue for wakeup related purposes.
> 
> I still hate this whole separate counter thing. It seems really annoying.
> 
> If re-ordering things didn't work out, then why can't just the counter
> we *already* have in the spinlock itself work as the counter? Your
> counter update logic seems to basically match when you take the
> spinlock anyway.
> 
> The *testing* side doesn't actually care about how many waiters there
> are, it only cares about whether there are waiters. 

True.

> And it can look at
> the wait-list for that - but you want to close the race between the
> entry actually getting added to the list using this counter. But the
> place you increment the new counter is the same place as you take the
> spinlock, which does that ticket increment. No?

I don't think so. If we rely on this, then we could end up missing
to-be-queued tasks that are in the process of acquiring the lock, so
waiters could sleep forever. So we need a way of acknowledging that a
task is in the process of waiting when concurrently doing wakeups.

Thanks,
Davidlohr

