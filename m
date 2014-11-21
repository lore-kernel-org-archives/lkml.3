Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbaKUF24 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 00:28:56 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:38132 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaKUF2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 00:28:55 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Mel Gorman <mgorman@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Linux-MM <linux-mm@kvack.org>,
        LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        Hugh Dickins <hughd@google.com>, Dave Jones <davej@redhat.com>,
        Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Kirill Shutemov <kirill.shutemov@linux.intel.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: [PATCH 03/10] mm: Convert p[te|md]_numa users to p[te|md]_protnone_numa
In-Reply-To: <1416478790-27522-4-git-send-email-mgorman@suse.de>
References: <1416478790-27522-1-git-send-email-mgorman@suse.de> <1416478790-27522-4-git-send-email-mgorman@suse.de>
User-Agent: Notmuch/0.18.2+162~g34d2c62 (http://notmuchmail.org) Emacs/25.0.50.1 (x86_64-pc-linux-gnu)
Date: Fri, 21 Nov 2014 10:58:34 +0530
Message-ID: <87lhn56s1p.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14112105-0025-0000-0000-0000008D1A3E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mel Gorman <mgorman@suse.de> writes:

> Convert existing users of pte_numa and friends to the new helper. Note
> that the kernel is broken after this patch is applied until the other
> page table modifiers are also altered. This patch layout is to make
> review easier.
>

.....

> diff --git a/arch/powerpc/mm/pgtable.c b/arch/powerpc/mm/pgtable.c
> index c90e602..b5d58d3 100644
> --- a/arch/powerpc/mm/pgtable.c
> +++ b/arch/powerpc/mm/pgtable.c
> @@ -173,7 +173,13 @@ void set_pte_at(struct mm_struct *mm, unsigned long addr, pte_t *ptep,
>  		pte_t pte)
>  {
>  #ifdef CONFIG_DEBUG_VM
> -	WARN_ON(pte_val(*ptep) & _PAGE_PRESENT);
> +	/*
> +	 * When handling numa faults, we already have the pte marked
> +	 * _PAGE_PRESENT, but we can be sure that it is not in hpte.
> +	 * Hence we can use set_pte_at for them.
> +	 */
> +	WARN_ON((pte_val(*ptep) & (_PAGE_PRESENT | _PAGE_USER)) ==
> +		(_PAGE_PRESENT | _PAGE_USER));
>  #endif


This can be VM_WARN_ON with #ifdef removed.

>  	/* Note: mm->context.id might not yet have been assigned as
>  	 * this context might not have been activated yet when this
> diff --git a/arch/powerpc/mm/pgtable_64.c b/arch/powerpc/mm/pgtable_64.c

-aneesh

