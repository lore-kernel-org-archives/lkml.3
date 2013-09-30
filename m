Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573Ab3I3RKt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 13:10:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:54943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab3I3RKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 13:10:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1009,1371106800"; 
   d="scan'208";a="385810698"
Subject: Re: [PATCH, v2] anon_vmas: Convert the rwsem to an rwlock_t
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Ingo Molnar <mingo@kernel.org>
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
In-Reply-To: <20130928195207.GA31245@gmail.com>
References: <1380308424-31011-1-git-send-email-Waiman.Long@hp.com>
	 <CA+55aFxXeQ69B1bfrO+0QtBqm0gt688LOshx=ppNjch10JF8FQ@mail.gmail.com>
	 <20130928074144.GA17773@gmail.com>
	 <CA+55aFyx-Lpqd8i2tHvhXCqL+nJZPq-6SikEkb-cQZEU9ogRjA@mail.gmail.com>
	 <20130928192123.GA8228@gmail.com> <20130928193739.GA8642@gmail.com>
	 <CA+55aFyMXxH-PGewqxse=VJzMdHWkyN4iKMh-VgQ1X2yJFnAgw@mail.gmail.com>
	 <20130928195207.GA31245@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Sep 2013 10:10:27 -0700
Message-ID: <1380561027.3467.196.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-28 at 21:52 +0200, Ingo Molnar wrote:
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > On Sat, Sep 28, 2013 at 12:37 PM, Ingo Molnar <mingo@kernel.org> wrote:
> > >
> > > -               down_write_nest_lock(&anon_vma->root->rwsem, &mm->mmap_sem);
> > > +               down_write_nest_lock(&anon_vma->root->rwlock, &mm->mmap_sem);
> > 
> > That's just completely bogus, and cannot work.
> > 
> > Maybe just a "write_lock(&anon_vma->root->rwlock)" (which is just
> > anon_vma_unlock_write(anon_vma)). But I think we might have a lockdep
> > issue. I'm not quite sure what's up with the nesting there.
> > 
> > > -       if (rwsem_is_locked(&anon_vma->root->rwsem)) {
> > > +       if (write_can_lock(&anon_vma->root->rwlock)) {
> > >                 anon_vma_lock_write(anon_vma);
> > >                 anon_vma_unlock_write(anon_vma);
> > >         }
> > 
> > That's the wrong way around. It should be
> > 
> >         if (!write_can_lock(&anon_vma->root->rwlock)) {
> > 
> > so some more testing definitely needed.
> 
> Yeah, that silly API asymmetry has bitten me before as well :-/
> 
> The attached version booted up fine under 16-way KVM:
> 
>  sh-4.2# uptime
>   19:50:08 up 0 min,  0 users,  load average: 0.00, 0.00, 0.00
> 
> That's all the testing it will get this evening though. Patch should be 
> good enough for Tim to try?


Here's the exim workload data:

rwsem improvment:
Waimain's patch:        +2.0%
Alex+Tim's patchset:    +4.8%
Waiman+Alex+Tim:        +5.3%

convert rwsem to rwlock_t for root anon_vma lock
Ingo's patch		+11.7%

Yes, changing the anon-vma root lock to rwlock_t gives the most boost.

However, I think that Waiman's patches, Alex's patches and my
patches can still be combined together to improve scalability of 
rwsem, even if we should decide to convert this particular rwsem to
rwlock_t.

Thanks.

Tim

> 
> Thanks,
> 
> 	Ingo
> 


