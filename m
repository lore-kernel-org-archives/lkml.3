Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332Ab3LQMgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 07:36:33 -0500
Received: from mail-gg0-f181.google.com ([209.85.161.181]:42753 "EHLO
	mail-gg0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390Ab3LQMgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 07:36:32 -0500
X-Greylist: delayed 421 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Dec 2013 07:36:32 EST
Date: Tue, 17 Dec 2013 07:29:26 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Message-ID: <20131217122926.GC29989@htj.dyndns.org>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils>
 <52AEC989.4080509@huawei.com>
 <20131216095345.GB23582@dhcp22.suse.cz>
 <20131216104042.GC23582@dhcp22.suse.cz>
 <20131216163530.GH32509@htj.dyndns.org>
 <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
 <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
 <52AFC163.5010507@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52AFC163.5010507@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Dec 17, 2013 at 11:13:39AM +0800, Li Zefan wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index c36d906..769b5bb 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -868,6 +868,15 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
>  		struct cgroup *cgrp = dentry->d_fsdata;
>  
>  		BUG_ON(!(cgroup_is_dead(cgrp)));
> +
> +		/*
> +		 * We should remove the cgroup object from idr before its
> +		 * grace period starts, so we won't be looking up a cgroup
> +		 * while the cgroup is being freed.
> +		 */

Let's remove this comment and instead comment that this is to be made
per-css.  I mixed up the lifetime rules of the cgroup and css and
thought css_from_id() should fail once css is confirmed to be offline,
so the above comment.  It looks like we'll eventually have to move
cgrp->id to css->id (just simple per-ss idr) as the two objects'
lifetime rules will be completely separate.  Other than that, looks
good to me.

Thanks.

-- 
tejun
