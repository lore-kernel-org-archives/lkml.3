Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab3I2X0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 19:26:09 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:64702 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab3I2X0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 19:26:05 -0400
MIME-Version: 1.0
In-Reply-To: <1380495986.2174.10.camel@buesod1.americas.hpqcorp.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	<20130928074144.GA17773@gmail.com>
	<CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	<1380495986.2174.10.camel@buesod1.americas.hpqcorp.net>
Date: Sun, 29 Sep 2013 16:26:02 -0700
X-Google-Sender-Auth: zlz5alsHsvm6u1xhGDKAmpoUCRg
Message-ID: <CA+55aFx1PErQQ8eR6JgQzmM0RZwyUtyc6CFfnvzzKz2RJa2GFw@mail.gmail.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Davidlohr Bueso <davidlohr@hp.com>
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 29, 2013 at 4:06 PM, Davidlohr Bueso <davidlohr@hp.com> wrote:
>>
>> Btw, I really hate that thing. I think we should turn it back into a
>> spinlock. None of what it protects needs a mutex or an rwsem.
>
> The same should apply to i_mmap_mutex, having a similar responsibility
> to the anon-vma lock with file backed pages. A few months ago I had
> suggested changing that lock to rwsem, giving some pretty reasonable
> performance improvement numbers.
>
> http://lwn.net/Articles/556342/

Ok, that's pretty convincing too.

Side note: are you sure that the i_mmap_mutex needs to be a sleeping
lock at all? It's documented to nest outside the anon_vma->rwsem, so
as long as that is a sleeping lock, the i_mmap_mutex needs to be one
too, but looking at the actual users, most of them seem to be *very*
similar to the anon_vma->rwsem users. It is a very close cousin to the
anon_vma->rwsem, after all (just for file-backed pages rather than
anonymous ones). No?

I dunno. Maybe the ranges are too big and it really has latency
issues, the few I looked at looked like fairly trivial interval-tree
operations, though.

And your numbers for Ingo's patch:

> After testing Ingo's anon-vma rwlock_t conversion (v2) on a 8 socket, 80
> core system with aim7, I am quite surprised about the numbers -
> considering the lack of queuing in rwlocks. A lot of the tests didn't
> show hardly any difference, but those that really contend this lock
> (with high amounts of users) benefited quite nicely:
>
> Alltests: +28% throughput after 1000 users and runtime was reduced from
> 7.2 to 6.6 secs.
>
> Custom: +61% throughput after 100 users and runtime was reduced from 7
> to 4.9 secs.
>
> High_systime: +40% throughput after 1000 users and runtime was reduced
> from 19 to 15.5 secs.
>
> Shared: +30.5% throughput after 100 users and runtime was reduced from
> 6.5 to 5.1 secs.
>
> Short: Lots of variance in the numbers, but avg of +29% throughput - no
> particular performance degradation either.

Are just overwhelming, in my opinion. The conversion *from* a spinlock
never had this kind of support behind it.

Btw, did anybody run Ingo's patch with lockdep and the spinlock sleep
debugging code to verify that we haven't introduced any problems wrt
sleeping since the lock was converted into a rw-semaphore?

Because quite frankly, considering these kinds of numbers, I really
don't see how we could possibly make excuses for keeping that
rw-semaphore unless there is some absolutely _horrible_ latency issue?

            Linus
