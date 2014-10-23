Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbaJWVJe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 17:09:34 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:48477 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073AbaJWVJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 17:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <20141023132233.b156cd79badc1254eff08494@linux-foundation.org>
References: <1413893696-25484-1-git-send-email-thierry.reding@gmail.com> <20141023132233.b156cd79badc1254eff08494@linux-foundation.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 23 Oct 2014 22:09:12 +0100
X-Google-Sender-Auth: eaioXotczQ1PFaGkm7cpdgi21-E
Message-ID: <CAHkRjk5KLR1390eiRdXcNmppVKWBgugutsuvhpesMwXYa6CRzA@mail.gmail.com>
Subject: Re: [PATCH] mm/cma: Make kmemleak ignore CMA regions
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 October 2014 21:22, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Tue, 21 Oct 2014 14:14:56 +0200 Thierry Reding <thierry.reding@gmail.com> wrote:
>
>> From: Thierry Reding <treding@nvidia.com>
>>
>> kmemleak will add allocations as objects to a pool. The memory allocated
>> for each object in this pool is periodically searched for pointers to
>> other allocated objects. This only works for memory that is mapped into
>> the kernel's virtual address space, which happens not to be the case for
>> most CMA regions.
>>
>> Furthermore, CMA regions are typically used to store data transferred to
>> or from a device and therefore don't contain pointers to other objects.
>>
>> Signed-off-by: Thierry Reding <treding@nvidia.com>
>> ---
>> Note: I'm not sure this is really the right fix. But without this, the
>> kernel crashes on the first execution of the scan_gray_list() because
>> it tries to access highmem. Perhaps a more appropriate fix would be to
>> reject any object that can't map to a kernel virtual address?
>
> Let's cc Catalin.
>
>> --- a/mm/cma.c
>> +++ b/mm/cma.c
>> @@ -280,6 +280,7 @@ int __init cma_declare_contiguous(phys_addr_t base,
>>                       ret = -ENOMEM;
>>                       goto err;
>>               } else {
>> +                     kmemleak_ignore(phys_to_virt(addr));
>>                       base = addr;
>>               }
>>       }

I wonder whether using __va() for the argument of kmemleak_alloc() in
memblock_alloc_range_nid() is always correct. Is
memblock.current_limit guaranteed to be in lowmem? If not, I think we
need some logic not to call kmemleak_alloc() for all memblock
allocations (and avoid the need to ignore them later).

> And let's tell our poor readers why we did stuff.  Something like this.
>
> --- a/mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions-fix
> +++ a/mm/cma.c
> @@ -280,6 +280,10 @@ int __init cma_declare_contiguous(phys_a
>                         ret = -ENOMEM;
>                         goto err;
>                 } else {
> +                       /*
> +                        * kmemleak writes metadata to the tracked objects, but
> +                        * this address isn't mapped and accessible.
> +                        */
>                         kmemleak_ignore(phys_to_virt(addr));
>                         base = addr;
>                 }

The reason is different, as per Therry's patch description. Kmemleak
does not write metadata to the tracked objects but reads them during
memory scanning. So maybe something like "kmemleak scans/reads tracked
objects for pointers to other objects but this address isn't mapped
and accessible."

A better API to use here would have been kmemleak_no_scan(), however,
I don't think we care about such CMA pointers anyway since they seem
to be tracked by physical address which kmemleak doesn't store.

-- 
Catalin
