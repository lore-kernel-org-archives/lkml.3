Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab3KGUew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 15:34:52 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:54705 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751701Ab3KGUep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 15:34:45 -0500
Date: Thu, 7 Nov 2013 20:33:34 +0000
From: Dave Martin <Dave.Martin@arm.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, James Hogan <james.hogan@imgtec.com>,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>,
        libseccomp-discuss@lists.sourceforge.net,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] seccomp: not compatible with ARM OABI
Message-ID: <20131107203334.GC3129@localhost.localdomain>
References: <20131107174746.GA22344@www.outflux.net>
 <CALCETrXpzmw7qvDPxkW+y=_h5W+a+uyJp1xkz55oBXu9sC+t3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXpzmw7qvDPxkW+y=_h5W+a+uyJp1xkz55oBXu9sC+t3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 07, 2013 at 10:16:13AM -0800, Andy Lutomirski wrote:
> On Thu, Nov 7, 2013 at 9:47 AM, Kees Cook <keescook@chromium.org> wrote:
> > Make sure that seccomp filter won't be built when ARM OABI is in use,
> > since there is work needed to distinguish calling conventions. Until
> > that is done (which is likely never since OABI is deprecated), make
> > sure seccomp filter is unavailable in the OABI world.
> >
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > ---
> > v2:
> >  - toggle availability via HAVE_ARCH_SECCOMP_FILTER; James Hogan.
> > ---
> >  arch/arm/Kconfig |    7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 0a1dc697333c..a0a8590f3609 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -23,7 +23,7 @@ config ARM
> >         select HARDIRQS_SW_RESEND
> >         select HAVE_ARCH_JUMP_LABEL if !XIP_KERNEL
> >         select HAVE_ARCH_KGDB
> > -       select HAVE_ARCH_SECCOMP_FILTER
> > +       select HAVE_ARCH_SECCOMP_FILTER if (AEABI && !OABI_COMPAT)
> >         select HAVE_ARCH_TRACEHOOK
> >         select HAVE_BPF_JIT
> >         select HAVE_CONTEXT_TRACKING
> > @@ -1735,6 +1735,11 @@ config OABI_COMPAT
> >           in memory differs between the legacy ABI and the new ARM EABI
> >           (only for non "thumb" binaries). This option adds a tiny
> >           overhead to all syscalls and produces a slightly larger kernel.
> > +
> > +         The seccomp filter system will not be available when this is
> > +         selected, since there is no way yet to sensibly distinguish
> > +         between calling conventions during filtering.
> > +
> >           If you know you'll be using only pure EABI user space then you
> >           can say N here. If this option is not selected and you attempt
> >           to execute a legacy ABI binary then the result will be
> > --
> > 1.7.9.5
> >
> >
> 
> FWIW, OABI-only (i.e. !AEABI, as opposed to OABI_COMPAT) is, in
> principle, supportable -- userspace would just have to know that, if
> build for OABI, the calling convention is different.
> 
> I doubt this is worth supporting, though, and, if no one complains
> about your patch for a couple releases, then that would mean we could
> get away with adding AUDIT_ARCH_ARM_OABI or something (maybe for
> seccomp only) if needed.

Won't SECCOMP (from arch/arm/Kconfig) still be visible and selectable
in the Kconfig system?  That may cause confusion.


One option might be to make SECCOMP depend on AEABI, and treat all OABI
syscalls as invalid after TIF_SECCOMP is set.  This would allow people
to build modern kernels that can still run ancient userspace, without
having to compile SECCOMP out.  I don't think we care about whether
SECCOMP works for OABI userspace -- it's too recent a feature on ARM.

That may be overkill nowadays, though.  The alternative would be to
make SECCOMP depend on AEABI && !OABI_COMPAT.

Cheer
---Dave
