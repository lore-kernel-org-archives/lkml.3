Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab3JXKjc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 06:39:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41585 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754320Ab3JXKja (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 06:39:30 -0400
Date: Thu, 24 Oct 2013 13:39:25 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, avi.kivity@gmail.com,
        mtosatti@redhat.com, pbonzini@redhat.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH v3 10/15] KVM: MMU: allocate shadow pages from slab
Message-ID: <20131024103925.GE5289@redhat.com>
References: <1382534973-13197-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <1382534973-13197-11-git-send-email-xiaoguangrong@linux.vnet.ibm.com>
 <20131024091905.GB5289@redhat.com>
 <5268E888.7060608@linux.vnet.ibm.com>
 <20131024095204.GD5289@redhat.com>
 <5268F226.4030309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5268F226.4030309@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 06:10:46PM +0800, Xiao Guangrong wrote:
> On 10/24/2013 05:52 PM, Gleb Natapov wrote:
> > On Thu, Oct 24, 2013 at 05:29:44PM +0800, Xiao Guangrong wrote:
> >> On 10/24/2013 05:19 PM, Gleb Natapov wrote:
> >>
> >>>> @@ -946,7 +947,7 @@ static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
> >>>>  {
> >>>>  	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
> >>>>  
> >>>> -	return (struct kvm_mmu_page *)page_private(page);
> >>>> +	return (struct kvm_mmu_page *)(page->mapping);
> >>> Why?
> >>
> >> That's because page->private has been used by slab:
> >>
> > But does lockless path actually looks at it?
> 
> Lockless path does not use it, however, it is used by kvm_mmu_page():
> 
> static inline struct kvm_mmu_page *page_header(hpa_t shadow_page)
> {
> 	struct page *page = pfn_to_page(shadow_page >> PAGE_SHIFT);
> 
> 	return (struct kvm_mmu_page *)(page->mapping);
> }
> 
> which is used in the common code.
Ah, so the pointer is not available even after object is allocated.
Make sense since we allocate object, not page here, but is it safe to
use mapping like that?

--
			Gleb.
