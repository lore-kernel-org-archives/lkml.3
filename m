Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaCKTrC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:47:02 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44643 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754711AbaCKTrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:47:00 -0400
Date: Tue, 11 Mar 2014 12:46:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <xen-devel@lists.xenproject.org>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Subject: Re: [PATCHv2] mm/vmalloc: avoid soft lockup warnings when
 vunmap()'ing large ranges
Message-Id: <20140311124659.9565a5cc86ade7084eabe24d@linux-foundation.org>
In-Reply-To: <1394563223-5045-1-git-send-email-david.vrabel@citrix.com>
References: <1394563223-5045-1-git-send-email-david.vrabel@citrix.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Mar 2014 18:40:23 +0000 David Vrabel <david.vrabel@citrix.com> wrote:

> If vunmap() is used to unmap a large (e.g., 50 GB) region, it may take
> sufficiently long that it triggers soft lockup warnings.
> 
> Add a cond_resched() into vunmap_pmd_range() so the calling task may
> be resheduled after unmapping each PMD entry.  This is how
> zap_pmd_range() fixes the same problem for userspace mappings.
> 
> All callers may sleep except for the APEI GHES driver (apei/ghes.c)
> which calls unmap_kernel_range_no_flush() from NMI and IRQ contexts.
> This driver only unmaps a single pages so don't call cond_resched() if
> the unmap doesn't cross a PMD boundary.
> 
> Reported-by: Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
> v2: don't call cond_resched() at the end of a PMD range.
> ---
>  mm/vmalloc.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 0fdf968..1a8b162 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -75,6 +75,8 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end)
>  		if (pmd_none_or_clear_bad(pmd))
>  			continue;
>  		vunmap_pte_range(pmd, addr, next);
> +		if (next != end)
> +			cond_resched();
>  	} while (pmd++, addr = next, addr != end);
>  }

Worried.  This adds a schedule into a previously atomic function.  Are
there any callers which call into here from interrupt or with a lock
held, etc?

I started doing an audit, got to
mvebu_hwcc_dma_ops.free->__dma_free_remap->unmap_kernel_range->vunmap_page_range
and gave up - there's just too much.

The best I can suggest is to do

--- a/mm/vmalloc.c~mm-vmalloc-avoid-soft-lockup-warnings-when-vunmaping-large-ranges-fix
+++ a/mm/vmalloc.c
@@ -71,6 +71,8 @@ static void vunmap_pmd_range(pud_t *pud,
 	pmd_t *pmd;
 	unsigned long next;
 
+	might_sleep();
+
 	pmd = pmd_offset(pud, addr);
 	do {
 		next = pmd_addr_end(addr, end);

so we at least find out about bugs promptly, but that's a pretty lame
approach.

Who the heck is mapping 50GB?
