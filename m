Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab3C3GNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 02:13:42 -0400
Received: from alvesta.synopsys.com ([198.182.60.77]:49895 "EHLO
	alvesta.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752432Ab3C3GNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 02:13:40 -0400
Message-ID: <51568277.8000404@synopsys.com>
Date: Sat, 30 Mar 2013 11:43:11 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <mingo@redhat.com>, <x86@kernel.org>,
        <rth@twiddle.net>, <linux@arm.linux.org.uk>, <msalter@redhat.com>,
        <starvik@axis.com>, <dhowells@redhat.com>, <tony.luck@intel.com>,
        <benh@kernel.crashing.org>, <takata@linux-m32r.org>,
        <geert@linux-m68k.org>, <james.hogan@imgtec.com>, <monstr@monstr.eu>,
        <ralf@linux-mips.org>, <jonas@southpole.se>, <rkuo@codeaurora.org>,
        <schwidefsky@de.ibm.com>, <liqin.chen@sunplusct.com>,
        <davem@davemloft.net>, <lethal@linux-sh.org>, <chris@zankel.net>,
        <cmetcalf@tilera.com>, <ysato@users.sourceforge.jp>,
        <gxt@mprc.pku.edu.cn>, <jdike@addtoit.com>
Subject: Re: [PATCH v2 5/5] dump_stack: unify debug information printed by
 show_regs()
References: <1364610428-2074-1-git-send-email-tj@kernel.org> <1364610428-2074-6-git-send-email-tj@kernel.org> <20130330032445.GA28468@htj.dyndns.org>
In-Reply-To: <20130330032445.GA28468@htj.dyndns.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 03/30/2013 08:54 AM, Tejun Heo wrote:
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
> ---
> Silly last minute mistake in x86-32.  git branch updated accordingly.
> 
> Thanks.
> 
>  arch/alpha/kernel/process.c         |  1 +
>  arch/arc/kernel/troubleshoot.c      |  1 +
>  arch/arm/kernel/process.c           |  8 ++------
>  arch/arm64/kernel/process.c         |  7 +------
>  arch/avr32/kernel/process.c         |  5 ++---
>  arch/blackfin/kernel/trace.c        |  2 ++
>  arch/c6x/kernel/traps.c             |  1 +
>  arch/cris/arch-v10/kernel/process.c |  3 +++
>  arch/cris/arch-v32/kernel/process.c |  3 +++
>  arch/frv/kernel/traps.c             |  3 +--
>  arch/h8300/kernel/process.c         |  2 ++
>  arch/hexagon/kernel/vm_events.c     |  2 ++
>  arch/ia64/kernel/process.c          |  4 ++--
>  arch/m32r/kernel/process.c          |  2 ++
>  arch/metag/kernel/process.c         |  2 ++
>  arch/microblaze/kernel/process.c    |  2 ++
>  arch/mips/kernel/traps.c            |  2 +-
>  arch/mn10300/kernel/process.c       |  1 +
>  arch/openrisc/kernel/process.c      |  1 +
>  arch/parisc/kernel/traps.c          |  2 ++
>  arch/powerpc/kernel/process.c       |  8 ++------
>  arch/score/kernel/traps.c           |  2 ++
>  arch/sh/kernel/process_32.c         |  6 +-----
>  arch/sh/kernel/process_64.c         |  1 +
>  arch/sparc/kernel/process_32.c      |  2 ++
>  arch/sparc/kernel/process_64.c      |  2 ++
>  arch/tile/kernel/process.c          |  3 +--
>  arch/um/sys-ppc/sysrq.c             |  2 ++
>  arch/unicore32/kernel/process.c     |  6 +-----
>  arch/x86/include/asm/bug.h          |  3 ---
>  arch/x86/kernel/dumpstack_32.c      |  4 +---
>  arch/x86/kernel/dumpstack_64.c      |  6 +-----
>  arch/x86/kernel/process.c           | 24 ------------------------
>  arch/x86/kernel/process_32.c        |  2 --
>  arch/x86/kernel/process_64.c        |  1 -
>  arch/xtensa/kernel/traps.c          |  2 ++
>  include/linux/printk.h              |  2 ++
>  lib/dump_stack.c                    | 16 ++++++++++++++++
>  38 files changed, 70 insertions(+), 76 deletions(-)
> 
[..]
>  
> diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
> index 7c10873..96be1e6 100644
> --- a/arch/arc/kernel/troubleshoot.c
> +++ b/arch/arc/kernel/troubleshoot.c
> @@ -163,6 +163,7 @@ void show_regs(struct pt_regs *regs)
>  		return;
>  
>  	print_task_path_n_nm(tsk, buf);
> +	show_regs_print_info(KERN_INFO);
>  
>  	if (current->thread.cause_code)
>  		show_ecr_verbose(regs);

With print-fatal-signals enabled, this will also be called for dumping user mode
register state. With your patch, we now get something like this

----------->8-------------------------
[ARCLinux]$ ./crash
crash/50: potentially unexpected fatal signal 11.	<-- [1]
/sbin/crash, TGID 50					<-- [2]
Pid: 50, comm: crash Not tainted 3.9.0-rc4+ #132 	<-- [3]
CPU:0 task: 8e11c2c0 ti: 8e136000 task.ti: 8e136000

[ECR]: 0x00230400 => Misaligned r/w from 0x0001036a
[EFA]: 0x0001036a
[ERET]: 0x0001036a (PC of Faulting Instr)
...
...
----------->8-------------------------

Clearly there's duplication (rather triplication) of task name and tgid output.

Although in line [2], ARC trouble-shooting code prints the task path (rather than
comm). This was done to help identify faulting LTP open posix tests with same name
in different directories: e.g. fork/6-1, sigqueue/6-1 ....
Is this something you want to add to generic code as well - although it's slightly
involved due to tsk/mm locking etc.

Also I personally prefer the more compact <task-nm>/<tgid> format of [1] vs. [3].

Anyhow, can you please fold the following into your patchset to reduce above
duplication.

------------------->
>From 15e8d65f35385148f81d87aadadd7791ba79663c Mon Sep 17 00:00:00 2001
From: Vineet Gupta <vgupta@synopsys.com>
Date: Sat, 30 Mar 2013 11:35:23 +0530
Subject: [PATCH] print-fatal-signals: reduce duplicated information

----------->8------------
[ARCLinux]$ ./crash
crash/50: potentially unexpected fatal signal 11.	<-- [1]
/sbin/crash, TGID 50					<-- [2]
Pid: 50, comm: crash Not tainted 3.9.0-rc4+ #132 	<-- [3]
...
----------->8------------

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/kernel/troubleshoot.c |    2 +-
 kernel/signal.c                |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/arc/kernel/troubleshoot.c b/arch/arc/kernel/troubleshoot.c
index 96be1e6..0aec0198 100644
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -71,7 +71,7 @@ void print_task_path_n_nm(struct task_struct *tsk, char *buf)
 	}

 done:
-	pr_info("%s, TGID %u\n", path_nm, tsk->tgid);
+	pr_info("Path: %s\n", path_nm);
 }
 EXPORT_SYMBOL(print_task_path_n_nm);

diff --git a/kernel/signal.c b/kernel/signal.c
index dd72567..9c4ef65 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1160,8 +1160,7 @@ static int send_signal(int sig, struct siginfo *info, struct
task_struct *t,
 static void print_fatal_signal(int signr)
 {
 	struct pt_regs *regs = signal_pt_regs();
-	printk(KERN_INFO "%s/%d: potentially unexpected fatal signal %d.\n",
-		current->comm, task_pid_nr(current), signr);
+	printk(KERN_INFO "potentially unexpected fatal signal %d.\n", signr);

 #if defined(__i386__) && !defined(__arch_um__)
 	printk(KERN_INFO "code at %08lx: ", regs->ip);
-- 
1.7.10.4


