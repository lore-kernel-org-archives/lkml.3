Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293Ab3AXKBn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:01:43 -0500
Received: from mail-ea0-f176.google.com ([209.85.215.176]:36817 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab3AXKBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:01:40 -0500
Date: Thu, 24 Jan 2013 11:01:34 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v2 2/6] sched: split out css_online/css_offline from tg
 creation/destruction
Message-ID: <20130124100134.GC26351@gmail.com>
References: <5100D4FE.9080205@huawei.com>
 <5100D518.8000103@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5100D518.8000103@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Li Zefan <lizefan@huawei.com> wrote:

> This is a preparaton for later patches.
> 
> - What do we gain from cpu_cgroup_css_online():
> 
> After ss->css_alloc() and before ss->css_online(), there's a small
> window that tg->css.cgroup is NULL. With this change, tg won't be seen
> before ss->css_online(), where it's added to the global list, so we're
> guaranteed we'll never see NULL tg->css.cgroup.
> 
> - What do we gain from cpu_cgroup_css_offline():
> 
> tg is freed via RCU, so is cgroup. Without this change, This is how
> synchronization works:
> 
> cgroup_rmdir()
>   no ss->css_offline()
> diput()
>   syncornize_rcu()
>   ss->css_free()       <-- unregister tg, and free it via call_rcu()
>   kfree_rcu(cgroup)    <-- wait possible refs to cgroup, and free cgroup
> 
> We can't just kfree(cgroup), because tg might access tg->css.cgroup.
> 
> With this change:
> 
> cgroup_rmdir()
>   ss->css_offline()    <-- unregister tg
> diput()
>   synchronize_rcu()    <-- wait possible refs to tg and cgroup
>   ss->css_free()       <-- free tg
>   kfree_rcu(cgroup)    <-- free cgroup
> 
> As you see, kfree_rcu() is redundant now.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
