Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3ILSaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:30:30 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46238 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab3ILSa3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 14:30:29 -0400
Date: Thu, 12 Sep 2013 20:30:25 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [RFC] Restrict kernel spawning of threads to a specified set of
 cpus.
Message-ID: <20130912183023.GA25386@somewhere>
References: <00000140efbcb701-c26320b3-f434-4538-bc80-8e92fed6f303-000000@email.amazonses.com>
 <20130911220228.GB15367@somewhere>
 <000001411282afa6-fe9c0543-0447-492b-991e-dc8214884b88-000000@email.amazonses.com>
 <20130912141625.GA23357@somewhere>
 <00000141128d759a-44dcacb6-8f48-4f9b-8381-d14003bd6da1-000000@email.amazonses.com>
 <20130912143137.GA23839@somewhere>
 <0000014112a921ae-51d171bf-e8d4-4569-bd20-94dabda2d5ba-000000@email.amazonses.com>
 <20130912151102.GB23839@somewhere>
 <alpine.DEB.2.02.1309121030390.21473@gentwo.org>
 <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000014112d66287-d0abaeb1-71ff-48a0-8740-f984d47400a7-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 03:42:21PM +0000, Christoph Lameter wrote:
> Let me just say that the user space approach does not work because the
> kernel sets the cpumask to all and then spawns a thread f.e. for
> usermodehelper.
> 
> This mean we would have to run a daemon that keeps scanning for errand
> threads and then move them. But at that point the damage would already
> have been done. Short term threads would never be caught.
> 
> So I think the kernel based approach is unavoidable.
> 
> Look at this in kernel/kmod.c:
> 
> static int ____call_usermodehelper(void *data)
> {
>         struct subprocess_info *sub_info = data;
>         struct cred *new;
>         int retval;
> 
>         spin_lock_irq(&current->sighand->siglock);
>         flush_signal_handlers(current, 1);
>         spin_unlock_irq(&current->sighand->siglock);
> 
>         /* We can run anywhere, unlike our parent keventd(). */
>         set_cpus_allowed_ptr(current, cpu_all_mask);
> 
> 
> !!!!! No chance to catch this from user space.
> 
> 
> 
> 	....
> 
>         retval = do_execve(sub_info->path,
>                        (const char __user *const __user *)sub_info->argv,
>                            (const char __user *const __user *)sub_info->envp);
>         if (!retval)
> 
> 
> 	....
> 

Yeah, setting the threads affinity is racy from userspace in any case. By the time
one scan /proc for tasks, some others can be forked concurrently.

So yeah it's a problem in theory. Now in practice, I have yet to be convinced because
this should be solved after a few iterations in /proc in most cases.

Now the issue doesn't only concern kthreads but all tasks in the system.
If we really want to solve that race, then may be we can think of a kernel_parameter
that sets the initial affinity of init and then lets get it naturally inherited
through the whole tree.
