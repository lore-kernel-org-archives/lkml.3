Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab3JARgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 13:36:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55696 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3JARgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 13:36:35 -0400
Date: Tue, 1 Oct 2013 19:36:15 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Oleg Nesterov <oleg@redhat.com>,
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
Message-ID: <20131001173615.GW3657@laptop.programming.kicks-ass.net>
References: <20130925175055.GA25914@redhat.com>
 <20130928144720.GL15690@laptop.programming.kicks-ass.net>
 <20130928163104.GA23352@redhat.com>
 <7632387.20FXkuCITr@vostro.rjw.lan>
 <524B0233.8070203@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <524B0233.8070203@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 01, 2013 at 10:41:15PM +0530, Srivatsa S. Bhat wrote:
> However, as Oleg said, its definitely worth considering whether this proposed
> change in semantics is going to hurt us in the future. CPU_POST_DEAD has certainly
> proved to be very useful in certain challenging situations (commit 1aee40ac9c
> explains one such example), so IMHO we should be very careful not to undermine
> its utility.

Urgh.. crazy things. I've always understood POST_DEAD to mean 'will be
called at some time after the unplug' with no further guarantees. And my
patch preserves that.

Its not at all clear to me why cpufreq needs more; 1aee40ac9c certainly
doesn't explain it.

What's wrong with leaving a cleanup handle in percpu storage and
effectively doing:

struct cpu_destroy {
	void (*destroy)(void *);
	void *args;
};

DEFINE_PER_CPU(struct cpu_destroy, cpu_destroy);

	POST_DEAD:
	{
		struct cpu_destroy x = per_cpu(cpu_destroy, cpu);
		if (x.destroy)
			x.destroy(x.arg);
	}

POST_DEAD cannot fail; so CPU_DEAD/CPU_DOWN_PREPARE can simply assume it
will succeed; it has to.

The cpufreq situation simply doesn't make any kind of sense to me.


