Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366AbaFWQnW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 12:43:22 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:34616 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbaFWQnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 12:43:21 -0400
Date: Mon, 23 Jun 2014 09:43:13 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, dave.hansen@intel.com,
        cl@gentwo.org, umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
Message-ID: <20140623164313.GA27233@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140621025958.GA7185@linux.vnet.ibm.com>
 <20140623062615.GB19860@laptop.programming.kicks-ass.net>
 <20140623154931.GF8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140623154931.GF8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14062316-3532-0000-0000-000002A9F74D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 08:49:31AM -0700, Andi Kleen wrote:
> > On the topic of these threads; I recently noticed RCU grew a metric ton
> > of them, I found some 75 rcu kthreads on my box, wth up with that?
> 
> It seems like RCU is growing in complexity all the time.
> 
> Can it be put on a diet in general? 

In 3.10, RCU had 14,046 lines of code, not counting documentation and
test scripting.  In 3.15, RCU had 13,208 lines of code, again not counting
documentation and test scripting.  That is a decrease of almost 1KLoC,
so your wish is granted.

In the future, I hope to be able to make NOCB the default and remove the
softirq-based callback handling, which should shrink things a bit further.
Of course, continued work to make NOCB handle various corner cases will
offset that expected shrinkage, though hopefully not be too much.

Of course, I cannot resist taking your call for RCU simplicity as a vote
against Peter's proposal for aligning the rcu_node tree to the hardware's
electrical structure.  ;-)

> No more new CONFIGs please either.

Since 3.10, I have gotten rid of CONFIG_RCU_CPU_STALL_TIMEOUT.

Over time, it might be possible to make CONFIG_RCU_FAST_NO_HZ the default,
and thus eliminate that Kconfig parameter.  As noted about, ditto for
CONFIG_RCU_NOCB_CPU, CONFIG_RCU_NOCB_CPU_NONE, CONFIG_RCU_NOCB_CPU_ZERO,
and CONFIG_RCU_NOCB_CPU_ALL.  It also might be reasonable to replace
uses of CONFIG_PROVE_RCU with CONFIG_PROVE_LOCKING, thus allowing
CONFIG_PROVE_RCU to be eliminated.  CONFIG_PROVE_RCU_DELAY hasn't proven
very good at finding bugs, so I am considering eliminating it as well.
Given recent and planned changes related to RCU's stall-warning stack
dumping, I hope to eliminate both CONFIG_RCU_CPU_STALL_VERBOSE and
CONFIG_RCU_CPU_STALL_INFO, making them both happen unconditionally.
(And yes, I should probably make CONFIG_RCU_CPU_STALL_INFO be the default
for some time beforehand.)  I have also been considering getting rid of
CONFIG_RCU_FANOUT_EXACT, given that it appears that no one uses it.

That should make room for additional RCU Kconfig parameters as needed
for specialized or high-risk new functionality, when and if required.

							Thanx, Paul

> -Andi
> -- 
> ak@linux.intel.com -- Speaking for myself only
> 

