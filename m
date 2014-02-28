Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751240AbaB1GIB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 01:08:01 -0500
Received: from mga02.intel.com ([134.134.136.20]:18458 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbaB1GIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 01:08:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,560,1389772800"; 
   d="scan'208";a="483345839"
Message-ID: <531027BE.2010807@linux.intel.com>
Date: Fri, 28 Feb 2014 14:07:58 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@linux.intel.com>,
        Len.Brown@intel.com, Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53100C8D.1060001@linux.intel.com> <20140228045637.GA28257@srcf.ucam.org> <53101D1D.9010202@linux.intel.com> <20140228055629.GA847@srcf.ucam.org>
In-Reply-To: <20140228055629.GA847@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/28 13:56, Matthew Garrett wrote:
> On Fri, Feb 28, 2014 at 01:22:37PM +0800, Li, Aubrey wrote:
>> On 2014/2/28 12:56, Matthew Garrett wrote:
>>> EFI reboot is still somewhat unreliable - it may be safe after the 
>>> recent patches to provide a 1:1 mapping.
>>
>> So it's acceptable to put EFI in the default list.
> 
> Probably, once we've got those patches landed (I've lost track of 
> whether they're in 3.13 or aimed at 3.14)

You didn't look the reference I quoted in the patch.

It's stable if 32/64 bit linux call the corresponding 32/64bit EFI
runtime service. Matt Fleming's mixed mode is aiming at 3.15:

http://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/log/?h=mixed-mode

> 
>>> CF9 is, as far as I know, not  part of any spec, so it seems like a bad
>>> idea to put it in the default list.
>>
>> Any hurt known if put it in the default list?
> 
> Mm. Not all x86 platforms support cf8/cf9 (Moorestown, for instance) and 
> so it's theoretically possible that they'd put some different hardware 
> there instead. But then, Moorestown probably has its own reboot code, so 
> that may not matter?

Yes, Moorestown has its own machine_ops. Instead of the system hanging
after issue "reboot" command, I think and suggest CF9 is worth to have a
try.

> 
>>>
>>> What do the ACPI reboot vectors look like on these systems?
>>
>> Reset register address: 0xCF9
>> Value to cause reset:   0x6
> 
> Huh. But that's almost exactly what the PCI reboot code would do. Why 
> does the PCI method work but the ACPI one fail? Does it really depend on 
> ORing the original value with the reset value? Or is the timing just 
> somehow marginal?

reboot returns at:

if (!(acpi_gbl_FADT.flags & ACPI_FADT_RESET_REGISTER))
                return;

This is a ACPI bug or intention, who knows.

> 
>>> This is definitely incorrect. The ACPI write *must* occur twice in order 
>>> to be effective on various systems. EFI shouldn't be attempted until 
>>> after the second ACPI write.
>>>
>>
>> Do we have any spec mentioned that?
> 
> Nope. This is entirely unspecified, it's just how things work - several 
> vendors use cf9 for the ACPI reboot vector, and there have to be two 
> writes to cf9 to trigger the reboot. Windows attempts the write twice, 
> and as a result things work.
> 

Thanks to clarify this, I'll refine the patch, including CF9 if you
don't have more concern.

-Aubrey
