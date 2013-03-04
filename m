Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab3CDQuA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 11:50:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757003Ab3CDQt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 11:49:58 -0500
Date: Mon, 4 Mar 2013 17:47:53 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v4 4/6] uretprobes: return probe entry, prepare
	uretprobe
Message-ID: <20130304164753.GA3328@redhat.com>
References: <1362407893-32505-1-git-send-email-anton@redhat.com> <1362407893-32505-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362407893-32505-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Anton Arapov wrote:
>
> @@ -1085,6 +1093,7 @@ static int xol_add_vma(struct xol_area *area)
>  {
>  	struct mm_struct *mm = current->mm;
>  	int ret = -EALREADY;
> +	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
>
>  	down_write(&mm->mmap_sem);
>  	if (mm->uprobes_state.xol_area)
> @@ -1106,6 +1115,13 @@ static int xol_add_vma(struct xol_area *area)
>  	smp_wmb();	/* pairs with get_xol_area() */
>  	mm->uprobes_state.xol_area = area;
>  	ret = 0;
> +
> +	/*
> +	 * If we reached this place, we did allocate a new area. We want
> +	 * pre-alloc a slot for the return probes here.
> +	 */
> +	xol_get_insn_slot(&insn);

Just change get_xol_area() to do set_bit(0, bitmap) and copy_to_page(page, int3)
(extacted from xol_get_insn_slot().

> @@ -1485,8 +1538,11 @@ static struct uprobe *find_active_uprobe(unsigned long bp_vaddr, int *is_swbp)
>  		*is_swbp = -EFAULT;
>  	}
>  
> -	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
> +	utask = get_utask();
> +	if (!uprobe && hlist_empty(&utask->return_uprobes) &&
> +	    test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags)) {
>  		mmf_recalc_uprobes(mm);

Wait, I was wrong. We should not clear MMF_* if another thread has
->return_uprobes. Perhaps we should change uprobe_pre_sstep_notifier()
instead...

>  	down_read(&uprobe->register_rwsem);
>  	for (uc = uprobe->consumers; uc; uc = uc->next) {
> -		int rc = uc->handler(uc, regs);
> +		if (uc->handler)
> +			rc = uc->handler(uc, regs);
> +
> +		if (uc->rp_handler)
> +			prepare_uretprobe(uprobe, regs); /* put bp at return */

Again, this is not right. We should do this only once after the main
loop.

Oleg.

