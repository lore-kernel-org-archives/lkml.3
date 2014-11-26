Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339AbaKZGv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 01:51:57 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62996 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055AbaKZGv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 01:51:56 -0500
MIME-Version: 1.0
In-Reply-To: <20141125133857.bb2d71659287df6aa908de5b@linux-foundation.org>
References: <1416683799-678-1-git-send-email-js07.lee@gmail.com>
	<20141125133857.bb2d71659287df6aa908de5b@linux-foundation.org>
Date: Wed, 26 Nov 2014 15:51:54 +0900
Message-ID: <CAPP0e=M9eUkn+riY3E+5fTOkrxH+Btr_arByg+E4ROH+ifcZ1g@mail.gmail.com>
Subject: Re: [RFC PATCH] fs/binfmt_elf.c: fix inconsistent vma dump size
From: Jungseung Lee <js07.lee@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

2014-11-26 6:38 GMT+09:00 Andrew Morton <akpm@linux-foundation.org>:
> On Sun, 23 Nov 2014 04:16:39 +0900 Jungseung Lee <js07.lee@gmail.com> wrote:
>
>> vma_dump_size() has been used several times on actual dumper
>> and it is supposed to be same values for same vma.
>> But vma_dump_size() could be different, while coredump is procceeded.
>> (e.g. remove shared memory)
>>
>> In that case, header info and vma size could be inconsistent
>> and it cause wrong coredump file creation.
>>
>> Fix the problem by always using the same vma dump size
>> which is stored in vma_filsz.
>
> So concurrent shared memory removal causes inconsistencies.
>
> But concurrent shared memory removal can still cause inconsistency
> after this patch, can't it?  If it happens while vma_filesz[] is being
> populated or if it happens between vma_filesz[] population and
> vma_filesz[] usage.  This will result in a dump file which is
> internally consistent, but is inconsistent with reality?
>
Yes, you are right.

The problem is internally inconsistent between header and dump data in
core file that
cause wrong vma detection in gdb.
In my opinion, if the factor whether to dump or not is changed while
coredump is working it is
reasonable to choose anyone.
  (bit 1) anonymous shared memory vs  (bit 3) file-backed shared memory

> If my understanding is correct then please fully describe this scenario
> within the changelog and explain why it is tolerable, if it is
> tolerable.
>
OK, I'll.

>> @@ -2093,7 +2083,20 @@ static int elf_core_dump(struct coredump_params *cprm)
>>
>>       dataoff = offset = roundup(offset, ELF_EXEC_PAGESIZE);
>>
>> -     offset += elf_core_vma_data_size(gate_vma, cprm->mm_flags);
>> +     vma_filesz = kmalloc(sizeof(*vma_filesz) * (segs - 1), GFP_KERNEL);
>
> Use kmalloc_array() here, in case a disaster has occurred...
>
I'll try to find another way how to pass or save vma size with consistency.

>> +     if (!vma_filesz)
>> +             goto end_coredump;
>> +
>> +     for (i = 0, vma = first_vma(current, gate_vma); vma != NULL;
>> +                     vma = next_vma(vma, gate_vma)) {
>> +             unsigned long dump_size;
>> +
>> +             dump_size = vma_dump_size(vma, cprm->mm_flags);
>> +             vma_filesz[i++] = dump_size;
>> +             vma_data_size += dump_size;
>> +     }
>> +
>> +     offset += vma_data_size;
>
Thanks,
