Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935546Ab3DPDJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 23:09:47 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:34824 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935212Ab3DPDJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 23:09:46 -0400
Message-ID: <516CC0F1.30404@linux.vnet.ibm.com>
Date: Tue, 16 Apr 2013 11:09:37 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: gleb@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v2 0/6] KVM: MMU: fast invalid all mmio sptes
References: <1364810209-25954-1-git-send-email-xiaoguangrong@linux.vnet.ibm.com> <20130416005439.GC1962@amt.cnet>
In-Reply-To: <20130416005439.GC1962@amt.cnet>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041603-9574-0000-0000-00000779E0FA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Marcelo,

On 04/16/2013 08:54 AM, Marcelo Tosatti wrote:
> On Mon, Apr 01, 2013 at 05:56:43PM +0800, Xiao Guangrong wrote:
>> Changelog in v2:
>>   - rename kvm_mmu_invalid_mmio_spte to kvm_mmu_invalid_mmio_sptes
>>   - use kvm->memslots->generation as kvm global generation-number
>>   - fix comment and codestyle
>>   - init kvm generation close to mmio wrap-around value
>>   - keep kvm_mmu_zap_mmio_sptes
>>
>> The current way is holding hot mmu-lock and walking all shadow pages, this
>> is not scale. This patchset tries to introduce a very simple and scale way
>> to fast invalid all mmio sptes - it need not walk any shadow pages and hold
>> any locks.
>>
>> The idea is simple:
>> KVM maintains a global mmio invalid generation-number which is stored in
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
> 
> Hi Xiao,
> 
> Is it still necessary with generation numbers at 'struct shadow_page'
> level (which covers the slot deletion case).

Yes.

> 
> That is, once kvm_mmu_zap_all is fixed to increase generation count and
> nuke roots, can't that be used instead with similar effectiveness for
> SLOT_CREATE/SLOT_MOVE cases?

It seems not easy. :(

We can not increase kvm's generation count for SLOT_CREATE since any change
on kvm->generation_count will cause all vcpus fault on _all_ memory region.

We also can not separately update mmio-sp's generation count instead of
zapping them since a sp can have both mmio-spte and normal-spte, we should
zap the normal spte on a mmio-sp.

Thanks!

