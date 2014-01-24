Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752630AbaAXNNF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 08:13:05 -0500
Received: from smtp-fw-9102.amazon.com ([207.171.184.29]:4924 "EHLO
	smtp-fw-9102.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaAXNND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 08:13:03 -0500
X-IronPort-AV: E=Sophos;i="4.95,712,1384300800"; 
   d="scan'208";a="67768427"
Message-ID: <52E266D6.20208@amazon.de>
Date: Fri, 24 Jan 2014 14:12:54 +0100
From: "Egger, Christoph" <chegger@amazon.de>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matt Wilson <msw@linux.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xen.org>, Matt Rushton <mrushton@amazon.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Anthony Liguori <aliguori@amazon.com>, Matt Wilson <msw@amazon.com>,
        =?UTF-8?B?Um9nZXIgUGF1IE1vbm7DqQ==?= <roger.pau@citrix.com>
Subject: Re: [Xen-devel] [PATCH] xen-blkback: fix memory leak when persistent
 grants are used
References: <1390505326-9368-1-git-send-email-msw@linux.com>
In-Reply-To: <1390505326-9368-1-git-send-email-msw@linux.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.01.14 20:28, Matt Wilson wrote:
> From: Matt Rushton <mrushton@amazon.com>
> 
> Currently shrink_free_pagepool() is called before the pages used for
> persistent grants are released via free_persistent_gnts(). This
> results in a memory leak when a VBD that uses persistent grants is
> torn down.

This memory leak was introduced with commit
c6cc142dac52e62e1e8a2aff5de1300202b96c66 xen-blkback: use balloon pages
for all mappings

Christoph

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
>  
> +	/* Since we are shutting down remove all pages from the buffer */
> +	shrink_free_pagepool(blkif, 0 /* All */);
> +
>  	if (log_stats)
>  		print_stats(blkif);
>  
> 

