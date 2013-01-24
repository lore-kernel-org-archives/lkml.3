Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3AXSTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 13:19:42 -0500
Received: from mail-qa0-f53.google.com ([209.85.216.53]:53498 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab3AXSTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 13:19:37 -0500
Date: Thu, 24 Jan 2013 10:19:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] cgroup: fix exit() vsrmdir() race
Message-ID: <20130124181923.GK2373@mtj.dyndns.org>
References: <5100D810.5020406@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5100D810.5020406@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 02:43:28PM +0800, Li Zefan wrote:
> In cgroup_exit() put_css_set_taskexit() is called without any lock,
> which might lead to accessing a freed cgroup:
> 
> thread1                           thread2
> ---------------------------------------------
> exit()
>   cgroup_exit()
>     put_css_set_taskexit()
>       atomic_dec(cgrp->count);
>                                    rmdir();
>       /* not safe !! */
>       check_for_release(cgrp);
> 
> rcu_read_lock() can be used to make sure the cgroup is alive.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applying to cgroup/for-3.8-fixes w/ stable cc'd.

* Can you please add WARN_ON_ONCE(!rcu_read_lock_held()) in
  check_for_release()?

* cgroup_release_agent() seems broken too.  It's accessing cgrp after
  removing it from release_list.  Can you please fix it too?

Thanks.

-- 
tejun
