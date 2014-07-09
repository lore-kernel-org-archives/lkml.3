Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaGIBtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:49:18 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:48013 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465AbaGIBtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:49:16 -0400
X-IronPort-AV: E=Sophos;i="5.00,861,1396972800"; 
   d="scan'208";a="33021463"
Message-ID: <53BC9FD1.90604@cn.fujitsu.com>
Date: Wed, 9 Jul 2014 09:50:09 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <dipankar@in.ibm.com>,
        <akpm@linux-foundation.org>, <mathieu.desnoyers@efficios.com>,
        <josh@joshtriplett.org>, <niv@us.ibm.com>, <tglx@linutronix.de>,
        <peterz@infradead.org>, <rostedt@goodmis.org>, <dhowells@redhat.com>,
        <edumazet@google.com>, <dvhart@linux.intel.com>, <fweisbec@gmail.com>,
        <oleg@redhat.com>, <sbw@mit.edu>
Subject: Re: [PATCH tip/core/rcu 08/17] rcu: Allow post-unlock reference for
 rt_mutex
References: <20140707223756.GA7187@linux.vnet.ibm.com> <1404772701-8804-1-git-send-email-paulmck@linux.vnet.ibm.com> <1404772701-8804-8-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1404772701-8804-8-git-send-email-paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 06:38 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> The current approach to RCU priority boosting uses an rt_mutex strictly
> for its priority-boosting side effects.  The rt_mutex_init_proxy_locked()
> function is used by the booster to initialize the lock as held by the
> boostee.  The booster then uses rt_mutex_lock() to acquire this rt_mutex,
> which priority-boosts the boostee.  When the boostee reaches the end
> of its outermost RCU read-side critical section, it checks a field in
> its task structure to see whether it has been boosted, and, if so, uses
> rt_mutex_unlock() to release the rt_mutex.  The booster can then go on
> to boost the next task that is blocking the current RCU grace period.
> 
> But reasonable implementations of rt_mutex_unlock() might result in the
> boostee referencing the rt_mutex's data after releasing it. 

XXXX_unlock(lock_ptr) should not reference to the lock_ptr after it has unlocked the lock. (*)
So I think this patch is unneeded. Although its adding overhead is at slow-patch,
but it adds REVIEW-burden.

And although the original rt_mutex_unlock() violates the rule(*) when the fast-cmpxchg-path,
but it is fixed now.

It is the lock-subsystem's responsible to do this. I prefer to add the wait_for_complete()
stuff until the future when the boostee needs to re-access the booster after rt_mutex_unlock()
instead of now.

Thanks,
Lai
