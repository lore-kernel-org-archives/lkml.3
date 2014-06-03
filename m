Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752081AbaFCR1w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:27:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38061 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751578AbaFCR1v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:27:51 -0400
Date: Tue, 3 Jun 2014 19:26:32 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603172632.GA27956@redhat.com>
References: <20140603130233.658a6a3c@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140603130233.658a6a3c@gandalf.local.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03, Steven Rostedt wrote:
>
> We were able to trigger this bug in -rt, and by review, I'm thinking
> that this could very well be a mainline bug too. I had our QA team add
> a trace patch to the kernel to prove my analysis, and it did.
>
> Here's the patch:
>
>  http://rostedt.homelinux.com/private/sighand-trace.patch
>
> Let me try to explain the bug:
>
>
> 	CPU0				CPU1
> 	----				----
>  [ read of /proc/<pid>/stat ]
>   get_task_struct();
>   [...]
> 				  [ <pid> exits ]
> 				  [ parent does wait on <pid> ]
> 				  wait_task_zombie()
> 				    release_task()
> 				      proc_flush_task()
> 				      /* the above removes new access
> 				         to the /proc system */
> 				      __exit_signal()
> 				        __cleanup_sighand(sighand);
> 					  atomic_dec_and_test(sighand->count);
>   do_task_stat()
>     lock_task_sighand(task);
>       sighand = rcu_dereference(tsk->sighand);
>
> 					    kmem_cache_free(sighand);
>
>       if (sighand != NULL)
>         spin_lock(sighand->siglock);
>
>        ** BOOM! use after free **

Yes, ->sighand can be already freed at this point, but this should be
fine because sighand_cachep is SLAB_DESTROY_BY_RCU.

That is why lock_task_sighand() does rcu_read_lock() and re-checks
sighand == tsk->sighand after it takes ->siglock. It is fine if it was
already freed or even reallocated via kmem_cache_alloc(sighand_cachep).
We only need to ensure that (SLAB_DESTROY_BY_RCU should ensure this)
this memory won't be returned to system, so this peace of memory must
be "struct sighand" with the properly initialized ->siglock until
rcu_read_unlock().

> Seems there is no protection between reading the sighand from proc and
> freeing it. The sighand->count is not updated, and the sighand is not
> freed via rcu.

See above.

> One, the spinlock in -rt is an rtmutex. The list_del_entry() bug is the
> task trying to remove itself from sighand->lock->wait_list. As the lock
> has been freed, the list head of the rtmutex is corrupted.

looks like, SLAB_DESTROY_BY_RCU logic is broken?

Oleg.

