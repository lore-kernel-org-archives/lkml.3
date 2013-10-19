Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3JSQnm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Oct 2013 12:43:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab3JSQnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Oct 2013 12:43:41 -0400
Date: Sat, 19 Oct 2013 18:36:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Long <dave.long@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Rabin Vincent <rabin@rab.in>,
        "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/13] uprobes: allow arch access to xol slot
Message-ID: <20131019163627.GA7837@redhat.com>
References: <1381871068-27660-1-git-send-email-dave.long@linaro.org> <1381871068-27660-4-git-send-email-dave.long@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381871068-27660-4-git-send-email-dave.long@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15, David Long wrote:
>
> Allow arches to customize how the instruction is filled into the xol
> slot.  ARM will use this to insert an undefined instruction after the
> real instruction in order to simulate a single step of the instruction
> without hardware support.

OK, but

> +void __weak arch_uprobe_xol_copy(struct arch_uprobe *auprobe, void *vaddr)
> +{
> +	memcpy(vaddr, auprobe->insn, MAX_UINSN_BYTES);
> +}
> +
>  /*
>   * xol_get_insn_slot - allocate a slot for xol.
>   * Returns the allocated slot address or 0.
> @@ -1246,6 +1251,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
>  {
>  	struct xol_area *area;
>  	unsigned long xol_vaddr;
> +	void *kaddr;
>  
>  	area = get_xol_area();
>  	if (!area)
> @@ -1256,7 +1262,9 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
>  		return 0;
>  
>  	/* Initialize the slot */
> -	copy_to_page(area->page, xol_vaddr, uprobe->arch.insn, MAX_UINSN_BYTES);
> +	kaddr = kmap_atomic(area->page);
> +	arch_uprobe_xol_copy(&uprobe->arch, kaddr + (xol_vaddr & ~PAGE_MASK));
> +	kunmap_atomic(kaddr);

This looks a bit strange and defeats the purpose of generic helper...

How about

	void __weak arch_uprobe_xol_copy(...)
	{
		copy_to_page(...);
	}

then just

	- copy_to_page(...);
	+ arch_uprobe_xol_copy(...);

?

Or, I am just curious, can't we have an empty "__weak arch_uprobe_xol_copy" if
we call it right after copy_to_page() ?

Oleg.

