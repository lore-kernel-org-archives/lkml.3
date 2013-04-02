Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761575Ab3DBJ0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 05:26:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760766Ab3DBJ0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 05:26:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1364610428-2074-1-git-send-email-tj@kernel.org>
References: <1364610428-2074-1-git-send-email-tj@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: dhowells@redhat.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mingo@redhat.com, x86@kernel.org, rth@twiddle.net,
        linux@arm.linux.org.uk, msalter@redhat.com, starvik@axis.com,
        tony.luck@intel.com, benh@kernel.crashing.org, takata@linux-m32r.org,
        geert@linux-m68k.org, james.hogan@imgtec.com, monstr@monstr.eu,
        ralf@linux-mips.org, jonas@southpole.se, rkuo@codeaurora.org,
        schwidefsky@de.ibm.com, liqin.chen@sunplusct.com, davem@davemloft.net,
        lethal@linux-sh.org, vgupta@synopsys.com, chris@zankel.net,
        cmetcalf@tilera.com, ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn,
        jdike@addtoit.com
Subject: Re: [PATCHSET] arch: unify task dump debug info
Date: Tue, 02 Apr 2013 10:24:27 +0100
Message-ID: <32341.1364894667@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tejun Heo <tj@kernel.org> wrote:

> There are multiple ways a task can be dumped - explicit call to
> dump_stack(), triggering WARN() or BUG(), through sysrq-t and so on.
> Most of what gets printed is upto each architecture and the current
> state is not particularly pretty.  Different pieces of information are
> presented differently depending on which path the dump takes and which
> architecture it's running on.  This is messy for no good reason and
> makes it exceedingly difficult to add or modify debug information to
> task dumps.
> 
> In all archs except for s390, there's nothing arch-specific about the
> printed debug information.  This patchset updates all those archs to
> use the same helpers to consistently print out the same debug
> information.
> 
> An example WARN dump after this patchset.
> 
>  WARNING: at /work/os/work/kernel/workqueue.c:4840 init_workqueues+0x35/0x505()
>  Modules linked in:
>  Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc1-work+ #18 empty empty/S3992
>   0000000000000009 ffff88007c861e08 ffffffff81c61525 ffff88007c861e48
>   ffffffff8108f500 ffffffff82228240 0000000000000040 ffffffff8234a041
>   0000000000000000 0000000000000000 0000000000000000 ffff88007c861e58
>  Call Trace:
>   [<ffffffff81c61525>] dump_stack+0x19/0x1b
>   [<ffffffff8108f500>] warn_slowpath_common+0x70/0xa0
>   [<ffffffff8108f54a>] warn_slowpath_null+0x1a/0x20
>   [<ffffffff8234a076>] init_workqueues+0x35/0x505
>   ...
> 
> And BUG dump.
> 
>  kernel BUG at /work/os/work/kernel/workqueue.c:4841!
>  invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
>  Modules linked in:
>  Pid: 1, comm: swapper/0 Tainted: G        W    3.9.0-rc1-work+ #20 empty empty/S3992
>  CPU:0 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
>  RIP: 0010:[<ffffffff8234a042>]  [<ffffffff8234a042>] init_workqueues+0x15/0x17
>  RSP: 0000:ffff88007c861ec8  EFLAGS: 00010296
>  RAX: 0000000000000024 RBX: ffffffff82446608 RCX: 0000000000000001
>  ...
>  Stack:
>   ffff88007c861ef8 ffffffff81000312 ffffffff82446608 ffff88007c85e650
>   0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
>   ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47730
>  Call Trace:
>   [<ffffffff81000312>] do_one_initcall+0x122/0x170
>   [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
>   ...
> 
> This patchset contains the following five patches.
> 
>  0001-x86-don-t-show-trace-beyond-show_stack-NULL-NULL.patch
>  0002-sparc32-make-show_stack-acquire-fp-if-_ksp-is-not-sp.patch
>  0003-dump_stack-consolidate-dump_stack-implementations-an.patch
>  0004-dump_stack-implement-arch-specific-hardware-descript.patch
>  0005-dump_stack-unify-debug-information-printed-by-show_r.patch
> 
> 0001-0002 update stack dumping functions in x86 and sparc32 in
> preparation.
> 
> 0003 makes all arches except s390 and blackfin use generic
> dump_stack().  blackfin still uses the generic helper to print the
> same info.  s390 is left alone as its current debug info includes
> arch-specific stuff.
> 
> 0004 properly abstracts DMI identifier printing in WARN() and
> show_regs() so that all dumps print out the information.  This enables
> show_regs() to use the same debug info message.
> 
> 0005 updates show_regs() of all arches except for s390 to use a common
> generic helper to print debug info.
> 
> While this patchset changes how debug info is printed on some archs,
> the printed information is always superset of what used to be there.
> 
> This patchset makes task dump debug messages consistent and enables
> adding more information.  Workqueue is scheduled to add worker
> information including the workqueue in use and work item specific
> description.
> 
> This patchset is based on top of v3.9-rc4 and available in the
> following git branch.
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-unify-dump
> 
> While this patch touches a lot of archs, it isn't too likely to cause
> non-trivial conflicts with arch-specfic changes and would probably be
> best to route together either through -tip or -mm.
> 
> x86 is tested but other archs are either only compile tested or not
> tested at all.  Changes to most archs are generally trivial.

For FRV and MN10300 bits:

Acked-by: David Howells <dhowells@redhat.com>
