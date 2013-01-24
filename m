Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab3AXLdp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 06:33:45 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50212 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3AXLdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 06:33:36 -0500
Message-ID: <51011C06.9090003@linux.vnet.ibm.com>
Date: Thu, 24 Jan 2013 19:33:26 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi.kivity@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 05/12] KVM: MMU: introduce vcpu_adjust_access
References: <50FFB5A1.5090708@linux.vnet.ibm.com> <50FFB62C.4070808@linux.vnet.ibm.com> <20130124103604.GW31120@redhat.com>
In-Reply-To: <20130124103604.GW31120@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012411-7014-0000-0000-00000282952B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2013 06:36 PM, Gleb Natapov wrote:
> On Wed, Jan 23, 2013 at 06:06:36PM +0800, Xiao Guangrong wrote:
>> Introduce it to split the code of adjusting pte_access from the large
>> function of set_spte
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/kvm/mmu.c |   63 +++++++++++++++++++++++++++++++++-------------------
>>  1 files changed, 40 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
>> index af8bcb2..43b7e0c 100644
>> --- a/arch/x86/kvm/mmu.c
>> +++ b/arch/x86/kvm/mmu.c
>> @@ -2324,25 +2324,18 @@ static int mmu_need_write_protect(struct kvm_vcpu *vcpu, gfn_t gfn,
>>  	return 0;
>>  }
>>
>> -static int set_spte(struct kvm_vcpu *vcpu, u64 *sptep,
>> -		    unsigned pte_access, int level,
>> -		    gfn_t gfn, pfn_t pfn, bool speculative,
>> -		    bool can_unsync, bool host_writable)
>> +/*
>> + * Return -1 if a race condition is detected, 1 if @gfn need to be
>> + * write-protected, otherwise 0 is returned.
>> + */
> That's a little bit crafty.
> 
> Isn't it better to handle race condition in set_spte() explicitly?
> Something like do:
> 
>  if (host_writable && (pte_access & ACC_WRITE_MASK) &&
>         level > PT_PAGE_TABLE_LEVEL && has_wrprotected_page(vcpu->kvm, gfn, level))
>     return 0;
> 
> before calling vcpu_adjust_access() in set_spte()?
> 
> Or even do:
> 
>  if ((pte_access & ACC_WRITE_MASK) && level > PT_PAGE_TABLE_LEVEL &&
>            has_wrprotected_page(vcpu->kvm, gfn, level))
>     return 0;
> 
> After calling vcpu_adjust_access().
> 
> The later will create read only large page mapping where now it is not
> created, but it shouldn't be a problem as far as I see.

Yes. I like the later way. Will update it. Thanks for your suggestion, Gleb!

