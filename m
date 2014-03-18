Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbaCRVcg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 17:32:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933560AbaCRV2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 17:28:48 -0400
Date: Tue, 18 Mar 2014 17:28:43 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Shaohua Li <shli@kernel.org>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [patch v3]DM: dm-insitu-comp: a compressed DM target for SSD
Message-ID: <20140318212842.GA10850@redhat.com>
References: <20140218101304.GA24889@kernel.org>
 <20140307075733.GB21790@kernel.org>
 <20140310135256.GA28665@redhat.com>
 <20140314094008.GA2386@kernel.org>
 <20140314224444.GA18027@redhat.com>
 <20140317095653.GA1014@kernel.org>
 <20140317200039.GC3269@redhat.com>
 <20140318074145.GA14397@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140318074145.GA14397@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18 2014 at  3:41am -0400,
Shaohua Li <shli@kernel.org> wrote:

> On Mon, Mar 17, 2014 at 04:00:40PM -0400, Mike Snitzer wrote:
> > 
> > I folded your changes in, and then committed a patch ontop that cleans
> > some code up.  But added 2 FIXMEs that still speak to pretty fundamental
> > problems with the architecture of the dm-insitu-comp target, see:
> > https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=for-3.15-insitu-comp&id=8565ab6b04837591d03c94851c2f9f9162ce12f4
> > 
> > Unfortunately the single insitu_comp_wq workqueue that all insitu-comp
> > targets are to share isn't a workable solution.  Each target needs to
> > have resource isolation from other targets (imagine insitu-comp used for
> > multiple SSDs).  This is important for suspend too because you'll need
> > to flush/stop the workqueue.
> 
> Is this just because of suspend? I didn't see fundamental reason why the
> workqueue can't be shared even for several targets.

I'm not seeing how you are guaranteeing that all queued work is
completed during suspend.  insitu_comp_queue_req() just calls
queue_work_on().

BTW, queue_work_on()'s comment above its implementation says:
"We queue the work to a specific CPU, the caller must ensure it can't go
away." -- you're not able to insure a cpu isn't hotplugged so... but I
also see you've used it in your raid5 perf improvement changes so you
obviously have experience with using this interface.

> > You introduced a state machine for tracking suspending, suspended,
> > resumed.  This really isn't necessary.  During suspend you need to
> > flush_workqueue().  On resume you shouldn't need to do anything special.
> > 
> > As I noted in the commit, the thin and cache targets can serve as
> > references for how you can manage the workqueue across suspend/resume
> > and the lifetime of these workqueues relative to .ctr and .dtr.
> 
> As far as I checking the code, .postsuspend is called after all requests are
> finished. This already guarantees no pending requests running in insitu-comp
> workqueue.

I could easily be missing something obvious, but I don't see where that
guarantee is implemented.

> Doing a workqueue flush isn't required. The writeback thread is
> running in background and waiting for requests completion can't guarantee the
> thread isn't running, so we must make sure it is safely parked.

Sure, but you don't need a state machine to do that.  The DM core takes
care of calling these hooks, so you just need to stop the writeback
thread during suspend and (re)start/kick it on resume (preresume).
