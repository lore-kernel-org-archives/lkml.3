Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759552Ab3CZMFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:05:17 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49933 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3CZMFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:05:15 -0400
Date: Tue, 26 Mar 2013 17:29:54 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 1/5] uprobes: Turn copy_opcode() into copy_from_page()
Message-ID: <20130326115954.GC639@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130324182040.GA13078@redhat.com>
 <20130324182110.GA13301@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130324182110.GA13301@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032612-3620-0000-0000-000001C5CA03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-03-24 19:21:10]:

> No functional changes. Rename copy_opcode() into copy_from_page() and
> add the new "int len" argument to make it more more generic for the
> new users.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 5c273b3..d6891cb 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -173,10 +173,10 @@ bool __weak is_swbp_insn(uprobe_opcode_t *insn)
>  	return *insn == UPROBE_SWBP_INSN;
>  }
> 
> -static void copy_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t *opcode)
> +static void copy_from_page(struct page *page, unsigned long vaddr, void *dst, int len)
>  {
>  	void *kaddr = kmap_atomic(page);
> -	memcpy(opcode, kaddr + (vaddr & ~PAGE_MASK), UPROBE_SWBP_INSN_SIZE);
> +	memcpy(dst, kaddr + (vaddr & ~PAGE_MASK), len);
>  	kunmap_atomic(kaddr);
>  }
> 
> @@ -185,7 +185,7 @@ static int verify_opcode(struct page *page, unsigned long vaddr, uprobe_opcode_t
>  	uprobe_opcode_t old_opcode;
>  	bool is_swbp;
> 
> -	copy_opcode(page, vaddr, &old_opcode);
> +	copy_from_page(page, vaddr, &old_opcode, UPROBE_SWBP_INSN_SIZE);
>  	is_swbp = is_swbp_insn(&old_opcode);
> 
>  	if (is_swbp_insn(new_opcode)) {
> @@ -1449,7 +1449,7 @@ static int is_swbp_at_addr(struct mm_struct *mm, unsigned long vaddr)
>  	if (result < 0)
>  		return result;
> 
> -	copy_opcode(page, vaddr, &opcode);
> +	copy_from_page(page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
>  	put_page(page);
>   out:
>  	return is_swbp_insn(&opcode);
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

