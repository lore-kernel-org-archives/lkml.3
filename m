Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934348Ab3DHQIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 12:08:21 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:42720 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab3DHQIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 12:08:16 -0400
Date: Mon, 8 Apr 2013 18:08:11 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Tejun Heo <tj@kernel.org>
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
Message-ID: <20130408160811.GA20612@gmail.com>
References: <1365016497-32033-1-git-send-email-tj@kernel.org>
 <1365016497-32033-2-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365016497-32033-2-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Tejun Heo <tj@kernel.org> wrote:

> show_stack(current or NULL, NULL) is used to print the backtrace of
> the current task.  As trace beyond the function itself isn't of much
> interest to anyone, don't show it by determining sp and bp in
> show_stack()'s frame and passing them to show_stack_log_lvl().
> 
> This brings show_stack(NULL, NULL)'s behavior in line with
> dump_stack().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  arch/x86/kernel/dumpstack.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
> index c8797d5..dd1a7c3 100644
> --- a/arch/x86/kernel/dumpstack.c
> +++ b/arch/x86/kernel/dumpstack.c
> @@ -176,7 +176,19 @@ void show_trace(struct task_struct *task, struct pt_regs *regs,
>  
>  void show_stack(struct task_struct *task, unsigned long *sp)
>  {
> -	show_stack_log_lvl(task, NULL, sp, 0, "");
> +	unsigned long bp = 0;
> +	unsigned long stack;
> +
> +	/*
> +	 * Stack frames below this one aren't interesting.  Don't show them
> +	 * if we're printing for %current.
> +	 */
> +	if (!sp && (!task || task == current)) {
> +		sp = &stack;
> +		bp = stack_frame(current, NULL);
> +	}
> +
> +	show_stack_log_lvl(task, NULL, sp, bp, "");

Hm, show_regs() has a similar problem AFAICS.

Would be nice to create an __always_inline helper for all this, and to use it for 
show_regs() as well.

Then the !bp special case in dump_trace() could be removed, and !bp be made an 
invalid variant.

Thanks,

	Ingo
