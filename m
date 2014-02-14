Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaBNG51 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 01:57:27 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:46386 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbaBNG50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 01:57:26 -0500
X-AuditID: 9c93017d-b7c89ae000006ae1-d3-52fdbe5448df
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 0/9] clean-up and remove lockdep annotation in SLAB
Date: Fri, 14 Feb 2014 15:57:14 +0900
Message-Id: <1392361043-22420-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does some clean-up and tries to remove lockdep annotation.

Patches 1~3 are just for really really minor improvement.
Patches 4~9 are for clean-up and removing lockdep annotation.

There are two cases that lockdep annotation is needed in SLAB.
1) holding two node locks
2) holding two array cache(alien cache) locks

I looked at the code and found that we can avoid these cases without
any negative effect.

1) occurs if freeing object makes new free slab and we decide to
destroy it. Although we don't need to hold the lock during destroying
a slab, current code do that. Destroying a slab without holding the lock
would help the reduction of the lock contention. To do it, I change the
implementation that new free slab is destroyed after releasing the lock.

2) occurs on similar situation. When we free object from non-local node,
we put this object to alien cache with holding the alien cache lock.
If alien cache is full, we try to flush alien cache to proper node cache,
and, in this time, new free slab could be made. Destroying it would be
started and we will free metadata object which comes from another node.
In this case, we need another node's alien cache lock to free object.
This forces us to hold two array cache locks and then we need lockdep
annotation although they are always different locks and deadlock cannot
be possible. To prevent this situation, I use same way as 1).

In this way, we can avoid 1) and 2) cases, and then, can remove lockdep
annotation. As short stat noted, this makes SLAB code much simpler.

This patchset is based on slab/next branch on Pekka's git tree.
git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git

Thanks.

Joonsoo Kim (9):
  slab: add unlikely macro to help compiler
  slab: makes clear_obj_pfmemalloc() just return store masked value
  slab: move up code to get kmem_cache_node in free_block()
  slab: defer slab_destroy in free_block()
  slab: factor out initialization of arracy cache
  slab: introduce alien_cache
  slab: use the lock on alien_cache, instead of the lock on array_cache
  slab: destroy a slab without holding any alien cache lock
  slab: remove a useless lockdep annotation

 mm/slab.c |  384 ++++++++++++++++++++++---------------------------------------
 mm/slab.h |    2 +-
 2 files changed, 138 insertions(+), 248 deletions(-)

-- 
1.7.9.5

