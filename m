Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab3IMA4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 20:56:25 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:42050 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab3IMA4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 20:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<20130910222924.GB13318@ZenIV.linux.org.uk>
	<20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
	<20130910223624.GC13318@ZenIV.linux.org.uk>
	<20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
	<20130910224823.GE13318@ZenIV.linux.org.uk>
	<20130910225934.GF13318@ZenIV.linux.org.uk>
	<CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
Date: Thu, 12 Sep 2013 17:56:08 -0700
X-Google-Sender-Auth: GNHOOsTDAcHHi_qnfat6RRo6_Cg
Message-ID: <CA+55aFxz2r3voP=W0oCns5MzMqBaeYxMLxp5AxRxjY23K3nvuA@mail.gmail.com>
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

On Tue, Sep 10, 2013 at 4:37 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> From a quick look, this looks pretty broken:
>
>     if (list_lru_add(&dentry->d_sb->s_dentry_lru, &dentry->d_lru))
>         this_cpu_inc(nr_dentry_unused);
>     dentry->d_flags |= DCACHE_LRU_LIST;
>
> because if that list_lru_add() can fail, then we shouldn't set the
> DCACHE_LRU_LIST bit either.
>
> That said, I don't see how it can fail. We only do this with the
> dentry locked, and when it's not already on the LRU list. So I think
> the "if()" is just misleading and unnecessary - but the code works.

So I thought you'd clean this up. Looking again, it still seems really
confused, and I'm finding actual bugs.

You don't clear the DCACHE_LRU_LIST when you remove dentries from the
d_lru list. In other cases (like shrink_dentry_list), you clear just
the DCACHE_SHRINK_LIST.

As a result, the "if ()" isn't necessarily unnecessary, but there are
actual bugs. It looks like the dentry can be removed from the d_lru
lists without the bit ever getting cleared, and if that happens, it
will never be moved back.

The rule for DCACHE_LRU_LIST was - and should be - that the bit is set
IFF the d_lru list is not empty. So it gets set when a dentry is moved
to the LRU lists, but it _stays_ set if the dentry is moved to the
shrink_list. It then gets cleared when the dentry is removed from any
d_lru list (ie "list_del_init()").

I'll walk through the code, it looked suspicious. Maybe there's
something subtle that makes it work, but I don't see it.

           Linus
