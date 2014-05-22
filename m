Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbaEVVcY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:32:24 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:59453 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbaEVVcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:32:22 -0400
Message-ID: <537E6C9F.5060406@linux.vnet.ibm.com>
Date: Fri, 23 May 2014 03:01:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Borislav Petkov <bp@alien8.de>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "ego@linux.vnet.ibm.com" <ego@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH] intel_rapl: Correct hotplug correction
References: <1400750624-19238-1-git-send-email-bp@alien8.de> <537DC6D2.8040305@linux.vnet.ibm.com> <20140522100820.GE4383@pd.tnic> <537DE579.6000505@linux.vnet.ibm.com> <20140522123251.GU30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140522123251.GU30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052221-3864-0000-0000-00000E5D97CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2014 06:02 PM, Peter Zijlstra wrote:
> On Thu, May 22, 2014 at 05:24:33PM +0530, Srivatsa S. Bhat wrote:
>> Yeah, its complicated and perhaps we can do much better than that. But I'll
>> try to explain why there are so many different locks in the existing code.
>>
[...]
> 
> So I think we can reduce it to just the one rwsem (with recursion) if we
> shoot CPU_POST_DEAD in the head.
> 

Ok, I'll take a look at the cpufreq core and see how we can get rid of the
POST_DEAD case there. I myself had added that (sorry!) to solve a complicated
deadlock involving a race between CPU offline and a task writing to one of
the cpufreq sysfs files. The sysfs writer task would increment the kobject
refcount and call get_online_cpus(), whereas the CPU offline task would wait
for the kobj refcount to drop to zero, while still holding the hotplug lock.
Thus the 2 tasks would end up waiting on each other indefinitely.

So using POST_DEAD had enabled us to wait for the refcount to drop to zero
without holding the hotplug lock, which allowed the sysfs writer to get
past get_online_cpus(), finish its job and finally drop the refcount.

Anyway, I'll take a fresh look to see if we can overcome that problem in
some other way.

> Because currently we cannot take the rwsem in exclusive mode over the
> whole thing because of POST_DEAD.
> 
> Once we kill that, the hotplug lock's exclusive mode can cover the
> entire hotplug operation.
> 
> For (un)registrer we can also use the exclusive lock, (un)register of
> notifiers should not happen often and should equally not be performance
> critical, so using the exclusive lock should be just fine.
> 
> That means we can then remove cpu_add_remove_lock from both the register
> and hotplug ops proper. (un)register_cpu_notifier() should get an
> assertion that we hold the hotplug lock in exclusive mode.
> 
> That leaves the non-exclusive lock to guard against hotplug happening.
> 
> Now, last time Linus said he would like that to be a non-lock, and have
> it weakly serialized, RCU style. Not sure we can fully pull that off,
> haven't throught that through yet.

Thank you for explanation!

> 
>> I think Oleg had a proposed patch to use per-cpu rwsem in CPU hotplug to
>> drastically simplify this whole locking scheme. I think we could look at
>> that again.
> 
> I don't think that was to simplify things, the hotplug lock is basically
> an open coded rw lock already, so that was to make it reuse the per-cpu
> rwsem code.
> 

Ah, ok!

Regards,
Srivatsa S. Bhat

