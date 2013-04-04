Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764447Ab3DDTKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:10:51 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:47083 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763430Ab3DDTKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1304041149030.29847@eggly.anvils>
References: <alpine.LNX.2.00.1304041120510.26822@eggly.anvils>
	<CA+55aFwCG2h1ijWTCJ38LVcUyczDAfk72c4MVSU+_-BiLoMOOw@mail.gmail.com>
	<alpine.LNX.2.00.1304041149030.29847@eggly.anvils>
Date: Thu, 4 Apr 2013 12:10:49 -0700
X-Google-Sender-Auth: 33Qpc3Pe4RvDf8LUxekhptICH9o
Message-ID: <CA+55aFzNYSRRDpewo2koEVC=kZEw9uvL67s9D9ENwtHJjQSCcg@mail.gmail.com>
Subject: Re: [PATCH] mm: prevent mmap_cache race in find_vma()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jan Stancek <jstancek@redhat.com>, Jakub Jelinek <jakub@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ian Lance Taylor <iant@google.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 12:01 PM, Hugh Dickins <hughd@google.com> wrote:
>
> When Paul reminded us of it yesterday, I came to wonder if actually
> every use of ACCESS_ONCE in the read form should strictly be matched
> by ACCESS_ONCE whenever modifying the location.
>
> My uneducated guess is that strictly it ought to, in the sense of
> insurance policy; but that (apart from that strange split writing
> issue which came up a couple of months ago) in practice our compilers
> have not "advanced" to the point of making this an issue yet.

I don't see how a compiler could reasonably really ever do anything
different, but I do think the ACCESS_ONCE() modification version might
be a good thing just as a "documentation".

This is a good example of this issue, exactly because we have a mix of
both speculative cases (the find_vma() lookup and modification)
together with strictly exclusive locked accesses to the same field
(the ones that invalidate the cache under the write lock). So
documenting that the write in find_vma() is this kind of "optimistic
unlocked access" is actually a potentially interesting piece of
information for programmers, completely independently of whether the
compiler will then treat it really differently or not.

Of course, a plain comment would do the same, but would be less greppable.

And despite the verbiage here, I don't really have a very strong
opinion on this. I'm going to let it go, and if somebody sends me a
patch with a good explanation in the next merge window, I'll probably
apply it.

                    Linus
