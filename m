Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933363Ab3DGKxa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 06:53:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:51753 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345Ab3DGKx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 06:53:29 -0400
Date: Sun, 7 Apr 2013 16:23:08 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Anton Arapov <anton@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH v1 6/9] uretprobes: Return probe exit, invoke handlers
Message-ID: <20130407105308.GA2899@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <1365004839-21982-1-git-send-email-anton@redhat.com>
 <1365004839-21982-7-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1365004839-21982-7-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13040710-4834-0000-0000-00000587A252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Anton Arapov <anton@redhat.com> [2013-04-03 18:00:36]:

> Uretprobe handlers are invoked when the trampoline is hit, on completion the
> trampoline is replaced with the saved return address and the uretprobe instance
> deleted.
> 
> v1 changes:
> * pass bp_vaddr to ret_handler()
> * simplify handle_uretprobe()
> 
> RFCv6 changes:
> * rework handle_uretprobe()
> 
> RFCv5 changes:
> * switch to simply linked list ->return_uprobes
> * rework handle_uretprobe()
> 
> RFCv4 changes:
> * check, whether utask is not NULL in handle_uretprobe()
> * get rid of area->rp_trampoline_vaddr
> * minor handle_uretprobe() fixups
> 
> RFCv3 changes:
> * protected uprobe with refcounter. See put_uprobe() in handle_uretprobe()
>   that reflects increment in prepare_uretprobe()
> 
> RFCv2 changes:
> * get rid of ->return_consumers member from struct uprobe, introduce
>   ret_handler() in consumer instead
> 
> Signed-off-by: Anton Arapov <anton@redhat.com>
> ---
>  kernel/events/uprobes.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 59 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 08ecfff..d129c1d 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -1609,6 +1609,57 @@ static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
>  	up_read(&uprobe->register_rwsem);
>  }
> 
> +static void
> +handler_uretprobe_chain(struct return_instance *ri, struct pt_regs *regs)

> +{
> +	struct uprobe *uprobe = ri->uprobe;
> +	struct uprobe_consumer *uc;
> +
> +	down_read(&uprobe->register_rwsem);
> +	for (uc = uprobe->consumers; uc; uc = uc->next) {
> +		if (uc->ret_handler)
> +			uc->ret_handler(uc, ri->func, regs);
> +	}
> +	up_read(&uprobe->register_rwsem);
> +}
> +
> +static bool handler_uretprobe(struct pt_regs *regs)

Nit: can this be renamed to handle_trampoline

> +{
> +	struct uprobe_task *utask;
> +	struct return_instance *ri, *tmp;
> +	bool chained;
> +
> +	utask = current->utask;
> +	if (!utask)
> +		return false;
> +
> +	ri = utask->return_instances;
> +	if (!ri)
> +		return false;
> +
> +	instruction_pointer_set(regs, ri->orig_ret_vaddr);

Should we a check here before using top most ri.
What if the application had done a longjmp and the trampoline he hit
corresponds to something thats below in the stack?

Not sure if this what you meant by leaking return instances in your next
patch.


> +
> +	for (;;) {
> +		handler_uretprobe_chain(ri, regs);
> +
> +		chained = ri->chained;
> +		put_uprobe(ri->uprobe);
> +
> +		tmp = ri;
> +		ri = ri->next;
> +		kfree(tmp);
> +
> +		if (!chained)
> +			break;
> +
> +		BUG_ON(!ri);
> +	}
> +
> +	utask->return_instances = ri;
> +
> +	return true;
> +}
> +
>  /*
>   * Run handler and ask thread to singlestep.
>   * Ensure all non-fatal signals cannot interrupt thread while it singlesteps.
> @@ -1620,8 +1671,15 @@ static void handle_swbp(struct pt_regs *regs)
>  	int uninitialized_var(is_swbp);
> 
>  	bp_vaddr = uprobe_get_swbp_addr(regs);
> -	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
> +	if (bp_vaddr == get_trampoline_vaddr()) {
> +		if (handler_uretprobe(regs))
> +			return;
> 
> +		pr_warn("uprobe: unable to handle uretprobe pid/tgid=%d/%d\n",
> +						current->pid, current->tgid);
> +	}
> +
> +	uprobe = find_active_uprobe(bp_vaddr, &is_swbp);
>  	if (!uprobe) {
>  		if (is_swbp > 0) {
>  			/* No matching uprobe; signal SIGTRAP. */
> -- 
> 1.8.1.4
> 

