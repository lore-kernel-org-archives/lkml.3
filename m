Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756790Ab3B1UMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 15:12:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8510 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756417Ab3B1UMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 15:12:19 -0500
Date: Thu, 28 Feb 2013 21:10:24 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [RFC PATCH v3 4/6] uretprobes: return probe entry, prepare
	uretprobe
Message-ID: <20130228201024.GB9074@redhat.com>
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

This is called under down_read(), so 2 threads can race with each other
and use the different rp_trampoline_vaddr's if ->rp_trampoline_vaddr was
NULL.

And again, I think ->rp_trampoline_vaddr is simply unneeded, see my
reply to 3/6.

>  static void handler_chain(struct uprobe *uprobe, struct pt_regs *regs)
>  {
> +	int rc = 0;
>  	struct uprobe_consumer *uc;
>  	int remove = UPROBE_HANDLER_REMOVE;
>  
>  	down_read(&uprobe->register_rwsem);
>  	for (uc = uprobe->consumers; uc; uc = uc->next) {
> -		int rc = uc->handler(uc, regs);
> +		if (uc->handler)
> +			rc = uc->handler(uc, regs);
> +
> +		if (uc->rp_handler)
> +			prepare_uretprobe(uprobe, regs); /* put bp at return */

Hmm. I didn't read this series yet. But at first glance I am not
sure prepare_uretprobe() should be called every time we see
->rp_handler != NULL, there could be multiple consumers...

Oleg.

