Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752851Ab3AWCfp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 21:35:45 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:61170 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579Ab3AWCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 21:35:44 -0500
Message-ID: <50FF4C4D.4020405@huawei.com>
Date: Wed, 23 Jan 2013 10:34:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] cgroup: initialize cgrp->dentry before css_alloc()
References: <50F7B040.2020906@huawei.com> <20130123002754.GB5359@htj.dyndns.org>
In-Reply-To: <20130123002754.GB5359@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/1/23 8:27, Tejun Heo wrote:
> (cc'ing Andrew as scheduler folks are difficult to get response from
>  these days and I can't think of anyone else to bother :)
> 
> Hello, Li.
> 
> The cgroup part looks good to me but it would be great if the
> descriptions are more detailed, especially, about why the change is
> beneficial or what it's aiming at.  I take it that the shed changes
> are necessary to facilitate the later cgroup changes?  Can you please
> elaborate how?
> 

Scheduler changes made in patch #2 are preparation for #3 and #4.

- for #3:

After ss->css_alloc(), there's a small window that tg->css.cgroup is NULL.
With the change, tg won't be seen before ss->css_online(), so the scheduler
won't see NULL tg->css.cgroup.

- for #4:

If tg is unregistered and removed from global list in css_free(), and if
we kfree cgroup right after ss->css_free(), the scheduler can access
invalid tg->css.cgroup, because tg is also protected by RCU.

Without patch #2:

cgroup_rmdir()
  no ss->css_offline()
diput()
  syncronize_rcu()
  ss->css_free()    <-- remove tg from global list,
			and free tg via call_rcu()
  kfree_rcu(cgroup) <-- wait rcu read section

With the change:

cgroup_rmdir()
  ss->css_offline() <-- remove tg from global list
diput()
  synchronize_rcu() <-- wait rcu read section
  ss->css_free();   <-- free tg
  kfree(cgroup);

> The scheduler part of changes are mostly mechanical, so it would be
> great if we can get ack from scheduler people and route these together.
> 
> Thanks.
> 

