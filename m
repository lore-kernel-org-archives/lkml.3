Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab3IXQnq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:43:46 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14493 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574Ab3IXQnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:43:45 -0400
X-Authority-Analysis: v=2.0 cv=LYm+G0ji c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=6uerBSPhkSsA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=rzOjJkEkrDcA:10 a=20KFwNOVAAAA:8 a=TjSqwAcOZwPWnt3izXcA:9 a=CjuIK1q_8ugA:10 a=jEp0ucaQiEUA:10 a=5Au0VPIJt5UA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Tue, 24 Sep 2013 12:43:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] hotplug: Optimize {get,put}_online_cpus()
Message-ID: <20130924124341.64d57912@gandalf.local.home>
In-Reply-To: <20130924160359.GA2739@redhat.com>
References: <1378805550-29949-1-git-send-email-mgorman@suse.de>
	<1378805550-29949-38-git-send-email-mgorman@suse.de>
	<20130917143003.GA29354@twins.programming.kicks-ass.net>
	<20130917162050.GK22421@suse.de>
	<20130917164505.GG12926@twins.programming.kicks-ass.net>
	<20130918154939.GZ26785@twins.programming.kicks-ass.net>
	<20130919143241.GB26785@twins.programming.kicks-ass.net>
	<20130923175052.GA20991@redhat.com>
	<20130924123821.GT12926@twins.programming.kicks-ass.net>
	<20130924160359.GA2739@redhat.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Sep 2013 18:03:59 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> On 09/24, Peter Zijlstra wrote:
> >
> > +static inline void get_online_cpus(void)
> > +{
> > +	might_sleep();
> > +
> > +	if (current->cpuhp_ref++) {
> > +		barrier();
> > +		return;
> 
> I don't undestand this barrier()... we are going to return if we already
> hold the lock, do we really need it?

I'm confused too. Unless gcc moves this after the release, but the
release uses preempt_disable() which is its own barrier.

If anything, it requires a comment.

-- Steve

> 
> The same for put_online_cpus().
> 
> > +void __get_online_cpus(void)
> >  {
> > -	if (cpu_hotplug.active_writer == current)
> > +	if (cpuhp_writer_task == current)
> >  		return;
> 
