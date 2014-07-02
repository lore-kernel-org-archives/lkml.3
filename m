Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbaGBUAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:00:55 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:46860 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbaGBUAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:00:53 -0400
MIME-Version: 1.0
In-Reply-To: <20140701000913.5ea51f77@gandalf.local.home>
References: <20140701000913.5ea51f77@gandalf.local.home>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 2 Jul 2014 13:00:32 -0700
Message-ID: <CALCETrW8MYApbyVZ3zxhX3StqVZVBux1xoF8y+gNBAaUP7y6TQ@mail.gmail.com>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max = 13)
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 9:09 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> Testing the latest kernel (3.16-rc3) I hit this build bug:
>
>   VDSO2C  arch/x86/vdso/vdso-image-64.c
> Error: too many copied sections (max = 13)
> /arch/x86/vdso/Makefile:61: recipe for target 'arch/x86/vdso/vdso-image-64.c' failed
> make[3]: *** [arch/x86/vdso/vdso-image-64.c] Error 1
> /scripts/Makefile.build:404: recipe for target 'arch/x86/vdso' failed
> make[2]: *** [arch/x86/vdso] Error 2
>
> I bisected it down to this commit:
>
> commit 0e3727a8839c988a3c56170bc8da76d55a16acad
> Author: Andy Lutomirski <luto@amacapital.net>
> Date:   Wed Jun 18 15:59:49 2014 -0700
>
>     x86/vdso: Remove some redundant in-memory section headers
>
> When I revert this commit, it compiles fine.
>
> I built my gcc and binutils from their sources unmodified:
>
> gcc 4.6.0
>
> binutils 2.21

I managed to munge the binutils sources enough to build binutils 2.21.
This seems to be a binutils bug: ld generates an empty .rela.dyn.
Fortunately, it's not generating a DT_RELA dynamic entry.

I'm not quite sure what to do about this.  I could discard it, but
then I might want to make sure that, once I've discarded it, I don't
put any other sections in, since I don't know how well gdb can handle
section renumbering.  Maybe there's nothing to worry about here.

Or I could admit defeat and put the vvar area before the vdso text.

--Andy
