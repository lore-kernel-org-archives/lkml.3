Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762978Ab3IDR6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 13:58:42 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56864 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762704Ab3IDR6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 13:58:41 -0400
Date: Wed, 4 Sep 2013 18:58:34 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: rwheeler@redhat.com, avati@redhat.com, bfoster@redhat.com,
        dhowells@redhat.com, eparis@redhat.com, raven@themaw.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        mszeredi@suse.cz, Steven Whitehouse <swhiteho@redhat.com>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 02/10] vfs: check submounts and drop atomically
Message-ID: <20130904175834.GI13318@ZenIV.linux.org.uk>
References: <1378303556-7220-1-git-send-email-miklos@szeredi.hu>
 <1378303556-7220-3-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378303556-7220-3-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 04, 2013 at 04:05:48PM +0200, Miklos Szeredi wrote:

> +static void check_and_drop(void *_data, struct dentry *dentry)
> +{
> +	struct select_data *data = _data;
> +
> +	/* We're only interested in the root of this subtree */
> +	if (data->start == dentry) {
> +		if (d_mountpoint(dentry))
> +			data->found = -EBUSY;
> +		if (!data->found)
> +			__d_drop(dentry);
> +	}
> +}

Wouldn't it be better to do that in caller?  Granted, it's not a hot
path, but... why bother calling it for each dentry in a subtree, only
to return immediately on all calls but the last one?

> +static int __check_submounts_and_drop(struct dentry *parent,
> +					     struct list_head *dispose)
> +{
> +	struct select_data data = {
> +		.start = parent,
> +		.dispose = dispose,
> +		.found = 0,
> +	};
> +
> +	d_walk(parent, &data, check_and_collect, check_and_drop);
> +
> +	return data.found;
> +}

Incidentally, I would rather expand that in the only caller...

> +/**
> + * check_submounts_and_drop - prune dcache, check for submounts and drop
> + *
> + * All done as a single atomic operation relative to has_unlinked_ancestor().
> + * Returns 0 if successfully unhashed @parent.  If there were submounts then
> + * return -EBUSY.
> + *
> + * @dentry: dentry to prune and drop
> + */
> +int check_submounts_and_drop(struct dentry *dentry)
> +{
> +	int ret = 0;
> +
> +	/* Negative dentries can be dropped without further checks */
> +	if (!dentry->d_inode) {
> +		d_drop(dentry);
> +		goto out;
> +	}
> +
> +	spin_lock(&dentry->d_lock);
> +	if (d_unhashed(dentry))
> +		goto out_unlock;
> +	if (list_empty(&dentry->d_subdirs)) {
> +		if (d_mountpoint(dentry)) {
> +			ret = -EBUSY;
> +			goto out_unlock;
> +		}
> +		__d_drop(dentry);
> +		goto out_unlock;
> +	}
> +	spin_unlock(&dentry->d_lock);
> +
> +	for (;;) {
> +		LIST_HEAD(dispose);
> +		ret = __check_submounts_and_drop(dentry, &dispose);
> +		if (!list_empty(&dispose))
> +			shrink_dentry_list(&dispose);
> +
> +		if (ret <= 0)
> +			break;
> +
> +		cond_resched();
> +	}
> +
> +out:
> +	return ret;
> +
> +out_unlock:
> +	spin_unlock(&dentry->d_lock);
> +	goto out;
> +}
> +EXPORT_SYMBOL(check_submounts_and_drop);
