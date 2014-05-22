Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235AbaEVVQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:16:27 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:43402 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEVVQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:16:26 -0400
X-Originating-IP: 173.246.103.110
Date: Thu, 22 May 2014 14:16:17 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Manu Gupta <manugupt1@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c:  Fix to remove
 null pointer checks that could never happen
Message-ID: <20140522211617.GB11775@jtriplet-mobl1>
References: <1400788682-10787-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400788682-10787-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 09:58:02PM +0200, Rickard Strandqvist wrote:
> Removal of null pointer checks that could never happen
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/rtl8188eu/os_dep/usb_intf.c |  110 +++++++++++++--------------
>  1 file changed, 52 insertions(+), 58 deletions(-)
> 
> diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> index 2e49cd5..3454e1b 100644
> --- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> +++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> @@ -396,49 +396,47 @@ int rtw_hw_suspend(struct adapter *padapter)
>  		goto error_exit;
>  	}
>  
> -	if (padapter) { /* system suspend */
> -		LeaveAllPowerSaveMode(padapter);
> +	/* system suspend */
> +	LeaveAllPowerSaveMode(padapter);
>  
> -		DBG_88E("==> rtw_hw_suspend\n");
> -		_enter_pwrlock(&pwrpriv->lock);
> -		pwrpriv->bips_processing = true;
> -		/* s1. */
> -		if (pnetdev) {
> -			netif_carrier_off(pnetdev);
> -			rtw_netif_stop_queue(pnetdev);
> -		}
> +	DBG_88E("==> rtw_hw_suspend\n");
> +	_enter_pwrlock(&pwrpriv->lock);
> +	pwrpriv->bips_processing = true;
> +	/* s1. */
> +	if (pnetdev) {
> +		netif_carrier_off(pnetdev);
> +		rtw_netif_stop_queue(pnetdev);
> +	}
>  
> -		/* s2. */
> -		rtw_disassoc_cmd(padapter, 500, false);
> +	/* s2. */
> +	rtw_disassoc_cmd(padapter, 500, false);
>  
> -		/* s2-2.  indicate disconnect to os */
> -		{
> -			struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
> +	/* s2-2.  indicate disconnect to os */
> +	{
> +		struct	mlme_priv *pmlmepriv = &padapter->mlmepriv;
>  
> -			if (check_fwstate(pmlmepriv, _FW_LINKED)) {
> -				_clr_fwstate_(pmlmepriv, _FW_LINKED);
> +		if (check_fwstate(pmlmepriv, _FW_LINKED)) {
> +			_clr_fwstate_(pmlmepriv, _FW_LINKED);
>  
> -				rtw_led_control(padapter, LED_CTL_NO_LINK);
> +			rtw_led_control(padapter, LED_CTL_NO_LINK);
>  
> -				rtw_os_indicate_disconnect(padapter);
> +			rtw_os_indicate_disconnect(padapter);
>  
> -				/* donnot enqueue cmd */
> -				rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_DISCONNECT, 0);
> -			}
> +			/* donnot enqueue cmd */
> +			rtw_lps_ctrl_wk_cmd(padapter, LPS_CTRL_DISCONNECT, 0);
>  		}
> -		/* s2-3. */
> -		rtw_free_assoc_resources(padapter, 1);
> +	}
> +	/* s2-3. */
> +	rtw_free_assoc_resources(padapter, 1);
>  
> -		/* s2-4. */
> -		rtw_free_network_queue(padapter, true);
> -		rtw_ips_dev_unload(padapter);
> -		pwrpriv->rf_pwrstate = rf_off;
> -		pwrpriv->bips_processing = false;
> +	/* s2-4. */
> +	rtw_free_network_queue(padapter, true);
> +	rtw_ips_dev_unload(padapter);
> +	pwrpriv->rf_pwrstate = rf_off;
> +	pwrpriv->bips_processing = false;
> +
> +	_exit_pwrlock(&pwrpriv->lock);
>  
> -		_exit_pwrlock(&pwrpriv->lock);
> -	} else {
> -		goto error_exit;
> -	}
>  	return 0;
>  
>  error_exit:
> @@ -452,35 +450,32 @@ int rtw_hw_resume(struct adapter *padapter)
>  	struct net_device *pnetdev = padapter->pnetdev;
>  
>  
> -	if (padapter) { /* system resume */
> -		DBG_88E("==> rtw_hw_resume\n");
> -		_enter_pwrlock(&pwrpriv->lock);
> -		pwrpriv->bips_processing = true;
> -		rtw_reset_drv_sw(padapter);
> +	/* system resume */
> +	DBG_88E("==> rtw_hw_resume\n");
> +	_enter_pwrlock(&pwrpriv->lock);
> +	pwrpriv->bips_processing = true;
> +	rtw_reset_drv_sw(padapter);
>  
> -		if (pm_netdev_open(pnetdev, false) != 0) {
> -			_exit_pwrlock(&pwrpriv->lock);
> -			goto error_exit;
> -		}
> +	if (pm_netdev_open(pnetdev, false) != 0) {
> +		_exit_pwrlock(&pwrpriv->lock);
> +		goto error_exit;
> +	}
>  
> -		netif_device_attach(pnetdev);
> -		netif_carrier_on(pnetdev);
> +	netif_device_attach(pnetdev);
> +	netif_carrier_on(pnetdev);
>  
> -		if (!netif_queue_stopped(pnetdev))
> -			netif_start_queue(pnetdev);
> -		else
> -			netif_wake_queue(pnetdev);
> +	if (!netif_queue_stopped(pnetdev))
> +		netif_start_queue(pnetdev);
> +	else
> +		netif_wake_queue(pnetdev);
>  
> -		pwrpriv->bkeepfwalive = false;
> -		pwrpriv->brfoffbyhw = false;
> +	pwrpriv->bkeepfwalive = false;
> +	pwrpriv->brfoffbyhw = false;
>  
> -		pwrpriv->rf_pwrstate = rf_on;
> -		pwrpriv->bips_processing = false;
> +	pwrpriv->rf_pwrstate = rf_on;
> +	pwrpriv->bips_processing = false;
>  
> -		_exit_pwrlock(&pwrpriv->lock);
> -	} else {
> -		goto error_exit;
> -	}
> +	_exit_pwrlock(&pwrpriv->lock);
>  
>  
>  	return 0;
> @@ -591,8 +586,7 @@ int rtw_resume_process(struct adapter *padapter)
>  
>  	_enter_pwrlock(&pwrpriv->lock);
>  	rtw_reset_drv_sw(padapter);
> -	if (pwrpriv)
> -		pwrpriv->bkeepfwalive = false;
> +	pwrpriv->bkeepfwalive = false;
>  
>  	DBG_88E("bkeepfwalive(%x)\n", pwrpriv->bkeepfwalive);
>  	if (pm_netdev_open(pnetdev, true) != 0)
> -- 
> 1.7.10.4
> 
