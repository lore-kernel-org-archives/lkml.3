Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab3CUGPS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 02:15:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59328 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846Ab3CUGPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 02:15:15 -0400
Date: Thu, 21 Mar 2013 15:14:28 +0900 (JST)
Message-Id: <20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify
 mmap()'s page-size boundary requirement
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <8738vp75cy.fsf@xmission.com>
References: <87txo5bxk4.fsf@xmission.com>
	<20130321.122501.82758179.d.hatayama@jp.fujitsu.com>
	<8738vp75cy.fsf@xmission.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
Date: Wed, 20 Mar 2013 21:18:37 -0700

> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
> 
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
>> Date: Wed, 20 Mar 2013 13:55:55 -0700
>>
>>> Vivek Goyal <vgoyal@redhat.com> writes:
>>> 
>>>> On Tue, Mar 19, 2013 at 03:38:45PM -0700, Eric W. Biederman wrote:
>>>>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>>>>> 
>>>>> > If there's some vmcore object that doesn't satisfy page-size boundary
>>>>> > requirement, remap_pfn_range() fails to remap it to user-space.
>>>>> >
>>>>> > Objects that posisbly don't satisfy the requirement are ELF note
>>>>> > segments only. The memory chunks corresponding to PT_LOAD entries are
>>>>> > guaranteed to satisfy page-size boundary requirement by the copy from
>>>>> > old memory to buffer in 2nd kernel done in later patch.
>>>>> >
>>>>> > This patch doesn't copy each note segment into the 2nd kernel since
>>>>> > they amount to so large in total if there are multiple CPUs. For
>>>>> > example, current maximum number of CPUs in x86_64 is 5120, where note
>>>>> > segments exceed 1MB with NT_PRSTATUS only.
>>>>> 
>>>>> So you require the first kernel to reserve an additional 20MB, instead
>>>>> of just 1.6MB.  336 bytes versus 4096 bytes.
>>>>> 
>>>>> That seems like completely the wrong tradeoff in memory consumption,
>>>>> filesize, and backwards compatibility.
>>>>
>>>> Agreed. 
>>>>
>>>> So we already copy ELF headers in second kernel's memory. If we start
>>>> copying notes too, then both headers and notes will support mmap().
>>> 
>>> The only real is it could be a bit tricky to allocate all of the memory
>>> for the notes section on high cpu count systems in a single allocation.
>>> 
>>
>> Do you mean it's getting difficult on many-cpus machine to get free
>> pages consequtive enough to be able to cover all the notes?
>>
>> If so, is it necessary to think about any care to it in the next
>> patch? Or, should it be pending for now?
> 
> I meant that in general allocations > PAGE_SIZE get increasingly
> unreliable the larger they are.  And on large cpu count machines we are
> having larger allocations.  Of course large cpu count machines typically
> have more memory so the odds go up.
> 
> Right now MAX_ORDER seems to be set to 11 which is 8MiB, and my x86_64
> machine certainly succeeded in an order 11 allocation during boot so I
> don't expect any real problems with a 2MiB allocation but it is
> something to keep an eye on with kernel memory.
> 

OK, rigorously, suceess or faliure of the requested free pages
allocation depends on actual memory layout at the 2nd kernel boot. To
increase the possibility of allocating memory, we have no method but
reserve more memory for the 2nd kernel now.

>>>> For mmap() of memory regions which are not page aligned, we can map
>>>> extra bytes (as you suggested in one of the mails). Given the fact
>>>> that we have one ELF header for every memory range, we can always modify
>>>> the file offset where phdr data is starting to make space for mapping
>>>> of extra bytes.
>>> 
>>> Agreed ELF file offset % PAGE_SIZE should == physical address % PAGE_SIZE to
>>> make mmap work.
>>> 
>>
>> OK, your conclusion is the 1st version is better than the 2nd.
>>
>> The purpose of this design was not to export anything but dump target
>> memory to user-space from /proc/vmcore. I think it better to do it if
>> possible. it's possible for read interface to fill the corresponding
>> part with 0. But it's impossible for mmap interface to data on modify
>> old memory.
> 
> In practice someone lied.  You can't have a chunk of memory that is
> smaller than page size.  So I don't see it doing any harm to export
> the memory that is there but some silly system lied to us about.
> 
>> Do you agree two vmcores seen from read and mmap interfaces are no
>> longer coincide?
> 
> That is an interesting point.  I don't think there is any point in
> having read and mmap disagree, that just seems to lead to complications,
> especially since the data we are talking about adding is actually memory
> contents.
> 
> I do think it makes sense to have logical chunks of the file that are
> not covered by PT_LOAD segments.  Logical chunks like the leading edge
> of a page inside of which a PT_LOAD segment starts, and the trailing
> edge of a page in which a PT_LOAD segment ends.
> 
> Implementaton wise this would mean extending the struct vmcore entry to
> cover missing bits, by rounding down the start address and rounding up
> the end address to the nearest page size boundary.  The generated
> PT_LOAD segment would then have it's file offset adjusted to point skip
> the bytes of the page that are there but we don't care about.

Do you mean for each range represented by each PT_LOAD entry, say:

  [p_paddr, p_paddr + p_memsz]

extend it as:

  [rounddown(p_paddr, PAGE_SIZE), roundup(p_paddr + p_memsz, PAGE_SIZE)].

not only objects in vmcore_list, but also updating p_paddr and p_memsz
members themselves of each PT_LOAD entry? In other words, there's no
new holes not referenced by any PT_LOAD entry since the regions
referenced by some PT_LOAD entry, themselves are extended.

Then, the vmcores seen from read and mmap methods are coincide in the
direction of including both ranges

  [rounddown(p_paddr, PAGE_SIZE), p_paddr]

and

  [p_paddr + p_memsz, roundup(p_paddr + p_memsz, PAGE_SIZE)]

are included in both vmcores seen from read and mmap methods, although
they are originally not dump target memory, which you are not
problematic for ease of implementation.

Is there difference here from you understanding?

Thanks.
HATAYAMA, Daisuke

