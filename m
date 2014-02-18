Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753AbaBRA6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 19:58:11 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:60457 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231AbaBRA6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 19:58:09 -0500
Date: Mon, 17 Feb 2014 16:58:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 19/55] rcutorture: Abstract TOROUT_STRING()
 and friends
Message-ID: <20140218005802.GW4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140217221231.GA8419@linux.vnet.ibm.com>
 <1392675179-11560-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1392675179-11560-19-git-send-email-paulmck@linux.vnet.ibm.com>
 <20140218002606.GE19929@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140218002606.GE19929@thin>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021800-6688-0000-0000-000006AF91AD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 04:26:06PM -0800, Josh Triplett wrote:
> On Mon, Feb 17, 2014 at 02:12:23PM -0800, Paul E. McKenney wrote:
> > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > 
> > These diagnostic macros are not confined to torturing RCU, so this commit
> > makes them available to other torture tests.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This removes the do {} while (0) around the first of the macros, without
> any explanation in the commit message.

checkpatch.pl yelled at me about it.  ;-)

> Also, to what extent could these be made redundant with pr_fmt?
> if(verbose) seems like it really ought to become a priority level or
> dynamic debugging (and it's really awful to further propagate macros
> that reference an out-of-macro variable).  Ideally all of these could go
> away in favor of pr_fmt, and then the individual calls to them would
> become pr_alert, pr_debug, pr_error, or similar.

I don't immediately see how to get the "!!!" to be there or not with
pr_fmt(), since the same pr_fmt() would apply to all the macros.
I am also not all that excited about including "verbose" or similar
into the argument list of all calls to these guys.

Other suggestions?  Or am I missing your point?

							Thanx, Paul

> - Josh Triplett
> 
> >  include/linux/torture.h | 8 ++++++++
> >  kernel/rcu/rcutorture.c | 8 --------
> >  2 files changed, 8 insertions(+), 8 deletions(-)
> > 
> > diff --git a/include/linux/torture.h b/include/linux/torture.h
> > index 368e15bb1a39..8a4088f2f87b 100644
> > --- a/include/linux/torture.h
> > +++ b/include/linux/torture.h
> > @@ -41,6 +41,14 @@
> >  	module_param(name, type, 0444); \
> >  	MODULE_PARM_DESC(name, msg);
> >  
> > +#define TORTURE_FLAG "-torture:"
> > +#define TOROUT_STRING(s) \
> > +	pr_alert("%s" TORTURE_FLAG s "\n", torture_type)
> > +#define VERBOSE_TOROUT_STRING(s) \
> > +	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
> > +#define VERBOSE_TOROUT_ERRSTRING(s) \
> > +	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
> > +
> >  /* Low-rider random number generator. */
> >  struct torture_random_state {
> >  	unsigned long trs_state;
> > diff --git a/kernel/rcu/rcutorture.c b/kernel/rcu/rcutorture.c
> > index 04813bdf5e53..2bb3dcb67221 100644
> > --- a/kernel/rcu/rcutorture.c
> > +++ b/kernel/rcu/rcutorture.c
> > @@ -96,14 +96,6 @@ static char *torture_type = "rcu";
> >  module_param(torture_type, charp, 0444);
> >  MODULE_PARM_DESC(torture_type, "Type of RCU to torture (rcu, rcu_bh, ...)");
> >  
> > -#define TORTURE_FLAG "-torture:"
> > -#define TOROUT_STRING(s) \
> > -	do { pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
> > -#define VERBOSE_TOROUT_STRING(s) \
> > -	do { if (verbose) pr_alert("%s" TORTURE_FLAG s "\n", torture_type); } while (0)
> > -#define VERBOSE_TOROUT_ERRSTRING(s) \
> > -	do { if (verbose) pr_alert("%s" TORTURE_FLAG "!!! " s "\n", torture_type); } while (0)
> > -
> >  static int nrealreaders;
> >  static struct task_struct *writer_task;
> >  static struct task_struct **fakewriter_tasks;
> > -- 
> > 1.8.1.5
> > 
> 

