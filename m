Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248AbaIBU5Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:57:25 -0400
Received: from www.sr71.net ([198.145.64.142]:53384 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169AbaIBU5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:57:24 -0400
Message-ID: <54062F32.5070504@sr71.net>
Date: Tue, 02 Sep 2014 13:57:22 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Dave Hansen <dave.hansen@intel.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
References: <54061505.8020500@sr71.net> <5406262F.4050705@intel.com>
In-Reply-To: <5406262F.4050705@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I, of course, forgot to include the most important detail.  This appears
to be pretty run-of-the-mill spinlock contention in the resource counter
code.  Nearly 80% of the CPU is spent spinning in the charge or uncharge
paths in the kernel.  It is apparently spinning on res_counter->lock in
both the charge and uncharge paths.

It already does _some_ batching here on the free side, but that
apparently breaks down after ~40 threads.

It's a no-brainer since the patch in question removed an optimization
skipping the charging, and now we're seeing overhead from the charging.

Here's the first entry from perf top:

    80.18%    80.18%  [kernel]               [k] _raw_spin_lock
                  |
                  --- _raw_spin_lock
                     |
                     |--66.59%-- res_counter_uncharge_until
                     |          res_counter_uncharge
                     |          uncharge_batch
                     |          uncharge_list
                     |          mem_cgroup_uncharge_list
                     |          release_pages
                     |          free_pages_and_swap_cache
                     |          tlb_flush_mmu_free
                     |          |
                     |          |--90.12%-- unmap_single_vma
                     |          |          unmap_vmas
                     |          |          unmap_region
                     |          |          do_munmap
                     |          |          vm_munmap
                     |          |          sys_munmap
                     |          |          system_call_fastpath
                     |          |          __GI___munmap
                     |          |
                     |           --9.88%-- tlb_flush_mmu
                     |                     tlb_finish_mmu
                     |                     unmap_region
                     |                     do_munmap
                     |                     vm_munmap
                     |                     sys_munmap
                     |                     system_call_fastpath
                     |                     __GI___munmap
                     |
                     |--46.13%-- __res_counter_charge
                     |          res_counter_charge
                     |          try_charge
                     |          mem_cgroup_try_charge
                     |          |
                     |          |--99.89%-- do_cow_fault
                     |          |          handle_mm_fault
                     |          |          __do_page_fault
                     |          |          do_page_fault
                     |          |          page_fault
                     |          |          testcase
                     |           --0.11%-- [...]
                     |
                     |--1.14%-- do_cow_fault
                     |          handle_mm_fault
                     |          __do_page_fault
                     |          do_page_fault
                     |          page_fault
                     |          testcase
                      --8217937613.29%-- [...]

