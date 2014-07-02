Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771AbaGBPsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 11:48:30 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:42327 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550AbaGBPs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 11:48:28 -0400
Date: Wed, 2 Jul 2014 08:39:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, riel@redhat.com, mingo@kernel.org,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140702153915.GQ4603@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140702123412.GD19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070215-7164-0000-0000-000002DC18F2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 02:34:12PM +0200, Peter Zijlstra wrote:
> On Fri, Jun 27, 2014 at 07:20:38AM -0700, Paul E. McKenney wrote:
> > An 80-CPU system with a context-switch-heavy workload can require so
> > many NOCB kthread wakeups that the RCU grace-period kthreads spend several
> > tens of percent of a CPU just awakening things.  This clearly will not
> > scale well: If you add enough CPUs, the RCU grace-period kthreads would
> > get behind, increasing grace-period latency.
> > 
> > To avoid this problem, this commit divides the NOCB kthreads into leaders
> > and followers, where the grace-period kthreads awaken the leaders each of
> > whom in turn awakens its followers.  By default, the number of groups of
> > kthreads is the square root of the number of CPUs, but this default may
> > be overridden using the rcutree.rcu_nocb_leader_stride boot parameter.
> > This reduces the number of wakeups done per grace period by the RCU
> > grace-period kthread by the square root of the number of CPUs, but of
> > course by shifting those wakeups to the leaders.  In addition, because
> > the leaders do grace periods on behalf of their respective followers,
> > the number of wakeups of the followers decreases by up to a factor of two.
> > Instead of being awakened once when new callbacks arrive and again
> > at the end of the grace period, the followers are awakened only at
> > the end of the grace period.
> > 
> > For a numerical example, in a 4096-CPU system, the grace-period kthread
> > would awaken 64 leaders, each of which would awaken its 63 followers
> > at the end of the grace period.  This compares favorably with the 79
> > wakeups for the grace-period kthread on an 80-CPU system.
> 
> Urgh, how about we kill the entire nocb nonsense and try again? This is
> getting quite rediculous.

Sure thing, Peter.

							Thanx, Paul

