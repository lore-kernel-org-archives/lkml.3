Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753841AbaHEMz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 08:55:56 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:35561 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaHEMzy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 08:55:54 -0400
Date: Tue, 5 Aug 2014 13:55:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140805125548.GP15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
 <20140804122728.GH15082@console-pimps.org>
 <20140804150627.4563b6a7@pluto>
 <20140804135452.GJ15082@console-pimps.org>
 <20140805100242.425e1093@pluto>
 <20140805084542.GM15082@console-pimps.org>
 <20140805111330.3cf9319f@pluto>
 <20140805091848.GN15082@console-pimps.org>
 <20140805135130.2d180b69@pluto>
 <20140805141142.437ecb17@pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140805141142.437ecb17@pluto>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug, at 02:11:42PM, Bruno Prémont wrote:
> 
> arch/x86/boot/compressed/head_64.S
> 341 /*
> 342  * Copy the compressed kernel to the end of our buffer
> 343  * where decompression in place becomes safe.
> 344  */
> 345         pushq   %rsi
> 346         leaq    (_bss-8)(%rip), %rsi
> 347         leaq    (_bss-8)(%rbx), %rdi
> 348         movq    $_bss /* - $startup_32 */, %rcx
> 349         shrq    $3, %rcx
> 350         std
> 
> code gets up to here
> 
> 351         rep     movsq
> 
> this location is never reached but instead system reboots
> 
> 352         cld
> 353         popq    %rsi
> 354 
> 355 /*      
> 356  * Jump to the relocated address.
> 357  */

Excellent. Thanks for doing this, it's all starting to make sense now.

I suspect if you enable CONFIG_RELOCATABLE things will work just fine.
I've actually got a patch to force that option if CONFIG_EFI_STUB is
enabled to mitigate this exact problem. Could you try it out (see
below)?

Without CONFIG_RELOCATABLE the early boot code will try and decompress
the kernel image to LOAD_PHYSICAL_ADDR. That may have worked in the days
of BIOS, when it was reasonable to assume that nothing important would
be sitting in the 0x10000000 region, but that's just not so for UEFI. 

For UEFI we need to request memory from the firmware and not stray
outside the bounds of those allocations. Otherwise there's the potential
that we'll trash bits of the firmware's code/data.

---

>From b9ffb908e18b11be1d89e4c39bee5d4671d3fa6f Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Fri, 11 Jul 2014 08:45:25 +0100
Subject: [PATCH] x86/efi: Enforce CONFIG_RELOCATABLE for EFI boot stub
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Without CONFIG_RELOCATABLE the early boot code will decompress the
kernel to LOAD_PHYSICAL_ADDR. While this may have been fine in the BIOS
days, that isn't going to fly with UEFI since parts of the firmware
code/data may be located at LOAD_PHYSICAL_ADDR.

Straying outside of the bounds of the regions we've explicitly requested
from the firmware will cause all sorts of trouble. Bruno reports that
his machine resets while trying to decompress the kernel image.

We already go to great pains to ensure the kernel is loaded into a
suitably aligned buffer, it's just that the address isn't necessarily
LOAD_PHYSICAL_ADDR, because we can't guarantee that address isn't in-use
by the firmware.

Explicitly enforce CONFIG_RELOCATABLE for the EFI boot stub, so that we
can load the kernel at any address with the correct alignment.

Reported-by: Bruno Prémont <bonbons@linux-vserver.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 801ed36c2e49..f31b8ae8c81c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1537,6 +1537,7 @@ config EFI
 config EFI_STUB
        bool "EFI stub support"
        depends on EFI
+       select RELOCATABLE
        ---help---
           This kernel feature allows a bzImage to be loaded directly
 	  by EFI firmware without the use of a bootloader.
-- 
1.9.0

-- 
Matt Fleming, Intel Open Source Technology Center
