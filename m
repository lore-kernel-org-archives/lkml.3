Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932702AbaFLHZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:25:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:45686 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S932161AbaFLHZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:25:19 -0400
X-IronPort-AV: E=Sophos;i="5.00,694,1396972800"; 
   d="scan'208";a="31801467"
Message-ID: <539955E5.9070504@cn.fujitsu.com>
Date: Thu, 12 Jun 2014 15:25:25 +0800
From: Zhang Yanfei <zhangyanfei@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131030 Thunderbird/17.0.10
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        <kvm@vger.kernel.org>, <linux-mm@kvack.org>,
        Gleb Natapov <gleb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <agraf@suse.de>, <kvm-ppc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paolo Bonzini <pbonzini@redhat.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 05/10] DMA, CMA: support arbitrary bitmap granularity
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com> <1402543307-29800-6-git-send-email-iamjoonsoo.kim@lge.com> <20140612070811.GI12415@bbox>
In-Reply-To: <20140612070811.GI12415@bbox>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.225.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2014 03:08 PM, Minchan Kim wrote:
> On Thu, Jun 12, 2014 at 12:21:42PM +0900, Joonsoo Kim wrote:
>> ppc kvm's cma region management requires arbitrary bitmap granularity,
>> since they want to reserve very large memory and manage this region
>> with bitmap that one bit for several pages to reduce management overheads.
>> So support arbitrary bitmap granularity for following generalization.
>>
>> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Acked-by: Minchan Kim <minchan@kernel.org>
> 
> Just a nit below.
> 
>>
>> diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
>> index bc4c171..9bc9340 100644
>> --- a/drivers/base/dma-contiguous.c
>> +++ b/drivers/base/dma-contiguous.c
>> @@ -38,6 +38,7 @@ struct cma {
>>  	unsigned long	base_pfn;
>>  	unsigned long	count;
>>  	unsigned long	*bitmap;
>> +	int order_per_bit; /* Order of pages represented by one bit */
>>  	struct mutex	lock;
>>  };
>>  
>> @@ -157,9 +158,38 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
>>  
>>  static DEFINE_MUTEX(cma_mutex);
>>  
>> +static unsigned long cma_bitmap_aligned_mask(struct cma *cma, int align_order)
>> +{
>> +	return (1 << (align_order >> cma->order_per_bit)) - 1;
>> +}
>> +
>> +static unsigned long cma_bitmap_maxno(struct cma *cma)
>> +{
>> +	return cma->count >> cma->order_per_bit;
>> +}
>> +
>> +static unsigned long cma_bitmap_pages_to_bits(struct cma *cma,
>> +						unsigned long pages)
>> +{
>> +	return ALIGN(pages, 1 << cma->order_per_bit) >> cma->order_per_bit;
>> +}
>> +
>> +static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
>> +{
>> +	unsigned long bitmapno, nr_bits;
>> +
>> +	bitmapno = (pfn - cma->base_pfn) >> cma->order_per_bit;
>> +	nr_bits = cma_bitmap_pages_to_bits(cma, count);
>> +
>> +	mutex_lock(&cma->lock);
>> +	bitmap_clear(cma->bitmap, bitmapno, nr_bits);
>> +	mutex_unlock(&cma->lock);
>> +}
>> +
>>  static int __init cma_activate_area(struct cma *cma)
>>  {
>> -	int bitmap_size = BITS_TO_LONGS(cma->count) * sizeof(long);
>> +	int bitmap_maxno = cma_bitmap_maxno(cma);
>> +	int bitmap_size = BITS_TO_LONGS(bitmap_maxno) * sizeof(long);
>>  	unsigned long base_pfn = cma->base_pfn, pfn = base_pfn;
>>  	unsigned i = cma->count >> pageblock_order;
>>  	struct zone *zone;
>> @@ -221,6 +251,7 @@ core_initcall(cma_init_reserved_areas);
>>   * @base: Base address of the reserved area optional, use 0 for any
>>   * @limit: End address of the reserved memory (optional, 0 for any).
>>   * @alignment: Alignment for the contiguous memory area, should be power of 2
>> + * @order_per_bit: Order of pages represented by one bit on bitmap.
>>   * @res_cma: Pointer to store the created cma region.
>>   * @fixed: hint about where to place the reserved area
>>   *
>> @@ -235,7 +266,7 @@ core_initcall(cma_init_reserved_areas);
>>   */
>>  static int __init __dma_contiguous_reserve_area(phys_addr_t size,
>>  				phys_addr_t base, phys_addr_t limit,
>> -				phys_addr_t alignment,
>> +				phys_addr_t alignment, int order_per_bit,
>>  				struct cma **res_cma, bool fixed)
>>  {
>>  	struct cma *cma = &cma_areas[cma_area_count];
>> @@ -269,6 +300,8 @@ static int __init __dma_contiguous_reserve_area(phys_addr_t size,
>>  	base = ALIGN(base, alignment);
>>  	size = ALIGN(size, alignment);
>>  	limit &= ~(alignment - 1);
>> +	/* size should be aligned with order_per_bit */
>> +	BUG_ON(!IS_ALIGNED(size >> PAGE_SHIFT, 1 << order_per_bit));
>>  
>>  	/* Reserve memory */
>>  	if (base && fixed) {
>> @@ -294,6 +327,7 @@ static int __init __dma_contiguous_reserve_area(phys_addr_t size,
>>  	 */
>>  	cma->base_pfn = PFN_DOWN(base);
>>  	cma->count = size >> PAGE_SHIFT;
>> +	cma->order_per_bit = order_per_bit;
>>  	*res_cma = cma;
>>  	cma_area_count++;
>>  
>> @@ -313,7 +347,7 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>>  {
>>  	int ret;
>>  
>> -	ret = __dma_contiguous_reserve_area(size, base, limit, 0,
>> +	ret = __dma_contiguous_reserve_area(size, base, limit, 0, 0,
>>  						res_cma, fixed);
>>  	if (ret)
>>  		return ret;
>> @@ -324,13 +358,6 @@ int __init dma_contiguous_reserve_area(phys_addr_t size, phys_addr_t base,
>>  	return 0;
>>  }
>>  
>> -static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
>> -{
>> -	mutex_lock(&cma->lock);
>> -	bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
>> -	mutex_unlock(&cma->lock);
>> -}
>> -
>>  /**
>>   * dma_alloc_from_contiguous() - allocate pages from contiguous area
>>   * @dev:   Pointer to device for which the allocation is performed.
>> @@ -345,7 +372,8 @@ static void clear_cma_bitmap(struct cma *cma, unsigned long pfn, int count)
>>  static struct page *__dma_alloc_from_contiguous(struct cma *cma, int count,
>>  				       unsigned int align)
>>  {
>> -	unsigned long mask, pfn, pageno, start = 0;
>> +	unsigned long mask, pfn, start = 0;
>> +	unsigned long bitmap_maxno, bitmapno, nr_bits;
> 
> Just Nit: bitmap_maxno, bitmap_no or something consistent.
> I know you love consistent when I read description in first patch
> in this patchset. ;-)
> 

Yeah, not only in this patchset, I saw Joonsoo trying to unify all
kinds of things in the MM. This is great for newbies, IMO.

-- 
Thanks.
Zhang Yanfei
