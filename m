Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966744AbaFRNiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 09:38:09 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:47137 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966349AbaFRNiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 09:38:06 -0400
Date: Wed, 18 Jun 2014 09:36:56 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Waiman.Long@hp.com,
        tglx@linutronix.de, mingo@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        paolo.bonzini@gmail.com, boris.ostrovsky@oracle.com,
        paulmck@linux.vnet.ibm.com, riel@redhat.com,
        torvalds@linux-foundation.org, raghavendra.kt@linux.vnet.ibm.com,
        david.vrabel@citrix.com, oleg@redhat.com, gleb@redhat.com,
        scott.norton@hp.com, chegu_vinod@hp.com,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 03/11] qspinlock: Add pending bit
Message-ID: <20140618133656.GA4729@laptop.dumpdata.com>
References: <20140615124657.264658593@chello.nl>
 <20140615130153.196728583@chello.nl>
 <20140617203615.GA29634@laptop.dumpdata.com>
 <53A1782C.7040400@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53A1782C.7040400@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 01:29:48PM +0200, Paolo Bonzini wrote:
> Il 17/06/2014 22:36, Konrad Rzeszutek Wilk ha scritto:
> >+	/* One more attempt - but if we fail mark it as pending. */
> >+	if (val == _Q_LOCKED_VAL) {
> >+		new = Q_LOCKED_VAL |_Q_PENDING_VAL;
> >+
> >+		old = atomic_cmpxchg(&lock->val, val, new);
> >+		if (old == _Q_LOCKED_VAL) /* YEEY! */
> >+			return;
> >+		val = old;
> >+	}
> 
> Note that Peter's code is in a for(;;) loop:
> 
> 
> +	for (;;) {
> +		/*
> +		 * If we observe any contention; queue.
> +		 */
> +		if (val & ~_Q_LOCKED_MASK)
> +			goto queue;
> +
> +		new = _Q_LOCKED_VAL;
> +		if (val == new)
> +			new |= _Q_PENDING_VAL;
> +
> +		old = atomic_cmpxchg(&lock->val, val, new);
> +		if (old == val)
> +			break;
> +
> +		val = old;
> +	}
> +
> +	/*
> +	 * we won the trylock
> +	 */
> +	if (new == _Q_LOCKED_VAL)
> +		return;
> 
> So what you'd have is basically:
> 
> 	/*
> 	 * One more attempt if no one is already in queue.  Perhaps
> 	 * they have unlocked the spinlock already.
> 	 */
> 	if (val == _Q_LOCKED_VAL && atomic_read(&lock->val) == 0) {
> 		old = atomic_cmpxchg(&lock->val, 0, _Q_LOCKED_VAL);
> 		if (old == 0) /* YEEY! */
> 			return;
> 		val = old;
> 	}
> 
> But I agree with Waiman that this is unlikely to trigger often enough. It
> does have to be handled in the slowpath for correctness, but the most likely
> path is (0,0,1)->(0,1,1).

<nods>
> 
> Paolo
