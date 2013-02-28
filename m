Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760778Ab3B1V6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 16:58:51 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:52446 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab3B1V6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 16:58:47 -0500
MIME-Version: 1.0
In-Reply-To: <512FC89B.6030507@redhat.com>
References: <20130206150403.006e5294@cuia.bos.redhat.com>
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
	<CA+55aFw3t+sC-zv6njxdJ6hB0arJnZzoGNO9W7o8h=tcUo5P_Q@mail.gmail.com>
	<CA+55aFwEshukBGU5YCtKL=7c-43guMuGSHTnXo02rLxZWGQWTw@mail.gmail.com>
	<512FC89B.6030507@redhat.com>
Date: Thu, 28 Feb 2013 13:58:46 -0800
X-Google-Sender-Auth: _SxQjcWYIXI3SSwraB1HIe4_ViQ
Message-ID: <CA+55aFxbm83Oc2g55868HA2xCytsJzTxWGE0w_pMUzKaU5mJMw@mail.gmail.com>
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
        Michel Lespinasse <walken@google.com>, Ingo Molnar <mingo@kernel.org>,
        Larry Woodman <lwoodman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 1:14 PM, Rik van Riel <riel@redhat.com> wrote:
>
> I have modified one of the semop tests to use multiple semaphores.

Ooh yeah. This shows contention quite nicely. And it's all from
ipc_lock, and looking at the top-10 loffenders of the profile:

 43.01%  semop-multi  [kernel.kallsyms]   [k] _raw_spin_lock
...
  4.73%  semop-multi  [kernel.kallsyms]   [k] avc_has_perm_flags
  4.52%  semop-multi  [kernel.kallsyms]   [k] ipc_has_perm.isra.21
...
  2.43%  semop-multi  [kernel.kallsyms]   [k] ipcperms

The 43% isn't actually all that interesting, it just shows that there
is contention and we're waiting for other user. Yes, we waste almost
half the CPU time on locking, but ignore that for a moment.

The "more than 10% of the total time is spent in ipc permission code"
*is* the interesting part. Because that 10%+ is actually more like 20%
if you ignore the "wait for lock" part. And it's all done *inside* the
lock.

In other words, I can pretty much guarantee that the contention will
go down a lot if we just move the security check outside the spinlock.
According to the above numbers, we're currently spending basically
1/5th of our remaining CPU resources serialized for absolutely no good
reason. THAT is the kind of thing we shouldn't do.

The rest of the big offenders seem to be mostly done outside the
spinlock, although it's hard to tell how much of the 10% of
sys_semtimedop() iis also under the lock. There's probably other
things there than just the permission checking.

I'm not seeing any real reason the permission checking couldn't be
done just under the RCU lock, before we get the spinlock. Except for
the fact that the "helper" routines in ipc/util.c are written the way
they are, so it's a layering violation. But I really think that would
be a *reasonably* low-hanging fruit thing to do.

Changing the locking itself to be more fine-grained, and doing it
across many different ipc semaphores would be a major pain. So I do
suspect that the work Michel Lespinasse did is probably worth doing
anyway in addition to at least trying to fix the horrible lack of
scalability of the code a bit.

                      Linus
