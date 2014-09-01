Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbaIALVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 07:21:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:56560 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaIALVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 07:21:06 -0400
Date: Mon, 1 Sep 2014 13:20:59 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, dvhart@linux.intel.com, fweisbec@gmail.com,
        oleg@redhat.com, bobby.prani@gmail.com, <""@rjwysocki.net>,
        tianyu.lan@intel.com
Subject: Re: [PATCH RFC tip/core/rcu] Eliminate deadlock between CPU hotplug
 and expedited grace periods
Message-ID: <20140901112059.GG27892@worktop.ger.corp.intel.com>
References: <20140828194745.GA3761@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140828194745.GA3761@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 12:47:45PM -0700, Paul E. McKenney wrote:
> Currently, the expedited grace-period primitives do get_online_cpus().
> This greatly simplifies their implementation, but means that calls to
> them holding locks that are acquired by CPU-hotplug notifiers (to say
> nothing of calls to these primitives from CPU-hotplug notifiers) can
> deadlock.  But this is starting to become inconvenient:
> https://lkml.org/lkml/2014/8/5/754

Please recap the actual problem; the link might die and the actual mail
linked to isn't very useful in any case.

> This commit avoids the deadlock and retains the simplicity by creating
> a try_get_online_cpus(), which returns false if the get_online_cpus()
> reference count could not immediately be incremented.  If a call to
> try_get_online_cpus() returns true, the expedited primitives operate
> as before.  If a call returns false, the expedited primitives fall back
> to normal grace-period operations.  This falling back of course results
> in increased grace-period latency, but only during times when CPU
> hotplug operations are actually in flight.  The effect should therefore
> be negligible during normal operation.

URGH.. I really hate that. The hotplug interface is already too
horrible, we should not add such hacks to it.

How about ripping that rcu_expedited stuff out instead? That's all
conditional anyhow, so might as well not do it.

