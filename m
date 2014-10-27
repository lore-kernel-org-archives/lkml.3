Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752064AbaJ0BIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 21:08:46 -0400
Received: from mail-la0-f51.google.com ([209.85.215.51]:49661 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaJ0BIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 21:08:43 -0400
MIME-Version: 1.0
In-Reply-To: <71A9FEBE-A07D-4DFE-BDF7-D6E9A60CEFF2@zytor.com>
References: <90d5683679179df27ffeef18c3e1010ed4e72695.1414342681.git.luto@amacapital.net>
 <20141026171819.GQ7996@ZenIV.linux.org.uk> <CALCETrW0pqGznCOEoFT3ttEkmqNmpZVaNu-FPb=RUB3D7k+aQg@mail.gmail.com>
 <20141026180938.GR7996@ZenIV.linux.org.uk> <71A9FEBE-A07D-4DFE-BDF7-D6E9A60CEFF2@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sun, 26 Oct 2014 18:08:21 -0700
Message-ID: <CALCETrW1Tgp=yHVYrtHovzsyEbcsLsbBNANWrtbvRQmEZwMmPg@mail.gmail.com>
Subject: Re: [PATCH] all arches, signal: Move restart_block to struct task_struct
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kees Cook <keescook@chromium.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 26, 2014 at 11:11 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On x86 we have discussed to combine thread_info and task_struct into a single allocation with a percpu variable lining pointng at it.

Is that better than just gradually eliminating all the members of thread_info?

Anyway, ftrace is the only user of ti->task on x86, so it's not a very
juicy target.

--Andy

>
> On October 26, 2014 11:09:39 AM PDT, Al Viro <viro@ZenIV.linux.org.uk> wrote:
>>On Sun, Oct 26, 2014 at 10:36:45AM -0700, Andy Lutomirski wrote:
>>
>>> I never said it was the *only* juicy target, but we can fix the rest,
>>> too.  Also, I suspect that overwriting task could be harder to
>>> exploit.  First, you need to avoid crashing, and second, on systems
>>> with SMAP or similar protection, you need to make task point
>>somewhere
>>> that contains a useful exploit payload.
>>>
>>> We could probably get rid of thread_info's task pointer on x86, too
>>--
>>> it's not used by get_current() any more.
>>
>>Huh?  If you can overwrite that pointer, you can bloody well overwrite
>>->task itself, making it point into the overwritten part of stack right
>>next to thread_info.
>>
>>Again, on most of the architectures the _only_ way to reach task_struct
>>is via thread_info:
>>       * everything that uses asm-generic/current.h - arm, arm64, blackfin,
>>c6x, hexagon, metag, mips, openrisc, sh, um, unicore32
>>       * everything that should be using it - alpha, avr32, cris, m32r,
>>parisc, score, tile.  These guys can simply add generic-y += current.h
>>into their asm/Kbuild and remove asm/current.h.
>>       * nearly the same situation - xtensa (there's an asm variant of
>>the same thing + copy of asm-generic/current.h for C)
>>       * sparc32
>>       * m68k-noMMU
>>       * mn10300-SMP
>>
>>It's a strong majority.  Check arch/*/asm/current.h and see for
>>yourself.
>
> --
> Sent from my mobile phone.  Please pardon brevity and lack of formatting.



-- 
Andy Lutomirski
AMA Capital Management, LLC
