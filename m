Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbaFCM5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:57:34 -0400
Received: from mail-qg0-f52.google.com ([209.85.192.52]:38933 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaFCM5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:57:33 -0400
Date: Tue, 3 Jun 2014 08:57:28 -0400
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 1/3] cgroup: don't destroy the default root
Message-ID: <20140603125728.GA26210@htj.dyndns.org>
References: <538D4956.5050205@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538D4956.5050205@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Li.

On Tue, Jun 03, 2014 at 12:04:38PM +0800, Li Zefan wrote:
>  static void cgroup_get(struct cgroup *cgrp)
>  {
>  	WARN_ON_ONCE(cgroup_is_dead(cgrp));
> -	css_get(&cgrp->self);
> +	if (!(cgrp->self.flags & CSS_NO_REF))
> +		css_get(&cgrp->self);

Hmmm?  The same condition is tested by css_get().  Why should it be
tested again here?

>  static void cgroup_put(struct cgroup *cgrp)
>  {
> -	css_put(&cgrp->self);
> +	if (!(cgrp->self.flags & CSS_NO_REF))
> +		css_put(&cgrp->self);

Ditto.

> @@ -1781,10 +1783,12 @@ static void cgroup_kill_sb(struct super_block *sb)
>  	 * This prevents new mounts by disabling percpu_ref_tryget_live().
>  	 * cgroup_mount() may wait for @root's release.
>  	 */
> -	if (css_has_online_children(&root->cgrp.self))
> +	if (css_has_online_children(&root->cgrp.self)) {
>  		cgroup_put(&root->cgrp);
> -	else
> -		percpu_ref_kill(&root->cgrp.self.refcnt);
> +	} else {
> +		if (root != &cgrp_dfl_root)
> +			percpu_ref_kill(&root->cgrp.self.refcnt);
> +	}

As conceptually percpu_ref_kill() just puts the base ref and the
dfl_root's refcnt never reaches zero, it won't actually trigger.
Hmmm.... wouldn't the above leak a ref each time the default hierarchy
is unmounted tho?  Shouldn't it be like the following?

	if (root == &cgrp_dfl_root || css_has_online_children(...))
		cgroup_put(&root->cgrp);
	else
		percpu_ref_kill(...);

Thanks.

-- 
tejun
