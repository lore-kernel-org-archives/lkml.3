Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955AbaB0Ukz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 15:40:55 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:45749 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904AbaB0Ukx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 15:40:53 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 27 Feb 2014 12:40:32 -0800
Message-ID: <CALCETrWbjazg_kAY1uAB+cMTdaJqtyGrTwQWNFCSzZ56B0KEkw@mail.gmail.com>
Subject: Making a universal list of syscalls?
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        libseccomp-discuss@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, dealing with Linux syscalls in an architecture-independent
way is a mess.  Here are some issues:

 1. There's no clean way to map between syscall names and numbers on
different architectures.  The kernel contains a number of tables (that
work differently for different architectures).  strace has some arcane
mechanism.  libseccomp has another.

 2. There's no clean way to map between syscall argument registers and
logical syscall arguments.  Each architecture knows how to do it, as
do strace and glibc, but I suspect that *everyone* else gets it wrong.
 Especially on ARM.

 3. Determining which architectures have which syscalls is a mess.
Recent kernel builds love to warn me that finit_module is missing on
x86_64.  This is simply not true.  I have no idea why.

 4. Actually issuing a nontrivial syscall is annoying.  syscall(2) can
do it for the native architecture (only).

 5. Decoding ucontext from SIGSYS is a mess.  I have prototype code
for libseccomp that can do it, but it gets the arguments wrong due to
ABI issues.  See (2).

I'd like to see a master list in the kernel that lists, for every
syscall, the name, the number for each architecture that implements it
(using the AUDIT_ARCH semantics, probably), and the signature.  The
build process could parse this table to replace the current per-arch
mess.

Issues here: some syscalls have different signatures on different
architectures.  Maybe we could require that a canonical syscall name
would have the same signature everywhere, but architectures could
specify alternate names.  So, for things like clone (?), there could
actually be a few syscalls that all have alternate names of "clone".

More importantly, we could add a library in tools that exposes this
information to userspace.  Useful operations:

 - For a given (arch, nr), indicate, for each logical argument, which
physical argument slot is used or, if the argument is split into a
high and low part, which pair of slots is used.

 - For a given (nr, logical args), issue the syscall for the
architecture that build the library.

 - For a given (arch, nr, logical args), issue the syscall if
possible.  An x86_32 build could issue x86_64 syscalls with some
effort, and an x86_64 build could easily issue 32-bit syscalls.

 - For a given arch, map between name and nr, and give access to the signature.

If this happened, presumably all architectures that supported it would
have to have valid AUDIT_ARCH support.  That means that someone would
have to fix ARM OABI (sigh).

Thoughts?


--Andy
