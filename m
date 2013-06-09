Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3FIQD6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 12:03:58 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:44116 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab3FIQD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 12:03:56 -0400
Date: Sun, 9 Jun 2013 09:03:53 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH v3 0/7] cpuset: implement sane hierarchy behaviors
Message-ID: <20130609160353.GE2835@htj.dyndns.org>
References: <51B4475A.8030509@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B4475A.8030509@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Sun, Jun 09, 2013 at 05:14:02PM +0800, Li Zefan wrote:
> v2 -> v3:
> Currently some cpuset behaviors are not friendly when cpuset is co-mounted
> with other cgroup controllers.
> 
> Now with this patchset if cpuset is mounted with sane_behavior option, it
> behaves differently:
> 
> - Tasks will be kept in empty cpusets when hotplug happens and take masks
> of ancestors with non-empty cpus/mems, instead of being moved to an ancestor.
> 
> - A task can be moved into an empty cpuset, and again it takes masks of
> ancestors, so the user can drop a task into a newly created cgroup without
> having to do anything for it.

I applied 1-2 and the rest of the series also look correct to me and
seem like a step in the right direction; however, I'm not quite sure
this is the final interface we want.

* cpus/mems_allowed changing as CPUs go up and down is nasty.  There
  should be separation between the configured CPUs and currently
  available CPUs.  The current behavior makes sense when coupled with
  the irreversible task migration and all.  If we're allowing tasks to
  remain in empty cpusets, it only makes sense to retain and re-apply
  configuration as CPUs come back online.

  I find the original behavior of changing configurations as system
  state changes pretty weird especially because it's happening without
  any notification making it pretty difficult to use in any sort of
  automated way - anything which wants to wrap cpuset would have to
  track the configuration and CPU/nodes up/down states separately on
  its own, which is a very easy way to introduce incoherencies.

* validate_change() rejecting updates to config if any of its
  descendants are using some is weird.  The config change should be
  enforced in hierarchical manner too.  If the parent drops some CPUs,
  it should simply drop those CPUs from the children.  The same in the
  other direction, children having configs which aren't fully
  contained inside their parents is fine as long as the effective
  masks are correct.

  IOW, validate_change() doesn't really make sense if we're keeping
  tasks in empty cgroups.  As CPUs go down and up, we'd keep the
  organization but lose the configuration, which is just weird.

I think what we want is expanding on this patchset so that we have
separate "configured" and "effective" masks, which are preferably
exposed to userland and just let the config propagation deal with
computing the effective masks as CPUs/nodes go down/up and config
changes.  The code actually could be simpler that way although
there'll be complications due to the old behaviors.

What do you think?  If you agree, how should we proceed?  We can apply
these patches and build on top if you prefer.

Thanks.

-- 
tejun
