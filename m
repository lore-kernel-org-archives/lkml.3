Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab3CGKcm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 05:32:42 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:45744 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847Ab3CGKcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 05:32:41 -0500
Date: Thu, 7 Mar 2013 10:32:40 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: trim epitem by one cache line on x86_64
Message-ID: <20130307103240.GA24132@dcvr.yhbt.net>
References: <20130304112941.GA16284@dcvr.yhbt.net>
 <20130306143741.d5e56f13c94d2d6b2c1ea449@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130306143741.d5e56f13c94d2d6b2c1ea449@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:
> It's going to be hard to maintain this - someone will change something
> sometime and break it.  I suppose we could add a runtime check if we
> cared enough.  Adding a big fat comment to struct epitem might help.

Thanks for looking at this patch.  I'll send a patch with a comment
about keeping epitem size in check.  Also, would adding (with comments):

	BUILD_BUG_ON(sizeof(struct epitem) > 128);

...be too heavy-handed?  I used that in my testing.  I'll check for:
sizeof(void *) <= 8 too; in case 128-bit machines appear...

> I don't see much additional room to be saved.  We could probably remove
> epitem.nwait, but that wouldn't actually save anything because nwait
> nestles with ffd.fd.

If we remove nwait, we can move epoll_event up and have event.events
tucked in there.  I have more and more depending on epoll, so I'll be
around to comment on future epoll changes as they come up.

> I tested your patch on powerpc and it reduced sizeof(epitem) from 136
> to 128 for that arch as well, so I suggest we run with
> 
> --- a/fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
> +++ a/fs/eventpoll.c
> @@ -105,7 +105,7 @@
>  struct epoll_filefd {
>  	struct file *file;
>  	int fd;
> -} EPOLL_PACKED;
> +} __packed;

Thanks for testing on ppc.  Looks good to me.  For what it's worth:
Acked-by: Eric Wong <normalperson@yhbt.net>
