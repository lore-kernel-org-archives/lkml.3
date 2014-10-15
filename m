Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751637AbaJOOno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 10:43:44 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:38256 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316AbaJOOnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 10:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAJd=RBDbziyL1FR+eHLe-8zXSFa0mfMPi2Xcg2-aP=GvyALHjg@mail.gmail.com>
References: <CAJd=RBDbziyL1FR+eHLe-8zXSFa0mfMPi2Xcg2-aP=GvyALHjg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 15 Oct 2014 07:43:20 -0700
Message-ID: <CALCETrX1KPwA9TMVqg8ZnLDMSFtTX3YeW9pYqX5JsrfM5tERXg@mail.gmail.com>
Subject: Re: [RFC 2/5] x86: Store a per-cpu shadow copy of CR4
To: Hillf Danton <dhillf@gmail.com>
Cc: "hillf.zj" <hillf.zj@alibaba-inc.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, Kees Cook <keescook@chromium.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Oct 15, 2014 12:37 AM, "Hillf Danton" <dhillf@gmail.com> wrote:
>
> Hey Andy
> >
> > Context switches and TLB flushes can change individual bits of CR4.
> > CR4 reads take several cycles, so store a shadow copy of CR4 in a
> > per-cpu variable.
> >
> > To avoid wasting a cache line, I added the CR4 shadow to
> > cpu_tlbstate, which is already touched during context switches.
> >
> > Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> > ---
> >  arch/x86/include/asm/tlbflush.h | 52
> > ++++++++++++++++++++++++++++++-----------
> >  arch/x86/kernel/cpu/common.c    |  7 ++++++
> >  arch/x86/kernel/head32.c        |  1 +
> >  arch/x86/kernel/head64.c        |  2 ++
> >  arch/x86/kvm/vmx.c              |  4 ++--
> >  arch/x86/mm/init.c              |  8 +++++++
> >  arch/x86/mm/tlb.c               |  3 ---
> >  7 files changed, 59 insertions(+), 18 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/tlbflush.h
> > b/arch/x86/include/asm/tlbflush.h
> > index 95b672f8b493..a04cad4bcbc3 100644
> > --- a/arch/x86/include/asm/tlbflush.h
> > +++ b/arch/x86/include/asm/tlbflush.h
> > @@ -15,14 +15,37 @@
> >  #define __flush_tlb_single(addr) __native_flush_tlb_single(addr)
> >  #endif
> >
> > +struct tlb_state {
> > +#ifdef CONFIG_SMP
> > +     struct mm_struct *active_mm;
> > +     int state;
> > +#endif
> > +
> > +     /*
> > +      * Access to this CR4 shadow and to H/W CR4 is protected by
> > +      * disabling interrupts when modifying either one.
> > +      */
> > +     unsigned long cr4;
> > +};
> > +DECLARE_PER_CPU_SHARED_ALIGNED(struct tlb_state, cpu_tlbstate);
> > +
> > +/* Initialize cr4 shadow for this CPU. */
> > +static inline void cr4_init_shadow(void)
> > +{
> > +     this_cpu_write(cpu_tlbstate.cr4, read_cr4());
> > +}
> > +
> >  /* Set in this cpu's CR4. */
> >  static inline void cr4_set(unsigned long mask)
> >  {
> >       unsigned long cr4;
> >
> > -     cr4 = read_cr4();
> > -     cr4 |= mask;
> > -     write_cr4(cr4);
> > +     cr4 = this_cpu_read(cpu_tlbstate.cr4);
> > +     if (!(cr4 & mask)) {
>
> What if cr4 contains bit_A and mask contains bits A and B?

A malfunction.  Whoops :)  Will fix.

--Andy

>
> Hillf
> > +             cr4 |= mask;
> > +             this_cpu_write(cpu_tlbstate.cr4, cr4);
> > +             write_cr4(cr4);
> > +     }
> >  }
> >
> [...]
