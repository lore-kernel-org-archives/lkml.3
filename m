Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871AbaLAXSf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:18:35 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:56398 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932461AbaLAXSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:18:32 -0500
MIME-Version: 1.0
In-Reply-To: <20141201153336.GB3180@laptop.dumpdata.com>
References: <cover.1414516558.git.luto@amacapital.net> <6b0c9b0fc128de68634c730a5b1a80e1d085ad02.1414516558.git.luto@amacapital.net>
 <20141028174629.GA2150@jtriplet-mobl1> <CALCETrUihPeKODJqi3tMYwyWYhML1Z=gr4wrVK5VnaFo=KGVJA@mail.gmail.com>
 <20141029200016.GK3424@laptop.dumpdata.com> <CALCETrW+f8S9fNrui_J34q3Ve4jwA=neGe-tYZ_Lbp+ML3LiRw@mail.gmail.com>
 <20141201153336.GB3180@laptop.dumpdata.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Mon, 1 Dec 2014 15:18:11 -0800
Message-ID: <CALCETrUR6RKPZ7XpEp6NNu7n2W4TdAPQTCkB8Tpc2iF2SfdROw@mail.gmail.com>
Subject: Re: [PATCH 3/3] x86_64,vsyscall: Make vsyscall emulation configurable
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Josh Triplett <josh@joshtriplett.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 1, 2014 2:08 PM, "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com> wrote:
>
> On Wed, Oct 29, 2014 at 02:30:29PM -0700, Andy Lutomirski wrote:
> > On Oct 29, 2014 1:00 PM, "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com> wrote:
> > >
> > > On Tue, Oct 28, 2014 at 11:09:53AM -0700, Andy Lutomirski wrote:
> > > > On Tue, Oct 28, 2014 at 10:57 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> > > > > On Tue, Oct 28, 2014 at 10:22:28AM -0700, Andy Lutomirski wrote:
> > > > >> This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
> > > > >> Turning it off completely disables vsyscall emulation, saving ~3.5k
> > > > >> for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
> > > > >> page), some tiny amount of core mm code that supports a gate area,
> > > > >> and possibly 4k for a wasted pagetable.  The latter is because the
> > > > >> vsyscall addresses are misaligned and fit poorly in the fixmap.
> > > > >>
> > > > >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > > > >
> > > > > One minor nit below, but with or without that change,
> > > > > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> > > > >
> > > > >> --- a/arch/x86/xen/mmu.c
> > > > >> +++ b/arch/x86/xen/mmu.c
> > > > >> @@ -1456,11 +1456,13 @@ static int xen_pgd_alloc(struct mm_struct *mm)
> > > > >>               user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> > > > >>               page->private = (unsigned long)user_pgd;
> > > > >>
> > > > >> +#ifdef CONFIG_X86_VSYSCALL_EMULATION
> > > > >>               if (user_pgd != NULL) {
> > > > >>                       user_pgd[pgd_index(VSYSCALL_ADDR)] =
> > > > >>                               __pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
> > > > >>                       ret = 0;
> > > > >>               }
> > > > >> +#endif
> > > > >
> > > > > Could you instead make the if use IS_ENABLED?
> > > > >
> > > > >                 if (IS_ENABLED(CONFIG_X86_VSYSCALL_EMULATION) && user_pgd != NULL)
> > > > >
> > > > > That has the advantage of ensuring that the code continues to compile.
> > > > > (Given that you haven't removed level3_user_vsyscall, that should work.)
> > > >
> > > > I need the ret = 0, I think, so I'll resend.
> > > >
> > > > I think I'd rather use #ifdef here, since I think it would be great if
> > > > the Xen people could clean this up further.  With this change, under
> > > > some configurations, there should be no user-accessible kernel
> > > > addresses at all.  (Also, is there some PV mechanism
>
> What about the vsyscall time stamp (aka kvm-clock). That is not
> really VSYSCALL emulation based but normal code?

That's entirely separate now.

>
> > > > that I'm not thinking of that will break with this change?  I know
> > > > I've tripped over Xen pagetable and fixmap oddities before.)
> > >
> > > Not that I know of. The vsyscall is the only one that I know of that
> > > does this.
> >
> > There's kvm-clock, too, but that may never co-exist with Xen.
>
> It will eventually.

Hmm. Maybe I should clean up the read code first.

--Andy

> >
> > I tagged v2 here:
> >
> > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/tag/?id=optional-vsyscall-emulation-v2
> >
> > and I'll send it out in a bit.
> >
> > --Andy
> >
> > >
> > > Do you have a full patchset somewhere for testing?
> > > >
> > > > --Andy
