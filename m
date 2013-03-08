Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042Ab3CHBaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 20:30:30 -0500
Received: from dcvr.yhbt.net ([64.71.152.64]:51068 "EHLO dcvr.yhbt.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab3CHBa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 20:30:28 -0500
Date: Fri, 8 Mar 2013 01:30:27 +0000
From: Eric Wong <normalperson@yhbt.net>
To: Arve =?utf-8?B?SGrDuG5uZXbDpWc=?= <arve@android.com>
Cc: NeilBrown <neilb@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: epoll: possible bug from wakeup_source activation
Message-ID: <20130308013027.GA31830@dcvr.yhbt.net>
References: <20130307112639.GA25130@dcvr.yhbt.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130307112639.GA25130@dcvr.yhbt.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Wong <normalperson@yhbt.net> wrote:
> Hi Arve, looking at commit 4d7e30d98939a0340022ccd49325a3d70f7e0238
> (epoll: Add a flag, EPOLLWAKEUP, to prevent suspend ...)
> 
> I think the reason for using ep->ws instead of epi->ws in the unlikely
> ovflist case applies to the likely rdllist case, too.  Since epi->ws is
> only protected by ep->mtx, it can also be deactivated while inside
> ep_poll_callback.
> 
> So something like the following patch might be necessary
> (shown here with extra context):
> 
> --- a/fs/eventpoll.c
> +++ b/fs/eventpoll.c
> @@ -968,39 +968,45 @@ static int ep_poll_callback(wait_queue_t *wait, unsigned mode, int sync, void *k
>  	if (unlikely(ep->ovflist != EP_UNACTIVE_PTR)) {
>  		if (epi->next == EP_UNACTIVE_PTR) {
>  			epi->next = ep->ovflist;
>  			ep->ovflist = epi;
>  			if (epi->ws) {
>  				/*
>  				 * Activate ep->ws since epi->ws may get
>  				 * deactivated at any time.
>  				 */
>  				__pm_stay_awake(ep->ws);
>  			}
>  
>  		}

Thinking about this more, it looks like the original ep->ovflist case of
using ep->ws is unnecessary.

ep->ovflist != EP_UNACTIVE_PTR can only happen while ep->mtx is held (in
ep_scan_ready_list); which means ep_modify+friends cannot remove epi->ws.

ep_poll_callback holding ep->lock means ep_poll_callback prevents
ep_scan_ready_list from setting ep->ovflist = EP_UNACTIVE_PTR and
releasing ep->mtx.

>  		goto out_unlock;
>  	}
>  
>  	/* If this file is already in the ready list we exit soon */
>  	if (!ep_is_linked(&epi->rdllink)) {
>  		list_add_tail(&epi->rdllink, &ep->rdllist);
> -		__pm_stay_awake(epi->ws);
> +		if (epi->ws) {
> +			/*
> +			 * Activate ep->ws since epi->ws may get
> +			 * deactivated at any time.
> +			 */
> +			__pm_stay_awake(ep->ws);
> +		}
>  	}

I still think ep->ws needs to be used in the common ep->rdllist case.
