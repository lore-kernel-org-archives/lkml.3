Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab3C3Da6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 23:30:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60097 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab3C3Da5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 23:30:57 -0400
Date: Fri, 29 Mar 2013 23:30:53 -0400 (EDT)
Message-Id: <20130329.233053.364190210064269793.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, vgupta@synopsys.com,
        chris@zankel.net, cmetcalf@tilera.com, ysato@users.sourceforge.jp,
        gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: Re: [PATCH v2 5/5] dump_stack: unify debug information printed by
 show_regs()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130330032445.GA28468@htj.dyndns.org>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
	<1364610428-2074-6-git-send-email-tj@kernel.org>
	<20130330032445.GA28468@htj.dyndns.org>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Mar 2013 20:30:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Fri, 29 Mar 2013 20:24:45 -0700

> show_regs() is inherently arch-dependent but it does make sense to
> print generic debug information and some archs already do albeit in
> slightly different forms.  This patch introduces a generic function to
> print debug information from show_regs() so that different archs print
> out the same information and it's much easier to modify what's
> printed.
> 
> show_regs_print_current() prints out the same debug info as
> dump_stack() does plus CPU, task and thread_info pointers.
> 
> * Archs which didn't print debug info now do.
> 
>   alpha, arc, blackfin, c6x, cris, frv, h8300, hexagon, ia64, m32r,
>   metag, microblaze, mn10300, openrisc, parisc, score, sh64, sparc,
>   um, xtensa
> 
> * Already prints debug info.  Replaced with show_regs_print_current().
>   The printed information is superset of what used to be there.
> 
>   arm, arm64, avr32, mips, powerpc, sh32, tile, unicore32, x86
> 
> * The printed debug information includes arch-specific bits.  Left
>   alone.
> 
>   s390
> 
> Note that now all archs print the debug info before actual register
> dumps.
> 
> An example BUG() dump follows.
> 
>  kernel BUG at /work/os/work/kernel/workqueue.c:4841!
>  invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>  Modules linked in:
>  Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc1-work+ #20 empty empty/S3992
>  CPU:0 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
>  RIP: 0010:[<ffffffff8234a042>]  [<ffffffff8234a042>] init_workqueues+0x15/0x17
>  RSP: 0000:ffff88007c861ec8  EFLAGS: 00010296
>  RAX: 0000000000000024 RBX: ffffffff82446608 RCX: 0000000000000001
>  RDX: 0000000000000046 RSI: 0000000000000000 RDI: 0000000000000009
>  RBP: ffff88007c861ec8 R08: 0000000000000000 R09: 0000000000000000
>  R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8234a02d
>  R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>  CR2: ffff88015f7ff000 CR3: 00000000021f1000 CR4: 00000000000007f0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Stack:
>   ffff88007c861ef8 ffffffff81000312 ffffffff82446608 ffff88007c85e650
>   0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
>   ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47730
>  Call Trace:
>   [<ffffffff81000312>] do_one_initcall+0x122/0x170
>   [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
>   ...
> 
> v2: Typo fix in x86-32.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>

For sparc bits:

Acked-by: David S. Miller <davem@davemloft.net>
