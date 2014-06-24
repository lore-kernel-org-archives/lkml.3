Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbaFXVPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 17:15:53 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:34854 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479AbaFXVPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 17:15:51 -0400
Date: Tue, 24 Jun 2014 14:15:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, ak@linux.intel.com, cl@gentwo.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140624211545.GA4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <53A85BF9.7030006@intel.com>
 <53A8611F.1000804@intel.com>
 <20140623180945.GL4603@linux.vnet.ibm.com>
 <53A8B884.6000600@intel.com>
 <20140624001519.GO4603@linux.vnet.ibm.com>
 <53A8C44E.7050000@intel.com>
 <20140624003934.GR4603@linux.vnet.ibm.com>
 <53A9E2E4.5010600@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A9E2E4.5010600@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062421-8236-0000-0000-0000035A1A06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 24, 2014 at 01:43:16PM -0700, Dave Hansen wrote:
> On 06/23/2014 05:39 PM, Paul E. McKenney wrote:
> > On Mon, Jun 23, 2014 at 05:20:30PM -0700, Dave Hansen wrote:
> >> On 06/23/2014 05:15 PM, Paul E. McKenney wrote:
> >>> Just out of curiosity, how many CPUs does your system have?  80?
> >>> If 160, looks like something bad is happening at 80.
> >>
> >> 80 cores, 160 threads.  >80 processes/threads is where we start using
> >> the second thread on the cores.  The tasks are also pinned to
> >> hyperthread pairs, so they disturb each other, and the scheduler moves
> >> them between threads on occasion which causes extra noise.
> > 
> > OK, that could explain the near flattening of throughput near 80
> > processes.  Is 3.16.0-rc1-pf2 with the two RCU patches?  If so, is the
> > new sysfs parameter at its default value?
> 
> Here's 3.16-rc1 with e552592e applied and jiffies_till_sched_qs=12 vs. 3.15:
> 
> > https://www.sr71.net/~dave/intel/bb.html?2=3.16.0-rc1-paultry2-jtsq12&1=3.15
> 
> 3.16-rc1 is actually in the lead up until the end when we're filling up
> the hyperthreads.  The same pattern holds when comparing
> 3.16-rc1+e552592e to 3.16-rc1 with ac1bea8 reverted:
> 
> > https://www.sr71.net/~dave/intel/bb.html?2=3.16.0-rc1-paultry2-jtsq12&1=3.16.0-rc1-wrevert
> 
> So, the current situation is generally _better_ than 3.15, except during
> the noisy ranges of the test where hyperthreading and the scheduler are
> coming in to play.

Good to know that my intuition is not yet completely broken.  ;-)

>                     I made the mistake of doing all my spot-checks at
> the 160-thread number, which honestly wasn't the best point to be
> looking at.

That would do it!  ;-)

> At this point, I'm satisfied with how e552592e is dealing with the
> original regression.  Thanks for all the prompt attention on this one, Paul.

Glad it worked out, I have sent a pull request to Ingo to hopefully
get this into 3.16.

							Thanx, Paul

