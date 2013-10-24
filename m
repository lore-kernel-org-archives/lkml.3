Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab3JXLB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 07:01:58 -0400
Received: from mail-oa0-f53.google.com ([209.85.219.53]:41582 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab3JXLBz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 07:01:55 -0400
Message-ID: <5268FE1D.50809@gmail.com>
Date: Thu, 24 Oct 2013 19:01:49 +0800
From: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/15] KVM: MMU: allocate shadow pages from slab
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1382534973-13197-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20131024091905.GB5289@redhat.com> <5268E888.7060608@linux.vnet.ibm.com> <20131024095204.GD5289@redhat.com> <5268F226.4030309@gmail.com> <20131024103925.GE5289@redhat.com>
In-Reply-To: <20131024103925.GE5289@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/2013 06:39 PM, Gleb Natapov wrote:
> On Thu, Oct 24, 2013 at 06:10:46PM +0800, Xiao Guangrong wrote:
>> On 10/24/2013 05:52 PM, Gleb Natapov wrote:
>>> On Thu, Oct 24, 2013 at 05:29:44PM +0800, Xiao Guangrong wrote:
>>>> On 10/24/2013 05:19 PM, Gleb Natapov wrote:
>>>>
>>>>>> @@ -946,7 +947,7 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
>>>>>>  {
>>>>>>  	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
>>>>>>  
>>>>>> -	return (struct kvm_mmu_page *)page_private(page);
>>>>>> +	return (struct kvm_mmu_page *)(page->mapping);
>>>>> Why?
>>>>
>>>> That's because page->private has been used by slab:
>>>>
>>> But does lockless path actually looks at it?
>>
>> Lockless path does not use it, however, it is used by kvm_mmu_page():
>>
>> static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
>> {
>> 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
>>
>> 	return (struct kvm_mmu_page *)(page->mapping);
>> }
>>
>> which is used in the common code.
> Ah, so the pointer is not available even after object is allocated.
> Make sense since we allocate object, not page here, but is it safe to
> use mapping like that?

The commens says:

	struct address_space *mapping;	/* If low bit clear, points to
					 * inode address_space, or NULL.
					 * If page mapped as anonymous
					 * memory, low bit is set, and
					 * it points to anon_vma object:
					 * see PAGE_MAPPING_ANON below.

It seems mapping is used for address_space or anonymous memory, in
our case, the page is used by slab, so I guess it is ok. And the bug
i put in set_page_header() was not tiggered on both slab and slub.


