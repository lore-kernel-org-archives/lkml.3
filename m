Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027Ab3B1SWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:22:30 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:57778 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab3B1SWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:22:25 -0500
MIME-Version: 1.0
In-Reply-To: <512F7429.4020103@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
	<tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org>
	<CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
	<511BE4A3.8050607@redhat.com>
	<CA+55aFycMB7OZGQ54ueQ74C42beDBSdQE_fKJDV=TbjTjr_emg@mail.gmail.com>
	<511C1204.9040608@redhat.com>
	<CA+55aFwxYK-BLH0crhySHaQvAYHOH-VGUi7WTd1aq-24+WTDYw@mail.gmail.com>
	<511C24A6.8020409@redhat.com>
	<CA+55aFws80EEJQskqiP+a5J-HOGu=M1Fe=uCs50ifedVxPxT1Q@mail.gmail.com>
	<512E376D.70105@redhat.com>
	<CA+55aFzPxJ3rfZvAvrP9LxCXfDU8AAVvhMZnP-OAoe-ycc70aw@mail.gmail.com>
	<512E6443.9050603@redhat.com>
	<CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com>
	<512E80E3.7060800@redhat.com>
	<CA+55aFwa0EjGG2NUDYVLVBmXJa2k81YiuNO2yggk=GLRQxhhUQ@mail.gmail.com>
	<512EC7F0.60103@redhat.com>
	<1362024397.1867.28.camel@buesod1.americas.hpqcorp.net>
	<CA+55aFygzjuNYiG4MTPMzimEjQ92rpS-rNJr7HD4OQCAqze5zg@mail.gmail.com>
	<512F7429.4020103@redhat.com>
Date: Thu, 28 Feb 2013 10:22:23 -0800
X-Google-Sender-Auth: L44W-tjE7PjzKSjwI832hHjoZT4
Message-ID: <CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>,
        linux-tip-commits@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, aquini@redhat.com,
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 7:13 AM, Rik van Riel <riel@redhat.com> wrote:
>
> Btw, the IPC lock is already fairly fine grained. One ipc
> lock is allocated for each set of semaphores allocated through
> sys_semget. Looking up those semaphores in the namespace, when
> they are used later, is done under RCU.

Bullshit. There is no fine-grained locking, and the code has never
ever been optimized for concurrency at all.

Yes, the lookup is done with RCU, and that's good. And I can tell you
*why* it's done with RCU:  all the trivial sysv semaphore benchmarks
I've seen tend to have just one lock per semget and then they test the
performance of that semaphore.

But I'm suspecting that since there is clearly contention going on
(and hopefully the real world people aren't just all pounding on one
single mutex), maybe these loads actually allocate multiple semaphores
with semget (that 'nsems' argument). And then we scale really badly,
because we use a single spinlock for all of them, even if we didn't
have to.

THERE IS ABSOLUTELY ZERO SCALING. None. Nada. The scaling that exists
(your RCU lookup example) is for *unrelated* locks, which is exactly
what you'd expect if all the simple benchmarks around did a single
sem-lock and then the "scaling" was tested by running a thousand
copies of that program - all using their own private single ipc
semaphore.

Plus the code in ipc/sem.c really is not very good. It does that
"sem_lock()" (which gets the ipc spinlock) way too eagerly, because
the semaphore lock also protects some trivial ipc stuff, so it gets
the lock *first*, then it does all the random checks it wants to do
(security checks, you name it), and then ot does all the queue undo
crap etc. All while holding that lock.

So no. There's no scaling, and the SINGLE lock that is held is held
way too f*cking long.

And that's what I'm talking about. We've never had people actually
bother about the IPC locking, because we've never had people who
cared. Everybody hates the crazy SysV IPC code, often for good reason.
People are told not to use it (use shared memory and futexes instead,
which actually *do* scale, and people *do* care about). But of course,
lots of projects do use the horrid SysV IPC code because it's
portable, and it does have those undo features etc.

And I'm sure we *could* fix it, but judging by past performance nobody
really cares enough. Which is why I do think that fixing it the wrong
way (by making the contention on the ipc_lock()) may well be the right
thing here for once.

Of course, if the real-world applications really only use a single
SysV semaphore, then we can't scale any better. But even then we could
still try to lower the hold-times of that ipc_lock().

And hold-time really tends to be one big killer for contention. A lot
of hardware tends to have ping-pong avoidance logic that means that
quick unlocks after getting the lock, and it will still remain in the
local node caches. Hardware features like that make it much harder to
introduce the really bad contention cases even if there are tons of
CPU's trying to access the same lock. But if the lock hold times are
long, it's *much* easier to get bad contention.

Looking at the code, if we could just get the security hook outside of
the locked region, that would probably be a big improvement. Maybe do
that part in the RCU lookup part? Because selinux really is very
expensive, with the whole ipc_has_perm -> avc_has_perm_flags thing etc
etc. This is exactly the kind of thing we did with pathnames.

I'm sure there are other things we could do to improve ipc lock times
even if we don't actually split the lock, but the security one might
be a good first step.

                      Linus
