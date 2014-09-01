Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130AbaIAFN0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 01:13:26 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:25958 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750869AbaIAFNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 01:13:25 -0400
X-IronPort-AV: E=Sophos;i="5.04,440,1406563200"; 
   d="scan'208";a="35324003"
Message-ID: <540400B4.5050006@cn.fujitsu.com>
Date: Mon, 1 Sep 2014 13:14:28 +0800
From: tangchen <tangchen@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: <gleb@kernel.org>, <mtosatti@redhat.com>, <nadav.amit@gmail.com>,
        <jan.kiszka@web.de>
CC: <kvm@vger.kernel.org>, <laijs@cn.fujitsu.com>,
        <isimatu.yasuaki@jp.fujitsu.com>, <guz.fnst@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>, <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH v4 0/6] kvm, mem-hotplug: Do not pin ept identity pagetable
 and apic access page.
References: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1409134661-27916-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gleb,

Would you please help to review these patches ?

Thanks.

On 08/27/2014 06:17 PM, Tang Chen wrote:
> ept identity pagetable and apic access page in kvm are pinned in memory.
> As a result, they cannot be migrated/hot-removed.
>
> But actually they don't need to be pinned in memory.
>
> [For ept identity page]
> Just do not pin it. When it is migrated, guest will be able to find the
> new page in the next ept violation.
>
> [For apic access page]
> The hpa of apic access page is stored in VMCS APIC_ACCESS_ADDR pointer.
> When apic access page is migrated, we update VMCS APIC_ACCESS_ADDR pointer
> for each vcpu in addition.
>
> NOTE: Tested with -cpu xxx,-x2apic option.
>        But since nested vm pins some other pages in memory, if user uses nested
>        vm, memory hot-remove will not work.
>
> Change log v3 -> v4:
> 1. The original patch 6 is now patch 5. ( by Jan Kiszka <jan.kiszka@web.de> )
> 2. The original patch 1 is now patch 6 since we should unpin apic access page
>     at the very last moment.
>
>
> Tang Chen (6):
>    kvm: Use APIC_DEFAULT_PHYS_BASE macro as the apic access page address.
>    kvm: Remove ept_identity_pagetable from struct kvm_arch.
>    kvm: Make init_rmode_identity_map() return 0 on success.
>    kvm, mem-hotplug: Reload L1' apic access page on migration in
>      vcpu_enter_guest().
>    kvm, mem-hotplug: Reload L1's apic access page on migration when L2 is
>      running.
>    kvm, mem-hotplug: Do not pin apic access page in memory.
>
>   arch/x86/include/asm/kvm_host.h |   3 +-
>   arch/x86/kvm/svm.c              |  15 +++++-
>   arch/x86/kvm/vmx.c              | 103 +++++++++++++++++++++++++++-------------
>   arch/x86/kvm/x86.c              |  22 +++++++--
>   include/linux/kvm_host.h        |   3 ++
>   virt/kvm/kvm_main.c             |  30 +++++++++++-
>   6 files changed, 135 insertions(+), 41 deletions(-)
>

