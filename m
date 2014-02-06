Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756349AbaBFMJ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 07:09:27 -0500
Received: from www84.your-server.de ([213.133.104.84]:48562 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbaBFMJZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 07:09:25 -0500
Message-ID: <1391688600.29423.15.camel@wall-e.seibold.net>
Subject: Re: [PATCH v12 9/9] Add 32 bit VDSO time support for 64 bit kernel
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        John Stultz <john.stultz@linaro.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        andriy.shevchenko@linux.intel.com, Martin.Runge@rohde-schwarz.com,
        Andreas.Brief@rohde-schwarz.com
Date: Thu, 06 Feb 2014 13:10:00 +0100
In-Reply-To: <CALCETrUx7iSquojTuYzoVZ_Pbi8NW7Wvs-CXSh3GEjMd-diRKQ@mail.gmail.com>
References: <1391588404-28147-1-git-send-email-stefani@seibold.net>
	 <1391588404-28147-10-git-send-email-stefani@seibold.net>
	 <CALCETrUx7iSquojTuYzoVZ_Pbi8NW7Wvs-CXSh3GEjMd-diRKQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, den 05.02.2014, 14:01 -0800 schrieb Andy Lutomirski:
> On Wed, Feb 5, 2014 at 12:20 AM,  <stefani@seibold.net> wrote:
> > From: Stefani Seibold <stefani@seibold.net>
> >
> > This patch add the VDSO time support for the IA32 Emulation Layer.
> >
> > Due the nature of the kernel headers and the LP64 compiler where the
> > size of a long and a pointer differs against a 32 bit compiler, there
> > is some type hacking necessary.
> >
> > The vsyscall_gtod_data struture must be a little bit rearranged, to
> > serve 32- and 64-bit code access:
> >
> > - The seqcount_t was replaced by an unsigned, this makes the
> >   vsyscall_gtod_data intedepend of kernel configuration and internal functions.
> > - The structure is now packed, so it can accessed from 32- und 64- bit
> >   code at the same time.
> > - The inner struct clock was removed, to make packing of the while
> >   struct easier.
> >
> > The "unsigned seq" would be handled by functions derivated from seqcount_t.
> >
> > Signed-off-by: Stefani Seibold <stefani@seibold.net>
> > ---
> >  arch/x86/include/asm/vgtod.h          |  20 +++---
> >  arch/x86/kernel/vsyscall_gtod.c       |  26 +++++--
> >  arch/x86/vdso/vclock_gettime.c        | 129 ++++++++++++++++++++++++----------
> >  arch/x86/vdso/vdso32/vclock_gettime.c |  11 +++
> >  include/uapi/linux/time.h             |   2 +-
> >  5 files changed, 132 insertions(+), 56 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/vgtod.h b/arch/x86/include/asm/vgtod.h
> > index 46e24d3..2567b02 100644
> > --- a/arch/x86/include/asm/vgtod.h
> > +++ b/arch/x86/include/asm/vgtod.h
> > @@ -4,16 +4,18 @@
> >  #include <asm/vsyscall.h>
> >  #include <linux/clocksource.h>
> >
> > -struct vsyscall_gtod_data {
> > -       seqcount_t      seq;
> > +/*
> > + * vsyscall_gtod_data will be accessed by 32 and 64 bit code at the same time
> > + * so the structure must be packed
> > + */
> > +struct __attribute__((packed)) vsyscall_gtod_data {
> > +       unsigned seq;
> 
> Is that actually true?  At least in the part you're changing,
> everything looks like it's aligned correctly.
> 

Yes, i know. But for convenient this is less error prone when modifying
the structure. I can kick it out if you insist.
 
> It's almost certainly having some kind of BUILD_BUG_ON that will catch
> the case where this structure's size changes.  I suspect that some
> kind of asm-offsets magic can be used for this.
> 

This kind af ASM magic wan't work, because the code will be compiled
with -m32 for a 32 bit VDSO but will access a structure generated with a
64 bit compiler.

> >
> > -       struct { /* extract of a clocksource struct */
> > -               int vclock_mode;
> > -               cycle_t cycle_last;
> > -               cycle_t mask;
> > -               u32     mult;
> > -               u32     shift;
> > -       } clock;
> > +       int vclock_mode;
> > +       cycle_t cycle_last;
> > +       cycle_t mask;
> > +       u32     mult;
> > +       u32     shift;
> >
> >         /* open coded 'struct timespec' */
> >         time_t          wall_time_sec;
> > diff --git a/arch/x86/kernel/vsyscall_gtod.c b/arch/x86/kernel/vsyscall_gtod.c
> > index 91862a4..ca48248 100644
> > --- a/arch/x86/kernel/vsyscall_gtod.c
> > +++ b/arch/x86/kernel/vsyscall_gtod.c
> > @@ -16,6 +16,18 @@
> >
> >  DEFINE_VVAR(struct vsyscall_gtod_data, vsyscall_gtod_data);
> >
> > +static inline void gtod_write_begin(unsigned *s)
> > +{
> > +       ++*s;
> > +       smp_wmb();
> > +}
> > +
> > +static inline void gtod_write_end(unsigned *s)
> > +{
> > +       smp_wmb();
> > +       ++*s;
> > +}
> > +
> 
> Someone else should probably comment on the style for this.  Maybe
> this should live in a header somewhere.  IMO if it's called
> gtod_write_begin, it should take a pointer to gtod as a parameter.
> 

Fixed in the next version.

> 
> > +struct api_timeval {
> > +       long    tv_sec;         /* seconds */
> > +       long    tv_usec;        /* microseconds */
> > +};
> > +
> > +struct api_timespec {
> > +       long    tv_sec;         /* seconds */
> > +       long    tv_nsec;        /* nanoseconds */
> > +};
> 
> Did you address my question about why there are two versions of this?
> Shouldn't it just match the userspace headers regardless of what the
> host kernel is?
> 

Again, -m32 compilation. The timeval and timespec are __kernel_long_t,
which is defined as "long long" in a case of 32 bit VDSO for 64 bit
kernel.

The vsyscall_gtod_data use the kernel defined timeval and timespec, so
for 32 bit a conversation is needed.

The only way to prevent this kind of hack is to replace the struct
timespec and time_t members of vsyscall_gtod_data by a compiler independ
definition.

In this case it would be also necessary to have an own copy of
timespec_add_ns() function for the VDSO.

> You have *still* not responded to my objection to the unconditional fixmaps.
> 

I have responded this objection on monday. If i enable the sysctl
interface i need this mapping too.

- Stefani


