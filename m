Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3I3TQ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 15:16:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755272Ab3I3TQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 15:16:57 -0400
Date: Mon, 30 Sep 2013 21:16:00 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, Waiman Long <Waiman.Long@hp.com>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        Alex Shi <alex.shi@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Matthew R Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Michel Lespinasse <walken@google.com>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Haggai Eran <haggaie@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH] anon_vmas: Convert the rwsem to an rwlock_t
Message-ID: <20130930191600.GL29230@redhat.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
 <20130928074144.GA17773@gmail.com>
 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
 <20130928192123.GA8228@gmail.com>
 <20130928193739.GA8642@gmail.com>
 <20130930085243.GA25685@redhat.com>
 <CA+55aFxG3hK0CiZJh1XORv+tiNWXVxh8rzr37Vmu=ASWj1s4PQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxG3hK0CiZJh1XORv+tiNWXVxh8rzr37Vmu=ASWj1s4PQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 09:26:21AM -0700, Linus Torvalds wrote:
> On Mon, Sep 30, 2013 at 1:52 AM, Andrea Arcangeli <aarcange@redhat.com> wrote:
> >
> > Sorry having to break the party but the sleepable locks for anon_vma
> > and i_mmap_mutex are now requirement for the "pageable RDMA" effort
> > recently achieved upstream by mellanox with the MMU notifier.
> 
> I'll happily break that.

Unless a solution is found that could allow to invalidate secondary
MMUs with a spinlock/rwlock for anon_vma->lock/i_mmap_lock, would it
be acceptable to switch between spinlock/rwlock mutex/rwsem through a
config option? option CONFIG_SLEEPABLE_RMAP, implicitly selected by
CONFIG_SLEEPABLE_MMU_NOTIFIER, in turn selected by the RDMA and nvidia
drivers if they're built (ideally nvidia drivers will figure out how
to avoid scheduling).

I mean it only requires a wrapping header file, aside from the header
file it wouldn't be a much bigger patch than the one posted already.

It would be much easier to switch between spinning and sleeping locks
to keep benchmarking different scenarios too.
