Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756934Ab3LSXyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:54:03 -0500
Received: from mail-vc0-f182.google.com ([209.85.220.182]:52536 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643Ab3LSXyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:54:00 -0500
MIME-Version: 1.0
In-Reply-To: <1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	<1387478746-5436-5-git-send-email-davidlohr@hp.com>
	<CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
	<1387496569.8363.12.camel@buesod1.americas.hpqcorp.net>
Date: Thu, 19 Dec 2013 15:53:59 -0800
X-Google-Sender-Auth: C2tFsi8ajsr2v3ZYoU935T93PgE
Message-ID: <CA+55aFyay84UKWEbAZ=8bT-KV5gq-+1fWgS52gRQv=qZJzMSOQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/4] futex: Avoid taking hb lock if nothing to wakeup
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 3:42 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
>> And it can look at
>> the wait-list for that - but you want to close the race between the
>> entry actually getting added to the list using this counter. But the
>> place you increment the new counter is the same place as you take the
>> spinlock, which does that ticket increment. No?
>
> I don't think so. If we rely on this, then we could end up missing
> to-be-queued tasks that are in the process of acquiring the lock, so
> waiters could sleep forever. So we need a way of acknowledging that a
> task is in the process of waiting when concurrently doing wakeups.

I don't understand. Why is that any better with the separate atomic count?

The only place you increment the count - hb_waiters_inc() - is called
in exactly two places:

 - in requeue_futex(), which already holds the spinlock on both queues

 - in queue_lock(), immediately before getting the spinlock (which
will do the SAME ATOMIC INCREMENT, except it's just doing it on a
different member of the structure, namely the spinlock head)

so if you drop the waiters increment, and instead use the spinlock
head increment as the "waiters", you get exactly the same semantics.
If anything, for the requeue_futex() case, the spinlock increment was
done *earlier*, but that's really not relevant.

So how could we miss this? Explain to me what the separate counter
does that isn't done by the spinlock head counter.

              Linus
