Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab3JJS4l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:56:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:44049 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab3JJS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:56:40 -0400
Message-ID: <5256F766.2050300@linux.vnet.ibm.com>
Date: Fri, 11 Oct 2013 00:22:22 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 0/6] Optimize the cpu hotplug locking -v2
References: <20131008102505.404025673@infradead.org> <20131009225006.7101379c.akpm@linux-foundation.org> <20131010121908.GB28601@twins.programming.kicks-ass.net> <20131010145738.GA5167@gmail.com> <20131010152612.GA13375@redhat.com>
In-Reply-To: <20131010152612.GA13375@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13101018-4790-0000-0000-00000ABE9F34
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 08:56 PM, Oleg Nesterov wrote:
> On 10/10, Ingo Molnar wrote:
>>
>> * Peter Zijlstra <peterz@infradead.org> wrote:
>>
>>> But the thing is; our sense of NR_CPUS has shifted, where it used to be
>>> ok to do something like:
>>>
>>>   for_each_cpu()
>>>
>>> With preemption disabled; it gets to be less and less sane to do so,
>>> simply because 'common' hardware has 256+ CPUs these days. If we cannot
>>> rely on preempt disable to exclude hotplug, we must use
>>> get_online_cpus(), but get_online_cpus() is global state and thus cannot
>>> be used at any sort of frequency.
>>
>> So ... why not make it _really_ cheap, i.e. the read lock costing nothing,
>> and tie CPU hotplug to freezing all tasks in the system?
>>
>> Actual CPU hot unplugging and repluggin is _ridiculously_ rare in a
>> system, I don't understand how we tolerate _any_ overhead from this utter
>> slowpath.
> 
> Well, iirc Srivatsa (cc'ed) pointed out that some systems do cpu_down/up
> quite often to save the power.
> 

Yes, I've heard of such systems and so I might have brought them up during
discussions about CPU hotplug. But unfortunately, I have been misquoted quite
often, leading to the wrong impression that I have such a usecase or that I
recommend/support using CPU hotplug for power management. So let me clarify
that part, while I have the chance. (And I don't blame anyone for that. I
work on power-management related areas, and I've worked on improving/optimizing
CPU hotplug; so its pretty natural to make a connection between the two
and assume that I tried to optimize CPU hotplug keeping power management
in mind. But that's not the case, as I explain below.)

I started out trying to make suspend/resume more reliable, scalable and fast.
And suspend/resume uses CPU hotplug underneath and that's a pretty valid usecase.
So with that, I started looking at CPU hotplug and soon realized the mess it
had become. So I started working on cleaning up that mess, like rethinking the
whole notifier scheme[1], and removing the ridiculous stop_machine() from the
cpu_down path[2] etc. But the intention behind all this work was just to make
CPU hotplug cleaner/saner/bug-free and possibly speed up suspend/resume. IOW,
I didn't have any explicit intention to make it easier for people to use it
for power management, although I understood that some of this work might
help those poor souls who don't have any other choice, for whatever reason.
And fortunately, (IIUC) the number of systems/people relying on CPU hotplug for
power management has reduced quite a bit in the recent times, which is a very
good thing.

So, to reiterate, I totally agree that power-aware scheduler is the right way
to do CPU power management; CPU hotplug is simply not the tool to use for that.
No question about that. Also, system shutdown used to depend on CPU hotplug to
disable the non-boot CPUs, but we don't do that any more after commit cf7df378a,
which is a very welcome change. And in future if we can somehow do suspend/resume
without using CPU hotplug, that would be absolutely wonderful as well. (There
have been discussions in the past around this, but nobody has a solution yet).
The other valid usecases that I can think of, for using CPU hotplug, is for RAS
reasons and for DLPAR (Dynamic Logical Partitioning) operations on powerpc, both
of which are not performance-sensitive, AFAIK.


[1]. Reverse invocation of CPU hotplug notifiers
     http://lwn.net/Articles/508072/

[2]. Stop-machine()-free CPU hotplug
     http://lwn.net/Articles/538819/ (v6)
     http://lwn.net/Articles/556727/

Regards,
Srivatsa S. Bhat

