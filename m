Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397AbaHEIpu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:45:50 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:41819 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757245AbaHEIps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:45:48 -0400
Date: Tue, 5 Aug 2014 09:45:42 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Bruno =?iso-8859-1?Q?Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140805084542.GM15082@console-pimps.org>
References: <20140804113435.34ed8c76@pluto>
 <20140804122728.GH15082@console-pimps.org>
 <20140804150627.4563b6a7@pluto>
 <20140804135452.GJ15082@console-pimps.org>
 <20140805100242.425e1093@pluto>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140805100242.425e1093@pluto>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 05 Aug, at 10:02:42AM, Bruno Prémont wrote:
> 
> I tried in setup_arch(), but system still keeps rebooting.
> 
> Working backwards I got to x86_64_start_kernel() in
> arch/x86/kernel/head64.c but system is still rebooting.
 
Thanks for doing this. I'm sure it was a major PITA ;-)

> Not sure what happens before x86_64_start_kernel() is called, it seems
> to be called from ASM code in arch/x86/kernel/head_64.S.
 
Yep. Roughly the code flow goes like this (chronologically),

  efi_pe_entry()	[arch/x86/boot/compressed/head_64.S]
    efi_main()		[arch/x86/boot/compressed/eboot.c]
  startup_64		[arch/x86/kernel/head_64.S]
  secondary_startup64	[arch/x86/kernel/head_64.S]
  x86_64_start_kernel()	[arch/x86/kernel/head64.c]

> > Meanwhile I'm going to go and stare at the EFI boot stub code and
> > instrument OVMF to check for more memory corruption bugs like the one
> > Michael found in commit c7fb93ec51d4 ("x86/efi: Include a .bss section
> > within the PE/COFF headers").
> 
> If there are places between exit_boot() in
> arch/x86/boot/compressed/eboot.c and x86_64_start_kernel() where I
> should include such loops, please tell!

I guess we need to verify efi_main() actually exits correctly. So a
while (1); loop at the end of that function would be useful.

Assuming that does actually hang, you get the fun of rummaging around in
the early assembly code, where you can use something like this,

bruno:
	hlt
	jmp bruno

to try and force a hang.

Could you also attach your .config? In particular I'm wondering whether
you've got CONFIG_RELOCATBLE enabled.

-- 
Matt Fleming, Intel Open Source Technology Center
