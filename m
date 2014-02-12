Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaBLBvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 20:51:33 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:52412 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbaBLBvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 20:51:31 -0500
Message-ID: <52FAD36F.7000500@huawei.com>
Date: Wed, 12 Feb 2014 09:50:39 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Michal Hocko <mhocko@suse.cz>
CC: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH] cgroup: protect modifications to cgroup_idr with cgroup_mutex
References: <52F9D9DA.7040108@huawei.com> <20140211102032.GA11946@dhcp22.suse.cz>
In-Reply-To: <20140211102032.GA11946@dhcp22.suse.cz>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/11 18:20, Michal Hocko wrote:
> Hi Li,
> good work in reproducing the issue so quickly!
> I have tried to backport this patch to 3.12 kernel but the code has
> changed since then.
> The only two instances of idr_remove which are called outside of
> cgroup_mutex seem to be:
>  - cgroup_create calling it from err_free_id: path
>  - css_free_work_fn
>      mem_cgroup_css_free
>        __mem_cgroup_free
>          free_css_id
> 
> The second one takes ss->id_lock spinlock which should be sufficient
> to exclude get_new_cssid but cgroup_mount and cgroup_create don't use
> id_lock. They do hold cgroup_mutex though. So I guess I need something
> like the following (I will have it tested):

I don't think you need to do anything with ss->idr.

cgroup_create() calls alloc_css_id() -> get_new_cssid(), and get_new_cssid()
uses id_lock.

cgroup_mount() won't touch ss->idr, because the css_id for root cgroup is
always 0.

