Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343AbaEAQjX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 12:39:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:58793 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750801AbaEAQjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 12:39:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,966,1389772800"; 
   d="scan'208";a="504421826"
Subject: Re: [PATCH v3] rwsem: Support optimistic spinning
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1398914496.22957.11.camel@buesod1.americas.hpqcorp.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398914496.22957.11.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 May 2014 09:39:16 -0700
Message-ID: <1398962356.2970.128.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 20:21 -0700, Davidlohr Bueso wrote:

> +
> +static inline bool rwsem_can_spin_on_owner(struct rw_semaphore *sem)
> +{
> +	struct task_struct *owner;
> +	bool on_cpu = true;
> +
> +	if (need_resched())
> +		return 0;
> +
> +	rcu_read_lock();
> +	owner = ACCESS_ONCE(sem->owner);
> +	if (owner)
> +		on_cpu = owner->on_cpu;
> +	rcu_read_unlock();
> +
> +	/*
> +	 * If lock->owner is not set, the mutex owner may have
> +	 * just acquired it and not set the owner yet or the mutex

Nitpick. Change the above 2 mutex in comment to rwsem.

> +	 * has been released.
> +	 */
> +	return on_cpu;
> +}
> +

Tim


