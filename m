Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaAXWD0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 17:03:26 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:52209 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751621AbaAXWDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 17:03:22 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 0/2] mm: reduce reclaim stalls with heavy anon and dirty cache
Date: Fri, 24 Jan 2014 17:03:02 -0500
Message-Id: <1390600984-13925-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun reported stuttering and latency spikes on a system where random
tasks would enter direct reclaim and get stuck on dirty pages.  Around
50% of memory was occupied by tmpfs backed by an SSD, and another disk
(rotating) was reading and writing at max speed to shrink a partition.

Analysis:

When calculating the amount of dirtyable memory, the VM considers all
free memory and all file and anon pages as baseline to which to apply
dirty limits.  This implies that, given memory pressure from dirtied
cache, the VM would actually start swapping to make room.  But alas,
this is not really the case and page reclaim tries very hard not to
swap as long as there is any used-once cache available.  The dirty
limit may have been 10-15% of main memory, but page cache was less
than 50% of that, which means that a third of the pages that the
reclaimers actually looked at were dirty.  Kswapd stopped making
progress, and in turn allocators were forced into direct reclaim only
to get stuck on dirty/writeback congestion.

These two patches fix the dirtyable memory calculation to acknowledge
the fact that the VM does not really replace anon with dirty cache.
As such, anon memory can no longer be considered "dirtyable."

Longer term we probably want to look into reducing some of the bias
towards cache.  The problematic workload in particular was not even
using any of the anon pages, one swap burst could have resolved it.

