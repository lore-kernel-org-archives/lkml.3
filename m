Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab3JWVC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:02:26 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:42117 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab3JWVCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 17:02:24 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 23 Oct 2013 14:02:00 -0700
Message-ID: <CALCETrXyLBXmimjLepU=y1igmWpwcdWUNCqNjMHi_jyLw0pHMA@mail.gmail.com>
Subject: ARM seccomp filters and EABI/OABI
To: libseccomp-discuss@lists.sourceforge.net, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm looking at the seccomp code, the ARM entry code, and the
syscall(2) manpage, and I'm a bit lost.  (The fact that I don't really
speak ARM assembly doesn't help.)  My basic question is: what happens
if an OABI syscall happens?

AFAICS, the syscall arguments for EABI are r0..r5, although their
ordering is a bit odd*.  For OABI, r6 seems to play some role, but I'm
lost as to what it is.  The seccomp_bpf_load function won't load r6,
so there had better not be anything useful in there...  (Also, struct
seccomp_data will have issues with a seventh "argument".)

But what happens to the syscall number?  For an EABI syscall, it's in
r7.  For an OABI syscall, it's in the swi instruction and gets copied
to r7 on entry.  If a debugger changes r7, presumably the syscall
number changes.

Oddly, there are two different syscall tables.  The major differences
seem to be that some of the OABI entries have their argument order
changed.  But there's also a magic constant 0x900000 added to the
syscall number somewhere -- is it reflected in _sigsys._syscall?  Is
it reflected in ucontext's r7?

I'm a bit surprised to see that both the EABI and OABI ABIs show up as
AUDIT_ARCH_ARM.

Can any of you shed some light on this?  I don't have an ARM system I
can test on, but if one of you can point me at a decent QEMU image, I
can play around.

For reference, I'm working on userspace code to decode a TRAP and
eventually to allow syscall emulation (either by emulating the syscall
inside the signal handler and setting the return value or (egads!) by
changing the syscall and restarting it -- the latter is probably
impossible if the original syscall came in through OABI and may be
generally impossible if userspace expects any of the argument
registers to be preserved).


* I think that a syscall with signature long func(int a, long long b,
int c, int d, int e) ends up with c in r1 and b in r2/r3.  The
syscall(2) manpage appears to be entirely wrong.
