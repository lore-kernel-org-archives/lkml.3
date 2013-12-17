Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab3LQQs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:48:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60486 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab3LQQs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:48:26 -0500
From: Mel Gorman <mgorman@suse.de>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>, Rik van Riel <riel@redhat.com>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mgorman@suse.de>
Subject: [RFC PATCH 0/6] Configurable fair allocation zone policy v3
Date: Tue, 17 Dec 2013 16:48:18 +0000
Message-Id: <1387298904-8824-1-git-send-email-mgorman@suse.de>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is currently untested and is being posted to sync up discussions
on the treatment of page cache pages, particularly the sysv part. I have
not thought it through in detail but postings patches is the easiest way
to highlight where I think a problem might be.

Changelog since v2
o Drop an accounting patch, behaviour is deliberate
o Special case tmpfs and shmem pages for discussion

Changelog since v1
o Fix lot of brain damage in the configurable policy patch
o Yoink a page cache annotation patch
o Only account batch pages against allocations eligible for the fair policy
o Add patch that default distributes file pages on remote nodes

Commit 81c0a2bb ("mm: page_alloc: fair zone allocator policy") solved a
bug whereby new pages could be reclaimed before old pages because of how
the page allocator and kswapd interacted on the per-zone LRU lists.

Unfortunately a side-effect missed during review was that it's now very
easy to allocate remote memory on NUMA machines. The problem is that
it is not a simple case of just restoring local allocation policies as
there are genuine reasons why global page aging may be prefereable. It's
still a major change to default behaviour so this patch makes the policy
configurable and sets what I think is a sensible default.

The patches are on top of some NUMA balancing patches currently in -mm.
It's untested and posted to discuss patches 4 and 6.

 Documentation/sysctl/vm.txt |  29 ++++++++++
 include/linux/gfp.h         |   4 +-
 include/linux/mmzone.h      |   2 +
 include/linux/pagemap.h     |   2 +-
 include/linux/swap.h        |   2 +
 kernel/sysctl.c             |   8 +++
 mm/filemap.c                |   2 +
 mm/page_alloc.c             | 136 +++++++++++++++++++++++++++++++++++++-------
 mm/shmem.c                  |  14 +++++
 9 files changed, 176 insertions(+), 23 deletions(-)

-- 
1.8.4

