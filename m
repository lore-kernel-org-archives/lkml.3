Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966454AbaFRMcF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 08:32:05 -0400
Received: from smtp.citrix.com ([66.165.176.89]:7176 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966306AbaFRMcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 08:32:04 -0400
X-IronPort-AV: E=Sophos;i="5.01,499,1400025600"; 
   d="scan'208";a="144865924"
Message-ID: <53A186BC.6040107@citrix.com>
Date: Wed, 18 Jun 2014 13:31:56 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>,
        Daniel Kiper <daniel.kiper@oracle.com>
CC: <linux-efi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xenproject.org>,
        <andrew.cooper3@citrix.com>, <boris.ostrovsky@oracle.com>,
        <eshelton@pobox.com>, <hpa@zytor.com>, <ian.campbell@citrix.com>,
        <jbeulich@suse.com>, <jeremy@goop.org>, <konrad.wilk@oracle.com>,
        <matt.fleming@intel.com>, <mingo@redhat.com>, <mjg59@srcf.ucam.org>,
        <stefano.stabellini@eu.citrix.com>, <tglx@linutronix.de>,
        Mark Salter <msalter@redhat.com>
Subject: Re: [PATCH v5 1/7] efi: Use early_mem*() instead of early_io*()
References: <1402678823-24589-1-git-send-email-daniel.kiper@oracle.com> <1402678823-24589-2-git-send-email-daniel.kiper@oracle.com> <20140618121709.GF24049@console-pimps.org>
In-Reply-To: <20140618121709.GF24049@console-pimps.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18/06/14 13:17, Matt Fleming wrote:
> (Pulling in Mark Salter for early_ioremap() knowledge)
> 
> On Fri, 13 Jun, at 07:00:17PM, Daniel Kiper wrote:
>> Use early_mem*() instead of early_io*() because all mapped EFI regions
>> are true RAM not I/O regions. Additionally, I/O family calls do not work
>> correctly under Xen in our case. AIUI, early_io*() maps/unmaps real machine
>> addresses. However, all artificial EFI structures created under Xen live
>> in dom0 memory and should be mapped/unmapped using early_mem*() family
>> calls which map domain memory.
>>
>> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
>> ---
>>  arch/x86/platform/efi/efi.c |   42 +++++++++++++++++++++---------------------
>>  drivers/firmware/efi/efi.c  |    4 ++--
>>  2 files changed, 23 insertions(+), 23 deletions(-)
>>
>> diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
>> index 87fc96b..dd1e351 100644
>> --- a/arch/x86/platform/efi/efi.c
>> +++ b/arch/x86/platform/efi/efi.c
>> @@ -427,7 +427,7 @@ void __init efi_unmap_memmap(void)
>>  {
>>  	clear_bit(EFI_MEMMAP, &efi.flags);
>>  	if (memmap.map) {
>> -		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
>> +		early_memunmap(memmap.map, memmap.nr_map * memmap.desc_size);
>>  		memmap.map = NULL;
>>  	}
>>  }
>> @@ -467,12 +467,12 @@ static int __init efi_systab_init(void *phys)
>>  			if (!data)
>>  				return -ENOMEM;
>>  		}
>> -		systab64 = early_ioremap((unsigned long)phys,
>> -					 sizeof(*systab64));
>> +		systab64 = early_memremap((unsigned long)phys,
>> +						sizeof(*systab64));
> 
> Please don't misalign the arguments :-( This makes the diff harder to
> read when all you're doing is changing the function call. You're
> indentation isn't an improvement.
>  
> As Matthew pointed out we may also need to access EFI mapped flash
> devices.
> 
> Now, the only difference between early_memremap() and early_ioremap(),
> at least on x86, is PAGE_KERNEL vs. PAGE_KERNEL_IO, where PAGE_KERNEL_IO
> has the additional _PAGE_BIT_IOMAP bit set in the pte. But that's a
> software bit for x86.

_PAGE_BIT_IOMAP is supposed to be going away...

> So, even though this change should be harmless, it's not clear to me why
> this change is needed. You say "I/O family calls do not work correctly
> under Xen in our case", but could you provide some more explanation as
> to why they don't work correctly?

_PAGE_BIT_IOMAP causes a Xen PV guest to skip the PFN to MFN conversion
when building the PTE.  Using it for RAM will attempt to map the wrong
machine frame.

David
