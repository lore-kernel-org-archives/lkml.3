Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743Ab3KEOnk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 09:43:40 -0500
Received: from mga14.intel.com ([143.182.124.37]:42683 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab3KEOnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 09:43:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,640,1378882800"; 
   d="scan'208";a="422597165"
Date: Tue, 5 Nov 2013 22:43:43 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Davidlohr Bueso <davidlohr@hp.com>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] per anon_vma lock and turn anon_vma rwsem lock to
 rwlock_t
Message-ID: <20131105144343.GD8860@yliu-dev.sh.intel.com>
References: <1383292467-28922-1-git-send-email-yuanhan.liu@linux.intel.com>
 <20131101080135.GB25547@gmail.com>
 <20131101081159.GB12829@yliu-dev.sh.intel.com>
 <20131101082146.GA27021@gmail.com>
 <20131101101643.GC30123@yliu-dev.sh.intel.com>
 <1383362113.2444.5.camel@buesod1.americas.hpqcorp.net>
 <20131104035920.GH30123@yliu-dev.sh.intel.com>
 <1383615840.11046.265.camel@schen9-DESK>
 <20131105031043.GI30123@yliu-dev.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131105031043.GI30123@yliu-dev.sh.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 05, 2013 at 11:10:43AM +0800, Yuanhan Liu wrote:
> On Mon, Nov 04, 2013 at 05:44:00PM -0800, Tim Chen wrote:
> > On Mon, 2013-11-04 at 11:59 +0800, Yuanhan Liu wrote:
> > > On Fri, Nov 01, 2013 at 08:15:13PM -0700, Davidlohr Bueso wrote:
> > > > On Fri, 2013-11-01 at 18:16 +0800, Yuanhan Liu wrote:
> > > > > On Fri, Nov 01, 2013 at 09:21:46AM +0100, Ingo Molnar wrote:
> > > > > > 
> > > > > > * Yuanhan Liu <yuanhan.liu@linux.intel.com> wrote:
> > > > > > 
> > > > > > > > Btw., another _really_ interesting comparison would be against 
> > > > > > > > the latest rwsem patches. Mind doing such a comparison?
> > > > > > > 
> > > > > > > Sure. Where can I get it? Are they on some git tree?
> > > > > > 
> > > > > > I've Cc:-ed Tim Chen who might be able to point you to the latest 
> > > > > > version.
> > > > > > 
> > > > > > The last on-lkml submission was in this thread:
> > > > > > 
> > > > > >   Subject: [PATCH v8 0/9] rwsem performance optimizations
> > > > > > 
> > > > > 
> > > > > Thanks.
> > > > > 
> > > > > I queued bunchs of tests about one hour ago, and already got some
> > > > > results(If necessary, I can add more data tomorrow when those tests are
> > > > > finished):
> > > > 
> > > > What kind of system are you using to run these workloads on?
> > > 
> > > I queued jobs on 5 testboxes:
> > >   - brickland1: 120 core Ivybridge server
> > >   - lkp-ib03:   48 core Ivybridge server
> > >   - lkp-sb03:   32 core Sandybridge server
> > >   - lkp-nex04:  64 core NHM server
> > >   - lkp-a04:    Atom server
> > > > 
> > > > > 
> > > > > 
> > > > >                v3.12-rc7      fe001e3de090e179f95d  
> > > > > ------------------------  ------------------------  
> > > > >                                 -9.3%               brickland1/micro/aim7/shared
> > > > >                                 +4.3%               lkp-ib03/micro/aim7/fork_test
> > > > >                                 +2.2%               lkp-ib03/micro/aim7/shared
> > > > >                                 -2.6%               TOTAL aim7.2000.jobs-per-min
> > > > > 
> > > > 
> > > > Sorry if I'm missing something, but could you elaborate more on what
> > > > these percentages represent?
> > > 
> > >                v3.12-rc7      fe001e3de090e179f95d  
> > > ------------------------  ------------------------  
> > >                                 -9.3%               brickland1/micro/aim7/shared
> > > ....
> > > ....
> > >                                 -2.6%               TOTAL aim7.2000.jobs-per-min
> > > 
> > > The comparation base is v3.12-rc7, and we got 9.3 performance regression
> > > at commit fe001e3de090e179f95d, which is the head of rwsem performance
> > > optimizations patch set.
> > 
> > Yunahan, thanks for the data.  This I assume is with the entire rwsem
> > v8 patchset.
> 
> Yes, it is; 9 patches in total.
> 
> > Any idea of the run variation on the workload?
> 
> Your concern is right. The variation is quite big on the brickland1/micro/aim7/shared
> testcase.
> 
>    * - v3.12-rc7
>    O - fe001e3de090e179f95d
> 
>                  brickland1/micro/aim7/shared: aim7.2000.jobs-per-min
> 
>    320000 ++----------------------------------------------------------------+
>           |                                                                 |
>    310000 ++                              .*.........                       |
>           |                           ....           .......                |
>    300000 ++                      ....                      .......         |
>           |                    ...                                 ......   |
>    290000 ++               ....                                          ...|
>           |            ....                                                 *
>    280000 ++        ...                                                     |
>           |     ....                                                        |
>    270000 ++....                                                            |
>           *.                                                                O
>    260000 O+                                                                |
>           |                                O                                |
>    250000 ++----------------------------------------------------------------+
> 

Tim,

Please ignore this "regression", it disappears when I run that testcase
6 times both for v3.12-rc7 and fe001e3de090e179f95d.

I guess 2000 users is a bit small for 120 core IVB server. I may try to
increase the user count and do test again to see how it will behavior
with your patches applied.

Sorry for the inconvenience.

	--yliu

