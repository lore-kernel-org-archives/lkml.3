Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270AbaJWWk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 18:40:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44385 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751102AbaJWWk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 18:40:56 -0400
Date: Thu, 23 Oct 2014 18:40:35 -0400 (EDT)
Message-Id: <20141023.184035.388557314666522484.davem@davemloft.net>
To: akpm@linux-foundation.org
Cc: aneesh.kumar@linux.vnet.ibm.com, steve.capper@linaro.org,
        aarcange@redhat.com, benh@kernel.crashing.org, mpe@ellerman.id.au,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        hannes@cmpxchg.org
Subject: Re: [PATCH V2 1/2] mm: Update generic gup implementation to handle
 hugepage directory
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141022160224.9c2268795e55d5a2eff5b94d@linux-foundation.org>
References: <1413520687-31729-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
	<20141022160224.9c2268795e55d5a2eff5b94d@linux-foundation.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 15:40:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hey guys, was looking over the generic GUP while working on a sparc64
issue and I noticed that you guys do speculative page gets, and after
talking with Johannes Weiner (CC:'d) about this we don't see how it
could be necessary.

If interrupts are disabled during the page table scan (which they
are), no IPI tlb flushes can arrive.  Therefore any removal from the
page tables is guarded by interrupts being re-enabled.  And as a
result, page counts of pages we see in the page tables must always
have a count > 0.

x86 does direct atomic_add() on &page->_count because of this
invariant and I would rather see the generic version do this too.
