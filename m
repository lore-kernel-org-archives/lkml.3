Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718Ab3DSLNT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 07:13:19 -0400
Received: from relay3.blacknight.com ([78.153.203.206]:41057 "EHLO
	relay3.blacknight.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757162Ab3DSLNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 07:13:18 -0400
Message-ID: <5171274B.7090500@nexus-software.ie>
Date: Fri, 19 Apr 2013 12:15:23 +0100
From: "Bryan O'Donoghue" <bryan.odonoghue.lkml@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: matt@console-pimps.org, matthew.garrett@nebula.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, darren.hart@intel.com,
        josh@joshtriplett.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode V2
References: <1366236341-22615-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie> <20130419055813.GA16443@kroah.com>
In-Reply-To: <20130419055813.GA16443@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/04/13 06:58, Greg KH wrote:
>> This patch gives the option to switch off that behavior - if your BIOS
>> has neither BGRT - nor bugs that require mapping of EFI boot code/data
>
> No, never add new boot options, no users, or distros, know to set them.
> Isn't there some way we can dynamically determine this instead?

Peter, Greg.

There are three issues to consider here

1: Some UEFI BIOS is buggy and the EFI_RUNTIME_SERVICES code - actually 
touches EFI_BOOT_MEMORY. Boot memory should be completely untouched 
after an entity calls ExitBootServices() - typically done by an EFI 
aware bootloader before handing off to Linux.

2: Existing code maps EFI_BOOT_MEMORY in arch/x86/platform/efi/efi.c.
Initially it looked to me as though you could probe for ACPI::BGRT - 
look for an ACPI object sometimes stored in EFI_BOOT_MEMORY and use that 
to determine if EFI_BOOT_MEMORY should be mapped. I wasn't aware #1 
above was also a concern. So just probing for something - doesn't appear 
to fly

3: Standards compliant EFI BIOS - like the reference EFI 2.3.1 code we 
have on my project, has neither of the two above problems to work around

So we can.

1. Just silently map EFI_BOOT_MEMORY - even on unbuggy platforms like #3 
- or we can

2. Introduce some sort of intelligence - a parameter somewhere to tell 
the efi_enter_virtual mode if/when to map EFI_BOOT_MEMORY.

3. Just go the suggested route from Josh
#ifdef CONFIG_X86_64
			if (md->type != EFI_BOOT_SERVICES_CODE &&
			    md->type != EFI_BOOT_SERVICES_DATA)
#endif

Option #3 - so long as it doesn't break ia32::BGRT systems works for me.
