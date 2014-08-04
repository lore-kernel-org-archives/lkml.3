Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaHDNGc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:06:32 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:34140 "EHLO
	smptrelay.restena.lu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751394AbaHDNGb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:06:31 -0400
Date: Mon, 4 Aug 2014 15:06:27 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140804150627.4563b6a7@pluto>
In-Reply-To: <20140804122728.GH15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
	<20140804122728.GH15082@console-pimps.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

On Mon, 4 Aug 2014 13:27:28 +0100 Matt Fleming wrote:
> On Mon, 04 Aug, at 11:34:35AM, Bruno Prémont wrote:
> > Hi,
> > 
> > Since 3.13 kernels with built-in initrd fail to boot on Fujitsu hardware
> > in EFI mode (efi stub) though the exact same kernel binary does boot in
> > BIOS mode (grub).
> > Interestingly EFI kernels with different config do boot under VMWare.
> > 
> > Your patch "initramfs: read CONFIG_RD_ variables for initramfs
> > compression" is the trigger.
> > 
> > 
> > Is something missing in EFI stub or why do things behave differently?
>  
> Nuts. I suspect it's an EFI boot stub bug. Have you definitely tried out
> 3.16? In particular the following commit might make a difference,
>
>   commit c7fb93ec51d4
>   Author: Michael Brown <mbrown@fensystems.co.uk>
>   Date:   Thu Jul 10 12:26:20 2014 +0100
> 
>       x86/efi: Include a .bss section within the PE/COFF headers
>     
>       The PE/COFF headers currently describe only the initialised-data
>       portions of the image, and result in no space being allocated for the
>       uninitialised-data portions.  Consequently, the EFI boot stub will end
>       up overwriting unexpected areas of memory, with unpredictable results.
>     
>       Fix by including a .bss section in the PE/COFF headers (functionally
>       equivalent to the init_size field in the bzImage header).
>     
>       Signed-off-by: Michael Brown <mbrown@fensystems.co.uk>
>       Cc: Thomas Bächler <thomas@archlinux.org>
>       Cc: Josh Boyer <jwboyer@fedoraproject.org>
>       Cc: <stable@vger.kernel.org>
>       Signed-off-by: Matt Fleming <matt.fleming@intel.com>

Yes, I did as I have seen that patch flying by, but it did not help
(I tried at 3.16-rc7).

On 3.16-rc7 I even tried adding earlyprintk=efi,keep, console=efi,
ignore_loglevel and added some efi_printk() in EFI stub (in the spirit
of https://bugzilla.kernel.org/show_bug.cgi?id=68761)
The last message I get is my efi_printk() right before exiting boot
services. Without my efi_printk() there is no output at all.

Then system reboots.

There is no output on serial console either (via BMC),
(earlycon=uart,io,0x3f8,115200 or earlyprintk=serial,ttyS0,115200)


I even tried without initrd (setting CONFIG_INITRAMFS_SOURCE="")
and got the same end-result.

> > Looking at compiled kernel with and without this patch the resulting
> > bzImage is similar in size but in build directory I get:
> 
> Could you send me the initrd image? I'd like to try and reproduce this
> on my end, even though I regularly boot with a built-in initrd.

I could share a slightly modified one, replacing the
contained /etc/passwd. It's about 16MiB in size due to RAID controller
management blobs for recovery. Except for that it just tries to find
ROOT partition, setting up dmcrypt if needed.


Note: System is Fujitsu Primergy RX200 S7 server, BIOS revisions
tested: R2.21.0 and R2.25.0.
The same initrd works on Fujitsu laptop (Lifebook U904, EFI, other kernel
config) works though.



Any hint on how to find out what fails would be nice!
initrd issues tend not to be easy to debug (it would help if initrd
issues could be reported at the time kernel tries to start init - e.g.
when console outputs are up and running).


Bruno
