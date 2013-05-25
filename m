Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757682Ab3EYScH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 14:32:07 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:27499 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757550Ab3EYScE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 14:32:04 -0400
Message-ID: <1369506721.2065.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH v2] ipc/sem.c: fix lockup, restore FIFO behavior
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Rik van Riel <riel@redhat.com>
Cc: Manfred Spraul <manfred@colorfullife.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, hhuang@redhat.com,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 May 2013 11:32:01 -0700
In-Reply-To: <51A0FB23.3050301@redhat.com>
References: <1369495011-2586-1-git-send-email-manfred@colorfullife.com>
	 <51A0FB23.3050301@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-05-25 at 13:55 -0400, Rik van Riel wrote:
> On 05/25/2013 11:16 AM, Manfred Spraul wrote:
> > The double coward solution:
> > - wakeup stays FIFO
> > - fast switch back to per-semaphore spinlock mode
> >
> > The patch
> > a) fixes a lockup due to a missing restart.
> > b) makes the wakeups again FIFO (as linux <= 3.0.9)
> > c) tries to limit the time while in global lock mode as much
> >     as possible. (same as linux-3.0.10-rc1)
> >
> > Changes:
> > - the wait-for-zero operations are moved into seperate lists. Thus they can
> >    be checked seperately, without rescanning the whole queue.
> > - If a complex operation must sleep, then all pending change operations are
> >    moved into the global queue. This allows to keep everything FIFO.
> > - When all complex operations have completed, the simple ops are moved
> >    back into the per-semaphore queues.
> >
> > Advantage:
> > - FIFO. Dropping FIFO is a user visible change, and I'm a coward.
> 
> I am still not entirely convinced that FIFO is worthwhile,
> but the code looks correct to me.

Yep, could you please explain what benefits you see in keeping FIFO
order?

> 
> Acked-by: Rik van Riel <riel@redhat.com>
> 
> > - simpler check_restart logic.
> > - Efficient handling of wait-for-zero semops, both simple and complex.
> > - Fewer restarts in update_queue(), because pending wait-for-zero do not
> >    force a restart anymore.
> >
> > Other changes:
> > - try_atomic_semop() also performs the semop. Thus rename the function.
> >
> > It passes tests with qemu, but not boot-tested due to EFI problems.

I think this still needs a *lot* of testing - I don't have my Oracle
workload available right now, but I will definitely see how this patch
behaves on it. That said, I believe Oracle is are already quite happy
with the sem improvements.

Furthermore, this patch is way too invasive for considering it for 3.10
- I like Rik's patch better because it simply addresses the issue and
nothing more.

Thanks,
Davidlohr

