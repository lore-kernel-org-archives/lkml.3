Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab3FSNK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 09:10:28 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:41905 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab3FSNK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 09:10:26 -0400
Message-ID: <51C1ADB9.2030509@linux.vnet.ibm.com>
Date: Wed, 19 Jun 2013 21:10:17 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH 7/7] KVM: MMU: document fast invalidate all mmio sptes
References: <1371632965-20077-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <1371632965-20077-8-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51C1A57F.3060704@redhat.com>
In-Reply-To: <51C1A57F.3060704@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061913-1396-0000-0000-000003245049
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2013 08:35 PM, Paolo Bonzini wrote:
> Il 19/06/2013 11:09, Xiao Guangrong ha scritto:
>> Document it to Documentation/virtual/kvm/mmu.txt
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  Documentation/virtual/kvm/mmu.txt | 25 +++++++++++++++++++++++++
>>  1 file changed, 25 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/mmu.txt b/Documentation/virtual/kvm/mmu.txt
>> index f5c4de9..9b7cfb3 100644
>> --- a/Documentation/virtual/kvm/mmu.txt
>> +++ b/Documentation/virtual/kvm/mmu.txt
>> @@ -396,6 +396,31 @@ ensures the old pages are not used any more. The invalid-gen pages
>>  (sp->mmu_valid_gen != kvm->arch.mmu_valid_gen) are zapped by using lock-break
>>  technique.
>>  
>> +Fast invalidate all mmio sptes
>> +===========
>> +As mentioned in "Reaction to events" above, kvm will cache the mmio information
>> +to the last sptes so that we should zap all mmio sptes when the guest mmio info
>> +is changed. This will happen when a new memslot is added or the existing
>> +memslot is moved.
>> +
>> +Zapping mmio spte is also a scalability issue for the large memory and large
>> +vcpus guests since it needs to hold hot mmu-lock and walk all shadow pages to
>> +find all the mmio spte out.
>> +
>> +We fix this issue by using the similar way of "Fast invalidate all pages".
>> +The global mmio valid generation-number is stored in kvm->memslots.generation
>> +and every mmio spte stores the current global generation-number into his
>> +available bits when it is created
>> +
>> +The global mmio valid generation-number is increased whenever the gust memory
>> +info is changed. When guests do mmio access, kvm intercepts a MMIO #PF then it
>> +walks the shadow page table and get the mmio spte. If the generation-number on
>> +the spte does not equal the global generation-number, it will go to the normal
>> +#PF handler to update the mmio spte.
>> +
>> +Since 19 bits are used to store generation-number on mmio spte, we zap all pages
>> +when the number is round.
> 
> As mentioned in "Reaction to events" above, kvm will cache MMIO
> information in leaf sptes.  When a new memslot is added or an existing
> memslot is changed, this information may become stale and needs to be
> invalidated.  This also needs to hold the MMU lock while walking all
> shadow pages, and is made more scalable with a similar technique.
> 
> MMIO sptes have a few spare bits, which are used to store a
> generation number.  The global generation number is stored in
> kvm_memslots(kvm)->generation, and increased whenever guest memory info
> changes.  This generation number is distinct from the one described in
> the previous section.
> 
> When KVM finds an MMIO spte, it checks the generation number of the spte.
> If the generation number of the spte does not equal the global generation
> number, it will ignore the cached MMIO information and handle the page
> fault through the slow path.
> 
> Since only 19 bits are used to store generation-number on mmio spte, all
> pages are zapped when there is an overflow.

Really nice.

> 
> 
> I'm also adding this in the page fault section:
> 
>    - check for valid generation number in the spte (see "Fast invalidation of
>      MMIO sptes" below)

Oh, i forgot it in this section, thanks for your fix.



