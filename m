Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750902Ab3CAFpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 00:45:46 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:53406 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab3CAFpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 00:45:45 -0500
Date: Fri, 1 Mar 2013 11:15:36 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH v3 2/6] uretprobes/x86: hijack return address
Message-ID: <20130301054536.GB30500@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1362049215-5780-1-git-send-email-anton@redhat.com> <1362049215-5780-3-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362049215-5780-3-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030105-2876-0000-0000-000005D8EBE9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 12:00:11PM +0100, Anton Arapov wrote:
>   hijack the return address and replace it with a "trampoline"
> 
> v2:
>   - remove ->doomed flag, kill task immediately
> 
> Signed-off-by: Anton Arapov <anton@redhat.com>
> ---
>  arch/x86/include/asm/uprobes.h |  1 +
>  arch/x86/kernel/uprobes.c      | 29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 8ff8be7..c353555 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -55,4 +55,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
>  extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
>  extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long rp_trampoline_vaddr, struct pt_regs *regs);
>  #endif	/* _ASM_UPROBES_H */
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 0ba4cfb..85e2153 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -697,3 +697,32 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  		send_sig(SIGTRAP, current, 0);
>  	return ret;
>  }
> +
> +extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long
> +		rp_trampoline_vaddr, struct pt_regs *regs)
> +{
> +	int rasize, ncopied;
> +	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
> +
> +	rasize = is_ia32_task() ? 4 : 8;
> +	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
> +	if (unlikely(ncopied))

What if ncopied < rasize? Agreed that the upper order bits can be 0, but should
you not validate ncopied == rasize?

Ananth

