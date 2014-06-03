Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790AbaFCSFe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:05:34 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:60202 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751607AbaFCSFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:05:33 -0400
Date: Tue, 3 Jun 2014 14:05:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603140529.048701b9@gandalf.local.home>
In-Reply-To: <20140603172632.GA27956@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
	<20140603172632.GA27956@redhat.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jun 2014 19:26:32 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 06/03, Steven Rostedt wrote:
> >
> > We were able to trigger this bug in -rt, and by review, I'm thinking
> > that this could very well be a mainline bug too. I had our QA team add
> > a trace patch to the kernel to prove my analysis, and it did.
> >
> > Here's the patch:
> >
> >  http://rostedt.homelinux.com/private/sighand-trace.patch
> >
> > Let me try to explain the bug:
> >
> >
> > 	CPU0				CPU1
> > 	----				----
> >  [ read of /proc/<pid>/stat ]
> >   get_task_struct();
> >   [...]
> > 				  [ <pid> exits ]
> > 				  [ parent does wait on <pid> ]
> > 				  wait_task_zombie()
> > 				    release_task()
> > 				      proc_flush_task()
> > 				      /* the above removes new access
> > 				         to the /proc system */
> > 				      __exit_signal()
> > 				        __cleanup_sighand(sighand);
> > 					  atomic_dec_and_test(sighand->count);
> >   do_task_stat()
> >     lock_task_sighand(task);
> >       sighand = rcu_dereference(tsk->sighand);
> >
> > 					    kmem_cache_free(sighand);
> >
> >       if (sighand != NULL)
> >         spin_lock(sighand->siglock);
> >
> >        ** BOOM! use after free **
> 
> Yes, ->sighand can be already freed at this point, but this should be
> fine because sighand_cachep is SLAB_DESTROY_BY_RCU.

Ah, I didn't notice that. This makes this even more bazaar.

You know, this code could use some comments. I may send you a patch,
because that __lock_task_sighand() is doing a lot of subtle things and
there's not a single comment explaining it :-(



> 
> That is why lock_task_sighand() does rcu_read_lock() and re-checks
> sighand == tsk->sighand after it takes ->siglock. It is fine if it was
> already freed or even reallocated via kmem_cache_alloc(sighand_cachep).
> We only need to ensure that (SLAB_DESTROY_BY_RCU should ensure this)
> this memory won't be returned to system, so this peace of memory must
> be "struct sighand" with the properly initialized ->siglock until
> rcu_read_unlock().

OK, this makes __lock_task_sighand() make some more sense.

> 
> > Seems there is no protection between reading the sighand from proc and
> > freeing it. The sighand->count is not updated, and the sighand is not
> > freed via rcu.
> 
> See above.
> 
> > One, the spinlock in -rt is an rtmutex. The list_del_entry() bug is the
> > task trying to remove itself from sighand->lock->wait_list. As the lock
> > has been freed, the list head of the rtmutex is corrupted.
> 
> looks like, SLAB_DESTROY_BY_RCU logic is broken?

Could be. I'll look to see if we didn't break something.

Thanks!

-- Steve
