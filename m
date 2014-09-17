Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaIQJ0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 05:26:18 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:48890 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754244AbaIQJ0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 05:26:15 -0400
Message-ID: <541953AF.7000201@huawei.com>
Date: Wed, 17 Sep 2014 17:26:07 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Cong Wang <xiyou.wangcong@gmail.com>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>
Subject: Re: Kernel crash in cgroup_pidlist_destroy_work_fn()
References: <CAM_iQpVNzx1r8x-bP5CoiCX8PFk15JYHw_XfpYvJGgdkFHj8Gw@mail.gmail.com> <54191C41.3080003@huawei.com>
In-Reply-To: <54191C41.3080003@huawei.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020209.541953B5.0028,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 7409216bdbd3d5d6309c132121ba567c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/17 13:29, Li Zefan wrote:
> On 2014/9/17 7:56, Cong Wang wrote:
>> Hi, Tejun
>>
>>
>> We saw some kernel null pointer dereference in
>> cgroup_pidlist_destroy_work_fn(), more precisely at
>> __mutex_lock_slowpath(), on 3.14. I can show you the full stack trace
>> on request.
>>
> 
> Yes, please.
> 
>> Looking at the code, it seems flush_workqueue() doesn't care about new
>> incoming works, it only processes currently pending ones, if this is
>> correct, then we could have the following race condition:
>>
>> cgroup_pidlist_destroy_all():
>>         //...
>>         mutex_lock(&cgrp->pidlist_mutex);
>>         list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
>>                 mod_delayed_work(cgroup_pidlist_destroy_wq,
>> &l->destroy_dwork, 0);
>>         mutex_unlock(&cgrp->pidlist_mutex);
>>
>>         // <--- another process calls cgroup_pidlist_start() here
>> since mutex is released
>>
>>         flush_workqueue(cgroup_pidlist_destroy_wq); // <--- another
>> process adds new pidlist and queue work in pararell
>>         BUG_ON(!list_empty(&cgrp->pidlists)); // <--- This check is
>> passed, list_add() could happen after this
>>
> 
> Did you confirm this is what happened when the bug was triggered?
> 
> I don't think the race condition you described exists. In 3.14 kernel,
> cgroup_diput() won't be called if there is any thread running
> cgroup_pidlist_start(). This is guaranteed by vfs.
> 
> But newer kernels are different. Looks like the bug exists in those
> kernels.
> 

Newer kernels should be also fine.

If cgroup_pidlist_destroy_all() is called, it means kernfs has already
removed the tasks file, and even if you still have it opened, when
you try to read it, it will immediately return an errno.

                                fd = open(cgrp/tasks)
cgroup_rmdir(cgrp)
  cgroup_destroy_locked(c)
    kernfs_remove()
  ...
css_free_work_fn()
  cgroup_pidlist_destroy_all()
                               read(fd of cgrp/tasks)
                                 return -ENODEV

So cgroup_pidlist_destroy_all() won't race with cgroup_pidlist_start().

