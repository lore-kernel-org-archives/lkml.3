Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab3KVJpX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 04:45:23 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:52330 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879Ab3KVJpS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 04:45:18 -0500
MIME-Version: 1.0
In-Reply-To: <CAGG-pUTec1mzz-nXSGVyMHPZ8PQ=hMrbTLnnRoLZ8ju=EKo98g@mail.gmail.com>
References: <1384994071-12283-1-git-send-email-geyslan@gmail.com>
	<20131121013918.GI10323@ZenIV.linux.org.uk>
	<CAGG-pUTec1mzz-nXSGVyMHPZ8PQ=hMrbTLnnRoLZ8ju=EKo98g@mail.gmail.com>
Date: Fri, 22 Nov 2013 07:45:16 -0200
Message-ID: <CAGG-pUQHP5hGeWXX5aBo7JT2L=04U2BwTYg2SqHy-0RN3SL-0A@mail.gmail.com>
Subject: Re: [PATCH v2] fs: binfmt_elf: Add ELF header consistency checks
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "open list:FILESYSTEMS (VFS...), linux-kernel@vger.kernel.org (open
	list)" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/11/21 Geyslan Gregório Bem <geyslan@gmail.com>:
> 2013/11/20 Al Viro <viro@zeniv.linux.org.uk>:
>> On Wed, Nov 20, 2013 at 09:34:31PM -0300, Geyslan G. Bem wrote:
>>> The member 'e_ehsize' that holds the ELF header size is compared
>>> with the elfhdr struct size. If not equal, goes out.
>>> If 'e_phoff' holds 0 the object has no program header table, so
>>> goes out.
>>> Ensures the file being loaded has the correct data encoding, checking
>>> 'e_ident[EI_DATA]' against 'ELF_DATA'.
>>>
>>> Besides the checks being in accordance with the ELF Specifications,
>>> they increase the binary consistency reducing the use of malformed ones.
>>
>> This is completely misguided.  We are allowed to reject such binaries,
>> but what's the point of doing that?
>
> Viro, First of all, thanks for reply.
>
> The security (or anti-security) guys are used to mess up with the not checked
> header fields for their "benefits": anti-debugging, injection and so on.
>
> Concerning to 'e_phoff': when it is 0 the check avoids that 'elf_phdr' been read
> from a erroneous offset (ELF header). I know that without this check the binary
> will goes out anyway. But it reduces wasting cpu cycles.
>
> Regarding 'e_ident[EI_DATA]': that check also prevents a farther code reading
> when the binary, although been the correct arch, is compiled with a different
> data encoding (MSB vs LSB).
>
> So checking besides increase the binary consistency, guarantee some mislead
> and fewer cpu cycles.
>
> --
> Regards,
>
> Geyslan G. Bem
> hackingbits.com

Another good reason is that ld does reject such binaries (I hex edit
one to hold MSB value in header):

uzumaki@hb ~ $ /lib/ld-linux-x86-64.so.2 ./a.out
./a.out: error while loading shared libraries: ./a.out: ELF file data
encoding not little-endian

After zeroing the phoff:

uzumaki@hb ~ $ /lib/ld-linux-x86-64.so.2 ./a.out
./a.out: error while loading shared libraries: ./a.out: object file
has no loadable segments

I really think that is a way to get a more robust binfmt consistency check.

What you think?

-- 
Regards,

Geyslan G. Bem
hackingbits.com
