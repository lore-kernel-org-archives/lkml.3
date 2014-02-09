Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbaBICAN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 21:00:13 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:46365 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaBICAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 21:00:11 -0500
Date: Sat, 8 Feb 2014 18:00:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@iki.fi>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux-foundation.org,
        penberg@kernel.org, mpm@selenic.com
Subject: Re: Memory allocator semantics
Message-ID: <20140209020004.GY4250@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140102203320.GA27615@linux.vnet.ibm.com>
 <52F60699.8010204@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52F60699.8010204@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020902-1542-0000-0000-000005E980D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 12:27:37PM +0200, Pekka Enberg wrote:
> Hi Paul,
> 
> On 01/02/2014 10:33 PM, Paul E. McKenney wrote:
> > From what I can see, the Linux-kernel's SLAB, SLOB, and SLUB memory
> >allocators would deal with the following sort of race:
> >
> >A.	CPU 0: r1 = kmalloc(...); ACCESS_ONCE(gp) = r1;
> >
> >	CPU 1: r2 = ACCESS_ONCE(gp); if (r2) kfree(r2);
> >
> >However, my guess is that this should be considered an accident of the
> >current implementation rather than a feature.  The reason for this is
> >that I cannot see how you would usefully do (A) above without also allowing
> >(B) and (C) below, both of which look to me to be quite destructive:
> >
> >B.	CPU 0: r1 = kmalloc(...);  ACCESS_ONCE(shared_x) = r1;
> >
> >         CPU 1: r2 = ACCESS_ONCE(shared_x); if (r2) kfree(r2);
> >
> >	CPU 2: r3 = ACCESS_ONCE(shared_x); if (r3) kfree(r3);
> >
> >	This results in the memory being on two different freelists.
> >
> >C.      CPU 0: r1 = kmalloc(...);  ACCESS_ONCE(shared_x) = r1;
> >
> >	CPU 1: r2 = ACCESS_ONCE(shared_x); r2->a = 1; r2->b = 2;
> >
> >	CPU 2: r3 = ACCESS_ONCE(shared_x); if (r3) kfree(r3);
> >
> >	CPU 3: r4 = kmalloc(...);  r4->s = 3; r4->t = 4;
> >
> >	This results in the memory being used by two different CPUs,
> >	each of which believe that they have sole access.
> >
> >But I thought I should ask the experts.
> >
> >So, am I correct that kernel hackers are required to avoid "drive-by"
> >kfree()s of kmalloc()ed memory?
> 
> So to be completely honest, I don't understand what is the race in
> (A) that concerns the *memory allocator*.  I also don't what the
> memory allocator can do in (B) and (C) which look like double-free
> and use-after-free, respectively, to me. :-)

>From what I can see, (A) works by accident, but is kind of useless because
you allocate and free the memory without touching it.  (B) and (C) are the
lightest touches I could imagine, and as you say, both are bad.  So I
believe that it is reasonable to prohibit (A).

Or is there some use for (A) that I am missing?

							Thanx, Paul

