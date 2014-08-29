Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbaH2QEo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 12:04:44 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34723 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaH2QEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 12:04:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140826144303.GX23445@arm.com>
References: <1407949593-16121-1-git-send-email-keescook@chromium.org>
	<1407949593-16121-8-git-send-email-keescook@chromium.org>
	<20140819123342.GJ23128@arm.com>
	<CAGXu5jLnXeavr4E4YF9jtB03iA-y4vLZjf83a8ABzUC-hdkz9w@mail.gmail.com>
	<20140826144303.GX23445@arm.com>
Date: Fri, 29 Aug 2014 09:04:41 -0700
X-Google-Sender-Auth: GMi34rg8P3bli_gcFRIbgSLq7cs
Message-ID: <CAGXu5j+OnpaZAJRsSsR=iid8178p+4hR5xzrJ7N3F94DZ7DYMg@mail.gmail.com>
Subject: Re: [PATCH v4 7/8] ARM: mm: allow non-text sections to be non-executable
From: Kees Cook <keescook@chromium.org>
To: Will Deacon <will.deacon@arm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh@kernel.org>, Laura Abbott <lauraa@codeaurora.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        Rabin Vincent <rabin@rab.in>, Liu hua <sdu.liu@huawei.com>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 7:43 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Wed, Aug 20, 2014 at 01:37:14PM +0100, Kees Cook wrote:
>> On Tue, Aug 19, 2014 at 7:33 AM, Will Deacon <will.deacon@arm.com> wrote:
>> > On Wed, Aug 13, 2014 at 06:06:32PM +0100, Kees Cook wrote:
>> >> +/*
>> >> + * Updates section permissions only for the current mm (sections are
>> >> + * copied into each mm). During startup, this is the init_mm.
>> >> + */
>> >> +static inline void section_update(unsigned long addr, pmdval_t mask,
>> >> +                               pmdval_t prot)
>> >> +{
>> >> +     struct mm_struct *mm;
>> >> +     pmd_t *pmd;
>> >> +
>> >> +     mm = current->active_mm;
>> >> +     pmd = pmd_offset(pud_offset(pgd_offset(mm, addr), addr), addr);
>> >> +
>> >> +#ifdef CONFIG_ARM_LPAE
>> >> +     pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
>> >> +#else
>> >> +     if (addr & SECTION_SIZE)
>> >> +             pmd[1] = __pmd((pmd_val(pmd[1]) & mask) | prot);
>> >> +     else
>> >> +             pmd[0] = __pmd((pmd_val(pmd[0]) & mask) | prot);
>> >> +#endif
>> >> +     flush_pmd_entry(pmd);
>> >> +     local_flush_tlb_kernel_range(addr, addr + SECTION_SIZE);
>> >
>> > Why only a local flush? You're changing global mappings here, right?
>>
>> Yes, but with the a15 errata, it cannot use a global flush. As a
>> result, section_update can only be used by a single CPU which is how
>> the usage is managed. Perhaps I should add some comments to that
>> effect? (There was a thread a few months ago on this problem and this
>> shook out as a solution.)
>
> Hmm, so do you mandate that preemption is disabled during sections of code
> where the permissions must be changed after boot? (e.g. ftrace patching)

I guess it's not enforced (how do I make sure preempt is off?), but
it's only used during the ftrace patching. I'm open to suggestions! (I
had avoided going the fixmap route since I would have expected that to
be much slower.)

-Kees

-- 
Kees Cook
Chrome OS Security
