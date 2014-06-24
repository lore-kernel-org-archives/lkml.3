Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014AbaFXUnY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 16:43:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:30505 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222AbaFXUnU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 16:43:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,540,1400050800"; 
   d="scan'208";a="562817951"
Message-ID: <53A9E2E4.5010600@intel.com>
Date: Tue, 24 Jun 2014 13:43:16 -0700
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
References: <20140621025958.GA7185@linux.vnet.ibm.com> <53A85BF9.7030006@intel.com> <53A8611F.1000804@intel.com> <20140623180945.GL4603@linux.vnet.ibm.com> <53A8B884.6000600@intel.com> <20140624001519.GO4603@linux.vnet.ibm.com> <53A8C44E.7050000@intel.com> <20140624003934.GR4603@linux.vnet.ibm.com>
In-Reply-To: <20140624003934.GR4603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 05:39 PM, Paul E. McKenney wrote:
> On Mon, Jun 23, 2014 at 05:20:30PM -0700, Dave Hansen wrote:
>> On 06/23/2014 05:15 PM, Paul E. McKenney wrote:
>>> Just out of curiosity, how many CPUs does your system have?  80?
>>> If 160, looks like something bad is happening at 80.
>>
>> 80 cores, 160 threads.  >80 processes/threads is where we start using
>> the second thread on the cores.  The tasks are also pinned to
>> hyperthread pairs, so they disturb each other, and the scheduler moves
>> them between threads on occasion which causes extra noise.
> 
> OK, that could explain the near flattening of throughput near 80
> processes.  Is 3.16.0-rc1-pf2 with the two RCU patches?  If so, is the
> new sysfs parameter at its default value?

Here's 3.16-rc1 with e552592e applied and jiffies_till_sched_qs=12 vs. 3.15:

> https://www.sr71.net/~dave/intel/bb.html?2=3.16.0-rc1-paultry2-jtsq12&1=3.15

3.16-rc1 is actually in the lead up until the end when we're filling up
the hyperthreads.  The same pattern holds when comparing
3.16-rc1+e552592e to 3.16-rc1 with ac1bea8 reverted:

> https://www.sr71.net/~dave/intel/bb.html?2=3.16.0-rc1-paultry2-jtsq12&1=3.16.0-rc1-wrevert

So, the current situation is generally _better_ than 3.15, except during
the noisy ranges of the test where hyperthreading and the scheduler are
coming in to play.  I made the mistake of doing all my spot-checks at
the 160-thread number, which honestly wasn't the best point to be
looking at.

At this point, I'm satisfied with how e552592e is dealing with the
original regression.  Thanks for all the prompt attention on this one, Paul.
