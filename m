Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760480Ab3GaSeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 14:34:08 -0400
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:49779 "EHLO
	smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab3GaSeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 14:34:05 -0400
X-IronPort-AV: E=Sophos;i="4.89,788,1367971200"; 
   d="scan'208";a="587515854"
Date: Wed, 31 Jul 2013 11:33:59 -0700
From: Matt Wilson <msw@amazon.com>
To: Roger Pau Monne <roger.pau@citrix.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        David Vrabel <david.vrabel@citrix.com>
Subject: Re: [PATCH 1/3] xen-gnt: prevent adding duplicate gnt callbacks
Message-ID: <20130731183358.GD4239@u109add4315675089e695.ant.amazon.com>
References: <1375282844-4314-1-git-send-email-roger.pau@citrix.com>
 <1375282844-4314-2-git-send-email-roger.pau@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1375282844-4314-2-git-send-email-roger.pau@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 31, 2013 at 05:00:42PM +0200, Roger Pau Monne wrote:
> With the current implementation, the callback in the tail of the list
> can be added twice, because the check done in
> gnttab_request_free_callback is bogus, callback->next can be NULL if
> it is the last callback in the list. If we add the same callback twice
> we end up with an infinite loop, were callback == callback->next.
> 
> Replace this check with a proper one that iterates over the list to
> see if the callback has already been added.

Acked-by: Matt Wilson <msw@amazon.com>

> Signed-off-by: Roger Pau Monné <roger.pau@citrix.com>
> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> ---
> This patch should be backported to stable trees
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
> +
>  	callback->fn = fn;
>  	callback->arg = arg;
>  	callback->count = count;
