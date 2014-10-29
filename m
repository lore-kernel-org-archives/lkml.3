Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756859AbaJ2UAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 16:00:31 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22881 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbaJ2UA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 16:00:29 -0400
Date: Wed, 29 Oct 2014 16:00:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Josh Triplett <josh@joshtriplett.org>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 3/3] x86_64,vsyscall: Make vsyscall emulation configurable
Message-ID: <20141029200016.GK3424@laptop.dumpdata.com>
References: <cover.1414516558.git.luto@amacapital.net>
 <6b0c9b0fc128de68634c730a5b1a80e1d085ad02.1414516558.git.luto@amacapital.net>
 <20141028174629.GA2150@jtriplet-mobl1>
 <CALCETrUihPeKODJqi3tMYwyWYhML1Z=gr4wrVK5VnaFo=KGVJA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUihPeKODJqi3tMYwyWYhML1Z=gr4wrVK5VnaFo=KGVJA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 11:09:53AM -0700, Andy Lutomirski wrote:
> On Tue, Oct 28, 2014 at 10:57 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> > On Tue, Oct 28, 2014 at 10:22:28AM -0700, Andy Lutomirski wrote:
> >> This adds CONFIG_X86_VSYSCALL_EMULATION, guarded by CONFIG_EXPERT.
> >> Turning it off completely disables vsyscall emulation, saving ~3.5k
> >> for vsyscall_64.c, 4k for vsyscall_emu_64.S (the fake vsyscall
> >> page), some tiny amount of core mm code that supports a gate area,
> >> and possibly 4k for a wasted pagetable.  The latter is because the
> >> vsyscall addresses are misaligned and fit poorly in the fixmap.
> >>
> >> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> >
> > One minor nit below, but with or without that change,
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> >
> >> --- a/arch/x86/xen/mmu.c
> >> +++ b/arch/x86/xen/mmu.c
> >> @@ -1456,11 +1456,13 @@ static int xen_pgd_alloc(struct mm_struct *mm)
> >>               user_pgd = (pgd_t *)__get_free_page(GFP_KERNEL | __GFP_ZERO);
> >>               page->private = (unsigned long)user_pgd;
> >>
> >> +#ifdef CONFIG_X86_VSYSCALL_EMULATION
> >>               if (user_pgd != NULL) {
> >>                       user_pgd[pgd_index(VSYSCALL_ADDR)] =
> >>                               __pgd(__pa(level3_user_vsyscall) | _PAGE_TABLE);
> >>                       ret = 0;
> >>               }
> >> +#endif
> >
> > Could you instead make the if use IS_ENABLED?
> >
> >                 if (IS_ENABLED(CONFIG_X86_VSYSCALL_EMULATION) && user_pgd != NULL)
> >
> > That has the advantage of ensuring that the code continues to compile.
> > (Given that you haven't removed level3_user_vsyscall, that should work.)
> 
> I need the ret = 0, I think, so I'll resend.
> 
> I think I'd rather use #ifdef here, since I think it would be great if
> the Xen people could clean this up further.  With this change, under
> some configurations, there should be no user-accessible kernel
> addresses at all.  (Also, is there some PV mechanism
> that I'm not thinking of that will break with this change?  I know
> I've tripped over Xen pagetable and fixmap oddities before.)

Not that I know of. The vsyscall is the only one that I know of that
does this. 

Do you have a full patchset somewhere for testing?
> 
> --Andy
