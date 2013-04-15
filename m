Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab3DOCEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 22:04:09 -0400
Received: from ozlabs.org ([203.10.76.45]:48522 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab3DOCEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 22:04:08 -0400
Date: Mon, 15 Apr 2013 12:03:54 +1000
From: Paul Mackerras <paulus@samba.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 6/7] rcu: Drive quiescent-state-forcing
 delay from HZ
Message-ID: <20130415020354.GB3401@iris.ozlabs.ibm.com>
References: <20130412231846.GA20038@linux.vnet.ibm.com>
 <1365808754-20762-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1365808754-20762-6-git-send-email-paulmck@linux.vnet.ibm.com>
 <20130412235401.GA8140@jtriplet-mobl1>
 <20130413063804.GV29861@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130413063804.GV29861@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 11:38:04PM -0700, Paul E. McKenney wrote:
> On Fri, Apr 12, 2013 at 04:54:02PM -0700, Josh Triplett wrote:
> > On Fri, Apr 12, 2013 at 04:19:13PM -0700, Paul E. McKenney wrote:
> > > From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> > > 
> > > Systems with HZ=100 can have slow bootup times due to the default
> > > three-jiffy delays between quiescent-state forcing attempts.  This
> > > commit therefore auto-tunes the RCU_JIFFIES_TILL_FORCE_QS value based
> > > on the value of HZ.  However, this would break very large systems that
> > > require more time between quiescent-state forcing attempts.  This
> > > commit therefore also ups the default delay by one jiffy for each
> > > 256 CPUs that might be on the system (based off of nr_cpu_ids at
> > > runtime, -not- NR_CPUS at build time).
> > > 
> > > Reported-by: Paul Mackerras <paulus@au1.ibm.com>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Something seems very wrong if RCU regularly hits the fqs code during
> > boot; feels like there's some more straightforward solution we're
> > missing.  What causes these CPUs to fall under RCU's scrutiny during
> > boot yet not actually hit the RCU codepaths naturally?
> 
> The problem is that they are running HZ=100, so that RCU will often
> take 30-60 milliseconds per grace period.  At that point, you only
> need 16-30 grace periods to chew up a full second, so it is not all
> that hard to eat up the additional 8-12 seconds of boot time that
> they were seeing.  IIRC, UP boot was costing them 4 seconds.

I added some instrumentation, which counted 202 calls to
synchronize_sched() during boot (Fedora 17 minimal install +
development tools) with a 3.8.0 kernel on a 4-cpu KVM virtual machine
on a POWER7.  Without this patch, those 202 calls take up a total of
4.32 seconds; with it, they take up 3.6 seconds.  The kernel is
compiled with HZ=100 and NR_CPUS=1024, like the standard Fedora
kernel.

I suspect a lot of the calls are in udevd and related processes.
Interestingly there were no calls to synchronize_rcu_bh or
synchronize_sched_expedited.

Paul.
