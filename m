Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754278Ab3K0Giw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 01:38:52 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:9211 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab3K0Giu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 01:38:50 -0500
Message-ID: <52959328.3090407@huawei.com>
Date: Wed, 27 Nov 2013 14:37:28 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Tejun Heo <tj@kernel.org>, John Stultz <john.stultz@linaro.org>,
        "Mel Gorman" <mgorman@suse.de>, Juri Lelli <juri.lelli@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] cpuset: Fix memory allocator deadlock
References: <20131126140341.GL10022@twins.programming.kicks-ass.net>
In-Reply-To: <20131126140341.GL10022@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/11/26 22:03, Peter Zijlstra wrote:
> Juri hit the below lockdep report:
> 
> [    4.303391] ======================================================
> [    4.303392] [ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
> [    4.303394] 3.12.0-dl-peterz+ #144 Not tainted
> [    4.303395] ------------------------------------------------------
> [    4.303397] kworker/u4:3/689 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [    4.303399]  (&p->mems_allowed_seq){+.+...}, at: [<ffffffff8114e63c>] new_slab+0x6c/0x290
> [    4.303417]
> [    4.303417] and this task is already holding:
> [    4.303418]  (&(&q->__queue_lock)->rlock){..-...}, at: [<ffffffff812d2dfb>] blk_execute_rq_nowait+0x5b/0x100
> [    4.303431] which would create a new lock dependency:
> [    4.303432]  (&(&q->__queue_lock)->rlock){..-...} -> (&p->mems_allowed_seq){+.+...}
> [    4.303436]
> 
> [    4.303898] the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe lock:
> [    4.303918] -> (&p->mems_allowed_seq){+.+...} ops: 2762 {
> [    4.303922]    HARDIRQ-ON-W at:
> [    4.303923]                     [<ffffffff8108ab9a>] __lock_acquire+0x65a/0x1ff0
> [    4.303926]                     [<ffffffff8108cbe3>] lock_acquire+0x93/0x140
> [    4.303929]                     [<ffffffff81063dd6>] kthreadd+0x86/0x180
> [    4.303931]                     [<ffffffff816ded6c>] ret_from_fork+0x7c/0xb0
> [    4.303933]    SOFTIRQ-ON-W at:
> [    4.303933]                     [<ffffffff8108abcc>] __lock_acquire+0x68c/0x1ff0
> [    4.303935]                     [<ffffffff8108cbe3>] lock_acquire+0x93/0x140
> [    4.303940]                     [<ffffffff81063dd6>] kthreadd+0x86/0x180
> [    4.303955]                     [<ffffffff816ded6c>] ret_from_fork+0x7c/0xb0
> [    4.303959]    INITIAL USE at:
> [    4.303960]                    [<ffffffff8108a884>] __lock_acquire+0x344/0x1ff0
> [    4.303963]                    [<ffffffff8108cbe3>] lock_acquire+0x93/0x140
> [    4.303966]                    [<ffffffff81063dd6>] kthreadd+0x86/0x180
> [    4.303969]                    [<ffffffff816ded6c>] ret_from_fork+0x7c/0xb0
> [    4.303972]  }
> 
> Which reports that we take mems_allowed_seq with interrupts enabled. A
> little digging found that this can only be from
> cpuset_change_task_nodemask().
> 

Yeah, the other one in set_mems_allowed() was fixed by John.

> This is an actual deadlock because an interrupt doing an allocation will
> hit get_mems_allowed()->...->__read_seqcount_begin(), which will spin
> forever waiting for the write side to complete.
> 
> Cc: John Stultz <john.stultz@linaro.org>
> Cc: Mel Gorman <mgorman@suse.de>
> Reported-by: Juri Lelli <juri.lelli@gmail.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Acked-by: Li Zefan <lizefan@huawei.com>


