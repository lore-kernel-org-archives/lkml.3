Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456Ab3I0T2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:28:19 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:47777 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753618Ab3I0T2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:28:16 -0400
MIME-Version: 1.0
In-Reply-To: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
Date: Fri, 27 Sep 2013 12:28:15 -0700
X-Google-Sender-Auth: DBKK_92H1qvmMvA4CtVAhwILoio
Message-ID: <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
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

On Fri, Sep 27, 2013 at 12:00 PM, Waiman Long <Waiman.Long@hp.com> wrote:
>
> On a large NUMA machine, it is entirely possible that a fairly large
> number of threads are queuing up in the ticket spinlock queue to do
> the wakeup operation. In fact, only one will be needed.  This patch
> tries to reduce spinlock contention by doing just that.
>
> A new wakeup field is added to the rwsem structure. This field is
> set on entry to rwsem_wake() and __rwsem_do_wake() to mark that a
> thread is pending to do the wakeup call. It is cleared on exit from
> those functions.

Ok, this is *much* simpler than adding the new MCS spinlock, so I'm
wondering what the performance difference between the two are.

I'm obviously always in favor of just removing lock contention over
trying to improve the lock scalability, so I really like Waiman's
approach over Tim's new MCS lock. Not because I dislike MCS locks in
general (or you, Tim ;), it's really more fundamental: I just
fundamentally believe more in trying to avoid lock contention than in
trying to improve lock behavior when that contention happens.

As such, I love exactly these kinds of things that Wainman's patch
does, and I'm heavily biased.

But I know I'm heavily biased, so I'd really like to get comparative
numbers for these things. Waiman, can you compare your patch with
Tim's (and Alex's) 6-patch series to make the rwsem's use MCS locks
for the spinlock?

The numbers Tim quotes for the MCS patch series ("high_systime (+7%)")
are lower than the ones you quote (16-20%), but that may be due to
hardware platform differences and just methodology. Tim was also
looking at exim performance.

So Tim/Waiman, mind comparing the two approaches on the setups you have?

                   Linus
