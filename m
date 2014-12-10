Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbaLJTAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:00:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932501AbaLJTAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:00:02 -0500
Date: Wed, 10 Dec 2014 19:59:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Hildenbrand <dahi@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v3] CPU hotplug: active_writer not woken up in some
	cases - deadlock
Message-ID: <20141210185909.GB15239@redhat.com>
References: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com> <20141210001239.GA516@redhat.com> <20141210085620.0c102fd9@thinkpad-w530>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141210085620.0c102fd9@thinkpad-w530>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, David Hildenbrand wrote:
>
> > Why active_writer should see .puts_pending != 0 if this is called
> > right after cpu_hotplug_begin() takes cpu_hotplug.lock but before
> > it sets TASK_UNINTERRUPTIBLE?
>
> get_online_cpus() increased the refcount.
> put_online_cpus() will increment puts_pending and trigger a wake up (if the
> lock is alread taken - might be by cpu_hotplug_begin() or by some other
> get_online_cpus()).
>
> So refcount == 1, puts_pending == 1
>
> cpu_hotplug_begin() gets the lock and sees refcount == 1 and puts_pending == 0
> or puts_pending == 1 (race with put_online_cpus()).
>
> If that answers your question :)

Sorry for confusion ;)

I meant that without mb() cpu_hotplug_begin() can miss puts_pending != 0,
so it needs set_current_state() before atomic_read().

But this doesn't matter, your v4 uses wake_up/prepare_to_wait.

> > IOW,
> > 
> > >  void cpu_hotplug_begin(void)
> > >  {
> > > +	spin_lock(&cpu_hotplug.awr_lock);
> > >  	cpu_hotplug.active_writer = current;
> > > +	spin_unlock(&cpu_hotplug.awr_lock);
> > >  
> > >  	cpuhp_lock_acquire();
> > >  	for (;;) {
> > >  		mutex_lock(&cpu_hotplug.lock);
> > > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> > 
> > don't we need set_current_state() here ?
> 
> Hm, good question, this was only a move of existing code. But I thing the
> checked variant would be better.
> 
> > 
> > Oleg.
> > 
> 
> Thanks!
> 
> David
> 

