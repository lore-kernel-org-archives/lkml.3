Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab3F2Sxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 14:53:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:38921 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752098Ab3F2Sxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 14:53:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,967,1363158000"; 
   d="scan'208";a="261798926"
Message-ID: <51CF2C88.4030900@linux.intel.com>
Date: Sat, 29 Jun 2013 21:50:48 +0300
From: Eliezer Tamir <eliezer.tamir@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Eric Dumazet <erdnetdev@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        HPA <hpa@zytor.com>, Cody P Schafer <devel-lists@codyps.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: Using sched_clock() for polling time limit
References: <20130628125918.14419.36214.stgit@ladj378.jer.intel.com>  <20130628125926.14419.89905.stgit@ladj378.jer.intel.com> <1372438309.1937.9.camel@bwh-desktop.uk.level5networks.com>
In-Reply-To: <1372438309.1937.9.camel@bwh-desktop.uk.level5networks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/06/2013 19:51, Ben Hutchings wrote:
> On Fri, 2013-06-28 at 15:59 +0300, Eliezer Tamir wrote:
>> Our use of sched_clock is OK because we don't mind the side effects
>> of calling it and occasionally waking up on a different CPU.
>
> Sure about that?  Jitter matters too.
>
Pretty sure, this is a limit on how long we poll, it's for fairness to
the rest of the system not for performance of this code.

What matters is that on average you are bounded by something close to
what the user specified. If once in a while you run less because of
clock jitter, or even twice the specified time, it's no big deal.

So I don't see how jitter would matter.

And if your workload is jitter sensitive, you should probably be
pinning tasks to CPUs anyway.


>> When CONFIG_DEBUG_PREEMPT is on, disable preempt before calling
>> sched_clock() so we don't trigger a debug_smp_processor_id() warning.
> [...]
>
> I think this is papering over a problem.  The warning is there for a
> good reason.

I think we understand the warning, and that we are OK with the effects.

looking at how other users in the kernel solved this issue
It seems like this is what they do.
for example trace/ring_buffer.c:ring_buffer_time_Stamp()

Also kvm_clock_read() and xen_clokcsource_read() seem to disable preempt
just to silence this warning.

If they really cared about reading the value on one CPU, then being
scheduled on another they should have disabled interrupts.
or am I missing something?

> Would functions like these make it possible to use sched_clock() safely
> for polling?  (I didn't spend much time thinking about the names.)
>
> struct sched_timestamp {
> 	int cpu;
> 	unsigned long long clock;
> };
>
> static inline struct sched_timestamp sched_get_timestamp(void)
> {
> 	struct sched_timestamp ret;
>
> 	preempt_disable_notrace();
> 	ret.cpu = smp_processor_id();
> 	ret.clock = sched_clock();
> 	preempt_enable_no_resched_notrace();
>
> 	return ret;
> }

I don't understand, preempt_disable() only makes prevents preempt
from taking the CPU away from you, you could still lose it for
other reasons.
You would really need to disable interrupts in this region to be
sure that it all executed on the same CPU.

-Eliezer
