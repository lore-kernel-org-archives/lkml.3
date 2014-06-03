Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaFCK1N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:27:13 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60514 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752252AbaFCK1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:27:10 -0400
Date: Tue, 3 Jun 2014 11:26:46 +0100
From: Will Deacon <will.deacon@arm.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "larry.bassel@linaro.org \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v6 2/2] arm64: enable context tracking
Message-ID: <20140603102646.GB23149@arm.com>
References: <1401399904-24471-1-git-send-email-larry.bassel@linaro.org>
 <1401399904-24471-3-git-send-email-larry.bassel@linaro.org>
 <20140530182349.GI22895@arm.com>
 <7hioonythl.fsf@paris.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7hioonythl.fsf@paris.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

On Fri, May 30, 2014 at 08:08:38PM +0100, Kevin Hilman wrote:
> Will Deacon <will.deacon@arm.com> writes:
> > I'd like to give these some stress testing before it gets merged, so I'm
> > not sure if it'll make it for 3.16 given where we are at the moment.
> 
> FWIW, this feature is disabled by default.  I use the following kconfig
> fragment to enable the various parts I use for testing:
> 
> CONFIG_NO_HZ=y
> CONFIG_NO_HZ_FULL=y
> CONFIG_NO_HZ_FULL_ALL=y
> CONFIG_NO_HZ_FULL_SYSIDLE=y
> 
> # default to power-efficient workqueues (which are then set to unbound)
> CONFIG_WQ_POWER_EFFICIENT_DEFAULT=y
> 
> # lockup detector sets a 4s timer on every CPU, which wakes CPUs
> # from idle. (alternately, can be controlled via procfs,
> # e.g: echo 0 > /proc/sys/kernel/watchdog)
> #CONFIG_LOCKUP_DETECTOR=n

I had a go with this, but I couldn't seem to trigger any context tracking
without forcing CONFIG_CONTEXT_TRACKING_FORCE=y. Does that mean we're
missing something else?

Anyway, with that forced on, I see the following during boot:


------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/rcu/tree.c:418 rcu_eqs_enter+0x84/0xa4()
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.15.0-rc8+ #5
Call trace:
[<ffffffc000088048>] dump_backtrace+0x0/0x130
[<ffffffc000088188>] show_stack+0x10/0x1c
[<ffffffc0004891a0>] dump_stack+0x74/0xbc
[<ffffffc0000a45e0>] warn_slowpath_common+0x8c/0xb4
[<ffffffc0000a46cc>] warn_slowpath_null+0x14/0x20
[<ffffffc0000efc14>] rcu_eqs_enter+0x80/0xa4
[<ffffffc0000efc58>] rcu_idle_enter+0x20/0x50
[<ffffffc0000dd314>] cpu_startup_entry+0x118/0x184
[<ffffffc0004865ec>] rest_init+0x7c/0x88
[<ffffffc000609800>] start_kernel+0x368/0x37c
---[ end trace c17313e162496e65 ]---
------------[ cut here ]------------
WARNING: CPU: 0 PID: 0 at kernel/rcu/tree.c:541 rcu_eqs_exit+0xb0/0xbc()
Modules linked in:
CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        W     3.15.0-rc8+ #5
Call trace:
[<ffffffc000088048>] dump_backtrace+0x0/0x130
[<ffffffc000088188>] show_stack+0x10/0x1c
[<ffffffc0004891a0>] dump_stack+0x74/0xbc
[<ffffffc0000a45e0>] warn_slowpath_common+0x8c/0xb4
[<ffffffc0000a46cc>] warn_slowpath_null+0x14/0x20
[<ffffffc0000ed384>] rcu_eqs_exit+0xac/0xbc
[<ffffffc0000efdac>] rcu_user_exit+0xc/0x18
[<ffffffc00011d48c>] context_tracking_user_exit+0xc4/0xd4
[<ffffffc000083d98>] el1_irq+0x58/0xd4
[<ffffffc0000dd318>] cpu_startup_entry+0x11c/0x184
[<ffffffc0004865ec>] rest_init+0x7c/0x88
[<ffffffc000609800>] start_kernel+0x368/0x37c
---[ end trace c17313e162496e66 ]---


Can you take a look please? I had to fix up some conflicts to apply your
patches against our for-next branch, so I've put a branch here for you to
look at:

  git://git.kernel.org/pub/scm/linux/kernel/git/will/linux.git aarch64/context-tracking

Cheers,

Will
