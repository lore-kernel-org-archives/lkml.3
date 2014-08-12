Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaHLVrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 17:47:40 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:57472 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbaHLVri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 17:47:38 -0400
MIME-Version: 1.0
In-Reply-To: <53EA897D.8030901@codeaurora.org>
References: <1407867869-5194-1-git-send-email-keescook@chromium.org>
	<1407867869-5194-4-git-send-email-keescook@chromium.org>
	<53EA897D.8030901@codeaurora.org>
Date: Tue, 12 Aug 2014 14:47:37 -0700
X-Google-Sender-Auth: lZJvwZL18I1EVDLofhWGORapXGg
Message-ID: <CAGXu5j+TPBs9h9YvVDt=g4WFykHgzcde9Ujuef=cRQAou8hZoA@mail.gmail.com>
Subject: Re: [PATCH v3 3/7] arm: use fixmap for text patching when text is RO
From: Kees Cook <keescook@chromium.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Liu hua <sdu.liu@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Will Deacon <will.deacon@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Doug Anderson <dianders@google.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Mark Salter <msalter@redhat.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 12, 2014 at 2:39 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 08/12/14 11:24, Kees Cook wrote:
>> diff --git a/arch/arm/kernel/patch.c b/arch/arm/kernel/patch.c
>> index 07314af47733..03dd4e39c833 100644
>> --- a/arch/arm/kernel/patch.c
>> +++ b/arch/arm/kernel/patch.c
>> @@ -13,21 +16,69 @@ struct patch {
>>       unsigned int insn;
>>  };
>>
>> -void __kprobes __patch_text(void *addr, unsigned int insn)
>> +static DEFINE_SPINLOCK(patch_lock);
>> +
>> +static void __kprobes *patch_map(void *addr, int fixmap, unsigned long *flags)
>> +{
>> +     unsigned int uintaddr = (uintptr_t) addr;
>> +     bool module = !core_kernel_text(uintaddr);
>> +     struct page *page;
>> +
>> +     if (module && IS_ENABLED(CONFIG_DEBUG_SET_MODULE_RONX))
>> +             page = vmalloc_to_page(addr);
>> +     else if (!module && IS_ENABLED(CONFIG_DEBUG_RODATA))
>> +             page = virt_to_page(addr);
>> +     else
>> +             return addr;
>> +
>> +     if (flags)
>> +             spin_lock_irqsave(&patch_lock, *flags);
>> +
>> +     set_fixmap(fixmap, page_to_phys(page));
>> +
>> +     return (void *) (__fix_to_virt(fixmap) + (uintaddr & ~PAGE_MASK));
>> +}
>> +
>> +static void __kprobes patch_unmap(int fixmap, unsigned long *flags)
>> +{
>> +     clear_fixmap(fixmap);
>> +
>> +     if (flags)
>> +             spin_unlock_irqrestore(&patch_lock, *flags);
>> +}
>
> Has the kbuildbot complained about this one yet?
>
>   CHECK  arch/arm/kernel/patch.c
>   arch/arm/kernel/patch.c:47:39: warning: context imbalance in
> 'patch_unmap' - unexpected unlock
>
> I guess we're going to ignore it.

No, nothing yet from buildbot, let me do a sparse run -- I think we
can just add annotation and we'll be okay.

-Kees

-- 
Kees Cook
Chrome OS Security
