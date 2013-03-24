Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab3CXPCJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:02:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab3CXPCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:02:07 -0400
Date: Sun, 24 Mar 2013 15:59:42 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 3/7] uretprobes/x86: hijack return address
Message-ID: <20130324145942.GB17037@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-4-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-4-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
> +arch_uretprobe_hijack_return_addr(unsigned long trampoline_vaddr, struct pt_regs *regs)
> +{
> +	int rasize, ncopied;
> +	unsigned long orig_ret_vaddr = 0; /* clear high bits for 32-bit apps */
> +
> +	rasize = is_ia32_task() ? 4 : 8;

Hmm.. I guess you need is_compat_task() here.

> +	ncopied = copy_from_user(&orig_ret_vaddr, (void __user *)regs->sp, rasize);
> +	if (unlikely(ncopied))
> +		return -1;
> +
> +	/* check whether address has been already hijacked */
> +	if (orig_ret_vaddr == trampoline_vaddr)
> +		return orig_ret_vaddr;
> +
> +	ncopied = copy_to_user((void __user *)regs->sp, &trampoline_vaddr, rasize);
> +	if (unlikely(ncopied)) {
> +		if (ncopied != rasize) {
> +			printk(KERN_ERR "uprobe: return address clobbered: "

Cosmetic, but we have pr_err().

> +					"pid=%d, %%sp=%#lx, %%ip=%#lx\n",
> +					current->pid, regs->sp, regs->ip);
> +			/* kill task immediately */
> +			send_sig(SIGSEGV, current, 0);

probably force_sig_info() makes more sense, but this is minor

> +		}

You need to retun -1 here.

Cosmetic again, but since this function should be updated anyway,
I'd suggest

	ncopied = copy_to_user(...);

	if (likely(!ncopied))
		return orig_ret_vaddr;

	if (ncopied != rasize) {
		...
	}

	return -1;

Oleg.

