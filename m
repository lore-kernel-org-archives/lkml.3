Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635AbaFWRe3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 13:34:29 -0400
Received: from mga09.intel.com ([134.134.136.24]:26933 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbaFWRe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 13:34:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,531,1400050800"; 
   d="scan'208";a="561998520"
Message-ID: <53A8651B.4010607@intel.com>
Date: Mon, 23 Jun 2014 10:34:19 -0700
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
References: <20140621025958.GA7185@linux.vnet.ibm.com> <53A85BF9.7030006@intel.com> <20140623171644.GH4603@linux.vnet.ibm.com>
In-Reply-To: <20140623171644.GH4603@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2014 10:16 AM, Paul E. McKenney wrote:
> On Mon, Jun 23, 2014 at 09:55:21AM -0700, Dave Hansen wrote:
>> This still has a regression.  Commit 1ed70de (from Paul's git tree),
>> gets a result of 52231880.  If I back up two commits to v3.16-rc1 and
>> revert ac1bea85 (the original culprit) the result goes back up to 57308512.
>>
>> So something is still going on here.
> 
> And commit 1ed70de is in fact the right one, so...
> 
> The rcutree.jiffies_till_sched_qs boot/sysfs parameter controls how
> long RCU waits before asking for quiescent states.  The default is
> currently HZ/20.  Does increasing this parameter help?  Easy for me to
> increase the default if it does.

Making it an insane value:

echo 12 > /sys/module/rcutree/parameters/jiffies_till_sched_qs
average:52248706
echo 9999999 > /sys/module/rcutree/parameters/jiffies_till_sched_qs
average:55712533

gets us back up _closer_ to our original 57M number, but it's still not
quite there.
