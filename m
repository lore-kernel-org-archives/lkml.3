Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752936Ab3LJMVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 07:21:04 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:42488 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313Ab3LJMU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 07:20:59 -0500
MIME-Version: 1.0
Date: Tue, 10 Dec 2013 04:20:58 -0800
Message-ID: <CAMe9rOrKGSxr9X5txGq2Js0vGwXdwxPT+ip70-YZs-Wz-aPgQg@mail.gmail.com>
Subject: Re: RFC: binutils PATCH: Set e_type to ET_EXEC for -pie -Ttext-segment=
From: "H.J. Lu" <hjl.tools@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Binutils <binutils@sourceware.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 9, 2013 at 8:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Where do the _32 and _32S relocations come from?  Are we mixing multiple things inside -pie?

They come from crt1.o and crtbegin.o.  -pie uses Scrt1.o and crtbeginS.o.

> "H.J. Lu" <hjl.tools@gmail.com> wrote:
>>On Mon, Dec 9, 2013 at 7:23 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 12/09/2013 07:05 PM, H.J. Lu wrote:
>>>>>
>>>>> I see.  Maybe linker can set ET_EXEC if vaddr is non-zero.
>>>>>
>>>>
>>>> Linker sets e_type in ELF header to ET_DYN for -pie
>>-Ttext-segment=0xXXX.
>>>> When I added -Ttext-segment=0xXXX, one goal was to load
>>>> small model executable above 4GB on Linux/x86-64, which
>>>> was done with -pie -Ttext-segment=0xXXX.  But -pie sets
>>>> e_type in ELF header to ET_DYN and kernel may ignore
>>>> p_vaddr in ELF header to load ET_DYN binary at a random
>>>> address.  This patch changes ld to set e_type in ELF header
>>>> to ET_EXEC if the first PT_LOAD segment has non-zero
>>>> p_vaddr.  If this is unacceptable as generic ELF change,
>>>> I can make it specific to x86.
>>>>
>>>
>>> Why not just drop the -pie from the command line?  I would expect
>>-pie
>>> to set ET_DYN, but if you want to load at a specific address one
>>would
>>> expect to use -Ttext-segment=... and *not* -pie.
>>>
>>
>>No.  We must keep -pie.  Without -pie, we can't set -Ttext-segment=
>>to above 4GB:
>>
>>[hjl@gnu-6 tmp]$ gcc  a.c -Wl,-Ttext-segment=0x7ff000000
>>/usr/lib/gcc/x86_64-redhat-linux/4.8.2/../../../../lib64/crt1.o: In
>>function `_start':
>>(.text+0x12): relocation truncated to fit: R_X86_64_32S against symbol
>>`__libc_csu_fini' defined in .text section in
>>/usr/lib64/libc_nonshared.a(elf-init.oS)
>>/usr/lib/gcc/x86_64-redhat-linux/4.8.2/../../../../lib64/crt1.o: In
>>function `_start':
>>(.text+0x19): relocation truncated to fit: R_X86_64_32S against symbol
>>`__libc_csu_init' defined in .text section in
>>/usr/lib64/libc_nonshared.a(elf-init.oS)
>>/usr/lib/gcc/x86_64-redhat-linux/4.8.2/../../../../lib64/crt1.o: In
>>function `_start':
>>(.text+0x20): relocation truncated to fit: R_X86_64_32S against symbol
>>`main' defined in .text section in /tmp/ccV9AIMR.o
>>/usr/lib/gcc/x86_64-redhat-linux/4.8.2/crtbegin.o: In function
>>`deregister_tm_clones':
>>crtstuff.c:(.text+0x1): relocation truncated to fit: R_X86_64_32
>>against symbol `__TMC_END__' defined in .data section in a.out
>>crtstuff.c:(.text+0x8): relocation truncated to fit: R_X86_64_32S
>>against `.tm_clone_table'
>>crtstuff.c:(.text+0x23): relocation truncated to fit: R_X86_64_32
>>against `.tm_clone_table'
>>/usr/lib/gcc/x86_64-redhat-linux/4.8.2/crtbegin.o: In function
>>`register_tm_clones':
>>crtstuff.c:(.text+0x31): relocation truncated to fit: R_X86_64_32
>>against symbol `__TMC_END__' defined in .data section in a.out
>>crtstuff.c:(.text+0x38): relocation truncated to fit: R_X86_64_32S
>>against `.tm_clone_table'
>>crtstuff.c:(.text+0x63): relocation truncated to fit: R_X86_64_32
>>against `.tm_clone_table'
>>/usr/lib/gcc/x86_64-redhat-linux/4.8.2/crtbegin.o: In function
>>`frame_dummy':
>>crtstuff.c:(.text+0xa6): relocation truncated to fit: R_X86_64_32
>>against `.jcr'
>>/tmp/ccV9AIMR.o: In function `main':
>>a.c:(.text+0x5): additional relocation overflows omitted from the
>>output
>>collect2: error: ld returned 1 exit status
>>[hjl@gnu-6 tmp]$ gcc -fpie -pie  a.c -Wl,-Ttext-segment=0x7ff000000
>>[hjl@gnu-6 tmp]$
>>
>

-- 
H.J.
