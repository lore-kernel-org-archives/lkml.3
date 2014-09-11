Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015AbaIKQ1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 12:27:06 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:32936 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756867AbaIKQ1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 12:27:04 -0400
MIME-Version: 1.0
In-Reply-To: <20140911161636.GU6158@arm.com>
References: <CAGXu5jKimGaupwyUwt0Zwa3OtjeoED8-uBeMX0MwXjBYP6ssAg@mail.gmail.com>
	<20140904172748.GO7156@arm.com>
	<20140908191634.GV5598@outflux.net>
	<20140908215506.GA4759@dator>
	<CAGXu5jJFB+pcDVkcMoRZ9DnJu7MQuN=kceDhpkGrO=6ZLFy6Kw@mail.gmail.com>
	<20140909123829.GK1754@arm.com>
	<CAGXu5jJoW-B7WwuFUhbN4e1aL-HVxa9x4da9hB9DcCGEXVLgzw@mail.gmail.com>
	<20140910175126.GJ1710@arm.com>
	<CAGXu5jJaML_S+6LUn1uPLrScXxUJL+1N1B+Fa08ioxKt933nCw@mail.gmail.com>
	<CAGXu5jJ_wLsKOuVgbS7cb+k-nyA=8XpaMYwov0o3hdFdyjaCmA@mail.gmail.com>
	<20140911161636.GU6158@arm.com>
Date: Thu, 11 Sep 2014 09:27:03 -0700
X-Google-Sender-Auth: VuHxam9cmByYUTTfnNbVQcGaCqs
Message-ID: <CAGXu5jJ1zZ3bxJ8B-FR_2STDuMMFp_H3dAKrpJmv+dH7iDSwCA@mail.gmail.com>
Subject: Re: [PATCH v5 3/8] arm: fixmap: implement __set_fixmap()
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Rabin Vincent <rabin@rab.in>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh@kernel.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 9:16 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Thu, Sep 11, 2014 at 05:05:14PM +0100, Kees Cook wrote:
>> Actually, this doesn't make sense. If we're using
>> local_flush_tlb_kernel_range() in set_fixmap, we must always run under
>> stop_machine. The needs-broadcast case is solved by using
>> local_flush_tlb_kernel_range(), and the TLB-miss-on-other-CPU case is
>> solved by using stop_machine(). This is how the ftrace case work,
>> though not via fixmap.
>>
>> Since we need to flush the TLB on each fixmap change during
>> patch_text(), if we want to make the local_flush_tlb_... optionally
>> use flush_tlb_... to avoid calling stop_machine in the
>> does't-need-broadcast case, then we'd be checking in multiple places,
>> making this code overly complex for this rare operation. Is there a
>> good reason to complicate this code to avoid stop_machine()?
>>
>> I think we should just do this:
>>
>> diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
>> index 07314af47733..5038960e3c55 100644
>> --- a/arch/arm/kernel/patch.c
>> +++ b/arch/arm/kernel/patch.c
>> @@ -60,16 +125,5 @@ void __kprobes patch_text(void *addr, unsigned int insn)
>>                 .insn = insn,
>>         };
>>
>> -       if (cache_ops_need_broadcast()) {
>> -               stop_machine(patch_text_stop_machine, &patch, cpu_online_mask);
>> -       } else {
>> -               bool straddles_word = IS_ENABLED(CONFIG_THUMB2_KERNEL)
>> -                                     && __opcode_is_thumb32(insn)
>> -                                     && ((uintptr_t)addr & 2);
>> -
>> -               if (straddles_word)
>> -                       stop_machine(patch_text_stop_machine, &patch, NULL);
>> -               else
>> -                       __patch_text(addr, insn);
>> -       }
>> +       stop_machine(patch_text_stop_machine, &patch, NULL);
>
> The reason not to use stop machine is that it's very expensive and the
> architecture does provide some guarantees that mean it's not always
> required...
>
> ... however, as I pointed out in a kprobes thread the other day, the code
> you remove above is actually broken, so I wouldn't be against replacing it
> all with stop_machine.

Okay, sounds good.

> Is there any way to you can WARN_ON(!called_under_stop_machine) in
> set_fixmap before doing the local TLBI?

I'm not sure what the right tests for that would be. As I understand
it, this can be called during early boot too, but I'm not sure how to
distinguish either being early or being under stop machine. Rabin or
Rob, I think you've worked on this from the perspective of early boot,
any ideas?

In the meantime, I could add a comment on set_fixmap...

>
> Will
>
> P.S. If you plan on doing an equivalent series for arm64, you should do it
> before we have any broken CPUs, then you can use TLBI without worry ;)

Heh. Hopefully I can start testing arm64 soon. I think Laura sent a
series for CONFIG_DEBUG_RODATA already, so I'm hoping by the time I
get 64-bit hardware, this will already be done. ;)

-Kees

-- 
Kees Cook
Chrome OS Security
