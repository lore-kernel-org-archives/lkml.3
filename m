Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab3KKJsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 04:48:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:49779 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752794Ab3KKJr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 04:47:59 -0500
X-IronPort-AV: E=Sophos;i="4.93,676,1378857600"; 
   d="scan'208";a="73070509"
Message-ID: <5280A7D0.5040101@citrix.com>
Date: Mon, 11 Nov 2013 10:48:00 +0100
From: =?ISO-8859-1?Q?Roger_Pau_Monn=E9?= <roger.pau@citrix.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Felipe Pena <felipensp@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH] block: xen-blkfront: Fix possible NULL ptr
 dereference
References: <1384011369-4381-1-git-send-email-felipensp@gmail.com>
In-Reply-To: <1384011369-4381-1-git-send-email-felipensp@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/13 16:36, Felipe Pena wrote:
> In the blkif_release function the bdget_disk() call might returns
> a NULL ptr which might be dereferenced on bdev->bd_openers checking
> 
> Signed-off-by: Felipe Pena <felipensp@gmail.com>
> ---
>  drivers/block/xen-blkfront.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index a4660bb..7bb1552 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1959,6 +1959,9 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
>  
>  	bdev = bdget_disk(disk, 0);
>  
> +	if (!bdev)
> +		goto out_mutex;

Is this actually possible? By looking at blkfront code, it seems like we
don't remove the device if it is still open, so maybe this should be a
BUG_ON instead of failing silently.

Roger.
