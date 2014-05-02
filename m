Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753085AbaEBUB4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 16:01:56 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:56287 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbaEBUBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 16:01:55 -0400
Date: Fri, 2 May 2014 15:01:52 -0500
From: Seth Jennings <sjennings@variantweb.net>
To: Weijie Yang <weijie.yang.kh@gmail.com>
Cc: Dan Streetman <ddstreet@ieee.org>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] mm: zpool: implement zsmalloc shrinking
Message-ID: <20140502200152.GA18670@cerebellum.variantweb.net>
References: <1397922764-1512-1-git-send-email-ddstreet@ieee.org>
 <1397922764-1512-3-git-send-email-ddstreet@ieee.org>
 <CAL1ERfMPcfyUeACnmZ2QF5WxJUQ2PaKbtRzis8sPbQsjnvf_GQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL1ERfMPcfyUeACnmZ2QF5WxJUQ2PaKbtRzis8sPbQsjnvf_GQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 26, 2014 at 04:37:31PM +0800, Weijie Yang wrote:
> On Sat, Apr 19, 2014 at 11:52 PM, Dan Streetman <ddstreet@ieee.org> wrote:
> > Add zs_shrink() and helper functions to zsmalloc.  Update zsmalloc
> > zs_create_pool() creation function to include ops param that provides
> > an evict() function for use during shrinking.  Update helper function
> > fix_fullness_group() to always reinsert changed zspages even if the
> > fullness group did not change, so they are updated in the fullness
> > group lru.  Also update zram to use the new zsmalloc pool creation
> > function but pass NULL as the ops param, since zram does not use
> > pool shrinking.
> >
> 
> I only review the code without test, however, I think this patch is
> not acceptable.
> 
> The biggest problem is it will call zswap_writeback_entry() under lock,
> zswap_writeback_entry() may sleep, so it is a bug. see below
> 
> The 3/4 patch has a lot of #ifdef, I don't think it's a good kind of
> abstract way.
> 
> What about just disable zswap reclaim when using zsmalloc?

I agree here.  Making a generic allocator layer and zsmalloc reclaim
support should be two different efforts, since zsmalloc reclaim is
fraught with peril.

The generic layer can be done though, as long as you provide a way for
the backend to indicate that it doesn't support reclaim, which just
results in lru-inverse overflow to the swap device at the zswap layer.
Hopefully, if the user overrides the default to use zsmalloc, they
understand the implications and have sized their workload properly.

Also, the fallback logic shouldn't be in this generic layer.  It should
not be transparent to the user.  The user (in this case zswap) should
implement the fallback if they care to have it.  The generic allocator
layer makes it trivial for the user to implement.

Thanks,
Seth
