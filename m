Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976AbaBSAXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 19:23:54 -0500
Received: from mail-ve0-f173.google.com ([209.85.128.173]:40231 "EHLO
	mail-ve0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005AbaBSAXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 19:23:52 -0500
MIME-Version: 1.0
In-Reply-To: <20140219000352.GP21483@n2100.arm.linux.org.uk>
References: <20140217234644.GA5171@rmk-PC.arm.linux.org.uk>
	<CA+55aFy7ApiQRudxPAd3v5k_apppxRnePHb1HZPH13erqhmX=g@mail.gmail.com>
	<20140219000352.GP21483@n2100.arm.linux.org.uk>
Date: Tue, 18 Feb 2014 16:23:51 -0800
X-Google-Sender-Auth: yTpTt7mTpJuaYbabsp8VenQnkRQ
Message-ID: <CA+55aFxZz9ubkj72KHy8PhpsjZb6D7LD+v6jHJTtsD4N6AWPzw@mail.gmail.com>
Subject: Re: [GIT PULL] ARM fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        James Bottomley <James.Bottomley@parallels.com>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, ARM SoC <arm@kernel.org>,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 4:03 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
>
> Almost, but not quite.  If we're going to avoid u64, then dma_addr_t
> woudl be the right type here because we're talking about DMA addresses.

Well, phys_addr_t had better be as big as dma_addr_t, because that's
what the resource management handles.

> We could also switch to keeping this as PFNs - block internally converts
> it to a PFN anyway:

Yeah, that definitely sounds like it would be a good idea.

> Maybe blk_queue_bounce_pfn_limit() so we ensure all users get caught?
>
>> That said, it's admittedly a disgusting name, and I wonder if we
>> should introduce a nicer-named "pfn_to_phys()" that matches the other
>> "xyz_to_abc()" functions we have (including "pfn_to_virt()")
>
> We have these on ARM:
>
> arch/arm/include/asm/memory.h:#define   __pfn_to_phys(pfn)      ((phys_addr_t)(pfn) << PAGE_SHIFT)
> arch/arm/include/asm/memory.h:#define   __phys_to_pfn(paddr)    ((unsigned long)((paddr) >> PAGE_SHIFT))
>
> it probably makes sense to pick those right out, maybe losing the
> __ prefix on them.

Yup.

>>   __va(PFN_PHYS(page_to_pfn(page)));
>
> Wow.  Two things spring to mind there... highmem pages, and don't we
> already have page_address() for that?

Well, that code clearly cannot handle highmem anyway, but yes, it
really smells like xen should use page_address().

Adding Xen people who I didn't add the last time around.

             Linus
