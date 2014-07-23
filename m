Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbaGWGGy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:06:54 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:34901 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752821AbaGWGGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:06:53 -0400
X-Sasl-enc: cSu7VQ/xHv+pptJDfy7g2S6fFDdcrsFInczT7UX9qeyi 1406095611
Message-ID: <1406095603.2509.11.camel@perseus.fritz.box>
Subject: Re: [PATCH  v4] fs: umount on symlink leaks mnt count
From: Ian Kent <raven@themaw.net>
To: Vasily Averin <vvs@parallels.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Weinberger <richard.weinberger@gmail.com>
Date: Wed, 23 Jul 2014 14:06:43 +0800
In-Reply-To: <53CCCF9F.6090301@parallels.com>
References: <CAFLxGvxf_bsLNKRtt05zgkdHy+7ALWMz29QUG=f9UwTcqXetfg@mail.gmail.com>
	 <cover.1405859651.git.vvs@openvz.org> <53CCCF9F.6090301@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-21 at 12:30 +0400, Vasily Averin wrote:
> v4: description corrected
> v3: patch inline
> 
> Currently umount on symlink blocks following umount:
> 
> /vz is separate mount
> 
> # ls /vz/ -al | grep test
> drwxr-xr-x.  2 root root       4096 Jul 19 01:14 testdir
> lrwxrwxrwx.  1 root root         11 Jul 19 01:16 testlink -> /vz/testdir
> # umount -l /vz/testlink
> umount: /vz/testlink: not mounted (expected)
> 
> # lsof /vz
> # umount /vz
> umount: /vz: device is busy. (unexpected)
> 
> In this case mountpoint_last() gets an extra refcount on path->mnt
> 
> Signed-off-by: Vasily Averin <vvs@openvz.org>

Acked-by: Ian Kent <raven@themaw.net>

I was working on this too.
I prefer this patch over my own.
Haven't tested it yet but it is very similar to the patch I was working
with which had seen some basic testing.

> ---
>  fs/namei.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 985c6f3..9eb787e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2256,9 +2256,10 @@ done:
>  		goto out;
>  	}
>  	path->dentry = dentry;
> -	path->mnt = mntget(nd->path.mnt);
> +	path->mnt = nd->path.mnt;
>  	if (should_follow_link(dentry, nd->flags & LOOKUP_FOLLOW))
>  		return 1;
> +	mntget(path->mnt);
>  	follow_mount(path);
>  	error = 0;
>  out:


