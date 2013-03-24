Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab3CXOoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 10:44:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58709 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3CXOoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 10:44:13 -0400
Date: Sun, 24 Mar 2013 15:41:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Anton Arapov <anton@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 2/7] uretprobes: extract fill_page() and trampoline
	implementation
Message-ID: <20130324144144.GA17037@redhat.com>
References: <1363957745-6657-1-git-send-email-anton@redhat.com> <1363957745-6657-3-git-send-email-anton@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363957745-6657-3-git-send-email-anton@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22, Anton Arapov wrote:
>
> +static void fill_page(struct page *page, unsigned long offset, uprobe_opcode_t *insn)
                                                                  ^^^^^^^^^^^^^^^
Well, it should be "u8 *insn" or "char *".

xol_get_insn_slot() passes arch.insn, and this is not uprobe_opcode_t
in general (see arch/powerpc/include/asm/uprobes.h)

> +{
> +	void *vaddr;
> +
> +	vaddr = kmap_atomic(page);
> +	memcpy(vaddr + offset, insn, MAX_UINSN_BYTES);
                                     ^^^^^^^^^^^^^^^
OK, but see below...

> +	kunmap_atomic(vaddr);
> +
> +	/*
> +	 * We probably need flush_icache_user_range() but it needs vma.
> +	 * This should work on supported architectures too.
> +	 */
> +	flush_dcache_page(page);
> +}

Please do not move flush_dcache_page() from xol_get_insn_slot(),
this is not needed.

Unlike xol_get_insn_slot(), get_xol_area() calls fill_page() before
xol_add_vma().

>  static int xol_add_vma(struct xol_area *area)
>  {
> @@ -1122,6 +1137,7 @@ static struct xol_area *get_xol_area(void)
>  {
>  	struct mm_struct *mm = current->mm;
>  	struct xol_area *area;
> +	uprobe_opcode_t insn = UPROBE_SWBP_INSN;
>
>  	area = mm->uprobes_state.xol_area;
>  	if (area)
> @@ -1139,6 +1155,10 @@ static struct xol_area *get_xol_area(void)
>  	if (!area->page)
>  		goto free_bitmap;
>
> +	/* pre-allocate for return probes */
> +	set_bit(0, area->bitmap);
> +	fill_page(area->page, 0, &insn);

sizeof(insn) == UPROBE_SWBP_INSN_SIZE != MAX_UINSN_BYTES. See also the
comments above.

Oleg.

