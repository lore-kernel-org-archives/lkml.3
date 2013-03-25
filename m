Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756887Ab3CYKbr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:31:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20349 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab3CYKbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:31:45 -0400
Date: Mon, 25 Mar 2013 11:31:26 +0100
From: Anton Arapov <anton@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>, Josh Stone <jistone@redhat.com>,
        Frank Eigler <fche@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 4/5] uprobes: Introduce copy_to_page()
Message-ID: <20130325103126.GE8163@bandura.brq.redhat.com>
References: <20130324182040.GA13078@redhat.com>
 <20130324182122.GA13318@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130324182122.GA13318@redhat.com>
X-PGP-Key: http://people.redhat.com/aarapov/gpg
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 24, 2013 at 07:21:22PM +0100, Oleg Nesterov wrote:
> Extract the kmap_atomic/memcpy/kunmap_atomic code from
> xol_get_insn_slot() into the new simple helper, copy_to_page().
> It will have more users soon.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---
>  kernel/events/uprobes.c |   14 ++++++++------
>  1 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index e5d479f..9d943f7 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -180,6 +180,13 @@ static void copy_from_page(struct page *page, unsigned long vaddr, void *dst, in
>  	kunmap_atomic(kaddr);
>  }
>  
> +static void copy_to_page(struct page *page, unsigned long vaddr, const void *src, int len)
> +{
> +	void *kaddr = kmap_atomic(page);
> +	memcpy(kaddr + (vaddr & ~PAGE_MASK), src, len);
> +	kunmap_atomic(kaddr);
> +}
> +
>  static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *new_opcode)
>  {
>  	uprobe_opcode_t old_opcode;
> @@ -1204,9 +1211,7 @@ static unsigned long xol_take_insn_slot(struct xol_area *area)
>  static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
>  {
>  	struct xol_area *area;
> -	unsigned long offset;
>  	unsigned long xol_vaddr;
> -	void *vaddr;
>  
>  	area = get_xol_area();
>  	if (!area)
> @@ -1217,10 +1222,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe)
>  		return 0;
>  
>  	/* Initialize the slot */
> -	offset = xol_vaddr & ~PAGE_MASK;
> -	vaddr = kmap_atomic(area->page);
> -	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
> -	kunmap_atomic(vaddr);
> +	copy_to_page(area->page, xol_vaddr, uprobe->arch.insn, MAX_UINSN_BYTES);
>  	/*
>  	 * We probably need flush_icache_user_range() but it needs vma.
>  	 * This should work on supported architectures too.
> -- 
> 1.5.5.1
> 

Acked-by: Anton Arapov <anton@redhat.com>
