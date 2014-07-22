Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826AbaGVMK1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:10:27 -0400
Received: from 8bytes.org ([81.169.241.247]:53018 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754139AbaGVMKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:10:24 -0400
Date: Tue, 22 Jul 2014 14:10:22 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140722121022.GA31450@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721160346.GP30979@8bytes.org>
 <20140721230500.GA7019@amd.pavel.ucw.cz>
 <6793803.1FXN0a3O0V@vostro.rjw.lan>
 <20140722103443.GV30979@8bytes.org>
 <20140722105812.GB9814@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722105812.GB9814@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 12:58:12PM +0200, Pavel Machek wrote:
> On Tue 2014-07-22 12:34:44, Joerg Roedel wrote:
> > On Tue, Jul 22, 2014 at 02:41:29AM +0200, Rafael J. Wysocki wrote:
> > > It looks like some specific need motivated the Joerg's work, however,
> > > so let's just not dismiss the use case lightly without knowing it.
> > 
> > The motivation was to optimize the data structures for machines with
> > large amounts of RAM without penalizing average machines. On a 12TB
> > machine you are close to 100000 pages just for one bitmap. Scanning
> > through that linearly to find a given bit just doesnt scale anymore in
> > this case.
> 
> Can you produce backtrace where 12TB machine spends time during boot
> with resume= parameter but no suspend image?
> 
> AFAICT swsusp_check() does not play with bitmaps.

I can ask for a backtrace, I currently don't have one. But I have
perf-data for this case. It also shows that it spends most of its time
with bitmap operations:

~# time perf record /usr/sbin/resume $sdev
resume: libgcrypt version: 1.5.0
[ perf record: Woken up 12 times to write data ]
[ perf record: Captured and wrote 2.882 MB perf.data (~125898 samples) ]

real    1m16.043s
user    0m0.016s
sys     0m0.312s
~# perf report --stdio |head -50
# Events: 75K cycles
#
# Overhead  Command         Shared Object                                   
Symbol
# ........  .......  .................... 
........................................
#
    56.16%   resume  [kernel.kallsyms]     [k] memory_bm_test_bit
    19.35%   resume  [kernel.kallsyms]     [k] swsusp_free
    14.90%   resume  [kernel.kallsyms]     [k] memory_bm_find_bit
     7.28%   resume  [kernel.kallsyms]     [k] swsusp_page_is_forbidden
     0.40%   resume  [kernel.kallsyms]     [k] clear_page_c_e
     0.34%   resume  [kernel.kallsyms]     [k] native_read_tsc
     0.22%   resume  [kernel.kallsyms]     [k] delay_tsc
     0.19%   resume  [kernel.kallsyms]     [k] pfn_valid
     0.11%   resume  [kernel.kallsyms]     [k] create_basic_memory_bitmaps
     0.09%   resume  [kernel.kallsyms]     [k] _raw_spin_lock
     0.09%   resume  [kernel.kallsyms]     [k] __alloc_pages_nodemask
     0.07%   resume  [kernel.kallsyms]     [k] scheduler_tick
     0.06%   resume  [kernel.kallsyms]     [k] io_serial_in
     0.05%   resume  [kernel.kallsyms]     [k] update_curr
     0.05%   resume  [kernel.kallsyms]     [k] idle_cpu
     0.05%   resume  [kernel.kallsyms]     [k] perf_adjust_freq_unthr_context
     0.04%   resume  [kernel.kallsyms]     [k] find_get_page
     0.04%   resume  [kernel.kallsyms]     [k] __memset
     0.04%   resume  [kernel.kallsyms]     [k] ktime_get_update_offsets
     0.03%   resume  [kernel.kallsyms]     [k] get_page_from_freelist
     0.03%   resume  [kernel.kallsyms]     [k] __bitmap_empty
     0.02%   resume  [kernel.kallsyms]     [k] update_cpu_load
     0.02%   resume  [kernel.kallsyms]     [k] update_rq_clock
     0.02%   resume  [kernel.kallsyms]     [k] native_write_msr_safe
     0.02%   resume  [kernel.kallsyms]     [k] mem_cgroup_del_lru_list
     0.02%   resume  [kernel.kallsyms]     [k] free_pcppages_bulk
     0.02%   resume  [kernel.kallsyms]     [k] __rcu_pending
     0.02%   resume  [kernel.kallsyms]     [k] rcu_exit_nohz
     0.01%   resume  [kernel.kallsyms]     [k] __rmqueue
     0.01%   resume  [kernel.kallsyms]     [k] x86_pmu_disable
     0.01%   resume  [kernel.kallsyms]     [k] touch_nmi_watchdog
     0.01%   resume  [kernel.kallsyms]     [k] __do_softirq
     0.01%   resume  [kernel.kallsyms]     [k] alloc_pages_current
     0.01%   resume  [kernel.kallsyms]     [k] memory_bm_create
     0.01%   resume  [kernel.kallsyms]     [k] check_cpu_stall
     0.01%   resume  [kernel.kallsyms]     [k] account_system_time
     0.01%   resume  [kernel.kallsyms]     [k] vma_prio_tree_next
     0.01%   resume  [kernel.kallsyms]     [k] free_hot_cold_page
     0.01%   resume  [kernel.kallsyms]     [k] find_vma
     0.01%   resume  [kernel.kallsyms]     [k] entity_tick
     0.01%   resume  [kernel.kallsyms]     [k] apic_timer_interrupt
     0.01%   resume  [kernel.kallsyms]     [k] read_tsc
