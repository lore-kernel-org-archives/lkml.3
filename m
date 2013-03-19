Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab3CSDPx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:15:53 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:45630 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab3CSDPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:15:51 -0400
Message-ID: <5147D858.4010805@linux.vnet.ibm.com>
Date: Tue, 19 Mar 2013 11:15:36 +0800
From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Eric Northup <digitaleric@google.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/5] KVM: MMU: fast invalid all mmio sptes
References: <51433D98.4050605@linux.vnet.ibm.com> <51433E71.2070107@linux.vnet.ibm.com> <CAG7+5M0Z+HLxUf6n6=D3uqKhn3F2NbKU6tcHYtD6gyF3t8iHsw@mail.gmail.com>
In-Reply-To: <CAG7+5M0Z+HLxUf6n6=D3uqKhn3F2NbKU6tcHYtD6gyF3t8iHsw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031903-1618-0000-0000-000003878601
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2013 06:16 AM, Eric Northup wrote:
> On Fri, Mar 15, 2013 at 8:29 AM, Xiao Guangrong
> <xiaoguangrong@linux.vnet.ibm.com> wrote:
>> This patch tries to introduce a very simple and scale way to invalid all
>> mmio sptes - it need not walk any shadow pages and hold mmu-lock
>>
>> KVM maintains a global mmio invalid generation-number which is stored in
>> kvm->arch.mmio_invalid_gen and every mmio spte stores the current global
>> generation-number into his available bits when it is created
>>
>> When KVM need zap all mmio sptes, it just simply increase the global
>> generation-number. When guests do mmio access, KVM intercepts a MMIO #PF
>> then it walks the shadow page table and get the mmio spte. If the
>> generation-number on the spte does not equal the global generation-number,
>> it will go to the normal #PF handler to update the mmio spte
>>
>> Since 19 bits are used to store generation-number on mmio spte, the
>> generation-number can be round after 33554432 times. It is large enough
>> for nearly all most cases, but making the code be more strong, we zap all
>> shadow pages when the number is round
>>
>> Signed-off-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
>> ---
>>  arch/x86/include/asm/kvm_host.h |    2 +
>>  arch/x86/kvm/mmu.c              |   61 +++++++++++++++++++++++++++++++++------
>>  arch/x86/kvm/mmutrace.h         |   17 +++++++++++
>>  arch/x86/kvm/paging_tmpl.h      |    7 +++-
>>  arch/x86/kvm/vmx.c              |    4 ++
>>  arch/x86/kvm/x86.c              |    6 +--
>>  6 files changed, 82 insertions(+), 15 deletions(-)
>>
>> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
>> index ef7f4a5..572398e 100644
>> --- a/arch/x86/include/asm/kvm_host.h
>> +++ b/arch/x86/include/asm/kvm_host.h
>> @@ -529,6 +529,7 @@ struct kvm_arch {
>>         unsigned int n_requested_mmu_pages;
>>         unsigned int n_max_mmu_pages;
>>         unsigned int indirect_shadow_pages;
>> +       unsigned int mmio_invalid_gen;
> 
> Could this get initialized to something close to the wrap-around
> value, so that the wrap-around case gets more real-world coverage?

I am afraid we can not. We cache the current mmio_invalid_gen into mmio spte when
it is created no matter what the initiation value is.

If you have a better way, please show me. ;)



