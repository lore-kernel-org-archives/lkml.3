Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaEZPn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:43:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbaEZPn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:43:56 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Benoit Taine <benoit.taine@lip6.fr>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 9/18] staging: rtl8723au: Use kmemdup instead of kmalloc + memcpy
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
	<1401117687-28911-10-git-send-email-benoit.taine@lip6.fr>
Date: Mon, 26 May 2014 17:43:45 +0200
In-Reply-To: <1401117687-28911-10-git-send-email-benoit.taine@lip6.fr> (Benoit
	Taine's message of "Mon, 26 May 2014 17:21:18 +0200")
Message-ID: <wrfjy4xo35qm.fsf@ultrasam.lan.trained-monkey.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benoit Taine <benoit.taine@lip6.fr> writes:
> This issue was reported by coccicheck using the semantic patch 
> at scripts/coccinelle/api/memdup.cocci
>
> Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
> ---
> Tested by compilation without errors.
>
>  drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c |    3 +--
>  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c |   16 ++++++----------
>  2 files changed, 7 insertions(+), 12 deletions(-)

Benoit,

I believe this was already applied to staging-next - if you feel
something is missing. Could you please re-diff against the latest
staging-next tree.

Cheers,
Jes

commit 4a6eea4dcbc0328c3126fed264c42b0725bea659
Author: Benoit Taine <benoit.taine@lip6.fr>
Date:   Thu May 22 15:08:33 2014 +0200

    staging: rtl8723au: Use kmemdup() instead of memcpy() to duplicate memory
    
    This issue was reported by coccicheck using the semantic patch
    at scripts/coccinelle/api/memdup.cocci, and tested by compilation.
    
    Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


>
> diff --git a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> index e2d426a..f917edd 100644
> --- a/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> +++ b/drivers/staging/rtl8723au/hal/rtl8723a_hal_init.c
> @@ -339,12 +339,11 @@ int rtl8723a_FirmwareDownload(struct rtw_adapter *padapter)
>  		rtStatus = _FAIL;
>  		goto Exit;
>  	}
> -	firmware_buf = kzalloc(fw->size, GFP_KERNEL);
> +	firmware_buf = kmemdup(fw->data, fw->size, GFP_KERNEL);
>  	if (!firmware_buf) {
>  		rtStatus = _FAIL;
>  		goto Exit;
>  	}
> -	memcpy(firmware_buf, fw->data, fw->size);
>  	buf = firmware_buf;
>  	fw_size = fw->size;
>  	release_firmware(fw);
> diff --git a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> index 182f57c..735eb99 100644
> --- a/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> +++ b/drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c
> @@ -1426,14 +1426,13 @@ static int rtw_cfg80211_set_probe_req_wpsp2pie(struct rtw_adapter *padapter,
>  				pmlmepriv->wps_probe_req_ie = NULL;
>  			}
>  
> -			pmlmepriv->wps_probe_req_ie =
> -				kmalloc(wps_ielen, GFP_KERNEL);
> +			pmlmepriv->wps_probe_req_ie = kmemdup(wps_ie,
> +							wps_ielen, GFP_KERNEL);
>  			if (pmlmepriv->wps_probe_req_ie == NULL) {
>  				DBG_8723A("%s()-%d: kmalloc() ERROR!\n",
>  					  __func__, __LINE__);
>  				return -EINVAL;
>  			}
> -			memcpy(pmlmepriv->wps_probe_req_ie, wps_ie, wps_ielen);
>  			pmlmepriv->wps_probe_req_ie_len = wps_ielen;
>  		}
>  	}
> @@ -1697,12 +1696,11 @@ static int rtw_cfg80211_set_wpa_ie(struct rtw_adapter *padapter, const u8 *pie,
>  		ret = -EINVAL;
>  		goto exit;
>  	}
> -	buf = kzalloc(ielen, GFP_KERNEL);
> +	buf = kmemdup(pie, ielen, GFP_KERNEL);
>  	if (buf == NULL) {
>  		ret = -ENOMEM;
>  		goto exit;
>  	}
> -	memcpy(buf, pie, ielen);
>  
>  	/* dump */
>  	DBG_8723A("set wpa_ie(length:%zu):\n", ielen);
> @@ -3178,14 +3176,13 @@ static int rtw_cfg80211_set_beacon_wpsp2pie(struct net_device *ndev, char *buf,
>  				pmlmepriv->wps_beacon_ie = NULL;
>  			}
>  
> -			pmlmepriv->wps_beacon_ie =
> -				kmalloc(wps_ielen, GFP_KERNEL);
> +			pmlmepriv->wps_beacon_ie = kmemdup(wps_ie, wps_ielen,
> +							   GFP_KERNEL);
>  			if (pmlmepriv->wps_beacon_ie == NULL) {
>  				DBG_8723A("%s()-%d: kmalloc() ERROR!\n",
>  					  __func__, __LINE__);
>  				return -EINVAL;
>  			}
> -			memcpy(pmlmepriv->wps_beacon_ie, wps_ie, wps_ielen);
>  			pmlmepriv->wps_beacon_ie_len = wps_ielen;
>  
>  #ifdef CONFIG_8723AU_AP_MODE
> @@ -3270,14 +3267,13 @@ static int rtw_cfg80211_set_assoc_resp_wpsp2pie(struct net_device *net,
>  			pmlmepriv->wps_assoc_resp_ie = NULL;
>  		}
>  
> -		pmlmepriv->wps_assoc_resp_ie = kmalloc(len, GFP_KERNEL);
> +		pmlmepriv->wps_assoc_resp_ie = kmemdup(buf, len, GFP_KERNEL);
>  		if (pmlmepriv->wps_assoc_resp_ie == NULL) {
>  			DBG_8723A("%s()-%d: kmalloc() ERROR!\n",
>  				  __func__, __LINE__);
>  			return -EINVAL;
>  
>  		}
> -		memcpy(pmlmepriv->wps_assoc_resp_ie, buf, len);
>  		pmlmepriv->wps_assoc_resp_ie_len = len;
>  	}
>  
