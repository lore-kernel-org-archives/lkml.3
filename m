Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754369Ab3KCSv3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 13:51:29 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:56699 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab3KCSv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 13:51:28 -0500
MIME-Version: 1.0
In-Reply-To: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
References: <1383337039.2653.18.camel@buesod1.americas.hpqcorp.net>
Date: Sun, 3 Nov 2013 10:51:27 -0800
X-Google-Sender-Auth: nZ_bMKpIjSmFTTsNREBqKKddiy8
Message-ID: <CA+55aFwrtOaFtwGc6xyZH6-1j3f--AG1JS-iZM8-pZPnwRHBow@mail.gmail.com>
Subject: Re: [PATCH] mm: cache largest vma
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ugh. This patch makes me angry. It looks way too ad-hoc.

I can well imagine that our current one-entry cache is crap and could
be improved, but this looks too random. Different code for the
CONFIG_MMU case? Same name, but for non-MMU it's a single entry, for
MMU it's an array? And the whole "largest" just looks odd. Plus why do
you set LAST_USED if you also set LARGEST?

Did you try just a two- or four-entry pseudo-LRU instead, with a
per-thread index for "last hit"? Or even possibly a small fixed-size
hash table (say "idx = (add >> 10) & 3" or something)?

And what happens for threaded models? Maybe we'd be much better off
making the cache be per-thread, and the flushing of the cache would be
a sequence number that has to match (so "vma_clear_cache()" ends up
just incrementing a 64-bit sequence number in the mm)?

Basically, my complaints boil down to "too random" and "too
specialized", and I can see (and you already comment on) this patch
being grown with even *more* ad-hoc random new cases (LAST, LARGEST,
MOST_USED - what's next?). And while I don't know if we should worry
about the threaded case, I do get the feeling that this ad-hoc
approach is guaranteed to never work for that, which makes me feel
that it's not just ad-hoc, it's also fundamentally limited.

I can see us merging this patch, but I would really like to hear that
we do so because other cleaner approaches don't work well. In
particular, pseudo-LRU tends to be successful (and cheap) for caches.

                 Linus
