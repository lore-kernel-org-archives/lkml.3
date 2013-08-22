Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab3HVIod (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 04:44:33 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:57101 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3HVIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 04:44:19 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-4b-5215cf62773b
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <js1304@gmail.com>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 00/16] slab: overload struct slab over struct page to reduce memory usage
Date: Thu, 22 Aug 2013 17:44:09 +0900
Message-Id: <1377161065-30552-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is two main topics in this patchset. One is to reduce memory usage
and the other is to change a management method of free objects of a slab.

The SLAB allocate a struct slab for each slab. The size of this structure
except bufctl array is 40 bytes on 64 bits machine. We can reduce memory
waste and cache footprint if we overload struct slab over struct page.

And this patchset change a management method of free objects of a slab.
Current free objects management method of the slab is weird, because
it touch random position of the array of kmem_bufctl_t when we try to
get free object. See following example.
    
struct slab's free = 6
kmem_bufctl_t array: 1 END 5 7 0 4 3 2
    
To get free objects, we access this array with following pattern.
6 -> 3 -> 7 -> 2 -> 5 -> 4 -> 0 -> 1 -> END
    
If we have many objects, this array would be larger and be not in the same
cache line. It is not good for performance.
    
We can do same thing through more easy way, like as the stack.
This patchset implement it and remove complex code for above algorithm.
This makes slab code much cleaner.

This patchset is based on v3.11-rc6, but tested on v3.10.

Thanks.

Joonsoo Kim (16):
  slab: correct pfmemalloc check
  slab: change return type of kmem_getpages() to struct page
  slab: remove colouroff in struct slab
  slab: remove nodeid in struct slab
  slab: remove cachep in struct slab_rcu
  slab: put forward freeing slab management object
  slab: overloading the RCU head over the LRU for RCU free
  slab: use well-defined macro, virt_to_slab()
  slab: use __GFP_COMP flag for allocating slab pages
  slab: change the management method of free objects of the slab
  slab: remove kmem_bufctl_t
  slab: remove SLAB_LIMIT
  slab: replace free and inuse in struct slab with newly introduced
    active
  slab: use struct page for slab management
  slab: remove useless statement for checking pfmemalloc
  slab: rename slab_bufctl to slab_freelist

 include/linux/mm_types.h |   21 +-
 include/linux/slab.h     |    9 +-
 include/linux/slab_def.h |    4 +-
 mm/slab.c                |  563 ++++++++++++++++++----------------------------
 4 files changed, 237 insertions(+), 360 deletions(-)

-- 
1.7.9.5

