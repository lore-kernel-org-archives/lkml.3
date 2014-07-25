Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409AbaGYXQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 19:16:53 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:49210 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbaGYXQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 19:16:52 -0400
Message-ID: <53D2E556.7040402@gmail.com>
Date: Sat, 26 Jul 2014 00:16:38 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Guillaume Clement <gclement@baobob.org>,
        Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH] staging: vt6655: fix direct dereferencing of user pointer
References: <20140725123301.GZ13737@mwanda> <1406292443-11734-1-git-send-email-gclement@baobob.org>
In-Reply-To: <1406292443-11734-1-git-send-email-gclement@baobob.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guillaume

On 25/07/14 13:47, Guillaume Clement wrote:
> Sparse reported that the data from tagSCmdRequest is given by
> userspace, so it should be tagged as such.
extra is not in user space

All Wireless Extensions ioctl extra calls originate from 
ioctl_standard_iw_point in wext-core.

Either through ioctl or iw_handler

All these functions should have been converted to iw_handler.

Regards


Malcolm

>
> Later, we were memcomparing and dereferencing it without first copying
> it, fix that as well.
>
> Signed-off-by: Guillaume Clement <gclement@baobob.org>
> ---
>   drivers/staging/vt6655/iocmd.h |  2 +-
>   drivers/staging/vt6655/iwctl.c | 32 ++++++++++++++++++++++----------
>   drivers/staging/vt6655/iwctl.h |  6 +++---
>   3 files changed, 26 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/staging/vt6655/iocmd.h b/drivers/staging/vt6655/iocmd.h
> index e499f1b..dd12498 100644
> --- a/drivers/staging/vt6655/iocmd.h
> +++ b/drivers/staging/vt6655/iocmd.h
> @@ -100,7 +100,7 @@ typedef enum tagWZONETYPE {
>   #pragma pack(1)
>   typedef struct tagSCmdRequest {
>   	u8	    name[16];
> -	void	*data;
> +	void __user *data;
>   	u16	    wResult;
>   	u16     wCmdCode;
>   } SCmdRequest, *PSCmdRequest;
> diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
> index 501cd64..7ce23b5 100644
> --- a/drivers/staging/vt6655/iwctl.c
> +++ b/drivers/staging/vt6655/iwctl.c
> @@ -1621,17 +1621,24 @@ int iwctl_giwauth(struct net_device *dev,
>   int iwctl_siwgenie(struct net_device *dev,
>   		   struct iw_request_info *info,
>   		   struct iw_point *wrq,
> -		   char *extra)
> +		   char __user *extra)
>   {
>   	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
>   	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
>   	int ret = 0;
> +	char length;
>
>   	if (wrq->length) {
> -		if ((wrq->length < 2) || (extra[1]+2 != wrq->length)) {
> -			ret = -EINVAL;
> -			goto out;
> -		}
> +		if (wrq->length < 2)
> +			return -EINVAL;
> +
> +		ret = get_user(length, extra + 1);
> +		if (ret)
> +			return ret;
> +
> +		if (length + 2 != wrq->length)
> +			return -EINVAL;
> +
>   		if (wrq->length > MAX_WPA_IE_LEN) {
>   			ret = -ENOMEM;
>   			goto out;
> @@ -1654,7 +1661,7 @@ out://not completely ...not necessary in wpa_supplicant 0.5.8
>   int iwctl_giwgenie(struct net_device *dev,
>   		   struct iw_request_info *info,
>   		   struct iw_point *wrq,
> -		   char *extra)
> +		   char __user *extra)
>   {
>   	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
>   	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
> @@ -1801,18 +1808,23 @@ int iwctl_giwencodeext(struct net_device *dev,
>   int iwctl_siwmlme(struct net_device *dev,
>   		  struct iw_request_info *info,
>   		  struct iw_point *wrq,
> -		  char *extra)
> +		  char __user *extra)
>   {
>   	PSDevice			pDevice = (PSDevice)netdev_priv(dev);
>   	PSMgmtObject	pMgmt = &(pDevice->sMgmtObj);
> -	struct iw_mlme *mlme = (struct iw_mlme *)extra;
> +	struct iw_mlme mime;
> +
>   	int ret = 0;
>
> -	if (memcmp(pMgmt->abyCurrBSSID, mlme->addr.sa_data, ETH_ALEN)) {
> +	ret = copy_from_user(&mime, extra, sizeof(mime));
> +	if (ret)
> +		return -EFAULT;
> +
> +	if (memcmp(pMgmt->abyCurrBSSID, mime.addr.sa_data, ETH_ALEN)) {
>   		ret = -EINVAL;
>   		return ret;
>   	}
> -	switch (mlme->cmd) {
> +	switch (mime.cmd) {
>   	case IW_MLME_DEAUTH:
>   		//this command seems to be not complete,please test it --einsnliu
>   		//bScheduleCommand((void *) pDevice, WLAN_CMD_DEAUTH, (unsigned char *)&reason);
> diff --git a/drivers/staging/vt6655/iwctl.h b/drivers/staging/vt6655/iwctl.h
> index de0a337..7dd6310 100644
> --- a/drivers/staging/vt6655/iwctl.h
> +++ b/drivers/staging/vt6655/iwctl.h
> @@ -176,12 +176,12 @@ int iwctl_giwauth(struct net_device *dev,
>   int iwctl_siwgenie(struct net_device *dev,
>   		   struct iw_request_info *info,
>   		   struct iw_point *wrq,
> -		   char *extra);
> +		   char __user *extra);
>
>   int iwctl_giwgenie(struct net_device *dev,
>   		   struct iw_request_info *info,
>   		   struct iw_point *wrq,
> -		   char *extra);
> +		   char __user *extra);
>
>   int iwctl_siwencodeext(struct net_device *dev,
>   		       struct iw_request_info *info,
> @@ -196,7 +196,7 @@ int iwctl_giwencodeext(struct net_device *dev,
>   int iwctl_siwmlme(struct net_device *dev,
>   		  struct iw_request_info *info,
>   		  struct iw_point *wrq,
> -		  char *extra);
> +		  char __user *extra);
>   #endif // #ifdef WPA_SUPPLICANT_DRIVER_WEXT_SUPPORT
>   //End Add -- //2008-0409-07, <Add> by Einsn Liu
>
>
