Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab3AWBCf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 20:02:35 -0500
Received: from mail-qc0-f182.google.com ([209.85.216.182]:57904 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861Ab3AWBCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 20:02:32 -0500
Date: Tue, 22 Jan 2013 17:02:26 -0800
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Colin Cross <ccross@google.com>, cgroups@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>
Subject: Re: [PATCH v5 00/11] per-cgroup cpu-stat
Message-ID: <20130123010226.GF5359@htj.dyndns.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
 <CAMbhsRQ7B4Uu1Wukfay+m4K7CVXtVbsTTEd6JHrwC2s+NcEFNA@mail.gmail.com>
 <50FD3123.6090003@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FD3123.6090003@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 21, 2013 at 04:14:27PM +0400, Glauber Costa wrote:
> > Android userspace is currently using both cpu and cpuacct, and not
> > co-mounting them.  They are used for fundamentally different uses such
> > that creating a single hierarchy for both of them while maintaining
> > the existing behavior is not possible.
> > 
> > We use the cpu cgroup primarily as a priority container.  A simple
> > view is that each thread is assigned to a foreground cgroup when it is
> > user-visible, and a background cgroup when it is not.  The foreground
> > cgroup is assigned a significantly higher cpu.shares value such that
> > when each group is fully loaded the background group will get 5% and
> > the foreground group will get 95%.
> > 
> > We use the cpuacct cgroup to measure cpu usage per uid, primarily to
> > estimate one cause of battery usage.  Each uid gets a cgroup, and when
> > spawning a task for a new uid we put it in the appropriate cgroup.
> 
> As we are all in a way sons of Linus the Great, the fact that you have
> this usecase should be by itself a reason for us not to deprecate it.
> 
> I still view this, however, as a not common use case. And from the
> scheduler PoV, we still have all the duplicate hierarchy walks. So
> assuming we would carry on all the changes in this patchset, except the
> deprecation, would it be okay for you?
> 
> This way we could take steps to make sure the scheduler codepaths for
> cpuacct are not taking during normal comounted operation, and you could
> still have your setup unchanged.
> 
> Tejun, any words here?

I think the only thing we can do is keeping cpuacct around.  We can
still optimize comounted cpu and cpuacct as the usual case.  That
said, I'd really like to avoid growing new use cases for separate
hierarchies for cpu and cpuacct (well, any controller actually).
Having multiple hierarchies is fundamentally broken in that we can't
say whether a given resource belongs to certain cgroup independently
from the current task, and we're definitnely moving towards unified
hierarchy.

We are not gonna break multiple hierarchies but won't go extra miles
to optimize or enable new features on it, so it would be best to move
away from it.

Maybe we can generate a warning message on separate mounts?

Thanks.

-- 
tejun
