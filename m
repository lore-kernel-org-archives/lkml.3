Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580AbbAVOfA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 09:35:00 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:60009 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbbAVOe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 09:34:58 -0500
Date: Thu, 22 Jan 2015 09:34:54 -0500
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Will Deacon <will.deacon@arm.com>,
        "Suzuki K. Poulose" <Suzuki.Poulose@arm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mhocko@suse.cz" <mhocko@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [Regression] 3.19-rc3 : memcg: Hang in mount memcg
Message-ID: <20150122143454.GA4507@htj.dyndns.org>
References: <54B01335.4060901@arm.com>
 <20150110085525.GD2110@esperanza>
 <54BCFDCF.9090603@arm.com>
 <20150121163955.GM4549@arm.com>
 <20150122134550.GA13876@phnom.home.cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122134550.GA13876@phnom.home.cmpxchg.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Jan 22, 2015 at 08:45:50AM -0500, Johannes Weiner wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index bb263d0caab3..9a09308c8066 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1819,8 +1819,11 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
>  			goto out_unlock;
>  		}
>  
> -		if (root->flags ^ opts.flags)
> -			pr_warn("new mount options do not match the existing superblock, will be ignored\n");
> +		if (root->flags ^ opts.flags) {
> +			pr_warn("new mount options do not match the existing superblock\n");
> +			ret = -EBUSY;
> +			goto out_unlock;
> +		}

Do we really need the above chunk?

> @@ -1909,7 +1912,7 @@ static void cgroup_kill_sb(struct super_block *sb)
>  	 *
>  	 * And don't kill the default root.
>  	 */
> -	if (css_has_online_children(&root->cgrp.self) ||
> +	if (!list_empty(&root->cgrp.self.children) ||
>  	    root == &cgrp_dfl_root)
>  		cgroup_put(&root->cgrp);

I tried to do something a bit more advanced so that eventual async
release of dying children, if they happen, can also release the
hierarchy but I don't think it really matters unless we can forcefully
drain.  So, shouldn't just the above part be enough?

Thanks.

-- 
tejun
