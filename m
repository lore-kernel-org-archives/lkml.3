Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822Ab3JXJ3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:29:53 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:46105 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754561Ab3JXJ3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:29:51 -0400
Message-ID: <5268E888.7060608@linux.vnet.ibm.com>
Date: Thu, 24 Oct 2013 17:29:44 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: avi.kivity@gmail.com, mtosatti@redhat.com, pbonzini@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/15] KVM: MMU: allocate shadow pages from slab
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131024091905.GB5289@redhat.com>
In-Reply-To: <20131024091905.GB5289@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102409-3568-0000-0000-00000473CE99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 05:19 PM, Gleb Natapov wrote:

>> @@ -946,7 +947,7 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
>>  {
>>  	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
>>  
>> -	return (struct kvm_mmu_page *)page_private(page);
>> +	return (struct kvm_mmu_page *)(page->mapping);
> Why?

That's because page->private has been used by slab:

	/* Remainder is not double word aligned */
	union {
		unsigned long private;		/* Mapping-private opaque data:
					 	 * usually used for buffer_heads
						 * if PagePrivate set; used for
						 * swp_entry_t if PageSwapCache;
						 * indicates order in the buddy
						 * system if PG_buddy is set.
						 */
#if USE_SPLIT_PTLOCKS
		spinlock_t ptl;
#endif
		struct kmem_cache *slab_cache;	/* SL[AU]B: Pointer to slab */
		struct page *first_page;	/* Compound tail pages */
	};

