Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbbAISG7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 13:06:59 -0500
Received: from service87.mimecast.com ([91.220.42.44]:42826 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbbAISG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 13:06:58 -0500
Message-ID: <54B018B8.1080306@arm.com>
Date: Fri, 09 Jan 2015 18:06:48 +0000
From: Vladimir Murzin <vladimir.murzin@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mason <mpeg.blue@free.fr>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: LKML <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: ioremap vs remap_pfn_range, VMSPLIT, etc
References: <54AFD09E.1010806@free.fr> <20150109131322.GO12302@n2100.arm.linux.org.uk> <54B013F0.10408@free.fr>
In-Reply-To: <54B013F0.10408@free.fr>
X-OriginalArrivalTime: 09 Jan 2015 18:06:55.0568 (UTC) FILETIME=[0D897500:01D02C37]
X-MC-Unique: 115010918065605201
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 17:46, Mason wrote:
> On 09/01/2015 14:13, Russell King - ARM Linux wrote:
> 
>> On Fri, Jan 09, 2015 at 01:59:10PM +0100, Mason wrote:
>>
>>> Yesterday, I used /dev/mem to mmap 2 GB and (to my surprise) it worked.
>>> Specifically, I opened /dev/mem O_RDWR | O_SYNC
>>> then called
>>>   mmap(NULL, 1U<<31, PROT_WRITE, MAP_SHARED, fd, 0x80000000);
>>
>> So you asked to map 2GB starting at 2GB physical.
>>
>>> And mmap returned a valid pointer.
>>
>> And that mapping would have been created to map physical addresses
>> 0x80000000-0xffffffff inclusive.
>>
>>> I was expecting it to fail.
>>>
>>> - the kernel is configured with VMSPLIT_3G (3G/1G user/kernel)
>>
>> This has no bearing on the above.
> 
> I don't understand why.
> 
> mmap allocates virtual addresses in the user-space process, yes?
> So if I had VMSPLIT_2G, user-space processes would be limited
> to 2G virtual addresses, and could not create a single 2G map
> on top of its stack and text space. Or am I missing something?
> 

Because you are mmaping special file (dev/mem) mmap call is routed to
the dedicated hook, responsible for all "magic" you see. Please, take a
look at drivers/char/mem.c for details.

Vladimir

>>> - the kernel manages 256 MB RAM
>>> - there is roughly 750 MB of VMALLOC space, no highmem
>>
>> vmalloc has no bearing on the above, mmap() doesn't allocate anything
>> into vmalloc space.
> 
> This means remap_pfn_range doesn't "put" anything in the kernel's
> virtual address space.
> 
>>> If I requested the same mapping *within the kernel* using ioremap,
>>> would that fail because of limited VMALLOC space?
>>
>> Correct.
> 
> OK.
> 
>>> Moving to arch-specific questions (namely ARM Cortex-A9).
>>> If I understand correctly (which is very possibly NOT the case)
>>> the CPU has two registers pointing to page tables, one for
>>> the current process, one for the kernel. And the CPU automatically
>>> picks the correct one, based on the active context?
>>> It would seem possible to have a full 4G for process, and a full 4G
>>> for the kernel, using that method, no? (Like Ingo's old 4G/4G split).
>>> Without the performance overhead of fiddling with the page tables.
>>> What am I missing?
>>
>> It's possible to use both, but the CPU selects the page table register
>> according to the virtual address.  So it's not possible to have 4G for
>> both.  There's only a restricted set of options:  2G / 2G, where the
>> bottom 2G of virtual space uses TTBR0 and the upper 2G uses TTBR1.
>> 1G / 3G (1G for TTBR0, 3G for TTBR1).
>>
>> We don't use it because most people run with 3G for userspace, which
>> isn't supported in hardware.
> 
> I see. Thanks for spelling it out.
> 
> Regards.
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> 
> 


