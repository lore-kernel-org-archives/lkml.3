Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab3GWD04 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 23:26:56 -0400
Received: from eu1sys200aog111.obsmtp.com ([207.126.144.131]:56243 "HELO
	eu1sys200aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753586Ab3GWD0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 23:26:49 -0400
Date: Tue, 23 Jul 2013 15:25:11 +1200
From: Michael Cree <cree@waikato.ac.nz>
To: Rob Landley <rob@landley.net>
Cc: Richard Henderson <rth@twiddle.net>, linux-kernel@vger.kernel.org,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        linux-alpha@vger.kernel.org
Subject: Re: [PATCH 0/7] Minor Alpha updates for 3.11
Message-ID: <20130723032511.GA18086@stolen.phys.waikato.ac.nz>
References: <20130717000347.GB2483@stolen.phys.waikato.ac.nz>
 <1374546701.3719.33@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374546701.3719.33@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 22, 2013 at 09:31:41PM -0500, Rob Landley wrote:
> On 07/16/2013 07:03:47 PM, Michael Cree wrote:
> >On Tue, Jul 16, 2013 at 06:35:07PM -0500, Rob Landley wrote:
> >> On 07/16/2013 12:04:33 PM, Richard Henderson wrote:
> >> >Here's a set of minor updates for arch/alpha that should not
> >> >be controversial.
> >>
> >> I also note that I had to do this to get busybox to build against
> >> uClibc:
> >> -#define __NR_umount		 22
> >> +#define __NR_umount2		 22
> >> -#define __NR_oldumount		321
> >> +#define __NR_umount		321
> >
> >I anticipate that this will likely break userspace.
> 
> Haven't seen it so far. It's the same semantics all the other
> targets have. Haven't built the whole of linux from scratch against
> it yet though. (Most of my package builds are native and I'm still
> tweaking my build environment to get a native toolchain built.)

[snip]

> I.E. nobody's tried to build busybox umount for Alpha (except me)
> for thirteen years.

That appears false to me.  Busybox builds OK on Debian-Ports [1], and it looks
like in the build log that umount is built.  A search in Debian busybox
sources does not return any hits for __NR_umount or __NR_umount2, but does
for umount2 which are library calls (admittedly ones that are just wrappers
for the kernel syscall). I also don't see any Debian patches in busybox that
change behaviour of busybox specifically for Alpha.  But IIRC Debian links
against glibc even for the installer where busybox is used.

So maybe the problem is in uClibc?  Yes, a quick look at the source shows
that uClibc does not test __NR_oldumount so presumably does not compile
correct umount and umount2 library calls on Alpha.

Maybe it's the case noone has compiled uClibc on Alpha until now?

> There are waaaaay more busybox installations out there than even
> _emulated_ alpha systems, and this is trivial to fix with a local
> patch to the kernel. So I'll just do that. Your idea of the
> "correct" thing to do to "fix" this seems entirely backwards to me.

I wondered if your proposal will break glibc as glibc checks for
__NR_oldumount and does different things based on that.  But maybe your
fix will not adversely affect glibc (I did not look particularly closely
to see if so), but even so, there is no guarantee that other software does
not directly access the oldumount syscall when compiled on Alpha, and your
change would likely break any such software.

Cheers
Michael

[1] http://buildd.debian-ports.org/status/package.php?p=busybox
