Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934105AbaD3QcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:32:22 -0400
Received: from g4t3425.houston.hp.com ([15.201.208.53]:46293 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073AbaD3QcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:32:21 -0400
Message-ID: <1398875537.2618.9.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] rwsem: Support optimistic spinning
From: Davidlohr Bueso <davidlohr@hp.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Alex Shi <alex.shi@linaro.org>,
        Andi Kleen <andi@firstfloor.org>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E.McKenney" <paulmck@linux.vnet.ibm.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-kernel@vger.kernel.org
Date: Wed, 30 Apr 2014 09:32:17 -0700
In-Reply-To: <20140430092136.GD11096@twins.programming.kicks-ass.net>
References: <1398205166.6345.7.camel@buesod1.americas.hpqcorp.net>
	 <1398722941.25549.16.camel@buesod1.americas.hpqcorp.net>
	 <20140430092136.GD11096@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-04-30 at 11:21 +0200, Peter Zijlstra wrote:
> On Mon, Apr 28, 2014 at 03:09:01PM -0700, Davidlohr Bueso wrote:
> > +#ifdef CONFIG_SMP
> 
> > +#else
> > +static bool rwsem_optimistic_spin(struct rw_semaphore *sem)
> > +{
> > +	return false;
> > +}
> > +#endif
> 
> On the mutex side we guard this with MUTEX_SPIN_ON_OWNER, do we want to
> use that here too?

I thought of it, but hated adding mutex naming to rwsem code -- we
already do it for cpu_relax() thanks to s390.

MUTEX_SPIN_ON_OWNER depends on SMP && !DEBUG_MUTEXES.
Right now rwsem optimistic spinning depends on SMP && RWSEM_XCHGADD_ALGORITHM.

It might sense to add RWSEM_SPIN_ON_OWNER to encapsulate what we already
have. I don't think we want DEBUG_MUTEX dependencies in rwsems. Would
you accept such thing?

Thanks,
Davidlohr

