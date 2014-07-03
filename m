Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaGHJFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 05:05:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:53732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaGHJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 05:04:58 -0400
Date: Thu, 3 Jul 2014 11:49:49 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu
Subject: Re: [PATCH RFC tip/core/rcu] Parallelize and economize NOCB kthread
 wakeups
Message-ID: <20140703094949.GM3935@laptop>
References: <20140627142038.GA22942@linux.vnet.ibm.com>
 <20140702123412.GD19379@twins.programming.kicks-ass.net>
 <20140702153915.GQ4603@linux.vnet.ibm.com>
 <20140702160412.GO19379@twins.programming.kicks-ass.net>
 <20140702170838.GS4603@linux.vnet.ibm.com>
 <20140702172600.GR19379@twins.programming.kicks-ass.net>
 <53B44182.4090107@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B44182.4090107@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 02, 2014 at 01:29:38PM -0400, Rik van Riel wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 07/02/2014 01:26 PM, Peter Zijlstra wrote:
> > On Wed, Jul 02, 2014 at 10:08:38AM -0700, Paul E. McKenney wrote:
> >> As were others, not that long ago.  Today is the first hint that
> >> I got that you feel otherwise.  But it does look like the softirq
> >> approach to callback processing needs to stick around for awhile
> >> longer.  Nice to hear that softirq is now "sane and normal"
> >> again, I guess.  ;-)
> > 
> > Nah, softirqs are still totally annoying :-)
> > 
> > So I've lost detail again, but it seems to me that on all CPUs that
> > are actually getting ticks, waking tasks to process the RCU state
> > is entirely over doing it. Might as well keep processing their RCU
> > state from the tick as was previously done.
> 
> For CPUs that are not getting ticks (eg. because they are idle),
> is it worth waking up anything on that CPU, or would it make more
> sense to simply process their RCU callbacks on a different CPU,
> if there aren't too many pending?

If they're idle, RCU 'should' know this and exclude them from the state
machine, the tricky part, and where all this nocb nonsense started with,
its the NOHZ_FULL stuff where a cpu can be !idle but still not get
ticks.
