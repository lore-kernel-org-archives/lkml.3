Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3I0VtY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 17:49:24 -0400
Received: from mga02.intel.com ([134.134.136.20]:10910 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753835Ab3I0VtW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 17:49:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,996,1371106800"; 
   d="scan'208";a="410633569"
Subject: Re: [PATCH] rwsem: reduce spinlock contention in wakeup code path
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Waiman Long <Waiman.Long@hp.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
In-Reply-To: <1380310766.2222.10.camel@buesod1.americas.hpqcorp.net>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	 <1380310766.2222.10.camel@buesod1.americas.hpqcorp.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Sep 2013 14:49:18 -0700
Message-ID: <1380318558.3467.159.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-09-27 at 12:39 -0700, Davidlohr Bueso wrote:
> On Fri, 2013-09-27 at 12:28 -0700, Linus Torvalds wrote:
> > On Fri, Sep 27, 2013 at 12:00 PM, Waiman Long <Waiman.Long@hp.com> wrote:
> > >
> > > On a large NUMA machine, it is entirely possible that a fairly large
> > > number of threads are queuing up in the ticket spinlock queue to do
> > > the wakeup operation. In fact, only one will be needed.  This patch
> > > tries to reduce spinlock contention by doing just that.
> > >
> > > A new wakeup field is added to the rwsem structure. This field is
> > > set on entry to rwsem_wake() and __rwsem_do_wake() to mark that a
> > > thread is pending to do the wakeup call. It is cleared on exit from
> > > those functions.
> > 
> > Ok, this is *much* simpler than adding the new MCS spinlock, so I'm
> > wondering what the performance difference between the two are.
> 
> Both approaches should be complementary. The idea of optimistic spinning
> in rwsems is to avoid putting putting the writer on the wait queue -
> reducing contention and giving a greater chance for the rwsem
> to get acquired. Waiman's approach is once the blocking actually occurs,
> and at this point I'm not sure how this will affect writer stealing
> logic.
> 

I agree with the view that the two approaches are complementary 
to each other.  They address different bottleneck areas in the
rwsem. Here're the performance numbers for exim workload 
compared to a vanilla kernel.

Waimain's patch:        +2.0%
Alex+Tim's patchset:    +4.8%
Waiman+Alex+Tim:	+5.3%

Tim

