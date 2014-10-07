Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718AbaJGMbj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 08:31:39 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53609 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753152AbaJGMbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 08:31:36 -0400
Date: Tue, 7 Oct 2014 14:31:09 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@arm.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "juri.lelli@gmail.com" <juri.lelli@gmail.com>,
        "raistlin@linux.it" <raistlin@linux.it>,
        "michael@amarulasolutions.com" <michael@amarulasolutions.com>,
        "fchecconi@gmail.com" <fchecconi@gmail.com>,
        "daniel.wagner@bmw-carit.de" <daniel.wagner@bmw-carit.de>,
        "vincent@legout.info" <vincent@legout.info>,
        "luca.abeni@unitn.it" <luca.abeni@unitn.it>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when
 migrating tasks between exclusive cpusets
Message-ID: <20141007123109.GG19379@twins.programming.kicks-ass.net>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
 <1411118561-26323-3-git-send-email-juri.lelli@arm.com>
 <20140919212547.GG2832@worktop.localdomain>
 <5433AB8A.7050908@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5433AB8A.7050908@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 09:59:54AM +0100, Juri Lelli wrote:
> Hi Peter,
> 
> On 19/09/14 22:25, Peter Zijlstra wrote:
> > On Fri, Sep 19, 2014 at 10:22:40AM +0100, Juri Lelli wrote:
> >> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
> >> affinity (performing what is commonly called clustered scheduling).
> >> Unfortunately, such thing is currently broken for two reasons:
> >>
> >>  - No check is performed when the user tries to attach a task to
> >>    an exlusive cpuset (recall that exclusive cpusets have an
> >>    associated maximum allowed bandwidth).
> >>
> >>  - Bandwidths of source and destination cpusets are not correctly
> >>    updated after a task is migrated between them.
> >>
> >> This patch fixes both things at once, as they are opposite faces
> >> of the same coin.
> >>
> >> The check is performed in cpuset_can_attach(), as there aren't any
> >> points of failure after that function. The updated is split in two
> >> halves. We first reserve bandwidth in the destination cpuset, after
> >> we pass the check in cpuset_can_attach(). And we then release
> >> bandwidth from the source cpuset when the task's affinity is
> >> actually changed. Even if there can be time windows when sched_setattr()
> >> may erroneously fail in the source cpuset, we are fine with it, as
> >> we can't perfom an atomic update of both cpusets at once.
> > 
> > The thing I cannot find is if we correctly deal with updates to the
> > cpuset. Say we first setup 2 (exclusive) sets A:cpu0 B:cpu1-3. Then
> > assign tasks and then update the cpu masks like: B:cpu2,3, A:cpu1,2.
> > 
> 
> So, what follows should address the problem you describe.
> 
> Assuming you intended that we try to update masks as A:cpu0,3 and
> B:cpu1,2, with what below we are able to check that removing cpu3
> from B doesn't break guarantees. After that cpu3 can be put in A.
> 
> Does it make any sense?

Yeah, I think that about covers is. Could you write a changelog with it?

The reason I hadn't applied your patch #2 yet is because I thought it
triggered the splat reported in this thread. But later emails seem to
suggest this is a separate/pre-existing issue?


