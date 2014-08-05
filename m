Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbaHEOVM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 10:21:12 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:34703 "EHLO
	smptrelay.restena.lu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752121AbaHEOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 10:21:10 -0400
Date: Tue, 5 Aug 2014 16:21:07 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: P J P <ppandit@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 3.12 to 3.13 boot regression bisected - still applies to 3.16
Message-ID: <20140805162107.4698f717@pluto>
In-Reply-To: <20140805125548.GP15082@console-pimps.org>
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
	<20140805125548.GP15082@console-pimps.org>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Aug 2014 13:55:48 +0100 Matt Fleming wrote:
> I suspect if you enable CONFIG_RELOCATABLE things will work just fine.
> I've actually got a patch to force that option if CONFIG_EFI_STUB is
> enabled to mitigate this exact problem. Could you try it out (see
> below)?
> 
> Without CONFIG_RELOCATABLE the early boot code will try and decompress
> the kernel image to LOAD_PHYSICAL_ADDR. That may have worked in the days
> of BIOS, when it was reasonable to assume that nothing important would
> be sitting in the 0x10000000 region, but that's just not so for UEFI. 
> 
> For UEFI we need to request memory from the firmware and not stray
> outside the bounds of those allocations. Otherwise there's the potential
> that we'll trash bits of the firmware's code/data.

Thanks, enabling CONFIG_RELOCATABLE allows kernel to successfully boot!

So you can add my tested-by to the patch.


If of interest, memory layout information as reported by 3.16 with
CONFIG_RELOCATABLE enabled:
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007da97fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007da98000-0x000000007dae5fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007dae6000-0x000000007db80fff] ACPI data
[    0.000000] BIOS-e820: [mem 0x000000007db81000-0x000000007dd89fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007dd8a000-0x000000007f362fff] reserved
[    0.000000] BIOS-e820: [mem 0x000000007f363000-0x000000007f363fff] usable
[    0.000000] BIOS-e820: [mem 0x000000007f364000-0x000000007f3e9fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000007f3ea000-0x000000007f7fffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000047fffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] e820: update [mem 0x6d6e3018-0x6d6f7657] usable ==> usable
[    0.000000] e820: update [mem 0x6d6da018-0x6d6e2057] usable ==> usable
[    0.000000] extended physical RAM map:
[    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000009ffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000000100000-0x000000006d6da017] usable
[    0.000000] reserve setup_data: [mem 0x000000006d6da018-0x000000006d6e2057] usable
[    0.000000] reserve setup_data: [mem 0x000000006d6e2058-0x000000006d6e3017] usable
[    0.000000] reserve setup_data: [mem 0x000000006d6e3018-0x000000006d6f7657] usable
[    0.000000] reserve setup_data: [mem 0x000000006d6f7658-0x000000007da97fff] usable
[    0.000000] reserve setup_data: [mem 0x000000007da98000-0x000000007dae5fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007dae6000-0x000000007db80fff] ACPI data
[    0.000000] reserve setup_data: [mem 0x000000007db81000-0x000000007dd89fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000007dd8a000-0x000000007f362fff] reserved
[    0.000000] reserve setup_data: [mem 0x000000007f363000-0x000000007f363fff] usable
[    0.000000] reserve setup_data: [mem 0x000000007f364000-0x000000007f3e9fff] ACPI NVS
[    0.000000] reserve setup_data: [mem 0x000000007f3ea000-0x000000007f7fffff] usable
[    0.000000] reserve setup_data: [mem 0x0000000080000000-0x000000008fffffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] reserve setup_data: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000047fffffff] usable
[    0.000000] efi: EFI v2.31 by American Megatrends
[    0.000000] efi:  ACPI=0x7db05000  ACPI 2.0=0x7db05000  SMBIOS=0xf04c0  MPS=0xfd4b0 
[    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000008000) (0MB)
[    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000008000-0x000000000000e000) (0MB)
[    0.000000] efi: mem02: type=7, attr=0xf, range=[0x000000000000e000-0x000000000003f000) (0MB)
[    0.000000] efi: mem03: type=4, attr=0xf, range=[0x000000000003f000-0x0000000000050000) (0MB)
[    0.000000] efi: mem04: type=3, attr=0xf, range=[0x0000000000050000-0x00000000000a0000) (0MB)
[    0.000000] efi: mem05: type=7, attr=0xf, range=[0x0000000000100000-0x0000000001000000) (15MB)
[    0.000000] efi: mem06: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001100000) (1MB)
[    0.000000] efi: mem07: type=7, attr=0xf, range=[0x0000000001100000-0x0000000002000000) (15MB)
[    0.000000] efi: mem08: type=2, attr=0xf, range=[0x0000000002000000-0x00000000038e7000) (24MB)
[    0.000000] efi: mem09: type=7, attr=0xf, range=[0x00000000038e7000-0x000000006d6d9000) (1693MB)
[    0.000000] efi: mem10: type=2, attr=0xf, range=[0x000000006d6d9000-0x000000006d6f9000) (0MB)
[    0.000000] efi: mem11: type=1, attr=0xf, range=[0x000000006d6f9000-0x000000006efe0000) (24MB)
[    0.000000] efi: mem12: type=7, attr=0xf, range=[0x000000006efe0000-0x0000000071d8d000) (45MB)
[    0.000000] efi: mem13: type=4, attr=0xf, range=[0x0000000071d8d000-0x0000000071e5c000) (0MB)
[    0.000000] efi: mem14: type=7, attr=0xf, range=[0x0000000071e5c000-0x0000000071e60000) (0MB)
[    0.000000] efi: mem15: type=4, attr=0xf, range=[0x0000000071e60000-0x0000000071e90000) (0MB)
[    0.000000] efi: mem16: type=7, attr=0xf, range=[0x0000000071e90000-0x0000000071eb5000) (0MB)
[    0.000000] efi: mem17: type=4, attr=0xf, range=[0x0000000071eb5000-0x0000000071fe6000) (1MB)
[    0.000000] efi: mem18: type=7, attr=0xf, range=[0x0000000071fe6000-0x0000000071fef000) (0MB)
[    0.000000] efi: mem19: type=4, attr=0xf, range=[0x0000000071fef000-0x0000000071ff1000) (0MB)
[    0.000000] efi: mem20: type=7, attr=0xf, range=[0x0000000071ff1000-0x0000000071ff5000) (0MB)
[    0.000000] efi: mem21: type=4, attr=0xf, range=[0x0000000071ff5000-0x0000000071ff6000) (0MB)
[    0.000000] efi: mem22: type=7, attr=0xf, range=[0x0000000071ff6000-0x000000007200f000) (0MB)
[    0.000000] efi: mem23: type=4, attr=0xf, range=[0x000000007200f000-0x0000000072010000) (0MB)
[    0.000000] efi: mem24: type=7, attr=0xf, range=[0x0000000072010000-0x0000000072013000) (0MB)
[    0.000000] efi: mem25: type=4, attr=0xf, range=[0x0000000072013000-0x0000000072017000) (0MB)
[    0.000000] efi: mem26: type=7, attr=0xf, range=[0x0000000072017000-0x0000000072018000) (0MB)
[    0.000000] efi: mem27: type=4, attr=0xf, range=[0x0000000072018000-0x0000000072019000) (0MB)
[    0.000000] efi: mem28: type=7, attr=0xf, range=[0x0000000072019000-0x0000000072061000) (0MB)
[    0.000000] efi: mem29: type=4, attr=0xf, range=[0x0000000072061000-0x00000000720a6000) (0MB)
[    0.000000] efi: mem30: type=7, attr=0xf, range=[0x00000000720a6000-0x00000000720ab000) (0MB)
[    0.000000] efi: mem31: type=4, attr=0xf, range=[0x00000000720ab000-0x00000000720d1000) (0MB)
[    0.000000] efi: mem32: type=7, attr=0xf, range=[0x00000000720d1000-0x00000000720dc000) (0MB)
[    0.000000] efi: mem33: type=4, attr=0xf, range=[0x00000000720dc000-0x00000000720dd000) (0MB)
[    0.000000] efi: mem34: type=7, attr=0xf, range=[0x00000000720dd000-0x00000000720f9000) (0MB)
[    0.000000] efi: mem35: type=4, attr=0xf, range=[0x00000000720f9000-0x000000007232e000) (2MB)
[    0.000000] efi: mem36: type=7, attr=0xf, range=[0x000000007232e000-0x0000000072332000) (0MB)
[    0.000000] efi: mem37: type=4, attr=0xf, range=[0x0000000072332000-0x0000000072357000) (0MB)
[    0.000000] efi: mem38: type=7, attr=0xf, range=[0x0000000072357000-0x000000007235e000) (0MB)
[    0.000000] efi: mem39: type=4, attr=0xf, range=[0x000000007235e000-0x000000007235f000) (0MB)
[    0.000000] efi: mem40: type=7, attr=0xf, range=[0x000000007235f000-0x0000000072365000) (0MB)
[    0.000000] efi: mem41: type=4, attr=0xf, range=[0x0000000072365000-0x0000000072370000) (0MB)
[    0.000000] efi: mem42: type=7, attr=0xf, range=[0x0000000072370000-0x0000000072376000) (0MB)
[    0.000000] efi: mem43: type=4, attr=0xf, range=[0x0000000072376000-0x000000007237f000) (0MB)
[    0.000000] efi: mem44: type=7, attr=0xf, range=[0x000000007237f000-0x0000000072380000) (0MB)
[    0.000000] efi: mem45: type=4, attr=0xf, range=[0x0000000072380000-0x000000007d0ff000) (173MB)
[    0.000000] efi: mem46: type=7, attr=0xf, range=[0x000000007d0ff000-0x000000007d5e4000) (4MB)
[    0.000000] efi: mem47: type=3, attr=0xf, range=[0x000000007d5e4000-0x000000007da98000) (4MB)
[    0.000000] efi: mem48: type=0, attr=0xf, range=[0x000000007da98000-0x000000007daa7000) (0MB)
[    0.000000] efi: mem49: type=0, attr=0xf, range=[0x000000007daa7000-0x000000007dae6000) (0MB)
[    0.000000] efi: mem50: type=9, attr=0xf, range=[0x000000007dae6000-0x000000007db05000) (0MB)
[    0.000000] efi: mem51: type=9, attr=0xf, range=[0x000000007db05000-0x000000007db81000) (0MB)
[    0.000000] efi: mem52: type=10, attr=0xf, range=[0x000000007db81000-0x000000007dc6f000) (0MB)
[    0.000000] efi: mem53: type=10, attr=0xf, range=[0x000000007dc6f000-0x000000007dd8a000) (1MB)
[    0.000000] efi: mem54: type=6, attr=0x800000000000000f, range=[0x000000007dd8a000-0x000000007e1d2000) (4MB)
[    0.000000] efi: mem55: type=6, attr=0x800000000000000f, range=[0x000000007e1d2000-0x000000007e23e000) (0MB)
[    0.000000] efi: mem56: type=6, attr=0x800000000000000f, range=[0x000000007e23e000-0x000000007e240000) (0MB)
[    0.000000] efi: mem57: type=6, attr=0x800000000000000f, range=[0x000000007e240000-0x000000007f2fc000) (16MB)
[    0.000000] efi: mem58: type=5, attr=0x800000000000000f, range=[0x000000007f2fc000-0x000000007f310000) (0MB)
[    0.000000] efi: mem59: type=5, attr=0x800000000000000f, range=[0x000000007f310000-0x000000007f363000) (0MB)
[    0.000000] efi: mem60: type=4, attr=0xf, range=[0x000000007f363000-0x000000007f364000) (0MB)
[    0.000000] efi: mem61: type=10, attr=0xf, range=[0x000000007f364000-0x000000007f3ea000) (0MB)
[    0.000000] efi: mem62: type=4, attr=0xf, range=[0x000000007f3ea000-0x000000007f539000) (1MB)
[    0.000000] efi: mem63: type=3, attr=0xf, range=[0x000000007f539000-0x000000007f7d7000) (2MB)
[    0.000000] efi: mem64: type=4, attr=0xf, range=[0x000000007f7d7000-0x000000007f7dd000) (0MB)
[    0.000000] efi: mem65: type=3, attr=0xf, range=[0x000000007f7dd000-0x000000007f7e1000) (0MB)
[    0.000000] efi: mem66: type=4, attr=0xf, range=[0x000000007f7e1000-0x000000007f800000) (0MB)
[    0.000000] efi: mem67: type=7, attr=0xf, range=[0x0000000100000000-0x0000000480000000) (14336MB)
[    0.000000] efi: mem68: type=11, attr=0x8000000000000001, range=[0x0000000080000000-0x0000000090000000) (256MB)
[    0.000000] efi: mem69: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
[    0.000000] efi: mem70: type=11, attr=0x8000000000000001, range=[0x00000000ff000000-0x0000000100000000) (16MB)
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI: FUJITSU PRIMERGY RX200 S7/D3032-A1, BIOS V4.6.5.3 R2.21.0 for D3032-A1x 04/05/2013
