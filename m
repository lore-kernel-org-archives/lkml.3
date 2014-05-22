Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaEVXEq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 19:04:46 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:60595 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaEVXEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 19:04:44 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 May 2014 16:04:22 -0700
Message-ID: <CALCETrX4-qooSyLw3=zHGcMoWqQ2ozPB_WtKU2AtkMei-XZOUA@mail.gmail.com>
Subject: Pondering per-process vsyscall disablement
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be nice to have a way for new programs to declare that they
don't need vsyscalls.  What's the right way to do this?  An ELF header
entry in the loader?  An ELF header entry in the program?  A new
arch_prctl?

As background, there's an old part of the x86_64 ABI that allows
programs to do gettimeofday, clock_gettime, and getcpu by calling to
fixed addresses of the form 0xffffffffff600n00 where n indicates which
of those three syscalls is being invoked.  This is a security issue.

Since Linux 3.1, vsyscalls are emulated using NX and page faults.  As
a result, vsyscalls no longer offer any performance advantage over
normal syscalls; in fact, they're much slower.  As far as I know,
nothing newer than 2012 will attempt to use vsyscalls if a vdso is
present.  (Sadly, a lot of things will still fall back to the vsyscall
page if there is no vdso, but that shouldn't matter, since there is
always a vdso.)

Despite the emulation, they could still be used as a weird form of ROP
gadget that lives at a fixed address.  I'd like to offer a way for new
runtimes to indicate that they don't use vsyscalls so that the kernel
can selectively disable emulation and remove the fixed-address
executable code issue.


--Andy
