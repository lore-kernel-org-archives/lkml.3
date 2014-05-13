Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760408AbaEMM4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 08:56:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37185 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590AbaEMM42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 08:56:28 -0400
Date: Tue, 13 May 2014 08:56:06 -0400
From: Aristeu Rozanski <aris@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        hannes@cmpxchg.org, Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH 04/14] device_cgroup: remove direct access to
 cgroup->children
Message-ID: <20140513125605.GI29214@redhat.com>
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

On Fri, May 09, 2014 at 05:31:21PM -0400, Tejun Heo wrote:
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

Acked-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu

