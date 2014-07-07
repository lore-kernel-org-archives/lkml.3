Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452AbaGGPJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 11:09:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaGGPJM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 11:09:12 -0400
Message-ID: <53BAB7E1.4010506@redhat.com>
Date: Mon, 07 Jul 2014 17:08:17 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, paulmck@linux.vnet.ibm.com,
        riel@redhat.com, torvalds@linux-foundation.org,
        raghavendra.kt@linux.vnet.ibm.com, david.vrabel@citrix.com,
        oleg@redhat.com, gleb@redhat.com, scott.norton@hp.com,
        chegu_vinod@hp.com
Subject: Re: [PATCH 05/11] qspinlock: Optimize for smaller NR_CPUS
References: <20140615124657.264658593@chello.nl> <20140615130153.483502389@chello.nl> <53A17A88.7090705@redhat.com> <20140707143503.GS6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140707143503.GS6758@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 07/07/2014 16:35, Peter Zijlstra ha scritto:
> On Wed, Jun 18, 2014 at 01:39:52PM +0200, Paolo Bonzini wrote:
>> Il 15/06/2014 14:47, Peter Zijlstra ha scritto:
>>>
>>> -	for (;;) {
>>> -		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
>>> -
>>> -		old = atomic_cmpxchg(&lock->val, val, new);
>>> -		if (old == val)
>>> -			break;
>>> -
>>> -		val = old;
>>> -	}
>>> +	clear_pending_set_locked(lock, val);
>>> 	return;
>>
>>
>> Might as well add clear_pending_set_locked already in patch 3.
>
> Patch 4, if anywhere.
>

This code is added in patch 3:

+	/*
+	 * take ownership and clear the pending bit.
+	 *
+	 * *,1,0 -> *,0,1
+	 */
+	for (;;) {
+		new = (val & ~_Q_PENDING_MASK) | _Q_LOCKED_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+	return;

Unlike the change in patch 4, clear_pending_set_locked doesn't change 
how qspinlock moves from a state to the next.

Paolo
