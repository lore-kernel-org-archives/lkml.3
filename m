Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbaDHQ7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:59:10 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:39351 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768AbaDHQ7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <1396973561.14809.26.camel@linaro1.home>
References: <1396577719-14786-1-git-send-email-keescook@chromium.org>
	<1396577719-14786-3-git-send-email-keescook@chromium.org>
	<20140404195818.GA21028@debian>
	<CAGXu5jKPX2igsb2rQzdCZQZ8X3h4YZihCV9D+cDW3F+qii8H2A@mail.gmail.com>
	<1396960898.3567.55.camel@linaro1.home>
	<CAGXu5jJq24k4uQbBJmihJ4RScJ40o41oKFtm13hBO_YZOvHpkA@mail.gmail.com>
	<1396973561.14809.26.camel@linaro1.home>
Date: Tue, 8 Apr 2014 09:59:07 -0700
X-Google-Sender-Auth: mV5_jx23MNnQ00tpi5yBNzpngHM
Message-ID: <CAGXu5jJewy0Xy-qUEF2K6bAcEC8ZdKy0Ad2nLPjGRsq20fSQXQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: mm: make text and rodata read-only
From: Kees Cook <keescook@chromium.org>
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Rabin Vincent <rabin@rab.in>, Russell King <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2014 at 9:12 AM, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
> On Tue, 2014-04-08 at 09:01 -0700, Kees Cook wrote:
>> On Tue, Apr 8, 2014 at 5:41 AM, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
>> > On Fri, 2014-04-04 at 17:07 -0700, Kees Cook wrote:
>> >> On Fri, Apr 4, 2014 at 12:58 PM, Rabin Vincent <rabin@rab.in> wrote:
>> > [...]
>> >> > You need a TLB flush.  I had a flush_tlb_all() in my example patch,
>> >> > http://lists.infradead.org/pipermail/linux-arm-kernel/2014-April/244335.html,
>> >> > but the following is probably nicer (on top of this patch):
>> >> >
>> >> > diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
>> >> > index 9bea524..a92c45a 100644
>> >> > --- a/arch/arm/mm/init.c
>> >> > +++ b/arch/arm/mm/init.c
>> >> > @@ -741,6 +741,8 @@ static inline bool arch_has_strict_perms(void)
>> >> >                      addr += SECTION_SIZE)                              \
>> >> >                         section_update(addr, perms[i].mask,             \
>> >> >                                        perms[i].field);                 \
>> >> > +                                                                       \
>> >> > +               flush_tlb_kernel_range(perms[i].start, perms[i].end);   \
>> >> >         }                                                               \
>> >> >  }
>> >> >
>> >>
>> >> When I do this, I hang the system, and get a WARN due to the tlb call
>> >> attempting to flush on all CPUs, I think:
>> >>
>> >> [   34.246034] WARNING: at
>> >> /mnt/host/source/src/third_party/kernel-next/kernel/smp.c:466
>> >> smp_call_function_many+0xac/0x26c()
>> >> ...
>> >> [   34.246617] Backtrace:
>> >> [   34.246697] [<c010d3b8>] (unwind_backtrace+0x0/0x118) from
>> >> [<c060b9d8>] (dump_stack+0x28/0x30)
>> >> [   34.246765] [<c060b9d8>] (dump_stack+0x28/0x30) from [<c0123044>]
>> >> (warn_slowpath_null+0x44/0x5c)
>> >> [   34.246824] [<c0123044>] (warn_slowpath_null+0x44/0x5c) from
>> >> [<c017426c>] (smp_call_function_many+0xac/0x26c)
>> >> [   34.246881] [<c017426c>] (smp_call_function_many+0xac/0x26c) from
>> >> [<c0174468>] (smp_call_function+0x3c/0x48)
>> >> [   34.246937] [<c0174468>] (smp_call_function+0x3c/0x48) from
>> >> [<c010c0fc>] (broadcast_tlb_a15_erratum+0x40/0x4c)
>> >> [   34.246994] [<c010c0fc>] (broadcast_tlb_a15_erratum+0x40/0x4c) from
>> >> [<c010c590>] (flush_tlb_kernel_range+0x74/0xa0)
>> >> [   34.247046] [<c010c590>] (flush_tlb_kernel_range+0x74/0xa0) from
>> >> [<c011403c>] (set_kernel_text_rw+0xd8/0xec)
>> >> [   34.247099] [<c011403c>] (set_kernel_text_rw+0xd8/0xec) from
>> >> [<c010c878>] (__ftrace_modify_code+0x14/0x28)
>> >> [   34.247156] [<c010c878>] (__ftrace_modify_code+0x14/0x28) from
>> >> [<c0184318>] (stop_machine_cpu_stop+0xc0/0x114)
>> >> [   34.247212] [<c0184318>] (stop_machine_cpu_stop+0xc0/0x114) from
>> >> [<c01841cc>] (cpu_stopper_thread+0xd8/0x164)
>> >> [   34.247266] [<c01841cc>] (cpu_stopper_thread+0xd8/0x164) from
>> >> [<c0145c14>] (kthread+0xc8/0xd8)
>> >> [   34.247323] [<c0145c14>] (kthread+0xc8/0xd8) from [<c0106118>]
>> >> (ret_from_fork+0x14/0x20)
>> >>
>> >> Using local_flush_tlb_kernel_range() fixed it though.
>> >
>> > What about if another CPU had a TLB entry with the old permissions in?
>> > Or do you consider that the likelihood and consequences of that aren't
>> > significant?
>>
>> The purpose of the function is to temporarily make text writable, do
>> the write, and then restore read-only. Since only the writer needs to
>> care about TLB state, this works fine. It's actually nice that only
>> the current CPU can make text writes.
>
> And is the page table being modified unique to the current CPU? I
> thought a common set of page tables was shared across all of them. If
> that is the case then one CPU can modify the PTE to be writeable,
> another CPU take a TLB miss and pull in that writeable entry, which will
> stay there until it drops out the TLB at some indefinite point in the
> future. That's the scenario I was getting at with my previous comment.

As I understood it, this would be true for small PTEs, but sections
are fully duplicated on each CPU so we don't run that risk. This was
the whole source of my problem with this patch series: even a full
all-CPU TLB flush wasn't working -- the section permissions were
unique to the CPU since the entries were duplicated.

-Kees

-- 
Kees Cook
Chrome OS Security
