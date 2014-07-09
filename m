Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaGICNm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 22:13:42 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:51941 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751112AbaGICNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 22:13:41 -0400
X-IronPort-AV: E=Sophos;i="5.00,861,1396972800"; 
   d="scan'208";a="33022619"
Message-ID: <53BCA58C.8060106@cn.fujitsu.com>
Date: Wed, 9 Jul 2014 10:14:36 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: <paulmck@linux.vnet.ibm.com>
CC: <linux-kernel@vger.kernel.org>, <mingo@kernel.org>, <dipankar@in.ibm.com>,
        <akpm@linux-foundation.org>, <mathieu.desnoyers@efficios.com>,
        <josh@joshtriplett.org>, <niv@us.ibm.com>, <tglx@linutronix.de>,
        <peterz@infradead.org>, <rostedt@goodmis.org>, <dhowells@redhat.com>,
        <edumazet@google.com>, <dvhart@linux.intel.com>, <fweisbec@gmail.com>,
        <oleg@redhat.com>, <sbw@mit.edu>
Subject: Re: [PATCH tip/core/rcu 0/17] Miscellaneous fixes for 3.17
References: <20140707223756.GA7187@linux.vnet.ibm.com>
In-Reply-To: <20140707223756.GA7187@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides patch 3, please also add my review-by for these patches:
patch 1, 2, 5, 7, 12, 13, 15, 16, 17

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks,
Lai

On 07/08/2014 06:37 AM, Paul E. McKenney wrote:
> Hello!
> 
> This series provides miscellaneous fixes:
> 
> 1.	Document deadlock-avoidance information in rcu_read_unlock()'s
> 	docbook comment header.
> 
> 2.	Remove obsolete references to TINY_PREEMPT_RCU.
> 
> 3.	Add deadlock explanation to local_irq_save() call in
> 	__lock_task_sighand().
> 
> 4.	Make the rcu_node arrays be static const char * const,
> 	courtesy of Fabian Frederick.
> 
> 5.	Remove redundant ACCESS_ONCE() from tick_do_timer_cpu under
> 	#ifdef CONFIG_NO_HZ_FULL.
> 
> 6.	Eliminate read-modify-write ACCESS_ONCE() calls.
> 
> 7.	Loosen __call_rcu()'s rcu_head alignment constraint to handle
> 	m68k's 16-bit alignment.
> 
> 8.	Allow post-unlock reference for rt_mutex.
> 
> 9.	Check both root and current rcu_node structures when setting up
> 	future grace periods, courtesy of Pranith Kumar.
> 
> 10.	Simplify priority boosting by putting rt_mutex in rcu_node
> 	structure.
> 
> 11.	Bind grace-period kthreads to no-NO_HZ_FULL CPUs instead of the
> 	timekeeping CPU, at least for CONFIG_NO_HZ_FULL_SYSIDLE=n.
> 
> 12.	Don't use NMIs to dump other CPUs' stacks.
> 
> 13.	Use __this_cpu_read() instead of per_cpu_ptr(), courtesy of Shan Wei.
> 
> 14.	Remove CONFIG_PROVE_RCU_DELAY.
> 
> 15.	Fix __rcu_reclaim to use true/false instead of 1/0.
> 
> 16.	Fix sparse warning in rcu_initiate_boost(), courtesy of Pranith
> 	Kumar.
> 
> 17.	Fix sparse warning in rcu_report_unblock_qs_rnp(), again courtesy
> 	of Pranith Kumar.
> 
> 							Thanx, Paul
> 
> ------------------------------------------------------------------------
> 
>  b/include/linux/init_task.h                               |    9 --
>  b/include/linux/rcupdate.h                                |   45 ++++++++--
>  b/include/linux/sched.h                                   |    6 -
>  b/include/linux/tick.h                                    |   19 ++++
>  b/init/Kconfig                                            |    2 
>  b/kernel/rcu/rcu.h                                        |    8 +
>  b/kernel/rcu/srcu.c                                       |    4 
>  b/kernel/rcu/tree.c                                       |   59 ++++++--------
>  b/kernel/rcu/tree.h                                       |    8 +
>  b/kernel/rcu/tree_plugin.h                                |   52 +++++++-----
>  b/kernel/rcu/update.c                                     |    3 
>  b/kernel/signal.c                                         |    4 
>  b/kernel/time/tick-sched.c                                |   10 ++
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE01   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE02   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE02-T |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE03   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE04   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE05   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE06   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE07   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE08   |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE08-T |    1 
>  b/tools/testing/selftests/rcutorture/configs/rcu/TREE09   |    1 
>  24 files changed, 147 insertions(+), 93 deletions(-)
> 
> .
> 

