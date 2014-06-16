Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916AbaFPTzE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 15:55:04 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:36685 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbaFPTzA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 15:55:00 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [patch 00/12] mm: memcontrol: naturalize charge lifetime v3
Date: Mon, 16 Jun 2014 15:54:20 -0400
Message-Id: <1402948472-8175-1-git-send-email-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is v3 of the memcg charge naturalization series.  Changes since
v2 include:

o make THP charges use __GFP_NORETRY to prevent excessive reclaim (Michal)
o simplify move precharging while in the area
o add acks & rebase to v3.16-rc1

These patches rework memcg charge lifetime to integrate more naturally
with the lifetime of user pages.  This drastically simplifies the code
and reduces charging and uncharging overhead.  The most expensive part
of charging and uncharging is the page_cgroup bit spinlock, which is
removed entirely after this series.

Here are the top-10 profile entries of a stress test that reads a 128G
sparse file on a freshly booted box, without even a dedicated cgroup
(i.e. executing in the root memcg).  Before:

    15.36%              cat  [kernel.kallsyms]   [k] copy_user_generic_string                  
    13.31%              cat  [kernel.kallsyms]   [k] memset                                    
    11.48%              cat  [kernel.kallsyms]   [k] do_mpage_readpage                         
     4.23%              cat  [kernel.kallsyms]   [k] get_page_from_freelist                    
     2.38%              cat  [kernel.kallsyms]   [k] put_page                                  
     2.32%              cat  [kernel.kallsyms]   [k] __mem_cgroup_commit_charge                
     2.18%          kswapd0  [kernel.kallsyms]   [k] __mem_cgroup_uncharge_common              
     1.92%          kswapd0  [kernel.kallsyms]   [k] shrink_page_list                          
     1.86%              cat  [kernel.kallsyms]   [k] __radix_tree_lookup                       
     1.62%              cat  [kernel.kallsyms]   [k] __pagevec_lru_add_fn                      

After:

    15.67%           cat  [kernel.kallsyms]   [k] copy_user_generic_string                  
    13.48%           cat  [kernel.kallsyms]   [k] memset                                    
    11.42%           cat  [kernel.kallsyms]   [k] do_mpage_readpage                         
     3.98%           cat  [kernel.kallsyms]   [k] get_page_from_freelist                    
     2.46%           cat  [kernel.kallsyms]   [k] put_page                                  
     2.13%       kswapd0  [kernel.kallsyms]   [k] shrink_page_list                          
     1.88%           cat  [kernel.kallsyms]   [k] __radix_tree_lookup                       
     1.67%           cat  [kernel.kallsyms]   [k] __pagevec_lru_add_fn                      
     1.39%       kswapd0  [kernel.kallsyms]   [k] free_pcppages_bulk                        
     1.30%           cat  [kernel.kallsyms]   [k] kfree                                     

As you can see, the memcg footprint has shrunk quite a bit.

   text    data     bss     dec     hex filename
  37970    9892     400   48262    bc86 mm/memcontrol.o.old
  35303    9892     400   45595    b21b mm/memcontrol.o

 Documentation/cgroups/memcg_test.txt |  160 +---
 include/linux/memcontrol.h           |   94 +--
 include/linux/page_cgroup.h          |   43 +-
 include/linux/swap.h                 |   15 +-
 kernel/events/uprobes.c              |    1 +
 mm/filemap.c                         |   13 +-
 mm/huge_memory.c                     |   57 +-
 mm/memcontrol.c                      | 1516 ++++++++++++----------------------
 mm/memory.c                          |   43 +-
 mm/migrate.c                         |   44 +-
 mm/rmap.c                            |   20 -
 mm/shmem.c                           |   32 +-
 mm/swap.c                            |   40 +
 mm/swap_state.c                      |    8 +-
 mm/swapfile.c                        |   21 +-
 mm/truncate.c                        |    9 -
 mm/vmscan.c                          |   12 +-
 mm/zswap.c                           |    2 +-
 18 files changed, 754 insertions(+), 1376 deletions(-)

