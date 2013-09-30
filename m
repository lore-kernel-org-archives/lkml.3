Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab3I3U7L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 16:59:11 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:53249 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab3I3U7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 16:59:10 -0400
Date: Mon, 30 Sep 2013 20:59:06 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 09/11] epoll: Remove unnecessary error path
Message-ID: <20130930205906.GA13646@dcvr.yhbt.net>
References: <1380572952-30729-1-git-send-email-andi@firstfloor.org>
 <1380572952-30729-10-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380572952-30729-10-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> A static checker was pointing out that nothing can possible set
> nwait < 0 in this path. The comment and the check appears to be
> outdated. Remove it.

I don't think so...

> Cc: viro@zeniv.linux.org.uk
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  fs/eventpoll.c | 10 ----------
>  1 file changed, 10 deletions(-)
> 
> diff --git a/fs/eventpoll.c b/fs/eventpoll.c
> index 473e09d..f72bf55 100644
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -1276,15 +1276,6 @@ static int ep_insert(struct eventpoll *ep, struct epoll_event *event,
>  	 */
>  	revents = ep_item_poll(epi, &epq.pt);

ep_item_poll calls f_op->poll, which calls poll_wait().
poll_wait() will call ep_ptable_queue_proc.

> -	/*
> -	 * We have to check if something went wrong during the poll wait queue
> -	 * install process. Namely an allocation for a wait queue failed due
> -	 * high memory pressure.
> -	 */
> -	error = -ENOMEM;
> -	if (epi->nwait < 0)
> -		goto error_unregister;
> -
>  	/* Add the current item to the list of active epoll hook for this file */
>  	spin_lock(&tfile->f_lock);
>  	list_add_tail(&epi->fllink, &tfile->f_ep_links);
> @@ -1334,7 +1325,6 @@ error_remove_epi:
>  
>  	rb_erase(&epi->rbn, &ep->rbr);
>  
> -error_unregister:
>  	ep_unregister_pollwait(ep, epi);
>  
>  	/*
