Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab3B0USQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 15:18:16 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:54488 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945Ab3B0USP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 15:18:15 -0500
MIME-Version: 1.0
In-Reply-To: <512E6443.9050603@redhat.com>
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
Date: Wed, 27 Feb 2013 12:18:13 -0800
X-Google-Sender-Auth: As1Sj_hciKnBk8PiAkjJ03SDYy0
Message-ID: <CA+55aFwHxv9RH75BoXYcwdKeHx+otOOpg9494TTdFwQe3biOhw@mail.gmail.com>
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket lock
 out of line
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, aquini@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        "Vinod, Chegu" <chegu_vinod@hp.com>, "Low, Jason" <jason.low2@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 11:53 AM, Rik van Riel <riel@redhat.com> wrote:
>
> If we have two classes of spinlocks, I suspect we would be better
> off making those high-demand spinlocks MCS or LCH locks, which have
> the property that having N+1 CPUs contend on the lock will never
> result in slower aggregate throughput than having N CPUs contend.

I doubt that.

The fancy "no slowdown" locks almost never work in practice. They
scale well by performing really badly for the normal case, either
needing separate allocations or having memory ordering problems
requiring multiple locked cycles.

A spinlock basically needs to have a fast-case that is a single locked
instruction, and all the clever ones tend to fail that simple test.

> I can certainly take profiles of various workloads, but there is
> absolutely no guarantee that I will see the same bottlenecks that
> eg. the people at HP have seen. The largest test system I currently
> have access to has 40 cores, vs. the 80 cores in the (much more
> interesting) HP results I pasted.
>
> Would you also be interested in performance numbers (and profiles)
> of a kernel that has bottleneck spinlocks replaced with MCS locks?

MCS locks don't even work, last time I saw. They need that extra lock
holder allocation, which forces people to have different calling
conventions, and is just a pain. Or am I confusing them with something
else?

They might work for the special cases like the sleeping locks, which
have one or two places that take and release the lock, but not for the
generic spinlock.

Also, it might be worth trying current git - if it's a rwsem that is
implicated, the new lock stealing might be a win.

So before even trying anything fancy, just basic profiles would be
good to see which lock it is. Many of the really bad slowdowns are
actually about the timing details of the sleeping locks (do *not*
enable lock debugging etc for profiling, you want the mutex spinning
code to be active, for example).

                   Linus
