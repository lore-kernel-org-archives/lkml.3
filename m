Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaLXCMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 21:12:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:41599 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaLXCMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 21:12:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="503409437"
Message-ID: <549A211A.30508@linux.intel.com>
Date: Wed, 24 Dec 2014 10:12:42 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: "Zhang, Yang Z" <yang.z.zhang@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, "Wu, Feng" <feng.wu@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "x86@kernel.org" <x86@kernel.org>, Gleb Natapov <gleb@kernel.org>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "joro@8bytes.org" <joro@8bytes.org>,
        Alex Williamson <alex.williamson@redhat.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, Eric Auger <eric.auger@linaro.org>
Subject: Re: [v3 06/26] iommu, x86: No need to migrating irq for VT-d Posted-Interrupts
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>	<1418397300-10870-7-git-send-email-feng.wu@intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC0486D@SHSMSX104.ccr.corp.intel.com>	<E959C4978C3B6342920538CF579893F00230A649@SHSMSX104.ccr.corp.intel.com>	<A9667DDFB95DB7438FA9D7D576C3D87E0AC04E77@SHSMSX104.ccr.corp.intel.com>	<54941326.4080405@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC06282@SHSMSX104.ccr.corp.intel.com> <54992C2C.5030305@redhat.com> <E959C4978C3B6342920538CF579893F002314236@SHSMSX104.ccr.corp.intel.com> <5499370D.8000703@redhat.com> <A9667DDFB95DB7438FA9D7D576C3D87E0AC06DF9@SHSMSX104.ccr.corp.intel.com>
In-Reply-To: <A9667DDFB95DB7438FA9D7D576C3D87E0AC06DF9@SHSMSX104.ccr.corp.intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/12/24 9:38, Zhang, Yang Z wrote:
> Paolo Bonzini wrote on 2014-12-23:
>>
>>
>> On 23/12/2014 10:07, Wu, Feng wrote:
>>>> On 23/12/2014 01:37, Zhang, Yang Z wrote:
>>>>> I don't quite understand it. If user set an interrupt's affinity
>>>>> to a CPU, but he still see the interrupt delivers to other CPUs in host.
>>>>> Do you think it is a right behavior?
>>>>
>>>> No, the interrupt is not delivered at all in the host.  Normally you'd have:
>>>>
>>>> - interrupt delivered to CPU from host affinity
>>>>
>>>> - VFIO interrupt handler writes to irqfd
>>>>
>>>> - interrupt delivered to vCPU from guest affinity
>>>>
>>>> Here, you just skip the first two steps.  The interrupt is
>>>> delivered to the thread that is running the vCPU directly, so the
>>>> host affinity is bypassed entirely.
>>>>
>>>> ... unless you are considering the case where the vCPU is blocked
>>>> and the host is processing the posted interrupt wakeup vector.  In
>>>> that case yes, it would be better to set NDST to a CPU matching the host affinity.
>>>
>>> In my understanding, wakeup vector should have no relationship with
>>> the host affinity of the irq. Wakeup notification event should be
>>> delivered to the pCPU which the vCPU was blocked on. And in kernel's
>>> point of view, the irq is not associated with the wakeup vector, right?
>>
>> That is correct indeed.  It is not associated to the wakeup vector,
>> hence this patch is right, I think.
>>
>> However, the wakeup vector has the same function as the VFIO interrupt
>> handler, so you could argue that it is tied to the host affinity
>> rather than the guest.  Let's wait for Yang to answer.
> 
> Actually, that's my original question too. I am wondering what happens if the user changes the assigned device's affinity in host's /proc/irq/? If ignore it is acceptable, then this patch is ok. But it seems the discussion out of my scope, need some experts to tell us their idea since it will impact the user experience. 
Hi Yang,
	Originally we have a proposal to return failure when user
sets IRQ affinity through native OS interfaces if an IRQ is in PI
mode. But that proposal will break CPU hot-removal because OS needs
to migrate away all IRQs binding to the CPU to be offlined. Then we
propose saving user IRQ affinity setting without changing hardware
configuration (keeping PI configuration). Later when PI mode is
disabled, the cached affinity setting will be used to setup IRQ
destination for native OS. On the other hand, for IRQ in PI mode,
it won't be delivered to native OS, so user may not sense that
the IRQ is delivered to CPUs other than those in the affinity set.
In that aspect, I think it's acceptable:)
Regards!
Gerry
> 
>>
>> Paolo
> 
> 
> Best regards,
> Yang
> 
> 
