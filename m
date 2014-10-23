Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbaJWXli (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:41:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:35149 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751573AbaJWXlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:41:36 -0400
Message-ID: <1414107635.364.91.camel@pasglop>
Subject: Re: [PATCH V2 1/2] mm: Update generic gup implementation to handle
 hugepage directory
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com,
        steve.capper@linaro.org, aarcange@redhat.com, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        hannes@cmpxchg.org
Date: Fri, 24 Oct 2014 10:40:35 +1100
In-Reply-To: <20141023.184035.388557314666522484.davem@davemloft.net>
References: <1413520687-31729-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	 <20141022160224.9c2268795e55d5a2eff5b94d@linux-foundation.org>
	 <20141023.184035.388557314666522484.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-23 at 18:40 -0400, David Miller wrote:
> Hey guys, was looking over the generic GUP while working on a sparc64
> issue and I noticed that you guys do speculative page gets, and after
> talking with Johannes Weiner (CC:'d) about this we don't see how it
> could be necessary.
> 
> If interrupts are disabled during the page table scan (which they
> are), no IPI tlb flushes can arrive.  Therefore any removal from the
> page tables is guarded by interrupts being re-enabled.  And as a
> result, page counts of pages we see in the page tables must always
> have a count > 0.
> 
> x86 does direct atomic_add() on &page->_count because of this
> invariant and I would rather see the generic version do this too.

This is of course only true of archs who use IPIs for TLB flushes, so if
we are going down the path of not being speculative, powerpc would have
to go back to doing its own since our broadcast TLB flush means we
aren't protected (we are only protected vs. the page tables themselves
being freed since we do that via sched RCU).

AFAIK, ARM also broadcasts TLB flushes...

Another option would be to make the generic code use something defined
by the arch to decide whether to use speculative get or
not. I like the idea of keeping the bulk of that code generic...

Cheers,
Ben.

> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


