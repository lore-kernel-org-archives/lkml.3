Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755776AbaGAUnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 16:43:31 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:53795 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755316AbaGAUn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 16:43:29 -0400
Date: Tue, 1 Jul 2014 16:43:26 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH cgroup/for-3.16-fixes] cpuset: break kernfs active
 protection in cpuset_write_resmask()
Message-ID: <20140701204326.GB12459@htj.dyndns.org>
References: <53B0DD8D.5060805@huawei.com>
 <20140630194732.GF14807@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140630194732.GF14807@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 03:47:32PM -0400, Tejun Heo wrote:
> Hey, Li.
> 
> Can you please test this patch and ack it?
> 
> Thanks.
> ------ 8< ------
> Writing to either "cpuset.cpus" or "cpuset.mems" file flushes
> cpuset_hotplug_work so that cpu or memory hotunplug doesn't end up
> migrating tasks off a cpuset after new resources are added to it.
> 
> As cpuset_hotplug_work calls into cgroup core via
> cgroup_transfer_tasks(), this flushing adds the dependency to cgroup
> core locking from cpuset_write_resmak().  This used to be okay because
> cgroup interface files were protected by a different mutex; however,
> 8353da1f91f1 ("cgroup: remove cgroup_tree_mutex") simplified the
> cgroup core locking and this dependency became a deadlock hazard -
> cgroup file removal performed under cgroup core lock tries to drain
> on-going file operation which is trying to flush cpuset_hotplug_work
> blocked on the same cgroup core lock.
> 
> The locking simplification was done because kernfs added an a lot
> easier way to deal with circular dependencies involving kernfs active
> protection.  Let's use the same strategy in cpuset and break active
> protection in cpuset_write_resmask().  While it isn't the prettiest,
> this is a very rare, likely unique, situation which also goes away on
> the unified hierarchy.
> 
> The commands to trigger the deadlock warning without the patch and the
> lockdep output follow.
...
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.16-fixes.

Thanks.

-- 
tejun
