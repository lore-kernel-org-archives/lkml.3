Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbaI1AoR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 20:44:17 -0400
Received: from mail-oi0-f48.google.com ([209.85.218.48]:48198 "EHLO
	mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaI1AoQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 20:44:16 -0400
MIME-Version: 1.0
In-Reply-To: <983713E2-1EBC-45CC-8212-20FBFAA9AC0B@arm.com>
References: <CAHkaATRAuo=Mh1tmMVDxnWeO8ARjW+KBfHNLpaFG3XxN5uY-hQ@mail.gmail.com>
	<983713E2-1EBC-45CC-8212-20FBFAA9AC0B@arm.com>
Date: Sun, 28 Sep 2014 08:44:15 +0800
Message-ID: <CAHkaATSUH=sKYJZ1NEM6-M8nCYPeqsU6v3JMBQbm_R=ykbkUjg@mail.gmail.com>
Subject: Re: [PATCH] Remove GFP_DMA and GFP_DMA32 from flags before passing it
 into kmalloc.
From: Miles MH Chen <orca.chen@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 11:13 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On 27 Sep 2014, at 16:09, Miles MH Chen <orca.chen@gmail.com> wrote:
>> Signed-off-by: Min-Hua Chen <orca.chen@gmail.com>
>> ---
>>  arch/arm64/mm/dma-mapping.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/mm/dma-mapping.c b/arch/arm64/mm/dma-mapping.c
>> index 4164c5a..273cf6d 100644
>> --- a/arch/arm64/mm/dma-mapping.c
>> +++ b/arch/arm64/mm/dma-mapping.c
>> @@ -103,7 +103,8 @@ static void *__dma_alloc_noncoherent(struct device *dev, size_t size,
>>      ptr = __dma_alloc_coherent(dev, size, dma_handle, flags, attrs);
>>      if (!ptr)
>>          goto no_mem;
>> -    map = kmalloc(sizeof(struct page *) << order, flags & ~GFP_DMA);
>> +    map = kmalloc(sizeof(struct page *) << order,
>> +                    flags & ~(GFP_DMA | GFP_DMA32));
>
> Do you have an explanation on why this is needed (and such explanation
> should also be included in the commit log)? We don’t use ZONE_DMA32 on
> arm64 (we did initially but it was for the wrong reasons).

If GFP_DMA32 is passed to dma_alloc_coherent, the flag will go to kmalloc and
trigger a BUG_ON check in slab allocator:

__dma_alloc_noncoherent
kmalloc
new_slab  BUG_ON(flags & GFP_SLAB_BUG_MASK);

It can be avoided this by removing GFP_DMA32 before passing it to kmalloc
or we should block GFP_DMA32 flag earlier in arch/arm64/dma-mapping.c if
GFP_DMA32 is not allowed in arch/arm64/dma-mapping.c.

Thanks,
MH

>
> Thanks,
>
> Catalin
