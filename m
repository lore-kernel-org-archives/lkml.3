Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488AbaDFPeC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:34:02 -0400
Received: from relay.parallels.com ([195.214.232.42]:33500 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603AbaDFPd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:33:57 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: <akpm@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <devel@openvz.org>
Subject: [PATCH -mm 0/3] slab: cleanup mem hotplug synchronization
Date: Sun, 6 Apr 2014 19:33:49 +0400
Message-ID: <cover.1396779337.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.24.24.157]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

kmem_cache_{create,destroy,shrink} need to get a stable value of
cpu/node online mask, because they init/destroy/access per-cpu/node
kmem_cache parts, which can be allocated or destroyed on cpu/mem
hotplug. To protect against cpu hotplug, these functions use
{get,put}_online_cpus. However, they do nothing to synchronize with
memory hotplug - taking the slab_mutex does not eliminate the
possibility of race as described in patch 3.

What we need there is something like get_online_cpus, but for memory. We
already have lock_memory_hotplug, which serves for the purpose, but it's
a bit of a hammer right now, because it's backed by a mutex. As a
result, it imposes some limitations to locking order, which are not
desirable, and can't be used just like get_online_cpus. I propose to
turn this mutex into an rw semaphore, which will be taken for reading in
lock_memory_hotplug and for writing in memory hotplug code (that's what
patch 1 does).

When I tried to use this rw semaphore in the slab implementation, I came
across a problem with lockdep: rw_semaphore is not marked as read
recursive although it is (at least, it looks so to me), so lockdep
complains about wrong ordering with a sysfs internal mutex in case of
slub, because in contrast to recursive read lock, non-recursive one
should always be taken in the same order with a mutex. That's why in
patch 2 I mark rw semaphore as read-recursive, just like rw spin lock.

Thanks,

Vladimir Davydov (3):
  mem-hotplug: turn mem_hotplug_mutex to rwsem
  lockdep: mark rwsem_acquire_read as recursive
  slab: lock_memory_hotplug for kmem_cache_{create,destroy,shrink}

 include/linux/lockdep.h |    2 +-
 include/linux/mmzone.h  |    7 ++---
 mm/memory_hotplug.c     |   70 +++++++++++++++++++++--------------------------
 mm/slab.c               |   26 ++----------------
 mm/slab.h               |    1 +
 mm/slab_common.c        |   35 ++++++++++++++++++++++--
 mm/slob.c               |    3 +-
 mm/slub.c               |    5 ++--
 mm/vmscan.c             |    2 +-
 9 files changed, 75 insertions(+), 76 deletions(-)

-- 
1.7.10.4

