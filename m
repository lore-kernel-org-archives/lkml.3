Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482Ab3LSXOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:14:07 -0500
Received: from mail-vb0-f53.google.com ([209.85.212.53]:54276 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754699Ab3LSXOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:14:05 -0500
MIME-Version: 1.0
In-Reply-To: <1387478746-5436-5-git-send-email-davidlohr@hp.com>
References: <1387478746-5436-1-git-send-email-davidlohr@hp.com>
	<1387478746-5436-5-git-send-email-davidlohr@hp.com>
Date: Thu, 19 Dec 2013 15:14:01 -0800
X-Google-Sender-Auth: GZTltnMrTIewtVZCC2nRSQj6Ep0
Message-ID: <CA+55aFxY_sMes2=0tz0qTKH5-fpAaLji_xd9CdU-u2JxxNN6pA@mail.gmail.com>
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

On Thu, Dec 19, 2013 at 10:45 AM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> - increment the counter at queue_lock() as we always end up calling
>   queue_me() which adds the element to the list. Upon any error,
>   queue_unlock() is called for housekeeping, for which we decrement
>   to mach the increment done in queue_lock().
>
> - decrement the counter at __unqueue_me() to reflect when an element is
>   removed from the queue for wakeup related purposes.

I still hate this whole separate counter thing. It seems really annoying.

If re-ordering things didn't work out, then why can't just the counter
we *already* have in the spinlock itself work as the counter? Your
counter update logic seems to basically match when you take the
spinlock anyway.

The *testing* side doesn't actually care about how many waiters there
are, it only cares about whether there are waiters. And it can look at
the wait-list for that - but you want to close the race between the
entry actually getting added to the list using this counter. But the
place you increment the new counter is the same place as you take the
spinlock, which does that ticket increment. No?

So I still think this can be done without that new counter field, or
any new atomics.

hb_waiters_pending() could be something like

    spin_contended(hb->lock) || !list_empty(&hb->chain)

which considering where you increment the new count should be
equivalent to your "!!hb->waiters". The smp_mb_after_atomic_inc()" on
the spinlock side would become smp_mb_after_spin_lock() instead.

Yes? No? Why?

            Linus
