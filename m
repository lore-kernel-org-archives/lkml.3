Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbbAJXwE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 18:52:04 -0500
Received: from us01smtprelay-2.synopsys.com ([198.182.47.9]:35558 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbbAJXwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 18:52:02 -0500
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Yunzhi Li <lyz@rock-chips.com>,
        "Dinh Nguyen (dinguyen@opensource.altera.com)" 
	<dinguyen@opensource.altera.com>
CC: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "jwerner@chromium.org" <jwerner@chromium.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        "zyw@rock-chips.com" <zyw@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>
Subject: RE: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support for
 dwc2 usb controler platform driver.
Thread-Topic: [PATCH v7 3/5] usb: dwc2: add generic PHY framework support
 for dwc2 usb controler platform driver.
Thread-Index: AQHQFh27WKp3IndWekWc7l03cD6hbpy3NGmQgAMESwD///rIMA==
Date: Sat, 10 Jan 2015 23:51:57 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E030484506931@US01WEMBX2.internal.synopsys.com>
References: <1418396413-27937-1-git-send-email-lyz@rock-chips.com>
 <1418396972-32686-1-git-send-email-lyz@rock-chips.com>
 <A2CA0424C0A6F04399FB9E1CD98E03048450635E@US01WEMBX2.internal.synopsys.com>
 <54B14E0E.4070504@rock-chips.com>
In-Reply-To: <54B14E0E.4070504@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.13.184.20]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0ANqQuU012150

> From: Yunzhi Li [mailto:lyz@rock-chips.com]
> Sent: Saturday, January 10, 2015 8:07 AM
> 
> åœ¨ 2015/1/9 10:15, Paul Zimmerman å†™é“:
> >> [...]
> >>   	/*
> >> -	 * Attempt to find a generic PHY, then look for an old style
> >> -	 * USB PHY, finally fall back to pdata
> >> +	 * If platform probe couldn't find a generic PHY or an old style
> >> +	 * USB PHY, fall back to pdata
> >>   	 */
> >> -	phy = devm_phy_get(dev, "usb2-phy");
> >> -	if (IS_ERR(phy)) {
> >> -		uphy = devm_usb_get_phy(dev, USB_PHY_TYPE_USB2);
> >> -		if (IS_ERR(uphy)) {
> >> -			/* Fallback for pdata */
> >> -			plat = dev_get_platdata(dev);
> >> -			if (!plat) {
> >> -				dev_err(dev,
> >> -				"no platform data or transceiver defined\n");
> >> -				return -EPROBE_DEFER;
> >> -			}
> >> -			hsotg->plat = plat;
> >> -		} else
> >> -			hsotg->uphy = uphy;
> >> -	} else {
> >> -		hsotg->phy = phy;
> >> +	if (IS_ERR_OR_NULL(hsotg->phy) && IS_ERR_OR_NULL(hsotg->uphy)) {
> >> +		plat = dev_get_platdata(dev);
> >> +		if (!plat) {
> >> +			dev_err(dev,
> >> +			"no platform data or transceiver defined\n");
> >> +			return -EPROBE_DEFER;
> > Hi Yunzhi,
> >
> > Testing Felipe's testing/next branch on an Altera SOCFPGA platform,
> > the driver never loads because it always returns -EPROBE_DEFER here.
> > Apparently the SOCFPGA platform does not have any platform data
> > defined, because dev_get_platdata() always returns NULL.
> >
> > If I remove the -EPROBE_DEFER return and have it continue on, the
> > driver works. Reverting the patch also makes it work.
>      When I debug this problem, I checked socfpga.dtsi, there is a
> usbphy node defined for each
> dwc2 controller, so I think when running dwc2_driver_probe() uphy =
> devm_usb_get_phy()
> should get a valid usbphy pointer and hsotg->uphy will not be NULL or
> ERROR, then in dwc2_gadget_init()
> it will not return -EPROBE_DEFER. I have no idea about why you meet
> -EPROBE_DEFER, could you please tell
> me what's the return value of devm_usb_get_phy() on your socfpga board ?

I'm away from the hardware right now, but I just found this in a saved
boot log:

[    1.097268] usb_phy_generic soc:usbphy@0: Error requesting RESET GPIO
[    1.097285] usb_phy_generic: probe of soc:usbphy@0 failed with error -2

So that probably explains it. I'll dig into this some more on Monday.

-- 
Paul

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
