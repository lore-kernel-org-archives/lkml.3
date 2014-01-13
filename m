Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaAMXFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:05:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53277 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaAMXFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:05:04 -0500
Date: Mon, 13 Jan 2014 15:05:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>,
        Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        Dave Chinner <dchinner@redhat.com>, Glauber Costa <glommer@gmail.com>
Subject: Re: [PATCH 1/5] mm: vmscan: shrink all slab objects if tight on
 memory
Message-Id: <20140113150502.4505f661589a4a2d30e6f11d@linux-foundation.org>
In-Reply-To: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com>
References: <7d37542211678a637dc6b4d995fd6f1e89100538.1389443272.git.vdavydov@parallels.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 16:36:31 +0400 Vladimir Davydov <vdavydov@parallels.com> wrote:

> When reclaiming kmem, we currently don't scan slabs that have less than
> batch_size objects (see shrink_slab_node()):
> 
>         while (total_scan >= batch_size) {
>                 shrinkctl->nr_to_scan = batch_size;
>                 shrinker->scan_objects(shrinker, shrinkctl);
>                 total_scan -= batch_size;
>         }
> 
> If there are only a few shrinkers available, such a behavior won't cause
> any problems, because the batch_size is usually small, but if we have a
> lot of slab shrinkers, which is perfectly possible since FS shrinkers
> are now per-superblock, we can end up with hundreds of megabytes of
> practically unreclaimable kmem objects. For instance, mounting a
> thousand of ext2 FS images with a hundred of files in each and iterating
> over all the files using du(1) will result in about 200 Mb of FS caches
> that cannot be dropped even with the aid of the vm.drop_caches sysctl!

True.  I suspect this was an accidental consequence of the chosen
implementation.  As you mentioned, I was thinking that the caches would
all be large, and the remaining 1 ..  SHRINK_BATCH-1 objects just
didn't matter.

> This problem was initially pointed out by Glauber Costa [*]. Glauber
> proposed to fix it by making the shrink_slab() always take at least one
> pass, to put it simply, turning the scan loop above to a do{}while()
> loop. However, this proposal was rejected, because it could result in
> more aggressive and frequent slab shrinking even under low memory
> pressure when total_scan is naturally very small.

Well, it wasn't "rejected" - Mel pointed out that Glauber's change
could potentially trigger problems which already exist in shrinkers.

The potential issues seem pretty unlikely to me, and they're things we
can fix up if they eventuate.

So I'm thinking we should at least try Glauber's approach - it's a bit
weird that we should treat the final 0 ..  batch_size-1 objects in a
different manner from all the others.


That being said, I think I'll schedule this patch as-is for 3.14.  Can
you please take a look at implementing the simpler approach, send me
something for 3.15-rc1?

