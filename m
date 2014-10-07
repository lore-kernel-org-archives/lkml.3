Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680AbaJGRIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 13:08:01 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:46371 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbaJGRH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 13:07:58 -0400
Date: Tue, 7 Oct 2014 19:07:48 +0200
From: Mathias Krause <minipli@googlemail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Matt Fleming <matt@console-pimps.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Matt Fleming <matt.fleming@intel.com>
Subject: Re: [PATCHv2 1/3] x86, ptdump: Add section for EFI runtime services
Message-ID: <20141007170748.GA25767@jig.fritz.box>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
 <1411313216-2641-2-git-send-email-minipli@googlemail.com>
 <20141003134707.GJ14343@console-pimps.org>
 <20141007150132.GA7307@nazgul.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007150132.GA7307@nazgul.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 05:01:32PM +0200, Borislav Petkov wrote:
> On Fri, Oct 03, 2014 at 02:47:07PM +0100, Matt Fleming wrote:
> > Looks OK to me. Borislav?
> 
> It needs more work AFAICT because with it, espfix area gets cut off
> prematurely:
> 

I don't think so. See below...

> ...
> [    0.134611] ---[ Vmemmap ]---
> [    0.135003] 0xffffea0000000000-0xffffea0002000000          32M     RW         PSE GLB NX pmd
> [    0.136743] 0xffffea0002000000-0xffffea0040000000         992M                           pmd
> [    0.138091] 0xffffea0040000000-0xffffea8000000000         511G                           pud
> [    0.139611] 0xffffea8000000000-0xffffff0000000000       20992G                           pgd
> [    0.140610] ---[ ESPfix Area ]---
> [    0.141003] 0xffffff0000000000-0xffffff8000000000         512G                           pgd
> [    0.142614] 0xffffff8000000000-0xffffffef00000000         444G                           pud
> [    0.144088] ---[ EFI Runtime Services ]---
> [    0.144722] 0xffffffef00000000-0xfffffffec0000000          63G                           pud
> [    0.146090] 0xfffffffec0000000-0xfffffffefbe00000         958M                           pmd
> [    0.147613] 0xfffffffefbe00000-0xfffffffefbfe0000        1920K                           pte
> [    0.149003] 0xfffffffefbfe0000-0xfffffffefc000000         128K     RW                 x  pte
> [    0.150484] 0xfffffffefc000000-0xfffffffefc065000         404K                           pte
> [    0.151612] 0xfffffffefc065000-0xfffffffefc200000        1644K     RW                 x  pte
> [    0.153285] 0xfffffffefc200000-0xfffffffefc400000           2M     RW         PSE     x  pmd
> [    0.154721] 0xfffffffefc400000-0xfffffffefc5e0000        1920K     RW                 x  pte
> ...
> 
> and I think we want to see something more from the espfix area (this is
> what we have now):
> 
> [    0.138086] ---[ ESPfix Area ]---
> [    0.138590] 0xffffff0000000000-0xffffff8000000000         512G                           pgd
> [    0.140099] 0xffffff8000000000-0xfffffffec0000000         507G                           pud
> [    0.141444] 0xfffffffec0000000-0xfffffffefbe00000         958M                           pmd
> [    0.142597] 0xfffffffefbe00000-0xfffffffefbfe0000        1920K                           pte
> [    0.144086] 0xfffffffefbfe0000-0xfffffffefc000000         128K     RW                 x  pte
> [    0.145545] 0xfffffffefc000000-0xfffffffefc065000         404K                           pte
> [    0.146597] 0xfffffffefc065000-0xfffffffefc200000        1644K     RW                 x  pte
> [    0.148346] 0xfffffffefc200000-0xfffffffefc400000           2M     RW         PSE     x  pmd
> [    0.149776] 0xfffffffefc400000-0xfffffffefc5e0000        1920K     RW                 x  pte
> [    0.151347] 0xfffffffefc5e0000-0xfffffffefc631000         324K                           pte
> [    0.152593] 0xfffffffefc631000-0xfffffffefc655000         144K     RW                 x  pte
> [    0.154143] 0xfffffffefc655000-0xfffffffefc801000        1712K                           pte
> [    0.155437] 0xfffffffefc801000-0xfffffffefc831000         192K     RW                 x  pte
> [    0.157004] 0xfffffffefc831000-0xfffffffefc881000         320K                           pte
> [    0.158088] 0xfffffffefc881000-0xfffffffefca01000        1536K     RW                 x  pte
> [    0.159712] 0xfffffffefca01000-0xfffffffefcb34000        1228K                           pte
> [    0.161117] ... 36 entries skipped ...

What you can see here are actually the EFI runtime service mappings, not
the ESP fix area. Check the addresses and compare them. You should find
similarities ;) And, in fact, the EFI mappings are incomplete in the
second dump, i.e. the vanilla kernel one, because of the enforced limit
for the ESP fix area.

So, in your examples are actually *no* ESP fix area mappings as those
would be r/o. In fact, I think, the above dumps are the result of a
CONFIG_EFI_PGT_DUMP enabled kernel that dumps the page table after
setting up the EFI mappings. There are no ESP fix mappings in this dump
because those are only set up after the EFI runtime service mappings.
See the following code in init/main:

  #ifdef CONFIG_X86
      if (efi_enabled(EFI_RUNTIME_SERVICES))
          efi_enter_virtual_mode();
  #endif
  #ifdef CONFIG_X86_ESPFIX64
      /* Should be run before the first non-init thread is created */
      init_espfix_bsp();
  #endif

To get a more complete view of the mappings, have a look at the debugfs
file /sys/kernel/debug/kernel_page_tables.

For v3.17 I get (notice the missing EFI mappings):
...
---[ Vmemmap ]---
0xffffea0000000000-0xffffff0000000000          21T                           pgd
---[ ESPfix Area ]---
0xffffff0000000000-0xffffff3b00000000         236G                           pud
0xffffff3b00000000-0xffffff3b0000e000          56K                           pte
0xffffff3b0000e000-0xffffff3b0000f000           4K     ro             GLB NX pte
0xffffff3b0000f000-0xffffff3b0001e000          60K                           pte
0xffffff3b0001e000-0xffffff3b0001f000           4K     ro             GLB NX pte
0xffffff3b0001f000-0xffffff3b0002e000          60K                           pte
0xffffff3b0002e000-0xffffff3b0002f000           4K     ro             GLB NX pte
0xffffff3b0002f000-0xffffff3b0003e000          60K                           pte
0xffffff3b0003e000-0xffffff3b0003f000           4K     ro             GLB NX pte
0xffffff3b0003f000-0xffffff3b0004e000          60K                           pte
0xffffff3b0004e000-0xffffff3b0004f000           4K     ro             GLB NX pte
0xffffff3b0004f000-0xffffff3b0005e000          60K                           pte
0xffffff3b0005e000-0xffffff3b0005f000           4K     ro             GLB NX pte
0xffffff3b0005f000-0xffffff3b0006e000          60K                           pte
0xffffff3b0006e000-0xffffff3b0006f000           4K     ro             GLB NX pte
0xffffff3b0006f000-0xffffff3b0007e000          60K                           pte
... 131165 entries skipped ... 
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
...

For v3.17 plus this patch I get this:
...
---[ Vmemmap ]---
0xffffea0000000000-0xffffff0000000000          21T                           pgd
---[ ESPfix Area ]---
0xffffff0000000000-0xffffff5600000000         344G                           pud
0xffffff5600000000-0xffffff5600005000          20K                           pte
0xffffff5600005000-0xffffff5600006000           4K     ro             GLB NX pte
0xffffff5600006000-0xffffff5600015000          60K                           pte
0xffffff5600015000-0xffffff5600016000           4K     ro             GLB NX pte
0xffffff5600016000-0xffffff5600025000          60K                           pte
0xffffff5600025000-0xffffff5600026000           4K     ro             GLB NX pte
0xffffff5600026000-0xffffff5600035000          60K                           pte
0xffffff5600035000-0xffffff5600036000           4K     ro             GLB NX pte
0xffffff5600036000-0xffffff5600045000          60K                           pte
0xffffff5600045000-0xffffff5600046000           4K     ro             GLB NX pte
0xffffff5600046000-0xffffff5600055000          60K                           pte
0xffffff5600055000-0xffffff5600056000           4K     ro             GLB NX pte
0xffffff5600056000-0xffffff5600065000          60K                           pte
0xffffff5600065000-0xffffff5600066000           4K     ro             GLB NX pte
0xffffff5600066000-0xffffff5600075000          60K                           pte
... 131059 entries skipped ... 
---[ EFI Runtime Services ]---
0xffffffef00000000-0xfffffffec0000000          63G                           pud
0xfffffffec0000000-0xfffffffef8800000         904M                           pmd
0xfffffffef8800000-0xfffffffef89d0000        1856K                           pte
0xfffffffef89d0000-0xfffffffef8a00000         192K     RW                 x  pte
0xfffffffef8a00000-0xfffffffef8a75000         468K                           pte
0xfffffffef8a75000-0xfffffffef8c00000        1580K     RW                 x  pte
0xfffffffef8c00000-0xfffffffef8e00000           2M     RW         PSE     x  pmd
0xfffffffef8e00000-0xfffffffef8fd0000        1856K     RW                 x  pte
0xfffffffef8fd0000-0xfffffffef9041000         452K                           pte
0xfffffffef9041000-0xfffffffef9065000         144K     RW                 x  pte
0xfffffffef9065000-0xfffffffef9211000        1712K                           pte
0xfffffffef9211000-0xfffffffef9241000         192K     RW                 x  pte
0xfffffffef9241000-0xfffffffef9291000         320K                           pte
0xfffffffef9291000-0xfffffffef9411000        1536K     RW                 x  pte
0xfffffffef9411000-0xfffffffef9529000        1120K                           pte
0xfffffffef9529000-0xfffffffef9600000         860K     RW                 x  pte
0xfffffffef9600000-0xfffffffefa400000          14M     RW         PSE     x  pmd
0xfffffffefa400000-0xfffffffefa491000         580K     RW                 x  pte
0xfffffffefa491000-0xfffffffefa528000         604K                           pte
0xfffffffefa528000-0xfffffffefa529000           4K     RW                 x  pte
0xfffffffefa529000-0xfffffffefa708000        1916K                           pte
0xfffffffefa708000-0xfffffffefa728000         128K     RW                 x  pte
0xfffffffefa728000-0xfffffffefa907000        1916K                           pte
0xfffffffefa907000-0xfffffffefa908000           4K     RW                 x  pte
0xfffffffefa908000-0xfffffffefab06000        2040K                           pte
0xfffffffefab06000-0xfffffffefab07000           4K     RW                 x  pte
0xfffffffefab07000-0xfffffffefad05000        2040K                           pte
0xfffffffefad05000-0xfffffffefad06000           4K     RW                 x  pte
0xfffffffefad06000-0xfffffffefae07000        1028K                           pte
0xfffffffefae07000-0xfffffffefaf05000        1016K     RW                 x  pte
0xfffffffefaf05000-0xfffffffefb005000           1M                           pte
0xfffffffefb005000-0xfffffffefb007000           8K     RW                 x  pte
0xfffffffefb007000-0xfffffffefb1ea000        1932K                           pte
0xfffffffefb1ea000-0xfffffffefb205000         108K     RW                 x  pte
0xfffffffefb205000-0xfffffffefb3e1000        1904K                           pte
0xfffffffefb3e1000-0xfffffffefb3ea000          36K     RW                 x  pte
0xfffffffefb3ea000-0xfffffffefb5cf000        1940K                           pte
0xfffffffefb5cf000-0xfffffffefb600000         196K     RW                 x  pte
0xfffffffefb600000-0xfffffffefb800000           2M     RW         PSE     x  pmd
0xfffffffefb800000-0xfffffffefb9e1000        1924K     RW                 x  pte
0xfffffffefb9e1000-0xfffffffefbb26000        1300K                           pte
0xfffffffefbb26000-0xfffffffefbbcf000         676K     RW                 x  pte
0xfffffffefbbcf000-0xfffffffefbc80000         708K                           pte
0xfffffffefbc80000-0xfffffffefbd26000         664K     RW                 x  pte
0xfffffffefbd26000-0xfffffffefbe7d000        1372K                           pte
0xfffffffefbe7d000-0xfffffffefbe80000          12K     RW                 x  pte
0xfffffffefbe80000-0xfffffffefc05e000        1912K                           pte
0xfffffffefc05e000-0xfffffffefc07d000         124K     RW                 x  pte
0xfffffffefc07d000-0xfffffffefc237000        1768K                           pte
0xfffffffefc237000-0xfffffffefc25e000         156K     RW                 x  pte
0xfffffffefc25e000-0xfffffffefc434000        1880K                           pte
0xfffffffefc434000-0xfffffffefc437000          12K     RW                 x  pte
0xfffffffefc437000-0xfffffffefc62e000        2012K                           pte
0xfffffffefc62e000-0xfffffffefc634000          24K     RW                 x  pte
0xfffffffefc634000-0xfffffffefc82c000        2016K                           pte
0xfffffffefc634000-0xfffffffefc82c000        2016K                           pte
0xfffffffefc82c000-0xfffffffefc82e000           8K     RW                 x  pte
0xfffffffefc82e000-0xfffffffefca2a000        2032K                           pte
0xfffffffefca2a000-0xfffffffefca2c000           8K     RW                 x  pte
0xfffffffefca2c000-0xfffffffefcc28000        2032K                           pte
0xfffffffefcc28000-0xfffffffefcc2a000           8K     RW                 x  pte
0xfffffffefcc2a000-0xfffffffefce15000        1964K                           pte
0xfffffffefce15000-0xfffffffefce28000          76K     RW                 x  pte
0xfffffffefce28000-0xfffffffefd012000        1960K                           pte
0xfffffffefd012000-0xfffffffefd015000          12K     RW                 x  pte
0xfffffffefd015000-0xfffffffefd20e000        2020K                           pte
0xfffffffefd20e000-0xfffffffefd212000          16K     RW                 x  pte
0xfffffffefd212000-0xfffffffefd40d000        2028K                           pte
0xfffffffefd40d000-0xfffffffefd40e000           4K     RW                 x  pte
0xfffffffefd40e000-0xfffffffefd5e9000        1900K                           pte
0xfffffffefd5e9000-0xfffffffefd60d000         144K     RW                 x  pte
0xfffffffefd60d000-0xfffffffefd7e7000        1896K                           pte
0xfffffffefd7e7000-0xfffffffefd7e9000           8K     RW                 x  pte
0xfffffffefd7e9000-0xfffffffefd9e0000        2012K                           pte
0xfffffffefd9e0000-0xfffffffefd9e7000          28K     RW                 x  pte
0xfffffffefd9e7000-0xfffffffefdbdf000        2016K                           pte
0xfffffffefdbdf000-0xfffffffefdbe0000           4K     RW                 x  pte
0xfffffffefdbe0000-0xfffffffefddce000        1976K                           pte
0xfffffffefddce000-0xfffffffefdddf000          68K     RW                 x  pte
0xfffffffefdddf000-0xfffffffefdfcd000        1976K                           pte
0xfffffffefdfcd000-0xfffffffefdfce000           4K     RW                 x  pte
0xfffffffefdfce000-0xfffffffefe1af000        1924K                           pte
0xfffffffefe1af000-0xfffffffefe1cd000         120K     RW                 x  pte
0xfffffffefe1cd000-0xfffffffefe3ae000        1924K                           pte
0xfffffffefe3ae000-0xfffffffefe3af000           4K     RW                 x  pte
0xfffffffefe3af000-0xfffffffefe5a8000        2020K                           pte
0xfffffffefe5a8000-0xfffffffefe5ae000          24K     RW                 x  pte
0xfffffffefe5ae000-0xfffffffefe7a5000        2012K                           pte
0xfffffffefe7a5000-0xfffffffefe7a8000          12K     RW                 x  pte
0xfffffffefe7a8000-0xfffffffefe96d000        1812K                           pte
0xfffffffefe96d000-0xfffffffefe9a5000         224K     RW                 x  pte
0xfffffffefe9a5000-0xfffffffefeb69000        1808K                           pte
0xfffffffefeb69000-0xfffffffefeb6d000          16K     RW                 x  pte
0xfffffffefeb6d000-0xfffffffefed65000        2016K                           pte
0xfffffffefed65000-0xfffffffefed69000          16K     RW                 x  pte
0xfffffffefed69000-0xfffffffefef5f000        2008K                           pte
0xfffffffefef5f000-0xfffffffefef65000          24K     RW                 x  pte
0xfffffffefef65000-0xfffffffeff0dc000        1500K                           pte
0xfffffffeff0dc000-0xfffffffeff15f000         524K     RW                 x  pte
0xfffffffeff15f000-0xfffffffeff261000        1032K                           pte
0xfffffffeff261000-0xfffffffeff2dc000         492K     RW                 x  pte
0xfffffffeff2dc000-0xfffffffeff45f000        1548K                           pte
0xfffffffeff45f000-0xfffffffeff460000           4K     RW                 x  pte
0xfffffffeff460000-0xfffffffeff600000        1664K                           pte
0xfffffffeff600000-0xfffffffeff620000         128K     RW                 x  pte
0xfffffffeff620000-0xfffffffeff800000        1920K                           pte
0xfffffffeff800000-0xffffffff00000000           8M     RW         PSE     x  pmd
0xffffffff00000000-0xffffffff80000000           2G                           pud
---[ High Kernel Mapping ]---
...

The ESP fix area is trimmed, as expected. The EFI runtime service area
is, beside being rather lengthy, complete. Also, as expected.

> 
> But yeah, this issue needs to be addressed one way or the other as the
> espfix dump skips the runtime services.
> 
> And frankly, I don't see where we're setting that ->max_lines thing but
> it sounds like a promising thing to use. :)

It's the third parameter in the address_markers[] array in
arch/x86/mm/dump_pagetables.c:

  # ifdef CONFIG_X86_ESPFIX64
    { ESPFIX_BASE_ADDR, "ESPfix Area", 16 },
  # endif

So, it's 16 entries for the ESP fix area. If it's set to 0, as it is for
all the other entries, no limitation applies.


Thanks,
Mathias

> 
> Thanks.
> 
> -- 
> Regards/Gruss,
>     Boris.
> --
