Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbbAVIn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 03:43:28 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:56171 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbbAVInS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 03:43:18 -0500
MIME-Version: 1.0
In-Reply-To: <54C0B19D.4020804@codesourcery.com>
References: <54C0A357.4070701@gmail.com>
	<CAFiDJ58imeQEZxySFOYoYd27YU4wCYrsw+oDe8Pi3j3n13o2mg@mail.gmail.com>
	<54C0B19D.4020804@codesourcery.com>
Date: Thu, 22 Jan 2015 16:43:16 +0800
X-Google-Sender-Auth: kMmC0r63AI3rpd9lX3bhWkC-IKo
Message-ID: <CAFiDJ58=zM5Vk9M_z6tuW0nROjougVS+KYuZkhm0sgKw-vq=7w@mail.gmail.com>
Subject: Re: [PATCH] nios2: __kuser_sigtramp placement fix
From: Ley Foon Tan <lftan@altera.com>
To: Chung-Lin Tang <cltang@codesourcery.com>
Cc: Chung-Lin Tang <chunglin.tang@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tobias Klauser <tklauser@distanz.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:15 PM, Chung-Lin Tang <cltang@codesourcery.com> wrote:
> On 2015/1/22 03:54 PM, Ley Foon Tan wrote:
>> On Thu, Jan 22, 2015 at 3:14 PM, Chung-Lin Tang <chunglin.tang@gmail.com> wrote:
>>> The address of __kuser_sigtramp is wrong by one word, due to padding
>>> __kuser_cmpxchg to fully 64 bytes. The version word at the start of the
>>> page displaces __kuser_sigtramp to 0x1044, instead of the intended 0x1040.
>>>
>>> Fixed by counting the 64-byte frame from the start of the page instead
>>> of __kuser_cmpxchg. This shortens the __kuser_cmpxchg frame to 60-bytes,
>>> but that's likely enough.
>>>
>>> The zero-byte padding parts of the kuser_pad macro has been removed, due
>>> to the .if command refusing to behave properly when there are other
>>> .word directives in between. Probably a binutils gas bug.
>>>
>>> Thanks,
>>> Chung-Lin
>>>
>>> Cc: Ley Foon Tan <lftan@altera.com>
>>> Cc: Tobias Klauser <tklauser@distanz.ch>
>>> Signed-off-by: Chung-Lin Tang <cltang@codesourcery.com>
>>>
>>> diff --git a/arch/nios2/kernel/entry.S b/arch/nios2/kernel/entry.S
>>> index 0bdfd13..3224839 100644
>>> --- a/arch/nios2/kernel/entry.S
>>> +++ b/arch/nios2/kernel/entry.S
>>> @@ -492,14 +492,7 @@ ENTRY(ret_from_kernel_thread)
>>>
>>>   /* Filling pads with undefined instructions. */
>>>  .macro kuser_pad sym size
>>> -       .if     ((. - \sym) & 3)
>>> -       .rept   (4 - (. - \sym) & 3)
>>> -       .byte   0
>>> -       .endr
>>> -       .endif
>>> -       .rept   ((\size - (. - \sym)) / 4)
>>> -       .word   0xdeadbeef
>>> -       .endr
>>> +       .fill   ((\size - (. - \sym)) / 4), 4, 0xdeadbeef
>>>  .endm
>>>
>>>         .align  6
>>> @@ -526,7 +519,10 @@ cmpxchg_stw:
>>>  cmpxchg_ret:
>>>         ret
>>>
>>> -       kuser_pad __kuser_cmpxchg, 64
>>> +       /* The first 64-byte frame contains the version word, so note
>>> +          that the first padding entry is based from the start of the kuser
>>> +          page, instead of __kuser_cmpxchg.  */
>>> +       kuser_pad __kuser_helper_start, 64
>>>
>>>         .globl  __kuser_sigtramp
>>>  __kuser_sigtramp:
>>> --
>> Hi Chung-Lin
>>
>> I thought this is our original intention for it.
>>
>> First 4 bytes is the __kuser_version and each __kuser function will
>> have 64 bytes size.
>>
>> 0x1000 __kuser_helper_version
>> 0x1004 __kuser_cmpxchg
>> 0x1044 __kuser_sigtramp
>>
>> Any reason you can't use __kuser_sigtramp @ 0x1044?
>
> Well, that's okay as well, as the main place which sets this is the
> signal frame construction in arch/nios2/kernel/signal.c. The user space
> is mostly oblivious to the exact location.  You'll need to update it
> that way if you prefer 0x1044, as it's currently set at 0x1040.
>
> I suggested 0x1040 because 64b frames aligned at 64b seemed more
> intuitive; __kuser_cmpxchg would be a special case.

I think I will change to 0x1044 in arch/nios2/kernel/signal.c. I can
submit the fix.
Do you need to update toolchain for this change?

Regards
Ley Foon
