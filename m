Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750756Ab3HSDqt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:46:49 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:43872 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3HSDqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:46:48 -0400
Message-ID: <52119517.5010206@huawei.com>
Date: Mon, 19 Aug 2013 11:46:31 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Ming Lei <ming.lei@canonical.com>
CC: Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: cgroup/next tree: reference to uninitialized percpu ref
References: <CACVXFVMV-A5FUU4VuXX0QvWP6jHDqu70QwRL53tJwVfxR589Pw@mail.gmail.com>
In-Reply-To: <CACVXFVMV-A5FUU4VuXX0QvWP6jHDqu70QwRL53tJwVfxR589Pw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/19 11:32, Ming Lei wrote:
> Hi,
> 
> The kernel oops[1] is triggered during kernel boot with the latest next
> tree(3.11.0-rc5-next-20130816), looks it is caused by reference to uninitialized
> percpu ref of root cgroup, and below patch can fix the problem:
> 

Thanks for the report. Li Zhong has summited a patch to fix it:

www.spinics.net/lists/linux-next/msg26414.html

and it should show up in linux-next tree when next is updated.

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 723194f..0e8954b 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4485,7 +4485,8 @@ static long cgroup_create(struct cgroup *parent,
> struct dentry *dentry,
>   struct cgroup_subsys_state *css = css_ar[ss->subsys_id];
> 
>   dget(dentry);
> - percpu_ref_get(&css->parent->refcnt);
> + if (!(css->parent->flags & CSS_ROOT))
> + percpu_ref_get(&css->parent->refcnt);
>   }
> 


