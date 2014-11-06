Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaKFMEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:04:24 -0500
Received: from afflict.kos.to ([92.243.29.197]:55599 "EHLO afflict.kos.to"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676AbaKFMEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:04:21 -0500
Date: Thu, 6 Nov 2014 14:04:16 +0200
From: Riku Voipio <riku.voipio@iki.fi>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: Riku Voipio <riku.voipio@iki.fi>, "Stam, Michel [FINT]" <M.Stam@fugro.nl>,
        freddy@asix.com.tw, davem@davemloft.net, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: "asix: Don't reset PHY on if_up for ASIX 88772" breaks net on
 arndale platform
Message-ID: <20141106120416.GA20162@afflict.kos.to>
References: <20141104072236.GA559@afflict.kos.to>
 <C89EFD3CD56F64468D3D206D683A8D2203985F49@ldam-msx2.fugro-nl.local>
 <20141104094336.GA3145@afflict.kos.to>
 <C89EFD3CD56F64468D3D206D683A8D2203985FA9@ldam-msx2.fugro-nl.local>
 <20141104200914.GN23178@opensource.wolfsonmicro.com>
 <C89EFD3CD56F64468D3D206D683A8D22039FFC5F@ldam-msx2.fugro-nl.local>
 <20141105150258.GR23178@opensource.wolfsonmicro.com>
 <20141106090651.GA19109@afflict.kos.to>
 <20141106100104.GS23178@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106100104.GS23178@opensource.wolfsonmicro.com>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2014 at 10:01:04AM +0000, Charles Keepax wrote:
> On Thu, Nov 06, 2014 at 11:06:51AM +0200, Riku Voipio wrote:
> > The asix on arndale comes semi-configured from u-boot, which I guess is
> > not the state kernel expects it to come in. At least in my case where
> > I use tftp from u-boot to load my kernel.
> > 
> > So probably the full reset is needed here to make the asix chip come
> > to a truly pristine state.
> > 
> > The commit that Michel partially reverted (by returning to use
> > ax88772_link_reset instead of ax88772_reset), indicates that a strong reset
> > is needed for suspend/resume as well:
 
> Ok I think I have cracked this one. I am pretty sure you are
> right that the USB comes to us in a strange state and needs
> a full reset, but that only needs to happen once when the driver
> is bound in. So there is some code in ax88772_bind that appears
> to try to reset the device but does a lot less than ax88772_reset
> and I think that must be the problem. Applying the following on
> top of the patch we have been debating I think will make
> everything work for all of us:

The patch below on top of 3.18-rc3 fixes arndale network for me.

Tested-by: Riku Voipio <riku.voipio@linaro.org>

> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -465,19 +465,7 @@ static int ax88772_bind(struct usbnet *dev,
> struct usb_interface *in
>                 return ret;
>         }
> 
> -       ret = asix_sw_reset(dev, AX_SWRESET_IPPD | AX_SWRESET_PRL);
> -       if (ret < 0)
> -               return ret;
> -
> -       msleep(150);
> -
> -       ret = asix_sw_reset(dev, AX_SWRESET_CLEAR);
> -       if (ret < 0)
> -               return ret;
> -
> -       msleep(150);
> -
> -       ret = asix_sw_reset(dev, embd_phy ? AX_SWRESET_IPRL : AX_SWRESET_PRTE);
> +       ax88772_reset(dev);
> 
> If you guys could test that and let me know how you get on I will
> send in a proper patch if it looks good.
> 
> Thanks,
> Charles
