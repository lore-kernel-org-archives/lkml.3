Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3A2GlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 01:41:22 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54887 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab3A2GlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 01:41:19 -0500
Date: Mon, 28 Jan 2013 22:40:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 4/4] rcu: Make rcutorture's shuffler task
 shuffle recently added tasks
Message-ID: <20130129064055.GU6395@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130127000435.GA1521@linux.vnet.ibm.com>
 <1359245120-2266-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1359245120-2266-4-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130127104747.GA3119@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130127104747.GA3119@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012906-7606-0000-0000-000007D10E35
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 27, 2013 at 09:47:47PM +1100, Josh Triplett wrote:
> On Sat, Jan 26, 2013 at 04:05:20PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > A number of kthreads have been added to rcutorture, but the shuffler
> > task was not informed of them, and thus did not shuffle them.  This
> > commit therefore adds the requisite shuffling.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This also makes an unrelated semantic change, and several unrelated
> whitespace changes.
> 
> > ---
> >  kernel/rcutorture.c |   24 ++++++++++++++++++++----
> >  1 files changed, 20 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> > index a583f1c..3ebc8bf 100644
> > --- a/kernel/rcutorture.c
> > +++ b/kernel/rcutorture.c
> > @@ -846,7 +846,7 @@ static int rcu_torture_boost(void *arg)
> >  		/* Wait for the next test interval. */
> >  		oldstarttime = boost_starttime;
> >  		while (ULONG_CMP_LT(jiffies, oldstarttime)) {
> > -			schedule_timeout_uninterruptible(1);
> > +			schedule_timeout_interruptible(oldstarttime - jiffies);
> 
> This change doesn't seem related, and the commit message doesn't explain
> it either.  Could you split it out into a separate commit and document
> the rationale, please?

Ah, it is related because the shuffling is trying to keep CPUs idle,
which means that we don't want all the boost kthreads waking up every
CPU every jiffy.  I agree that this is not obvious, so I have updated
the commit message to call this out.

> >  			rcu_stutter_wait("rcu_torture_boost");
> >  			if (kthread_should_stop() ||
> >  			    fullstop != FULLSTOP_DONTSTOP)
> > @@ -1318,19 +1318,35 @@ static void rcu_torture_shuffle_tasks(void)
> >  				set_cpus_allowed_ptr(reader_tasks[i],
> >  						     shuffle_tmp_mask);
> >  	}
> > -
> >  	if (fakewriter_tasks) {
> >  		for (i = 0; i < nfakewriters; i++)
> >  			if (fakewriter_tasks[i])
> >  				set_cpus_allowed_ptr(fakewriter_tasks[i],
> >  						     shuffle_tmp_mask);
> >  	}
> > -
> >  	if (writer_task)
> >  		set_cpus_allowed_ptr(writer_task, shuffle_tmp_mask);
> > -
> 
> These three whitespace changes seem unrelated as well.

Some cleanup while in the neighborhood.  ;-)

I added this to the commit message as well.

							Thanx, Paul

> >  	if (stats_task)
> >  		set_cpus_allowed_ptr(stats_task, shuffle_tmp_mask);
> > +	if (stutter_task)
> > +		set_cpus_allowed_ptr(stutter_task, shuffle_tmp_mask);
> > +	if (fqs_task)
> > +		set_cpus_allowed_ptr(fqs_task, shuffle_tmp_mask);
> > +	if (shutdown_task)
> > +		set_cpus_allowed_ptr(shutdown_task, shuffle_tmp_mask);
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +	if (onoff_task)
> > +		set_cpus_allowed_ptr(onoff_task, shuffle_tmp_mask);
> > +#endif /* #ifdef CONFIG_HOTPLUG_CPU */
> > +	if (stall_task)
> > +		set_cpus_allowed_ptr(stall_task, shuffle_tmp_mask);
> > +	if (barrier_cbs_tasks)
> > +		for (i = 0; i < n_barrier_cbs; i++)
> > +			if (barrier_cbs_tasks[i])
> > +				set_cpus_allowed_ptr(barrier_cbs_tasks[i],
> > +						     shuffle_tmp_mask);
> > +	if (barrier_task)
> > +		set_cpus_allowed_ptr(barrier_task, shuffle_tmp_mask);
> 
> The rest of this seems fine.
> 
> - Josh Triplett
> 

