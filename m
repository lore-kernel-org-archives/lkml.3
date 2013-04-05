Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162129Ab3DERNH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:13:07 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52375 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162035Ab3DERNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:13:04 -0400
Date: Fri, 5 Apr 2013 18:12:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Waiman Long <Waiman.Long@hp.com>
Cc: Jeff Layton <jlayton@redhat.com>, Miklos Szeredi <mszeredi@suse.cz>,
        Ian Kent <raven@themaw.net>, Sage Weil <sage@inktank.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <Trond.Myklebust@netapp.com>,
        Eric Paris <eparis@redhat.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, autofs@vger.kernel.org,
        ceph-devel@vger.kernel.org, linux-cifs@vger.kernel.org,
        samba-technical@lists.samba.org, linux-nfs@vger.kernel.org,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>,
        Andi Kleen <andi@firstfloor.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v2 1/4] dcache: Don't take unnecessary lock in d_count
 update
Message-ID: <20130405171220.GD4068@ZenIV.linux.org.uk>
References: <1365181061-30787-1-git-send-email-Waiman.Long@hp.com>
 <1365181061-30787-2-git-send-email-Waiman.Long@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365181061-30787-2-git-send-email-Waiman.Long@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -635,22 +640,14 @@ struct dentry *dget_parent(struct dentry *dentry)
>  {
>  	struct dentry *ret;
>  
> -repeat:
> -	/*
> -	 * Don't need rcu_dereference because we re-check it was correct under
> -	 * the lock.
> -	 */
>  	rcu_read_lock();
> -	ret = dentry->d_parent;
> -	spin_lock(&ret->d_lock);
> -	if (unlikely(ret != dentry->d_parent)) {
> -		spin_unlock(&ret->d_lock);
> -		rcu_read_unlock();
> -		goto repeat;
> -	}
> +	ret = rcu_dereference(dentry->d_parent);
>  	rcu_read_unlock();
> +	if (dcount_inc_cmpxchg(ret))
> +		return ret;
> +	spin_lock(&ret->d_lock);

And WTF is going to protect your "ret" from being freed just as you'd done
rcu_read_unlock()?
