Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3HEC66 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 22:58:58 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:62019 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754281Ab3HEC64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 22:58:56 -0400
Message-ID: <51FF14C5.4040003@huawei.com>
Date: Mon, 5 Aug 2013 10:58:13 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@suse.cz>, <bsingharora@gmail.com>,
        <kamezawa.hiroyu@jp.fujitsu.com>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] cgroup: export __cgroup_from_dentry() and __cgroup_dput()
References: <1375632446-2581-1-git-send-email-tj@kernel.org> <1375632446-2581-3-git-send-email-tj@kernel.org>
In-Reply-To: <1375632446-2581-3-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +struct cgroup *__cgroup_from_dentry(struct dentry *dentry, struct cftype **cftp)
>  {
> -	if (file_inode(file)->i_fop != &cgroup_file_operations)
> -		return ERR_PTR(-EINVAL);
> -	return __d_cft(file->f_dentry);
> +	if (!dentry->d_inode ||
> +	    dentry->d_inode->i_op != &cgroup_file_inode_operations)
> +		return NULL;
> +
> +	if (cftp)
> +		*cftp = __d_cft(dentry);
> +	return __d_cgrp(dentry->d_parent);
>  }
> +EXPORT_SYMBOL_GPL(__cgroup_from_dentry);

As we don't expect new users, why export this symbol? memcg can't be
built as a module.

>  
>  static int cgroup_create_file(struct dentry *dentry, umode_t mode,
>  				struct super_block *sb)
> @@ -3953,7 +3956,7 @@ static int cgroup_write_notify_on_release(struct cgroup_subsys_state *css,
>   *
>   * That's why we hold a reference before dput() and drop it right after.
>   */
> -static void cgroup_dput(struct cgroup *cgrp)
> +void __cgroup_dput(struct cgroup *cgrp)
>  {
>  	struct super_block *sb = cgrp->root->sb;
>  
> @@ -3961,6 +3964,7 @@ static void cgroup_dput(struct cgroup *cgrp)
>  	dput(cgrp->dentry);
>  	deactivate_super(sb);
>  }
> +EXPORT_SYMBOL_GPL(__cgroup_dput);

ditto

