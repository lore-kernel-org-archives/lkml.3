Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab3IWOuY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 10:50:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6405 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752306Ab3IWOuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 10:50:22 -0400
X-Authority-Analysis: v=2.0 cv=fJG7LOme c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6uerBSPhkSsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rzOjJkEkrDcA:10 a=JfrnYn6hAAAA:8 a=LzSW3Tvbkn5jqZEmjMAA:9 a=CjuIK1q_8ugA:10 a=3Rfx1nUSh_UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Mon, 23 Sep 2013 10:50:17 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130923105017.030e0aef@gandalf.local.home>
In-Reply-To: <20130919143241.GB26785@twins.programming.kicks-ass.net>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
	<1378805550-29949-38-git-send-email-mgorman@suse.de>
	<20130917143003.GA29354@twins.programming.kicks-ass.net>
	<20130917162050.GK22421@suse.de>
	<20130917164505.GG12926@twins.programming.kicks-ass.net>
	<20130918154939.GZ26785@twins.programming.kicks-ass.net>
	<20130919143241.GB26785@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Sep 2013 16:32:41 +0200
Peter Zijlstra <peterz@infradead.org> wrote:


> +extern void __get_online_cpus(void);
> +
> +static inline void get_online_cpus(void)
> +{
> +	might_sleep();
> +
> +	preempt_disable();
> +	if (likely(!__cpuhp_writer || __cpuhp_writer == current))
> +		this_cpu_inc(__cpuhp_refcount);
> +	else
> +		__get_online_cpus();
> +	preempt_enable();
> +}


This isn't much different than srcu_read_lock(). What about doing
something like this:

static inline void get_online_cpus(void)
{
	might_sleep();

	srcu_read_lock(&cpuhp_srcu);
	if (unlikely(__cpuhp_writer || __cpuhp_writer != current)) {
		srcu_read_unlock(&cpuhp_srcu);
		__get_online_cpus();
		current->online_cpus_held++;
	}
}

static inline void put_online_cpus(void)
{
	if (unlikely(current->online_cpus_held)) {
		current->online_cpus_held--;
		__put_online_cpus();
		return;
	}

	srcu_read_unlock(&cpuhp_srcu);
}

Then have the writer simply do:

	__cpuhp_write = current;
	synchronize_srcu(&cpuhp_srcu);

	<grab the mutex here>

-- Steve
