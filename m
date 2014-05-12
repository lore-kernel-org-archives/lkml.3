Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbaELS62 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:58:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751389AbaELS60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:58:26 -0400
Date: Mon, 12 May 2014 20:57:39 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, kvm@vger.kernel.org,
        Paolo Bonzini <paolo.bonzini@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Oleg Nesterov <oleg@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Scott J Norton <scott.norton@hp.com>, Chegu Vinod <chegu_vinod@hp.com>
Subject: Re: [PATCH v10 10/19] qspinlock, x86: Allow unfair spinlock in a
 virtual guest
Message-ID: <20140512185739.GB12309@potion.brq.redhat.com>
References: <1399474907-22206-1-git-send-email-Waiman.Long@hp.com>
 <1399474907-22206-11-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399474907-22206-11-git-send-email-Waiman.Long@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(tl;dr: paravirtualization could be better than unfair qspinlock)

2014-05-07 11:01-0400, Waiman Long:
> Locking is always an issue in a virtualized environment because of 2
> different types of problems:
>  1) Lock holder preemption
>  2) Lock waiter preemption

Paravirtualized ticketlocks have a shortcoming;
we don't know which VCPU the ticket belongs to, so the hypervisor can
only blindly yield to runnable VCPUs after waiters halt in slowpath.
There aren't enough "free" bits in ticket struct to improve, thus we
have resorted to unfairness.

Qspinlock is different.

Most queued VCPUs already know the VCPU before it, so we have what it
takes to mitigate lock waiter preemption: we can include preempted CPU
id in hypercall, the hypervisor will schedule it, and we'll be woken up
from unlock slowpath [1].
This still isn't perfect: we can wake up a VCPU that got preempted
before it could hypercall, and these hypercalls will propagate one by
one through our queue to the preempted lock holder.
(We'd have to share the whole waiter-list to avoid this.
 We could also try to send holder's id instead and unconditionally kick
 next-in-line on unlock, I think it would be slower.)

Lock holder problem is tougher because we don't always share who is it.
The tail bits can be used for it as we don't really use them before a
queue has formed.  This would cost us one bit to differentiate between
holder/tail CPU id [2] and complicate operations a little, but only for
the paravirt case, where benefits are expected to be far greater.
Hypercall from lock slowpath could schedule preempted VCPU right away.

I think this could obsolete unfair locks and will prepare RFC patches
soon-ish [3]. (If the idea isn't proved infeasible before.)


---
1: It is possible that we could avoid O(N) traversal and hypercall in
   unlock slowpath by scheduling VCPUs in the right order often.
2: Or even less. idx=3 is a bug: if we are spinning in NMI, we are
   almost deadlocked, so we should WARN/BUG if it were to happen; which
   leaves the combination free to mean that the CPU id is a sole holder,
   not a tail.  (I prefer clean code though.)
3: I already tried and got quickly fed up by refactoring, so it might
   get postponed till the series gets merged.
