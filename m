Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640AbaHDNzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 09:55:00 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59887 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaHDNy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 09:54:59 -0400
Date: Mon, 4 Aug 2014 14:54:52 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140804135452.GJ15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
 <20140804122728.GH15082@console-pimps.org>
 <20140804150627.4563b6a7@pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140804150627.4563b6a7@pluto>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 04 Aug, at 03:06:27PM, Bruno Prémont wrote:
> 
> Yes, I did as I have seen that patch flying by, but it did not help
> (I tried at 3.16-rc7).
 
:-( Thanks for testing.

> On 3.16-rc7 I even tried adding earlyprintk=efi,keep, console=efi,
> ignore_loglevel and added some efi_printk() in EFI stub (in the spirit
> of https://bugzilla.kernel.org/show_bug.cgi?id=68761)
> The last message I get is my efi_printk() right before exiting boot
> services. Without my efi_printk() there is no output at all.
> 
> Then system reboots.

OK, so the fact that the system reboots suggests that the boot
stub/kernel caused a fault.
 
> There is no output on serial console either (via BMC),
> (earlycon=uart,io,0x3f8,115200 or earlyprintk=serial,ttyS0,115200)
> 
> 
> I even tried without initrd (setting CONFIG_INITRAMFS_SOURCE="")
> and got the same end-result.

Oh that's interesting.

> I could share a slightly modified one, replacing the
> contained /etc/passwd. It's about 16MiB in size due to RAID controller
> management blobs for recovery. Except for that it just tries to find
> ROOT partition, setting up dmcrypt if needed.
 
This shouldn't be necessary if you can reproduce the issue without an
initrd as you stated above.

> Any hint on how to find out what fails would be nice!
> initrd issues tend not to be easy to debug (it would help if initrd
> issues could be reported at the time kernel tries to start init - e.g.
> when console outputs are up and running).

I don't think this is necessarily an initrd issue.

The way that I would debug this is to insert while(1); into strategic
places. Yes, it's lame and time consuming, but it's effective.

My first suggestion would be setup_arch(). In particular, because your
machine is resetting, I'd guess that the kernel's early trap handlers
haven't yet been installed.

So throw a,

	while (1);

in there and see if you can get your machine to hang instead of reset.
If it doesn't hang, the reset occurs earlier in boot - work backwards.
If it does hang then you know that execution gets at least that far -
work forwards. Like I said, lame but effective.

Meanwhile I'm going to go and stare at the EFI boot stub code and
instrument OVMF to check for more memory corruption bugs like the one
Michael found in commit c7fb93ec51d4 ("x86/efi: Include a .bss section
within the PE/COFF headers").

-- 
Matt Fleming, Intel Open Source Technology Center
