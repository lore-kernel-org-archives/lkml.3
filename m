Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751551AbaIQF3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 01:29:46 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:36004 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaIQF3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 01:29:45 -0400
Message-ID: <54191C41.3080003@huawei.com>
Date: Wed, 17 Sep 2014 13:29:37 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>
Subject: Re: Kernel crash in cgroup_pidlist_destroy_work_fn()
References: <CAM_iQpVNzx1r8x-bP5CoiCX8PFk15JYHw_XfpYvJGgdkFHj8Gw@mail.gmail.com>
In-Reply-To: <CAM_iQpVNzx1r8x-bP5CoiCX8PFk15JYHw_XfpYvJGgdkFHj8Gw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/17 7:56, Cong Wang wrote:
> Hi, Tejun
> 
> 
> We saw some kernel null pointer dereference in
> cgroup_pidlist_destroy_work_fn(), more precisely at
> __mutex_lock_slowpath(), on 3.14. I can show you the full stack trace
> on request.
> 

Yes, please.

> Looking at the code, it seems flush_workqueue() doesn't care about new
> incoming works, it only processes currently pending ones, if this is
> correct, then we could have the following race condition:
> 
> cgroup_pidlist_destroy_all():
>         //...
>         mutex_lock(&cgrp->pidlist_mutex);
>         list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
>                 mod_delayed_work(cgroup_pidlist_destroy_wq,
> &l->destroy_dwork, 0);
>         mutex_unlock(&cgrp->pidlist_mutex);
> 
>         // <--- another process calls cgroup_pidlist_start() here
> since mutex is released
> 
>         flush_workqueue(cgroup_pidlist_destroy_wq); // <--- another
> process adds new pidlist and queue work in pararell
>         BUG_ON(!list_empty(&cgrp->pidlists)); // <--- This check is
> passed, list_add() could happen after this
> 

Did you confirm this is what happened when the bug was triggered?

I don't think the race condition you described exists. In 3.14 kernel,
cgroup_diput() won't be called if there is any thread running
cgroup_pidlist_start(). This is guaranteed by vfs.

But newer kernels are different. Looks like the bug exists in those
kernels.

> 
> Therefore, the newly added pidlist will point to a freed cgroup, and
> when it is freed in the delayed work we will crash.
> 
> The attached patch (compile test ONLY) could be a possible fix, since
> it will check and hold a refcount on this cgroup in
> cgroup_pidlist_start(). But I could very easily miss something here
> since there are many cgroup changes after 3.14 and I don't follow
> cgroup development.
> 
> What do you think?
> 

