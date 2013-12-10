Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808Ab3LJHvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 02:51:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55978 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726Ab3LJHvE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 02:51:04 -0500
Date: Tue, 10 Dec 2013 07:50:59 +0000
From: Mel Gorman <mgorman@suse.de>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] mm, page_alloc: allow __GFP_NOFAIL to allocate below
 watermarks after reclaim
Message-ID: <20131210075059.GA11295@suse.de>
References: <alpine.DEB.2.02.1312091402580.11026@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312091402580.11026@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 02:03:45PM -0800, David Rientjes wrote:
> If direct reclaim has failed to free memory, __GFP_NOFAIL allocations
> can potentially loop forever in the page allocator.  In this case, it's
> better to give them the ability to access below watermarks so that they
> may allocate similar to the same privilege given to GFP_ATOMIC
> allocations.
> 
> We're careful to ensure this is only done after direct reclaim has had
> the chance to free memory, however.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

The main problem with doing something like this is that it just smacks
into the adjusted watermark if there are a number of __GFP_NOFAIL. Who
was the user of __GFP_NOFAIL that was fixed by this patch?

It appears there are more __GFP_NOFAIL users than I expected and some of
them are silly. md uses it after mempool_alloc fails GFP_ATOMIC and then
immediately calls with __GFP_NOFAIL in a context that can sleep. It could
just have used GFP_NOIO for the mempool alloc which would "never" fail.

btrfs is using __GFP_NOFAIL to call the slab allocator for the extent
cache but also a kmalloc cache which is just dangerous. After this
patch, that thing can push the system below watermarks and then
effectively "leak" them to other !__GFP_NOFAIL users.

Buffer cache uses __GFP_NOFAIL to grow buffers where it expects the page
allocator can loop endlessly but again, allowing it to go below reserves
is just going to hit the same wall a short time later

gfs is using the flag with kmalloc slabs, same as btrfs this can "leak"
the reserves. jbd is the same although jbd2 avoids using the flag in a
manner of speaking.

There are enough bad users of __GFP_NOFAIL that I really question how
good an idea it is to allow emergency reserves to be used when they are
potentially leaked to other !__GFP_NOFAIL users via the slab allocator
shortly afterwards.

-- 
Mel Gorman
SUSE Labs
