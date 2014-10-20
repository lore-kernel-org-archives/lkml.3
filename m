Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586AbaJTLut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 07:50:49 -0400
Received: from mx2.parallels.com ([199.115.105.18]:36903 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155AbaJTLur (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 07:50:47 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Zefan Li <lizefan@huawei.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>
Subject: [PATCH RESEND 0/4] Simplify cpuset API and fix cpuset check in SL[AU]B
Date: Mon, 20 Oct 2014 15:50:28 +0400
Message-ID: <cover.1413804554.git.vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rebased on top of 3.18-rc1 and added acks from Christoph and Zefan]

Hi,

SLAB and SLUB use hardwall cpuset check on fallback alloc, while the
page allocator uses softwall check for all kernel allocations. This may
result in falling into the page allocator even if there are free objects
on other nodes. SLAB algorithm is especially affected: the number of
objects allocated in vain is unlimited, so that they theoretically can
eat up a whole NUMA node. For more details see comments to patches 3, 4.

When I last sent a fix (https://lkml.org/lkml/2014/8/10/100), David
found the whole cpuset API being cumbersome and proposed to simplify it
before getting to fixing its users. So this patch set addresses both
David's complain (patches 1, 2) and the SL[AU]B issues (patches 3, 4).

Reviews are appreciated.

Thanks,

Vladimir Davydov (4):
  cpuset: convert callback_mutex to a spinlock
  cpuset: simplify cpuset_node_allowed API
  slab: fix cpuset check in fallback_alloc
  slub: fix cpuset check in get_any_partial

 include/linux/cpuset.h |   37 +++--------
 kernel/cpuset.c        |  162 +++++++++++++++++-------------------------------
 mm/hugetlb.c           |    2 +-
 mm/oom_kill.c          |    2 +-
 mm/page_alloc.c        |    6 +-
 mm/slab.c              |    2 +-
 mm/slub.c              |    2 +-
 mm/vmscan.c            |    5 +-
 8 files changed, 74 insertions(+), 144 deletions(-)

-- 
1.7.10.4

