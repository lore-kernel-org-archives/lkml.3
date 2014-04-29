Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaD2DLR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:11:17 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:43754 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaD2DLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:11:16 -0400
Message-ID: <535F1851.3020004@lwfinger.net>
Date: Mon, 28 Apr 2014 22:11:13 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Christian Engelmayer <cengelma@gmx.at>, devel@driverdev.osuosl.org
CC: gregkh@linuxfoundation.org, peter.p.waskiewicz.jr@intel.com,
        oat.elena@gmail.com, dan.carpenter@oracle.com,
        w-lkml@lebenslange-mailadresse.de, teobaluta@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: rtl8188eu: fix potential leak in rtw_wx_read32()
References: <20140428225431.2ea55d58@spike> <20140428225620.611319cf@spike>
In-Reply-To: <20140428225620.611319cf@spike>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2014 03:56 PM, Christian Engelmayer wrote:
> Function rtw_wx_read32() dynamically allocates a temporary buffer that is not
> freed in all error paths. Use a centralized exit path and make sure that all
> memory is freed correctly. Detected by Coverity - CID 1077711.
>
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

This Ack is valid for all 5 patches.

Larry

> ---
>   drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 15 +++++++++------
>   1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> index cf30a08..45b47e2 100644
> --- a/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> +++ b/drivers/staging/rtl8188eu/os_dep/ioctl_linux.c
> @@ -2154,6 +2154,7 @@ static int rtw_wx_read32(struct net_device *dev,
>   	u32 bytes;
>   	u8 *ptmp;
>   	int rv;
> +	int ret = 0;
>
>   	padapter = (struct adapter *)rtw_netdev_priv(dev);
>   	p = &wrqu->data;
> @@ -2163,16 +2164,16 @@ static int rtw_wx_read32(struct net_device *dev,
>   		return -ENOMEM;
>
>   	if (copy_from_user(ptmp, p->pointer, len)) {
> -		kfree(ptmp);
> -		return -EFAULT;
> +		ret = -EFAULT;
> +		goto exit;
>   	}
>
>   	bytes = 0;
>   	addr = 0;
>   	rv = sscanf(ptmp, "%d,%x", &bytes, &addr);
>   	if (rv != 2) {
> -		kfree(ptmp);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto exit;
>   	}
>
>   	switch (bytes) {
> @@ -2190,12 +2191,14 @@ static int rtw_wx_read32(struct net_device *dev,
>   		break;
>   	default:
>   		DBG_88E(KERN_INFO "%s: usage> read [bytes],[address(hex)]\n", __func__);
> -		return -EINVAL;
> +		ret = -EINVAL;
> +		goto exit;
>   	}
>   	DBG_88E(KERN_INFO "%s: addr = 0x%08X data =%s\n", __func__, addr, extra);
>
> +exit:
>   	kfree(ptmp);
> -	return 0;
> +	return ret;
>   }
>
>   static int rtw_wx_write32(struct net_device *dev,
>

