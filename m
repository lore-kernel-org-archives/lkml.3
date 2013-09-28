Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714Ab3I1C7R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 22:59:17 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44133 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754262Ab3I1C7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 22:59:15 -0400
Message-ID: <524645F0.4020906@hp.com>
Date: Fri, 27 Sep 2013 22:58:56 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Tim Chen <tim.c.chen@linux.intel.com>
CC: paulmck@linux.vnet.ibm.com, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH v6 5/6] MCS Lock: Restructure the MCS lock defines and
 locking code into its own file
References: <cover.1380144003.git.tim.c.chen@linux.intel.com>  <1380147049.3467.67.camel@schen9-DESK>  <20130927152953.GA4464@linux.vnet.ibm.com> <1380305348.3467.109.camel@schen9-DESK>
In-Reply-To: <1380305348.3467.109.camel@schen9-DESK>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 02:09 PM, Tim Chen wrote:
> On Fri, 2013-09-27 at 08:29 -0700, Paul E. McKenney wrote:
>> On Wed, Sep 25, 2013 at 03:10:49PM -0700, Tim Chen wrote:
>>> We will need the MCS lock code for doing optimistic spinning for rwsem.
>>> Extracting the MCS code from mutex.c and put into its own file allow us
>>> to reuse this code easily for rwsem.
>>>
>>> Signed-off-by: Tim Chen<tim.c.chen@linux.intel.com>
>>> Signed-off-by: Davidlohr Bueso<davidlohr@hp.com>
>>> ---
>>>   include/linux/mcslock.h |   58 +++++++++++++++++++++++++++++++++++++++++++++++
>>>   kernel/mutex.c          |   58 +++++-----------------------------------------
>>>   2 files changed, 65 insertions(+), 51 deletions(-)
>>>   create mode 100644 include/linux/mcslock.h
>>>
>>> diff --git a/include/linux/mcslock.h b/include/linux/mcslock.h
>>> new file mode 100644
>>> index 0000000..20fd3f0
>>> --- /dev/null
>>> +++ b/include/linux/mcslock.h
>>> @@ -0,0 +1,58 @@
>>> +/*
>>> + * MCS lock defines
>>> + *
>>> + * This file contains the main data structure and API definitions of MCS lock.
>>> + */
>>> +#ifndef __LINUX_MCSLOCK_H
>>> +#define __LINUX_MCSLOCK_H
>>> +
>>> +struct mcs_spin_node {
>>> +	struct mcs_spin_node *next;
>>> +	int		  locked;	/* 1 if lock acquired */
>>> +};
>>> +
>>> +/*
>>> + * We don't inline mcs_spin_lock() so that perf can correctly account for the
>>> + * time spent in this lock function.
>>> + */
>>> +static noinline
>>> +void mcs_spin_lock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
>>> +{
>>> +	struct mcs_spin_node *prev;
>>> +
>>> +	/* Init node */
>>> +	node->locked = 0;
>>> +	node->next   = NULL;
>>> +
>>> +	prev = xchg(lock, node);
>>> +	if (likely(prev == NULL)) {
>>> +		/* Lock acquired */
>>> +		node->locked = 1;
>>> +		return;
>>> +	}
>>> +	ACCESS_ONCE(prev->next) = node;
>>> +	smp_wmb();
>>> +	/* Wait until the lock holder passes the lock down */
>>> +	while (!ACCESS_ONCE(node->locked))
>>> +		arch_mutex_cpu_relax();
>>> +}
>>> +
>>> +static void mcs_spin_unlock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
>>> +{
>>> +	struct mcs_spin_node *next = ACCESS_ONCE(node->next);
>>> +
>>> +	if (likely(!next)) {
>>> +		/*
>>> +		 * Release the lock by setting it to NULL
>>> +		 */
>>> +		if (cmpxchg(lock, node, NULL) == node)
>>> +			return;
>>> +		/* Wait until the next pointer is set */
>>> +		while (!(next = ACCESS_ONCE(node->next)))
>>> +			arch_mutex_cpu_relax();
>>> +	}
>>> +	ACCESS_ONCE(next->locked) = 1;
>>> +	smp_wmb();
>> Shouldn't the memory barrier precede the "ACCESS_ONCE(next->locked) = 1;"?
>> Maybe in an "else" clause of the prior "if" statement, given that the
>> cmpxchg() does it otherwise.
>>
>> Otherwise, in the case where the "if" conditionn is false, the critical
>> section could bleed out past the unlock.
> Yes, I agree with you that the smp_wmb should be moved before
> ACCESS_ONCE to prevent critical section from bleeding.  Copying Waiman
> who is the original author of the mcs code to see if he has any comments
> on things we may have missed.
>
> Tim

As a more general lock/unlock mechanism, I also agreed that we should 
move smp_wmb() before ACCESS_ONCE(). For the mutex case, it is used as a 
queuing mechanism rather than guarding critical section, so it doesn't 
really matter.

Regards,
Longman
