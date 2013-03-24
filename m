Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3CXP3U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 11:29:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752781Ab3CXP3T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 11:29:19 -0400
Date: Sun, 24 Mar 2013 16:26:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 4/7] uretprobes: return probe entry, prepare_uretprobe()
Message-ID: <20130324152651.GC17037@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
>  void uprobe_free_utask(struct task_struct *t)
>  {
>  	struct uprobe_task *utask = t->utask;
> +	struct return_instance *ri, *tmp;
>
>  	if (!utask)
>  		return;
> @@ -1325,6 +1334,15 @@ void uprobe_free_utask(struct task_struct *t)
>  	if (utask->active_uprobe)
>  		put_uprobe(utask->active_uprobe);
>
> +	ri = utask->return_instances;

You also need to nullify ->return_instances before return, otherwise
it can be use-after-freed later.

uprobe_free_utask() can also be called when the task execs.

> +	while (ri) {
> +		put_uprobe(ri->uprobe);
> +
> +		tmp = ri;
> +		ri = ri->next;
> +		kfree(tmp);
> +	}

This is really minor, but I can't resist. Both put_uprobe() and kfree()
work with the same object, it would be more clean to use the same var.
Say,

	while (ri) {
		tmp = ri;
		ri = ri->next;

		put_uprobe(tmp->uprobe);
		kfree(tmp);
	}

> +static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
> +{
...
> +
> +	prev_ret_vaddr = -1;
> +	if (utask->return_instances)
> +		prev_ret_vaddr = utask->return_instances->orig_ret_vaddr;
> +
> +	ri = kzalloc(sizeof(struct return_instance), GFP_KERNEL);
> +	if (!ri)
> +		return;
> +
> +	ri->dirty = false;
> +	trampoline_vaddr = get_trampoline_vaddr(area);
> +	ret_vaddr = arch_uretprobe_hijack_return_addr(trampoline_vaddr, regs);
> +
> +	/*
> +	 * We don't want to keep trampoline address in stack, rather keep the
> +	 * original return address of first caller thru all the consequent
> +	 * instances. This also makes breakpoint unwrapping easier.
> +	 */
> +	if (ret_vaddr == trampoline_vaddr) {
> +		if (likely(prev_ret_vaddr != -1)) {
> +			ri->dirty = true;
> +			ret_vaddr = prev_ret_vaddr;
> +		} else {
> +			/*
> +			 * This situation is not possible. Likely we have an
> +			 * attack from user-space. Die.
> +			 */
> +			printk(KERN_ERR "uprobe: something went wrong "
> +				"pid/tgid=%d/%d", current->pid, current->tgid);
> +			send_sig(SIGSEGV, current, 0);
> +			kfree(ri);
> +			return;
> +		}
> +	}
> +
> +	if (likely(ret_vaddr != -1)) {
> +		atomic_inc(&uprobe->ref);
> +		ri->uprobe = uprobe;
> +		ri->orig_ret_vaddr = ret_vaddr;
> +
> +		/* add instance to the stack */
> +		ri->next = utask->return_instances;
> +		utask->return_instances = ri;
> +
> +		return;
> +	}
> +
> +	kfree(ri);
> +}

Anton, this really doesn't look clear/clean. Why do you need prev_ret_vaddr
in advance? Why do you need it at all? why do you delay the "ret_vaddr == -1"
errorcheck?

And ->dirty looks confusing... perhaps ->chained ?

		ri = kzalloc(...);
		if (!ri)
			return;

		ret_vaddr = arch_uretprobe_hijack_return_addr(...);
		if (ret_vaddr == -1)
			goto err;

		if (ret_vaddr == trampoline_vaddr) {
			if (!utask->return_instances) {
				// This situation is not possible.
				// (not sure we should send SIGSEGV)
				pr_warn(...);
				goto err;
			}

			ri->chained = true;
			ret_vaddr = utask->return_instances->orig_ret_vaddr;
		}

		fill-ri-and-add-push-it;
		return;

	err:
		kfree(ri);
		return;

Oleg.

