Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547AbaENMw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 08:52:58 -0400
Received: from static.92.5.9.176.clients.your-server.de ([176.9.5.92]:35373
	"EHLO mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593AbaENMw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 08:52:56 -0400
Date: Wed, 14 May 2014 14:52:54 +0200
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, Aristeu Rozanski <aris@redhat.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 04/14] device_cgroup: remove direct access to
 cgroup->children
Message-ID: <20140514125254.GA30376@mail.hallyn.com>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-5-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399671091-23867-5-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> Currently, devcg::has_children() directly tests cgroup->children for
> list emptiness.  The field is not a published field and scheduled to
> go away.  In addition, the test isn't strictly correct as devcg should
> only care about children which are visible to userland.
> 
> This patch converts has_children() to use css_next_child() instead.
> The subtle incorrectness is noted and will be dealt with later.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Serge Hallyn <serge.hallyn@ubuntu.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  security/device_cgroup.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 3116015..75b4b18 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -477,9 +477,17 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
>  
>  static inline bool has_children(struct dev_cgroup *devcgroup)
>  {
> -	struct cgroup *cgrp = devcgroup->css.cgroup;
> +	bool ret;
>  
> -	return !list_empty(&cgrp->children);
> +	/*
> +	 * FIXME: There may be lingering offline csses and this function
> +	 * may return %true when there isn't any userland-visible child
> +	 * which is incorrect for our purposes.
> +	 */
> +	rcu_read_lock();
> +	ret = css_next_child(NULL, &devcgroup->css);
> +	rcu_read_unlock();
> +	return ret;
>  }
>  
>  /*
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
