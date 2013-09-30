Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab3I3PwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:52:04 -0400
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:14136 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755236Ab3I3PwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:52:01 -0400
Message-ID: <52499E13.8050109@hp.com>
Date: Mon, 30 Sep 2013 11:51:47 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Jason Low <jason.low2@hp.com>
CC: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
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
References: <cover.1380144003.git.tim.c.chen@linux.intel.com> <1380147049.3467.67.camel@schen9-DESK> <20130927152953.GA4464@linux.vnet.ibm.com> <1380310733.3467.118.camel@schen9-DESK> <20130927203858.GB9093@linux.vnet.ibm.com> <1380322005.3467.186.camel@schen9-DESK> <20130927230137.GE9093@linux.vnet.ibm.com> <CAGQ1y=7YbB_BouYZVJwAZ9crkSMLVCxg8hoqcO_7sXHRrZ90_A@mail.gmail.com> <20130928021947.GF9093@linux.vnet.ibm.com> <CAGQ1y=5RnRsWdOe5CX6WYEJ2vUCFtHpj+PNC85NuEDH4bMdb0w@mail.gmail.com>
In-Reply-To: <CAGQ1y=5RnRsWdOe5CX6WYEJ2vUCFtHpj+PNC85NuEDH4bMdb0w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2013 12:34 AM, Jason Low wrote:
>> Also, below is what the mcs_spin_lock() and mcs_spin_unlock()
>> functions would look like after applying the proposed changes.
>>
>> static noinline
>> void mcs_spin_lock(struct mcs_spin_node **lock, struct mcs_spin_node *node)
>> {
>>          struct mcs_spin_node *prev;
>>
>>          /* Init node */
>>          node->locked = 0;
>>          node->next   = NULL;
>>
>>          prev = xchg(lock, node);
>>          if (likely(prev == NULL)) {
>>                  /* Lock acquired. No need to set node->locked since it
>> won't be used */
>>                  return;
>>          }
>>          ACCESS_ONCE(prev->next) = node;
>>          /* Wait until the lock holder passes the lock down */
>>          while (!ACCESS_ONCE(node->locked))
>>                  arch_mutex_cpu_relax();
>>          smp_mb();

I wonder if a memory barrier is really needed here.

>> }
>>
>> static void mcs_spin_unlock(struct mcs_spin_node **lock, struct
>> mcs_spin_node *node)
>> {
>>          struct mcs_spin_node *next = ACCESS_ONCE(node->next);
>>
>>          if (likely(!next)) {
>>                  /*
>>                   * Release the lock by setting it to NULL
>>                   */
>>                  if (cmpxchg(lock, node, NULL) == node)
>>                          return;
>>                  /* Wait until the next pointer is set */
>>                  while (!(next = ACCESS_ONCE(node->next)))
>>                          arch_mutex_cpu_relax();
>>          }
>>          smp_wmb();
>>          ACCESS_ONCE(next->locked) = 1;
>> }

Instead, I think what we need may be:

if (likely(!next)) {
     ....
} else
     smp_mb();
ACCESS_ONCE(next->locked) = 1;

That will ensure a memory barrier in the unlock path.

Regards,
Longman
