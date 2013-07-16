Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab3GPX7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 19:59:10 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42151 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab3GPX7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 19:59:09 -0400
MIME-Version: 1.0
In-Reply-To: <51E5DAA5.3010806@zytor.com>
References: <20130716183441.GA14232@www.outflux.net>
	<CAE9FiQWSe-M8XhFvWM3Q5P3kj6_EvUFMSvCkrDZUH7WdPPp35g@mail.gmail.com>
	<CAGXu5jJd11FeaTEQc6=8=PgL56VeC0W37U=RvS-iJ-sP+Raeaw@mail.gmail.com>
	<1374006818.6458.62.camel@gandalf.local.home>
	<CAGXu5jJNjHFJS0GfJVQm2++YtTn2yUfCAkf3u10REh=8DdeZCg@mail.gmail.com>
	<51E5C31C.8000606@zytor.com>
	<CAE9FiQW-3H=rx-VewjMQjx2EOwcyDt351aQ0wnP8op6ZLViZag@mail.gmail.com>
	<51E5C65A.9010605@zytor.com>
	<CAE9FiQVMQyhy57MhrkCH7TYqhwgb5tHFjSxhCh8KcN+DNuXE4Q@mail.gmail.com>
	<51E5DAA5.3010806@zytor.com>
Date: Tue, 16 Jul 2013 16:59:08 -0700
X-Google-Sender-Auth: kDjDI0irv7dL1yf7g1f1854Lyqg
Message-ID: <CAE9FiQUrdVW3+FzNhbuubDcZasvsipKwGhsnqxgAmxpVkKryfQ@mail.gmail.com>
Subject: Re: [PATCH v5] x86: make sure IDT is page aligned
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, Steven Rostedt <rostedt@goodmis.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Seiji Aguchi <seiji.aguchi@hds.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        PaX Team <pageexec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 16, 2013 at 4:43 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 07/16/2013 04:39 PM, Yinghai Lu wrote:
>>
>> ok. so the old code is just for optimization to keep it cacheline aligned?
>>
>
> To the best of my knowledge.  I guess I should look through the git log
> to make sure it isn't some old erratum fix.
>
looks like before
commit e57113bc1ff591005ec0b0fb4885d97c01de73d8
Author: Jan Beulich <jbeulich@novell.com>
Date:   Sat Mar 25 16:30:01 2006 +0100

    [PATCH] x86_64: miscellaneous cleanup

    - adjust limits of GDT/IDT pseudo-descriptors (some were off by one)
    - move empty_zero_page into .bss.page_aligned
    - move cpu_gdt_table into .data.page_aligned
    - move idt_table into .bss
    - align inital_code and init_rsp
    - eliminate pointless (re-)declaration of idt_table in traps.c

it is PAGE aligned as it is after gdt page, after the commit, it is
cacheline aligned.


@@ -378,9 +378,12 @@ gdt_end:
        /* zero the remaining page */
        .fill PAGE_SIZE / 8 - GDT_ENTRIES,8,0

-ENTRY(idt_table)
-       .rept   256
-       .quad   0
-       .quad   0
-       .endr
+       .section .bss, "aw", @nobits
+       .align L1_CACHE_BYTES
+ENTRY(idt_table)
+       .skip 256 * 16

+       .section .bss.page_aligned, "aw", @nobits
+       .align PAGE_SIZE
+ENTRY(empty_zero_page)
+       .skip PAGE_SIZE
