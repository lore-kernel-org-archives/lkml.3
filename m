Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561AbaI2LLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 07:11:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:37218 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695AbaI2LLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 07:11:16 -0400
Date: Mon, 29 Sep 2014 13:11:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Cong Wang <cwang@twopensource.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: perf: perf_fuzzer triggers instant reboot
Message-ID: <20140929111111.GF5430@worktop>
References: <alpine.DEB.2.11.1409091352260.15874@vincent-weaver-1.umelst.maine.edu>
 <20140910083136.GP6758@twins.programming.kicks-ass.net>
 <alpine.DEB.2.11.1409100914410.8981@vincent-weaver-1.umelst.maine.edu>
 <541059C9.1040200@oracle.com>
 <alpine.DEB.2.11.1409101027250.8981@vincent-weaver-1.umelst.maine.edu>
 <20140910143306.GD4783@worktop.ger.corp.intel.com>
 <alpine.DEB.2.11.1409110926120.11483@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.11.1409250052480.26664@vincent-weaver-1.umelst.maine.edu>
 <CAHA+R7Nu_2KORkf9uP1_HktRA+MLy6TS4vXCPS9Q_JzrcH2SYg@mail.gmail.com>
 <542789E5.7090805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542789E5.7090805@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 12:09:09AM -0400, Sasha Levin wrote:

> [  690.801720] 2 locks held by trinity-c95/17888:
> [  690.801738] #0: (cpu_hotplug.lock){++++++}, at: get_online_cpus (kernel/cpu.c:92)
> [  690.801754] #1: (&ctx->lock){-.-...}, at: perf_lock_task_context (kernel/events/core.c:988)
> [  690.801758]
> [  690.801758] stack backtrace:
> [  690.801766] CPU: 21 PID: 17888 Comm: trinity-c95 Not tainted 3.17.0-rc6-next-20140926-sasha-00051-g9253dff-dirty #1242
> [  690.801779]  ffffffff92b7f320 0000000000000000 ffffffff92afbee0 ffff8804078179c8
> [  690.801798]  ffffffff8ef0070f 0000000000000011 ffffffff92ab6aa0 ffff880407817a18
> [  690.801813]  ffffffff8a24ec2c ffff880407817aa8 ffff880409c00000 ffff880407817a18
> [  690.801818] Call Trace:
> [  690.801836] dump_stack (lib/dump_stack.c:52)
> [  690.801845] print_circular_bug (kernel/locking/lockdep.c:1217)
> [  690.801856] __lock_acquire (kernel/locking/lockdep.c:1842 kernel/locking/lockdep.c:1947 kernel/locking/lockdep.c:2133 kernel/locking/lockdep.c:3184)
> [  690.801872] lock_acquire (kernel/locking/lockdep.c:3610)
> [  690.801892] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> [  690.801921] __queue_work (kernel/workqueue.c:1325)
> [  690.801943] queue_work_on (kernel/workqueue.c:1403)
> [  690.801956] free_object (lib/debugobjects.c:209)
> [  690.801967] __debug_check_no_obj_freed (lib/debugobjects.c:718)
> [  690.801983] debug_check_no_obj_freed (lib/debugobjects.c:727)
> [  690.801995] kmem_cache_free (mm/slub.c:2687 mm/slub.c:2715)
> [  690.802016] free_task (kernel/fork.c:221)
> [  690.802026] __put_task_struct (kernel/fork.c:251)
> [  690.802037] put_ctx (include/linux/sched.h:1864 kernel/events/core.c:904)
> [  690.802049] find_get_context (kernel/events/core.c:913 kernel/events/core.c:3222)
> [  690.802078] SYSC_perf_event_open (kernel/events/core.c:7347)
> [  690.802111] SyS_perf_event_open (kernel/events/core.c:7210)
> [  690.802120] tracesys_phase2 (arch/x86/kernel/entry_64.S:529)

This doesn't make sense; perf_lock_task_context() isn't supposed to
return with ctx->lock held and therefore it should not still be held in
find_get_context() when calling put_ctx().

Now, the only put_ctx() call in find_get_context() is in the !ctx path
of the perf_lock_task_context() call, furthermore there is a
mutex_lock() - which implies a might_sleep() - before that, so we can't
still be holding a spinlock().

Most puzzled.
