Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab3JASTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 14:19:14 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:39540 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751319Ab3JASTM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 14:19:12 -0400
Message-ID: <524B111F.9060003@linux.vnet.ibm.com>
Date: Tue, 01 Oct 2013 23:44:55 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
References: <20130925175055.GA25914@redhat.com> <20130928144720.GL15690@laptop.programming.kicks-ass.net> <20130928163104.GA23352@redhat.com> <7632387.20FXkuCITr@vostro.rjw.lan> <524B0233.8070203@linux.vnet.ibm.com> <20131001173615.GW3657@laptop.programming.kicks-ass.net>
In-Reply-To: <20131001173615.GW3657@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100118-5816-0000-0000-00000A2AC90B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/01/2013 11:06 PM, Peter Zijlstra wrote:
> On Tue, Oct 01, 2013 at 10:41:15PM +0530, Srivatsa S. Bhat wrote:
>> However, as Oleg said, its definitely worth considering whether this proposed
>> change in semantics is going to hurt us in the future. CPU_POST_DEAD has certainly
>> proved to be very useful in certain challenging situations (commit 1aee40ac9c
>> explains one such example), so IMHO we should be very careful not to undermine
>> its utility.
> 
> Urgh.. crazy things. I've always understood POST_DEAD to mean 'will be
> called at some time after the unplug' with no further guarantees. And my
> patch preserves that.
> 
> Its not at all clear to me why cpufreq needs more; 1aee40ac9c certainly
> doesn't explain it.
>

Sorry if I was unclear - I didn't mean to say that cpufreq needs more guarantees
than that. I was just saying that the cpufreq code would need certain additional
changes/restructuring to accommodate the change in the semantics brought about
by this patch. IOW, it won't work as it is, but it can certainly be fixed.

My other point (unrelated to cpufreq) was this: POST_DEAD of course means
that it will be called after unplug, with hotplug lock dropped. But it also
provides the guarantee (in the existing code), that a *new* hotplug operation
won't start until the POST_DEAD stage is also completed. This patch doesn't seem
to honor that part. The concern I have is in cases like those mentioned by
Oleg - say you take a lock at DOWN_PREPARE and want to drop it at POST_DEAD;
or some other requirement that makes it important to finish a full hotplug cycle
before moving on to the next one. I don't really have such a requirement in mind
at present, but I was just trying to think what we would be losing with this
change...

But to reiterate, I believe cpufreq can be reworked so that it doesn't depend
on things such as the above. But I wonder if dropping that latter guarantee
is going to be OK, going forward.

Regards,
Srivatsa S. Bhat
 
> What's wrong with leaving a cleanup handle in percpu storage and
> effectively doing:
> 
> struct cpu_destroy {
> 	void (*destroy)(void *);
> 	void *args;
> };
> 
> DEFINE_PER_CPU(struct cpu_destroy, cpu_destroy);
> 
> 	POST_DEAD:
> 	{
> 		struct cpu_destroy x = per_cpu(cpu_destroy, cpu);
> 		if (x.destroy)
> 			x.destroy(x.arg);
> 	}
> 
> POST_DEAD cannot fail; so CPU_DEAD/CPU_DOWN_PREPARE can simply assume it
> will succeed; it has to.
> 
> The cpufreq situation simply doesn't make any kind of sense to me.
> 
> 

