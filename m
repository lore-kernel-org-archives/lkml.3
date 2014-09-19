Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388AbaISV0A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:26:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:43475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbaISVZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:25:58 -0400
Date: Fri, 19 Sep 2014 23:25:47 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Juri Lelli <juri.lelli@arm.com>
Cc: mingo@redhat.com, juri.lelli@gmail.com, raistlin@linux.it,
        michael@amarulasolutions.com, fchecconi@gmail.com,
        daniel.wagner@bmw-carit.de, vincent@legout.info, luca.abeni@unitn.it,
        linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>,
        cgroups@vger.kernel.org
Subject: Re: [PATCH 2/3] sched/deadline: fix bandwidth check/update when
 migrating tasks between exclusive cpusets
Message-ID: <20140919212547.GG2832@worktop.localdomain>
References: <1411118561-26323-1-git-send-email-juri.lelli@arm.com>
 <1411118561-26323-3-git-send-email-juri.lelli@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411118561-26323-3-git-send-email-juri.lelli@arm.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 10:22:40AM +0100, Juri Lelli wrote:
> Exclusive cpusets are the only way users can restrict SCHED_DEADLINE tasks
> affinity (performing what is commonly called clustered scheduling).
> Unfortunately, such thing is currently broken for two reasons:
> 
>  - No check is performed when the user tries to attach a task to
>    an exlusive cpuset (recall that exclusive cpusets have an
>    associated maximum allowed bandwidth).
> 
>  - Bandwidths of source and destination cpusets are not correctly
>    updated after a task is migrated between them.
> 
> This patch fixes both things at once, as they are opposite faces
> of the same coin.
> 
> The check is performed in cpuset_can_attach(), as there aren't any
> points of failure after that function. The updated is split in two
> halves. We first reserve bandwidth in the destination cpuset, after
> we pass the check in cpuset_can_attach(). And we then release
> bandwidth from the source cpuset when the task's affinity is
> actually changed. Even if there can be time windows when sched_setattr()
> may erroneously fail in the source cpuset, we are fine with it, as
> we can't perfom an atomic update of both cpusets at once.

The thing I cannot find is if we correctly deal with updates to the
cpuset. Say we first setup 2 (exclusive) sets A:cpu0 B:cpu1-3. Then
assign tasks and then update the cpu masks like: B:cpu2,3, A:cpu1,2.


