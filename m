Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664AbaIIT21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 15:28:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26302 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751767AbaIIT2Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 15:28:25 -0400
Date: Tue, 9 Sep 2014 15:28:14 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140909192813.GB9435@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
 <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
 <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 08:53:29AM -0700, Kees Cook wrote:
> On Mon, Sep 8, 2014 at 11:24 PM, Baoquan He <bhe@redhat.com> wrote:
> > On 09/05/14 at 10:11am, Kees Cook wrote:
> >> I don't think this is correct. If you look at a02150610776 ("x86,
> >> relocs: Move ELF relocation handling to C"), we always did relocations
> >> on 32-bit when CONFIG_RELOCATABLE was set, so I think this will fail
> >> badly on 32-bit. 64-bit only needs relocation when
> >> CONFIG_RANDOMIZE_BASE is set, so this is probably what needs to be
> >> tested here instead. I think a better option would be, in
> >> decompress_kernel(), to compare output before and after
> >> choose_kernel_location(). If it's the same on 64-bit,
> >> handle_relocations() can be skipped. (Perhaps pass the before/after to
> >> handle_relocations() and it can perform the logic.)
> >>
> >> -Kees
> >
> > Hi Kees,
> >
> > Checking handle_relocations() again, I just didn't notice it's mandatory
> > to do the relocations handling in i386. So in this function delta is
> > checked to see if it's a kaslr relocation handling. This might be a
> > little confusing. But I am fine with it.
> >
> > Per your comment, you prefer to compare the output before and after
> > choose_kernel_location(). That's also good, Lu Yinghai posted a draft
> > patch in this way before, however the checking and the delta calculation
> > are not correct. I changed that and test all cases, it works well. So
> > do you like this it? If yes  I will repost it.
> >
> > From 13471bd838c52a0e143c2aee81e3863cfff585bd Mon Sep 17 00:00:00 2001
> > From: Baoquan He <bhe@redhat.com>
> > Date: Mon, 25 Aug 2014 14:57:43 +0800
> > Subject: [PATCH] kaslr: check if kernel location is changed
> >
> > Signed-off-by: Baoquan He <bhe@redhat.com>
> > ---
> >  arch/x86/boot/compressed/misc.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> >
> > diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> > index 57ab74d..887f404 100644
> > --- a/arch/x86/boot/compressed/misc.c
> > +++ b/arch/x86/boot/compressed/misc.c
> > @@ -230,8 +230,9 @@ static void error(char *x)
> >                 asm("hlt");
> >  }
> >
> > -#if CONFIG_X86_NEED_RELOCS
> > -static void handle_relocations(void *output, unsigned long output_len)
> > +#ifdef CONFIG_X86_NEED_RELOCS
> > +static void handle_relocations(void *output_orig, void *output,
> > +                              unsigned long output_len)
> >  {
> >         int *reloc;
> >         unsigned long delta, map, ptr;
> > @@ -242,6 +243,9 @@ static void handle_relocations(void *output, unsigned long output_len)
> >          * Calculate the delta between where vmlinux was linked to load
> >          * and where it was actually loaded.
> >          */
> > +       if (output_orig == output)
> > +               return;
> > +
> 
> I still think this needs a test for the 32-bit case, since IUIC, it
> requires relocations unconditionally.

[ CC hpa ]

Bao, for modifications in this area, I would recommend CC hpa too.

I also think that i386 will always require relocation handling. That's
how Eric had designed it. There was no separate kernel text mapping
region so PAGE_OFFSET was constant. Hence if you shift kernel in physical
address space, you had to shift mappings in virtual address space by
equal amount.

But in x86_64, we have kernel text mapped in a separate virtual region, and 
that allowed us wiggling room and we could load kernel anywhere
in physical address space and just change mappings of kernel text
virtual address region accordingly.

So I agree that on i386, we will most likely require relocations all
the time. Having said that, it is interesting that one can disable
X86_NEED_RELOCS on i386 while RELOCATBALE=y.

# Relocation on x86 needs some additional build support
config X86_NEED_RELOCS
        def_bool y
        depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)

I am not sure how i386 RELOCATABLE kernel will work if X86_NEED_RELOCS=n.


Secondly, IIUC, kernel has 32bit signed relocations. That means
relocations can be processed successfully only if kernel is loaded
in first 2G or -2G. If that's the case, then aslr mechanism should
see that where kernel is loaded physically and if it is loaded outside
the range where relocations can be processed successfully, it should
disable itself and output a message.

That way, one will not have to pass explicit "nokaslr" parameter to kernel.
If kernel can't handle relocations successfully, it will automatically
disable kaslr.

Thanks
Vivek

> 
> -Kees
> 
> >         delta = min_addr - LOAD_PHYSICAL_ADDR;
> >         if (!delta) {
> >                 debug_putstr("No relocation needed... ");
> > @@ -299,7 +303,8 @@ static void handle_relocations(void *output, unsigned long output_len)
> >  #endif
> >  }
> >  #else
> > -static inline void handle_relocations(void *output, unsigned long output_len)
> > +static inline void handle_relocations(void *output_orig, void *output,
> > +                                     unsigned long output_len)
> >  { }
> >  #endif
> >
> > @@ -360,6 +365,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
> >                                   unsigned char *output,
> >                                   unsigned long output_len)
> >  {
> > +       unsigned char *output_orig = output;
> > +
> >         real_mode = rmode;
> >
> >         sanitize_boot_params(real_mode);
> > @@ -402,7 +409,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
> >         debug_putstr("\nDecompressing Linux... ");
> >         decompress(input_data, input_len, NULL, NULL, output, NULL, error);
> >         parse_elf(output);
> > -       handle_relocations(output, output_len);
> > +       handle_relocations(output_orig, output, output_len);
> >         debug_putstr("done.\nBooting the kernel.\n");
> >         return output;
> >  }
> > --
> > 1.8.5.3
> >
> 
> 
> 
> -- 
> Kees Cook
> Chrome OS Security
