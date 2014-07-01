Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758733AbaGAUTB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:19:01 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:63308 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220AbaGAUTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:19:00 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 1 Jul 2014 13:18:38 -0700
Message-ID: <CALCETrXy3ft8AipAm=_u9OJb-t+FF=AfvXBke4pTh5a25nTcFA@mail.gmail.com>
Subject: Seccomp performance vs. asm complexity
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>,
        Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a question about tradeoffs.  I'm playing with a couple of
approaches for an x86 seccomp fast path.

It looks like populating struct seccomp_data in the syscall entry asm
code saves 4-5ns (83ns vs 87.7ns or so for getpid with seccomp
enabled).  Presumably this is because it avoids a branch and replaces
seven two-instruction memory copies with 6 register pushes and one
memory push.  It also keeps the code shorter, with corresponding
icache benefits.

OTOH, populating struct seccomp_data in C keeps the asm code shorter
and simpler.  In fast, it ends up being a net deletion of asm code.

Thoughts?  What's a line of assembly code worth?  Keep in mind that
someone will probably want to port this to the x86_32 and compat
entries.

To keep this in perspective, this is down from >200ns in 3.16-rc3.

My current code is here:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/seccomp-fastpath

I think it's in pretty good shape, but I still want to play with it a
bit before sending it out.  This version uses the C approach.

--Andy
