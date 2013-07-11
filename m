Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab3GKNRj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:17:39 -0400
Received: from smtp.citrix.com ([66.165.176.89]:37998 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab3GKNRi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:17:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,1043,1363132800"; 
   d="scan'208";a="36374477"
Message-ID: <51DEB070.3060106@citrix.com>
Date: Thu, 11 Jul 2013 14:17:36 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH RFC 1/4] xen-gnt: prevent adding duplicate
 gnt	callbacks
References: <1373288607-1876-1-git-send-email-roger.pau@citrix.com> <1373288607-1876-2-git-send-email-roger.pau@citrix.com>
In-Reply-To: <1373288607-1876-2-git-send-email-roger.pau@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.80.2.76]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/13 14:03, Roger Pau Monne wrote:
> With the current implementation, the callback in the tail of the list
> can be added twice, because the check done in
> gnttab_request_free_callback is bogus, callback->next can be NULL if
> it is the last callback in the list. If we add the same callback twice
> we end up with an infinite loop, were callback == callback->next.
> 
> Replace this check with a proper one that iterates over the list to
> see if the callback has already been added.
> 
> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/grant-table.c |   13 +++++++++++--
>  1 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index 04c1b2d..d5418c1 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -729,9 +729,18 @@ void gnttab_request_free_callback(struct gnttab_free_callback *callback,
>  				  void (*fn)(void *), void *arg, u16 count)
>  {
>  	unsigned long flags;
> +	struct gnttab_free_callback *cb;
> +
>  	spin_lock_irqsave(&gnttab_list_lock, flags);
> -	if (callback->next)
> -		goto out;
> +
> +	/* Check if the callback is already on the list */
> +	cb = gnttab_free_callback_list;
> +	while (cb) {
> +		if (cb == callback)
> +			goto out;
> +		cb = cb->next;
> +	}

O(N)?

Suggest using the standard list infrastructure, or using something other
than NULL for the end of the list (e.g., gnttab_free_callback_list).

gnttab_request_free_callback() is also putting the callbacks in the
wrong order -- it should be FIFO not LIFO.  Might be nice to fix this as
well.

David
