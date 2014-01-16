Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaAPCYF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 21:24:05 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44298 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaAPCYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 21:24:03 -0500
Date: Wed, 15 Jan 2014 18:23:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/timers 2/4] timers: Reduce __run_timers()
 latency for empty list
Message-ID: <20140116022356.GR10038@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140115051939.GA31164@linux.vnet.ibm.com>
 <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1389763248-31297-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140115203354.GC11147@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140115203354.GC11147@jtriplet-mobl1>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011602-0928-0000-0000-000005749049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 12:33:55PM -0800, Josh Triplett wrote:
> On Tue, Jan 14, 2014 at 09:20:46PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > The __run_timers() function currently steps through the list one jiffy at
> > a time in order to update the timer wheel.  However, if the timer wheel
> > is empty, no adjustment is needed other than updating ->timer_jiffies.
> > In this case, which is likely to be common for NO_HZ_FULL kernels, the
> > kernel currently incurs a large latency for no good reason.  This commit
> > therefore short-circuits this case.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/timer.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> > 
> > diff --git a/kernel/timer.c b/kernel/timer.c
> > index 2245b7374c3d..295837e5e011 100644
> > --- a/kernel/timer.c
> > +++ b/kernel/timer.c
> > @@ -338,6 +338,17 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
> >  }
> >  EXPORT_SYMBOL_GPL(set_timer_slack);
> >  
> > +static bool catchup_timer_jiffies(struct tvec_base *base)
> > +{
> > +#ifdef CONFIG_NO_HZ_FULL
> > +	if (!base->all_timers) {
> > +		base->timer_jiffies = jiffies;
> > +		return 1;
> > +	}
> > +#endif /* #ifdef CONFIG_NO_HZ_FULL */
> > +	return 0;
> > +}
> 
> In a function with return type "bool", please use true/false, not 1/0.
> 
> Please also document the semantic of the return value.

Done for both, thank you.

							Thanx, Paul

