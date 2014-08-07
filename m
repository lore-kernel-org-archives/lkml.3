Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757488AbaHGJds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 05:33:48 -0400
Received: from mga09.intel.com ([134.134.136.24]:29714 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbaHGJdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 05:33:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,816,1400050800"; 
   d="scan'208";a="584660896"
Message-ID: <53E3475A.9090301@intel.com>
Date: Thu, 07 Aug 2014 17:31:06 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/OSL: Remove RCU in the osl.c to avoid dead lock
 with cpu hot plug
References: <1407141608-28920-1-git-send-email-tianyu.lan@intel.com> <1655155.Bsn9BIJnyn@vostro.rjw.lan> <53E19175.208@intel.com> <5565710.HfsfjXfcL3@vostro.rjw.lan>
In-Reply-To: <5565710.HfsfjXfcL3@vostro.rjw.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年08月07日 03:09, Rafael J. Wysocki wrote:
> On Wednesday, August 06, 2014 10:22:45 AM Lan Tianyu wrote:
>> On 2014年08月06日 09:24, Rafael J. Wysocki wrote:
>>> On Monday, August 04, 2014 04:40:08 PM Lan Tianyu wrote:
> 
> [cut]
> 
>>>> @@ -298,29 +298,29 @@ void __iomem *acpi_os_get_iomem(acpi_physical_address phys, unsigned int size)
>>>>  {
>>>>  	struct acpi_ioremap *map;
>>>>  	void __iomem *virt = NULL;
>>>> +	unsigned long flags;
>>>>  
>>>> -	mutex_lock(&acpi_ioremap_lock);
>>>> +	spin_lock_irqsave(&acpi_ioremap_lock, flags);
>>>
>>> Why do you need to do _irqsave here?  It was a mutex before, after all,
>>> so it can't be called from interrupt context.
>>>
>>> In other places below too.
>>
>> Original code uses RCU lock to protect acpi_ioremaps list in the
>> acpi_os_read/write_memory() which will be called in apei_read/write().
>> apei_read/write() will be called in the interrupt from APEI comments.
> 
> But acpi_os_get_iomem() won't be called from interrupt context and should use
> spin_lock_irq() instead of _irqsave.  This also applies to the other places
> that use the mutex.

Yes, that's correct. Sorry. I misunderstood what you meant.

> 
>> Now replace RCU with acpi_ioremap_lock and the lock will be called in
>> the interrupt. So redefine it to spin lock. From history,
>> acpi_ioremap_lock was spin lock before adding RCU support.
> 
> And it had scalability problems IIRC.
> 
> Did you consider using SRCU instead of going back to the spinlock?

No, I will have a look at SRCU.

> 
> Rafael
> 


-- 
Best regards
Tianyu Lan
