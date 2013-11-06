Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab3KFAOx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 19:14:53 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:44321 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755558Ab3KFAOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 19:14:51 -0500
MIME-Version: 1.0
In-Reply-To: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
References: <CALCETrUt7Ojh5Yy4KYgBPj_wBr=fzKKJ=OOgGP9BtXoKrr9QnA@mail.gmail.com>
Date: Tue, 5 Nov 2013 16:14:49 -0800
X-Google-Sender-Auth: k07tiKhwdlzfVngzGXlFCK7o9xw
Message-ID: <CAGXu5jJreo001uBLV8oAgR_Z2WZK2qtH8YfvriQJVAQ4SgdRzw@mail.gmail.com>
Subject: Re: ARM audit, seccomp, etc are broken wrt OABI syscalls
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Paul Moore <paul@paul-moore.com>, Richard Weinberger <richard@nod.at>,
        libseccomp-discuss@lists.sourceforge.net,
        Will Drewry <wad@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 5, 2013 at 2:36 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> [cc: some ARM people]
>
> After a bit of an adventure, I got QEMU working.  (Linux 3.12's smc91x
> driver and qemu 1.6 don't get along.  It would be great if some
> kernel.org page described a standard way to boot a modern Linux image
> on a modern QEMU version, but I digress.)

Yeah, I kept losing this battle too, and most recently switch to using
mmc emulation instead of the SCSI emulation (CONFIG_MMC=y, and qemu's
"sd" disk driver).

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

Just to clarify: without CONFIG_OABI_COMPAT, all OABI syscalls turn into _exit?

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

I would agree: option 1 seems cleanest of the 3. 3 is sort of like a
built-in automatic check for a mismatched arch, so maybe that works
better?

Alternatively, CONFIG_SECCOMP_FILTER could depend on
!CONFIG_OABI_COMPAT. That seems like the least work, given the desire
to kill OABI in the real world. (Though I would note that at least
Ubuntu's ARM kernels build with CONFIG_OABI_COMPAT; Chrome OS does
not.)

-Kees

-- 
Kees Cook
Chrome OS Security
