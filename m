Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3EYAda (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 20:33:30 -0400
Received: from mail-pa0-f49.google.com ([209.85.220.49]:49207 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3EYAd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 20:33:29 -0400
Message-ID: <51A006CF.90105@gmail.com>
Date: Sat, 25 May 2013 08:33:19 +0800
From: Zhang Yanfei <zhangyanfei.yes@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Vivek Goyal <vgoyal@redhat.com>,
        Michael Holzheu <holzheu@linux.vnet.ibm.com>,
        HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>,
        Jan Willeke <willeke@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/2] kdump/mmap: Fix mmap of /proc/vmcore for s390
References: <1369400889-11064-1-git-send-email-holzheu@linux.vnet.ibm.com> <20130524143644.GD18218@redhat.com> <20130524170626.2ac06efe@holzheu> <20130524152849.GF18218@redhat.com> <87mwrkatgu.fsf@xmission.com>
In-Reply-To: <87mwrkatgu.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Eric,

于 2013年05月25日 06:44, Eric W. Biederman 写道:
> Vivek Goyal <vgoyal@redhat.com> writes:
> 
>> On Fri, May 24, 2013 at 05:06:26PM +0200, Michael Holzheu wrote:
>>> Hello Vivek,
>>>
>>> On Fri, 24 May 2013 10:36:44 -0400
>>> Vivek Goyal <vgoyal@redhat.com> wrote:
>>>
>>> [snip]
>>>
>>>> Sorry, I don't understand the problem. If we swapped low memory and
>>>> crash reserved memory, that should have been taken care by prepared
>>>> ELF headers so that we map the right pfns. In x86 we swap 640K of low
>>>> memory with 640K of memory in reserved and we take care of this by
>>>> preparing elf headers accordingly.
>>>>
>>>> So why s390 can't do the same thing?
>>>
>>> I am not sure if I understand this. Currently we create the ELF
>>> header in a way that we have virtual=real. In the copy_oldmem_page() we
>>> do the swap so that for the /proc/vmcore code it looks like contiguous
>>> non-swapped memory.
>>>
>>> One reason why I thought this was necessary was that /dev/oldmem
>>> also uses the function and it should provide linear memory access like
>>> it is on the live system with /dev/mem.
>>>
>>> Is that implementation incorrect?
>>
>> [ CC Andrew. Keep him in loop for all kernel kdump patches as all kdump
>>   patches are routed through him ].
>>
>> [ CC Eric Biederman ]
>>
>> Looking at the code, looks like /dev/oldmem is broken. It does not know
>> anything about swap of any of the memory areas and it will simply
>> return the contents of page frame asked. And this has been like this
>> since the beginning.
>>
>> I have always questioned the utility of /dev/oldmem. Atleast I am not
>> aware of any tool making use of it.
>>
>> If we want to fix it, then somebow all the swapped memory region info
>> needs to be communicated to second kernel so that read_oldmem() can
>> do the mapping correctly and we really don't have any mechanism for
>> that. (I am assuming that in s390 you must have hardcoded the regions
>> of memory which are always swapped).
>>
>> As /proc/vmcore is the most used and useful interface, I prefer that
>> we swap memory and put that info in elf headers. For /dev/oldme, I
>> don't mind if we leave it as it is. If somebody really cares, then
>> I guess we need to write a new command line option which /dev/mem
>> can parse and which tells it about swaps so that /dev/oldmem can
>> map things correctly. (This is better than hardcoding things).
>>
>> Eric, do you have any thoughts on this.
> 
> I don't think anyone actually uses /dev/oldmem.  I would like to cite
> the s390 confusion as proof but I don't think that quite works.
> 
> I think the solution is for someone to send a patch removing /dev/oldmem
> as an unused piece of code.  That will also move us in the direction of
> resolving HPAs concerns.

I think I can try this.

> 
> The function copy_oldmem_page also concerns me.  I don't have a clue why
> we duplicate that function on every architecutre in a slightly different
> form.  There should be enough abstractions in the kernel to make that
> unnecessary.  I would be glad to see that function go, and remove the
> possibility of confusion that happened on s390.

You mean we should have a common copy_oldmem_page for all architectures? And
just like vivek said above, for s390, we should put the swap info in the elf
headers instead of doing that in copy_oldmem_page.

Zhang
