Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222AbaBKSWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 13:22:43 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:61177 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaBKSWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 13:22:41 -0500
MIME-Version: 1.0
In-Reply-To: <20140211111751.GD3748@arm.com>
References: <20140209221826.GA30556@www.outflux.net>
	<20140210102935.GC25305@arm.com>
	<20140210104135.GD25305@arm.com>
	<CAGXu5jL0asY2L9xvnEDwBPQoWYZAVHjtG+U7nyz=JfZtXFK34A@mail.gmail.com>
	<20140211111751.GD3748@arm.com>
Date: Tue, 11 Feb 2014 10:22:40 -0800
X-Google-Sender-Auth: 8aGQsMNwjBVWBLkNGiw4z14AT4E
Message-ID: <CAGXu5jKhp515gX--i-B85T1cGhTOUu2K8JuXNq5XDpxZHcCUPw@mail.gmail.com>
Subject: Re: [PATCH] ARM: mm: report both sections from PMD
From: Kees Cook <keescook@chromium.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <Will.Deacon@arm.com>,
        Steven Capper <steve.capper@linaro.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Cyril Chemparathy <cyril@ti.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 11, 2014 at 3:17 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, Feb 10, 2014 at 05:26:28PM +0000, Kees Cook wrote:
>> On Mon, Feb 10, 2014 at 2:41 AM, Catalin Marinas
>> <catalin.marinas@arm.com> wrote:
>> > On Mon, Feb 10, 2014 at 10:29:35AM +0000, Catalin Marinas wrote:
>> >> On Sun, Feb 09, 2014 at 10:18:26PM +0000, Kees Cook wrote:
>> >> > diff --git a/arch/arm/mm/dump.c b/arch/arm/mm/dump.c
>> >> > index 1f7b1e13d945..ff1559f9200c 100644
>> >> > --- a/arch/arm/mm/dump.c
>> >> > +++ b/arch/arm/mm/dump.c
>> >> > @@ -264,6 +264,9 @@ static void walk_pmd(struct pg_state *st, pud_t *pud, unsigned long start)
>> >> >                     note_page(st, addr, 3, pmd_val(*pmd));
>> >> >             else
>> >> >                     walk_pte(st, pmd, addr);
>> >> > +
>> >> > +           if (SECTION_SIZE < PMD_SIZE && pmd_sect(*pmd))
>> >> > +                   note_page(st, addr + SECTION_SIZE, 3, pmd_val(pmd[1]));
>> >>
>> >> You can  use pmd_large() here as well.
>> >>
>> >> But I think this function is broken (the "for" statement not shown
>> >> here). The pmd_t is 32-bit with classic MMU and it uses pmd++ while the
>> >> address grows by PMD_SIZE (two pmd_t entries).
>> >
>> > Actually it's ok since PTRS_PER_PMD is 1, so it only goes through this
>> > loop once.
>> >
>> > But in your patch shouldn't you check for pmd_large(*(pmd+1))? The first
>> > pmd is already caught by the 'if' statement.
>>
>> It wasn't clear to me what the logic should be here. If PTRS_PER_PMD
>> is 1, then why is there this second pmd after the first? Shouldn't
>> PTRS_PER_PMD be 2 if that's the case?
>
> The reason is that a hardware pte has only 256 entries (classic MMU),
> this is 1KB. We put two pte tables together and it gives us 2KB. The
> other 2KB in the page are used for Linux pte bits. Because we have two
> hw pte tables in a page, we need two corresponding pmd entries.
>
> A side effect is that even though we don't actually have a pmd (normally
> we should have included pgtable-nopmd.h), we still pretend we have one
> and __pmd_populate takes care of writing two consecutive entries. If we
> set PTRS_PER_PMD to 2, we should modify pte_alloc_one() to allocate a
> single hw pte (1KB + 1KB for software bits). I don't think this would be
> more efficient (there may have been other kernel restrictions in the
> past to require a full pte table page).
>
>> If that's not the case, then I figured the state of needing to report
>> the 2nd pmd depended on the type of the first one, so that's what I
>> wrote instead of trying to figure out why PTRS_PER_PMD wasn't 2.
>
> I don't remember whether we can have the first pmd being a table and the
> second one being a section. I don't think we restrict this but Russell
> should know more.

It sounds like my logic is still okay, then? Perhaps move it into the
first "if" for readability?

                if (pmd_none(*pmd) || pmd_large(*pmd) || !pmd_present(*pmd)) {
                        note_page(st, addr, 3, pmd_val(*pmd));
                        if (SECTION_SIZE < PMD_SIZE && pmd_sect(*pmd))
                                note_page(st, addr + SECTION_SIZE, 3,
pmd_val(pmd[1]));
                } else
                        walk_pte(st, pmd, addr);

Or should be be explicitly separated (to allow for the very unlikely
future case of pmd_large != pmd_sect)? In the LPAE case, SECTION_SIZE
== PMD_SIZE, so IIUC, we have to continue testing for that:

                if (pmd_sect(*pmd)) {
                        note_page(st, addr, 3, pmd_val(*pmd));
                        if (SECTION_SIZE < PMD_SIZE)
                                note_page(st, addr + SECTION_SIZE, 3,
pmd_val(pmd[1]));
                } else if (pmd_none(*pmd) || pmd_large(*pmd) ||
!pmd_present(*pmd))
                        note_page(st, addr, 3, pmd_val(*pmd));
                else
                        walk_pte(st, pmd, addr);

>> There's clearly something I'm not understanding in here. :)
>
> I happen to understand it from time to time but it doesn't last ;).

Heh, understood. Thanks for looking at this. :)

-Kees

-- 
Kees Cook
Chrome OS Security
