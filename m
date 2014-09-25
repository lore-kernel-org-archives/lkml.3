Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaIYITw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:19:52 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:17949 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750877AbaIYITs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:19:48 -0400
X-IronPort-AV: E=Sophos;i="5.04,595,1406563200"; 
   d="scan'208";a="36453970"
Message-ID: <5423D015.6090107@cn.fujitsu.com>
Date: Thu, 25 Sep 2014 16:19:33 +0800
From: Tang Chen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Paolo Bonzini <pbonzini@redhat.com>, <gleb@kernel.org>,
        <mtosatti@redhat.com>, <nadav.amit@gmail.com>, <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v8 0/8] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1411545478-9848-1-git-send-email-tangchen@cn.fujitsu.com> <54227EB4.7070608@redhat.com>
In-Reply-To: <54227EB4.7070608@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paolo,

I'd like to help to test the patches.
Would you please tell me what is the best way to test this patch-set ?

I think ept page is being used by regular guest.
Is adding "-cpu xxx,-x2apic option" able to make sure guest is using
apic page ?

Thanks.

On 09/24/2014 04:20 PM, Paolo Bonzini wrote:
> Il 24/09/2014 09:57, Tang Chen ha scritto:
>> ept identity pagetable and apic access page in kvm are pinned in memory.
>> As a result, they cannot be migrated/hot-removed.
>>
>> But actually they don't need to be pinned in memory.
>>
>> [For ept identity page]
>> Just do not pin it. When it is migrated, guest will be able to find the
>> new page in the next ept violation.
>>
>> [For apic access page]
>> The hpa of apic access page is stored in VMCS APIC_ACCESS_ADDR pointer.
>> When apic access page is migrated, we update VMCS APIC_ACCESS_ADDR pointer
>> for each vcpu in addition.
>>
>> This patch-set is based on Linux 3.17.0-rc5.
>>
>> NOTE: Tested with -cpu xxx,-x2apic option.
>>        But since nested vm pins some other pages in memory, if user uses nested
>>        vm, memory hot-remove will not work.
>>
>> Change log v7->v8:
>> 1. Patch 1/9~3/9 were applied to kvm/queue by Paolo Bonzini <pbonzini@redhat.com>.
>>     Just resend them, no changes.
>> 2. Removed previous patch 4/9, which added unnecessary hook has_secondary_apic_access().
>> 3. Set kvm_x86_ops->set_apic_access_page_addr to NULL when hardware had no flexpriority
>>     functionality which actually exists only on x86.
>> 4. Moved declaration of kvm_arch_mmu_notifier_invalidate_page() to arch/*/include/asm/kvm_host.h.
>> 5. Removed useless set_apic_access_page_addr() hook for svm.
>>
>> Tang Chen (8):
>>    kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic access page address.
>>    kvm: Remove ept_identity_pagetable from struct kvm_arch.
>>    kvm: Make init_rmode_identity_map() return 0 on success.
>>    kvm, mem-hotplug: Reload L1's apic access page in vcpu_enter_guest().
>>    kvm: Rename make_all_cpus_request() to kvm_make_all_cpus_request() and
>>      make it non-static.
>>    kvm, mem-hotplug: Reload L1's apic access page on migration when L2 is
>>      running.
>>    kvm, mem-hotplug: Add arch specific mmu notifier to handle apic access
>>      migration.
>>    kvm, mem-hotplug: Unpin and remove kvm_arch->apic_access_page.
>>
>>   arch/arm/include/asm/kvm_host.h     |   5 ++
>>   arch/arm64/include/asm/kvm_host.h   |   5 ++
>>   arch/ia64/include/asm/kvm_host.h    |   7 ++
>>   arch/mips/include/asm/kvm_host.h    |   6 ++
>>   arch/powerpc/include/asm/kvm_host.h |   5 ++
>>   arch/s390/include/asm/kvm_host.h    |   8 +++
>>   arch/x86/include/asm/kvm_host.h     |   7 +-
>>   arch/x86/kvm/svm.c                  |   3 +-
>>   arch/x86/kvm/vmx.c                  | 130 ++++++++++++++++++++++++------------
>>   arch/x86/kvm/x86.c                  |  45 +++++++++++--
>>   include/linux/kvm_host.h            |   2 +
>>   virt/kvm/kvm_main.c                 |  13 ++--
>>   12 files changed, 180 insertions(+), 56 deletions(-)
>>
> Thanks for your persistence!  The patches look good, I'll test them and
> apply to kvm/queue.
>
> Paolo
> .
>

