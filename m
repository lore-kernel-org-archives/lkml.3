Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381AbbAIRqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 12:46:33 -0500
Received: from smtp21.services.sfr.fr ([93.17.128.1]:61746 "EHLO
	smtp21.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751803AbbAIRqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 12:46:31 -0500
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20150109174625297.488C970001F5@msfrf2103.sfr.fr
Message-ID: <54B013F0.10408@free.fr>
Date: Fri, 09 Jan 2015 18:46:24 +0100
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:34.0) Gecko/20100101
	Firefox/34.0 SeaMonkey/2.31
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Linux ARM <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioremap vs remap_pfn_range, VMSPLIT, etc
References: <54AFD09E.1010806@free.fr>
	<20150109131322.GO12302@n2100.arm.linux.org.uk>
In-Reply-To: <20150109131322.GO12302@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2015 14:13, Russell King - ARM Linux wrote:

> On Fri, Jan 09, 2015 at 01:59:10PM +0100, Mason wrote:
>
>> Yesterday, I used /dev/mem to mmap 2 GB and (to my surprise) it worked.
>> Specifically, I opened /dev/mem O_RDWR | O_SYNC
>> then called
>>   mmap(NULL, 1U<<31, PROT_WRITE, MAP_SHARED, fd, 0x80000000);
> 
> So you asked to map 2GB starting at 2GB physical.
> 
>> And mmap returned a valid pointer.
> 
> And that mapping would have been created to map physical addresses
> 0x80000000-0xffffffff inclusive.
> 
>> I was expecting it to fail.
>>
>> - the kernel is configured with VMSPLIT_3G (3G/1G user/kernel)
> 
> This has no bearing on the above.

I don't understand why.

mmap allocates virtual addresses in the user-space process, yes?
So if I had VMSPLIT_2G, user-space processes would be limited
to 2G virtual addresses, and could not create a single 2G map
on top of its stack and text space. Or am I missing something?

>> - the kernel manages 256 MB RAM
>> - there is roughly 750 MB of VMALLOC space, no highmem
> 
> vmalloc has no bearing on the above, mmap() doesn't allocate anything
> into vmalloc space.

This means remap_pfn_range doesn't "put" anything in the kernel's
virtual address space.

>> If I requested the same mapping *within the kernel* using ioremap,
>> would that fail because of limited VMALLOC space?
> 
> Correct.

OK.

>> Moving to arch-specific questions (namely ARM Cortex-A9).
>> If I understand correctly (which is very possibly NOT the case)
>> the CPU has two registers pointing to page tables, one for
>> the current process, one for the kernel. And the CPU automatically
>> picks the correct one, based on the active context?
>> It would seem possible to have a full 4G for process, and a full 4G
>> for the kernel, using that method, no? (Like Ingo's old 4G/4G split).
>> Without the performance overhead of fiddling with the page tables.
>> What am I missing?
> 
> It's possible to use both, but the CPU selects the page table register
> according to the virtual address.  So it's not possible to have 4G for
> both.  There's only a restricted set of options:  2G / 2G, where the
> bottom 2G of virtual space uses TTBR0 and the upper 2G uses TTBR1.
> 1G / 3G (1G for TTBR0, 3G for TTBR1).
> 
> We don't use it because most people run with 3G for userspace, which
> isn't supported in hardware.

I see. Thanks for spelling it out.

Regards.
