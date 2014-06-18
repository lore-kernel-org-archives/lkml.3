Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966156AbaFRLaz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 07:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35676 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933182AbaFRLax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 07:30:53 -0400
Message-ID: <53A1782C.7040400@redhat.com>
Date: Wed, 18 Jun 2014 13:29:48 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Waiman.Long@hp.com, tglx@linutronix.de, mingo@kernel.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
References: <20140615124657.264658593@chello.nl> <20140615130153.196728583@chello.nl> <20140617203615.GA29634@laptop.dumpdata.com>
In-Reply-To: <20140617203615.GA29634@laptop.dumpdata.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 17/06/2014 22:36, Konrad Rzeszutek Wilk ha scritto:
> +	/* One more attempt - but if we fail mark it as pending. */
> +	if (val == _Q_LOCKED_VAL) {
> +		new = Q_LOCKED_VAL |_Q_PENDING_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == _Q_LOCKED_VAL) /* YEEY! */
> +			return;
> +		val = old;
> +	}

Note that Peter's code is in a for(;;) loop:


+	for (;;) {
+		/*
+		 * If we observe any contention; queue.
+		 */
+		if (val & ~_Q_LOCKED_MASK)
+			goto queue;
+
+		new = _Q_LOCKED_VAL;
+		if (val == new)
+			new |= _Q_PENDING_VAL;
+
+		old = atomic_cmpxchg(&lock->val, val, new);
+		if (old == val)
+			break;
+
+		val = old;
+	}
+
+	/*
+	 * we won the trylock
+	 */
+	if (new == _Q_LOCKED_VAL)
+		return;

So what you'd have is basically:

	/*
	 * One more attempt if no one is already in queue.  Perhaps
	 * they have unlocked the spinlock already.
	 */
	if (val == _Q_LOCKED_VAL && atomic_read(&lock->val) == 0) {
		old = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
		if (old == 0) /* YEEY! */
			return;
		val = old;
	}

But I agree with Waiman that this is unlikely to trigger often enough. 
It does have to be handled in the slowpath for correctness, but the most 
likely path is (0,0,1)->(0,1,1).

Paolo
