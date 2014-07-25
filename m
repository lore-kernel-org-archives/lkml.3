Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760240AbaGYLw6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 07:52:58 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:22751 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaGYLw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 07:52:57 -0400
Date: Fri, 25 Jul 2014 14:52:34 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Guillaume Clement <gclement@baobob.org>
Cc: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: tag data as __user in struct
 tagSCmdRequest
Message-ID: <20140725115234.GZ25880@mwanda>
References: <1406243260-13490-1-git-send-email-gclement@baobob.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406243260-13490-1-git-send-email-gclement@baobob.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 01:07:40AM +0200, Guillaume Clement wrote:
> diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
> index 501cd64..9291259 100644
> --- a/drivers/staging/vt6655/iwctl.c
> +++ b/drivers/staging/vt6655/iwctl.c
> @@ -1621,14 +1621,17 @@ int iwctl_giwauth(struct net_device *dev,
>  int iwctl_siwgenie(struct net_device *dev,
>  		   struct iw_request_info *info,
>  		   struct iw_point *wrq,
> -		   char *extra)
> +		   char __user *extra)
>  {
>  	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
>  	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
>  	int ret = 0;
> +	char length;
>  
>  	if (wrq->length) {
> -		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
> +		if (get_user(length, extra + 1))
> +			return -EFAULT;
> +		if ((wrq->length < 2) || (length != wrq->length)) {
>  			ret = -EINVAL;
>  			goto out;
>  		}

Wow, this is confusing code.  The patch description isn't clear enough
that this is a bugfix patch and not just a "tag data" patch.

I don't think this is correct.  We need to check the length of the input
buffer before we call get_user().  Can we return directly or do we
*need* to go to the mysteriously named "out"?  Also the + 2 is lost,
this would break everything if the current code works (not necessarily a
valid assumption).  Delete all my comments in the final code.

	/* 2 because we skip the first byte and read length from the
	   second byte */
	if (wrq->length < 2) {
		ret = -EINVAL;
		goto out;
	}

	ret = get_user(length, extra + 1);
	if (ret)
		goto out;

	if (length + 2 != wrq->length) {
		ret = -EINVAL;
		goto out;
	}

regards,
dan carpenter

