Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485Ab3EGLCw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 07:02:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62995 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab3EGLCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 07:02:51 -0400
Message-ID: <5188DF27.4080000@huawei.com>
Date: Tue, 7 May 2013 19:01:59 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] kernel/cgroup.c: about kfree after 'get_new_cssid'
References: <5188DB93.2080504@asianux.com>
In-Reply-To: <5188DB93.2080504@asianux.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/7 18:46, Chen Gang wrote:
> Hello Maintainers:
> 
> After call get_new_cssid(), I can not find the related free function
> (it seems free_css_id() is for that, but not used).
> 
> The memory location is:
>   get_new_cssid() --> kzalloc() for 'struct css_id'
>   get_new_cssid() --> idr_alloc() for 'ss->idr'
> 
> One work flow:
>   cgroup_load_subsys() --> cgroup_init_idr() --> get_new_cssid()
>   when get_new_cssid() fails, it will:
>   cgroup_load_subsys() --> cgroup_unload_subsys() --> idr_destroy(),
>   and also:
>   cgroup_load_subsys() --> cgroup_unload_subsys() --> ss->css_free();
>     ('css_free' may 'debug_css_free', or 'freezer_css_free' ...)
> 
> It seems the work flow above is not 'kfree' 'struct css_id', is it true?
> 
> BTW: I also guess, for cgroup_init_idr() in cgroup_init(), need check
> the return value.
> 
> Please help check.
> 

It's the specific cgroup subsystem that calls free_css_id() in it's subsys->css_free()
callback. See __mem_cgroup_free() for example.

There's a bug in cgroup_unload_subsys() that idr_destroy() should be called after
ss->css_free(). That said, given there's no modular cgroup subsystem using css_id,
and the whole css_id thing will be eliminated in 3.11, why bother fixing it.

