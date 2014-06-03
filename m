Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934317AbaFCUFb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 16:05:31 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:6013 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933384AbaFCUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 16:05:27 -0400
Date: Tue, 3 Jun 2014 16:05:24 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603160524.7895f225@gandalf.local.home>
In-Reply-To: <CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
	<20140603172632.GA27956@redhat.com>
	<CA+55aFzT5CGv_T60voAqR+4PfiMmJmsDZLid2DZ4=+X8uvF+ig@mail.gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 11:03:49 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:
 
> An example of (b) is having a lock that is initialized by the
> constructor, and that everybody else uses properly: you may have
> delayed people locking/unlocking it, but as long as they don't screw
> anything else up they won't break even if the data structure was
> re-used by a new allocations.

I'm trying to wrap my head around this.

I guess it comes down to this code here in __lock_task_sighand:

	for (;;) {
		local_irq_save(*flags);
		rcu_read_lock();
		sighand = rcu_dereference(tsk->sighand);
		if (unlikely(sighand == NULL)) {
			rcu_read_unlock();
			local_irq_restore(*flags);
			break;
		}

   < Here's the critical point! >

		spin_lock(&sighand->siglock);
		if (likely(sighand == tsk->sighand)) {
			rcu_read_unlock();
			break;
		}
		spin_unlock(&sighand->siglock);
		rcu_read_unlock();
		local_irq_restore(*flags);
	}


We get the sighand with an rcu_dereference in an rcu_read_lock()
protected section, as the page its on in the slab cache can be freed
with rcu, thus we want to make sure what we get is a sighand and not
anything else. RCU protects us for this.

Now, that sighand can be freed and reallocated as another sighand,
but because it's still a sighand, the lock we are spinning on is some
sighand->lock pointer, whether it is ours or a new one.

Thus when we hit spin_lock(&sighand->siglock) it can be the sighand for
the task we want or reallocated and initialized for a new sighand, and
we are now suddenly spinning on a new lock which we would probably take.

In that case, if we take it, then sighand != tsk->sighand and we
release the lock and try again. Wow, that's very subtle :-p  The lock
was switch out right from under us.


> 
> Without looking at the code, it sounds like somebody may doing things
> to "sighand->lock->wait_list" that they shouldn't do. We've had cases
> like that before, and most of them have been changed to *not* use
> SLAB_DESTROY_BY_RCU, and instead make each individual allocation be
> RCU-free'd (which is a lot simpler to think about, because then you
> don't have the whole re-use issue).

Yes, this is exactly what happened. OK, this is an -rt only bug, not a
mainline one :-/

When we convert the spin_lock into a rtmutex, when we hit the lock and
it was contended (the task was in the process of exiting and it takes
the lock to set tsk->sighand to NULL), instead of spinning, the task
adds itself to the lock->wait_list and goes to sleep.

Now, if that lock is released and reused (I didn't trace other tasks
allocating these locks), it reinitializes the lock->wait_list. But when
the cleanup code released the lock, it woke up the task that was in
__lock_task_sighand() and that task now tries to take the lock. As the
lock is now free, it grabs it and removes itself from the
lock->wait_list. But because the lock->wait_list has been
re-initialized, it doesn't find itself on the list and we hit the bug.
This makes sense as we never crashed, we just triggered the list.h
debug warnings.

> 
> Of course, it could easily be lack of any RCU protection too. As
> mentioned, I didn't really check the code. I just wanted to clarify
> this subtlety, because while I think Oleg knows about it, maybe others
> didn't quite catch that subtlety.

At least for -rt, it seems we have to convert it that way. Anything
more complex than a simple spinning lock will trigger this bug. Can't
use normal mutexes either.

> 
> And this could easily be an RT issue, if the RT code does some
> re-initialization of the rtmutex that replaces the spinlock we have.

Yep, I believe this currently is an RT issue. But I would suggest that
sighand be freed by a normal rcu call. This reuse looks really subtle
and prone for other bugs.

Thanks for the explanation!

-- Steve
