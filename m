Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab3AUMix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 07:38:53 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:42011 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752852Ab3AUMiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 07:38:51 -0500
Message-ID: <50FD36CF.1000702@synopsys.com>
Date: Mon, 21 Jan 2013 18:08:39 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 28/76] ARC: I/O and DMA Mappings
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <1358511930-7424-29-git-send-email-vgupta@synopsys.com> <201301181555.43487.arnd@arndb.de>
In-Reply-To: <201301181555.43487.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013 09:25 PM, Arnd Bergmann wrote:
> On Friday 18 January 2013, Vineet Gupta wrote:
>> TBD: Do we need early ioremap support like openrisc
>>
>> Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
> Can you explain why early ioremap is necessary for you?
>
> I wasn't aware that openrisc has it. In a lot of cases,
> you can use fixmap as a replacement.

This came about when enabling the early console of arc uart using the early param
registration. I prefer console to be up as early as possible because the high
configurability of ARC means you get early panics if hardware and software don't
match (cache geom, mmu ver, ....) and it's good if we could print it out via uart.

So we do end up calling ioremap very early

setup_arch
   machine_desc->init_early
   plat_fpga_early_init
       arc_fpga_serial_init
             early_platform_add_devices
             early_platform_driver_probe
                  arc_serial_probe_earlyprintk
                        ioremap_nocache()

However, ioremap on ARC typically avoids MMU mappings (hence need for paging_init
etc to have run apriori) because memory mapped peripherals are typically wired up
in ARC's dedicated uncached address space. So unless the driver needs special
access permissions (in addition to uncached semantics), we can simply
short-circuit all of MMU routing.

So the comment above can be deleted, and we probably need a check in
ioremap_prot() so that early ioremap bails out if called early - probably using
slab_is_available()

>
>> +
>> +#ifndef _ASM_ARC_IO_H
>> +#define _ASM_ARC_IO_H
>> +
>> +#include <asm/byteorder.h>
>> +#include <asm/page.h>
>> +
>> +extern void __iomem *ioremap(unsigned long physaddr, unsigned long size);
>> +extern void iounmap(const void __iomem *addr);
>> +
>> +#define ioremap_nocache(phy, sz)	ioremap(phy, sz)
>> +#define ioremap_wc(phy, sz)		ioremap(phy, sz)
>> +
>> +/* Change struct page to physical address */
>> +#define page_to_phys(page)		(page_to_pfn(page) << PAGE_SHIFT)
>> +
>> +#include <asm-generic/io.h>
> I think I commented before that asm-generic/io.h has a number of
> problems and you should at least override the __raw_{read,write}{b,w,l,q}
> functions with your own ones using inline assembly.
>
> You should also define a non-NULL PCI_IOBASE.

Sorry for missing out on this one - this was indeed suggested in the private
pre-list review you did. The 64-bit version certainly needs to be wrapped in a irq
safe block.

However others will be exactly same as generic ones. Given that these routines
operate on __iomem memory which has to be uncached: either wired in uncached
address space, or goes via an uncached MMU mapping, IMHO the inline-asm or 'C'
version won't add any value. We do have uncached LD/ST, I've tried to avoid them
so far as they have certain micro-architectural quirks and per previous argument
it seems they would be redundant.

Having said that I might be over-looking something important - so please let me know.

-Vineet

