Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab3F1KEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:04:44 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51573 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750977Ab3F1KEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:04:42 -0400
Date: Fri, 28 Jun 2013 13:04:26 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@alien8.de>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH] cpu hotplug: rework cpu_hotplug locking (was
 [LOCKDEP] cpufreq: possible circular locking dependency detected)
Message-ID: <20130628100426.GA2228@swordfish.minsk.epam.com>
References: <20130625211544.GA2270@swordfish>
 <CAKohpo=ij+LTB80FtVFQZa_4uh-fceG80GBhGnhbxKio7N-Zuw@mail.gmail.com>
 <20130628074403.GA2201@swordfish>
 <51CD57F6.9050906@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CD57F6.9050906@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (06/28/13 15:01), Srivatsa S. Bhat wrote:
> On 06/28/2013 01:14 PM, Sergey Senozhatsky wrote:
> > On (06/28/13 10:13), Viresh Kumar wrote:
> >> On 26 June 2013 02:45, Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> >>>
> >>> [   60.277396] ======================================================
> >>> [   60.277400] [ INFO: possible circular locking dependency detected ]
> >>> [   60.277407] 3.10.0-rc7-dbg-01385-g241fd04-dirty #1744 Not tainted
> >>> [   60.277411] -------------------------------------------------------
> >>> [   60.277417] bash/2225 is trying to acquire lock:
> >>> [   60.277422]  ((&(&j_cdbs->work)->work)){+.+...}, at: [<ffffffff810621b5>] flush_work+0x5/0x280
> >>> [   60.277444]
> >>> but task is already holding lock:
> >>> [   60.277449]  (cpu_hotplug.lock){+.+.+.}, at: [<ffffffff81042d8b>] cpu_hotplug_begin+0x2b/0x60
> >>> [   60.277465]
> >>> which lock already depends on the new lock.
> >>
> >> Hi Sergey,
> >>
> >> Can you try reverting this patch?
> >>
> >> commit 2f7021a815f20f3481c10884fe9735ce2a56db35
> >> Author: Michael Wang <wangyun@linux.vnet.ibm.com>
> >> Date:   Wed Jun 5 08:49:37 2013 +0000
> >>
> >>     cpufreq: protect 'policy->cpus' from offlining during __gov_queue_work()
> >>
> > 
> > Hello,
> > Yes, this helps, of course, but at the same time it returns the previous
> > problem -- preventing cpu_hotplug in some places.
> > 
> > 
> > I have a bit different (perhaps naive) RFC patch and would like to hear
> > comments.
> > 
> > 
> > 
> > The idead is to brake existing lock dependency chain by not holding
> > cpu_hotplug lock mutex across the calls. In order to detect active
> > refcount readers or active writer, refcount now may have the following
> > values:
> > 
> > -1: active writer -- only one writer may be active, readers are blocked
> >  0: no readers/writer
> >> 0: active readers -- many readers may be active, writer is blocked
> > 
> > "blocked" reader or writer goes to wait_queue. as soon as writer finishes
> > (refcount becomes 0), it wakeups all existing processes in a wait_queue.
> > reader perform wakeup call only when it sees that pending writer is present
> > (active_writer is not NULL).
> > 
> > cpu_hotplug lock now only required to protect refcount cmp, inc, dec
> > operations so it can be changed to spinlock.
> > 
> 
> Its best to avoid changing the core infrastructure in order to fix some
> call-site, unless that scenario is really impossible to handle with the
> current infrastructure.
> 
> I have a couple of suggestions below, to solve this issue, without touching
> the core hotplug code:
> 
> You can perhaps try cancelling the work item in two steps:
>   a. using cancel_delayed_work() under CPU_DOWN_PREPARE
>   b. using cancel_delayed_work_sync() under CPU_POST_DEAD
> 
> And of course, destroy the resources associated with that work (like
> the timer_mutex) only after the full tear-down.
> 
> Or perhaps you might find a way to perform the tear-down in just one step
> at the CPU_POST_DEAD stage. Whatever works correctly.
> 
> The key point here is that the core CPU hotplug code provides us with the
> CPU_POST_DEAD stage, where the hotplug lock is _not_ held. Which is exactly
> what you want in solving the issue with cpufreq.
> 

Thanks for your ideas, I'll take a look.

cpu_hotplug mutex seems to be a troubling part in several places, not only
cpufreq. for example:
	https://lkml.org/lkml/2012/12/20/357


	-ss

> Regards,
> Srivatsa S. Bhat
> 
