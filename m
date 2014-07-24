Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531AbaGXSSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 14:18:20 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:53756 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934278AbaGXSSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 14:18:18 -0400
MIME-Version: 1.0
In-Reply-To: <20140724125814.GX6758@twins.programming.kicks-ass.net>
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com>
	<20140723095327.GA23131@pd.tnic>
	<CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com>
	<20140724064353.GW9918@twins.programming.kicks-ass.net>
	<20140724084126.GB19239@pd.tnic>
	<20140724122513.GM19239@pd.tnic>
	<20140724125814.GX6758@twins.programming.kicks-ass.net>
Date: Thu, 24 Jul 2014 11:18:16 -0700
X-Google-Sender-Auth: YGjFDaGCRVgCVFQdPG0A96bE6aY
Message-ID: <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com>
Subject: Re: Linux 3.16-rc6
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2014 at 5:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> So going by the nifty picture rostedt made:
>
> [   61.454336]        CPU0                    CPU1
> [   61.454336]        ----                    ----
> [   61.454336]   lock(&(&p->alloc_lock)->rlock);
> [   61.454336]                                local_irq_disable();
> [   61.454336]                                lock(tasklist_lock);
> [   61.454336]                                lock(&(&p->alloc_lock)->rlock);
> [   61.454336]   <Interrupt>
> [   61.454336]     lock(tasklist_lock);

So this *should* be fine. It always has been in the past, and it was
certainly the *intention* that it should continue to work with
qrwlock, even in the presense of pending writers on other cpu's.

The qrwlock rules are that a read-lock in an interrupt is still going
to be unfair and succeed if there are other readers.

> the fact that CPU1 holds tasklist_lock for reading, does not
> automagically allow CPU0 to acquire tasklist_lock for reading too, for
> example if CPU2 (not in the picture) is waiting to acquire tasklist_lock
> for writing, CPU0's read acquire is made to wait.

No.

That is true for qrwlock in general. But *not* in interrupt context.
In interrupt context, it's unfair. At least that was the _intent_ of
the code, maybe that got screwed up some way.

> The only kind of recursion that's safe is same CPU interrupt.

Any read-lock from an irq should still be unfair, no "same CPU" rules.
See queue_read_lock_slowpath(), where it will just wait for any actual
write lockers (not *waiting* writers) to go away. So by definition, of
somebody else (not just the current CPU) holds the lock for reading,
taking it for reading is safe on all cpu's in irq context, because we
obviously won't be waiting for any actual write lock holders.

So it sounds to me like the new lockdep rules in tip/master are too
strict and are throwing a false positive.

              Linus
