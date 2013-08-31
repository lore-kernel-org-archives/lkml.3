Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3HaSW2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 14:22:28 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55565 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753829Ab3HaSW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 14:22:26 -0400
MIME-Version: 1.0
In-Reply-To: <1376687844-19857-4-git-send-email-andi@firstfloor.org>
References: <1376687844-19857-1-git-send-email-andi@firstfloor.org>
	<1376687844-19857-4-git-send-email-andi@firstfloor.org>
Date: Sat, 31 Aug 2013 20:22:23 +0200
X-Google-Sender-Auth: T-ysyZ25Tvkrn2eH_uj43X3cCJA
Message-ID: <CAMuHMdU-EJdS2epcLUKXThSdGcQd56aXyPH5TyyhGZeiDtZBxQ@mail.gmail.com>
Subject: Re: [PATCH 3/6] tree-sweep: Include linux/sched.h for might_sleep users
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 16, 2013 at 11:17 PM, Andi Kleen <andi@firstfloor.org> wrote:
> might_sleep is moving from linux/kernel.h to linux/sched.h, so any users
> need to include linux/sched.h

Really? <linux/sched.h> is the worst choice w.r.t. include hell.

> This was done with a mechanistic script and some uses may be redundant
> (already included in some other include file). However it's good practice
> to always include any needed symbols from the top level .c file.
>
> Tested with x86-64 allyesconfig. I used to do a x86-32 allyesconfig
> on a old kernel, but since that is broken now I didn't retest.
>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

> diff --git a/arch/mn10300/include/asm/uaccess.h b/arch/mn10300/include/asm/uaccess.h
> index 5372787..274c9c2 100644
> --- a/arch/mn10300/include/asm/uaccess.h
> +++ b/arch/mn10300/include/asm/uaccess.h
> @@ -14,6 +14,7 @@
>  /*
>   * User space memory access functions
>   */
> +#include <linux/sched.h>
>  #include <linux/thread_info.h>
>  #include <linux/kernel.h>
>  #include <asm/page.h>

This part breaks mn10300:

  CC      init/version.o
In file included from linux-next/include/linux/timex.h:56:0,
                 from linux-next/include/linux/sched.h:17,
                 from linux-next/arch/mn10300/include/asm/uaccess.h:17,
                 from linux-next/arch/mn10300/include/asm/processor.h:21,
                 from linux-next/include/linux/spinlock_up.h:8,
                 from linux-next/include/linux/spinlock.h:89,
                 from linux-next/include/linux/seqlock.h:29,
                 from linux-next/include/linux/time.h:5,
                 from linux-next/include/linux/stat.h:18,
                 from linux-next/include/linux/module.h:10,
                 from linux-next/init/version.c:10:
linux-next/include/uapi/linux/timex.h:76:17: error: field 'time' has
incomplete type

http://kisskb.ellerman.id.au/kisskb/buildresult/9424440/
http://kisskb.ellerman.id.au/kisskb/buildresult/9424438/

Note that it doesn't use might_sleep(). It does use might_fault(), but only from
a macro, not from a C inline function.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
