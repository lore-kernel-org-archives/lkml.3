Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab3F1ORO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 10:17:14 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44505 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab3F1ORL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 10:17:11 -0400
Message-ID: <51CD9A1A.1060908@linux.vnet.ibm.com>
Date: Fri, 28 Jun 2013 19:43:46 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
CC: Viresh Kumar <viresh.kumar@linaro.org>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH] cpu hotplug: rework cpu_hotplug locking (was [LOCKDEP]
 cpufreq: possible circular locking dependency detected)
References: <20130625211544.GA2270@swordfish> <CAKohpo=ij+LTB80FtVFQZa_4uh-fceG80GBhGnhbxKio7N-Zuw@mail.gmail.com> <20130628074403.GA2201@swordfish>
In-Reply-To: <20130628074403.GA2201@swordfish>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13062814-4790-0000-0000-000009067D5A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2013 01:14 PM, Sergey Senozhatsky wrote:
> Hello,
> Yes, this helps, of course, but at the same time it returns the previous
> problem -- preventing cpu_hotplug in some places.
> 
> 
> I have a bit different (perhaps naive) RFC patch and would like to hear
> comments.
> 
> 
> 
> The idead is to brake existing lock dependency chain by not holding
> cpu_hotplug lock mutex across the calls. In order to detect active
> refcount readers or active writer, refcount now may have the following
> values:
> 
> -1: active writer -- only one writer may be active, readers are blocked
>  0: no readers/writer
>> 0: active readers -- many readers may be active, writer is blocked
> 
> "blocked" reader or writer goes to wait_queue. as soon as writer finishes
> (refcount becomes 0), it wakeups all existing processes in a wait_queue.
> reader perform wakeup call only when it sees that pending writer is present
> (active_writer is not NULL).
> 
> cpu_hotplug lock now only required to protect refcount cmp, inc, dec
> operations so it can be changed to spinlock.
> 

Hmm, now that I actually looked at your patch, I see that it is completely
wrong! I'm sure you intended to fix the *bug*, but instead you ended
up merely silencing the *warning* (and also left lockdep blind), leaving
the actual bug as it is!

So let me summarize what the actual bug is and what is it that actually
needs fixing:

Basically you have 2 things -
1. A worker item (cs_dbs_timer in this case) that can re-arm itself
   using gov_queue_work(). And gov_queue_work() uses get/put_online_cpus().

2. In the cpu_down() path, you want to cancel the worker item and destroy
   and cleanup its resources (the timer_mutex).

So the problem is that you can deadlock like this:

    CPU 3                                  CPU 4

   cpu_down()
   -> acquire hotplug.lock

				      cs_dbs_timer()
				        -> get_online_cpus()
					   //wait on hotplug.lock


   try to cancel cs_dbs_timer()
   synchronously.

That leads to a deadlock, because, cs_dbs_timer() is waiting to
get the hotplug lock which CPU 3 is holding, whereas CPU 3 is
waiting for cs_dbs_timer() to finish. So they can end up mutually
waiting for each other, forever. (Yeah, the lockdep splat might have
been a bit cryptic to decode this, but here it is).

So to fix the *bug*, you need to avoid waiting synchronously while
holding the hotplug lock. Possibly by using cancel_delayed_work_sync()
under CPU_POST_DEAD or something like that. That would remove the deadlock
possibility.

Your patch, on the other hand, doesn't remove the deadlock possibility:
just because you don't hold the lock throughout the hotplug operation
doesn't mean that the task calling get_online_cpus() can sneak in and
finish its work in-between a hotplug operation (because the refcount
won't allow it to). Also, it should *not* be allowed to sneak in like
that, since that constitutes *racing* with CPU hotplug, which it was
meant to avoid!.

Also, as a side effect of not holding the lock throughout the hotplug
operation, lockdep goes blind, and doesn't complain, even though the
actual bug is still there! Effectively, this is nothing but papering
over the bug and silencing the warning, which we should never do.

So, please, fix the _cpufreq_ code to resolve the deadlock.

Regards,
Srivatsa S. Bhat

