Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752269AbaFFRML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 13:12:11 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58799 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaFFRMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 13:12:09 -0400
Date: Fri, 6 Jun 2014 19:11:45 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, mpatocka@redhat.com,
        torvalds@linux-foundation.org, jason.low2@hp.com, waiman.long@hp.com,
        jejb@parisc-linux.org, paulmck@linux.vnet.ibm.com,
        dave.anglin@bell.net, aswin@hp.com, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, davem@davemloft.net,
        james.hogan@imgtec.com, cmetcalf@tilera.com, vgupta@synopsys.com
Subject: Re: [PATCH 2/2] locking/rwsem: Disable optimistic spinning for
 PA-RISC
Message-ID: <20140606171145.GU13930@laptop.programming.kicks-ass.net>
References: <1402070140-15090-1-git-send-email-davidlohr@hp.com>
 <1402070140-15090-3-git-send-email-davidlohr@hp.com>
 <1402070987.2207.75.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1402070987.2207.75.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 09:09:47AM -0700, James Bottomley wrote:
> On Fri, 2014-06-06 at 08:55 -0700, Davidlohr Bueso wrote:
> > PA-RISC's cmpxchg is not save against normal stores and the code used
> > for optimistic spinning is known broken because of this.
> 
> What about all the other identified architectures?  The problem is that
> unless you can do an atomic Read Modify Write on your architecture, you
> have to implement our exchange primitives with locking, and that makes
> you unsafe against stores  We happen to be the architecture that
> detected this, but I thought we agreed sparc32, metag, tile32, arc and
> possibly hexagon have this problem.
> 
> Rather than naming all the failing architectures, we probably want an 
> 
> ARCH_NO_ATOMIC_RMW

The thing is, all these archs are broken beyond this particular problem,
Mikulas Patocka found a number of other spots.

In any case, sure I can exclude more. Although ideally someone goes do
that __atomic sparse thing to flush out all this.

---
Subject: locking, mutex: Disable optimistic spinning on !RMW archs

For some archs a regular store does not play nice with cmpxchg(), the
optimistic spinning code (and various other places not caught by this)
break this assumption and make things go boom.

Until something better is found, disable optimistic spinning for these
archs.

Cc: James.Bottomley@HansenPartnership.com
Cc: davem@davemloft.net
Cc: james.hogan@imgtec.com
Cc: cmetcalf@tilera.com
Cc: vgupta@synopsys.com
Reported-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
---
 kernel/Kconfig.locks | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/Kconfig.locks b/kernel/Kconfig.locks
index d2b32ac27a39..b9c132c48bf1 100644
--- a/kernel/Kconfig.locks
+++ b/kernel/Kconfig.locks
@@ -220,6 +220,10 @@ config INLINE_WRITE_UNLOCK_IRQRESTORE
 
 endif
 
+config ARCH_NO_ATOMIC_RMW
+	def_bool y
+	depends on PARISC || SPARC32 || METAG_ATOMICITY_LOCK1 || (TILE && !TILEGX) || (ARC && !ARC_HAS_LLSC)
+
 config MUTEX_SPIN_ON_OWNER
 	def_bool y
-	depends on SMP && !DEBUG_MUTEXES
+	depends on SMP && !DEBUG_MUTEXES && !ARCH_NO_ATOMIC_RMW
