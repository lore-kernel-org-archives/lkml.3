Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab3IJXx4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:53:56 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59425 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3IJXxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:53:54 -0400
Date: Wed, 11 Sep 2013 00:53:49 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@openvz.org>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20130910235349.GG13318@ZenIV.linux.org.uk>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
 <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
 <20130910222924.GB13318@ZenIV.linux.org.uk>
 <20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
 <20130910223624.GC13318@ZenIV.linux.org.uk>
 <20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
 <20130910224823.GE13318@ZenIV.linux.org.uk>
 <20130910225934.GF13318@ZenIV.linux.org.uk>
 <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 04:37:19PM -0700, Linus Torvalds wrote:
> On Tue, Sep 10, 2013 at 3:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > It's not that bad, actually; I think the variant I've pushed right now
> > (vfs.git#for-next, head at f5e1dd34561e0fb06400b378d595198918833021) should
> > be doing the right thing.  It ought to cover everything in your branch
> > in -next from "fs: bump inode and dentry counters to long" on to the
> > end of queue.
> 
> >From a quick look, this looks pretty broken:
> 
>     if (list_lru_add(&dentry->d_sb->s_dentry_lru, &dentry->d_lru))
>         this_cpu_inc(nr_dentry_unused);
>     dentry->d_flags |= DCACHE_LRU_LIST;
> 
> because if that list_lru_add() can fail, then we shouldn't set the
> DCACHE_LRU_LIST bit either.

list_lru_add() can fail if it's already on the list; leaving the counter
alone should've been conditional on that, setting the flag - no.  Said
that, it probably should be WARN_ON(!...); this_cpu_inc(); ... |= ...;
