Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab3F1I6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:58:17 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64577 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3F1I6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:58:14 -0400
Date: Fri, 28 Jun 2013 10:58:05 +0200
From: Richard GENOUD <richard.genoud@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: rtl8192cu: slow path warning
Message-ID: <20130628085804.GA27866@lnx-rg>
References: <20130611123814.GA9854@lnx-rg>
 <20130626142241.GA13107@lnx-rg>
 <51CB0E9C.50408@lwfinger.net>
 <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
 <51CC8284.9070301@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51CC8284.9070301@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On [jeu., 27.06.2013 13:20:52], Larry Finger wrote:
> On 06/27/2013 02:33 AM, Richard Genoud wrote:
> >Yes, of course, you can add my
> >Reported-by: Richard Genoud <richard.genoud@gmail.com>
> >
> >But the patch doesn't compile on my platform ( since I'm on ARM, I
> >haven't got a PCI bus, so rtlwifi/pci.c is not compiled ) :
> >
> >ERROR: "rtl_lps_change_work_callback"
> >[drivers/net/wireless/rtlwifi/rtlwifi.ko] undefined!
> >
> >
> >Best regards,
> >Richard.
> >
> >PS: duckducking the warning, I found this automated report also :
> >https://retrace.fedoraproject.org/faf/reports/142038/
> 
> A revised patch for the warning is attached. The fix relatively
> simple and the only difference between this one and the earlier
> version is that routine rtl_lps_change_work_callback() was moved
> from pci.c to ps.c. As a result, it will be available for ARM and
> other architectures without a PCI bus.
> 
> Larry
> 
> 

> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/pci.c
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/pci.c
> @@ -1008,19 +1008,6 @@ static void _rtl_pci_prepare_bcn_tasklet
>  	return;
>  }
>  
> -static void rtl_lps_change_work_callback(struct work_struct *work)
> -{
> -	struct rtl_works *rtlworks =
> -	    container_of(work, struct rtl_works, lps_change_work);
> -	struct ieee80211_hw *hw = rtlworks->hw;
> -	struct rtl_priv *rtlpriv = rtl_priv(hw);
> -
> -	if (rtlpriv->enter_ps)
> -		rtl_lps_enter(hw);
> -	else
> -		rtl_lps_leave(hw);
> -}
> -
>  static void _rtl_pci_init_trx_var(struct ieee80211_hw *hw)
>  {
>  	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/ps.h
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/ps.h
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/ps.h
> @@ -49,5 +49,6 @@ void rtl_swlps_rf_awake(struct ieee80211
>  void rtl_swlps_rf_sleep(struct ieee80211_hw *hw);
>  void rtl_p2p_ps_cmd(struct ieee80211_hw *hw, u8 p2p_ps_state);
>  void rtl_p2p_info(struct ieee80211_hw *hw, void *data, unsigned int len);
> +void rtl_lps_change_work_callback(struct work_struct *work);
>  
>  #endif
> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/usb.c
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/usb.c
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/usb.c
> @@ -1070,6 +1070,8 @@ int rtl_usb_probe(struct usb_interface *
>  	spin_lock_init(&rtlpriv->locks.usb_lock);
>  	INIT_WORK(&rtlpriv->works.fill_h2c_cmd,
>  		  rtl_fill_h2c_cmd_work_callback);
> +	INIT_WORK(&rtlpriv->works.lps_change_work,
> +		  rtl_lps_change_work_callback);
>  
>  	rtlpriv->usb_data_index = 0;
>  	init_completion(&rtlpriv->firmware_loading_complete);
> Index: wireless-testing-save/drivers/net/wireless/rtlwifi/ps.c
> ===================================================================
> --- wireless-testing-save.orig/drivers/net/wireless/rtlwifi/ps.c
> +++ wireless-testing-save/drivers/net/wireless/rtlwifi/ps.c
> @@ -611,6 +611,18 @@ void rtl_swlps_rf_sleep(struct ieee80211
>  			MSECS(sleep_intv * mac->vif->bss_conf.beacon_int - 40));
>  }
>  
> +void rtl_lps_change_work_callback(struct work_struct *work)
> +{
> +	struct rtl_works *rtlworks =
> +	    container_of(work, struct rtl_works, lps_change_work);
> +	struct ieee80211_hw *hw = rtlworks->hw;
> +	struct rtl_priv *rtlpriv = rtl_priv(hw);
> +
> +	if (rtlpriv->enter_ps)
> +		rtl_lps_enter(hw);
> +	else
> +		rtl_lps_leave(hw);
> +}
>  
>  void rtl_swlps_wq_callback(void *data)
>  {

Tested the patch on 3.10-rc7, ARM at91sam9g35, usb key TP-link
TL-WN725N.
I haven't seen the WARNING any more.
Tests done: (DHCP request)
client with no security
client WEP
client WPA
AP with no security
AP WEP
AP+WAP test failed (bust it was like that before the patch also)

Tested-by: Richard Genoud <richard.genoud@gmail.com>

