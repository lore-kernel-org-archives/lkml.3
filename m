Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347AbaJNBqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 21:46:15 -0400
Received: from gum.cmpxchg.org ([85.214.110.215]:41793 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbaJNBqO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 21:46:14 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 0/3] mm: memcontrol: lockless page counters v3
Date: Mon, 13 Oct 2014 21:46:00 -0400
Message-Id: <1413251163-8517-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this series replaces the spinlock_irq-protected 64-bit res_counters
with lockless word-sized page counters.  This improves memory cgroup
scalability on the higher end and gets rid of 64-bit math on 32-bit
machines in the core accounting, but also generally simplifies the
counter code and interface.

Version 3 has a few more touch-ups based on reviews from Michal and
Vladimir:

    - documented ordering between limit() and try_charge() [vladimir]
    - removed charge revert during uncharge underflow [michal]
    - reworked limit update code flow [michal]
    - removed rounding-up in limit setting [michal]
    - fixed mem_cgroup_margin() memsw calculation [michal]
    - updated page_counter raciness comments [vladimir]

Version 2:

    cleanups:
    - moved new page_counter API to its own file [vladimir, michal]
    - documented page counter API [vladimir]
    - documented acceptable race conditions [vladimir]
    - split out res_counter removal to reduce patch size [vladimir]
    - split out hugetlb controller conversion to reduce patch size
    - split page_counter_charge and page_counter_try_charge [vladimir]
    - wrapped signed-to-unsigned read in page_counter_read() [vladimir]
    - wrapped watermark reset in page_counter_reset_watermark() [vladimir]
    - reverted counter->limited back to counter->failcnt [vladimir]
    - changed underflow to WARN_ON_ONCE and counter revert [kame, vladimir]

    fixes:
    - fixed kmem's value for unlimited [vladimir]
    - fixed page_counter_cancel() return value [vladimir]
    - based page counter range on atomic_long_t's max [vladimir]
    - fixed tcp memcontrol's usage reporting [vladimir]
    - fixed hugepage limit page alignment [vladimir]
    - fixed page_counter_limit() serialization [vladimir]

    optimizations:
    - converted page_counter_try_charge() from CAS to FAA [vladimir]

 Documentation/cgroups/hugetlb.txt          |   2 +-
 Documentation/cgroups/memory.txt           |   4 +-
 Documentation/cgroups/resource_counter.txt | 197 ---------
 include/linux/hugetlb_cgroup.h             |   1 -
 include/linux/memcontrol.h                 |   5 +-
 include/linux/page_counter.h               |  49 +++
 include/linux/res_counter.h                | 223 ----------
 include/net/sock.h                         |  26 +-
 init/Kconfig                               |  12 +-
 kernel/Makefile                            |   1 -
 kernel/res_counter.c                       | 211 ---------
 mm/Makefile                                |   1 +
 mm/hugetlb_cgroup.c                        | 103 +++--
 mm/memcontrol.c                            | 633 +++++++++++++--------------
 mm/page_counter.c                          | 203 +++++++++
 net/ipv4/tcp_memcontrol.c                  |  87 ++--
 16 files changed, 669 insertions(+), 1089 deletions(-)

