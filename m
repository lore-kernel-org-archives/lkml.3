Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab3LKVjU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 16:39:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49779 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab3LKVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 16:39:19 -0500
Date: Wed, 11 Dec 2013 13:39:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        <linux-acpi@vger.kernel.org>,
        xen-devel <xen-devel@lists.xenproject.org>,
        Dietmar Hahn <dietmar.hahn@ts.fujitsu.com>
Subject: Re: vunmap() on large regions may trigger soft lockup warnings
Message-Id: <20131211133917.dd10cb2c4360dba65d8e6ce2@linux-foundation.org>
In-Reply-To: <52A899AB.3010506@citrix.com>
References: <52A899AB.3010506@citrix.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Dec 2013 16:58:19 +0000 David Vrabel <david.vrabel@citrix.com> wrote:

> Andrew,
> 
> Dietmar Hahn reported an issue where calling vunmap() on a large (50 GB)
> region would trigger soft lockup warnings.
> 
> The following patch would resolve this (by adding a cond_resched() call
> to vunmap_pmd_range()). Almost calls of vunmap(), unmap_kernel_range()
> are from process context (as far as I could tell) except for an ACPI
> driver (drivers/acpi/apei/ghes.c) calls unmap_kernel_range_noflush()
> from an interrupt and NMI contexts.
> 
> Can you advise on a preferred solution?
> 
> For example, an unmap_kernel_page() function (callable from atomic
> context) could be provided since the GHES driver only maps/unmaps a
> single page.
> 
> 8<-------------------------
> mm/vmalloc: avoid soft lockup warnings when vunmap()'ing large ranges
> 
> From: David Vrabel <david.vrabel@citrix.com>
> 
> If vunmap() is used to unmap a large (e.g., 50 GB) region, it may take
> sufficiently long that it triggers soft lockup warnings.
> 
> Add a cond_resched() into vunmap_pmd_range() so the calling task may
> be resheduled after unmapping each PMD entry.  This is how
> zap_pmd_range() fixes the same problem for userspace mappings.
> 
> ...
>
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -75,6 +75,7 @@ static void vunmap_pmd_range(pud_t *pud, unsigned long
> addr, unsigned long end)
>  		if (pmd_none_or_clear_bad(pmd))
>  			continue;
>  		vunmap_pte_range(pmd, addr, next);
> +		cond_resched();
>  	} while (pmd++, addr = next, addr != end);
>  }

Well that's ugly.

We could redo unmap_kernel_range() so it takes an `atomic' flag then
loops around unmapping N MB at a time, doing

	if (!atomic)
		cond_resched()

each time.  But that would require difficult tuning of N.

I suppose we could just do

	if (!in_interrupt())
		cond_resched();

in vunmap_pmd_range(), but that's pretty specific to ghes.c and doesn't
permit unmap-inside-spinlock.

So I can't immediately think of a suitable fix apart from adding a new
unmap_kernel_range_atomic().  Then add a `bool atomic' arg to
vunmap_page_range() and pass that all the way down.



