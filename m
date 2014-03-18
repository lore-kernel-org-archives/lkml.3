Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752633AbaCRHuF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 03:50:05 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41611 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaCRHuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 03:50:03 -0400
Date: Tue, 18 Mar 2014 15:41:45 +0800
From: Shaohua Li <shli@kernel.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        agk@redhat.com
Subject: Re: [patch v3]DM: dm-insitu-comp: a compressed DM target for SSD
Message-ID: <20140318074145.GA14397@kernel.org>
References: <20140218101304.GA24889@kernel.org>
 <20140307075733.GB21790@kernel.org>
 <20140310135256.GA28665@redhat.com>
 <20140314094008.GA2386@kernel.org>
 <20140314224444.GA18027@redhat.com>
 <20140317095653.GA1014@kernel.org>
 <20140317200039.GC3269@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140317200039.GC3269@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 04:00:40PM -0400, Mike Snitzer wrote:
> On Mon, Mar 17 2014 at  5:56am -0400,
> Shaohua Li <shli@kernel.org> wrote:
> 
> > On Fri, Mar 14, 2014 at 06:44:45PM -0400, Mike Snitzer wrote:
> > > On Fri, Mar 14 2014 at  5:40am -0400,
> > > Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > On Mon, Mar 10, 2014 at 09:52:56AM -0400, Mike Snitzer wrote:
> > > > > On Fri, Mar 07 2014 at  2:57am -0500,
> > > > > Shaohua Li <shli@kernel.org> wrote:
> > > > > 
> > > > > > ping!
> > > > > 
> > > > > Hi,
> > > > > 
> > > > > I intend to get dm-insitu-comp reviewed for 3.15.  Sorry I haven't
> > > > > gotten back with you before now, been busy tending to 3.14-rc issues.
> > > > > 
> > > > > I took a quick first pass over your code a couple weeks ago.  Looks to
> > > > > be in great shape relative to coding conventions and the more DM
> > > > > specific conventions.  Clearly demonstrates you have a good command of
> > > > > DM concepts and quirks.
> > > 
> > > Think I need to eat my words from above at least partially.  Given you
> > > haven't implemented any of the target suspend or resume hooks this
> > > target will _not_ work properly across suspend + resume cycles that all
> > > DM targets must support.
> > > 
> > > But we can obviously work through it with urgency for 3.15.
> > > 
> > > I've pulled your v3 patch into git and have overlayed edits from my
> > > first pass.  Lots of funky wrapping to conform to 80 columns.  But
> > > whitespace aside, I've added FIXME:s in the relevant files.  If you work
> > > on any of these FIXMEs please send follow-up patches so that we don't
> > > step on each others' toes.
> > > 
> > > Please see the 'for-3.15-insitu-comp' branch of this git repo:
> > > git://git.kernel.org/pub/scm/linux/kernel/git/snitzer/linux.git
> > 
> > Thanks for your to look at it. I fixed them against your tree. Please check below patch.
> 
> I folded your changes in, and then committed a patch ontop that cleans
> some code up.  But added 2 FIXMEs that still speak to pretty fundamental
> problems with the architecture of the dm-insitu-comp target, see:
> https://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/commit/?h=for-3.15-insitu-comp&id=8565ab6b04837591d03c94851c2f9f9162ce12f4
> 
> Unfortunately the single insitu_comp_wq workqueue that all insitu-comp
> targets are to share isn't a workable solution.  Each target needs to
> have resource isolation from other targets (imagine insitu-comp used for
> multiple SSDs).  This is important for suspend too because you'll need
> to flush/stop the workqueue.

Is this just because of suspend? I didn't see fundamental reason why the
workqueue can't be shared even for several targets.
 
> You introduced a state machine for tracking suspending, suspended,
> resumed.  This really isn't necessary.  During suspend you need to
> flush_workqueue().  On resume you shouldn't need to do anything special.
> 
> As I noted in the commit, the thin and cache targets can serve as
> references for how you can manage the workqueue across suspend/resume
> and the lifetime of these workqueues relative to .ctr and .dtr.

As far as I checking the code, .postsuspend is called after all requests are
finished. This already guarantees no pending requests running in insitu-comp
workqueue. Doing a workqueue flush isn't required. The writeback thread is
running in background and waiting for requests completion can't guarantee the
thread isn't running, so we must make sure it is safely parked.

Thanks,
Shaohua
