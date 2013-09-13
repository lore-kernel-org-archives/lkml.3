Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab3IMBM2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 21:12:28 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:52341 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3IMBMZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 21:12:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<20130910222924.GB13318@ZenIV.linux.org.uk>
	<20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
	<20130910223624.GC13318@ZenIV.linux.org.uk>
	<20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
	<20130910224823.GE13318@ZenIV.linux.org.uk>
	<20130910225934.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
	<CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
Date: Thu, 12 Sep 2013 18:12:24 -0700
X-Google-Sender-Auth: fJSc4eVnPn9YUlGVRoFn3dg0zAs
Message-ID: <CA+55aFxnq2hjx1Aw7+iFuGnZp4sRK3HYK0Kfipz1gEYubOdnYQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 5:56 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll walk through the code, it looked suspicious. Maybe there's
> something subtle that makes it work, but I don't see it.

Btw, it's not just the DCACHE_LRU_LIST bit. The games with
"nr_dentry_unused" look totally broken too. It's decremented in
dentry_lru_isolate_shrink() for each dentry we remove, and then it is
decremented *again* in shrink_dcache_sb() by the number of dentries we
removed.

Maybe I'm confused, but the code sure looks more confused than I feel.

I would suggest keeping the same semantics for 'nr_dentry_unused'.
Dentries are unused whether they are on the "real" LRU list or have
been tagged with DCACHE_SHRINK_LIST. So moving from one list to the
other does nothing. It's the "list_del_init()" that should trigger
both 'nr_dentry_unused' and DCACHE_LRU_LIST bit-clearing.

In fact, maybe a helper function for _actually_ removing the thing
from all lists, and adding them back. Right now there are
"list_del_init()" and "list_add[_tail]()" calls sprinkled around in
random places, mixed up with the new "list_lru_add()".

Damn, the code is too confused. I have to go to a highschool parent
back-to-school meeting, so I won't get to this until maybe on a plane
tomorrow. Al, can you please give this a look?

             Linus
