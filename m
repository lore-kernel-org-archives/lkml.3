Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573AbaIILkT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 07:40:19 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41406 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752344AbaIILkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 07:40:16 -0400
Date: Tue, 9 Sep 2014 12:39:43 +0100
From: Will Deacon <will.deacon@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Clark <robdclark@gmail.com>
Subject: Re: [PATCH] ARM: perf: Don't sleep while atomic when enabling
 per-cpu interrupts
Message-ID: <20140909113943.GG1754@arm.com>
References: <1410200814-25878-1-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410200814-25878-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Sep 08, 2014 at 07:26:54PM +0100, Stephen Boyd wrote:
> Rob Clark reports a sleeping while atomic bug when using perf.
> 
> BUG: sleeping function called from invalid context at ../kernel/locking/mutex.c:583
> in_atomic(): 1, irqs_disabled(): 128, pid: 0, name: swapper/0
> ------------[ cut here ]------------
> WARNING: CPU: 2 PID: 4828 at ../kernel/locking/mutex.c:479 mutex_lock_nested+0x3a0/0x3e8()
> DEBUG_LOCKS_WARN_ON(in_interrupt())
> Modules linked in:
> CPU: 2 PID: 4828 Comm: Xorg.bin Tainted: G        W      3.17.0-rc3-00234-gd535c45-dirty #819
> [<c0216690>] (unwind_backtrace) from [<c0212174>] (show_stack+0x10/0x14)
> [<c0212174>] (show_stack) from [<c0867cc0>] (dump_stack+0x98/0xb8)
> [<c0867cc0>] (dump_stack) from [<c02492a4>] (warn_slowpath_common+0x70/0x8c)
> [<c02492a4>] (warn_slowpath_common) from [<c02492f0>] (warn_slowpath_fmt+0x30/0x40)
> [<c02492f0>] (warn_slowpath_fmt) from [<c086a3f8>] (mutex_lock_nested+0x3a0/0x3e8)
> [<c086a3f8>] (mutex_lock_nested) from [<c0294d08>] (irq_find_host+0x20/0x9c)
> [<c0294d08>] (irq_find_host) from [<c0769d50>] (of_irq_get+0x28/0x48)
> [<c0769d50>] (of_irq_get) from [<c057d104>] (platform_get_irq+0x1c/0x8c)
> [<c057d104>] (platform_get_irq) from [<c021a06c>] (cpu_pmu_enable_percpu_irq+0x14/0x38)
> [<c021a06c>] (cpu_pmu_enable_percpu_irq) from [<c02b1634>] (flush_smp_call_function_queue+0x88/0x178)
> [<c02b1634>] (flush_smp_call_function_queue) from [<c0214dc0>] (handle_IPI+0x88/0x160)
> [<c0214dc0>] (handle_IPI) from [<c0208930>] (gic_handle_irq+0x64/0x68)
> [<c0208930>] (gic_handle_irq) from [<c0212d04>] (__irq_svc+0x44/0x5c)
> Exception stack(0xe63ddea0 to 0xe63ddee8)
> dea0: 00000001 00000001 00000000 c2f3b200 c16db380 c032d4a0 e63ddf40 60010013
> dec0: 00000000 001fbfd4 00000100 00000000 00000001 e63ddee8 c0284770 c02a2e30
> dee0: 20010013 ffffffff
> [<c0212d04>] (__irq_svc) from [<c02a2e30>] (ktime_get_ts64+0x1c8/0x200)
> [<c02a2e30>] (ktime_get_ts64) from [<c032d4a0>] (poll_select_set_timeout+0x60/0xa8)
> [<c032d4a0>] (poll_select_set_timeout) from [<c032df64>] (SyS_select+0xa8/0x118)
> [<c032df64>] (SyS_select) from [<c020e8e0>] (ret_fast_syscall+0x0/0x48)
> ---[ end trace 0bb583b46342da6f ]---
> INFO: lockdep is turned off.
> 
> We don't really need to get the platform irq again when we're
> enabling or disabling the per-cpu irq. Instead we can pass along
> the two pieces of data we need to the enable/disable functions.
> This should be slightly more efficient and also fix the
> scheduling while atomic bug.
> 
> Reported-by: Rob Clark <robdclark@gmail.com>
> Fixes: bbd64559376f "ARM: perf: support percpu irqs for the CPU PMU"
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

It's interesting that arm64 isn't affected by this problem, since we don't
update the active_irqs mask for PPIs there and consequently just pass the
irq instead of the cpu_pmu. I can't see why we actually need to update the
active_irqs mask for arch/arm/, so could we remove that and follow arm64's
lead instead? That would remove the need for a new struct definition too.

Will
