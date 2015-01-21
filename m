Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751524AbbAUHi3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 02:38:29 -0500
Received: from mail-ig0-f182.google.com ([209.85.213.182]:37866 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbAUHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 02:38:24 -0500
Date: Wed, 21 Jan 2015 07:38:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Roger Tseng <rogerable@realtek.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>,
        Wei_wang <wei_wang@realsil.com.cn>,
        "micky_ching@realsil.com.cn" <micky_ching@realsil.com.cn>
Subject: Re: [PATCH 1/2] mfd: rtsx_usb: Fix runtime PM deadlock
Message-ID: <20150121073818.GA9258@x1>
References: <1421306085-32254-1-git-send-email-rogerable@realtek.com>
 <1421306085-32254-2-git-send-email-rogerable@realtek.com>
 <20150119094525.GK21886@x1>
 <1421752080.10290.5.camel@debian-rtk5880>
 <20150120160736.GM13701@x1>
 <1421823666.13666.15.camel@debian-rtk5880>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1421823666.13666.15.camel@debian-rtk5880>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jan 2015, Roger Tseng wrote:

> On Tue, 2015-01-20 at 16:07 +0000, Lee Jones wrote:
> > On Tue, 20 Jan 2015, Roger Tseng wrote:
> > 
> > > On Mon, 2015-01-19 at 09:45 +0000, Lee Jones wrote:
> > > > On Thu, 15 Jan 2015, Roger Tseng wrote:
> > > > 
> > > > > sd_set_power_mode() in derived module drivers/mmc/host/rtsx_usb_sdmmc.c
> > > > > acquires dev_mutex and then calls pm_runtime_get_sync() to make sure the
> > > > > device is awake while initializing a newly inserted card. Once it is
> > > > > called during suspending state and explicitly before rtsx_usb_suspend()
> > > > > acquires the same dev_mutex, both routine deadlock and further hang the
> > > > > driver because pm_runtime_get_sync() waits the pending PM operations.
> > > > > 
> > > > > Fix this by using an empty suspend method. mmc_core always turns the
> > > > > LED off after a request is done and thus it is ok to remove the only
> > > > > rtsx_usb_turn_off_led() here.
> > > > > 
> > > > > Cc: <stable@vger.kernel.org> # v3.16+
> > > > > Fixes: 730876be2566 ("mfd: Add realtek USB card reader driver")
> > > > > Signed-off-by: Roger Tseng <rogerable@realtek.com>
> > > > > ---
> > > > >  drivers/mfd/rtsx_usb.c | 9 ---------
> > > > >  1 file changed, 9 deletions(-)
> > > > 
> > > > Applied, thanks.
> > > > 
> > > I'm sorry but build bot from Intel just reported me that I forgot to
> > > delete an unused variable "ucr" between two commits. My bad.
> > > 
> > > Do I have a chance to send v2?
> > 
> > You're lucky I'm in a good mood. ;)
> > 
> > I fixed it already.
> > 
> That's great, thanks! And thus patch 2/2 also needs to be changed
> accordingly.
> 
> By the way, the build bot reported again about an undefined variable
> build error in 2/2(I'm sorry for this again). I put the overall updated
> content of 2/2 here for you if you're going to fix it, or I can also
> re-send it individually.

Please re-send this patch and prefix it with [OVERWRITE].

In future make sure you test your submission thoroughly prior to
sending, as my time is very limited and with all due respect I could
make better use of it than this.

> diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> index 210d1f85679e..ede50244f265 100644
> --- a/drivers/mfd/rtsx_usb.c
> +++ b/drivers/mfd/rtsx_usb.c
> @@ -681,9 +681,27 @@ static void rtsx_usb_disconnect(struct
> usb_interface *intf)
>  #ifdef CONFIG_PM
>  static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t
> message)
>  {
> +	struct rtsx_ucr *ucr =
> +		(struct rtsx_ucr *)usb_get_intfdata(intf);
> +	u16 val = 0;
> +
>  	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
>  			__func__, message.event);
>  
> +	if (PMSG_IS_AUTO(message)) {
> +		if (mutex_trylock(&ucr->dev_mutex)) {
> +			rtsx_usb_get_card_status(ucr, &val);
> +			mutex_unlock(&ucr->dev_mutex);
> +
> +			/* Defer the autosuspend if card exists */
> +			if (val & (SD_CD | MS_CD))
> +				return -EAGAIN;
> +		} else {
> +			/* There is an ongoing operation*/
> +			return -EAGAIN;
> +		}
> +	}
> +
>  	return 0;
>  }
> 
> 
> 
> > > > > diff --git a/drivers/mfd/rtsx_usb.c b/drivers/mfd/rtsx_usb.c
> > > > > index dbdd0faeb6ce..076694126e5d 100644
> > > > > --- a/drivers/mfd/rtsx_usb.c
> > > > > +++ b/drivers/mfd/rtsx_usb.c
> > > > > @@ -687,15 +687,6 @@ static int rtsx_usb_suspend(struct usb_interface *intf, pm_message_t message)
> > > > >  	dev_dbg(&intf->dev, "%s called with pm message 0x%04x\n",
> > > > >  			__func__, message.event);
> > > > >  
> > > > > -	/*
> > > > > -	 * Call to make sure LED is off during suspend to save more power.
> > > > > -	 * It is NOT a permanent state and could be turned on anytime later.
> > > > > -	 * Thus no need to call turn_on when resunming.
> > > > > -	 */
> > > > > -	mutex_lock(&ucr->dev_mutex);
> > > > > -	rtsx_usb_turn_off_led(ucr);
> > > > > -	mutex_unlock(&ucr->dev_mutex);
> > > > > -
> > > > >  	return 0;
> > > > >  }
> > > > >  
> > > > 
> > > 
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
