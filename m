Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933639Ab3DGLyq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 07:54:46 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49529 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933607Ab3DGLyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 07:54:45 -0400
Date: Sun, 7 Apr 2013 17:18:59 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 3/9] uretprobes/x86: Hijack return address
Message-ID: <20130407114859.GC2186@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
 <1365004839-21982-4-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1365004839-21982-4-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040711-5806-0000-0000-000020A12E6F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anton Arapov <anton@redhat.com> [2013-04-03 18:00:33]:

> Hijack the return address and replace it with a trampoline address.
> 
> v1 changes:
> * use force_sig_info()
> * rework and simplify logic
> 
> RFCv5 changes:
> * change the fail return code, because orig_ret_vaddr=0 is possible
> * style fixup
> RFCv2 changes:
> * remove ->doomed flag, kill task immediately
> 
> Signed-off-by: Anton Arapov <anton@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  arch/x86/include/asm/uprobes.h |  1 +
>  arch/x86/kernel/uprobes.c      | 29 +++++++++++++++++++++++++++++
>  2 files changed, 30 insertions(+)
> 
> diff --git a/arch/x86/include/asm/uprobes.h b/arch/x86/include/asm/uprobes.h
> index 8ff8be7..6e51979 100644
> --- a/arch/x86/include/asm/uprobes.h
> +++ b/arch/x86/include/asm/uprobes.h
> @@ -55,4 +55,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
>  extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
>  extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
>  #endif	/* _ASM_UPROBES_H */
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 0ba4cfb..2ed8459 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -697,3 +697,32 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
>  		send_sig(SIGTRAP, current, 0);
>  	return ret;
>  }
> +
> +unsigned long
> +arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
> +{
> +	int rasize, ncopied;
> +	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
> +
> +	rasize = is_ia32_task() ? 4 : 8;
> +	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
> +	if (unlikely(ncopied))
> +		return -1;
> +
> +	/* check whether address has been already hijacked */
> +	if (orig_ret_vaddr == trampoline_vaddr)
> +		return orig_ret_vaddr;
> +
> +	ncopied = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
> +	if (likely(!ncopied))
> +		return orig_ret_vaddr;
> +
> +	if (ncopied != rasize) {
> +		pr_err("uprobe: return address clobbered: pid=%d, %%sp=%#lx, "
> +			"%%ip=%#lx\n", current->pid, regs->sp, regs->ip);
> +
> +		force_sig_info(SIGSEGV, SEND_SIG_FORCED, current);
> +	}
> +
> +	return -1;
> +}
> -- 
> 1.8.1.4
> 

-- 
Thanks and Regards
Srikar Dronamraju

