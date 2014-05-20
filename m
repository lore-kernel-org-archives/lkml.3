Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549AbaETX0y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 19:26:54 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:65533 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbaETX0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 19:26:53 -0400
Message-ID: <537BE4BB.4010308@lwfinger.net>
Date: Tue, 20 May 2014 18:26:51 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Manu Gupta <manugupt1@gmail.com>, Josh Triplett <josh@joshtriplett.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8188eu: os_dep: usb_intf.c:  Fix for possible
 null pointer dereference
References: <1400621477-7603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1400621477-7603-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 04:31 PM, Rickard Strandqvist wrote:
> There is otherwise a risk of a possible null pointer dereference.
>
> Was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   drivers/staging/rtl8188eu/os_dep/usb_intf.c |  127 ++++++++++++++-------------
>   1 file changed, 66 insertions(+), 61 deletions(-)

Although cppcheck's analysis is correct, pointer padapter can never be null in 
any of these routines. In routine rtw_drv_init(), rtw_usb_if1_init() is called 
to allocate memory for struct adapter for the driver. If that fails, none of 
these other routines will ever be called as the driver will not be loaded.

If it is deemed better to fill the code with needless tests because some static 
checker points out a place like this, that is OK with me, but I do not see the 
point.

Larry

>
> diff --git a/drivers/staging/rtl8188eu/os_dep/usb_intf.c b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> index 2e49cd5..425b955 100644
> --- a/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> +++ b/drivers/staging/rtl8188eu/os_dep/usb_intf.c
> @@ -384,9 +384,16 @@ static void process_spec_devid(const struct usb_device_id *pdid)
>
>   int rtw_hw_suspend(struct adapter *padapter)
>   {
> -	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
> -	struct net_device *pnetdev = padapter->pnetdev;
> +	struct pwrctrl_priv *pwrpriv;
> +	struct net_device *pnetdev;
>
> +	if (!padapter)  {
> +		goto error_exit;
> +	}
> +
> +	/* system suspend */
> +	pwrpriv = &padapter->pwrctrlpriv;
> +	pnetdev = padapter->pnetdev;
>
>   	if ((!padapter->bup) || (padapter->bDriverStopped) ||
>   	    (padapter->bSurpriseRemoved)) {
> @@ -396,49 +403,46 @@ int rtw_hw_suspend(struct adapter *padapter)
>   		goto error_exit;
>   	}
>
> -	if (padapter) { /* system suspend */
> -		LeaveAllPowerSaveMode(padapter);
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
>   		}
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
>   	return 0;
>
>   error_exit:
> @@ -448,40 +452,41 @@ error_exit:
>
>   int rtw_hw_resume(struct adapter *padapter)
>   {
> -	struct pwrctrl_priv *pwrpriv = &padapter->pwrctrlpriv;
> -	struct net_device *pnetdev = padapter->pnetdev;
> -
> +	struct pwrctrl_priv *pwrpriv;
> +	struct net_device *pnetdev;
>
> -	if (padapter) { /* system resume */
> -		DBG_88E("==> rtw_hw_resume\n");
> -		_enter_pwrlock(&pwrpriv->lock);
> -		pwrpriv->bips_processing = true;
> -		rtw_reset_drv_sw(padapter);
> +	if (!padapter) {
> +		goto error_exit;
> +	}
> +	/* system resume */
> +	pwrpriv = &padapter->pwrctrlpriv;
> +	pnetdev = padapter->pnetdev;
>
> -		if (pm_netdev_open(pnetdev, false) != 0) {
> -			_exit_pwrlock(&pwrpriv->lock);
> -			goto error_exit;
> -		}
> +	DBG_88E("==> rtw_hw_resume\n");
> +	_enter_pwrlock(&pwrpriv->lock);
> +	pwrpriv->bips_processing = true;
> +	rtw_reset_drv_sw(padapter);
>
> -		netif_device_attach(pnetdev);
> -		netif_carrier_on(pnetdev);
> +	if (pm_netdev_open(pnetdev, false) != 0) {
> +		_exit_pwrlock(&pwrpriv->lock);
> +		goto error_exit;
> +	}
>
> -		if (!netif_queue_stopped(pnetdev))
> -			netif_start_queue(pnetdev);
> -		else
> -			netif_wake_queue(pnetdev);
> +	netif_device_attach(pnetdev);
> +	netif_carrier_on(pnetdev);
>
> -		pwrpriv->bkeepfwalive = false;
> -		pwrpriv->brfoffbyhw = false;
> +	if (!netif_queue_stopped(pnetdev))
> +		netif_start_queue(pnetdev);
> +	else
> +		netif_wake_queue(pnetdev);
>
> -		pwrpriv->rf_pwrstate = rf_on;
> -		pwrpriv->bips_processing = false;
> +	pwrpriv->bkeepfwalive = false;
> +	pwrpriv->brfoffbyhw = false;
>
> -		_exit_pwrlock(&pwrpriv->lock);
> -	} else {
> -		goto error_exit;
> -	}
> +	pwrpriv->rf_pwrstate = rf_on;
> +	pwrpriv->bips_processing = false;
>
> +	_exit_pwrlock(&pwrpriv->lock);
>
>   	return 0;
>   error_exit:
>

