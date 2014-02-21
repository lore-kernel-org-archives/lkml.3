Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbaBUVYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 16:24:35 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:63267 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771AbaBUVYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 16:24:34 -0500
MIME-Version: 1.0
In-Reply-To: <1393016226.3039.44.camel@buesod1.americas.hpqcorp.net>
References: <1392960523.3039.16.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFw1_Ecbjjv9vijj3o46mkq3NrJn0X-FnbpCGBZG2=NuOA@mail.gmail.com>
	<1393016226.3039.44.camel@buesod1.americas.hpqcorp.net>
Date: Fri, 21 Feb 2014 13:24:33 -0800
X-Google-Sender-Auth: pXKukTaVjvPIdSbqlvlnvdhyEKk
Message-ID: <CA+55aFzw24Mwk_xw3QM_36-TbDOya=XZCqUeSSBVNS1QfjnWEw@mail.gmail.com>
Subject: Re: [PATCH] mm: per-thread vma caching
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Michel Lespinasse <walken@google.com>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 21, 2014 at 12:57 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>
> Btw, one concern I had is regarding seqnum overflows... if such
> scenarios should happen we'd end up potentially returning bogus vmas and
> getting bus errors and other sorts of issues. So we'd have to flush the
> caches, but, do we care? I guess on 32bit systems it could be a bit more
> possible to trigger given enough forking.

I guess we should do something like

    if (unlikely(!++seqnum))
        flush_vma_cache()

just to not have to worry about it.

And we can either use a "#ifndef CONFIG_64BIT" to disable it for the
64-bit case (because no, we really don't need to worry about overflow
in 64 bits ;), or just decide that a 32-bit sequence number actually
packs better in the structures, and make it be an "u32" even on 64-bit
architectures?

It looks like a 32-bit sequence number might pack nicely next to the

    unsigned brk_randomized:1;

but I didn't actually go and look at the context there to see what
else is there..

                   Linus
