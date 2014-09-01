Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaIAQGE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 12:06:04 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46381 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753984AbaIAQGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 12:06:01 -0400
Date: Mon, 1 Sep 2014 09:05:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, <""@rjwysocki.net>,
        tianyu.lan@intel.com
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
Message-ID: <20140901160550.GL5001@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140828194745.GA3761@linux.vnet.ibm.com>
 <20140901112059.GG27892@worktop.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140901112059.GG27892@worktop.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090116-1542-0000-0000-000004733AD2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 01:20:59PM +0200, Peter Zijlstra wrote:
> On Thu, Aug 28, 2014 at 12:47:45PM -0700, Paul E. McKenney wrote:
> > Currently, the expedited grace-period primitives do get_online_cpus().
> > This greatly simplifies their implementation, but means that calls to
> > them holding locks that are acquired by CPU-hotplug notifiers (to say
> > nothing of calls to these primitives from CPU-hotplug notifiers) can
> > deadlock.  But this is starting to become inconvenient:
> > https://lkml.org/lkml/2014/8/5/754
> 
> Please recap the actual problem; the link might die and the actual mail
> linked to isn't very useful in any case.

Will do.

> > This commit avoids the deadlock and retains the simplicity by creating
> > a try_get_online_cpus(), which returns false if the get_online_cpus()
> > reference count could not immediately be incremented.  If a call to
> > try_get_online_cpus() returns true, the expedited primitives operate
> > as before.  If a call returns false, the expedited primitives fall back
> > to normal grace-period operations.  This falling back of course results
> > in increased grace-period latency, but only during times when CPU
> > hotplug operations are actually in flight.  The effect should therefore
> > be negligible during normal operation.
> 
> URGH.. I really hate that. The hotplug interface is already too
> horrible, we should not add such hacks to it.

We do have try_ interfaces to a number of other subsystems, so I don't
believe that it qualifies as such a hack.

> How about ripping that rcu_expedited stuff out instead? That's all
> conditional anyhow, so might as well not do it.

In what way is the expedited stuff conditional?

							Thanx, Paul

