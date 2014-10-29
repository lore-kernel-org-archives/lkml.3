Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272AbaJ2Vaw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 17:30:52 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:46952 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751917AbaJ2Vav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 17:30:51 -0400
MIME-Version: 1.0
In-Reply-To: <20141029200016.GK3424@laptop.dumpdata.com>
References: <cover.1414516558.git.luto@amacapital.net> <6b0c9b0fc128de68634c730a5b1a80e1d085ad02.1414516558.git.luto@amacapital.net>
 <20141028174629.GA2150@jtriplet-mobl1> <CALCETrUihPeKODJqi3tMYwyWYhML1Z=gr4wrVK5VnaFo=KGVJA@mail.gmail.com>
 <20141029200016.GK3424@laptop.dumpdata.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 29 Oct 2014 14:30:29 -0700
Message-ID: <CALCETrW+f8S9fNrui_J34q3Ve4jwA=neGe-tYZ_Lbp+ML3LiRw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86_64,vsyscall: Make vsyscall emulation configurable
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 29, 2014 1:00 PM, "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com> wrote:
>
> On Tue, Oct 28, 2014 at 11:09:53AM -0700, Andy Lutomirski wrote:
> > On Tue, Oct 28, 2014 at 10:57 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> > > On Tue, Oct 28, 2014 at 10:22:28AM -0700, Andy Lutomirski wrote:
> > >> This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
> > >> Turning it off completely disables vsyscall emulation, saving ~3.5k
> > >> for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
> > >> page), some tiny amount of core mm code that supports a gate area,
> > >> and possibly 4k for a wasted pagetable.  The latter is because the
> > >> vsyscall addresses are misaligned and fit poorly in the fixmap.
> > >>
> > >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > >
> > > One minor nit below, but with or without that change,
> > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > >
> > >> --- a/arch/x86/xen/mmu.c
> > >> +++ b/arch/x86/xen/mmu.c
> > >> @@ -1456,11 +1456,13 @@ static int xen_pgd_alloc(struct mm_struct *mm)
> > >>               user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> > >>               page->private = (unsigned long)user_pgd;
> > >>
> > >> +#ifdef CONFIG_X86_VSYSCALL_EMULATION
> > >>               if (user_pgd != NULL) {
> > >>                       user_pgd[pgd_index(VSYSCALL_ADDR)] =
> > >>                               __pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
> > >>                       ret = 0;
> > >>               }
> > >> +#endif
> > >
> > > Could you instead make the if use IS_ENABLED?
> > >
> > >                 if (IS_ENABLED(CONFIG_X86_VSYSCALL_EMULATION) && user_pgd != NULL)
> > >
> > > That has the advantage of ensuring that the code continues to compile.
> > > (Given that you haven't removed level3_user_vsyscall, that should work.)
> >
> > I need the ret = 0, I think, so I'll resend.
> >
> > I think I'd rather use #ifdef here, since I think it would be great if
> > the Xen people could clean this up further.  With this change, under
> > some configurations, there should be no user-accessible kernel
> > addresses at all.  (Also, is there some PV mechanism
> > that I'm not thinking of that will break with this change?  I know
> > I've tripped over Xen pagetable and fixmap oddities before.)
>
> Not that I know of. The vsyscall is the only one that I know of that
> does this.

There's kvm-clock, too, but that may never co-exist with Xen.

I tagged v2 here:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/tag/?id=optional-vsyscall-emulation-v2

and I'll send it out in a bit.

--Andy

>
> Do you have a full patchset somewhere for testing?
> >
> > --Andy
