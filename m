Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932671AbaLJRvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 12:51:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268AbaLJRvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 12:51:45 -0500
Date: Wed, 10 Dec 2014 18:50:55 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v4] CPU hotplug: active_writer not woken up in some
	cases - deadlock
Message-ID: <20141210175055.GA11802@redhat.com>
References: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418217721-42919-1-git-send-email-dahi@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, David Hildenbrand wrote:
>
> @@ -127,20 +119,16 @@ void put_online_cpus(void)
>  {
>  	if (cpu_hotplug.active_writer == current)
>  		return;
> -	if (!mutex_trylock(&cpu_hotplug.lock)) {
> -		atomic_inc(&cpu_hotplug.puts_pending);
> -		cpuhp_lock_release();
> -		return;
> -	}
> -
> -	if (WARN_ON(!cpu_hotplug.refcount))
> -		cpu_hotplug.refcount++; /* try to fix things up */
>  
> -	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> -		wake_up_process(cpu_hotplug.active_writer);
> -	mutex_unlock(&cpu_hotplug.lock);
> -	cpuhp_lock_release();
> +	if (atomic_dec_and_test(&cpu_hotplug.refcount) &&
> +	    waitqueue_active(&cpu_hotplug.wq))
> +		wake_up(&cpu_hotplug.wq);

OK, waitqueue_active() looks safe... prepare_to_wait() has a barrier.

>  void cpu_hotplug_begin(void)
>  {
> +	DEFINE_WAIT(wait);
> +
>  	cpu_hotplug.active_writer = current;
>  
> -	cpuhp_lock_acquire();
>  	for (;;) {
> +		cpuhp_lock_acquire();

not sure I understand why did you move cpuhp_lock_acquire() into
the loop, but this is minor.

>  		mutex_lock(&cpu_hotplug.lock);
> -		apply_puts_pending(1);
> -		if (likely(!cpu_hotplug.refcount))
> +		prepare_to_wait(&cpu_hotplug.wq, &wait, TASK_UNINTERRUPTIBLE);
> +		if (likely(!atomic_read(&cpu_hotplug.refcount)))
>  			break;
> -		__set_current_state(TASK_UNINTERRUPTIBLE);
>  		mutex_unlock(&cpu_hotplug.lock);
> +		cpuhp_lock_release();
>  		schedule();
>  	}
> +
> +	finish_wait(&cpu_hotplug.wq, &wait);
>  }

This is subjective, but how about

	static bool xxx(void)
	{
		mutex_lock(&cpu_hotplug.lock);
		if (atomic_read(&cpu_hotplug.refcount) == 0)
			return true;
		mutex_unlock(&cpu_hotplug.lock);
		return false;
	}

	void cpu_hotplug_begin(void)
	{
		cpu_hotplug.active_writer = current;

		cpuhp_lock_acquire();
		wait_event(&cpu_hotplug.wq, xxx());
	}

instead?

Oleg.

