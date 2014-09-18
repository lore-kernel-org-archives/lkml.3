Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbaIRMi4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:38:56 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34173 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268AbaIRMix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:38:53 -0400
Date: Thu, 18 Sep 2014 05:38:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, bobby.prani@gmail.com,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
Message-ID: <20140918123845.GO4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140828194745.GA3761@linux.vnet.ibm.com>
 <5419342E.60602@intel.com>
 <20140917131013.GU4723@linux.vnet.ibm.com>
 <541A8698.9040905@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <541A8698.9040905@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091812-3532-0000-0000-000004BDC8C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 03:15:36PM +0800, Lan Tianyu wrote:
> On 2014年09月17日 21:10, Paul E. McKenney wrote:
> > On Wed, Sep 17, 2014 at 03:11:42PM +0800, Lan Tianyu wrote:
> >> On 2014年08月29日 03:47, Paul E. McKenney wrote:
> >>> Currently, the expedited grace-period primitives do get_online_cpus().
> >>> This greatly simplifies their implementation, but means that calls to
> >>> them holding locks that are acquired by CPU-hotplug notifiers (to say
> >>> nothing of calls to these primitives from CPU-hotplug notifiers) can
> >>> deadlock.  But this is starting to become inconvenient:
> >>> https://lkml.org/lkml/2014/8/5/754
> >>>
> >>> This commit avoids the deadlock and retains the simplicity by creating
> >>> a try_get_online_cpus(), which returns false if the get_online_cpus()
> >>> reference count could not immediately be incremented.  If a call to
> >>> try_get_online_cpus() returns true, the expedited primitives operate
> >>> as before.  If a call returns false, the expedited primitives fall back
> >>> to normal grace-period operations.  This falling back of course results
> >>> in increased grace-period latency, but only during times when CPU
> >>> hotplug operations are actually in flight.  The effect should therefore
> >>> be negligible during normal operation.
> >>>
> >>> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> >>> Cc: Josh Triplett <josh@joshtriplett.org>
> >>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> >>> Cc: Lan Tianyu <tianyu.lan@intel.com>
> >>
> >> Hi Paul:
> >> 	What's the status of the patch? Will you push it? Thanks.
> > 
> > By default, it would go into 3.19.  Do you need it earlier?
> 
> IMO, this is a dead lock bug which is hard to reproduce and the patch
> should go into v3.17 and stable tree?

The problem with pushing for v3.17 is that I would have to rebase
that commit to the bottom of my current stack and redo all my testing.
If there were any problems, I could not only miss v3.17, but also miss
the v3.18 merge window.

So, given that the next merge window happens pretty soon, how about
v3.18 and the stable tree?

							Thanx, Paul

