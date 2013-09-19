Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab3ISSTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 14:19:50 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50029 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab3ISSTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 14:19:48 -0400
MIME-Version: 1.0
In-Reply-To: <87txhg3ftx.fsf@igel.home>
References: <20130917082838.218329307@infradead.org>
	<20130917182350.449685712@linutronix.de>
	<20130917183628.534494408@linutronix.de>
	<CAMuHMdWgrQf+ULDrZyY5R+vT3GtiWEgpsWxmfk0b5pivN7wBmg@mail.gmail.com>
	<alpine.DEB.2.02.1309172315550.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309181159520.4089@ionos.tec.linutronix.de>
	<alpine.DEB.2.02.1309191652480.4089@ionos.tec.linutronix.de>
	<87txhg3ftx.fsf@igel.home>
Date: Thu, 19 Sep 2013 20:19:47 +0200
X-Google-Sender-Auth: GP8yoSsMQ3adR4_M-Hr1QtEOBXw
Message-ID: <CAMuHMdW-YBroi6GezUP-KQBVRAcmYtUQERvBC=ekmemopDhVow@mail.gmail.com>
Subject: Re: [patch 1/6] hardirq: Make hardirq bits generic
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Peter Anvin <hpa@zytor.com>,
        Mike Galbraith <bitbucket@online.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 19, 2013 at 7:02 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Thomas Gleixner <tglx@linutronix.de> writes:
>> +     /*
>> +      * Only the last interrupt leaving the kernel goes through the
>> +      * various exception return checks.
>> +      */
>> +     cmpl    #0, %d0
>         tstl    %d0

arch/m68k/kernel/built-in.o: In function `bad_inthandler':
(.text+0x2a6): undefined reference to `ret_from_last_interrupt'

I came up with the quick (whitespace-damaged-gmail) fix below.
Or should we handle the nesting in handle_badint(), too?

--- a/arch/m68k/kernel/entry.S
+++ b/arch/m68k/kernel/entry.S
@@ -313,17 +313,11 @@ user_irqvec_fixup = . + 2

 ENTRY(bad_inthandler)
        SAVE_ALL_INT
-       GET_CURRENT(%d0)
-       movel   %d0,%a1
-       addqb   #1,%a1@(TINFO_PREEMPT+1)

        movel   %sp,%sp@-
        jsr     handle_badint
        addql   #4,%sp

-       movel   %curptr@(TASK_STACK),%a1
-       subqb   #1,%a1@(TINFO_PREEMPT+1)
-       jeq     ret_from_last_interrupt
        RESTORE_ALL

However, the resulting kernel hangs (on ARAnyM) after starting userspace:

| INIT: version 2.86 booting

I'll have a deeper look when I have some more time...

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
