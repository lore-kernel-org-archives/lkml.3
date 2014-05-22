Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754570AbaEVKIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 06:08:24 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50871 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754438AbaEVKIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 06:08:23 -0400
Date: Thu, 22 May 2014 12:08:20 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Ingo Molnar <mingo@kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] intel_rapl: Correct hotplug correction
Message-ID: <20140522100820.GE4383@pd.tnic>
References: <1400750624-19238-1-git-send-email-bp@alien8.de>
 <537DC6D2.8040305@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537DC6D2.8040305@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 03:13:46PM +0530, Srivatsa S. Bhat wrote:
> On 05/22/2014 02:53 PM, Borislav Petkov wrote:
> > From: Borislav Petkov <bp@suse.de>
> > 
> > So 009f225ef050 ("powercap, intel-rapl: Fix CPU hotplug callback
> > registration") says how get_/put_online_cpus() should be replaced with
> > this cpu_notifier_register_begin/_done().
> > 
> > But they're still there so what's up?
> > 
> 
> Ok, so I retained that because the comments in the code said that
> the caller of rapl_cleanup_data() should hold the hotplug lock.
> 
> Here is the snippet from the patch's changelog:
> 
>     ...
>     Fix the intel-rapl code in the powercap driver by using this latter form
>     of callback registration. But retain the calls to get/put_online_cpus(),
>     since they also protect the function rapl_cleanup_data(). By nesting
>     get/put_online_cpus() *inside* cpu_notifier_register_begin/done(), we avoid
>     the ABBA deadlock possibility mentioned above.

My bad, I missed that part.

> But looking closer at the code, I think the only requirement is that
> rapl_cleanup_data() should be protected against CPU hotplug, and we
> don't actually need to hold the cpu_hotplug.lock per-se.

What is the difference between "CPU hotplug" and cpu_hotplug.lock?
>From looking at the code those are two different mutexes with
cpu_hotplug.lock, i.e. get_online_cpus() having a preemption point.

And yet, you want to replace get_/put_online_cpus() with
cpu_notifier_register_begin/_done() which is kinda the same thing but
not really. The one protects against hotplug operations and the other
protects against cpu hotplug notifier registration.

Oh, and there's a third one, aliased to the notifier one, which
is "attempting to serialize the updates to cpu_online_mask &
cpu_present_mask."

So why, oh why do we need three? This is absolutely insane. Do we have
at least one sensible reason why cpu hotplug users should need to know
all that gunk?

> cpu_notifier_register_begin()/end() also provide equivalent protection
> against CPU hotplug. So we should be able to remove the get/put_online_cpus()
> from intel-rapl driver.

Btw, rapl_exit() has both calls too :-\.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
