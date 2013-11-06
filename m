Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab3KFPdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 10:33:19 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753476Ab3KFPdS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 10:33:18 -0500
Message-ID: <1383751951.28218.64.camel@flatline.rdu.redhat.com>
Subject: Re: [libseccomp-discuss] ARM audit, seccomp, etc are broken wrt
 OABI syscalls
From: Eric Paris <eparis@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Kees Cook <keescook@chromium.org>, Will Drewry <wad@chromium.org>,
        Richard Weinberger <richard@nod.at>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 06 Nov 2013 10:32:31 -0500
In-Reply-To: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-11-05 at 14:36 -0800, Andy Lutomirski wrote:
> [cc: some ARM people]
> 
> After a bit of an adventure, I got QEMU working.  (Linux 3.12's smc91x
> driver and qemu 1.6 don't get along.  It would be great if some
> kernel.org page described a standard way to boot a modern Linux image
> on a modern QEMU version, but I digress.)
> 
> The current state of affairs is unhealthy.  I wrote a program
> (attached) that does 'svc $0x90002f' (silly GNU syntax for "Issue the
> getgid syscall in OABI").  The registers I program are:
> 
> r0: 1
> r1: 2
> r2: 3
> r3: 4
> r4: 5
> r5: 6
> 
> (i.e. the arguments are 1,2,3,4,5,6, although getgid ignores them)
> 
> r7: 1
> 
> (r7 is the EABI syscall register.  On a kernel without OABI support,
> the immediate svc argument is ignored and syscall 1, i.e. _exit, will
> be invoked).
> 
> Seccomp sees the registers as I set them (unsurprisingly) and it sees
> nr == 0x2f.  It passes those values on to a SIGSYS handler, if one
> exists.  This is, IMO, bad.  The OABI and EABI argument passing
> conventions are *not* the same, and seccomp filters that check syscall
> argument values may be spoofable by using OABI calls.
> 
> I suspect that audit, perf, ftrace, and maybe even ptrace are broken
> as well for exactly the same reason.
> 
> I would argue that there are two reasonable fixes:
> 
> 1. Set a different audit arch for OABI syscalls (e.g.
> AUDIT_ARCH_ARMOABI).  That is, treat OABI syscall entries the same way
> that x86_64 treats int 80.

As the audit maintainer, I like #1.  It might break ABI, but the ABI is
flat wrong now and not maintainable...

> 
> 2. Leave the 0x900000 bits set in the syscall nr.  That way OABI
> syscalls would look like a different set of syscalls on the same
> architecture.  That is, treat OABI syscall entries kind of like x86_64
> treats x32 syscalls.  (There's probably no reason to accept 0x900000 +
> N as an r7 value to cause 'svc 0' to invoke OABI syscall N, though.)
> 
> 3. Unconditionally kill any process that makes an OABI syscall with
> seccomp enabled (because there should be no such programs).  Eww.
> 
> Options 1 and 2 are both break ABI, but I doubt that anythink cares.
> OABI is, AFAICT, mostly dead.  That being said, even if nothing
> legitimate uses OABI, exploits against seccomp-using programs can
> certainly use OABI, so I think that this needs to be fixed somehow.
> 
> Thoughts?  I think I prefer option 1.  I don't really want to make the
> change because my ARM assembly skills are lacking.
> ------------------------------------------------------------------------------
> November Webinars for C, C++, Fortran Developers
> Accelerate application performance with scalable programming models. Explore
> techniques for threading, error checking, porting, and tuning. Get the most 
> from the latest Intel processors and coprocessors. See abstracts and register
> http://pubads.g.doubleclick.net/gampad/clk?id=60136231&iu=/4140/ostg.clktrk
> _______________________________________________
> libseccomp-discuss mailing list
> libseccomp-discuss@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/libseccomp-discuss


