Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450AbaKQEAT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 23:00:19 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:35628 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbaKQEAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 23:00:16 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.11.1411162127310.3909@nanos>
References: <20141114204517.GA24402@www.outflux.net>
	<CAE9FiQULexNgTYCrQgQK+ccNTVDyiJCWkgiDVgbPG-5SY0uPGQ@mail.gmail.com>
	<CAE9FiQV=i=+tO2Xum0EYdnqjqso1=twHUfjGZHEASVhUGE-x2g@mail.gmail.com>
	<CAGXu5j+8sEhgmHtdky7G5X2arRsSQSjA=xxuBPPZZAP7v046dg@mail.gmail.com>
	<alpine.DEB.2.11.1411162127310.3909@nanos>
Date: Sun, 16 Nov 2014 20:00:16 -0800
X-Google-Sender-Auth: -sH6Z8j-kb8hzdfGd4GqcG3MMPg
Message-ID: <CAE9FiQUtKUWzwc57rzf-VZfAoZSzYZ6JujLdd_0Uc7nVCxF1YQ@mail.gmail.com>
Subject: Re: [PATCH v2] x86, mm: set NX across entire PMD at boot
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Wang Nan <wangnan0@huawei.com>, David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 16, 2014 at 3:44 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> _brk_end is adjusted at boot time via extend_brk() up to __brk_limit,
> which is the same as _end. We usually do not use all of that space. So
> it's expected that _brk_end < _end.
>
>> Is this correct? It sounded like tglx wanted the pmd split, like this:
>
> Yes, I wanted to get rid of the high mapping for anything between
> _brk_end and _end, and I brought you on the wrong track with my
> suggestion to call free_init_pages(). Sorry about that.

:)

>
> That happened because I missed the completely non obvious fact, that
> only the effective brk section is reserved for the kernel via
> reserve_brk(). So the area between _brk_end and _end is already
> reusable. Though that reuse works only by chance and not by design and
> is completely undocumented as everything else in that area.

where is info for everything else?

>
> So the initial patch to get rid of the X mapping is of course to just
> extend the area to the PMD. A little bit different to your initial
> patch, but essentially the same.
>
> -       unsigned long all_end = PFN_ALIGN(&_end);
> +       unsigned long all_end = roundup((unsigned long) &_end, PMD_SIZE);
>
> I'm going to apply your V1 patch with the above roundup()
> simplification. If a page of that area gets used later on then we are
> going to split up the PMD anyway.

should use _brk_end instead of &_end for the roundup?

>
> But still we want to get rid of that highmap between _brk_end and
> _end, but there is absolutely no reason to come up with extra silly
> functions for that.
>
> So the obvious solution is to let setup_arch() reserve the memory up
> to _end instead of _bss_stop, get rid of the extra reservation in
> reserve_brk() and then let free_initmem() release the area between
> _brk_end and _end. No extra hackery, no side effects, just works.

So where get the highmap to be removed?
free_init_pages via free_initmem()?

with the code change like you suggested,

---
 arch/x86/kernel/setup.c |    6 +-----
 arch/x86/mm/init.c      |    6 ++++++
 arch/x86/mm/init_64.c   |    2 +-
 3 files changed, 8 insertions(+), 6 deletions(-)

Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -286,10 +286,6 @@ static void __init cleanup_highmap(void)

 static void __init reserve_brk(void)
 {
-    if (_brk_end > _brk_start)
-        memblock_reserve(__pa_symbol(_brk_start),
-                 _brk_end - _brk_start);
-
     /* Mark brk area as locked down and no longer taking any
        new allocations */
     _brk_start = 0;
@@ -857,7 +853,7 @@ dump_kernel_offset(struct notifier_block
 void __init setup_arch(char **cmdline_p)
 {
     memblock_reserve(__pa_symbol(_text),
-             (unsigned long)__bss_stop - (unsigned long)_text);
+             (unsigned long)_end - (unsigned long)_text);

     early_reserve_initrd();

Index: linux-2.6/arch/x86/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init_64.c
+++ linux-2.6/arch/x86/mm/init_64.c
@@ -1122,7 +1122,7 @@ void mark_rodata_ro(void)
     unsigned long end = (unsigned long) &__end_rodata_hpage_align;
     unsigned long text_end = PFN_ALIGN(&__stop___ex_table);
     unsigned long rodata_end = PFN_ALIGN(&__end_rodata);
-    unsigned long all_end = PFN_ALIGN(&_end);
+    unsigned long all_end = roundup((unsigned long)&_end, PMD_SIZE);

     printk(KERN_INFO "Write protecting the kernel read-only data: %luk\n",
            (end - start) >> 10);
Index: linux-2.6/arch/x86/mm/init.c
===================================================================
--- linux-2.6.orig/arch/x86/mm/init.c
+++ linux-2.6/arch/x86/mm/init.c
@@ -637,9 +637,15 @@ void free_init_pages(char *what, unsigne

 void free_initmem(void)
 {
+    unsigned long all_end = roundup((unsigned long)&_end, PMD_SIZE);
+
     free_init_pages("unused kernel",
             (unsigned long)(&__init_begin),
             (unsigned long)(&__init_end));
+
+#ifdef CONFIG_X86_64
+    free_init_pages("unused brk", PFN_ALIGN(_brk_end), all_end);
+#endif
 }

 #ifdef CONFIG_BLK_DEV_INITRD


got
[    7.942636] Freeing unused brk memory: 500K (ffffffff84383000 -
ffffffff84400000)

---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
0xffffffff82e00000-0xffffffff83000000           2M     RW             GLB NX pte
0xffffffff83000000-0xffffffff83200000           2M     RW         PSE GLB NX pmd
0xffffffff83200000-0xffffffff83400000           2M     RW             GLB NX pte
0xffffffff83400000-0xffffffff84200000          14M     RW         PSE GLB NX pmd
0xffffffff84200000-0xffffffff84400000           2M     RW             GLB NX pte
0xffffffff84400000-0xffffffffa0000000         444M                           pmd

the _brk_end to &_end highmap is still there

Also if you want to remove highmap between _brk_end and _end,
Do you want highmap for
                        [text_end, rodata_start)
                        [rodata_end, _sdata),
as mark_rodata_ro is calling

        free_init_pages("unused kernel",
                        (unsigned long) __va(__pa_symbol(text_end)),
                        (unsigned long) __va(__pa_symbol(rodata_start)));
        free_init_pages("unused kernel",
                        (unsigned long) __va(__pa_symbol(rodata_end)),
                        (unsigned long) __va(__pa_symbol(_sdata)));

Thanks

Yinghai
