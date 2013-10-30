Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180Ab3J3Pjz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:39:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47225 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab3J3Pjy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:39:54 -0400
Date: Wed, 30 Oct 2013 16:39:31 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Victor Kaplansky <VICTORK@il.ibm.com>
Cc: Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PPC dev <linuxppc-dev@ozlabs.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        Michael Ellerman <michael@ellerman.id.au>,
        Michael Neuling <mikey@neuling.org>, Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: perf events ring buffer memory barrier on powerpc
Message-ID: <20131030153931.GM16117@laptop.programming.kicks-ass.net>
References: <20131025173749.GG19466@laptop.lan>
 <CAFTL4hxn47KFKZPLgKeBxxdaAbA4vg9QVzctuW4ZrSgmfX5bAQ@mail.gmail.com>
 <OFB9096CCA.68AAFFFB-ON42257C12.0044F107-42257C12.00457129@il.ibm.com>
 <20131028132634.GO19466@laptop.lan>
 <20131028163418.GD4126@linux.vnet.ibm.com>
 <20131028201735.GA15629@redhat.com>
 <OF58D85F5A.03E37A80-ON42257C12.0070E552-42257C12.00734308@il.ibm.com>
 <20131030092725.GL4126@linux.vnet.ibm.com>
 <20131030112526.GI16117@laptop.programming.kicks-ass.net>
 <OFF6C78E48.E477DB1E-ON42257C14.0050F9B3-42257C14.0051AC6D@il.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFF6C78E48.E477DB1E-ON42257C14.0050F9B3-42257C14.0051AC6D@il.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 04:52:05PM +0200, Victor Kaplansky wrote:
> Peter Zijlstra <peterz@infradead.org> wrote on 10/30/2013 01:25:26 PM:
> 
> > Also, I'm not entirely sure on C, that too seems like a dependency, we
> > simply cannot read the buffer @tail before we've read the tail itself,
> > now can we? Similarly we cannot compare tail to head without having the
> > head read completed.
> 
> No, this one we cannot omit, because our problem on consumer side is not
> with @tail, which is written exclusively by consumer, but with @head.

Ah indeed, my argument was flawed in that @head is the important part.
But we still do a comparison of @tail against @head before we do further
reads.

Although I suppose speculative reads are allowed -- they don't have the
destructive behaviour speculative writes have -- and thus we could in
fact get reorder issues.

But since it is still a dependent load in that we do that @tail vs @head
comparison before doing other loads, wouldn't a read_barrier_depends()
be sufficient? Or do we still need a complete rmb?

> BTW, it is why you also don't need ACCESS_ONCE() around @tail, but only
> around
> @head read.

Agreed, the ACCESS_ONCE() around tail is superfluous since we're the one
updating tail, so there's no problem with the value changing
unexpectedly.
