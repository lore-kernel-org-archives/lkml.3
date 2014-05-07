Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaEGGHx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 02:07:53 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42200 "EHLO
	lgemrelse7q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbaEGGEk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 02:04:40 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 00/10] clean-up and remove lockdep annotation in SLAB
Date: Wed,  7 May 2014 15:06:10 +0900
Message-Id: <1399442780-28748-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset does some clean-up and tries to remove lockdep annotation.

Patches 1~3 are just for really really minor improvement.
Patches 4~10 are for clean-up and removing lockdep annotation.

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

Many of this series get Ack from Christoph Lameter on previous iteration,
but 1, 2, 9 and 10 need to get Ack. There is no big change from previous
iteration. It is just rebased on current linux-next.

Thanks.

Joonsoo Kim (10):
  slab: add unlikely macro to help compiler
  slab: makes clear_obj_pfmemalloc() just return masked value
  slab: move up code to get kmem_cache_node in free_block()
  slab: defer slab_destroy in free_block()
  slab: factor out initialization of arracy cache
  slab: introduce alien_cache
  slab: use the lock on alien_cache, instead of the lock on array_cache
  slab: destroy a slab without holding any alien cache lock
  slab: remove a useless lockdep annotation
  slab: remove BAD_ALIEN_MAGIC

 mm/slab.c |  391 ++++++++++++++++++++++---------------------------------------
 mm/slab.h |    2 +-
 2 files changed, 140 insertions(+), 253 deletions(-)

-- 
1.7.9.5

