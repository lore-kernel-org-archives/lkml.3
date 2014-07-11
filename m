Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbaGKUbE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 16:31:04 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:41590 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934AbaGKUbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 16:31:02 -0400
Message-ID: <53C049DB.3050904@oracle.com>
Date: Fri, 11 Jul 2014 16:32:27 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Daniel Kiper <daniel.kiper@oracle.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, andrew.cooper3@citrix.com,
        david.vrabel@citrix.com, hpa@zytor.com, ian.campbell@citrix.com,
        jbeulich@suse.com, jeremy@goop.org, konrad.wilk@oracle.com,
        matt.fleming@intel.com, mingo@redhat.com,
        stefano.stabellini@eu.citrix.com, tglx@linutronix.de
Subject: Re: [PATCH 2/2] arch/x86/xen: Silence compiler warnings
References: <1405108461-3223-1-git-send-email-daniel.kiper@oracle.com> <1405108461-3223-3-git-send-email-daniel.kiper@oracle.com> <53C04322.1050000@oracle.com> <20140711201050.GJ13620@olila.local.net-space.pl>
In-Reply-To: <20140711201050.GJ13620@olila.local.net-space.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 04:10 PM, Daniel Kiper wrote:
> On Fri, Jul 11, 2014 at 04:03:46PM -0400, Boris Ostrovsky wrote:
>> On 07/11/2014 03:54 PM, Daniel Kiper wrote:
>>> Compiler complains in the following way when x86 32-bit kernel
>>> with Xen support is build:
>>>
>>>    CC      arch/x86/xen/enlighten.o
>>> arch/x86/xen/enlighten.c: In function ‘xen_start_kernel’:
>>> arch/x86/xen/enlighten.c:1726:3: warning: right shift count >= width of type [enabled by default]
>>>
>>> Such line contains following EFI initialization code:
>>>
>>> boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
>>>
>>> There is no issue if x86 64-bit kernel is build. However, 32-bit case
>>> generate warning (even if that code will not be executed because Xen
>>> does not work on 32-bit EFI platforms) due to __pa() returning unsigned long
>>> type which has 32-bits width. So move whole EFI initialization stuff
>>> to separate function and build its body conditionally to avoid above
>>> mentioned warning on x86 32-bit architecture.
>>>
>>> Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
>>> ---
>>>   arch/x86/xen/enlighten.c |   35 ++++++++++++++++++++++-------------
>>>   1 file changed, 22 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
>>> index bc89647..6abec74 100644
>>> --- a/arch/x86/xen/enlighten.c
>>> +++ b/arch/x86/xen/enlighten.c
>>> @@ -1516,12 +1516,32 @@ static void __init xen_pvh_early_guest_init(void)
>>>   #endif
>>>   }
>>> +static void __init xen_efi_init(void)
>>> +{
>>> +#ifdef CONFIG_XEN_EFI
>>> +	efi_system_table_t *efi_systab_xen;
>>> +
>>> +	efi_systab_xen = xen_efi_probe();
>>> +
>>> +	if (efi_systab_xen == NULL)
>>> +		return;
>>> +
>>> +	strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
>>> +			sizeof(boot_params.efi_info.efi_loader_signature));
>>> +	boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
>>> +	boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
>>> +
>>> +	set_bit(EFI_BOOT, &efi.flags);
>>> +	set_bit(EFI_PARAVIRT, &efi.flags);
>>> +	set_bit(EFI_64BIT, &efi.flags);
>>> +#endif
>>> +}
>>> +
>>>   /* First C function to be called on Xen boot */
>>>   asmlinkage __visible void __init xen_start_kernel(void)
>>>   {
>>>   	struct physdev_set_iopl set_iopl;
>>>   	int rc;
>>> -	efi_system_table_t *efi_systab_xen;
>>>   	if (!xen_start_info)
>>>   		return;
>>> @@ -1717,18 +1737,7 @@ asmlinkage __visible void __init xen_start_kernel(void)
>>>   	xen_setup_runstate_info(0);
>>> -	efi_systab_xen = xen_efi_probe();
>>> -
>>> -	if (efi_systab_xen) {
>>> -		strncpy((char *)&boot_params.efi_info.efi_loader_signature, "Xen",
>>> -				sizeof(boot_params.efi_info.efi_loader_signature));
>>> -		boot_params.efi_info.efi_systab = (__u32)__pa(efi_systab_xen);
>>> -		boot_params.efi_info.efi_systab_hi = (__u32)(__pa(efi_systab_xen) >> 32);
>>> -
>>> -		set_bit(EFI_BOOT, &efi.flags);
>>> -		set_bit(EFI_PARAVIRT, &efi.flags);
>>> -		set_bit(EFI_64BIT, &efi.flags);
>>> -	}
>>> +	xen_efi_init();
>> I'd put ifdef CONFIG_XEN_EFI around the call instead of having it
>> inside the routine.
> Well, I thought about that a bit and I prefer function like Konrad.
> Could you agree with him which solution do you (as maintainers) prefer?
>

I am not arguing against having a separate routine. All I am saying is 
that calling xen_efi_init() when CONFIG_XEN_EFI is not defined doesn't 
look logical. It will also add an unnecessary call (although compiler 
may optimize it out).

-boris
