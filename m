Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaIJNUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 09:20:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215AbaIJNU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 09:20:28 -0400
Date: Wed, 10 Sep 2014 09:20:21 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Baoquan He <bhe@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Deutschmann <whissi@whissi.de>, Dave Young <dyoung@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, WANG Chao <chaowang@redhat.com>
Subject: Re: [PATCH 1/4] kaslr: check user's config too when handle
 relocations
Message-ID: <20140910132020.GA2166@redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-2-git-send-email-bhe@redhat.com>
 <CAGXu5j+ih52B+ert+OF2wtm07wZDS_u6S0H7bwfycpJuBXT2_w@mail.gmail.com>
 <20140909062416.GA2872@dhcp-16-105.nay.redhat.com>
 <CAGXu5jJ+oUGszKUX12cqJ9RQBXCzO9j9e-5gBDmTH-cF80=xNg@mail.gmail.com>
 <20140910061035.GC25867@dhcp-16-116.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140910061035.GC25867@dhcp-16-116.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 02:10:35PM +0800, Baoquan He wrote:

[..]
> > > diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> > > index 57ab74d..887f404 100644
> > > --- a/arch/x86/boot/compressed/misc.c
> > > +++ b/arch/x86/boot/compressed/misc.c
> > > @@ -230,8 +230,9 @@ static void error(char *x)
> > >                 asm("hlt");
> > >  }
> > >
> > > -#if CONFIG_X86_NEED_RELOCS
> > > -static void handle_relocations(void *output, unsigned long output_len)
> > > +#ifdef CONFIG_X86_NEED_RELOCS
> > > +static void handle_relocations(void *output_orig, void *output,
> > > +                              unsigned long output_len)
> > >  {
> > >         int *reloc;
> > >         unsigned long delta, map, ptr;
> > > @@ -242,6 +243,9 @@ static void handle_relocations(void *output, unsigned long output_len)
> > >          * Calculate the delta between where vmlinux was linked to load
> > >          * and where it was actually loaded.
> > >          */
> > > +       if (output_orig == output)
> > > +               return;
> > > +
> > 
> > I still think this needs a test for the 32-bit case, since IUIC, it
> > requires relocations unconditionally.
> 
> Oops, just understood that 32 bit kernel alwasy need relocations, but
> only focus on x86_64 and kaslr again when I was doing it. You are right,
> this is not correct for 32 bit kernel.
> 
> I am thinking if I can add a compiling condition check like below. This
> only works only when x86_64 or when kaslr is compiled in. Otherwise it
> wokrs as before.
> 
> #if CONFIG_X86_64
> 	if (output_orig == output)
> 		return;
> #endif

Hi Bao,

I think above should work reasonably well. Also put a comment above it.
Something like as follows.

/*
 * 32bit always requires relocations to be performed. For x86_64,
 * relocations need to be performed only if kaslr has chosen a
 * different load address then kernel was originally loaded at.
 *
 * If we are here, either kaslr is not configured in or kaslr is disabled
 * or kaslr has chosen not to change the load location of kernel. Don't
 * perform any relocations.
 */

Thanks
Vivek
