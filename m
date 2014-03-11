Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121AbaCKOyL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 10:54:11 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:60698 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbaCKOyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 10:54:08 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
References: <f23ea19270122375e8d2efe0646bbe6101c451b4.1394499629.git.luto@amacapital.net>
 <CA+55aFwaWgb-hCfOf8Y_LA+ZAHpTFYU937XN=7T6SxDAdpPzcg@mail.gmail.com>
 <CALCETrUe0TjzjEo-N2GZkD9DiVbtjretGjTVqiv7U+ZJerWLXQ@mail.gmail.com>
 <CA+55aFydgX7yejyPq0ckuXabEFhjXO960F=L0-+yYNT=U=Madg@mail.gmail.com>
 <CALCETrXd_7K2rc-JPDFtxQWE+ZURzY6qfOLR9DDtjp-nBG1Sgg@mail.gmail.com> <CA+55aFzPntnPHCbNa6PNdeKQmFBsF4JNu0BHix8LsP2ybYQ-Yg@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 11 Mar 2014 07:53:47 -0700
Message-ID: <CALCETrXai1eS9FFC=EsxzSy51fMjgEh+zD6meDJiovLirPKf2Q@mail.gmail.com>
Subject: Re: [PATCH v2] x86: Remove compat vdso support
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Stefani Seibold <stefani@seibold.net>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Runge <Martin.Runge@rohde-schwarz.com>,
        Andreas Brief <Andreas.Brief@rohde-schwarz.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 11, 2014 2:36 AM, "Linus Torvalds" <torvalds@linux-foundation.org> wrote:
>
> On Mon, Mar 10, 2014 at 9:10 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> >
> > I suspect that a lot of 32-bit Linux users want syscall and/or
> > sysenter, and Stefani certainly wants the fast timing that the vDSO
> > can provide.  Also, presumably __kernel_sigreturn serves some purpose
> > :)
>
> Are we talking about the same thing at all?
>
> We're talking about the *COMPAT* vdso, right?
>
> The one you were just told Fedora had never _ever_ enabled? And you
> are seriously arguing that "peformance" is relevant, while at the same
> time trying to claim that the fact that it DOES NOT WORK on SuSE -
> which *did* enable it - is not such a big deal, and that we should
> ignore the "don't break user space" rule?

There isn't a separate "compat" vdso.  There may or may not be a vdso,
and that vdso may or may not be "compat".  Since the kernel can't
easily tell whether ld.so has the bug, the kernel can't easily decide
which vdso to present, if any.  So current kernels use only the compat
vdso by default.

The compat vdso *does* work on opensuse 9.  I'm arguing the the number
of people who use opensuse 9 is low enough that we should support them
by offering to turn off the vdso instead of by offering to fudge the
address at which the vdso is mapped.  The compat vdso also works on
modern glibc, but that comes at the expense of ASLR, some fixmap
entries that no one likes, and general maintainability of the code.


I wonder if we can actually detect buggy glibc versions at runtime.
The relevant commits are:

f866314b89d56845f55e6f365e18b31ec978ec3a: (Sun May 4 04:30:13 2003
+0000): add vdso support
3b3ddb4f7db98ec9e912ccdf54d35df4aa30e04a (Thu Feb 26 20:06:58 2004
+0000): remove the buggy assertion
49ad572a70b8aeb91e57483a11dd1b77e31c4468 (Sat Feb 28 17:56:22 2004
+0000): actually fix the code

Unfortunately, I was wrong about the affected versions.  Glibc 2.3.3
was released with the bug; glibc 2.3.2 and 2.3.4 appear to be okay.

It's okay for a quirk to incorrectly flag older glibc versions -- they
won't use a vdso regardless of what aux entries we set.  Incorrectly
flagging versions that are too new as quirky is unfortunate.

Checking for the text "(void *) ph->p_vaddr ==
_rtld_local._dl_sysinfo_dso" in ld.so will detect all but two days
worth of bad glibc versions.  I don't think that we actually want to
fault in the whole ELF loader on each program load, though.

We can detect glibc 2.3 in general by checking the symbol version
definitions.  That will incorrectly penalize a large range of later
versions, though.

We could do something really weird: we could look at the *name* of the
ELF loader.  This would have to resolve symlinks, which is rather ugly
and probably a net loss of sanity.


--Andy

>
> Seriously?
>
> WTF?
>
>                 Linus
