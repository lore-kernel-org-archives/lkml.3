Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab3IJXhW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 19:37:22 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:43975 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab3IJXhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 19:37:20 -0400
MIME-Version: 1.0
In-Reply-To: <20130910225934.GF13318@ZenIV.linux.org.uk>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
	<20130910152753.662599171456233c5f91edb4@linux-foundation.org>
	<20130910222924.GB13318@ZenIV.linux.org.uk>
	<20130910153520.14e49cd32feb16d45eb8abac@linux-foundation.org>
	<20130910223624.GC13318@ZenIV.linux.org.uk>
	<20130910154116.cc4afe048213a779040ea3cc@linux-foundation.org>
	<20130910224823.GE13318@ZenIV.linux.org.uk>
	<20130910225934.GF13318@ZenIV.linux.org.uk>
Date: Tue, 10 Sep 2013 16:37:19 -0700
X-Google-Sender-Auth: 9oy69M86kDiYgQznIYLC97teduE
Message-ID: <CA+55aFwXXsk47WrAqF6yuVXOQHuNpxT7x-=MmLsNBptyzjH1zQ@mail.gmail.com>
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

On Tue, Sep 10, 2013 at 3:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> It's not that bad, actually; I think the variant I've pushed right now
> (vfs.git#for-next, head at f5e1dd34561e0fb06400b378d595198918833021) should
> be doing the right thing.  It ought to cover everything in your branch
> in -next from "fs: bump inode and dentry counters to long" on to the
> end of queue.

>From a quick look, this looks pretty broken:

    if (list_lru_add(&dentry->d_sb->s_dentry_lru, &dentry->d_lru))
        this_cpu_inc(nr_dentry_unused);
    dentry->d_flags |= DCACHE_LRU_LIST;

because if that list_lru_add() can fail, then we shouldn't set the
DCACHE_LRU_LIST bit either.

That said, I don't see how it can fail. We only do this with the
dentry locked, and when it's not already on the LRU list. So I think
the "if()" is just misleading and unnecessary - but the code works.

              Linus
