Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751505AbaJYWTX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 18:19:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:51284 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaJYWTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 18:19:22 -0400
Date: Sun, 26 Oct 2014 00:19:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Friesen <chris.friesen@windriver.com>
cc: rt-users <linux-rt-users@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: semantics of reader/writer semaphores in rt patch
In-Reply-To: <544956B8.2000406@windriver.com>
Message-ID: <alpine.DEB.2.11.1410252354030.5308@nanos>
References: <544956B8.2000406@windriver.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Oct 2014, Chris Friesen wrote:

> I recently noticed that when CONFIG_PREEMPT_RT_FULL is enabled we the
> semantics change.  From "include/linux/rwsem_rt.h":
> 
>  * Note that the semantics are different from the usual
>  * Linux rw-sems, in PREEMPT_RT mode we do not allow
>  * multiple readers to hold the lock at once, we only allow
>  * a read-lock owner to read-lock recursively. This is
>  * better for latency, makes the implementation inherently
>  * fair and makes it simpler as well.
> 
> How is this valid?  It seems to me that there are any number of code paths
> that could depend on having multiple threads of execution be able to hold the
> reader lock simultaneously.  Something as simple as:
> 
> thread A:
> take rw_semaphore X for reading
> take lock Y, modify data, release lock Y
> wake up thread B
> wait on conditional protected by lock Y
> free rw_semaphore X
> 
> thread B:
> take rw_semaphore X for reading
> wait on conditional protected by lock Y
> send message to wake up thread A
> free rw_semaphore X

I don't see why B should wake A without changing the conditional. A
won't make progress by being woken by B as the conditional does not
magically change just because B wakes A.

So what you wanted to say is:

  thread B:
  take rw_semaphore X for reading
  wait on conditional protected by lock Y
+ take lock Y, modify data, release lock Y
  send message to wake up thread A
  free rw_semaphore X

Otherwise your example does not make any sense at all. And that has
some serious non RT related implications.

> In the regular kernel this would work, in the RT kernel it would deadlock.

Works by some definition of 'works'
 
> Does the RT kernel just disallow this sort of algorithm?

Yes. For a good reason. Let's add thread C

A    	   	B		C
down_read(X)
				down_write(X)
lock(Y)
modify data
unlock(Y)
wake(B)
		down_read(X)

Due to the mainline rwsem fairness semantics:

A holds X, C is blocked on A and B is blocked on A.

Deadlock, without RT and the single reader restriction being involved.

So RT does not violate ANY of the existing mainline semantics, it just
imposes a performance impact of not allowing multiple readers.

Aside of that it provides as usual the free of charge service to
expose mainline bugs faster.

Yes, it's valid and not that simple as you might think.

Thanks,

	tglx


