Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaLJTVq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:21:46 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:59236 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaLJTVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:21:45 -0500
Date: Wed, 10 Dec 2014 20:21:36 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v4] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141210202136.2c41d678@thinkpad-w530>
In-Reply-To: <20141210175055.GA11802@redhat.com>
References: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141210175055.GA11802@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121019-0017-0000-0000-000002294D1D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/10, David Hildenbrand wrote:
> >
> > @@ -127,20 +119,16 @@ void put_online_cpus(void)
> >  {
> >  	if (cpu_hotplug.active_writer == current)
> >  		return;
> > -	if (!mutex_trylock(&cpu_hotplug.lock)) {
> > -		atomic_inc(&cpu_hotplug.puts_pending);
> > -		cpuhp_lock_release();
> > -		return;
> > -	}
> > -
> > -	if (WARN_ON(!cpu_hotplug.refcount))
> > -		cpu_hotplug.refcount++; /* try to fix things up */
> >  
> > -	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> > -		wake_up_process(cpu_hotplug.active_writer);
> > -	mutex_unlock(&cpu_hotplug.lock);
> > -	cpuhp_lock_release();
> > +	if (atomic_dec_and_test(&cpu_hotplug.refcount) &&
> > +	    waitqueue_active(&cpu_hotplug.wq))
> > +		wake_up(&cpu_hotplug.wq);
> 
> OK, waitqueue_active() looks safe... prepare_to_wait() has a barrier.
> 
> >  void cpu_hotplug_begin(void)
> >  {
> > +	DEFINE_WAIT(wait);
> > +
> >  	cpu_hotplug.active_writer = current;
> >  
> > -	cpuhp_lock_acquire();
> >  	for (;;) {
> > +		cpuhp_lock_acquire();
> 
> not sure I understand why did you move cpuhp_lock_acquire() into
> the loop, but this is minor.

Well I got some lockdep issues and this way I was able to solve them.
(complain about same thread that called cpu_hotplug_begin() calling
put_online_cpus(), so we have to correctly tell lockdep when we get an release
the lock).

So I guess I also need that in the loop, or am I wrong (due to
cpuhp_lock_release())?

> 
> >  		mutex_lock(&cpu_hotplug.lock);
> > -		apply_puts_pending(1);
> > -		if (likely(!cpu_hotplug.refcount))
> > +		prepare_to_wait(&cpu_hotplug.wq, &wait, TASK_UNINTERRUPTIBLE);
> > +		if (likely(!atomic_read(&cpu_hotplug.refcount)))
> >  			break;
> > -		__set_current_state(TASK_UNINTERRUPTIBLE);
> >  		mutex_unlock(&cpu_hotplug.lock);
> > +		cpuhp_lock_release();
> >  		schedule();
> >  	}
> > +
> > +	finish_wait(&cpu_hotplug.wq, &wait);
> >  }
> 
> This is subjective, but how about
> 
> 	static bool xxx(void)
> 	{
> 		mutex_lock(&cpu_hotplug.lock);
> 		if (atomic_read(&cpu_hotplug.refcount) == 0)
> 			return true;
> 		mutex_unlock(&cpu_hotplug.lock);
> 		return false;
> 	}
> 
> 	void cpu_hotplug_begin(void)
> 	{
> 		cpu_hotplug.active_writer = current;
> 
> 		cpuhp_lock_acquire();
> 		wait_event(&cpu_hotplug.wq, xxx());
> 	}
> 
> instead?
> 

What I don't like about that suggestion is that the mutex_lock() happens in
another level of indirection, so by looking at cpu_hotplug_begin() it isn't
obvious that that lock remains locked after this function has been called.

On the other hand this is really a compact one (+ possibly lockdep
annotations) :) .

> Oleg.
> 

It is important that we do the state change to TASK_UNINTERRUPTIBLE prior to
checking for the condition.

Is it guaranteed with wait_event() that things like the following won't happen?

1. CPU1 wakes up the wq (refcount == 0)
2. CPU2 calls get_online_cpus() and increments refcount. (refcount == 1)
2. CPU3 executes xxx() up to "return false;" and gets scheduled away
3. CPU2 calls put_online_cpus(), decrementing the refcount (refcount == 0)
   -> waitqueue not active -> no wake up
4. CPU3 continues executing and sleeps
-> refcount == 0 but writer is not woken up

Saying, does wait_event() take care wakeups while executing xxx()?
(w.g. activating the wait queue, setting TASK_UNINTERRUPTIBLE just before
calling xxx())

In my code, this is guaranteed by calling
prepare_to_wait(&cpu_hotplug.wq, &wait, TASK_UNINTERRUPTIBLE); prior to checking for the condition.

If that is guaranteed, this would work. Will verify that tomorrow.

Thanks a lot!

David

