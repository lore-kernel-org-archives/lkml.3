Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbaE1WTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 18:19:52 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:41607 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbaE1WTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 18:19:50 -0400
MIME-Version: 1.0
In-Reply-To: <53865B53.7050809@redhat.com>
References: <1401279399-23854-1-git-send-email-raghavendra.kt@linux.vnet.ibm.com>
	<53865B53.7050809@redhat.com>
Date: Wed, 28 May 2014 15:19:49 -0700
X-Google-Sender-Auth: 1-nNRZwDjG0RuZ_K3w3URFwuTKE
Message-ID: <CA+55aFx9d1dP+A3tdR-GaASQYBkkJHcV-=t9FdA7AGrMN12S0w@mail.gmail.com>
Subject: Re: [RFC] Implement Batched (group) ticket lock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Peter Anvin <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Waiman Long <waiman.long@hp.com>, Dave Jones <davej@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>, Jason Wang <jasowang@redhat.com>,
        fernando_b1@lab.ntt.co.jp,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>,
        xen-devel@lists.xenproject.org, Marcelo Tosatti <mtosatti@redhat.com>,
        "Vinod, Chegu" <chegu_vinod@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 2:55 PM, Rik van Riel <riel@redhat.com> wrote:
>
> Or maybe cmpxchg is cheap once you already own the cache line
> exclusively?

A locked cmpxchg ends up being anything between ~15-50 cycles
depending on microarchitecture if things are already exclusively in
the cache (with the P4 being an outlier, and all locked instructions
tend to take ~100+ cycles, but I can't say I can really find it in
myself to even care about netburst any more).

The most noticeable downside we've seen has been when we've used
"read-op-cmpxchg" as a _replacement_ for something like "lock [x]add",
when that "read+cmpxchg" has caused two cacheline ops (cacheline first
loaded shared by the read, then exclusive by the cmpxchg). That's bad.

But if preceded by a write (or, in this case, an xadd), that doesn't
happen. Still, those roughly 15-50 cycles can certainly be noticeable
(especially at the high end), but you need to have some load that
doesn't bounce the lock, and largely fit in the caches to see it. And
you probably want to test one of the older CPU's, I think Haswell is
the lower end (ie in the ~20 cycle range).

If somebody has a P4 still, that's likely the worst case by far.

              Linus
