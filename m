Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3CBS2d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 13:28:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23084 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268Ab3CBS2c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 13:28:32 -0500
Date: Sat, 2 Mar 2013 19:26:43 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v3 4/6] uretprobes: return probe entry, prepare
	uretprobe
Message-ID: <20130302182643.GA1075@redhat.com>
References: <1362049215-5780-1-git-send-email-anton@redhat.com> <1362049215-5780-5-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362049215-5780-5-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Anton Arapov wrote:
>
> +static void prepare_uretprobe(struct uprobe *uprobe, struct pt_regs *regs)
> +{
> +	struct return_uprobe_i *ri;
> +	struct uprobe_task *utask;
> +	struct xol_area *area;
> +	unsigned long rp_trampoline_vaddr = 0;
> +	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
> +
> +	area = get_xol_area();
> +	if (area)
> +		rp_trampoline_vaddr = area->rp_trampoline_vaddr;
> +	if (!rp_trampoline_vaddr) {
> +		rp_trampoline_vaddr = xol_get_insn_slot(&insn);
> +		if (!rp_trampoline_vaddr)
> +			return;
> +	}
> +	area->rp_trampoline_vaddr = rp_trampoline_vaddr;
> +
> +	ri = kzalloc(sizeof(struct return_uprobe_i), GFP_KERNEL);
> +	if (!ri)
> +		return;
> +
> +	utask = get_utask();
> +	ri->orig_ret_vaddr = arch_uretprobe_hijack_return_addr(rp_trampoline_vaddr, regs);
> +	if (likely(ri->orig_ret_vaddr)) {
> +		/* TODO: uretprobe bypass logic */
> +		atomic_inc(&uprobe->ref);

OK, but even this is not enough.

Once we inserted "int3" we must ensure that handle_swbp() will be
called even if this uprobe goes away. We have the reference but it
only protects uprobe itself, it can't protect agains delete_uprobe().

IOW, we must ensure that uprobe_pre_sstep_notifier() can't return 0.

So this patch needs the additional change in find_active_uprobe(),

	-	if (!uprobe && test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))
	+	if (!uprobe && hlist_empty(->return_uprobes) &&
	+	    test_and_clear_bit(MMF_RECALC_UPROBES, &mm->flags))

Oleg.

