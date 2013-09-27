Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab3I0Tjd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:39:33 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:33640 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661Ab3I0Tjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:39:31 -0400
Message-ID: <1380310766.2222.10.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Davidlohr Bueso <davidlohr@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
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
Date: Fri, 27 Sep 2013 12:39:26 -0700
In-Reply-To: <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 12:28 -0700, Linus Torvalds wrote:
> On Fri, Sep 27, 2013 at 12:00 PM, Waiman Long <Waiman.Long@hp.com> wrote:
> >
> > On a large NUMA machine, it is entirely possible that a fairly large
> > number of threads are queuing up in the ticket spinlock queue to do
> > the wakeup operation. In fact, only one will be needed.  This patch
> > tries to reduce spinlock contention by doing just that.
> >
> > A new wakeup field is added to the rwsem structure. This field is
> > set on entry to rwsem_wake() and __rwsem_do_wake() to mark that a
> > thread is pending to do the wakeup call. It is cleared on exit from
> > those functions.
> 
> Ok, this is *much* simpler than adding the new MCS spinlock, so I'm
> wondering what the performance difference between the two are.

Both approaches should be complementary. The idea of optimistic spinning
in rwsems is to avoid putting putting the writer on the wait queue -
reducing contention and giving a greater chance for the rwsem
to get acquired. Waiman's approach is once the blocking actually occurs,
and at this point I'm not sure how this will affect writer stealing
logic.

Thanks,
Davidlohr



