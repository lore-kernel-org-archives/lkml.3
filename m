Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798AbaABU7Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:59:24 -0500
Received: from g1t0026.austin.hp.com ([15.216.28.33]:11555 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701AbaABU7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:59:23 -0500
Message-ID: <1388696357.11119.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v5 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Jeff Mahoney <jeffm@suse.com>,
        Jason Low <jason.low2@hp.com>, Waiman Long <Waiman.Long@hp.com>,
        Tom Vaden <tom.vaden@hp.com>, "Norton, Scott J" <scott.norton@hp.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>
Date: Thu, 02 Jan 2014 12:59:17 -0800
In-Reply-To: <CA+55aFwNPgzORGyKaziqBGqY9Uubuuo0w=rGQvcHS-Ftz4HQ9g@mail.gmail.com>
References: <1388675120-8017-1-git-send-email-davidlohr@hp.com>
	 <1388675120-8017-5-git-send-email-davidlohr@hp.com>
	 <CA+55aFwNPgzORGyKaziqBGqY9Uubuuo0w=rGQvcHS-Ftz4HQ9g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-01-02 at 11:23 -0800, Linus Torvalds wrote:
> On Thu, Jan 2, 2014 at 7:05 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
> >
> > In futex_wake() there is clearly no point in taking the hb->lock if we know
> > beforehand that there are no tasks to be woken.
> 
> Btw, I think we could optimize this a bit further for the wakeup case.
> 
> wake_futex() does a get_task_struct(p)/put_task_struct(p) around its
> actual waking logic, and I don't think that's necessary. The task
> structures are RCU-delayed, and the task cannot go away until the
> "q->lock_ptr = NULL" afaik, so you could replace that atomic inc/dec
> with just a RCU read region.

I had originally explored making the whole plist thing more rcu aware
but never got to anything worth sharing. What you say does make a lot of
sense, however, I haven't been able to see any actual improvements. It
doesn't hurt however, so I'd have no problem adding such patch to the
lot.

> 
> Maybe it's not a big deal ("wake_up_state()" ends up getting the task
> struct pi_lock anyway, so it's not like we can avoid toucing the task
> structure), but I'm getting the feeling that we're doing a lot of
> unnecessary work here.

I passed this idea through my wakeup measuring program and didn't notice
hardly any difference, just noise, even for large amounts of futexes.
I believe that peterz's idea of lockless batch wakeups is the next step
worth looking into for futexes -- even though the spurious wakeup
problem can become a real pain.

Thanks,
Davidlohr


