Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3KHIRZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 03:17:25 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:48028 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab3KHIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 03:17:23 -0500
Date: Fri, 8 Nov 2013 00:17:37 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: manual merge of the block tree with the  tree
Message-ID: <20131108081737.GA27885@kmo-pixel>
References: <20131107192545.GA20624@moria.home.lan>
 <527C2AA9.9040608@oracle.com>
 <20131108125307.613427c04a7527c4359e6443@canb.auug.org.au>
 <20131108020805.GI3842@kmo>
 <527C4D35.8000907@oracle.com>
 <20131108073324.GA31662@infradead.org>
 <20131108073959.GA17807@kmo-pixel>
 <20131108074445.GA11595@infradead.org>
 <20131108075617.GB17807@kmo-pixel>
 <20131108080221.GA31866@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131108080221.GA31866@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 08, 2013 at 12:02:21AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 07, 2013 at 11:56:17PM -0800, Kent Overstreet wrote:
> > So, I don't think the iov_iter stuff is the right approach for solving
> > the loop issue; it's an ugly hack and after immutable biovecs we're
> > pretty close to a better solution and some major cleanups too.
> 
> All the consumers aren't limited to a block-based filesystem backing,
> including loop.  So we need a file-ops based approach for in-kernel
> dio/aio.  If you have a counter proposal please at least describe it.

The core issue isn't whether the IO is going to a block based filesystem
(but thanks for pointing out that that's not necessarily true!) but
whether we want to work with pinned pages or not. If pinned pages are ok
for everything, then bios as a common interface work - likely evolving
them a bit to be more general (it's just bi_bdev and bi_sector that's
actually block specific) - and IMO that would be far preferable to this
abstraction layer.

If OTOH we need a common interface that's also for places where we can't
afford the overhead of pinning user pages - that's a different story,
and maybe we do need all this infrastructure then. That's why I'm asking
about the stuff you meantioned, I'm honestly not sure.

What I'm working towards though is a clean separation between buffered
and direct code paths, so that buffered IO can continue work with iovs
and for O_DIRECT the first thing you do is fill out a bio with pinned
pages and send it down to filesystem code or wherever it's going to go.

That make sense? I can show you more concretely what I'm working on if
you want. Or if I'm full of crap and this is useless for what you guys
want I'm sure you'll let me know :)
