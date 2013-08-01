Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756596Ab3HAUrq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 16:47:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54981 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab3HAUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 16:47:44 -0400
Date: Thu, 1 Aug 2013 22:47:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: Waiman Long <Waiman.Long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Richard Weinberger <richard@nod.at>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Akinobu Mita <akinobu.mita@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        George Spelvin <linux@horizon.com>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: Re: [PATCH RFC 1/2] qspinlock: Introducing a 4-byte queue spinlock
 implementation
Message-ID: <20130801204710.GH27162@twins.programming.kicks-ass.net>
References: <1375324631-32868-1-git-send-email-Waiman.Long@hp.com>
 <1375324631-32868-2-git-send-email-Waiman.Long@hp.com>
 <51FAC3BA.9050705@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51FAC3BA.9050705@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 01:53:22AM +0530, Raghavendra K T wrote:

You need to learn to trim your replies.. I already stopped reading that
paravirt thread because of it. Soon I'll introduce you to my /dev/null
mail reader.

> On 08/01/2013 08:07 AM, Waiman Long wrote:
> >+static __always_inline void queue_spin_lock(struct qspinlock *lock)
> >+{
> >+	if (likely(queue_spin_trylock(lock)))
> >+		return;
> >+	queue_spin_lock_slowpath(lock);
> >+}
> 
> quickly falling into slowpath may hurt performance in some cases. no?
> 
> Instead, I tried something like this:
> 
> #define SPIN_THRESHOLD 64
> 
> static __always_inline void queue_spin_lock(struct qspinlock *lock)
> {
>         unsigned count = SPIN_THRESHOLD;
>         do {
>                 if (likely(queue_spin_trylock(lock)))
>                         return;
>                 cpu_relax();
>         } while (count--);
>         queue_spin_lock_slowpath(lock);
> }
> 
> Though I could see some gains in overcommit, but it hurted undercommit
> in some workloads :(.

This would break the FIFO nature of the lock.

