Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934759Ab3DHR5o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:57:44 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:38363 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759861Ab3DHR5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:57:42 -0400
Date: Mon, 8 Apr 2013 10:57:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, x86@kernel.org,
        rth@twiddle.net, linux@arm.linux.org.uk, msalter@redhat.com,
        starvik@axis.com, dhowells@redhat.com, tony.luck@intel.com,
        benh@kernel.crashing.org, takata@linux-m32r.org, geert@linux-m68k.org,
        james.hogan@imgtec.com, monstr@monstr.eu, ralf@linux-mips.org,
        jonas@southpole.se, rkuo@codeaurora.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, davem@davemloft.net, lethal@linux-sh.org,
        vgupta@synopsys.com, chris@zankel.net, cmetcalf@tilera.com,
        ysato@users.sourceforge.jp, gxt@mprc.pku.edu.cn, jdike@addtoit.com
Subject: Re: [PATCH 1/7] x86: don't show trace beyond show_stack(NULL, NULL)
Message-ID: <20130408175734.GH3021@htj.dyndns.org>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <1365016497-32033-2-git-send-email-tj@kernel.org>
 <20130408160811.GA20612@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408160811.GA20612@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Ingo.

On Mon, Apr 08, 2013 at 06:08:11PM +0200, Ingo Molnar wrote:
> >  void show_stack(struct task_struct *task, unsigned long *sp)
> >  {
> > -	show_stack_log_lvl(task, NULL, sp, 0, "");
> > +	unsigned long bp = 0;
> > +	unsigned long stack;
> > +
> > +	/*
> > +	 * Stack frames below this one aren't interesting.  Don't show them
> > +	 * if we're printing for %current.
> > +	 */
> > +	if (!sp && (!task || task == current)) {
> > +		sp = &stack;
> > +		bp = stack_frame(current, NULL);
> > +	}
> > +
> > +	show_stack_log_lvl(task, NULL, sp, bp, "");
> 
> Hm, show_regs() has a similar problem AFAICS.

Doesn't seem so.  show_regs() have pt_regs which gets passed to
dump_trace() and then used to determine the frame being dumped.
e.g. BUG() takes pt_regs from the faulting frame and thus doesn't show
anything beyond it.

 kernel BUG at /work/os/work/kernel/workqueue.c:4841!
 invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 Modules linked in:
 CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.9.0-rc1-work+ #7
 Hardware name: empty empty/S3992, BIOS 080011  10/26/2007
 task: ffff88007c85e040 ti: ffff88007c860000 task.ti: ffff88007c860000
 RIP: 0010:[<ffffffff8234a07e>]  [<ffffffff8234a07e>] init_workqueues+0x4/0x6
 RSP: 0000:ffff88007c861ec8  EFLAGS: 00010246
 RAX: ffff88007c861fd8 RBX: ffffffff824466a8 RCX: 0000000000000001
 RDX: 0000000000000046 RSI: 0000000000000001 RDI: ffffffff8234a07a
 RBP: ffff88007c861ec8 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000001 R11: 0000000000000000 R12: ffffffff8234a07a
 R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
 FS:  0000000000000000(0000) GS:ffff88007dc00000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: ffff88015f7ff000 CR3: 00000000021f1000 CR4: 00000000000007f0
 DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
 DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
 Stack:
  ffff88007c861ef8 ffffffff81000312 ffffffff824466a8 ffff88007c85e650
  0000000000000003 0000000000000000 ffff88007c861f38 ffffffff82335e5d
  ffff88007c862080 ffffffff8223d8c0 ffff88007c862080 ffffffff81c47760
 Call Trace:
  [<ffffffff81000312>] do_one_initcall+0x122/0x170
  [<ffffffff82335e5d>] kernel_init_freeable+0x9b/0x1c8
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  [<ffffffff81c4776e>] kernel_init+0xe/0xf0
  [<ffffffff81c6be9c>] ret_from_fork+0x7c/0xb0
  [<ffffffff81c47760>] ? rest_init+0x140/0x140
  ...


Thanks.

-- 
tejun
