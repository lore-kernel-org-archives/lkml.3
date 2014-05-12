Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758696AbaELOir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:38:47 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:34492 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758165AbaELOiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:38:46 -0400
Message-ID: <1399905481.4337.16.camel@jlt4.sipsolutions.net>
Subject: Re: [PATCH] compiler.h: don't use temporary variable in
 __compiletime_assert()
From: Johannes Berg <johannes@sipsolutions.net>
To: James Hogan <james.hogan@imgtec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Santos <daniel.santos@pobox.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-metag <linux-metag@vger.kernel.org>
Date: Mon, 12 May 2014 16:38:01 +0200
In-Reply-To: <5370CFAC.40705@imgtec.com>
References: <1399530685-7749-1-git-send-email-johannes@sipsolutions.net>
	 <5370CFAC.40705@imgtec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Unfortunately this breaks the build of today's linux-next for the Meta
> architecture (arch/metag), which happens to use a fairly old compiler
> (based on gcc 4.2.4) which I presume is the reason why.

That's very odd.

Unfortunately, I don't have most of arch/metag, it seems, where could I
get it? In particular no gup.c exists for metag in Linus's current tree.

> A bunch of compile time asserts fail, even in code which should be
> optimised out. E.g. here's one which I analysed:
> 
> mm/gup.c: In function ‘follow_page_mask’:
> mm/gup.c:208: error: size of array ‘type name’ is negative
> 
> Line 208 uses HPAGE_PMD_NR which expands to a HPAGE_PMD_SHIFT, which
> expands to a BUILD_BUG(). However that line is inside an if block
> conditioned on pmd_trans_huge(*pmd) which include/asm-generic/pgtable.h
> defines inline to return 0, so the whole block should already be being
> optimised out.
> 
> I don't understand why your patch should break things, I suspect it's
> related to the sparse behaviour you're trying to work around, but can we
> please drop this patch until a more portable workaround can be found?
> I'm happy to test further patches with metag if it helps.

I don't really understand that either - if the compiler could prove that
the assignment to __cond was a constant, and remember that __cond is now
constant, I don't really see why it can't follow that through and
consider "!(condition)" a const??

I suppose the other option for the original problem is to ignore
_compiletime_assert() for sparse, like we do for BUG_ON(), but it'd
probably be good to analyse more why this particular code is broken now.

johannes

