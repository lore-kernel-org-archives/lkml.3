Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab3BNBVb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:21:31 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:61417 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab3BNBVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:21:30 -0500
MIME-Version: 1.0
In-Reply-To: <511C24A6.8020409@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
 <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
 <511BE4A3.8050607@redhat.com> <CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
 <511C1204.9040608@redhat.com> <CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
 <511C24A6.8020409@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 13 Feb 2013 17:21:08 -0800
X-Google-Sender-Auth: aWBJHb5gIODE8O_2G5vEeRhFASo
Message-ID: <CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, aquini@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 3:41 PM, Rik van Riel <riel@redhat.com> wrote:
>
> I have an example of the second case. It is a test case
> from a customer issue, where an application is contending on
> semaphores, doing semaphore lock and unlock operations. The
> test case simply has N threads, trying to lock and unlock the
> same semaphore.
>
> The attached graph (which I sent out with the intro email to
> my patches) shows how reducing the memory accesses from the
> spinlock wait path prevents the large performance degradation
> seen with the vanilla kernel. This is on a 24 CPU system with
> 4 6-core AMD CPUs.
>
> The "prop-N" series are with a fixed delay proportional back-off.
> You can see that a small value of N does not help much for large
> numbers of cpus, and a large value hurts with a small number of
> CPUs. The automatic tuning appears to be quite robust.

Ok, good, so there are some numbers. I didn't see any in the commit
messages anywhere, and since the threads I've looked at are from
tip-bot, I never saw the intro email.

That said, it's interesting that this happens with the semaphore path.
We've had other cases where the spinlock in the *sleeping* locks have
caused problems, and I wonder if we should look at that path in
particular.

> If we have only a few CPUs contending on the lock, the delays
> will be short.

Yes. I'm more worried about the overhead, especially on I$ (and to a
lesser degree on D$ when loading hashed delay values etc). I don't
believe it would ever loop very long, it's the other overhead I'd be
worried about.

>From looking at profiles of the kernel loads I've cared about (ie
largely VFS code), the I$ footprint seems to be a big deal, and
function entry (and the instruction *after* a call instruction)
actually tend to be hotspots. Which is why I care about things like
function prologues for leaf functions etc.

> Furthermore, the CPU at the head of the queue
> will run the old spinlock code with just cpu_relax() and checking
> the lock each iteration.

That's not AT ALL TRUE.

Look at the code you wrote. It does all the spinlock delay etc crap
unconditionally. Only the loop itself is conditional.

IOW, exactly all the overhead that I worry about. The function call,
the pointless turning of leaf functions into non-leaf functions, the
loading (and storing) of delay information etc etc.

The non-leaf-function thing is done even if you never hit the
slow-path, and affects the non-contention path. And the delay
information thing is done even if there is only one waiter on the
spinlock.

Did I miss anything?

> Eric got a 45% increase in network throughput, and I saw a factor 4x
> or so improvement with the semaphore test. I realize these are not
> "real workloads", and I will give you numbers with those once I have
> gathered some, on different systems.

Good. This is what I want to see.

> Are there significant cases where "perf -g" is not easily available,
> or harmful to tracking down the performance issue?

Yes. There are lots of machines where you cannot get call chain
information with CPU event buffers (pebs). And without the CPU event
buffers, you cannot get good profile data at all.

Now, on other machines you get the call chain even with pebs because
you can get the whole

> The cause of that was identified (with pause loop exiting, the  host
> effectively does the back-off for us), and the problem is avoided
> by limiting the maximum back-off value to something small on
> virtual guests.

And what if the hardware does something equivalent even when not
virtualized (ie power optimizations I already mentioned)?  That whole
maximum back-off limit seems to be just for known virtualization
issues. This is the kind of thing that makes me worry..

                   Linus
