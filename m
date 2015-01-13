Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbbAMF2F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 00:28:05 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44741 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbbAMF2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 00:28:03 -0500
Date: Tue, 13 Jan 2015 05:28:01 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs: namespace: Simplify function commit_tree()
Message-ID: <20150113052801.GH22149@ZenIV.linux.org.uk>
References: <1421125686-23765-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421125686-23765-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 13, 2015 at 01:08:06PM +0800, Jiang Liu wrote:
> Simplify function commit_tree() in fs/namespace.c, it also improves code
> readability.

Huh?

>  static void commit_tree(struct mount *mnt, struct mount *shadows)
>  {
>  	struct mount *parent = mnt->mnt_parent;
> -	struct mount *m;
> -	LIST_HEAD(head);
>  	struct mnt_namespace *n = parent->mnt_ns;
>  
>  	BUG_ON(parent == mnt);
> -
> -	list_add_tail(&head, &mnt->mnt_list);
> -	list_for_each_entry(m, &head, mnt_list)
> -		m->mnt_ns = n;
> -
> -	list_splice(&head, n->list.prev);
> -
> +	mnt->mnt_ns = n;
> +	list_add_tail(&mnt->mnt_list, &n->list);

And who will set ->mnt_ns on other mounts reachable via ->mnt_list from mnt?
Not to mention putting them on n->list...

What you seem to have missed is that list_add_tail(&head, &mnt->mnt_list)
is not the same thing as list_add_tail(&mnt->mnt_list, &head).  We are
not ripping mnt->mnt_list from whatever list it was on and insert it into
a previously empty one in head.  We take an unanchored cyclic list (all
elements being some_mnt->mnt_list) and anchor it at head, then go through
all elements of the original list and move them all at once into the
end of n->list.
