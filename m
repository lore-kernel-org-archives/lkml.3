Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbaJWUWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 16:22:34 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45994 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaJWUWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 16:22:32 -0400
Date: Thu, 23 Oct 2014 13:22:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] mm/cma: Make kmemleak ignore CMA regions
Message-Id: <20141023132233.b156cd79badc1254eff08494@linux-foundation.org>
In-Reply-To: <1413893696-25484-1-git-send-email-thierry.reding@gmail.com>
References: <1413893696-25484-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 14:14:56 +0200 Thierry Reding <thierry.reding@gmail.com> wrote:

> From: Thierry Reding <treding@nvidia.com>
> 
> kmemleak will add allocations as objects to a pool. The memory allocated
> for each object in this pool is periodically searched for pointers to
> other allocated objects. This only works for memory that is mapped into
> the kernel's virtual address space, which happens not to be the case for
> most CMA regions.
> 
> Furthermore, CMA regions are typically used to store data transferred to
> or from a device and therefore don't contain pointers to other objects.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
> Note: I'm not sure this is really the right fix. But without this, the
> kernel crashes on the first execution of the scan_gray_list() because
> it tries to access highmem. Perhaps a more appropriate fix would be to
> reject any object that can't map to a kernel virtual address?

Let's cc Catalin.

> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -280,6 +280,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>  			ret = -ENOMEM;
>  			goto err;
>  		} else {
> +			kmemleak_ignore(phys_to_virt(addr));
>  			base = addr;
>  		}
>  	}

And let's tell our poor readers why we did stuff.  Something like this.

--- a/mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions-fix
+++ a/mm/cma.c
@@ -280,6 +280,10 @@ int __init cma_declare_contiguous(phys_a
 			ret = -ENOMEM;
 			goto err;
 		} else {
+			/*
+			 * kmemleak writes metadata to the tracked objects, but
+			 * this address isn't mapped and accessible.
+			 */
 			kmemleak_ignore(phys_to_virt(addr));
 			base = addr;
 		}
_

