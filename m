Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655AbaIEWRT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 18:17:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54972 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaIEWRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 18:17:18 -0400
Date: Sat, 6 Sep 2014 06:16:57 +0800
From: Baoquan He <bhe@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Deutschmann <whissi@whissi.de>,
        Dave Young <dyoung@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Vivek Goyal <vgoyal@redhat.com>, WANG Chao <chaowang@redhat.com>
Subject: Re: [PATCH 2/4] kaslr: check if the random addr is available
Message-ID: <20140905221657.GA1675@dhcp-17-102.nay.redhat.com>
References: <1409926097-2101-1-git-send-email-bhe@redhat.com>
 <1409926097-2101-3-git-send-email-bhe@redhat.com>
 <CAGXu5jJXvR9c3OvkX-gBMjhJEwXh5-wBdT+jjMwBFXDs8_-40Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJXvR9c3OvkX-gBMjhJEwXh5-wBdT+jjMwBFXDs8_-40Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/14 at 10:16am, Kees Cook wrote:
> On Fri, Sep 5, 2014 at 7:08 AM, Baoquan He <bhe@redhat.com> wrote:
> > diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
> > index 7780a5b..d2a0eaa 100644
> > --- a/arch/x86/boot/compressed/misc.c
> > +++ b/arch/x86/boot/compressed/misc.c
> > @@ -250,6 +250,11 @@ static void handle_relocations(void *output, unsigned long output_len)
> >         }
> >  #endif
> >
> > +       if (max_addr > CONFIG_RANDOMIZE_BASE_MAX_OFFSET) {
> > +                debug_putstr("Random addr is not allowed. No relocation needed... \n");
> > +                return;
> > +        }
> > +
> 
> It's not clear to me what this is fixing. In aslr.c,
> process_e820_entry() should already make it impossible to select
> max_addr > CONFIG_RANDOMIZE_BASE_MAX_OFFSET. If you're trying to
> detect a non-kaslr boot, I think this is better handled in 1/4 where I
> suggest examining the "output" location before/after
> choose_kernel_location.
> 
> -Kees

Hi Kees,

Yes, process_e820_entry() can make sure the choice+output_len <
CONFIG_RANDOMIZE_BASE_MAX_OFFSET, but that can't stop other bootloaders
to put kernel in region above CONFIG_RANDOMIZE_BASE_MAX_OFFSET.

E.g in kdump, we can set crashkernel=256M@1024M in cmdline. Then the 1st
kernel will reserve 256M memory just at 1024M place. So if load kdump
kernel now, the output will be 1024M before choose_kernel_location().
With this value, output won't be changed in choose_kernel_location(),
then it will do decompress(), then call handle_relocations(). Then since
1024 is not equal to LOAD_PHYSICAL_ADDR, it will start relocatoins
handling. And this cause _text stamping into MODULES vaddr range. System
will be exceptional.

Thanks
Baoquan
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
