Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845Ab3CUDZL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 23:25:11 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46732 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151Ab3CUDZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 23:25:08 -0400
Date: Thu, 21 Mar 2013 12:25:01 +0900 (JST)
Message-Id: <20130321.122501.82758179.d.hatayama@jp.fujitsu.com>
To: ebiederm@xmission.com
Cc: vgoyal@redhat.com, cpw@sgi.com, kumagai-atsushi@mxc.nes.nec.co.jp,
        lisa.mitchell@hp.com, heiko.carstens@de.ibm.com,
        akpm@linux-foundation.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, zhangyanfei@cn.fujitsu.com
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify
 mmap()'s page-size boundary requirement
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
In-Reply-To: <87txo5bxk4.fsf@xmission.com>
References: <877gl3koay.fsf@xmission.com>
	<20130320135716.GE17274@redhat.com>
	<87txo5bxk4.fsf@xmission.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
Date: Wed, 20 Mar 2013 13:55:55 -0700

> Vivek Goyal <vgoyal@redhat.com> writes:
> 
>> On Tue, Mar 19, 2013 at 03:38:45PM -0700, Eric W. Biederman wrote:
>>> HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com> writes:
>>> 
>>> > If there's some vmcore object that doesn't satisfy page-size boundary
>>> > requirement, remap_pfn_range() fails to remap it to user-space.
>>> >
>>> > Objects that posisbly don't satisfy the requirement are ELF note
>>> > segments only. The memory chunks corresponding to PT_LOAD entries are
>>> > guaranteed to satisfy page-size boundary requirement by the copy from
>>> > old memory to buffer in 2nd kernel done in later patch.
>>> >
>>> > This patch doesn't copy each note segment into the 2nd kernel since
>>> > they amount to so large in total if there are multiple CPUs. For
>>> > example, current maximum number of CPUs in x86_64 is 5120, where note
>>> > segments exceed 1MB with NT_PRSTATUS only.
>>> 
>>> So you require the first kernel to reserve an additional 20MB, instead
>>> of just 1.6MB.  336 bytes versus 4096 bytes.
>>> 
>>> That seems like completely the wrong tradeoff in memory consumption,
>>> filesize, and backwards compatibility.
>>
>> Agreed. 
>>
>> So we already copy ELF headers in second kernel's memory. If we start
>> copying notes too, then both headers and notes will support mmap().
> 
> The only real is it could be a bit tricky to allocate all of the memory
> for the notes section on high cpu count systems in a single allocation.
> 

Do you mean it's getting difficult on many-cpus machine to get free
pages consequtive enough to be able to cover all the notes?

If so, is it necessary to think about any care to it in the next
patch? Or, should it be pending for now?

>> For mmap() of memory regions which are not page aligned, we can map
>> extra bytes (as you suggested in one of the mails). Given the fact
>> that we have one ELF header for every memory range, we can always modify
>> the file offset where phdr data is starting to make space for mapping
>> of extra bytes.
> 
> Agreed ELF file offset % PAGE_SIZE should == physical address % PAGE_SIZE to
> make mmap work.
> 

OK, your conclusion is the 1st version is better than the 2nd.

The purpose of this design was not to export anything but dump target
memory to user-space from /proc/vmcore. I think it better to do it if
possible. it's possible for read interface to fill the corresponding
part with 0. But it's impossible for mmap interface to data on modify
old memory.

Do you agree two vmcores seen from read and mmap interfaces are no
longer coincide?

Thanks.
HATAYAMA, Daisuke

