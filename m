Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaACDjS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 22:39:18 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39781 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743AbaACDjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 22:39:17 -0500
X-Originating-IP: 50.43.14.201
Date: Thu, 2 Jan 2014 19:39:07 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com
Subject: Re: Memory allocator semantics
Message-ID: <20140103033906.GB2983@leaf>
References: <20140102203320.GA27615@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140102203320.GA27615@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 12:33:20PM -0800, Paul E. McKenney wrote:
> Hello!
> 
> From what I can see, the Linux-kernel's SLAB, SLOB, and SLUB memory
> allocators would deal with the following sort of race:
> 
> A.	CPU 0: r1 = kmalloc(...); ACCESS_ONCE(gp) = r1;
> 
> 	CPU 1: r2 = ACCESS_ONCE(gp); if (r2) kfree(r2);
> 
> However, my guess is that this should be considered an accident of the
> current implementation rather than a feature.  The reason for this is
> that I cannot see how you would usefully do (A) above without also allowing
> (B) and (C) below, both of which look to me to be quite destructive:

(A) only seems OK if "gp" is guaranteed to be NULL beforehand, *and* if
no other CPUs can possibly do what CPU 1 is doing in parallel.  Even
then, it seems questionable how this could ever be used successfully in
practice.

This seems similar to the TCP simultaneous-SYN case: theoretically
possible, absurd in practice.

> B.	CPU 0: r1 = kmalloc(...);  ACCESS_ONCE(shared_x) = r1;
> 
>         CPU 1: r2 = ACCESS_ONCE(shared_x); if (r2) kfree(r2);
> 
> 	CPU 2: r3 = ACCESS_ONCE(shared_x); if (r3) kfree(r3);
> 
> 	This results in the memory being on two different freelists.

That's a straightforward double-free bug.  You need some kind of
synchronization there to ensure that only one call to kfree occurs.

> C.      CPU 0: r1 = kmalloc(...);  ACCESS_ONCE(shared_x) = r1;
> 
> 	CPU 1: r2 = ACCESS_ONCE(shared_x); r2->a = 1; r2->b = 2;
> 
> 	CPU 2: r3 = ACCESS_ONCE(shared_x); if (r3) kfree(r3);
> 
> 	CPU 3: r4 = kmalloc(...);  r4->s = 3; r4->t = 4;
> 
> 	This results in the memory being used by two different CPUs,
> 	each of which believe that they have sole access.

This is not OK either: CPU 2 has called kfree on a pointer that CPU 1
still considers alive, and again, the CPUs haven't used any form of
synchronization to prevent that.

> But I thought I should ask the experts.
> 
> So, am I correct that kernel hackers are required to avoid "drive-by"
> kfree()s of kmalloc()ed memory?

Don't kfree things that are in use, and synchronize to make sure all
CPUs agree about "in use", yes.

> PS.  To the question "Why would anyone care about (A)?", then answer
>      is "Inquiring programming-language memory-model designers want
>      to know."

I find myself wondering about the original form of the question, since
I'd hope that programming-languge memory-model designers would
understand the need for synchronization around reclaiming memory.

- Josh Triplett
