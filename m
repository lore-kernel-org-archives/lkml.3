Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752010AbaDVG1v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 02:27:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:1319 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaDVG1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 02:27:47 -0400
Message-ID: <53560BA3.40501@huawei.com>
Date: Tue, 22 Apr 2014 14:26:43 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jianyu Zhan <nasa4836@gmail.com>
CC: <tj@kernel.org>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroup: use uninitialized_var() for may-be uninitialized
 variable
References: <1398145479-11400-1-git-send-email-nasa4836@gmail.com>
In-Reply-To: <1398145479-11400-1-git-send-email-nasa4836@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 13:44, Jianyu Zhan wrote:
> To suppress this warning:
> 
>  warning: ‘err’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   int err;
> 	^

I don't see this warning, and I don't see how this is possible.

static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
{
	struct cgroup *parent = cgrp->parent;
	struct cgroup_subsys_state *css;
	int err;

	lockdep_assert_held(&cgroup_mutex);

	css = ss->css_alloc(cgroup_css(parent, ss));
	if (IS_ERR(css))
		return PTR_ERR(css);

	err = percpu_ref_init(&css->refcnt, css_release);
	if (err)
		goto err_free_css;
	...

	return err;
}

> 
> Use the uninitialized_var() to decalre err. It also serves to be good documetation.
> 

anyway, uninitialized_var() should be avoided if possible.

nack

> Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> ---
>  kernel/cgroup.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 24675f5..930569c 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -4144,7 +4144,7 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
>  {
>  	struct cgroup *parent = cgrp->parent;
>  	struct cgroup_subsys_state *css;
> -	int err;
> +	int uninitialized_var(err);
>  
>  	lockdep_assert_held(&cgroup_mutex);
>  
> 

