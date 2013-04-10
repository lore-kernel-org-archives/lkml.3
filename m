Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964830Ab3DJOBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:01:48 -0400
Received: from a9-58.smtp-out.amazonses.com ([54.240.9.58]:36723 "EHLO
	a9-58.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S936739Ab3DJOBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:01:46 -0400
X-Greylist: delayed 411 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2013 10:01:46 EDT
Date: Wed, 10 Apr 2013 13:54:53 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Simon Jeons <simon.jeons@gmail.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan@kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH 2/3] mm, slub: count freed pages via rcu as this task's
 reclaimed_slab
In-Reply-To: <5164DA6A.5060607@gmail.com>
Message-ID: <0000013df43a48e5-6addd57e-952b-4754-848e-6d454b0a906c-000000@email.amazonses.com>
References: <1365470478-645-1-git-send-email-iamjoonsoo.kim@lge.com> <1365470478-645-2-git-send-email-iamjoonsoo.kim@lge.com> <5163E194.3080600@gmail.com> <0000013def363b50-9a16dd09-72ad-494f-9c25-17269fc3aab3-000000@email.amazonses.com>
 <5164DA6A.5060607@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.10-54.240.9.58
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Simon Jeons wrote:

> It seems that you misunderstand my question. I don't doubt slab/slub can use
> high order pages. However, what I focus on is why slab/slub can use compound
> page, PageCompound() just on behalf of hugetlbfs pages or thp pages which
> should used by apps, isn't it?

I am not entirely clear on what you are asking for. The following gives a
couple of answers to what I guess the question was.

THP pages and user pages are on the lru and are managed differently.
The slab allocators cannot work with those pages.

Slab allocators *can* allocate higher order pages therefore they could
allocate a page of the same order as huge pages and manage it that way.

However there is no way that these pages could be handled like THP pages
since they cannot be broken up (unless we add the capability to move slab
objects which I wanted to do for a long time).


You can boot a Linux system that uses huge pages for slab allocation
by specifying the following parameter on the kernel command line.

	slub_min_order=9

The slub allocator will start using huge pages for all its storage
needs. You need a large number of huge pages to do this. Lots of memory
is going to be lost due to fragmentation but its going to be fast since
the slowpaths are rarely used. OOMs due to reclaim failure become much
more likely ;-).


