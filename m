Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933286Ab3GLPoR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 11:44:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:26282 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932970Ab3GLPoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 11:44:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,653,1367996400"; 
   d="scan'208";a="364339186"
Message-ID: <51E0244E.4090909@linux.intel.com>
Date: Fri, 12 Jul 2013 08:44:14 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "alex.shi@intel.com" <alex.shi@intel.com>,
        "efault@gmx.de" <efault@gmx.de>, "pjt@google.com" <pjt@google.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [RFC][PATCH 0/9] sched: Power scheduler design proposal
References: <1373385338-12983-1-git-send-email-morten.rasmussen@arm.com> <51DC414F.5050900@linux.intel.com> <20130710111627.GC15989@e103687> <51DD5BFC.8000102@linux.intel.com> <20130712130021.GC28271@arm.com>
In-Reply-To: <20130712130021.GC28271@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But on x86 you still have a P-state hint for the CPU and the scheduler
> could at least hope for more CPU performance. We can make the power
> scheduler ask the power driver for an increase or decrease of
> performance (as Preeti suggested) and give it the current load as
> argument rather than a precise performance/frequency level. The power
> driver would change the P-state accordingly and take the load into
> account (or ignore it, something like intel_pstate.c can do its own
> aperf/mperf tracking). But the power driver will inform the scheduler
> that it can't change the P-state further and the power scheduler can
> decide to spread the load out to other CPUs.


I am completely fine with an interface that is something like

void arch_please_go_faster(int cpunr);
void arch_please_go_fastest(int cpunr);
int arch_can_you_go_faster_than_now(int cpunr);

(maybe without the arguments and only make it for the local cpu, that would
make the implementation surely simpler)

with the understanding that these are instant requests (e.g. longer term policy will
clobber requests eventually).

it makes total sense to me for the scheduler to indicate "I need performance NOW".
Either when it sees it's on the verge of needing to load balance, or when it is about to schedule
a high priority (think realtime) task.

Part of the reason I like such interface is that it is a higher level one, it's a clear and high level enough
policy request that the hardware driver can translate into a hardware specific thing.

An interface that would be "put it at THIS much" is not. It's too low level and makes assumptions about
hardware things that change between generations/vendors that the scheduler really shouldn't know about.


