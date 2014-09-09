Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900AbaIISXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 14:23:20 -0400
Received: from www.sr71.net ([198.145.64.142]:37438 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751774AbaIISXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 14:23:17 -0400
Message-ID: <540F4592.9030408@sr71.net>
Date: Tue, 09 Sep 2014 11:23:14 -0700
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>, Dave Hansen <dave.hansen@intel.com>
CC: Michal Hocko <mhocko@suse.cz>, Hugh Dickins <hughd@google.com>,
        Tejun Heo <tj@kernel.org>, Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Vladimir Davydov <vdavydov@parallels.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: regression caused by cgroups optimization in 3.17-rc2
References: <54061505.8020500@sr71.net> <5406262F.4050705@intel.com> <54062F32.5070504@sr71.net> <20140904142721.GB14548@dhcp22.suse.cz> <5408CB2E.3080101@sr71.net> <20140905123517.GA21208@cmpxchg.org> <540DCF99.2070900@intel.com> <20140909145044.GA16027@cmpxchg.org>
In-Reply-To: <20140909145044.GA16027@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 07:50 AM, Johannes Weiner wrote:
> The mctz->lock is only taken when there is, or has been, soft limit
> excess.  However, the soft limit defaults to infinity, so unless you
> set it explicitly on the root level, I can't see how this could be
> mctz->lock contention.
> 
> It's more plausible that this is the res_counter lock for testing soft
> limit excess - for me, both these locks get inlined into check_events,
> could you please double check you got the right lock?

I got the wrong lock.  Here's how it looks after mainline, plus your free_pages_and_swap_cache() patch:

Samples: 2M of event 'cycles', Event count (approx.): 51647128377                            
+   60.60%     1.33%  page_fault2_processes              [.] testcase                       ▒
+   59.14%     0.41%  [kernel]                           [k] page_fault                     ◆
+   58.72%     0.01%  [kernel]                           [k] do_page_fault                  ▒
+   58.70%     0.08%  [kernel]                           [k] __do_page_fault                ▒
+   58.50%     0.29%  [kernel]                           [k] handle_mm_fault                ▒
+   40.14%     0.28%  [kernel]                           [k] do_cow_fault                   ▒
-   34.56%    34.56%  [kernel]                           [k] _raw_spin_lock                 ▒
   - _raw_spin_lock                                                                         ▒
      - 78.11% __res_counter_charge                                                         ▒
           res_counter_charge                                                               ▒
           try_charge                                                                       ▒
         - mem_cgroup_try_charge                                                            ▒
            + 99.99% do_cow_fault                                                           ▒
      - 10.30% res_counter_uncharge_until                                                   ▒
           res_counter_uncharge                                                             ▒
           uncharge_batch                                                                   ▒
           uncharge_list                                                                    ▒
           mem_cgroup_uncharge_list                                                         ▒
           release_pages                                                                    ▒
      + 4.75% free_pcppages_bulk                                                            ▒
      + 3.65% do_cow_fault                                                                  ▒
      + 2.24% get_page_from_freelist                                                        ▒

> You also said that this cost hasn't been there before, but I do see
> that trace in both v3.16 and v3.17-rc3 with roughly the same impact
> (although my machines show less contention than yours).  Could you
> please double check that this is in fact a regression independent of
> 05b843012335 ("mm: memcontrol: use root_mem_cgroup res_counter")?

Here's the same workload on the same machine with only Johannes' revert applied:

-   35.92%    35.92%  [kernel]                           [k] _raw_spin_lock                 ▒
   - _raw_spin_lock                                                                         ▒
      - 49.09% get_page_from_freelist                                                       ▒
         - __alloc_pages_nodemask                                                           ▒
            + 99.90% alloc_pages_vma                                                        ▒
      - 43.67% free_pcppages_bulk                                                           ▒
         - 100.00% free_hot_cold_page                                                       ▒
            + 99.93% free_hot_cold_page_list                                                ▒
      - 7.08% do_cow_fault                                                                  ▒
           handle_mm_fault                                                                  ▒
           __do_page_fault                                                                  ▒
           do_page_fault                                                                    ▒
           page_fault                                                                       ▒
           testcase                                                                         ▒

So I think it's probably part of the same regression.
