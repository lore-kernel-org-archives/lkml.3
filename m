Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863Ab3CSHwc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 03:52:32 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:38450 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757641Ab3CSHwb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 03:52:31 -0400
Message-ID: <51481933.1050009@linux.vnet.ibm.com>
Date: Tue, 19 Mar 2013 15:52:19 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Eric Northup <digitaleric@google.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: fast invalid all mmio sptes
References: <51433D98.4050605@linux.vnet.ibm.com> <51433E71.2070107@linux.vnet.ibm.com> <CAG7+5M0Z+HLxUf6n6=D3uqKhn3F2NbKU6tcHYtD6gyF3t8iHsw@mail.gmail.com> <5147D858.4010805@linux.vnet.ibm.com> <20130319073648.GT11223@redhat.com>
In-Reply-To: <20130319073648.GT11223@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031907-1618-0000-0000-00000387EACA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 03:36 PM, Gleb Natapov wrote:
> On Tue, Mar 19, 2013 at 11:15:36AM +0800, Xiao Guangrong wrote:
>> On 03/19/2013 06:16 AM, Eric Northup wrote:
>>> On Fri, Mar 15, 2013 at 8:29 AM, Xiao Guangrong
>>> <xiaoguangrong@linux.vnet.ibm.com> wrote:
>>>> This patch tries to introduce a very simple and scale way to invalid all
>>>> mmio sptes - it need not walk any shadow pages and hold mmu-lock
>>>>
>>>> KVM maintains a global mmio invalid generation-number which is stored in
>>>> kvm->arch.mmio_invalid_gen and every mmio spte stores the current global
>>>> generation-number into his available bits when it is created
>>>>
>>>> When KVM need zap all mmio sptes, it just simply increase the global
>>>> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
>>>> then it walks the shadow page table and get the mmio spte. If the
>>>> generation-number on the spte does not equal the global generation-number,
>>>> it will go to the normal #PF handler to update the mmio spte
>>>>
>>>> Since 19 bits are used to store generation-number on mmio spte, the
>>>> generation-number can be round after 33554432 times. It is large enough
>>>> for nearly all most cases, but making the code be more strong, we zap all
>>>> shadow pages when the number is round
>>>>
>>>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>>>> ---
>>>>  arch/x86/include/asm/kvm_host.h |    2 +
>>>>  arch/x86/kvm/mmu.c              |   61 +++++++++++++++++++++++++++++++++------
>>>>  arch/x86/kvm/mmutrace.h         |   17 +++++++++++
>>>>  arch/x86/kvm/paging_tmpl.h      |    7 +++-
>>>>  arch/x86/kvm/vmx.c              |    4 ++
>>>>  arch/x86/kvm/x86.c              |    6 +--
>>>>  6 files changed, 82 insertions(+), 15 deletions(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>>>> index ef7f4a5..572398e 100644
>>>> --- a/arch/x86/include/asm/kvm_host.h
>>>> +++ b/arch/x86/include/asm/kvm_host.h
>>>> @@ -529,6 +529,7 @@ struct kvm_arch {
>>>>         unsigned int n_requested_mmu_pages;
>>>>         unsigned int n_max_mmu_pages;
>>>>         unsigned int indirect_shadow_pages;
>>>> +       unsigned int mmio_invalid_gen;
>>>
>>> Could this get initialized to something close to the wrap-around
>>> value, so that the wrap-around case gets more real-world coverage?
>>
>> I am afraid we can not. We cache the current mmio_invalid_gen into mmio spte when
>> it is created no matter what the initiation value is.
>>
>> If you have a better way, please show me. ;)
>>
> The idea is to initialize mmio_invalid_gen to value close to MAX_GEN in
> order to exercise 

Oh, got it, i understood it as "initialize mmio_invalid properly to _avoid_ more
wrap-around"... Sorry for my careless! :(

The idea can check the hardly-run code at runtime, i am fine with this.

Thank you, Eric and Gleb!

