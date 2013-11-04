Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192Ab3KDD7G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 22:59:06 -0500
Received: from mga14.intel.com ([143.182.124.37]:58134 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab3KDD7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 22:59:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="316547097"
Date: Mon, 4 Nov 2013 11:59:20 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Ingo Molnar <mingo@kernel.org>, Tim Chen <tim.c.chen@linux.intel.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michel Lespinasse <walken@google.com>
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
Message-ID: <20131104035920.GH30123@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101080135.GB25547@gmail.com>
 <20131101081159.GB12829@yliu-dev.sh.intel.com>
 <20131101082146.GA27021@gmail.com>
 <20131101101643.GC30123@yliu-dev.sh.intel.com>
 <1383362113.2444.5.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383362113.2444.5.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 01, 2013 at 08:15:13PM -0700, Davidlohr Bueso wrote:
> On Fri, 2013-11-01 at 18:16 +0800, Yuanhan Liu wrote:
> > On Fri, Nov 01, 2013 at 09:21:46AM +0100, Ingo Molnar wrote:
> > > 
> > > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > > 
> > > > > Btw., another _really_ interesting comparison would be against 
> > > > > the latest rwsem patches. Mind doing such a comparison?
> > > > 
> > > > Sure. Where can I get it? Are they on some git tree?
> > > 
> > > I've Cc:-ed Tim Chen who might be able to point you to the latest 
> > > version.
> > > 
> > > The last on-lkml submission was in this thread:
> > > 
> > >   Subject: [PATCH v8 0/9] rwsem performance optimizations
> > > 
> > 
> > Thanks.
> > 
> > I queued bunchs of tests about one hour ago, and already got some
> > results(If necessary, I can add more data tomorrow when those tests are
> > finished):
> 
> What kind of system are you using to run these workloads on?

I queued jobs on 5 testboxes:
  - brickland1: 120 core Ivybridge server
  - lkp-ib03:   48 core Ivybridge server
  - lkp-sb03:   32 core Sandybridge server
  - lkp-nex04:  64 core NHM server
  - lkp-a04:    Atom server
> 
> > 
> > 
> >                v3.12-rc7      fe001e3de090e179f95d  
> > ------------------------  ------------------------  
> >                                 -9.3%               brickland1/micro/aim7/shared
> >                                 +4.3%               lkp-ib03/micro/aim7/fork_test
> >                                 +2.2%               lkp-ib03/micro/aim7/shared
> >                                 -2.6%               TOTAL aim7.2000.jobs-per-min
> > 
> 
> Sorry if I'm missing something, but could you elaborate more on what
> these percentages represent?

               v3.12-rc7      fe001e3de090e179f95d  
------------------------  ------------------------  
                                -9.3%               brickland1/micro/aim7/shared
....
....
                                -2.6%               TOTAL aim7.2000.jobs-per-min

The comparation base is v3.12-rc7, and we got 9.3 performance regression
at commit fe001e3de090e179f95d, which is the head of rwsem performance
optimizations patch set.

"brickland1/micro/aim7/shared" tells the testbox(brickland1) and testcase:
shared workfile of aim7.

The last line tell what field we are comparing, and it's
"aim7.2000.jobs-per-min" in this case. 2000 means 2000 users in aim7.

> Are they anon vma rwsem + optimistic
> spinning patches vs anon vma rwlock?

I tested "[PATCH v8 0/9] rwsem performance optimizations" only.

> 
> Also, I see your running aim7, you might be interested in some of the
> results I found when trying out Ingo's rwlock conversion patch on a
> largish 80 core system: https://lkml.org/lkml/2013/9/29/280

Besides aim7, I also tested dbench, hackbench, netperf, pigz. And as you
can image and see from the data, aim7 benifit most from the anon_vma
optimization stuff due to high contention of anon_vma lock.

Thanks.

	--yliu

