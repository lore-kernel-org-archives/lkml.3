Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751377AbaEWWYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 18:24:35 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44425 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaEWWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 18:24:34 -0400
Message-ID: <537FCAA0.6080106@codeaurora.org>
Date: Fri, 23 May 2014 15:24:32 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-tegra@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] clk: flatten clk tree in debugfs
References: <1400842772-4862-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1400842772-4862-1-git-send-email-pdeschrijver@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 03:59 AM, Peter De Schrijver wrote:
> This patch flattens the clk tree in CCF debugfs. Instead of representing the
> clocks and their hierarchy as a directory structure under
> /sys/kernel/debug/clk, each clock gets a single directory directly under
> /sys/kernel/debug/clk.
>
> While this may seem strange, here's way I think this is the right thing to do:
>
> 1) a directory structure cannot be 'snapshotted' atomically, therefore it's
>     not in general possible to get a consistent view of the clocktree, because
>     clocks can be reparented at any time. This was solved by adding clk_dump
>     and clk_summary, which do guarantee an atomic snapshot of the tree.
>     Therefore I think the directory structure doesn't add any value.
>
> 2) When writing userspace programs which use the files in the clock
>     directories (eg. for testing purposes), it's impossible to know for sure
>     where a certain clock will be, because it might have been reparented by the
>     time you figured out the path from clk_dump. This makes writing such
>     programs more difficult than it should be.
>
> So because the directory structure doesn't give any information we don't
> already provide by other means and it makes certain usecases more difficult
> than the should be, I think we should move to a flat directory containing
> one subdir per clock.

Completely agree and a huge ACK to this idea.

>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> ---
>   drivers/clk/clk.c |   54 +++-------------------------------------------------
>   1 files changed, 4 insertions(+), 50 deletions(-)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index dff0373..53c6b4f 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -306,7 +306,7 @@ static int clk_debug_create_subtree(struct clk *clk, struct dentry *pdentry)
>   		goto out;
>
>   	hlist_for_each_entry(child, &clk->children, child_node)
> -		clk_debug_create_subtree(child, clk->dentry);
> +		clk_debug_create_subtree(child, pdentry);
>
>   	ret = 0;
>   out:
> @@ -326,29 +326,20 @@ out:
>    */
>   static int clk_debug_register(struct clk *clk)
>   {
> -	struct clk *parent;
>   	struct dentry *pdentry;
>   	int ret = 0;
>
>   	if (!inited)
>   		goto out;
>
> -	parent = clk->parent;
> -
>   	/*
>   	 * Check to see if a clk is a root clk.  Also check that it is
>   	 * safe to add this clk to debugfs
>   	 */
> -	if (!parent)
> -		if (clk->flags & CLK_IS_ROOT)
> -			pdentry = rootdir;
> -		else
> -			pdentry = orphandir;
> +	if (clk->flags & CLK_IS_ROOT)
> +		pdentry = rootdir;
>   	else
> -		if (parent->dentry)
> -			pdentry = parent->dentry;
> -		else
> -			goto out;
> +		pdentry = orphandir;

I'm confused by this code. Shouldn't pdentry always be the same? Do we 
need a dir for orphans? Also, I'm not sure the code is actually right? 
Looks like you are putting everything but the root into orphandir?

>
>   	ret = clk_debug_create_subtree(clk, pdentry);
>
> @@ -372,39 +363,6 @@ static void clk_debug_unregister(struct clk *clk)
>   }
>
>   /**
> - * clk_debug_reparent - reparent clk node in the debugfs clk tree
> - * @clk: the clk being reparented
> - * @new_parent: the new clk parent, may be NULL
> - *
> - * Rename clk entry in the debugfs clk tree if debugfs has been
> - * initialized.  Otherwise it bails out early since the debugfs clk tree
> - * will be created lazily by clk_debug_init as part of a late_initcall.
> - *
> - * Caller must hold prepare_lock.
> - */
> -static void clk_debug_reparent(struct clk *clk, struct clk *new_parent)
> -{
> -	struct dentry *d;
> -	struct dentry *new_parent_d;
> -
> -	if (!inited)
> -		return;
> -
> -	if (new_parent)
> -		new_parent_d = new_parent->dentry;
> -	else
> -		new_parent_d = orphandir;
> -
> -	d = debugfs_rename(clk->dentry->d_parent, clk->dentry,
> -			new_parent_d, clk->name);
> -	if (d)
> -		clk->dentry = d;
> -	else
> -		pr_debug("%s: failed to rename debugfs entry for %s\n",
> -				__func__, clk->name);
> -}
> -
> -/**
>    * clk_debug_init - lazily create the debugfs clk tree visualization
>    *
>    * clks are often initialized very early during boot before memory can
> @@ -1277,9 +1235,6 @@ static void __clk_set_parent_after(struct clk *clk, struct clk *parent,
>   		clk_disable(old_parent);
>   		__clk_unprepare(old_parent);
>   	}
> -
> -	/* update debugfs with new clk tree topology */
> -	clk_debug_reparent(clk, parent);
>   }
>
>   static int __clk_set_parent(struct clk *clk, struct clk *parent, u8 p_index)
> @@ -1685,7 +1640,6 @@ out:
>   void __clk_reparent(struct clk *clk, struct clk *new_parent)
>   {
>   	clk_reparent(clk, new_parent);
> -	clk_debug_reparent(clk, new_parent);

This should also make a lot of set rate/parent calls faster even when 
debug is enabled.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
