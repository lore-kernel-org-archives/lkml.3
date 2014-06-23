Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbaFWXaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 19:30:20 -0400
Received: from mga02.intel.com ([134.134.136.20]:62898 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753221AbaFWXaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 19:30:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,533,1400050800"; 
   d="scan'208";a="562158562"
Message-ID: <53A8B884.6000600@intel.com>
Date: Mon, 23 Jun 2014 16:30:12 -0700
From: Dave Hansen <dave.hansen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, dvhart@linux.intel.com,
        fweisbec@gmail.com, oleg@redhat.com, ak@linux.intel.com, cl@gentwo.org,
        umgwanakikbuti@gmail.com
Subject: Re: [PATCH tip/core/rcu] Reduce overhead of cond_resched() checks
 for RCU
References: <20140621025958.GA7185@linux.vnet.ibm.com> <53A85BF9.7030006@intel.com> <53A8611F.1000804@intel.com> <20140623180945.GL4603@linux.vnet.ibm.com>
In-Reply-To: <20140623180945.GL4603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 11:09 AM, Paul E. McKenney wrote:
> So let's see...  The open1 benchmark sits in a loop doing open()
> and close(), and probably spends most of its time in the kernel.
> It doesn't do much context switching.  I am guessing that you don't
> have CONFIG_NO_HZ_FULL=y, or the boot/sysfs parameter would not have
> much effect because then the first quiescent-state-forcing attempt would
> likely finish the grace period.
> 
> So, given that short grace periods help other workloads (I have the
> scars to prove it), and given that the patch fixes some real problems,

I'm not arguing that short grace periods _can_ help some workloads, or
that one is better than the other.  The patch in question changes
existing behavior by shortening grace periods.  This change of existing
behavior removes some of the benefits that my system gets out of RCU.  I
suspect this affects a lot more systems, but my core cout makes it
easier to see.

Perhaps I'm misunderstanding the original patch's intent, but it seemed
to me to be working around an overactive debug message.  While often a
_useful_ debug message, it was firing falsely in the case being
addressed in the patch.

> and given that the large number for rcutree.jiffies_till_sched_qs got
> us within 3%, shouldn't we consider this issue closed?

With the default value for the tunable, the regression is still solidly
over 10%.  I think we can have a reasonable argument about it once the
default delta is down to the small single digits.

One more thing I just realized: this isn't a scalability problem, at
least with rcutree.jiffies_till_sched_qs=12.  There's a pretty
consistent delta in throughput throughout the entire range of threads
from 1->160.  See the "processes" column in the data files:

plain 3.15:
> https://www.sr71.net/~dave/intel/willitscale/systems/bigbox/3.15/open1.csv
e552592e0383bc:
> https://www.sr71.net/~dave/intel/willitscale/systems/bigbox/3.16.0-rc1-pf2/open1.csv

or visually:

> https://www.sr71.net/~dave/intel/array-join.html?1=willitscale/systems/bigbox/3.15&2=willitscale/systems/bigbox/3.16.0-rc1-pf2&hide=linear,threads_idle,processes_idle
