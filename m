Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbaHEICx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:02:53 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:34520 "EHLO
	smptrelay.restena.lu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757005AbaHEICr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:02:47 -0400
Date: Tue, 5 Aug 2014 10:02:42 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140805100242.425e1093@pluto>
In-Reply-To: <20140804135452.GJ15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
	<20140804122728.GH15082@console-pimps.org>
	<20140804150627.4563b6a7@pluto>
	<20140804135452.GJ15082@console-pimps.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014 14:54:52 +0100 Matt Fleming wrote:

> On Mon, 04 Aug, at 03:06:27PM, Bruno Prémont wrote:
> > 
> > Yes, I did as I have seen that patch flying by, but it did not help
> > (I tried at 3.16-rc7).
>  
> :-( Thanks for testing.
> 
> > On 3.16-rc7 I even tried adding earlyprintk=efi,keep, console=efi,
> > ignore_loglevel and added some efi_printk() in EFI stub (in the spirit
> > of https://bugzilla.kernel.org/show_bug.cgi?id=68761)
> > The last message I get is my efi_printk() right before exiting boot
> > services. Without my efi_printk() there is no output at all.
> > 
> > Then system reboots.
> 
> OK, so the fact that the system reboots suggests that the boot
> stub/kernel caused a fault.
>  
> > There is no output on serial console either (via BMC),
> > (earlycon=uart,io,0x3f8,115200 or earlyprintk=serial,ttyS0,115200)
> > 
> > 
> > I even tried without initrd (setting CONFIG_INITRAMFS_SOURCE="")
> > and got the same end-result.
> 
> Oh that's interesting.
> 
> > I could share a slightly modified one, replacing the
> > contained /etc/passwd. It's about 16MiB in size due to RAID controller
> > management blobs for recovery. Except for that it just tries to find
> > ROOT partition, setting up dmcrypt if needed.
>  
> This shouldn't be necessary if you can reproduce the issue without an
> initrd as you stated above.

I just verified CONFIG_INITRAMFS_SOURCE="" on 3.16 and it reboots.

> > Any hint on how to find out what fails would be nice!
> > initrd issues tend not to be easy to debug (it would help if initrd
> > issues could be reported at the time kernel tries to start init - e.g.
> > when console outputs are up and running).
> 
> I don't think this is necessarily an initrd issue.
> 
> The way that I would debug this is to insert while(1); into strategic
> places. Yes, it's lame and time consuming, but it's effective.
> 
> My first suggestion would be setup_arch(). In particular, because your
> machine is resetting, I'd guess that the kernel's early trap handlers
> haven't yet been installed.
> 
> So throw a,
> 
> 	while (1);
> 
> in there and see if you can get your machine to hang instead of reset.
> If it doesn't hang, the reset occurs earlier in boot - work backwards.
> If it does hang then you know that execution gets at least that far -
> work forwards. Like I said, lame but effective.

I tried in setup_arch(), but system still keeps rebooting.

Working backwards I got to x86_64_start_kernel() in
arch/x86/kernel/head64.c but system is still rebooting.

Not sure what happens before x86_64_start_kernel() is called, it seems
to be called from ASM code in arch/x86/kernel/head_64.S.

> Meanwhile I'm going to go and stare at the EFI boot stub code and
> instrument OVMF to check for more memory corruption bugs like the one
> Michael found in commit c7fb93ec51d4 ("x86/efi: Include a .bss section
> within the PE/COFF headers").

If there are places between exit_boot() in
arch/x86/boot/compressed/eboot.c and x86_64_start_kernel() where I
should include such loops, please tell!

Bruno
