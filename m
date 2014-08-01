Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbaHAId5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 04:33:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20094 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaHAIdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 04:33:55 -0400
Date: Fri, 1 Aug 2014 11:33:18 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, Ian Kent <raven@themaw.net>,
        autofs@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] VFS: allow ->d_manage() to declare -EISDIR in rcu_walk
 mode.
Message-ID: <20140801083318.GA4907@mwanda>
References: <20140730160833.5eac00ec@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730160833.5eac00ec@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 04:08:33PM +1000, NeilBrown wrote:
> @@ -1110,11 +1110,16 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
>  		 * Don't forget we might have a non-mountpoint managed dentry
>  		 * that wants to block transit.
>  		 */
> -		if (unlikely(managed_dentry_might_block(path->dentry)))
> +		switch (managed_dentry_rcu(path->dentry)) {
> +		case -ECHILD:
> +		default:
>  			return false;
> +		case -EISDIR:
> +			return true;
> +		}
>  

Smatch says that any lines after that switch statement are unreachable.

Is the "default" intended?

>  		if (!d_mountpoint(path->dentry))
> -			return true;
> +			return !(path->dentry->d_flags & DCACHE_NEED_AUTOMOUNT);
>  
>  		mounted = __lookup_mnt(path->mnt, path->dentry);
>  		if (!mounted)

regards,
dan carpenter

