Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932501Ab3ECFwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 01:52:21 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:36562 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762113Ab3ECFwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 01:52:19 -0400
Message-ID: <51835087.8090605@linux.vnet.ibm.com>
Date: Fri, 03 May 2013 13:52:07 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, takuya.yoshikawa@gmail.com
Subject: Re: [PATCH v4 4/6] KVM: MMU: fast invalid all shadow pages
References: <1367032402-13729-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1367032402-13729-5-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130503010534.GA5467@amt.cnet>
In-Reply-To: <20130503010534.GA5467@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13050305-1618-0000-0000-000003D0BCDC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/03/2013 09:05 AM, Marcelo Tosatti wrote:

>> +
>> +/*
>> + * Fast invalid all shadow pages belong to @slot.
>> + *
>> + * @slot != NULL means the invalidation is caused the memslot specified
>> + * by @slot is being deleted, in this case, we should ensure that rmap
>> + * and lpage-info of the @slot can not be used after calling the function.
>> + *
>> + * @slot == NULL means the invalidation due to other reasons, we need
>> + * not care rmap and lpage-info since they are still valid after calling
>> + * the function.
>> + */
>> +void kvm_mmu_invalid_memslot_pages(struct kvm *kvm,
>> +				   struct kvm_memory_slot *slot)
>> +{
>> +	spin_lock(&kvm->mmu_lock);
>> +	kvm->arch.mmu_valid_gen++;
>> +
>> +	/*
>> +	 * All shadow paes are invalid, reset the large page info,
>> +	 * then we can safely desotry the memslot, it is also good
>> +	 * for large page used.
>> +	 */
>> +	kvm_clear_all_lpage_info(kvm);
> 
> Xiao,
> 
> I understood it was agreed that simple mmu_lock lockbreak while
> avoiding zapping of newly instantiated pages upon a
> 
> 	if(spin_needbreak)
> 		cond_resched_lock()
> 
> cycle was enough as a first step? And then later introduce root zapping
> along with measurements.
> 
> https://lkml.org/lkml/2013/4/22/544

Yes, it is.

See the changelog in 0/0:

" we use lock-break technique to zap all sptes linked on the
invalid rmap, it is not very effective but good for the first step."

Thanks!


