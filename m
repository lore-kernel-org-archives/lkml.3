Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaCQT4X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 15:56:23 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19883 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaCQT4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 15:56:17 -0400
Message-ID: <53275359.7000802@oracle.com>
Date: Mon, 17 Mar 2014 15:56:09 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>, ngupta@vflare.org
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: zram: sleeping vunmap_pmd_range called from atomic zram_make_request
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest running the latest -next kernel
I've stumbled on the following spew:

[  827.272181] BUG: sleeping function called from invalid context at mm/vmalloc.c:74
[  827.273204] in_atomic(): 1, irqs_disabled(): 0, pid: 4213, name: kswapd14
[  827.274080] 1 lock held by kswapd14/4213:
[  827.274587]  #0:  (&zram->init_lock){++++.-}, at: zram_make_request (drivers/block/zram/zram_drv.c:765)
[  827.275923] Preemption disabled zram_bvec_write (drivers/block/zram/zram_drv.c:500)
[  827.276910]
[  827.277104] CPU: 30 PID: 4213 Comm: kswapd14 Tainted: G        W     3.14.0-rc6-next-20140317-sasha-00012-ge933921-dirty #226
[  827.278467]  ffff880229700000 ffff8802296fd388 ffffffff8449ebb3 0000000000000001
[  827.279610]  0000000000000000 ffff8802296fd3b8 ffffffff81176cec ffff8802296fd3c8
[  827.281258]
[  827.281549]  ffff88032b40a000 ffffc900077fa000 ffffc900077f8000 ffff8802296fd428
[  827.282911] Call Trace:
[  827.283318]  dump_stack (lib/dump_stack.c:52)
[  827.284013]  __might_sleep (kernel/sched/core.c:7016)
[  827.284797]  vunmap_pmd_range (mm/vmalloc.c:74)
[  827.285486]  ? sched_clock_cpu (kernel/sched/clock.c:311)
[  827.286313]  vunmap_page_range (mm/vmalloc.c:97 mm/vmalloc.c:112)
[  827.287177]  unmap_kernel_range (mm/vmalloc.c:1273)
[  827.288055]  zs_unmap_object (mm/zsmalloc.c:1086)
[  827.288863]  zram_bvec_write (drivers/block/zram/zram_drv.c:516)
[  827.289628]  zram_bvec_rw (drivers/block/zram/zram_drv.c:551)
[  827.290844]  __zram_make_request (drivers/block/zram/zram_drv.c:743)
[  827.291629]  zram_make_request (drivers/block/zram/zram_drv.c:774)
[  827.292414]  generic_make_request (block/blk-core.c:1862)
[  827.293283]  submit_bio (block/blk-core.c:1913)
[  827.294134]  ? test_set_page_writeback (include/linux/rcupdate.h:800 include/linux/memcontrol.h:180 mm/page-writeback.c:2408)
[  827.295287]  __swap_writepage (mm/page_io.c:315)
[  827.296287]  ? preempt_count_sub (kernel/sched/core.c:2530)
[  827.297199]  ? _raw_spin_unlock (arch/x86/include/asm/preempt.h:98 include/linux/spinlock_api_smp.h:152 kernel/locking/spinlock.c:183)
[  827.298019]  ? page_swapcount (mm/swapfile.c:898)
[  827.298802]  swap_writepage (mm/page_io.c:249)
[  827.299534]  pageout (mm/vmscan.c:502)
[  827.300721]  shrink_page_list (mm/vmscan.c:1015)
[  827.301475]  shrink_inactive_list (include/linux/spinlock.h:328 mm/vmscan.c:1503)
[  827.302320]  ? shrink_active_list (mm/vmscan.c:1744)
[  827.303170]  shrink_lruvec (mm/vmscan.c:1830 mm/vmscan.c:2054)
[  827.303881]  ? sched_clock (arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:305)
[  827.304518]  shrink_zone (mm/vmscan.c:2235)
[  827.305327]  kswapd_shrink_zone (include/linux/bitmap.h:165 include/linux/nodemask.h:131 mm/vmscan.c:2904)
[  827.306117]  balance_pgdat (mm/vmscan.c:3088)
[  827.306808]  ? finish_wait (kernel/sched/wait.c:254)
[  827.307479]  kswapd (mm/vmscan.c:3296)
[  827.308127]  ? perf_trace_mm_vmscan_wakeup_kswapd (mm/vmscan.c:3213)
[  827.309164]  ? perf_trace_mm_vmscan_wakeup_kswapd (mm/vmscan.c:3213)
[  827.310391]  kthread (kernel/kthread.c:216)
[  827.311092]  ? __tick_nohz_task_switch (arch/x86/include/asm/paravirt.h:809 kernel/time/tick-sched.c:272)
[  827.312070]  ? set_kthreadd_affinity (kernel/kthread.c:185)
[  827.312903]  ret_from_fork (arch/x86/kernel/entry_64.S:555)
[  827.313627]  ? set_kthreadd_affinity (kernel/kthread.c:185)


Thanks,
Sasha
