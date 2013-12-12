Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751721Ab3LLGB3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 01:01:29 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:58746 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab3LLGB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 01:01:26 -0500
Message-ID: <52A95128.9020309@huawei.com>
Date: Thu, 12 Dec 2013 14:01:12 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <devel@openvz.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: fix fail path in cgroup_load_subsys()
References: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
In-Reply-To: <1386403085-24866-1-git-send-email-vdavydov@parallels.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -4861,10 +4861,8 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	 */
>  	css = ss->css_alloc(cgroup_css(cgroup_dummy_top, ss));
>  	if (IS_ERR(css)) {
> -		/* failure case - need to deassign the cgroup_subsys[] slot. */
> -		cgroup_subsys[ss->subsys_id] = NULL;
> -		mutex_unlock(&cgroup_mutex);
> -		return PTR_ERR(css);
> +		ret = PTR_ERR(css);
> +		goto out_err;
>  	}
>  
>  	list_add(&ss->sibling, &cgroup_dummy_root.subsys_list);
> @@ -4873,6 +4871,10 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	/* our new subsystem will be attached to the dummy hierarchy. */
>  	init_css(css, ss, cgroup_dummy_top);
>  
> +	ret = online_css(css);
> +	if (ret)
> +		goto free_css;
> +
>  	/*
>  	 * Now we need to entangle the css into the existing css_sets. unlike
>  	 * in cgroup_init_subsys, there are now multiple css_sets, so each one
> @@ -4896,18 +4898,17 @@ int __init_or_module cgroup_load_subsys(struct cgroup_subsys *ss)
>  	}
>  	write_unlock(&css_set_lock);
>  
> -	ret = online_css(css);
> -	if (ret)
> -		goto err_unload;
> -

Moving online_css() upwards should be fine.

Acked-by: Li Zefan <lizefan@huawei.com>

>  	/* success! */
>  	mutex_unlock(&cgroup_mutex);
>  	return 0;
>  
> -err_unload:
> +free_css:
> +	list_del(&ss->sibling);
> +	ss->css_free(css);
> +out_err:
> +	/* failure case - need to deassign the cgroup_subsys[] slot. */
> +	cgroup_subsys[ss->subsys_id] = NULL;
>  	mutex_unlock(&cgroup_mutex);
> -	/* @ss can't be mounted here as try_module_get() would fail */
> -	cgroup_unload_subsys(ss);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(cgroup_load_subsys);
> 

