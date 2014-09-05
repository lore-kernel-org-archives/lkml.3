Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaIEWhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:37:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53071 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbaIEWhc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:37:32 -0400
Date: Sat, 6 Sep 2014 06:37:22 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Deutschmann <whissi@whissi.de>,
        Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, WANG Chao <chaowang@redhat.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140905223722.GC1675@dhcp-17-102.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 at 10:11am, Kees Cook wrote:
> On Fri, Sep 5, 2014 at 7:08 AM, Baoquan He <bhe@redhat.com> wrote:
> > kaslr's action is splitted into 2 parts. The 1st is getting available memory
> > slots and randomly choose the kernel relocation address. After decompression
> > of kernel to the chosen place, the 2nd part begin to check if kaslr has got
> > a relocation address, and will do the relocations handling if yes.
> >
> > However in current implementation, in the 2nd part, it doesn't check user's
> > config, just compare decompression output address and the LOAD_PHYSICAL_ADDR
> > where kernel was compiled to run. If they are equal, it means a kaslr is
> > taking action, and need do the relocation handling. This truly works when
> > bootloader always load kernel to LOAD_PHYSICAL_ADDR. But this doesn't always
> > happens. Kexec/kdump kernel loading is exceptional. Kdump/kexec can load
> > kernel anywhere, this is not fixed. So in this case, it will do the relocation
> > handling though user clearly set nokaslr in cmdline. This is not correct.
> >
> > So in this patch, check user's config too in the 2nd part, namely in
> > handle_relocations().
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  arch/x86/boot/compressed/aslr.c |  2 ++
> >  arch/x86/boot/compressed/misc.c | 12 ++++++++++++
> >  2 files changed, 14 insertions(+)
> >
> > diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
> > index fc6091a..975b07b 100644
> > --- a/arch/x86/boot/compressed/aslr.c
> > +++ b/arch/x86/boot/compressed/aslr.c
> > @@ -292,11 +292,13 @@ unsigned char *choose_kernel_location(unsigned char *input,
> >  #ifdef CONFIG_HIBERNATION
> >         if (!cmdline_find_option_bool("kaslr")) {
> >                 debug_putstr("KASLR disabled by default...\n");
> > +               debug_putstr("No need to choose kernel relocation...\n");
> >                 goto out;
> >         }
> >  #else
> >         if (cmdline_find_option_bool("nokaslr")) {
> >                 debug_putstr("KASLR disabled by cmdline...\n");
> > +               debug_putstr("No need to choose kernel relocation...\n");
> >                 goto out;
> >         }
> >  #endif
> 
> NAK on this part -- the whole point is to report the results of the
> expected KASLR state based on build config, cmdline, etc.
> 
> > diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> > index 57ab74d..7780a5b 100644
> > --- a/arch/x86/boot/compressed/misc.c
> > +++ b/arch/x86/boot/compressed/misc.c
> > @@ -238,6 +238,18 @@ static void handle_relocations(void *output, unsigned long output_len)
> >         unsigned long min_addr = (unsigned long)output;
> >         unsigned long max_addr = min_addr + output_len;
> >
> > +#ifdef CONFIG_HIBERNATION
> > +       if (!cmdline_find_option_bool("kaslr")) {
> > +               debug_putstr("No relocation needed... ");
> > +               return;
> > +       }
> > +#else
> > +       if (cmdline_find_option_bool("nokaslr")) {
> > +               debug_putstr("No relocation needed... ");
> > +               return;
> > +       }
> > +#endif
> > +
> 
> I don't think this is correct. If you look at a02150610776 ("x86,
> relocs: Move ELF relocation handling to C"), we always did relocations
> on 32-bit when CONFIG_RELOCATABLE was set, so I think this will fail
> badly on 32-bit. 64-bit only needs relocation when
> CONFIG_RANDOMIZE_BASE is set, so this is probably what needs to be
> tested here instead. I think a better option would be, in
> decompress_kernel(), to compare output before and after
> choose_kernel_location(). If it's the same on 64-bit,
> handle_relocations() can be skipped. (Perhaps pass the before/after to
> handle_relocations() and it can perform the logic.)


This doesn't work for kdump and kexec since they can be put anywhere.
Assume kdump kernel is put in 512M, and I compiled in the kaslr and set
nokaslr in cmdline. It will skip the choose_kernel_location(), then
decompress kernel to 512M. Then it will do relocations handling in
handle_relocations().

This is not correct. If kaslr is not compiled in, the kernel text
mapping will start from 0xffffffff81000000. But now if kaslr is compiled
in, and nokaslr is added into cmdline, the text mapping will start from
0xffffffffa0000000. This result is confusing.

> 
> -Kees
> 
> >         /*
> >          * Calculate the delta between where vmlinux was linked to load
> >          * and where it was actually loaded.
> > --
> > 1.8.5.3
> >
> 
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
