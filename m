Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590Ab3I2XGi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:06:38 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3773 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3I2XGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:06:36 -0400
Message-ID: <1380495986.2174.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Date: Sun, 29 Sep 2013 16:06:26 -0700
In-Reply-To: <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	 <20130928074144.GA17773@gmail.com>
	 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-28 at 11:55 -0700, Linus Torvalds wrote:
> On Sat, Sep 28, 2013 at 12:41 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> >
> > Yeah, I fully agree. The reason I'm still very sympathetic to Tim's
> > efforts is that they address a regression caused by a mechanic
> > mutex->rwsem conversion:
> >
> >   5a505085f043 mm/rmap: Convert the struct anon_vma::mutex to an rwsem
> >
> > ... and Tim's patches turn that regression into an actual speedup.
> 
> Btw, I really hate that thing. I think we should turn it back into a
> spinlock. None of what it protects needs a mutex or an rwsem.

The same should apply to i_mmap_mutex, having a similar responsibility
to the anon-vma lock with file backed pages. A few months ago I had
suggested changing that lock to rwsem, giving some pretty reasonable
performance improvement numbers.

http://lwn.net/Articles/556342/

> 
> Because you guys talk about the regression of turning it into a rwsem,
> but nobody talks about the *original* regression.
> 
> And it *used* to be a spinlock, and it was changed into a mutex back
> in 2011 by commit 2b575eb64f7a. That commit doesn't even have a reason
> listed for it, although my dim memory of it is that the reason was
> preemption latency.
> 
> And that caused big regressions too.

After testing Ingo's anon-vma rwlock_t conversion (v2) on a 8 socket, 80
core system with aim7, I am quite surprised about the numbers -
considering the lack of queuing in rwlocks. A lot of the tests didn't
show hardly any difference, but those that really contend this lock
(with high amounts of users) benefited quite nicely:

Alltests: +28% throughput after 1000 users and runtime was reduced from
7.2 to 6.6 secs.

Custom: +61% throughput after 100 users and runtime was reduced from 7
to 4.9 secs.

High_systime: +40% throughput after 1000 users and runtime was reduced
from 19 to 15.5 secs.

Shared: +30.5% throughput after 100 users and runtime was reduced from
6.5 to 5.1 secs.

Short: Lots of variance in the numbers, but avg of +29% throughput - no
particular performance degradation either.

The only workload that took a hit was fserver with a -6% throughput for
small amounts of users (10-100).

Theoretically at least, adding queuing to the rwlocks should only help
the situation furthermore. I'll also run some test for a similar
conversion for the i_mmap mutex next week.

Going back to the rwsems, I believe adding optimistic spinning is still
valid, independent of the anon-vma lock as it benefits all users.

Thanks,
Davidlohr

