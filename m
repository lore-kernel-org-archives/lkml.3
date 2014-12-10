Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbaLJH4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:56:36 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:49428 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753590AbaLJH4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:56:35 -0500
Date: Wed, 10 Dec 2014 08:56:20 +0100
From: David Hildenbrand <dahi@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, heiko.carstens@de.ibm.com,
        borntraeger@de.ibm.com, rafael.j.wysocki@intel.com,
        paulmck@linux.vnet.ibm.com, peterz@infradead.org, bp@suse.de,
        jkosina@suse.cz
Subject: Re: [PATCH v3] CPU hotplug: active_writer not woken up in some
 cases - deadlock
Message-ID: <20141210085620.0c102fd9@thinkpad-w530>
In-Reply-To: <20141210001239.GA516@redhat.com>
References: <1418127811-22629-1-git-send-email-dahi@linux.vnet.ibm.com>
	<20141210001239.GA516@redhat.com>
Organization: IBM Deutschland GmbH
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121007-0009-0000-0000-00000251B19D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (sorry if this was already discussed, I ignored most of my emails
>  I got this week)
> 
> On 12/09, David Hildenbrand wrote:
> >
> > @@ -116,7 +118,13 @@ void put_online_cpus(void)
> >  	if (cpu_hotplug.active_writer == current)
> >  		return;
> >  	if (!mutex_trylock(&cpu_hotplug.lock)) {
> > +		/* inc before testing for active_writer to not lose wake ups */
> >  		atomic_inc(&cpu_hotplug.puts_pending);
> > +		spin_lock(&cpu_hotplug.awr_lock);
> > +		/* we might be the last one */
> > +		if (unlikely(cpu_hotplug.active_writer))
> > +			wake_up_process(cpu_hotplug.active_writer);
> > +		spin_unlock(&cpu_hotplug.awr_lock);
> 
> Not sure I understand. awr_lock can only ensure that active_writer
> can't go away.

This solution is not optimal but works without races ... I'll try to get
something with wait queues running and/or even change the way refcount is
accessed as suggested by you.

And yes, awr_lock will only ensure that active_writer won't go away.

> 
> Why active_writer should see .puts_pending != 0 if this is called
> right after cpu_hotplug_begin() takes cpu_hotplug.lock but before
> it sets TASK_UNINTERRUPTIBLE?

get_online_cpus() increased the refcount.
put_online_cpus() will increment puts_pending and trigger a wake up (if the
lock is alread taken - might be by cpu_hotplug_begin() or by some other
get_online_cpus()).

So refcount == 1, puts_pending == 1

cpu_hotplug_begin() gets the lock and sees refcount == 1 and puts_pending == 0
or puts_pending == 1 (race with put_online_cpus()).

If that answers your question :)

> 
> IOW,
> 
> >  void cpu_hotplug_begin(void)
> >  {
> > +	spin_lock(&cpu_hotplug.awr_lock);
> >  	cpu_hotplug.active_writer = current;
> > +	spin_unlock(&cpu_hotplug.awr_lock);
> >  
> >  	cpuhp_lock_acquire();
> >  	for (;;) {
> >  		mutex_lock(&cpu_hotplug.lock);
> > +		__set_current_state(TASK_UNINTERRUPTIBLE);
> 
> don't we need set_current_state() here ?

Hm, good question, this was only a move of existing code. But I thing the
checked variant would be better.

> 
> Oleg.
> 

Thanks!

David

