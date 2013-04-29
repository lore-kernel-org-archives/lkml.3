Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab3D2I5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 04:57:20 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:57782 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab3D2I5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 04:57:19 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1304151825270.1376@eggly.anvils>
References: <20130412181348.GA2253@redhat.com>
	<CANN689GKfxM3R96wgY8-+FftpVT76zMFcHdgKccNKnjHGfYq1Q@mail.gmail.com>
	<20130415163552.GA31868@redhat.com>
	<20130415173424.GB31868@redhat.com>
	<20130415175929.GB30583@redhat.com>
	<20130415191304.GC30583@redhat.com>
	<alpine.LNX.2.00.1304151425540.1030@eggly.anvils>
	<20130416002123.GA29465@google.com>
	<alpine.LNX.2.00.1304151825270.1376@eggly.anvils>
Date: Mon, 29 Apr 2013 01:57:18 -0700
Message-ID: <CANN689EcqDg0xp+74SoQJYQMecU4z-WWdA+7FtM3Sc_R-uK=sg@mail.gmail.com>
Subject: Re: 3.9-rc5: Encountedred INFO: rcu_sched self-detected stall on CPU
 due to 09a9f1d27
From: Michel Lespinasse <walken@google.com>
To: Hugh Dickins <hughd@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 6:27 PM, Hugh Dickins <hughd@google.com> wrote:
> On Mon, 15 Apr 2013, Michel Lespinasse wrote:
>> sys_brk() passes the length as the difference of two page aligned addresses, so it's fine. But vm_brk() doesn't - it calls do_brk() which page aligns the length, but then vm_brk passes the unaligned length to mm_populate().
>>
>> What do you think of the following ? len is already a PAGE_SIZE multiple when called from sys_brk()...
>
> Yes, that's good.
>>
>> diff --git a/mm/mmap.c b/mm/mmap.c
>> index 0db0de1c2fbe..6af8b0d1c7db 100644
>> --- a/mm/mmap.c
>> +++ b/mm/mmap.c
>> @@ -2557,10 +2557,6 @@ static unsigned long do_brk(unsigned long addr, unsigned long len)
>>       pgoff_t pgoff = addr >> PAGE_SHIFT;
>>       int error;
>>
>> -     len = PAGE_ALIGN(len);
>> -     if (!len)
>> -             return addr;
>> -
>>       flags = VM_DATA_DEFAULT_FLAGS | VM_ACCOUNT | mm->def_flags;
>>
>>       error = get_unmapped_area(NULL, addr, len, 0, MAP_FIXED);
>> @@ -2643,6 +2639,10 @@ unsigned long vm_brk(unsigned long addr, unsigned long len)
>>       unsigned long ret;
>>       bool populate;
>>
>> +     len = PAGE_ALIGN(len);
>> +     if (!len)
>> +             return addr;
>> +
>>       down_write(&mm->mmap_sem);
>>       ret = do_brk(addr, len);
>>       populate = ((mm->def_flags & VM_LOCKED) != 0);

Vivek - what should I do with this change ? Do you want to take it as
part of your series, or should I push to Linus/Andrew ?

All vm_brk calls are in elf and aout loaders, so I don' t think we can
hit the issue without your changes. Still, it may be good to make
vm_brk robust anyway.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
