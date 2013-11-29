Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab3K2Sfa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Nov 2013 13:35:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59694 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab3K2SfY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Nov 2013 13:35:24 -0500
Date: Fri, 29 Nov 2013 19:35:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        x86@kernel.org, Andi Kleen <ak@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] Add a text_poke syscall v2
Message-ID: <20131129183558.GA9803@redhat.com>
References: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385426236-14960-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25, Andi Kleen wrote:
>
> +	err = get_user_pages_fast((unsigned long)addr, npages, 1, pages);
> +	if (err < 0)
> +		return err;
> +	if (err != npages) {
> +		err = -EFAULT;
> +		goto out;
> +	}
> +	err = 0;
> +	mutex_lock(&text_mutex);
> +	bp_target_mm = current->mm;
> +	bp_int3_addr = (u8 *)addr + 1;
> +	__text_poke_bp(pages,
> +		       (unsigned long)addr & ~PAGE_MASK,
> +		       insn, len, handler);

We are going to change this user page, it seems that we need
set_page_dirty() ?

Andi, et al. I am going to discuss the things I do not really
understand, probably this can't make any sense, but...

I am wondering if sys_text_poke() can do something like

	down_write(mmap_sem);

	get_user_pages(write, page, vma);

	ptep = page_check_address(...);

	pte = ptep_clear_flush(ptep);

	copy-opcode-to-page;

	pte = pte_mkdirty(pte);
	set_pte_at(ptep, pte);

	pte_unmap_unlock(...);
	up_write(mmap_sem);

?

Oleg.

