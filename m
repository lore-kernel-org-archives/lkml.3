Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622AbaBHK1l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 05:27:41 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50370 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751063AbaBHK1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 05:27:39 -0500
X-Sasl-enc: uaWdfH38Smv11IXh7+Ghxoc5Hf/SHJ62ES2zIf1VcOge 1391855258
Message-ID: <52F60699.8010204@iki.fi>
Date: Sat, 08 Feb 2014 12:27:37 +0200
From: Pekka Enberg <penberg@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
CC: cl@linux-foundation.org, penberg@kernel.org, mpm@selenic.com
Subject: Re: Memory allocator semantics
References: <20140102203320.GA27615@linux.vnet.ibm.com>
In-Reply-To: <20140102203320.GA27615@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On 01/02/2014 10:33 PM, Paul E. McKenney wrote:
>  From what I can see, the Linux-kernel's SLAB, SLOB, and SLUB memory
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
>
> B.	CPU 0: r1 = kmalloc(...);  ACCESS_ONCE(shared_x) = r1;
>
>          CPU 1: r2 = ACCESS_ONCE(shared_x); if (r2) kfree(r2);
>
> 	CPU 2: r3 = ACCESS_ONCE(shared_x); if (r3) kfree(r3);
>
> 	This results in the memory being on two different freelists.
>
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
>
> But I thought I should ask the experts.
>
> So, am I correct that kernel hackers are required to avoid "drive-by"
> kfree()s of kmalloc()ed memory?

So to be completely honest, I don't understand what is the race in (A) 
that concerns the *memory allocator*.  I also don't what the memory 
allocator can do in (B) and (C) which look like double-free and 
use-after-free, respectively, to me. :-)

                       Pekka
