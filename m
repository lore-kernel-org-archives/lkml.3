Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585AbaDAHi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 03:38:58 -0400
Received: from relay.parallels.com ([195.214.232.42]:56765 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaDAHiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 03:38:51 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <glommer@gmail.com>,
        <gthelen@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <devel@openvz.org>
Subject: [PATCH -mm v2 0/2] cleanup kmemcg charging (was: "kmemcg: get rid of __GFP_KMEMCG")
Date: Tue, 1 Apr 2014 11:38:43 +0400
Message-ID: <cover.1396335798.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.30.16.96]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently we charge kmem to memcg in alloc_pages if __GFP_KMEMCG is
passed. However, since there are only a few places where we actually
want to charge kmem, we could call kmemcg charge function explicitly
instead. That would remove all kmemcg-related stuff from the general
allocation path and make all kmem charges easier to follow.

So let's charge kmem explicitly where we want it to be charged (slab,
threadinfo) and remove __GFP_KMEMCG.

Changes in v2:
 - use static key optimization in memcg_(un)charge_slab to avoid any
   overhead if kmemcg is not used;
 - introduce helper functions, alloc/free_kmem_pages, which charge newly
   allocated pages to kmemcg, to avoid code duplication;
 - do not remove accounting of kmalloc_large allocations (as discussed in the
   comments to v1).

v1 can be found at lkml.org/lkml/2014/3/26/228

Thanks,

Vladimir Davydov (2):
  sl[au]b: charge slabs to kmemcg explicitly
  mm: get rid of __GFP_KMEMCG

 include/linux/gfp.h             |   10 ++++---
 include/linux/memcontrol.h      |   17 ++++--------
 include/linux/slab.h            |   11 --------
 include/linux/thread_info.h     |    2 --
 include/trace/events/gfpflags.h |    1 -
 kernel/fork.c                   |    6 ++---
 mm/memcontrol.c                 |    4 +--
 mm/page_alloc.c                 |   56 ++++++++++++++++++++++++---------------
 mm/slab.c                       |    7 ++++-
 mm/slab.h                       |   29 ++++++++++++++++++++
 mm/slab_common.c                |   18 +++++++++----
 mm/slub.c                       |   30 ++++++++++++++-------
 12 files changed, 119 insertions(+), 72 deletions(-)

-- 
1.7.10.4

