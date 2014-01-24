Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaAXKj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 05:39:28 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:60577 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaAXKj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 05:39:26 -0500
X-IronPort-AV: E=Sophos;i="4.95,712,1384300800"; 
   d="scan'208";a="94083277"
Message-ID: <52E242CE.4040400@citrix.com>
Date: Fri, 24 Jan 2014 11:39:10 +0100
From: =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Matt Rushton <mrushton@amazon.com>, Ian Campbell <Ian.Campbell@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, Anthony Liguori <aliguori@amazon.com>,
        Matt Wilson <msw@amazon.com>
Subject: Re: [PATCH] xen-blkback: fix memory leak when persistent grants are
 used
References: <1390505326-9368-1-git-send-email-msw@linux.com>
In-Reply-To: <1390505326-9368-1-git-send-email-msw@linux.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/14 20:28, Matt Wilson wrote:
> From: Matt Rushton <mrushton@amazon.com>
> 
> Currently shrink_free_pagepool() is called before the pages used for
> persistent grants are released via free_persistent_gnts(). This
> results in a memory leak when a VBD that uses persistent grants is
> torn down.

Good catch.

> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Cc: "Roger Pau Monné" <roger.pau@citrix.com>
> Cc: Ian Campbell <Ian.Campbell@citrix.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: xen-devel@lists.xen.org
> Cc: Anthony Liguori <aliguori@amazon.com>
> Signed-off-by: Matt Rushton <mrushton@amazon.com>
> Signed-off-by: Matt Wilson <msw@amazon.com>
> ---
>  drivers/block/xen-blkback/blkback.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
> index 6620b73..30ef7b3 100644
> --- a/drivers/block/xen-blkback/blkback.c
> +++ b/drivers/block/xen-blkback/blkback.c
> @@ -625,9 +625,6 @@ purge_gnt_list:
>  			print_stats(blkif);
>  	}
>  
> -	/* Since we are shutting down remove all pages from the buffer */
> -	shrink_free_pagepool(blkif, 0 /* All */);
> -
>  	/* Free all persistent grant pages */
>  	if (!RB_EMPTY_ROOT(&blkif->persistent_gnts))
>  		free_persistent_gnts(blkif, &blkif->persistent_gnts,
> @@ -636,6 +633,9 @@ purge_gnt_list:
>  	BUG_ON(!RB_EMPTY_ROOT(&blkif->persistent_gnts));
>  	blkif->persistent_gnt_c = 0;

I think we should also add:

flush_work(&blkif->persistent_purge_work);

Here in case there's some pending purge work going on, which could also
add pages to the free list after we have cleaned it.

> +	/* Since we are shutting down remove all pages from the buffer */
> +	shrink_free_pagepool(blkif, 0 /* All */);
> +
>  	if (log_stats)
>  		print_stats(blkif);
>  
> 

