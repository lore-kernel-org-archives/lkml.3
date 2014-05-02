Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaEBTvT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:51:19 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:60076 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbaEBTvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:51:18 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
 <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 2 May 2014 12:50:57 -0700
Message-ID: <CALCETrX8wCxRj9=F7_pM_SKdSxSYttMyLZKAWTy9HurAmtfC2w@mail.gmail.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 12:31 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Fri, May 2, 2014 at 12:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> This speeds up my kernel_pf microbenchmark by about 17%.  The cfi
>> annotations need some work.
>
> Sadly, performance of page faults in kernel mode is pretty much
> completely uninteresting. It simply doesn't happen on any real load.

I wonder if mlock, mlockall, MAP_POPULATE and such would benefit.
Anyone who mmaps a file and writes from the mmapped area to a socket,
pipe, or another file would benefit, I think, although I haven't
checked exactly how that works.

>
> That said, regular *device* interrupts do often return to kernel mode
> (the idle loop in particular), so if you have any way to measure that,
> that might be interesting, and might show some of the same advantages.

I can try something awful involving measuring latency of
hardware-timed packets on a SolarFlare card, but I'll have calibration
issues.  I suppose I could see if 'ping' gets faster.  In general,
this will speed up interrupts that wake userspace from idle by about
100ns on my box, since it's presumably the same size and the speedup
per loop in my silly benchmark.

I bet that lat_ctx and such would speed up, but that's unfair, since
it's still just a bug.

>
> And NMI not being re-enabled might just be a real advantage. Adding
> Steven to the cc to make him aware of this patch.
>
> So I like the patch, I just think that selling it on a "page fault
> cost" basis is not very interesting. The real advantages would be
> elsewhere. The page fault case is mainly a good way to test that it
> restores the registers correctly.
>
> Also, are you *really* sure that "popf" has the same one-instruction
> interrupt shadow that "sti" has? Because I'm not at all sure that is
> true, and it's not documented as far as I can tell. In contrast, the
> one-instruction shadow after "sti" very much _is_ documented.
>
> You may need to have a separate paths for do/don't enable interrupts,
> with the interrupt-enabling one clearing the IF bit on stack, and then
> finishing with "popf ; sti ; retq" instead.

Hmm.  I think I may have mis-remembered - I can't find it either.
I'll try this.

I'll also grumble at the CFI stuff.  I'm not really sure how to test
it -- my copy of gdb isn't happy with the stack even before I start
fiddling with it.

--Andy
