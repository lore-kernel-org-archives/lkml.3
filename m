Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaCIIrp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 04:47:45 -0400
Received: from www84.your-server.de ([213.133.104.84]:41465 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090AbaCIIri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 04:47:38 -0400
Message-ID: <1394354848.1002.37.camel@wall-e.seibold.net>
Subject: Re: [x86, vdso] BUG: unable to handle kernel paging request at
 d34bd000
From: Stefani Seibold <stefani@seibold.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Date: Sun, 09 Mar 2014 09:47:28 +0100
In-Reply-To: <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
References: <20140307013833.GD8427@localhost>
	 <1394176888.1018.3.camel@wall-e.seibold.net>
	 <CALCETrVCwZWvd78urw+O4zD3PoNZTQxg8FMzTrUi4+5w9rC5=A@mail.gmail.com>
	 <1394229220.20013.13.camel@wall-e.seibold.net>
	 <CALCETrXB0G3aA1Usp4U-9-eN0z22YC4Sn+3z42mrU2ab0gE9gQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 07.03.2014, 15:07 -0800 schrieb Andy Lutomirski:
> On Fri, Mar 7, 2014 at 1:53 PM, Stefani Seibold <stefani@seibold.net> wrote:
> >
> > Am Freitag, den 07.03.2014, 10:56 -0800 schrieb Andy Lutomirski:
> >> On Thu, Mar 6, 2014 at 11:21 PM, Stefani Seibold <stefani@seibold.net> wrote:
> >> > Hi Fengguang,
> >> >
> >> > i have build a kernel with the config, but my kvm is unable to start it.
> >> > I will try to find a way to test your kernek config.
> >> >
> >> > One thing is the crash point:
> >> >
> >> > The function sysenter_setup was modified by Andy, maybe he has an idea
> >> > what fails.
> >>
> >> *sigh*
> >>
> >> My host kernel is currently fscked up and won't run KVM.  Also, I want
> >> to confirm that I'm reproducing exactly what you're seeing, and I
> >> think it depends on the toolchain.  Can you (Fenguang) do:
> >>
> >> $ ls -l arch/x86/vdso/vdso32*.so
> >> -rwxrwxr-x. 1 luto luto 4096 Mar  7 10:19 arch/x86/vdso/vdso32-int80.so
> >> -rwxrwxr-x. 1 luto luto 4116 Mar  7 10:19 arch/x86/vdso/vdso32-sysenter.so
> >>
> >> (Of course, triggering this depends on which image gets selected.)
> >>
> >
> > Yes, that what i also figured out. There are two culprits:
> > CONFIG_OPTIMIZE_INLINING and CONFIG_X86_PPRO_FENCE. Each of them
> > increase the size of the code by about 500 bytes.
> >
> > When i add to file arch/x86/vdso/vdso32/vclock_gettime.c
> >
> > #undef CONFIG_OPTIMIZE_INLINING
> > #undef CONFIG_X86_PPRO_FENCE
> >
> > this will solve the issue.
> >
> >> Note that we have a .so file that exceeds 4k, i.e. one page.  Then
> >> read the relevant code and wonder what everyone was smoking when they
> >> wrote it.  There are so many buffer overflows, screwed up
> >> initializations, unnecessary and incorrect copies, etc, that I don't
> >> even want to speculate on what the first failure will be when the
> >> image is bigger than a page.
> >>
> >
> > Right. So the above one will not really solve it. At least when
> > __vdso_getcpu() code will also become a part of the 32 bit VDSO.
> >
> >> It's easy enough to fix, but someone should figure out what the impact
> >> will be on the compat vdso case.
> >>
> >> I wonder how hard it would be to change the compat vdso do be a dummy
> >> image a la the x86_64 fake vsyscall page so that old code can keep
> >> working (maybe with a performance hit) and new code can use a sane
> >> image.
> >>
> >
> > That is exactly what i wrote one week ago:
> >
> > Move the VDSO code before the VDSO compat fixmap area and create a kind
> > of helper VDSO for the VDSO compat fixmap page, which only calls the
> > real VDSO. But this would result in a performance regression for the
> > VDSO compat mode.
> 
> I think that regressing performance for compat_vdso (only) users is
> fine.  We need to figure out what those users are.  I have a vague
> recollection that it's a particular version of SuSE or OpenSuSE.
> 

Before i start to work i would ask if the following is a viable
solution:

The best is to have two different kinds of vDSO for all x86 32 bit
mutations (int80, syscall and sysenter):

- The compat vDSO which has only the __kernel_vsyscall(),
__kernel_sigreturn() and __kernel_rt_sigreturn() support. This will
never exceeds the page size limit.

- And the newer vDSO which has also support for __vdso_clock_gettime(),
__vdso_gettimeofday() and __vdso_time().

In case of compat vDSO (kernel parameter vdso=2) we map the compat vDSO
to the fixmap address. So we have exactly the old behaviour and there is
no regression nor a compatibility issue.

For the non compat vDSO suport (kernel parameter vdso=1) we can use the
larger vDSO with the time support functions, because we have no
limitations in the size of the vDSO.

This could be done very easily.

But let me ask an other question: Is the compat mode still needed
anymore?

Since Lguest, XEN, OPLC and the reservetop kernel parameter will change
the __FIXADDR_TOP, there is no fix place for the VDSO page. Also in the
32 bit emulation layer the address is not fix.

So all applications can fail when try directly access the VDSO page with
a hard coded address 0xffffe000.

IMHO this is broken. So an other solution is to remove the whole VDSO
compat code.

- Stefani


