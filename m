Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab3DDDcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 23:32:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57782 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab3DDDcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 23:32:19 -0400
Date: Thu, 4 Apr 2013 09:01:49 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, adrian.m.negreanu@intel.com,
        Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 4/9] uretprobes/ppc: Hijack return address
Message-ID: <20130404033149.GA17518@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <1365004839-21982-1-git-send-email-anton@redhat.com> <1365004839-21982-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365004839-21982-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040403-2398-0000-0000-000012E6D1E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 03, 2013 at 06:00:34PM +0200, Anton Arapov wrote:
> Hijack the return address and replace it with a trampoline address.
> PowerPC implementation.
> 
> Signed-off-by: Anton Arapov <anton@redhat.com>

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

> ---
>  arch/powerpc/include/asm/uprobes.h |  1 +
>  arch/powerpc/kernel/uprobes.c      | 13 +++++++++++++
>  2 files changed, 14 insertions(+)
> 
> diff --git a/arch/powerpc/include/asm/uprobes.h b/arch/powerpc/include/asm/uprobes.h
> index b532060..2301602 100644
> --- a/arch/powerpc/include/asm/uprobes.h
> +++ b/arch/powerpc/include/asm/uprobes.h
> @@ -51,4 +51,5 @@ extern int  arch_uprobe_post_xol(struct arch_uprobe *aup, struct pt_regs *regs);
>  extern bool arch_uprobe_xol_was_trapped(struct task_struct *tsk);
>  extern int  arch_uprobe_exception_notify(struct notifier_block *self, unsigned long val, void *data);
>  extern void arch_uprobe_abort_xol(struct arch_uprobe *aup, struct pt_regs *regs);
> +extern unsigned long arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs);
>  #endif	/* _ASM_UPROBES_H */
> diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
> index bc77834..567b975 100644
> --- a/arch/powerpc/kernel/uprobes.c
> +++ b/arch/powerpc/kernel/uprobes.c
> @@ -188,3 +188,16 @@ bool arch_uprobe_skip_sstep(struct arch_uprobe *auprobe, struct pt_regs *regs)
> 
>  	return false;
>  }
> +
> +unsigned long
> +arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
> +{
> +	unsigned long orig_ret_vaddr;
> +
> +	orig_ret_vaddr = regs->link;
> +
> +	/* Replace the return addr with trampoline addr */
> +	regs->link = trampoline_vaddr;
> +
> +	return orig_ret_vaddr;
> +}
> -- 
> 1.8.1.4

