Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751664AbaJZSJo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 14:09:44 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42772 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJZSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 14:09:42 -0400
Date: Sun, 26 Oct 2014 18:09:39 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] all arches, signal: Move restart_block to struct
 task_struct
Message-ID: <20141026180938.GR7996@ZenIV.linux.org.uk>
References: <90d5683679179df27ffeef18c3e1010ed4e72695.1414342681.git.luto@amacapital.net>
 <20141026171819.GQ7996@ZenIV.linux.org.uk>
 <CALCETrW0pqGznCOEoFT3ttEkmqNmpZVaNu-FPb=RUB3D7k+aQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrW0pqGznCOEoFT3ttEkmqNmpZVaNu-FPb=RUB3D7k+aQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 10:36:45AM -0700, Andy Lutomirski wrote:

> I never said it was the *only* juicy target, but we can fix the rest,
> too.  Also, I suspect that overwriting task could be harder to
> exploit.  First, you need to avoid crashing, and second, on systems
> with SMAP or similar protection, you need to make task point somewhere
> that contains a useful exploit payload.
> 
> We could probably get rid of thread_info's task pointer on x86, too --
> it's not used by get_current() any more.

Huh?  If you can overwrite that pointer, you can bloody well overwrite
->task itself, making it point into the overwritten part of stack right
next to thread_info.

Again, on most of the architectures the _only_ way to reach task_struct
is via thread_info:
	* everything that uses asm-generic/current.h - arm, arm64, blackfin,
c6x, hexagon, metag, mips, openrisc, sh, um, unicore32
	* everything that should be using it - alpha, avr32, cris, m32r,
parisc, score, tile.  These guys can simply add generic-y += current.h
into their asm/Kbuild and remove asm/current.h.
	* nearly the same situation - xtensa (there's an asm variant of
the same thing + copy of asm-generic/current.h for C)
	* sparc32
	* m68k-noMMU
	* mn10300-SMP

It's a strong majority.  Check arch/*/asm/current.h and see for yourself.
