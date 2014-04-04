Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753034AbaDDV4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:56:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:39128 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399AbaDDV4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:56:51 -0400
Subject: Re: [PATCH v2 9/9] uprobes/x86: Teach arch_uprobe_post_xol() to
 restart if possible
From: Jim Keniston <jkenisto@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <aarapov@redhat.com>, David Long <dave.long@linaro.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Jonathan Lebon <jlebon@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20140404185142.GA14756@redhat.com>
References: <20140404185142.GA14756@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Apr 2014 14:56:47 -0700
Message-ID: <1396648607.4769.3.camel@oc7886638347.ibm.com.usor.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-30.el6) 
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14040421-1542-0000-0000-000000DF21A2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-04 at 20:51 +0200, Oleg Nesterov wrote:
> SIGILL after the failed arch_uprobe_post_xol() should only be used as
> a last resort, we should try to restart the probed insn if possible.
> 
> Currently only adjust_ret_addr() can fail, and this can only happen if
> another thread unmapped our stack after we executed "call" out-of-line.
> Most probably the application if buggy, but even in this case it can
> have a handler for SIGSEGV/etc. And in theory it can be even correct
> and do something non-trivial with its memory.
> 
> Of course we can't restart unconditionally, so arch_uprobe_post_xol()
> does this only if ->post_xol() returns -ERESTART even if currently this
> is the only possible error.

When re-executing the call instruction, I'd think the stack pointer
would be wrong the second time around, unless you pop off the return
address from the first try.

> 
> Note: this is not "perfect", we do not want the extra handler_chain()
> after restart, but I think this is the best solution we can realistically
> do without too much uglifications.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  arch/x86/kernel/uprobes.c |   15 +++++++++++----
>  1 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index e72903e..b820668 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -443,16 +443,17 @@ static int default_post_xol_op(struct arch_uprobe *auprobe, struct pt_regs *regs
>  {
>  	struct uprobe_task *utask = current->utask;
>  	long correction = (long)(utask->vaddr - utask->xol_vaddr);
> -	int ret = 0;
> 
>  	handle_riprel_post_xol(auprobe, regs, &correction);
>  	if (auprobe->fixups & UPROBE_FIX_IP)
>  		regs->ip += correction;
> 
> -	if (auprobe->fixups & UPROBE_FIX_CALL)
> -		ret = adjust_ret_addr(regs->sp, correction);
> +	if (auprobe->fixups & UPROBE_FIX_CALL) {
> +		if (adjust_ret_addr(regs->sp, correction))
> +			return -ERESTART;
> +	}
> 
> -	return ret;
> +	return 0;
>  }
> 
>  static struct uprobe_xol_ops default_xol_ops = {
> @@ -599,6 +600,12 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  		int err = auprobe->ops->post_xol(auprobe, regs);
>  		if (err) {
>  			arch_uprobe_abort_xol(auprobe, regs);
> +			/*
> +			 * Restart the probed insn. ->post_xol() must ensure
> +			 * this is really possible if it returns -ERESTART.
> +			 */
> +			if (err == -ERESTART)
> +				return 0;
>  			return err;
>  		}
>  	}


