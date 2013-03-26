Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab3CZMEs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 08:04:48 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:49824 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757082Ab3CZMEr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 08:04:47 -0400
Date: Tue, 26 Mar 2013 17:29:35 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Anton Arapov <anton@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Stone <jistone@redhat.com>, Frank Eigler <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        adrian.m.negreanu@intel.com, Torsten.Polle@gmx.de
Subject: Re: [PATCH 5/5] uprobes: Change write_opcode() to use copy_*page()
Message-ID: <20130326115935.GB639@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20130324182040.GA13078@redhat.com>
 <20130324182125.GA13327@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130324182125.GA13327@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13032612-3620-0000-0000-000001C5C9BD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2013-03-24 19:21:25]:

> Change write_opcode() to use copy_highpage() + copy_to_page()
> and simplify the code.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>


Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

> ---
>  kernel/events/uprobes.c |   12 ++----------
>  1 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> index 9d943f7..72f03d4 100644
> --- a/kernel/events/uprobes.c
> +++ b/kernel/events/uprobes.c
> @@ -232,7 +232,6 @@ static int write_opcode(struct mm_struct *mm, unsigned long vaddr,
>  			uprobe_opcode_t opcode)
>  {
>  	struct page *old_page, *new_page;
> -	void *vaddr_old, *vaddr_new;
>  	struct vm_area_struct *vma;
>  	int ret;
> 
> @@ -253,15 +252,8 @@ retry:
> 
>  	__SetPageUptodate(new_page);
> 
> -	/* copy the page now that we've got it stable */
> -	vaddr_old = kmap_atomic(old_page);
> -	vaddr_new = kmap_atomic(new_page);
> -
> -	memcpy(vaddr_new, vaddr_old, PAGE_SIZE);
> -	memcpy(vaddr_new + (vaddr & ~PAGE_MASK), &opcode, UPROBE_SWBP_INSN_SIZE);
> -
> -	kunmap_atomic(vaddr_new);
> -	kunmap_atomic(vaddr_old);
> +	copy_highpage(new_page, old_page);
> +	copy_to_page(new_page, vaddr, &opcode, UPROBE_SWBP_INSN_SIZE);
> 
>  	ret = anon_vma_prepare(vma);
>  	if (ret)
> -- 
> 1.5.5.1
> 

-- 
Thanks and Regards
Srikar Dronamraju

