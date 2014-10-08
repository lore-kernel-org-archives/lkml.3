Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145AbaJHKq4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 06:46:56 -0400
Received: from relay.parallels.com ([195.214.232.42]:39315 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104AbaJHKqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 06:46:53 -0400
Date: Wed, 8 Oct 2014 14:46:49 +0400
From: Andrew Vagin <avagin@parallels.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>, Andrey Vagin <avagin@openvz.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: Re: [PATCH] mnt: Move the clear of MNT_LOCKED from copy_tree to it's
Message-ID: <20141008104649.GA24908@paralelels.com>
References: <1412683212-28077-1-git-send-email-avagin@openvz.org>
 <20141007132431.GF7996@ZenIV.linux.org.uk>
 <20141007134011.GA569@paralelels.com>
 <87vbnv3cl1.fsf_-_@x220.int.ebiederm.org>
 <20141007195307.GA23694@paralelels.com>
 <87iojvvbqe.fsf@x220.int.ebiederm.org>
 <20141007215959.GA4622@paralelels.com>
 <878ukrmp1t.fsf@x220.int.ebiederm.org>
 <87zjd7la91.fsf_-_@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Content-Disposition: inline
In-Reply-To: <87zjd7la91.fsf_-_@x220.int.ebiederm.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [10.30.16.48]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 07, 2014 at 04:40:10PM -0700, Eric W. Biederman wrote:
> 
> Clear MNT_LOCKED in the callers of copy_tree except copy_mnt_ns, and
> collect_mounts.  In copy_mnt_nswe want an exact copy of a mount tree,
> so not clearing MNT_LOCKED is important.  Similarly collect_mounts
> is used to take a snapshot of the mount tree for audit logging purposes
> and auditing using a faithful copy of the tree is important.
> 
> This becomes particularly significant when we start setting MNT_LOCKED
> on rootfs to prevent it from being unmounted.
> 

Acked-by: Andrew Vagin <avagin@parallels.com>

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  fs/namespace.c | 1 -
>  fs/pnode.c     | 1 +
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 9c6ee037bef7..5a11e273541c 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1498,7 +1498,6 @@ struct mount *copy_tree(struct mount *mnt, struct dentry *dentry,
>  	if (IS_ERR(q))
>  		return q;
>  
> -	q->mnt.mnt_flags &= ~MNT_LOCKED;
>  	q->mnt_mountpoint = mnt->mnt_mountpoint;
>  
>  	p = mnt;
> diff --git a/fs/pnode.c b/fs/pnode.c
> index aae331a5d03b..260ac8f898a4 100644
> --- a/fs/pnode.c
> +++ b/fs/pnode.c
> @@ -242,6 +242,7 @@ static int propagate_one(struct mount *m)
>  	child = copy_tree(last_source, last_source->mnt.mnt_root, type);
>  	if (IS_ERR(child))
>  		return PTR_ERR(child);
> +	child->mnt.mnt_flags &= ~MNT_LOCKED;
>  	mnt_set_mountpoint(m, mp, child);
>  	last_dest = m;
>  	last_source = child;
> -- 
> 1.9.1
> 
