Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab3I3G5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 02:57:10 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51164 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3I3G5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 02:57:08 -0400
Date: Mon, 30 Sep 2013 08:57:03 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Waiman Long <Waiman.Long@hp.com>,
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
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
Message-ID: <20130930065703.GB13584@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <1380495986.2174.10.camel@buesod1.americas.hpqcorp.net>
 <CA+55aFx1PErQQ8eR6JgQzmM0RZwyUtyc6CFfnvzzKz2RJa2GFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFx1PErQQ8eR6JgQzmM0RZwyUtyc6CFfnvzzKz2RJa2GFw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> [...]
> 
> And your numbers for Ingo's patch:
> 
> > After testing Ingo's anon-vma rwlock_t conversion (v2) on a 8 socket, 
> > 80 core system with aim7, I am quite surprised about the numbers - 
> > considering the lack of queuing in rwlocks. A lot of the tests didn't 
> > show hardly any difference, but those that really contend this lock 
> > (with high amounts of users) benefited quite nicely:
> >
> > Alltests: +28% throughput after 1000 users and runtime was reduced from
> > 7.2 to 6.6 secs.
> >
> > Custom: +61% throughput after 100 users and runtime was reduced from 7
> > to 4.9 secs.
> >
> > High_systime: +40% throughput after 1000 users and runtime was reduced
> > from 19 to 15.5 secs.
> >
> > Shared: +30.5% throughput after 100 users and runtime was reduced from
> > 6.5 to 5.1 secs.
> >
> > Short: Lots of variance in the numbers, but avg of +29% throughput - 
> > no particular performance degradation either.
> 
> Are just overwhelming, in my opinion. The conversion *from* a spinlock 
> never had this kind of support behind it.

Agreed. Especially given how primitive rwlock_t is especially on 80 cores, 
this is really a no-brainer conversion.

I have to say I am surprised by the numbers - after so many years it's 
still amazing how powerful the "get work done and don't interrupt it" 
batching concept is in computing...

> Btw, did anybody run Ingo's patch with lockdep and the spinlock sleep 
> debugging code to verify that we haven't introduced any problems wrt 
> sleeping since the lock was converted into a rw-semaphore?
> 
> Because quite frankly, considering these kinds of numbers, I really 
> don't see how we could possibly make excuses for keeping that 
> rw-semaphore unless there is some absolutely _horrible_ latency issue?

Given that there's only about a dozen critical sections that this lock 
covers I simply cannot imagine any latency problem that couldn't be fixed 
in some other fashion. (shrinking the critical section, breaking up a bad 
loop, etc.)

[ Btw., if PREEMPT_RT goes upstream we might not even need to break
  latencies all that much: people whose usecase values scheduling latency
  above throughput would run such a critical section preemptible anyway. ]

Thanks,

	Ingo
