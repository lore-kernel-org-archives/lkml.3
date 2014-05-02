Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaEBTbp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:31:45 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:47379 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaEBTbn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:31:43 -0400
MIME-Version: 1.0
In-Reply-To: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
References: <210a076ea197ae384705d2c02cfff12a951a62f8.1399057218.git.luto@amacapital.net>
Date: Fri, 2 May 2014 12:31:42 -0700
X-Google-Sender-Auth: h_qm-4GBJM6cHSubgE1v0CQ5L1E
Message-ID: <CA+55aFzfDgeFmzk18xJ+ZvCcm-qCsCtd4RrNxYi0CXdfNbZn_A@mail.gmail.com>
Subject: Re: [RFC/HACK] x86: Fast return to kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        "H. Peter Anvin" <h.peter.anvin@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 2, 2014 at 12:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> This speeds up my kernel_pf microbenchmark by about 17%.  The cfi
> annotations need some work.

Sadly, performance of page faults in kernel mode is pretty much
completely uninteresting. It simply doesn't happen on any real load.

That said, regular *device* interrupts do often return to kernel mode
(the idle loop in particular), so if you have any way to measure that,
that might be interesting, and might show some of the same advantages.

And NMI not being re-enabled might just be a real advantage. Adding
Steven to the cc to make him aware of this patch.

So I like the patch, I just think that selling it on a "page fault
cost" basis is not very interesting. The real advantages would be
elsewhere. The page fault case is mainly a good way to test that it
restores the registers correctly.

Also, are you *really* sure that "popf" has the same one-instruction
interrupt shadow that "sti" has? Because I'm not at all sure that is
true, and it's not documented as far as I can tell. In contrast, the
one-instruction shadow after "sti" very much _is_ documented.

You may need to have a separate paths for do/don't enable interrupts,
with the interrupt-enabling one clearing the IF bit on stack, and then
finishing with "popf ; sti ; retq" instead.

Side note related to the whole IF shadow: that thing is also really
easy to get wrong in emulation etc, so we should check with the
virtualization people..

              Linus
