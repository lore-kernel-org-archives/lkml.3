Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970AbaBJMHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 07:07:10 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:43409 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752561AbaBJMHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 07:07:07 -0500
Date: Mon, 10 Feb 2014 17:35:26 +0530
From: Gautham R Shenoy <ego@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: ego@linux.vnet.ibm.com, Oleg Nesterov <oleg@redhat.com>, paulus@samba.org,
        rusty@rustcorp.com.au, peterz@infradead.org, tglx@linutronix.de,
        akpm@linux-foundation.org, mingo@kernel.org,
        paulmck@linux.vnet.ibm.com, tj@kernel.org, walken@google.com,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        Toshi Kani <toshi.kani@hp.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH 01/51] CPU hotplug: Provide lockless versions of
	callback registration functions
Message-ID: <20140210120526.GA16263@in.ibm.com>
Reply-To: ego@linux.vnet.ibm.com
References: <20140205220251.19080.92336.stgit@srivatsabhat.in.ibm.com>
 <20140205220447.19080.9460.stgit@srivatsabhat.in.ibm.com>
 <20140206184103.GA31410@redhat.com>
 <20140207191125.GA8098@in.ibm.com>
 <52F898CB.6030900@linux.vnet.ibm.com>
 <20140210105130.GA14693@in.ibm.com>
 <52F8B3C8.4080802@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F8B3C8.4080802@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021012-0928-0000-0000-00000629BC94
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 10, 2014 at 04:41:04PM +0530, Srivatsa S. Bhat wrote:
> > ---
> [...]
> > +/* Lockdep annotations for get/put_online_cpus() and cpu_hotplug_begin/end() */
> > +#define cpuhp_lock_acquire_read() lock_map_acquire_read(&cpu_hotplug.dep_map)
> > +#define cpuhp_lock_acquire()      lock_map_acquire(&cpu_hotplug.dep_map)
> > +#define cpuhp_lock_release()      lock_map_release(&cpu_hotplug.dep_map)
> > +
> >  void get_online_cpus(void)
> >  {
> >  	might_sleep();
> >  	if (cpu_hotplug.active_writer == current)
> >  		return;
> > +	cpuhp_lock_acquire_read();
> >  	mutex_lock(&cpu_hotplug.lock);
> >  	cpu_hotplug.refcount++;
> >  	mutex_unlock(&cpu_hotplug.lock);
> > @@ -87,6 +101,7 @@ void put_online_cpus(void)
> >  	if (!--cpu_hotplug.refcount && unlikely(cpu_hotplug.active_writer))
> >  		wake_up_process(cpu_hotplug.active_writer);
> >  	mutex_unlock(&cpu_hotplug.lock);
> > +	cpuhp_lock_release();
> > 
> >  }
> >  EXPORT_SYMBOL_GPL(put_online_cpus);
> > @@ -117,6 +132,7 @@ void cpu_hotplug_begin(void)
> >  {
> >  	cpu_hotplug.active_writer = current;
> > 
> > +	cpuhp_lock_acquire();
> 
> Shouldn't we move this to _after_ the for-loop?

No if we move this to after the for-loop, we won't be able to catch
the ABBA dependency that you had mentioned earlier.

Consider the case

Thread1:                                              Thread 2:
------------------------------------------------------------------------
get_online_cpus()
// lockdep knows about this.
                                               cpu_maps_update_begin()
                                               //lockdep knows about this.

register_cpu_notifier()
|
|-> cpu_maps_update_begin()
    //lockdep knows about this. 


                                              cpu_hotplug_begin()
                                              |  
                                              |-->for(;;) {
                                                      Wait for all the
                                                      readers to exit. 
                                     
                                                      This will never
                                                      happen now and
                                                      we're stuck here
                                                      forever without
                                                      telling anyone why! 
                                                 }

					         cpuhp_lock_acquire();
                                                                        
--------------------------------------------------------------------------
> Because, that's when the
> hotplug writer is really in a state equivalent to exclusive access to the
> hotplug lock... Else, we might fool lockdep into believing that the hotplug
> writer has the lock for write, and at the same time several readers have
> the lock for read as well.. no?
> 

Well as I understand it, the purpose of lockdep annotations is to
signal the intent of acquiring a lock as opposed to reporting the
status that the lock has been acquired.

The annotation in the earlier patch is consistent with the lockdep
annotations in rwlocks. Except for the fact that the readers of
cpu_hotplug.lock can sleep having acquired the lock, there's no
difference between rwlock semantics and cpu-hotplug lock behaviour.
Both are unfair to the writer as they allow new readers to acquire the
lock as long as there's some reader which holds the lock.

--
Thanks and Regards
gautham.

