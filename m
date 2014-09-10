Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaIJHV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 03:21:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11670 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbaIJHV2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 03:21:28 -0400
Date: Wed, 10 Sep 2014 15:21:15 +0800
From: Baoquan He <bhe@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140910072115.GA31685@dhcp-16-116.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
 <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
 <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
 <20140909192813.GB9435@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140909192813.GB9435@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/14 at 03:28pm, Vivek Goyal wrote:
> On Tue, Sep 09, 2014 at 08:53:29AM -0700, Kees Cook wrote:
 
> > I still think this needs a test for the 32-bit case, since IUIC, it
> > requires relocations unconditionally.
> 
> [ CC hpa ]
> 
> Bao, for modifications in this area, I would recommend CC hpa too.
> 
> I also think that i386 will always require relocation handling. That's
> how Eric had designed it. There was no separate kernel text mapping
> region so PAGE_OFFSET was constant. Hence if you shift kernel in physical
> address space, you had to shift mappings in virtual address space by
> equal amount.
> 
> But in x86_64, we have kernel text mapped in a separate virtual region, and 
> that allowed us wiggling room and we could load kernel anywhere
> in physical address space and just change mappings of kernel text
> virtual address region accordingly.
> 
> So I agree that on i386, we will most likely require relocations all
> the time. Having said that, it is interesting that one can disable
> X86_NEED_RELOCS on i386 while RELOCATBALE=y.
> 
> # Relocation on x86 needs some additional build support
> config X86_NEED_RELOCS
>         def_bool y
>         depends on RANDOMIZE_BASE || (X86_32 && RELOCATABLE)
> 
> I am not sure how i386 RELOCATABLE kernel will work if X86_NEED_RELOCS=n.
> 
> 
> Secondly, IIUC, kernel has 32bit signed relocations. That means
> relocations can be processed successfully only if kernel is loaded
> in first 2G or -2G. If that's the case, then aslr mechanism should
> see that where kernel is loaded physically and if it is loaded outside
> the range where relocations can be processed successfully, it should
> disable itself and output a message.

Yes, kernel only handle 2G or -2G relocation since 32 bit signed
relocations. But for aslr, since the kernel text mapping shares 2G
virtual address space with modules, only 1G relocation can be done. I
took a test, when load kernel at 1G, if not checking if output_orig
and output are equal, it will trigger a BIOS reboot. And with the
restriction checking in process_e820_entry(), the kaslr relocations only
happens inside 1G.

If max_addr is outside 1G, namely CONFIG_RANDOMIZE_BASE_MAX_OFFSET, the
kaslr random kernel location choosing won't happen, then checking if
output_orig is equal to outout in handle_relocations(), if equal nothing
happened. This truly don't need to specify "nokaslr". 

In fact, I think below checking will be clearer and works too.


static void handle_relocations(void *output, unsigned long output_len)
{

...

#if CONFIG_X86_64

or

#if CONFIG_RANDOMIZE_BASE
#ifdef CONFIG_HIBERNATION
	if (!cmdline_find_option_bool("kaslr")) {
               debug_putstr("No relocation needed... ");
               return;
	}
#else
	if (cmdline_find_option_bool("nokaslr")) {
               debug_putstr("No relocation needed... ");
               return;
	}
#endif

	if (max_addr > CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
                debug_putstr("Random addr is not allowed. No relocation
needed... \n");
                return;
        }

#endif

...
}

> 
> That way, one will not have to pass explicit "nokaslr" parameter to kernel.
> If kernel can't handle relocations successfully, it will automatically
> disable kaslr.
> 
> Thanks
> Vivek
> 
> > 
> > -Kees
> > 
> > >         delta = min_addr - LOAD_PHYSICAL_ADDR;
> > >         if (!delta) {
> > >                 debug_putstr("No relocation needed... ");
> > > @@ -299,7 +303,8 @@ static void handle_relocations(void *output, unsigned long output_len)
> > >  #endif
> > >  }
> > >  #else
> > > -static inline void handle_relocations(void *output, unsigned long output_len)
> > > +static inline void handle_relocations(void *output_orig, void *output,
> > > +                                     unsigned long output_len)
> > >  { }
> > >  #endif
> > >
> > > @@ -360,6 +365,8 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
> > >                                   unsigned char *output,
> > >                                   unsigned long output_len)
> > >  {
> > > +       unsigned char *output_orig = output;
> > > +
> > >         real_mode = rmode;
> > >
> > >         sanitize_boot_params(real_mode);
> > > @@ -402,7 +409,7 @@ asmlinkage __visible void *decompress_kernel(void *rmode, memptr heap,
> > >         debug_putstr("\nDecompressing Linux... ");
> > >         decompress(input_data, input_len, NULL, NULL, output, NULL, error);
> > >         parse_elf(output);
> > > -       handle_relocations(output, output_len);
> > > +       handle_relocations(output_orig, output, output_len);
> > >         debug_putstr("done.\nBooting the kernel.\n");
> > >         return output;
> > >  }
> > > --
> > > 1.8.5.3
> > >
> > 
> > 
> > 
> > -- 
> > Kees Cook
> > Chrome OS Security
