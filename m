Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095AbaDHUTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 16:19:05 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:41449 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756748AbaDHUTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 16:19:02 -0400
MIME-Version: 1.0
In-Reply-To: <20140408194815.GA6188@debian>
References: <1396577719-14786-1-git-send-email-keescook@chromium.org>
	<1396577719-14786-3-git-send-email-keescook@chromium.org>
	<20140404195818.GA21028@debian>
	<CAGXu5jKPX2igsb2rQzdCZQZ8X3h4YZihCV9D+cDW3F+qii8H2A@mail.gmail.com>
	<1396960898.3567.55.camel@linaro1.home>
	<CAGXu5jJq24k4uQbBJmihJ4RScJ40o41oKFtm13hBO_YZOvHpkA@mail.gmail.com>
	<1396973561.14809.26.camel@linaro1.home>
	<CAGXu5jJewy0Xy-qUEF2K6bAcEC8ZdKy0Ad2nLPjGRsq20fSQXQ@mail.gmail.com>
	<20140408194815.GA6188@debian>
Date: Tue, 8 Apr 2014 13:19:01 -0700
X-Google-Sender-Auth: 3KiuvRtndHDapdig2ybSxqOBxwk
Message-ID: <CAGXu5jLkc2oFouYq3ZT1sUvgjjJY32_uEcuLLE4wHX-N0cFiFw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ARM: mm: make text and rodata read-only
From: Kees Cook <keescook@chromium.org>
To: Rabin Vincent <rabin@rab.in>
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
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

On Tue, Apr 8, 2014 at 12:48 PM, Rabin Vincent <rabin@rab.in> wrote:
> On Tue, Apr 08, 2014 at 09:59:07AM -0700, Kees Cook wrote:
>> On Tue, Apr 8, 2014 at 9:12 AM, Jon Medhurst (Tixy) <tixy@linaro.org> wrote:
>> > And is the page table being modified unique to the current CPU? I
>> > thought a common set of page tables was shared across all of them. If
>> > that is the case then one CPU can modify the PTE to be writeable,
>> > another CPU take a TLB miss and pull in that writeable entry, which will
>> > stay there until it drops out the TLB at some indefinite point in the
>> > future. That's the scenario I was getting at with my previous comment.
>>
>> As I understood it, this would be true for small PTEs, but sections
>> are fully duplicated on each CPU so we don't run that risk. This was
>> the whole source of my problem with this patch series: even a full
>> all-CPU TLB flush wasn't working -- the section permissions were
>> unique to the CPU since the entries were duplicated.
>
> The PGD is per-mm_struct.  mm_structs can be shared between processes.
> So the PGD is not per CPU.
>
> This set_kernel_text_rw() is called from ftrace in stop_machine() on one
> CPU.  All other CPUs will be spinning in kernel threads inside the loop
> in multi_cpu_stop(), with interrupts disabled.  Since kernel threads use
> the last process' mm, it is possible for the other CPU(s) to be
> currently using the same mm as the modifying CPU.
>
> For any other CPU to pull in the writable entry it would have to get a
> TLB miss inside the loop in multi_cpu_stop(), after the state transition
> to MULTI_STOP_RUN and before the state transition to MULTI_STOP_EXIT.
> This is unlikely, but theoretically possible, for example if
> multi_cpu_stop() straddles sections.

Ah! Now I understand. Thanks for the clarification.

> To prevent any stale entries being used indefinitely, perhaps the all
> CPU TLB flush can be inserted into
> ftrace_arch_code_modify_post_process(), which is called after the
> stop_machine() and which is where x86 for example makes the entries
> read-only again.

Do you mean something like this?

diff --git a/arch/arm/kernel/ftrace.c b/arch/arm/kernel/ftrace.c
index ea446ae09c89..b8c75e45a950 100644
--- a/arch/arm/kernel/ftrace.c
+++ b/arch/arm/kernel/ftrace.c
@@ -90,6 +90,8 @@ int ftrace_arch_code_modify_prepare(void)
 int ftrace_arch_code_modify_post_process(void)
 {
        set_all_modules_text_ro();
+       /* Make sure any TLB misses during machine stop are cleared. */
+       flush_tlb_all();
        return 0;
 }

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
