Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934205Ab3BNQst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 11:48:49 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:33293 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003Ab3BNQss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 11:48:48 -0500
Date: Thu, 14 Feb 2013 08:48:30 -0800
From: Tejun Heo <tj@kernel.org>
To: Jerry Snitselaar <jerry.snitselaar@oracle.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        serge.hallyn@canonical.com, aris@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] device_cgroup: don't grab mutex in rcu callback
Message-ID: <20130214164830.GI9057@htj.dyndns.org>
References: <1360860363-2879-1-git-send-email-jerry.snitselaar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360860363-2879-1-git-send-email-jerry.snitselaar@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Andrew)

Andrew, can you please pick up this one?

 http://article.gmane.org/gmane.linux.kernel.cgroups/6158/raw

Thank you.

On Thu, Feb 14, 2013 at 09:46:03AM -0700, Jerry Snitselaar wrote:
> commit 103a197 "security/device_cgroup: lock assert fails in
> dev_exception_clean()" grabs devcgroup_mutex to fix assert failure,
> but mutex can't be grabbed in rcu callback. Since there shouldn't be
> any other references when css_free is called, mutex isn't needed for
> list cleanup in devcgroup_css_free().
> 
> Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> Acked-by: Tejun Heo <tj@kernel.org>
> Acked-by: Aristeu Rozanski <aris@redhat.com>
> ---
>  security/device_cgroup.c | 21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index d794abc..1c69e38 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -159,6 +159,16 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
>  	}
>  }
>  
> +static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
> +{
> +	struct dev_exception_item *ex, *tmp;
> +
> +	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
> +		list_del_rcu(&ex->list);
> +		kfree_rcu(ex, rcu);
> +	}
> +}
> +
>  /**
>   * dev_exception_clean - frees all entries of the exception list
>   * @dev_cgroup: dev_cgroup with the exception list to be cleaned
> @@ -167,14 +177,9 @@ static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
>   */
>  static void dev_exception_clean(struct dev_cgroup *dev_cgroup)
>  {
> -	struct dev_exception_item *ex, *tmp;
> -
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	list_for_each_entry_safe(ex, tmp, &dev_cgroup->exceptions, list) {
> -		list_del_rcu(&ex->list);
> -		kfree_rcu(ex, rcu);
> -	}
> +	__dev_exception_clean(dev_cgroup);
>  }
>  
>  /*
> @@ -215,9 +220,7 @@ static void devcgroup_css_free(struct cgroup *cgroup)
>  	struct dev_cgroup *dev_cgroup;
>  
>  	dev_cgroup = cgroup_to_devcgroup(cgroup);
> -	mutex_lock(&devcgroup_mutex);
> -	dev_exception_clean(dev_cgroup);
> -	mutex_unlock(&devcgroup_mutex);
> +	__dev_exception_clean(dev_cgroup);
>  	kfree(dev_cgroup);
>  }
>  
> -- 
> 1.8.1.1.293.gfe73786
> 

-- 
tejun
