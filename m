Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901AbaEKEzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 00:55:19 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:60747 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbaEKEzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 00:55:16 -0400
Date: Sun, 11 May 2014 00:54:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] cgroup: implement css_tryget()
Message-ID: <20140511045459.GA25009@cmpxchg.org>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-15-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399671091-23867-15-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 05:31:31PM -0400, Tejun Heo wrote:
> Implement css_tryget() which tries to grab a cgroup_subsys_state's
> reference as long as it already hasn't reached zero.  Combined with
> the recent css iterator changes to include offline && !released csses
> during traversal, this can be used to access csses regardless of its
> online state.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  include/linux/cgroup.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
> 
> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
> index c8eb66e..6dd3867 100644
> --- a/include/linux/cgroup.h
> +++ b/include/linux/cgroup.h
> @@ -111,6 +111,22 @@ static inline void css_get(struct cgroup_subsys_state *css)
>  }
>  
>  /**
> + * css_tryget - try to obtain a reference on the specified css
> + * @css: target css
> + *
> + * Obtain a reference on @css unless it already has reached zero and is
> + * being released.  This function doesn't care whether @css is on or
> + * offline.  The caller naturally needs to ensure that @css is accessible
> + * but doesn't have to be holding a reference on it - IOW, RCU protected
> + * access is good enough for this function.  Returns %true if a reference
> + * count was successfully obtained; %false otherwise.
> + */
> +static inline bool css_tryget(struct cgroup_subsys_state *css)
> +{
> +	return percpu_ref_tryget(&css->refcnt);
> +}

percpu_ref_tryget() fails once killed (transitioned from per-cpu to
atomic mode), but exactly this happens during offlining and so this
would actually be equivalent to css_tryget_online(), no?
