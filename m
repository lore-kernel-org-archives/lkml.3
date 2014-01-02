Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531AbaABUdl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 15:33:41 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58770 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751841AbaABUdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 15:33:40 -0500
Date: Thu, 2 Jan 2014 12:33:20 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com
Subject: Memory allocator semantics
Message-ID: <20140102203320.GA27615@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14010220-7164-0000-0000-000004C6FE58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello!

>From what I can see, the Linux-kernel's SLAB, SLOB, and SLUB memory
allocators would deal with the following sort of race:

A.	CPU 0: r1 = kmalloc(...); ACCESS_ONCE(gp) = r1;

	CPU 1: r2 = ACCESS_ONCE(gp); if (r2) kfree(r2);

However, my guess is that this should be considered an accident of the
current implementation rather than a feature.  The reason for this is
that I cannot see how you would usefully do (A) above without also allowing
(B) and (C) below, both of which look to me to be quite destructive:

B.	CPU 0: r1 = kmalloc(...);  ACCESS_ONCE(shared_x) = r1;

        CPU 1: r2 = ACCESS_ONCE(shared_x); if (r2) kfree(r2);

	CPU 2: r3 = ACCESS_ONCE(shared_x); if (r3) kfree(r3);

	This results in the memory being on two different freelists.

C.      CPU 0: r1 = kmalloc(...);  ACCESS_ONCE(shared_x) = r1;

	CPU 1: r2 = ACCESS_ONCE(shared_x); r2->a = 1; r2->b = 2;

	CPU 2: r3 = ACCESS_ONCE(shared_x); if (r3) kfree(r3);

	CPU 3: r4 = kmalloc(...);  r4->s = 3; r4->t = 4;

	This results in the memory being used by two different CPUs,
	each of which believe that they have sole access.

But I thought I should ask the experts.

So, am I correct that kernel hackers are required to avoid "drive-by"
kfree()s of kmalloc()ed memory?

							Thanx, Paul

PS.  To the question "Why would anyone care about (A)?", then answer
     is "Inquiring programming-language memory-model designers want
     to know."

