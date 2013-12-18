Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3LRVhb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:37:31 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:44356 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754669Ab3LRVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:37:28 -0500
MIME-Version: 1.0
In-Reply-To: <20131218192005.GA8340@redhat.com>
References: <20131218191913.GA6464@redhat.com>
	<20131218192005.GA8340@redhat.com>
Date: Wed, 18 Dec 2013 13:37:27 -0800
X-Google-Sender-Auth: sYsEDm5S-ZEKnzvL5wtoU3QdN5s
Message-ID: <CA+55aFyVNDFY87V2TZ9ViS7TUMyH7n88g-V=CdB5_c9+=M+fNQ@mail.gmail.com>
Subject: Re: [PATCH -mm 6/7] mm: thp: introduce get_lock_thp_head()
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 11:20 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Both __put_page_tail() and __get_page_tail() need to carefully
> take a reference on page_head, take compound_lock() and recheck
> PageTail(page) under this lock.

Btw I suspect this is just disgustingly expensive, and I don't think
there's a really good reason for it.

May I suggest:

 - getting rid of the PG_compound_lock bit-lock

   bitlocks are expensive and unfair, and don't even get lockdep checking

 - replace it with a (small, say 32-256 entries) array of hashed sequence locks

 - just hash based on the "struct page" pointer, and teach this code
to do a read_seqcount_begin/read_seqcount_retry sequence instead for
the page lookup.

I think you can get rid of all the irq disables too, and the sequence
lock should be pure memory reads for the read-case that we care about.

Hmm? This is obviously orthogonal to your series, I just reacted to
seeing that bitlock thing that needs atomics for both locking and
unlocking and the irq disable, and just generally looks like the worst
possible way to do these things.

              Linus
