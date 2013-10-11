Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3JKEgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 00:36:00 -0400
Received: from mga02.intel.com ([134.134.136.20]:44433 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751040Ab3JKEf7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 00:35:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1077,1371106800"; 
   d="scan'208";a="409224292"
Date: Fri, 11 Oct 2013 12:35:53 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jakub Jelinek <jakub@redhat.com>, Richard Henderson <rth@twiddle.net>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, -v3] compiler/gcc4: Add quirk for 'asm goto'
 miscompilation bug
Message-ID: <20131011043553.GA9015@localhost>
References: <20131009190231.GI13848@laptop.programming.kicks-ass.net>
 <20131009190851.GX30970@tucnak.zalov.cz>
 <20131010062238.GB9853@gmail.com>
 <20131010065104.GY30970@tucnak.zalov.cz>
 <20131010080457.GC21875@tucnak.zalov.cz>
 <20131010082430.GA20577@gmail.com>
 <20131010083107.GZ30970@tucnak.zalov.cz>
 <5256B3E2.4060401@twiddle.net>
 <20131010142703.GI30970@tucnak.zalov.cz>
 <20131010151219.GC5167@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131010151219.GC5167@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 05:12:19PM +0200, Ingo Molnar wrote:
> 
> * Jakub Jelinek <jakub@redhat.com> wrote:
> 
> > On Thu, Oct 10, 2013 at 07:04:18AM -0700, Richard Henderson wrote:
> > > On 10/10/2013 01:31 AM, Jakub Jelinek wrote:
> > > > Also, for the bitops patch, you probably want an asm_volatile_goto variant.
> > > 
> > > Why?  Asm without output (which asm goto must be) are automatically volatile.
> > 
> > You're right.
> 
> Indeed. Something like the updated version below?
> 
> [ I kept the asm_volatile_goto() naming to make sure the implicit volatile 
>   is visible. ]

Ingo, I applied this patch (as commit c015a7f0b746) on top of
tip/sched/core

        3354781a2184 "sched/numa: Reflow task_numa_group() to avoid a compiler warning"

The below results show that it does fixed the many oops:

/kernel/i386-randconfig-i005-1008/c015a7f0b746d0a7e18b82876bd2b693722479d2

+--------------------------------------------------------------+--------------+--------------+
|                                                              | 3354781a2184 | c015a7f0b746 |
+--------------------------------------------------------------+--------------+--------------+
| WARNING:CPU:PID:at_fs/sysfs/dir.c:sysfs_add_one()            | 9            |              |
| WARNING:CPU:PID:at_lib/kobject.c:kobject_add_internal()      | 9            |              |
| WARNING:CPU:PID:at_drivers/base/driver.c:driver_unregister() | 9            |              |
| WARNING:CPU:PID:at_lib/list_debug.c:__list_add()             | 9            |              |
| kernel_BUG_at_kernel/timer.c                                 | 9            |              |
| invalid_opcode:PREEMPT_SMP                                   | 9            |              |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt        | 9            |              |
| good_boots                                                   | 0            | 9            |
+--------------------------------------------------------------+--------------+--------------+

/kernel/i386-randconfig-r4-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+--------------------------------------------------------------+--------------+--------------+
|                                                              | 3354781a2184 | c015a7f0b746 |
+--------------------------------------------------------------+--------------+--------------+
| BUG:kernel_early_hang_without_any_printk_output              | 2            | 3            |
| WARNING:CPU:PID:at_fs/sysfs/dir.c:sysfs_add_one()            | 7            |              |
| WARNING:CPU:PID:at_lib/kobject.c:kobject_add_internal()      | 7            |              |
| WARNING:CPU:PID:at_drivers/base/driver.c:driver_unregister() | 7            |              |
| WARNING:CPU:PID:at_lib/debugobjects.c:debug_print_object()   | 7            |              |
| INFO:trying_to_register_non-static_key                       | 7            |              |
| kernel_BUG_at_kernel/timer.c                                 | 7            |              |
| invalid_opcode:SMP                                           | 7            |              |
| Kernel_panic-not_syncing:Fatal_exception_in_interrupt        | 7            |              |
| good_boots                                                   | 0            | 6            |
+--------------------------------------------------------------+--------------+--------------+

/kernel/i386-randconfig-r8-1005/c015a7f0b746d0a7e18b82876bd2b693722479d2

+---------------------------------------------------------------+--------------+--------------+
|                                                               | 3354781a2184 | c015a7f0b746 |
+---------------------------------------------------------------+--------------+--------------+
| BUG:unable_to_handle_kernel_NULL_pointer_dereference_at       | 1            |              |
| Oops:DEBUG_PAGEALLOC                                          | 9            |              |
| kernel_BUG_at_kernel/cred.c                                   | 1            |              |
| invalid_opcode:DEBUG_PAGEALLOC                                | 1            |              |
| Kernel_panic-not_syncing:CRED:put_cred_rcu()sees_with_usage   | 4            |              |
| BUG:unable_to_handle_kernel_paging_request_at                 | 3            |              |
| BUG:unable_to_handle_kernel_NULL_pointer_dereference_at(null) | 5            |              |
| good_boots                                                    | 0            | 9            |
+---------------------------------------------------------------+--------------+--------------+

However it seems that it leads to or increases the chances of early
boot hang:

/kernel/x86_64-randconfig-a1-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| good_boots                                      | 9            | 8            |
| BUG:kernel_early_hang_without_any_printk_output | 0            | 1            |
+-------------------------------------------------+--------------+--------------+

/kernel/x86_64-randconfig-a5-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| good_boots                                      | 9            | 8            |
| BUG:kernel_early_hang_without_any_printk_output | 0            | 1            |
+-------------------------------------------------+--------------+--------------+

/kernel/i386-randconfig-r1-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| BUG:kernel_early_hang_without_any_printk_output | 9            | 9            |
+-------------------------------------------------+--------------+--------------+

/kernel/i386-randconfig-r7-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+--------------------------------------------------+--------------+--------------+
|                                                  | 3354781a2184 | c015a7f0b746 |
+--------------------------------------------------+--------------+--------------+
| BUG:soft_lockup-CPU_stuck_for_s                  | 1            |              |
| INFO:task_blocked_for_more_than_seconds          | 8            | 8            |
| Kernel_panic-not_syncing:hung_task:blocked_tasks | 8            | 8            |
| BUG:kernel_early_hang_without_any_printk_output  | 0            | 1            |
+--------------------------------------------------+--------------+--------------+

/kernel/i386-randconfig-r5-1009/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| BUG:kernel_early_hang_without_any_printk_output | 9            | 9            |
+-------------------------------------------------+--------------+--------------+

/kernel/i386-randconfig-i008-1008/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| BUG:kernel_early_hang_without_any_printk_output | 9            | 9            |
+-------------------------------------------------+--------------+--------------+

/kernel/i386-randconfig-i006-1008/c015a7f0b746d0a7e18b82876bd2b693722479d2

+-------------------------------------------------+--------------+--------------+
|                                                 | 3354781a2184 | c015a7f0b746 |
+-------------------------------------------------+--------------+--------------+
| good_boots                                      | 9            | 7            |
| BUG:kernel_early_hang_without_any_printk_output | 0            | 2            |
+-------------------------------------------------+--------------+--------------+

Thanks,
Fengguang
