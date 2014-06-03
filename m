Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965563AbaFCRCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 13:02:37 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:9904 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932714AbaFCRCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 13:02:35 -0400
Date: Tue, 3 Jun 2014 13:02:33 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Clark Williams <williams@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [BUG] signal: sighand unprotected when accessed by /proc
Message-ID: <20140603130233.658a6a3c@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were able to trigger this bug in -rt, and by review, I'm thinking
that this could very well be a mainline bug too. I had our QA team add
a trace patch to the kernel to prove my analysis, and it did.

Here's the patch:

 http://rostedt.homelinux.com/private/sighand-trace.patch

Let me try to explain the bug:


	CPU0				CPU1
	----				----
 [ read of /proc/<pid>/stat ]
  get_task_struct();
  [...]
				  [ <pid> exits ]
				  [ parent does wait on <pid> ]
				  wait_task_zombie()
				    release_task()
				      proc_flush_task()
				      /* the above removes new access
				         to the /proc system */
				      __exit_signal()
				        __cleanup_sighand(sighand);
					  atomic_dec_and_test(sighand->count);
  do_task_stat()
    lock_task_sighand(task);
      sighand = rcu_dereference(tsk->sighand);

					    kmem_cache_free(sighand);

      if (sighand != NULL)
        spin_lock(sighand->siglock);

       ** BOOM! use after free **


Seems there is no protection between reading the sighand from proc and
freeing it. The sighand->count is not updated, and the sighand is not
freed via rcu.  Wouldn't matter, because the use of sighand is not
totally protected by rcu.

We take a lot of care to free tsk->signal but we are a bit sloppy in
protecting sighand.

Here's the trace from our last crash:

      ps-23716   1....... 11201242344176: __lock_task_sighand: lock sighand=ffff8801022aee80 from sh:23718
    make-23672   1.....11 11201242409218: release_task: freeing sighand ffff8801022aee80 for sh:23718
    make-23672   1.....11 11201242409980: __cleanup_sighand: free sighand ffff8801022aee80
    make-23672   1.....11 11201242410380: __cleanup_sighand: sighand ffff8801022aee80 freed
      ps-23716   1d...211 11201243007052: __list_del_entry: BUG HIT!

Let me explain the differences between -rt and mainline here.

One, the spinlock in -rt is an rtmutex. The list_del_entry() bug is the
task trying to remove itself from sighand->lock->wait_list. As the lock
has been freed, the list head of the rtmutex is corrupted.

Another difference here is that all this ran on CPU 1. In mainline,
that could not happen because the spinlock prevents preemption. But
still, I don't see anything that could stop this from happening on
multiple CPUs.

Again, the bug does exist in mainline. I believe the only reason that
we do not trigger it (often) is that there's a lot that the reading of
the proc needs to do between opening the proc files and then reading
the sighand->lock. Much more than the clean up path between
removing /proc and freeing sighand. But with an interrupt going off at
the right time slowing down the fast path, we can still hit this race.

This is the beauty of the -rt patch. It can simulate hard to hit races
nicely, due to the preemptive nature of the spinlocks.

I do not see any trivial fix for this. I figured I show this to the
signal gurus before trying to redesign the way sighand gets freed or
used by /proc.

-- Steve

  
