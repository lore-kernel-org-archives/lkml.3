Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab3CFWhp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 17:37:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48531 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260Ab3CFWhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 17:37:43 -0500
Date: Wed, 6 Mar 2013 14:37:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Wong <normalperson@yhbt.net>
Cc: Davide Libenzi <davidel@xmailserver.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] epoll: trim epitem by one cache line on x86_64
Message-Id: <20130306143741.d5e56f13c94d2d6b2c1ea449@linux-foundation.org>
In-Reply-To: <20130304112941.GA16284@dcvr.yhbt.net>
References: <20130304112941.GA16284@dcvr.yhbt.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Mar 2013 11:29:41 +0000 Eric Wong <normalperson@yhbt.net> wrote:

> It is common for epoll users to have thousands of epitems, so saving a
> cache line on every allocation leads to large memory savings.
> 
> Since epitem allocations are cache-aligned, reducing sizeof(struct
> epitem) from 136 bytes to 128 bytes will allow it to squeeze under a
> cache line boundary on x86_64.
> 
> >From /sys/kernel/slab/eventpoll_epi, I see the following changes on my
> x86_64 Core2 Duo (which has 64-byte cache alignment):
> 
> 	object_size  :  192 => 128
> 	objs_per_slab:   21 =>  32
> 
> I have no access to other 64-bit machines, so I am limiting this to
> x86_64-only with EPOLL_PACKED instead of __attribute__((packed))
> 
> ...
>
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -107,7 +107,7 @@
>  struct epoll_filefd {
>  	struct file *file;
>  	int fd;
> -};
> +} EPOLL_PACKED;
>  
>  /*
>   * Structure used to track possible nested calls, for too deep recursions

Yes, I see the same numbers on my gcc, x86_64 allmodconfig.

It's going to be hard to maintain this - someone will change something
sometime and break it.  I suppose we could add a runtime check if we
cared enough.  Adding a big fat comment to struct epitem might help.

I don't see much additional room to be saved.  We could probably remove
epitem.nwait, but that wouldn't actually save anything because nwait
nestles with ffd.fd.

I tested your patch on powerpc and it reduced sizeof(epitem) from 136
to 128 for that arch as well, so I suggest we run with

--- a/fs/eventpoll.c~epoll-trim-epitem-by-one-cache-line-on-x86_64-fix
+++ a/fs/eventpoll.c
@@ -105,7 +105,7 @@
 struct epoll_filefd {
 	struct file *file;
 	int fd;
-} EPOLL_PACKED;
+} __packed;
 
 /*
  * Structure used to track possible nested calls, for too deep recursions
_

