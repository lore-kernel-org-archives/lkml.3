Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaAJSHm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 13:07:42 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:16974 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaAJSHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 13:07:40 -0500
Message-ID: <52D036FC.6000308@oracle.com>
Date: Fri, 10 Jan 2014 13:07:56 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Olaf Hering <olaf@aepfle.de>
CC: konrad.wilk@oracle.com, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com
Subject: Re: [PATCH] xen-blkfront: remove type check from blkfront_setup_discard
References: <1389371301-29532-1-git-send-email-olaf@aepfle.de>
In-Reply-To: <1389371301-29532-1-git-send-email-olaf@aepfle.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/10/2014 11:28 AM, Olaf Hering wrote:
> In its initial implementation a check for "type" was added, but only phy
> and file are handled. This breaks advertised discard support for other
> type values such as qdisk.
>
> Fix and simplify this function: If the backend advertises discard
> support it is supposed to implement it properly, so enable
> feature_discard unconditionally. If the backend advertises the need for
> a certain granularity and alignment then propagate both properties to
> the blocklayer. The discard-secure property is a boolean, update the code
> to reflect that.
>
> Signed-off-by: Olaf Hering <olaf@aepfle.de>
> ---
>   drivers/block/xen-blkfront.c | 40 ++++++++++++++--------------------------
>   1 file changed, 14 insertions(+), 26 deletions(-)
>
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index c4a4c90..c9e96b9 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -1635,36 +1635,24 @@ blkfront_closing(struct blkfront_info *info)
>   static void blkfront_setup_discard(struct blkfront_info *info)
>   {
>   	int err;
> -	char *type;
>   	unsigned int discard_granularity;
>   	unsigned int discard_alignment;
>   	unsigned int discard_secure;
>   
> -	type = xenbus_read(XBT_NIL, info->xbdev->otherend, "type", NULL);
> -	if (IS_ERR(type))
> -		return;
> -
> -	info->feature_secdiscard = 0;
> -	if (strncmp(type, "phy", 3) == 0) {
> -		err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> -			"discard-granularity", "%u", &discard_granularity,
> -			"discard-alignment", "%u", &discard_alignment,
> -			NULL);
> -		if (!err) {
> -			info->feature_discard = 1;
> -			info->discard_granularity = discard_granularity;
> -			info->discard_alignment = discard_alignment;
> -		}
> -		err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> -			    "discard-secure", "%d", &discard_secure,
> -			    NULL);
> -		if (!err)
> -			info->feature_secdiscard = discard_secure;
> -
> -	} else if (strncmp(type, "file", 4) == 0)
> -		info->feature_discard = 1;
> -
> -	kfree(type);
> +	info->feature_discard = 1;

If the call below fails, is it safe to continue using discard feature? 
At the least, are discard_granularity and discard_alignment guaranteed 
to have sane/safe values?

> +	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> +		"discard-granularity", "%u", &discard_granularity,
> +		"discard-alignment", "%u", &discard_alignment,
> +		NULL);
> +	if (!err) {
> +		info->discard_granularity = discard_granularity;
> +		info->discard_alignment = discard_alignment;
> +	}
> +	err = xenbus_gather(XBT_NIL, info->xbdev->otherend,
> +		    "discard-secure", "%d", &discard_secure,
> +		    NULL);
> +	if (!err)
> +		info->feature_secdiscard = !!discard_secure;
>   }

err variable is not really necessary so you can drop it.


-boris
>   
>   static int blkfront_setup_indirect(struct blkfront_info *info)

