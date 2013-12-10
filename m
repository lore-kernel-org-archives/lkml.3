Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638Ab3LJNPX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 08:15:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48578 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab3LJNPU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 08:15:20 -0500
Date: Tue, 10 Dec 2013 14:14:22 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Ingo Molnar <mingo@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Will Deacon <will.deacon@arm.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Waiman Long <waiman.long@hp.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH v5 tip/core/locking 5/7]
 Documentation/memory-barriers.txt: Downgrade UNLOCK+LOCK
Message-ID: <20131210131422.GG12849@twins.programming.kicks-ass.net>
References: <20131210012738.GA24317@linux.vnet.ibm.com>
 <1386638883-25379-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386638883-25379-5-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 05:28:01PM -0800, Paul E. McKenney wrote:
> +An UNLOCK followed by a LOCK may -not- be assumed to be a full memory
> +barrier because it is possible for a preceding UNLOCK to pass a later LOCK
> +from the viewpoint of the CPU, but not from the viewpoint of the compiler.
> +Note that deadlocks cannot be introduced by this interchange because if
> +such a deadlock threatened, the UNLOCK would simply complete.

For me its easier to read if we start a new paragraph here.

> If it is
> +necessary for an UNLOCK-LOCK pair to produce a full barrier, the LOCK
> +can be followed by an smp_mb__after_unlock_lock() invocation.  This will
> +produce a full barrier if either (a) the UNLOCK and the LOCK are executed
> +by the same CPU or task, or (b) the UNLOCK and LOCK act on the same
> +lock variable.  The smp_mb__after_unlock_lock() primitive is free on
> +many architectures. 

The way I read the above it says that you need
smp_mb__after_unlock_lock() when the UNLOCK and LOCK are on the same
variable. That doesn't make sense, I thought that was the one case we
all agreed on it would indeed be a full barrier without extra trickery.

So I would expect something like:

"If it is necessary for an UNLOCK-LOCK pair to produce a full barrier,
you must either ensure they operate on the same lock variable, or place
smp_mb__after_unlock_lock() after the LOCK."

> Without smp_mb__after_unlock_lock(), the UNLOCK
> +and LOCK can cross:
> +
> +	*A = a;
> +	UNLOCK
> +	LOCK
> +	*B = b;
> +
> +may occur as:
> +
> +	LOCK, STORE *B, STORE *A, UNLOCK
> +
> +With smp_mb__after_unlock_lock(), they cannot, so that:
> +
> +	*A = a;
> +	UNLOCK
> +	LOCK
> +	smp_mb__after_unlock_lock();
> +	*B = b;
> +
> +will always occur as:
> +
> +	STORE *A, UNLOCK, LOCK, STORE *B
> +

Since we introduced the concept of lock variables -- since it now
matters if the UNLOCK and LOCK act on the same one or not, we should
reflect that in the above examples (and maybe throughout the document).

That is; we should clarify:

  *A = a
  UNLOCK x
  LOCK y
  *B = b

Being different from:

  *A = a
  UNLOCK x
  LOCK x
  *B = b

I also find the wording slightly weird in that LOCK and UNLOCK are
stopped from crossing by smp_mb__after_unlock_lock(). They are not, what
it stopped is *B = b from moving up and the rest from moving down. The
UNLOCK and LOCK can still cross -- they happened before we issued the
barrier after all.
