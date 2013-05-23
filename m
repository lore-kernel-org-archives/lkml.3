Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab3EWUck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 16:32:40 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41601 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759346Ab3EWUci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 16:32:38 -0400
Date: Thu, 23 May 2013 15:32:34 -0500
From: Russ Anderson <rja@sgi.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Matthew Garrett <matthew.garrett@nebula.com>, matt.fleming@intel.com,
        linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [regression, bisected] x86: efi: Pass boot services variable
 info to runtime code
Message-ID: <20130523203234.GD20913@sgi.com>
Reply-To: Russ Anderson <rja@sgi.com>
References: <20130522162747.GA20816@sgi.com>
 <20130523115801.GJ14575@console-pimps.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130523115801.GJ14575@console-pimps.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 23, 2013 at 12:58:01PM +0100, Matt Fleming wrote:
> On Wed, 22 May, at 11:27:47AM, Russ Anderson wrote:
> > [    6.062157] EFI Variables Facility v0.08 2004-May-17
> > [    6.067731] BUG: unable to handle kernel paging request at 000000007ca95b10
> > [    6.075519] IP: [<ffff88007dbf2140>] 0xffff88007dbf213f
> 
> This is a bit of a head scratcher. Could you paste the EFI memmap
> entries in your dmesg for the regions that cover 0x7ca95b10 and
> 0x7dbf2140?  My guess would be that they're EFI runtime code regions,
> which would at least explain why we seem to be executing code in the
> direct mapping region (0xffff8800xxxxxxxx).

Yes.  The full e820 and EFI memmap are below.

> Are you booting via the EFI boot stub?

grub2.

FWIW, the EFI related config settings.

gulag1$ grep _EFI .config
CONFIG_EFI_PARTITION=y
CONFIG_EFI=y
CONFIG_EFI_STUB=y
CONFIG_FB_EFI=y
CONFIG_EFI_VARS=y
CONFIG_EFI_VARS_PSTORE=y
CONFIG_EFI_VARS_PSTORE_DEFAULT_DISABLE=y
# CONFIG_EFIVAR_FS is not set

----------------------------------------------------------------------
   57.923378 (    0.023626)| [    0.000000] e820: BIOS-provided physical RAM map:
   57.927705 (    0.004327)| [    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000007efff] usable
   57.987450 (    0.059745)| [    0.000000] BIOS-e820: [mem 0x000000000007f000-0x000000000007ffff] reserved
   57.987563 (    0.000113)| [    0.000000] BIOS-e820: [mem 0x0000000000080000-0x000000000009ffff] usable
   57.987647 (    0.000084)| [    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000007ca9bfff] usable
   57.987734 (    0.000087)| [    0.000000] BIOS-e820: [mem 0x000000007ca9c000-0x000000007ca9cfff] reserved
   57.987827 (    0.000093)| [    0.000000] BIOS-e820: [mem 0x000000007ca9d000-0x000000007caaffff] usable
   57.987914 (    0.000087)| [    0.000000] BIOS-e820: [mem 0x000000007cab0000-0x000000007cceffff] reserved
   57.988002 (    0.000088)| [    0.000000] BIOS-e820: [mem 0x000000007ccf0000-0x000000007d9fefff] usable
   58.003483 (    0.015481)| [    0.000000] BIOS-e820: [mem 0x000000007d9ff000-0x000000007dcfefff] reserved
   58.003590 (    0.000107)| [    0.000000] BIOS-e820: [mem 0x000000007dcff000-0x000000007eefefff] ACPI NVS
   58.007785 (    0.004195)| [    0.000000] BIOS-e820: [mem 0x000000007eeff000-0x000000007efe9fff] ACPI data
   58.015532 (    0.007747)| [    0.000000] BIOS-e820: [mem 0x000000007efea000-0x000000007effffff] usable
   58.023658 (    0.008126)| [    0.000000] BIOS-e820: [mem 0x0000000080000000-0x000000008fffffff] reserved
   58.027770 (    0.004112)| [    0.000000] BIOS-e820: [mem 0x00000000f8000000-0x00000000fdffffff] reserved
   58.035511 (    0.007741)| [    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
   58.043636 (    0.008125)| [    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000083fffffff] usable
   58.051382 (    0.007746)| [    0.000000] BIOS-e820: [mem 0x0000001000000000-0x00000017beffffff] usable
   58.059752 (    0.008370)| [    0.000000] BIOS-e820: [mem 0x000000ff00000000-0x000000ff03dfffff] reserved
   58.067496 (    0.007744)| [    0.000000] BIOS-e820: [mem 0x000000ff03f00000-0x000000ff03ffffff] reserved
   58.075619 (    0.008123)| [    0.000000] BIOS-e820: [mem 0x000000ff07f00000-0x000000ff07ffffff] reserved
   58.083368 (    0.007749)| [    0.000000] BIOS-e820: [mem 0x000000ff40000000-0x000000ff42ffffff] reserved
   58.091738 (    0.008370)| [    0.000000] BIOS-e820: [mem 0x000000ff44000000-0x000000ff46ffffff] reserved
   58.099485 (    0.007747)| [    0.000000] BIOS-e820: [mem 0x000000ff48000000-0x000000ff4affffff] reserved
   58.107609 (    0.008124)| [    0.000000] BIOS-e820: [mem 0x000000ff4c000000-0x000000ff4effffff] reserved
   58.115358 (    0.007749)| [    0.000000] e820: update [mem 0x693c5018-0x693cd057] usable ==> usable
   58.123721 (    0.008363)| [    0.000000] extended physical RAM map:
   58.127414 (    0.003693)| [    0.000000] reserve setup_data: [mem 0x0000000000000000-0x000000000007efff] usable
   58.135786 (    0.008372)| [    0.000000] reserve setup_data: [mem 0x000000000007f000-0x000000000007ffff] reserved
   58.143544 (    0.007758)| [    0.000000] reserve setup_data: [mem 0x0000000000080000-0x000000000009ffff] usable
   58.151681 (    0.008137)| [    0.000000] reserve setup_data: [mem 0x0000000000100000-0x00000000693c5017] usable
   58.159436 (    0.007755)| [    0.000000] reserve setup_data: [mem 0x00000000693c5018-0x00000000693cd057] usable
   58.167810 (    0.008374)| [    0.000000] reserve setup_data: [mem 0x00000000693cd058-0x000000007ca9bfff] usable
   58.175565 (    0.007755)| [    0.000000] reserve setup_data: [mem 0x000000007ca9c000-0x000000007ca9cfff] reserved
   58.183704 (    0.008139)| [    0.000000] reserve setup_data: [mem 0x000000007ca9d000-0x000000007caaffff] usable
   58.195472 (    0.011768)| [    0.000000] reserve setup_data: [mem 0x000000007cab0000-0x000000007cceffff] reserved
   58.203607 (    0.008135)| [    0.000000] reserve setup_data: [mem 0x000000007ccf0000-0x000000007d9fefff] usable
   58.211363 (    0.007756)| [    0.000000] reserve setup_data: [mem 0x000000007d9ff000-0x000000007dcfefff] reserved
   58.219746 (    0.008383)| [    0.000000] reserve setup_data: [mem 0x000000007dcff000-0x000000007eefefff] ACPI NVS
   58.227501 (    0.007755)| [    0.000000] reserve setup_data: [mem 0x000000007eeff000-0x000000007efe9fff] ACPI data
   58.235636 (    0.008135)| [    0.000000] reserve setup_data: [mem 0x000000007efea000-0x000000007effffff] usable
   58.243393 (    0.007757)| [    0.000000] reserve setup_data: [mem 0x0000000080000000-0x000000008fffffff] reserved
   58.255414 (    0.012021)| [    0.000000] reserve setup_data: [mem 0x00000000f8000000-0x00000000fdffffff] reserved
   58.263360 (    0.007946)| [    0.000000] reserve setup_data: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
   58.271798 (    0.008438)| [    0.000000] reserve setup_data: [mem 0x0000000100000000-0x000000083fffffff] usable
   58.279745 (    0.007947)| [    0.000000] reserve setup_data: [mem 0x0000001000000000-0x00000017beffffff] usable
   58.287506 (    0.007761)| [    0.000000] reserve setup_data: [mem 0x000000ff00000000-0x000000ff03dfffff] reserved
   58.295634 (    0.008128)| [    0.000000] reserve setup_data: [mem 0x000000ff03f00000-0x000000ff03ffffff] reserved
   58.303393 (    0.007759)| [    0.000000] reserve setup_data: [mem 0x000000ff07f00000-0x000000ff07ffffff] reserved
   58.315415 (    0.012022)| [    0.000000] reserve setup_data: [mem 0x000000ff40000000-0x000000ff42ffffff] reserved
   58.323792 (    0.008377)| [    0.000000] reserve setup_data: [mem 0x000000ff44000000-0x000000ff46ffffff] reserved
   58.331548 (    0.007756)| [    0.000000] reserve setup_data: [mem 0x000000ff48000000-0x000000ff4affffff] reserved
   58.339687 (    0.008139)| [    0.000000] reserve setup_data: [mem 0x000000ff4c000000-0x000000ff4effffff] reserved
   58.347445 (    0.007758)| [    0.000000] NX (Execute Disable) protection: active
   58.355780 (    0.008335)| [    0.000000] efi: EFI v2.30 by EDK II
   58.359602 (    0.003822)| [    0.000000] efi:  ACPI=0x7efe9000  ACPI 2.0=0x7efe9014  SMBIOS=0x7dcfb000  UVsystab=0x7dab7000
   58.367374 (    0.007772)| [    0.000000] efi: mem00: type=3, attr=0xf, range=[0x0000000000000000-0x0000000000001000) (0MB)
   58.375767 (    0.008393)| [    0.000000] efi: mem01: type=2, attr=0xf, range=[0x0000000000001000-0x0000000000004000) (0MB)
   58.387792 (    0.012025)| [    0.000000] efi: mem02: type=7, attr=0xf, range=[0x0000000000004000-0x000000000005f000) (0MB)
   58.395560 (    0.007768)| [    0.000000] efi: mem03: type=4, attr=0xf, range=[0x000000000005f000-0x0000000000060000) (0MB)
   58.407723 (    0.012163)| [    0.000000] efi: mem04: type=3, attr=0xf, range=[0x0000000000060000-0x000000000007f000) (0MB)
   58.415490 (    0.007767)| [    0.000000] efi: mem05: type=0, attr=0xf, range=[0x000000000007f000-0x0000000000080000) (0MB)
   58.424635 (    0.009145)| [    0.000000] efi: mem06: type=3, attr=0xf, range=[0x0000000000080000-0x00000000000a0000) (0MB)
   58.435668 (    0.011033)| [    0.000000] efi: mem07: type=7, attr=0xf, range=[0x0000000000100000-0x0000000000c00000) (11MB)
   58.443437 (    0.007769)| [    0.000000] efi: mem08: type=3, attr=0xf, range=[0x0000000000c00000-0x0000000001000000) (4MB)
   58.451822 (    0.008385)| [    0.000000] efi: mem09: type=2, attr=0xf, range=[0x0000000001000000-0x0000000001fab000) (15MB)
   58.463366 (    0.011544)| [    0.000000] efi: mem10: type=7, attr=0xf, range=[0x0000000001fab000-0x000000003ebb0000) (972MB)
   58.471761 (    0.008395)| [    0.000000] efi: mem11: type=2, attr=0xf, range=[0x000000003ebb0000-0x0000000040000000) (20MB)
   58.484788 (    0.013027)| [    0.000000] efi: mem12: type=7, attr=0xf, range=[0x0000000040000000-0x000000004eeb1000) (238MB)
   58.494746 (    0.009958)| [    0.000000] efi: mem13: type=2, attr=0xf, range=[0x000000004eeb1000-0x0000000069231000) (419MB)
   58.513531 (    0.018785)| [    0.000000] efi: mem14: type=1, attr=0xf, range=[0x0000000069231000-0x00000000692ff000) (0MB)
   58.525416 (    0.011885)| [    0.000000] efi: mem15: type=7, attr=0xf, range=[0x00000000692ff000-0x00000000693c5000) (0MB)
   58.536698 (    0.011282)| [    0.000000] efi: mem16: type=2, attr=0xf, range=[0x00000000693c5000-0x00000000693ce000) (0MB)
   58.548787 (    0.012089)| [    0.000000] efi: mem17: type=4, attr=0xf, range=[0x00000000693ce000-0x000000006941a000) (0MB)
   58.548922 (    0.000135)| [    0.000000] efi: mem18: type=7, attr=0xf, range=[0x000000006941a000-0x000000006941c000) (0MB)
   58.560687 (    0.011765)| [    0.000000] efi: mem19: type=4, attr=0xf, range=[0x000000006941c000-0x0000000069421000) (0MB)
   58.572589 (    0.011902)| [    0.000000] efi: mem20: type=7, attr=0xf, range=[0x0000000069421000-0x0000000069423000) (0MB)
   58.575380 (    0.002791)| [    0.000000] efi: mem21: type=4, attr=0xf, range=[0x0000000069423000-0x0000000069424000) (0MB)
   58.579662 (    0.004282)| [    0.000000] efi: mem22: type=7, attr=0xf, range=[0x0000000069424000-0x0000000069426000) (0MB)
   58.587433 (    0.007771)| [    0.000000] efi: mem23: type=4, attr=0xf, range=[0x0000000069426000-0x000000006944e000) (0MB)
   58.595816 (    0.008383)| [    0.000000] efi: mem24: type=2, attr=0xf, range=[0x000000006944e000-0x0000000069453000) (0MB)
   58.607358 (    0.011542)| [    0.000000] efi: mem25: type=4, attr=0xf, range=[0x0000000069453000-0x0000000069457000) (0MB)
   58.615751 (    0.008393)| [    0.000000] efi: mem26: type=2, attr=0xf, range=[0x0000000069457000-0x0000000069466000) (0MB)
   58.623515 (    0.007764)| [    0.000000] efi: mem27: type=4, attr=0xf, range=[0x0000000069466000-0x0000000069523000) (0MB)
   58.635545 (    0.012030)| [    0.000000] efi: mem28: type=1, attr=0xf, range=[0x0000000069523000-0x00000000695e0000) (0MB)
   58.643693 (    0.008148)| [    0.000000] efi: mem29: type=4, attr=0xf, range=[0x00000000695e0000-0x00000000695f0000) (0MB)
   58.655475 (    0.011782)| [    0.000000] efi: mem30: type=2, attr=0xf, range=[0x00000000695f0000-0x00000000695f7000) (0MB)
   58.663619 (    0.008144)| [    0.000000] efi: mem31: type=4, attr=0xf, range=[0x00000000695f7000-0x00000000695fd000) (0MB)
   58.671389 (    0.007770)| [    0.000000] efi: mem32: type=3, attr=0xf, range=[0x00000000695fd000-0x0000000069600000) (0MB)
   58.683421 (    0.012032)| [    0.000000] efi: mem33: type=4, attr=0xf, range=[0x0000000069600000-0x0000000069603000) (0MB)
   58.691807 (    0.008386)| [    0.000000] efi: mem34: type=3, attr=0xf, range=[0x0000000069603000-0x0000000069617000) (0MB)
   58.703346 (    0.011539)| [    0.000000] efi: mem35: type=4, attr=0xf, range=[0x0000000069617000-0x0000000069619000) (0MB)
   58.711738 (    0.008392)| [    0.000000] efi: mem36: type=3, attr=0xf, range=[0x0000000069619000-0x000000006961f000) (0MB)
   58.719736 (    0.007998)| [    0.000000] efi: mem37: type=4, attr=0xf, range=[0x000000006961f000-0x000000006afdc000) (25MB)
   58.731784 (    0.012048)| [    0.000000] efi: mem38: type=3, attr=0xf, range=[0x000000006afdc000-0x000000006b045000) (0MB)
   58.739553 (    0.007769)| [    0.000000] efi: mem39: type=4, attr=0xf, range=[0x000000006b045000-0x000000006b18d000) (1MB)
   58.747702 (    0.008149)| [    0.000000] efi: mem40: type=3, attr=0xf, range=[0x000000006b18d000-0x000000006b190000) (0MB)
   58.759485 (    0.011783)| [    0.000000] efi: mem41: type=4, attr=0xf, range=[0x000000006b190000-0x000000006b1ae000) (0MB)
   58.767629 (    0.008144)| [    0.000000] efi: mem42: type=3, attr=0xf, range=[0x000000006b1ae000-0x000000006b1df000) (0MB)
   58.779661 (    0.012032)| [    0.000000] efi: mem43: type=4, attr=0xf, range=[0x000000006b1df000-0x000000006b20c000) (0MB)
   58.786817 (    0.007156)| [    0.000000] efi: mem44: type=3, attr=0xf, range=[0x000000006b20c000-0x000000006b22c000) (0MB)
   58.795757 (    0.008940)| [    0.000000] efi: mem45: type=4, attr=0xf, range=[0x000000006b22c000-0x000000006b22f000) (0MB)
   58.807786 (    0.012029)| [    0.000000] efi: mem46: type=3, attr=0xf, range=[0x000000006b22f000-0x000000006b232000) (0MB)
   58.815554 (    0.007768)| [    0.000000] efi: mem47: type=4, attr=0xf, range=[0x000000006b232000-0x000000006b237000) (0MB)
   58.823704 (    0.008150)| [    0.000000] efi: mem48: type=3, attr=0xf, range=[0x000000006b237000-0x000000006b242000) (0MB)
   58.835485 (    0.011781)| [    0.000000] efi: mem49: type=4, attr=0xf, range=[0x000000006b242000-0x000000006b245000) (0MB)
   58.843628 (    0.008143)| [    0.000000] efi: mem50: type=3, attr=0xf, range=[0x000000006b245000-0x000000006b247000) (0MB)
   58.858639 (    0.015011)| [    0.000000] efi: mem51: type=4, attr=0xf, range=[0x000000006b247000-0x000000006b24a000) (0MB)
   58.863431 (    0.004792)| [    0.000000] efi: mem52: type=3, attr=0xf, range=[0x000000006b24a000-0x000000006b25f000) (0MB)
   58.872817 (    0.009386)| [    0.000000] efi: mem53: type=4, attr=0xf, range=[0x000000006b25f000-0x000000006b263000) (0MB)
   58.883357 (    0.010540)| [    0.000000] efi: mem54: type=3, attr=0xf, range=[0x000000006b263000-0x000000006b268000) (0MB)
   58.891749 (    0.008392)| [    0.000000] efi: mem55: type=4, attr=0xf, range=[0x000000006b268000-0x000000006b28b000) (0MB)
   58.900516 (    0.008767)| [    0.000000] efi: mem56: type=3, attr=0xf, range=[0x000000006b28b000-0x000000006b292000) (0MB)
   58.911565 (    0.011049)| [    0.000000] efi: mem57: type=4, attr=0xf, range=[0x000000006b292000-0x000000006b293000) (0MB)
   58.919706 (    0.008141)| [    0.000000] efi: mem58: type=3, attr=0xf, range=[0x000000006b293000-0x000000006b2af000) (0MB)
   58.932482 (    0.012776)| [    0.000000] efi: mem59: type=4, attr=0xf, range=[0x000000006b2af000-0x000000006b2b0000) (0MB)
   58.939601 (    0.007119)| [    0.000000] efi: mem60: type=3, attr=0xf, range=[0x000000006b2b0000-0x000000006b2b5000) (0MB)
   58.947387 (    0.007786)| [    0.000000] efi: mem61: type=4, attr=0xf, range=[0x000000006b2b5000-0x000000006b2b7000) (0MB)
   58.959421 (    0.012034)| [    0.000000] efi: mem62: type=3, attr=0xf, range=[0x000000006b2b7000-0x000000006b2e6000) (0MB)
   58.967806 (    0.008385)| [    0.000000] efi: mem63: type=4, attr=0xf, range=[0x000000006b2e6000-0x000000006b2e8000) (0MB)
   58.975575 (    0.007769)| [    0.000000] efi: mem64: type=3, attr=0xf, range=[0x000000006b2e8000-0x000000006b2ee000) (0MB)
   58.987737 (    0.012162)| [    0.000000] efi: mem65: type=4, attr=0xf, range=[0x000000006b2ee000-0x000000006b2f0000) (0MB)
   58.995506 (    0.007769)| [    0.000000] efi: mem66: type=3, attr=0xf, range=[0x000000006b2f0000-0x000000006b304000) (0MB)
   59.007534 (    0.012028)| [    0.000000] efi: mem67: type=4, attr=0xf, range=[0x000000006b304000-0x000000006b306000) (0MB)
   59.015684 (    0.008150)| [    0.000000] efi: mem68: type=3, attr=0xf, range=[0x000000006b306000-0x000000006b30c000) (0MB)
   59.023451 (    0.007767)| [    0.000000] efi: mem69: type=4, attr=0xf, range=[0x000000006b30c000-0x000000006b30d000) (0MB)
   59.038608 (    0.015157)| [    0.000000] efi: mem70: type=3, attr=0xf, range=[0x000000006b30d000-0x000000006b310000) (0MB)
   59.043807 (    0.005199)| [    0.000000] efi: mem71: type=4, attr=0xf, range=[0x000000006b310000-0x000000006b311000) (0MB)
   59.055345 (    0.011538)| [    0.000000] efi: mem72: type=3, attr=0xf, range=[0x000000006b311000-0x000000006b31a000) (0MB)
   59.063738 (    0.008393)| [    0.000000] efi: mem73: type=4, attr=0xf, range=[0x000000006b31a000-0x000000006b31c000) (0MB)
   59.071507 (    0.007769)| [    0.000000] efi: mem74: type=3, attr=0xf, range=[0x000000006b31c000-0x000000006b333000) (0MB)
   59.097647 (    0.026140)| [    0.000000] efi: mem75: type=4, attr=0xf, range=[0x000000006b333000-0x000000006b337000) (0MB)
   59.108554 (    0.010907)| [    0.000000] efi: mem76: type=3, attr=0xf, range=[0x000000006b337000-0x000000006b345000) (0MB)
   59.108685 (    0.000131)| [    0.000000] efi: mem77: type=4, attr=0xf, range=[0x000000006b345000-0x000000006b348000) (0MB)
   59.120455 (    0.011770)| [    0.000000] efi: mem78: type=3, attr=0xf, range=[0x000000006b348000-0x000000006b3bc000) (0MB)
   59.132549 (    0.012094)| [    0.000000] efi: mem79: type=4, attr=0xf, range=[0x000000006b3bc000-0x000000006b3c6000) (0MB)
   59.144828 (    0.012279)| [    0.000000] efi: mem80: type=3, attr=0xf, range=[0x000000006b3c6000-0x000000006b3cd000) (0MB)
   59.147614 (    0.002786)| [    0.000000] efi: mem81: type=4, attr=0xf, range=[0x000000006b3cd000-0x000000006b3ce000) (0MB)
   59.147747 (    0.000133)| [    0.000000] efi: mem82: type=3, attr=0xf, range=[0x000000006b3ce000-0x000000006b3d9000) (0MB)
   59.159667 (    0.011920)| [    0.000000] efi: mem83: type=4, attr=0xf, range=[0x000000006b3d9000-0x000000006b3da000) (0MB)
   59.167436 (    0.007769)| [    0.000000] efi: mem84: type=3, attr=0xf, range=[0x000000006b3da000-0x000000006b3e1000) (0MB)
   59.185822 (    0.018386)| [    0.000000] efi: mem85: type=4, attr=0xf, range=[0x000000006b3e1000-0x000000006b3e2000) (0MB)
   59.187424 (    0.001602)| [    0.000000] efi: mem86: type=3, attr=0xf, range=[0x000000006b3e2000-0x000000006b3f4000) (0MB)
   59.196755 (    0.009331)| [    0.000000] efi: mem87: type=4, attr=0xf, range=[0x000000006b3f4000-0x000000006b3f5000) (0MB)
   59.207349 (    0.010594)| [    0.000000] efi: mem88: type=3, attr=0xf, range=[0x000000006b3f5000-0x000000006b408000) (0MB)
   59.215740 (    0.008391)| [    0.000000] efi: mem89: type=4, attr=0xf, range=[0x000000006b408000-0x000000006b40c000) (0MB)
   59.223509 (    0.007769)| [    0.000000] efi: mem90: type=3, attr=0xf, range=[0x000000006b40c000-0x000000006b40e000) (0MB)
   59.235537 (    0.012028)| [    0.000000] efi: mem91: type=4, attr=0xf, range=[0x000000006b40e000-0x000000006b411000) (0MB)
   59.243686 (    0.008149)| [    0.000000] efi: mem92: type=3, attr=0xf, range=[0x000000006b411000-0x000000006b4cf000) (0MB)
   59.251454 (    0.007768)| [    0.000000] efi: mem93: type=4, attr=0xf, range=[0x000000006b4cf000-0x000000006b4d8000) (0MB)
   59.263486 (    0.012032)| [    0.000000] efi: mem94: type=3, attr=0xf, range=[0x000000006b4d8000-0x000000006b526000) (0MB)
   59.272628 (    0.009142)| [    0.000000] efi: mem95: type=4, attr=0xf, range=[0x000000006b526000-0x000000006b52c000) (0MB)
   59.283663 (    0.011035)| [    0.000000] efi: mem96: type=3, attr=0xf, range=[0x000000006b52c000-0x000000006b52d000) (0MB)
   59.291431 (    0.007768)| [    0.000000] efi: mem97: type=4, attr=0xf, range=[0x000000006b52d000-0x000000006b531000) (0MB)
   59.307560 (    0.016129)| [    0.000000] efi: mem98: type=3, attr=0xf, range=[0x000000006b531000-0x000000006b53c000) (0MB)
   59.311357 (    0.003797)| [    0.000000] efi: mem99: type=4, attr=0xf, range=[0x000000006b53c000-0x000000006b53f000) (0MB)
   59.319479 (    0.008122)| [    0.000000] efi: mem100: type=3, attr=0xf, range=[0x000000006b53f000-0x000000006b56e000) (0MB)
   59.331718 (    0.012239)| [    0.000000] efi: mem101: type=4, attr=0xf, range=[0x000000006b56e000-0x000000006b56f000) (0MB)
   59.339489 (    0.007771)| [    0.000000] efi: mem102: type=3, attr=0xf, range=[0x000000006b56f000-0x000000006b578000) (0MB)
   59.347632 (    0.008143)| [    0.000000] efi: mem103: type=4, attr=0xf, range=[0x000000006b578000-0x000000006b57b000) (0MB)
   59.359670 (    0.012038)| [    0.000000] efi: mem104: type=3, attr=0xf, range=[0x000000006b57b000-0x000000006b590000) (0MB)
   59.367439 (    0.007769)| [    0.000000] efi: mem105: type=4, attr=0xf, range=[0x000000006b590000-0x000000006b594000) (0MB)
   59.379593 (    0.012154)| [    0.000000] efi: mem106: type=3, attr=0xf, range=[0x000000006b594000-0x000000006b5a5000) (0MB)
   59.387368 (    0.007775)| [    0.000000] efi: mem107: type=4, attr=0xf, range=[0x000000006b5a5000-0x000000006b5b2000) (0MB)
   59.395761 (    0.008393)| [    0.000000] efi: mem108: type=3, attr=0xf, range=[0x000000006b5b2000-0x000000006b5b7000) (0MB)
   59.407788 (    0.012027)| [    0.000000] efi: mem109: type=4, attr=0xf, range=[0x000000006b5b7000-0x000000006b5b8000) (0MB)
   59.415558 (    0.007770)| [    0.000000] efi: mem110: type=3, attr=0xf, range=[0x000000006b5b8000-0x000000006b5ba000) (0MB)
   59.427719 (    0.012161)| [    0.000000] efi: mem111: type=4, attr=0xf, range=[0x000000006b5ba000-0x000000006b5bb000) (0MB)
   59.435491 (    0.007772)| [    0.000000] efi: mem112: type=3, attr=0xf, range=[0x000000006b5bb000-0x000000006b5d8000) (0MB)
   59.443634 (    0.008143)| [    0.000000] efi: mem113: type=4, attr=0xf, range=[0x000000006b5d8000-0x000000006b9d8000) (4MB)
   59.455669 (    0.012035)| [    0.000000] efi: mem114: type=3, attr=0xf, range=[0x000000006b9d8000-0x000000006b9de000) (0MB)
   59.463439 (    0.007770)| [    0.000000] efi: mem115: type=4, attr=0xf, range=[0x000000006b9de000-0x000000006b9e1000) (0MB)
   59.475596 (    0.012157)| [    0.000000] efi: mem116: type=3, attr=0xf, range=[0x000000006b9e1000-0x000000006b9e5000) (0MB)
   59.483369 (    0.007773)| [    0.000000] efi: mem117: type=4, attr=0xf, range=[0x000000006b9e5000-0x000000006b9e6000) (0MB)
   59.491762 (    0.008393)| [    0.000000] efi: mem118: type=3, attr=0xf, range=[0x000000006b9e6000-0x000000006b9e8000) (0MB)
   59.503790 (    0.012028)| [    0.000000] efi: mem119: type=4, attr=0xf, range=[0x000000006b9e8000-0x000000006b9ea000) (0MB)
   59.511560 (    0.007770)| [    0.000000] efi: mem120: type=3, attr=0xf, range=[0x000000006b9ea000-0x000000006ba00000) (0MB)
   59.523721 (    0.012161)| [    0.000000] efi: mem121: type=4, attr=0xf, range=[0x000000006ba00000-0x000000006ba47000) (0MB)
   59.531549 (    0.007828)| [    0.000000] efi: mem122: type=3, attr=0xf, range=[0x000000006ba47000-0x000000006ba84000) (0MB)
   59.539698 (    0.008149)| [    0.000000] efi: mem123: type=4, attr=0xf, range=[0x000000006ba84000-0x000000006bad2000) (0MB)
   59.551482 (    0.011784)| [    0.000000] efi: mem124: type=3, attr=0xf, range=[0x000000006bad2000-0x000000006bae6000) (0MB)
   59.559690 (    0.008208)| [    0.000000] efi: mem125: type=4, attr=0xf, range=[0x000000006bae6000-0x000000006bb1e000) (0MB)
   59.574471 (    0.014781)| [    0.000000] efi: mem126: type=3, attr=0xf, range=[0x000000006bb1e000-0x000000006bb22000) (0MB)
   59.579618 (    0.005147)| [    0.000000] efi: mem127: type=4, attr=0xf, range=[0x000000006bb22000-0x000000007ca9c000) (271MB)
   59.587390 (    0.007772)| [    0.000000] efi: mem128: type=6, attr=0x800000000000000f, range=[0x000000007ca9c000-0x000000007ca9d000) (0MB)
   59.599441 (    0.012051)| [    0.000000] efi: mem129: type=4, attr=0xf, range=[0x000000007ca9d000-0x000000007cab0000) (0MB)
   59.611598 (    0.012157)| [    0.000000] efi: mem130: type=6, attr=0x800000000000000f, range=[0x000000007cab0000-0x000000007ccf0000) (2MB)
   59.659388 (    0.047790)| [    0.000000] efi: mem131: type=4, attr=0xf, range=[0x000000007ccf0000-0x000000007d9ff000) (13MB)
   59.659520 (    0.000132)| [    0.000000] efi: mem132: type=6, attr=0x800000000000000f, range=[0x000000007d9ff000-0x000000007daff000) (1MB)
   59.659639 (    0.000119)| [    0.000000] efi: mem133: type=5, attr=0x800000000000000f, range=[0x000000007daff000-0x000000007dbff000) (1MB)
   59.672694 (    0.013055)| [    0.000000] efi: mem134: type=0, attr=0xf, range=[0x000000007dbff000-0x000000007dcff000) (1MB)
   59.672828 (    0.000134)| [    0.000000] efi: mem135: type=10, attr=0xf, range=[0x000000007dcff000-0x000000007eeff000) (18MB)
   59.684801 (    0.011973)| [    0.000000] efi: mem136: type=9, attr=0xf, range=[0x000000007eeff000-0x000000007efea000) (0MB)
   59.696460 (    0.011659)| [    0.000000] efi: mem137: type=4, attr=0xf, range=[0x000000007efea000-0x000000007f000000) (0MB)
   59.708492 (    0.012032)| [    0.000000] efi: mem138: type=7, attr=0xf, range=[0x0000000100000000-0x0000000840000000) (29696MB)
   59.719825 (    0.011333)| [    0.000000] efi: mem139: type=7, attr=0xf, range=[0x0000001000000000-0x00000017bf000000) (31728MB)
   59.719960 (    0.000135)| [    0.000000] efi: mem140: type=11, attr=0x8000000000000000, range=[0x0000000080000000-0x0000000090000000) (256MB)
   59.723610 (    0.003650)| [    0.000000] efi: mem141: type=11, attr=0x8000000000000001, range=[0x00000000f8000000-0x00000000fe000000) (96MB)
   59.735667 (    0.012057)| [    0.000000] efi: mem142: type=11, attr=0x8000000000000001, range=[0x00000000fed1c000-0x00000000fed20000) (0MB)
   59.743450 (    0.007783)| [    0.000000] efi: mem143: type=11, attr=0x8000000000000001, range=[0x000000ff00000000-0x000000ff03e00000) (62MB)
   59.755628 (    0.012178)| [    0.000000] efi: mem144: type=11, attr=0x8000000000000001, range=[0x000000ff03f00000-0x000000ff04000000) (1MB)
   59.767682 (    0.012054)| [    0.000000] efi: mem145: type=11, attr=0x8000000000000001, range=[0x000000ff07f00000-0x000000ff08000000) (1MB)
   59.779483 (    0.011801)| [    0.000000] efi: mem146: type=11, attr=0x8000000000000001, range=[0x000000ff40000000-0x000000ff43000000) (48MB)
   59.791533 (    0.012050)| [    0.000000] efi: mem147: type=11, attr=0x8000000000000001, range=[0x000000ff44000000-0x000000ff47000000) (48MB)
   59.799702 (    0.008169)| [    0.000000] efi: mem148: type=11, attr=0x8000000000000001, range=[0x000000ff48000000-0x000000ff4b000000) (48MB)
   59.811505 (    0.011803)| [    0.000000] efi: mem149: type=11, attr=0x8000000000000001, range=[0x000000ff4c000000-0x000000ff4f000000) (48MB)
[...]
   67.055714 (    0.008325)| [    5.971040] EFI Variables Facility v0.08 2004-May-17
   67.059441 (    0.003727)| [    5.976599] BUG: unable to handle kernel paging request at 000000007ca95b10
   67.067807 (    0.008366)| [    5.984386] IP: [<ffff88007dbf2140>] 0xffff88007dbf213f
   67.075529 (    0.007722)| [    5.990230] PGD 0
   67.075570 (    0.000041)| [    5.992484] Oops: 0000 [#1] SMP
   67.079368 (    0.003798)| [    5.996107] Modules linked in:
   67.083673 (    0.004305)| [    5.999516] CPU: 1 PID: 1 Comm: swapper/0 Not tainted 3.10.0-rc2-0.55.el7-rja+ #1
   67.091427 (    0.007754)| [    6.007861] Hardware name: SGI UV2000/ROMLEY, BIOS SGI UV 2000/3000 series BIOS 01/15/2013
   67.099815 (    0.008388)| [    6.017082] task: ffff880815938000 ti: ffff880815932000 task.ti: ffff880815932000
   67.107751 (    0.007936)| [    6.025428] RIP: 0010:[<ffff88007dbf2140>]  [<ffff88007dbf2140>] 0xffff88007dbf213f
   67.115507 (    0.007756)| [    6.033978] RSP: 0018:ffff8808159338d0 EFLAGS: 00010002
   67.123613 (    0.008106)| [    6.039903] RAX: 000000007ca95ad0 RBX: 000000000000006a RCX: 0000000090000002
   67.131365 (    0.007752)| [    6.047860] RDX: 0000000003050007 RSI: 0000000000000000 RDI: ffff88007dbf6ea8
   67.139730 (    0.008365)| [    6.055818] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
   67.147482 (    0.007752)| [    6.063776] R10: ffff880820801500 R11: 0000000000000000 R12: 0000000003050007
   67.155614 (    0.008132)| [    6.071732] R13: 0000000090000002 R14: ffff880815933db8 R15: 0000000000000000
   67.163362 (    0.007748)| [    6.079690] FS:  0000000000000000(0000) GS:ffff8817bec00000(0000) knlGS:0000000000000000
   67.171744 (    0.008382)| [    6.088715] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   67.179475 (    0.007731)| [    6.095122] CR2: 000000007ca95b10 CR3: 00000000018fd000 CR4: 00000000000407e0
   67.187605 (    0.008130)| [    6.103082] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
   67.195355 (    0.007750)| [    6.111039] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
   67.203724 (    0.008369)| [    6.118997] Stack:
   67.203764 (    0.000040)| [    6.121238]  0000000000000010 0000000000000246 ffffffff20815a80 ffff88083ffd9d80
   67.221504 (    0.017740)| [    6.129527]  0000000000000010 ffff88083ffdab08 0000000000000000 ffff88083ffd9d80
   67.233872 (    0.012368)| [    6.137819]  0000000000000010 0000000000000002 0000000000000000 0000000000000000
   67.245638 (    0.011766)| [    6.146110] Call Trace:
   67.245689 (    0.000051)| [    6.148847]  [<ffffffff81139a34>] ?  __alloc_pages_nodemask+0x154/0x2f0
   67.247488 (    0.001799)| [    6.156125]  [<ffffffff81174f7d>] ?  alloc_page_interleave+0x9d/0xa0
   67.247582 (    0.000094)| [    6.163120]  [<ffffffff812fe192>] ?  put_dec+0x72/0x90
   67.281377 (    0.033795)| [    6.168756]  [<ffffffff812f6d53>] ?  ida_get_new_above+0xb3/0x220
   67.281469 (    0.000092)| [    6.175449]  [<ffffffff812f6174>] ?  sub_alloc+0x74/0x1d0
   67.281550 (    0.000081)| [    6.181372]  [<ffffffff812f6174>] ?  sub_alloc+0x74/0x1d0
   67.281619 (    0.000069)| [    6.187305]  [<ffffffff812f6d53>] ?  ida_get_new_above+0xb3/0x220
   67.283631 (    0.002012)| [    6.194010]  [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150
   67.283748 (    0.000117)| [    6.201974]  [<ffffffff810499b3>] ?  efi_call3+0x43/0x80
   67.291432 (    0.007684)| [    6.207803]  [<ffffffff810492a7>] ?  virt_efi_get_next_variable+0x47/0x1c0
   67.299795 (    0.008363)| [    6.215374]  [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150
   67.307545 (    0.007750)| [    6.223340]  [<ffffffff814c7b55>] ?  efivar_init+0xd5/0x390
   67.311384 (    0.003839)| [    6.229458]  [<ffffffff814c8ae0>] ?  efivar_update_sysfs_entries+0x90/0x90
   67.319748 (    0.008364)| [    6.237032]  [<ffffffff812f906b>] ?  kobject_uevent+0xb/0x10
   67.327478 (    0.007730)| [    6.243247]  [<ffffffff812f812b>] ?  kset_register+0x5b/0x70
   67.331822 (    0.004344)| [    6.249469]  [<ffffffff814c8cc0>] ?  create_efivars_bin_attributes+0x150/0x150
   67.339570 (    0.007748)| [    6.257428]  [<ffffffff814c8d47>] ?  efivars_sysfs_init+0x87/0xf0
   67.347684 (    0.008114)| [    6.264129]  [<ffffffff8100032a>] ?  do_one_initcall+0x15a/0x1b0
   67.355415 (    0.007731)| [    6.270738]  [<ffffffff81a17831>] ?  do_basic_setup+0xad/0xce
   67.359500 (    0.004085)| [    6.277051]  [<ffffffff81a17ae3>] ?  kernel_init_freeable+0x291/0x291
   67.367616 (    0.008116)| [    6.284142]  [<ffffffff81a3708a>] ?  sched_init_smp+0x15b/0x162
   67.375352 (    0.007736)| [    6.290648]  [<ffffffff81a17a5f>] ?  kernel_init_freeable+0x20d/0x291
   67.379705 (    0.004353)| [    6.297739]  [<ffffffff81601eb0>] ?  rest_init+0x80/0x80
   67.387425 (    0.007720)| [    6.303566]  [<ffffffff81601ebe>] ?  kernel_init+0xe/0x180
   67.391507 (    0.004082)| [    6.309588]  [<ffffffff8162179c>] ?  ret_from_fork+0x7c/0xb0
   67.399616 (    0.008109)| [    6.315803]  [<ffffffff81601eb0>] ?  rest_init+0x80/0x80
   67.403574 (    0.003958)| [    6.321628] Code: 8b d8 e8 e4 fa ff ff 84 c0 75 0f 48 8b 15 61 58 00 00 48 8b 4c 24 30 ff 52 48 48 8b c3 eb 58 48 8b 05 4d 58 00 00 48 85 c0 74 42 <48> 83 78 40 00 74 3b 48 83 78 48 00 74 34 48 8d 53 14 4c 8d 44
   67.427797 (    0.024223)| [    6.343375] RIP  [<ffff88007dbf2140>] 0xffff88007dbf213f
   67.431635 (    0.003838)| [    6.349310]  RSP <ffff8808159338d0>
   67.435568 (    0.003933)| [    6.353198] CR2: 000000007ca95b10
   67.439379 (    0.003811)| [    6.356901] ---[ end trace 0d9ca8269f302599 ]---
   67.443710 (    0.004331)| [    6.362116] Kernel panic - not syncing: Attempted to kill init! exitcode=0x00000009
----------------------------------------------------------------------

-- 
Russ Anderson, OS RAS/Partitioning Project Lead  
SGI - Silicon Graphics Inc          rja@sgi.com
