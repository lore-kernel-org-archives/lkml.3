Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403AbaDQV2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:28:34 -0400
Received: from g5t1625.atlanta.hp.com ([15.192.137.8]:46815 "EHLO
	g5t1625.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDQV2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:28:24 -0400
Message-ID: <53504771.9070102@hp.com>
Date: Thu, 17 Apr 2014 17:28:17 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v9 04/19] qspinlock: Extract out the exchange of tail
 code word
References: <1397747051-15401-1-git-send-email-Waiman.Long@hp.com> <1397747051-15401-5-git-send-email-Waiman.Long@hp.com> <20140417154902.GO11096@twins.programming.kicks-ass.net>
In-Reply-To: <20140417154902.GO11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:49 AM, Peter Zijlstra wrote:
> On Thu, Apr 17, 2014 at 11:03:56AM -0400, Waiman Long wrote:
>> @@ -192,36 +220,25 @@ void queue_spin_lock_slowpath(struct qspinlock *lock, u32 val)
>>   	node->next = NULL;
>>
>>   	/*
>> +	 * We touched a (possibly) cold cacheline; attempt the trylock once
>> +	 * more in the hope someone let go while we weren't watching as long
>> +	 * as no one was queuing.
>>   	 */
>> +	if (!(val&  _Q_TAIL_MASK)&&  queue_spin_trylock(lock))
>> +		goto release;
> But you just did a potentially very expensive op; @val isn't
> representative anymore!

That is not true. I pass in a pointer to val to trylock_pending() (the 
pointer thing) so that it will store the latest value that it reads from 
the lock back into val. I did miss one in the PV qspinlock exit loop. I 
will add it back when I do the next version.

-Longman
