Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874AbaJYVAw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 17:00:52 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:41115 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852AbaJYVAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 17:00:49 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: David Miller <davem@davemloft.net>, akpm@linux-foundation.org
Cc: steve.capper@linaro.org, aarcange@redhat.com, benh@kernel.crashing.org,
        mpe@ellerman.id.au, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH V2 1/2] mm: Update generic gup implementation to handle hugepage directory
In-Reply-To: <20141023.184035.388557314666522484.davem@davemloft.net>
References: <1413520687-31729-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20141022160224.9c2268795e55d5a2eff5b94d@linux-foundation.org> <20141023.184035.388557314666522484.davem@davemloft.net>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Sat, 25 Oct 2014 16:00:05 +0530
Message-ID: <87ppdg30ia.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102510-0025-0000-0000-00000061D6E9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:

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


But that won't work with RCU GUP. For example on powerpc the tlb flush
doesn't involve an IPI and we can essentially find page count 0.

-aneesh

