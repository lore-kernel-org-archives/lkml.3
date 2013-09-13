Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab3IMUAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 16:00:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45037 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753441Ab3IMUAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 16:00:06 -0400
Date: Fri, 13 Sep 2013 21:00:00 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130913200000.GT13318@ZenIV.linux.org.uk>
References: <20130910222924.GB13318@ZenIV.linux.org.uk>
 <20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
 <20130910223624.GC13318@ZenIV.linux.org.uk>
 <20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
 <20130910224823.GE13318@ZenIV.linux.org.uk>
 <20130910225934.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
 <CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
 <CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
 <CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyaRsk-KkjppTnqDxy8+y5z9Yvi3TpMZwgGJ7ad7kwM4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 13, 2013 at 12:12:20PM -0700, Linus Torvalds wrote:

> It tries to consolidate the dentry LRU stuff into a few helper
> functions that right now have anal checking of the flags. Maybe I
> overdid it, but the code was really confusing, and I think we got the
> free dentry counts wrong, and the bits wrong too, so I tried to be
> extra careful.
> 
> There are several cases:
>  - d_lru_add/del: fairly obvious
>  - d_lru_isolate: this is when the LRU callbacks ask us to remove the
> entry from the list. This is different from d_lru_del() only in that
> it uses the raw list removal, not the lru list helper function. I'm
> not sure that's right, but that's what the code used to do.

It is right - for one thing, we are holding the lock on that LRU list,
so list_lru_del() would deadlock right there.  For another, the same
list_lru_walk (OK, list_lru_walk_node()) will do ->nr_items decrement
when we return LRU_REMOVED to it, so we don't want to do it twice.
Plain list_del_init() is correct here.

>  - d_lru_shrink_move: move from the "global" lru list to a private shrinker list
>  - d_shrink_add/del: fairly obvious.
> 
> And then "denty_lru_add/del" that actually take the current state into
> account and do the right thing. Those we had before, I'm just
> explaining the difference from the low-level operations that have
> fixed "from this state to that" semantics

Looks sane; FWIW, the variant I'm playing with uses two independent
flags for "shrinker" and "per-sb", but AFAICS that doesn't yield better
code.  Feel free to slap my acked-by on it.
