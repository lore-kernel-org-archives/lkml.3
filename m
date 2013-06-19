Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934176Ab3FSCrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 22:47:18 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:60812 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934139Ab3FSCrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 22:47:16 -0400
Message-ID: <51C11BA9.10000@linux.vnet.ibm.com>
Date: Wed, 19 Jun 2013 10:47:05 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>
CC: gleb@redhat.com, avi.kivity@gmail.com, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3 0/6] KVM: MMU: fast invalidate all mmio sptes
References: <1370595088-3315-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <51C06E14.5090501@redhat.com>
In-Reply-To: <51C06E14.5090501@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061902-9574-0000-0000-0000085B9D14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 10:26 PM, Paolo Bonzini wrote:
> Il 07/06/2013 10:51, Xiao Guangrong ha scritto:
>> Changelog:
>> V3:
>>   All of these changes are from Gleb's review:
>>   1) rename RET_MMIO_PF_EMU to RET_MMIO_PF_EMULATE.
>>   2) smartly adjust kvm generation number in kvm_current_mmio_generatio()
>>      to avoid kvm_memslots->generation overflow.
>>
>> V2:
>>   - rename kvm_mmu_invalid_mmio_spte to kvm_mmu_invalid_mmio_sptes
>>   - use kvm->memslots->generation as kvm global generation-number
>>   - fix comment and codestyle
>>   - init kvm generation close to mmio wrap-around value
>>   - keep kvm_mmu_zap_mmio_sptes
>>
>> The current way is holding hot mmu-lock and walking all shadow pages, this
>> is not scale. This patchset tries to introduce a very simple and scale way
>> to fast invalidate all mmio sptes - it need not walk any shadow pages and hold
>> any locks.
>>
>> The idea is simple:
>> KVM maintains a global mmio valid generation-number which is stored in
>> kvm->memslots.generation and every mmio spte stores the current global
>> generation-number into his available bits when it is created
>>
>> When KVM need zap all mmio sptes, it just simply increase the global
>> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
>> then it walks the shadow page table and get the mmio spte. If the
>> generation-number on the spte does not equal the global generation-number,
>> it will go to the normal #PF handler to update the mmio spte
>>
>> Since 19 bits are used to store generation-number on mmio spte, we zap all
>> mmio sptes when the number is round
>>
>> Xiao Guangrong (6):
>>   KVM: MMU: retain more available bits on mmio spte
>>   KVM: MMU: store generation-number into mmio spte
>>   KVM: MMU: make return value of mmio page fault handler more readable
>>   KVM: MMU: fast invalidate all mmio sptes
>>   KVM: MMU: add tracepoint for check_mmio_spte
>>   KVM: MMU: init kvm generation close to mmio wrap-around value
>>
>>  arch/x86/include/asm/kvm_host.h |   2 +-
>>  arch/x86/kvm/mmu.c              | 131 ++++++++++++++++++++++++++++++++--------
>>  arch/x86/kvm/mmu.h              |  17 ++++++
>>  arch/x86/kvm/mmutrace.h         |  34 +++++++++--
>>  arch/x86/kvm/paging_tmpl.h      |  10 ++-
>>  arch/x86/kvm/vmx.c              |  12 ++--
>>  arch/x86/kvm/x86.c              |  11 +++-
>>  7 files changed, 177 insertions(+), 40 deletions(-)
>>
> 
> Xiao, is it time to add more comments to the code or update
> Documentation/virtual/kvm/mmu.txt?  

Yes. it is.

We missed to update mmu.txt for a long time. I will post a separate patchset
to update it to the current mmu code.

> Don't worry about the English, it is
> more than understandable and I can help with the editing.

Okay. Thank you in advance, Paolo! :)


