Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab3H3QVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 12:21:39 -0400
Received: from mga02.intel.com ([134.134.136.20]:11847 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752866Ab3H3QVh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 12:21:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,992,1367996400"; 
   d="scan'208";a="371131590"
Subject: Re: [PATCH] Avoid useless inodes and dentries reclamation
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Dave Chinner <dchinner@redhat.com>,
        Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20130830014005.GT12779@dastard>
References: <1377726732.3625.31.camel@schen9-DESK>
	 <20130829110741.GA23571@dastard> <1377799676.3625.69.camel@schen9-DESK>
	 <20130830014005.GT12779@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Aug 2013 09:21:34 -0700
Message-ID: <1377879694.3625.77.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 11:40 +1000, Dave Chinner wrote:

> 
> The new shrinker infrastructure has a ->count_objects() callout to
> specifically return the number of objects in the cache.
> shrink_slab_node() can check that return value against the "minimum
> call count" and determine whether it needs to call ->scan_objects()
> at all.
> 
> Actually, the shrinker already behaves like this with the batch_size
> variable - the shrinker has to be asking for more items to be
> scanned than the batch size. That means the problem is that counting
> callouts are causing the problem, not the scanning callouts.
> 
> With the new code in the mmotm tree, for counting purposes we
> probably don't need to grab a passive superblock reference at all -
> the superblock and LRUs are guaranteed to be valid if the shrinker
> is currently running, but we don't really care if the superblock is
> being shutdown and the values that come back are invalid because the
> ->scan_objects() callout will fail to grab the superblock to do
> anything with the calculated values.

If that's the case, then we should remove grab_super_passive
from the super_cache_count code.  That should remove the bottleneck
in reclamation.

Thanks for your detailed explanation.

Tim

Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
diff --git a/fs/super.c b/fs/super.c
index 73d0952..4df1fab 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -112,9 +112,6 @@ static unsigned long super_cache_count(struct shrinker *shrink,
 
 	sb = container_of(shrink, struct super_block, s_shrink);
 
-	if (!grab_super_passive(sb))
-		return 0;
-
 	if (sb->s_op && sb->s_op->nr_cached_objects)
 		total_objects = sb->s_op->nr_cached_objects(sb,
 						 sc->nid);




