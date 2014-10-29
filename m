Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaJ2B0i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 21:26:38 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:37241 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056AbaJ2B0g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 21:26:36 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: "dinguyen@opensource.altera.com" <dinguyen@opensource.altera.com>,
        "balbi@ti.com" <balbi@ti.com>
CC: "dinh.linux@gmail.com" <dinh.linux@gmail.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "matthijs@stdin.nl" <matthijs@stdin.nl>,
        "r.baldyga@samsung.com" <r.baldyga@samsung.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "sachin.kamat@linaro.org" <sachin.kamat@linaro.org>,
        "ben-linux@fluff.org" <ben-linux@fluff.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "kever.yang@rock-chips.com" <kever.yang@rock-chips.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCHv6 8/8] usb: dwc2: move usb_disabled() call to host
 driver only
Thread-Topic: [PATCHv6 8/8] usb: dwc2: move usb_disabled() call to host
 driver only
Thread-Index: AQHP8wcWvZzyL/KB1k+yAGSg60g/IpxGR3iA
Date: Wed, 29 Oct 2014 01:26:27 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E6ACC@US01WEMBX2.internal.synopsys.com>
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com>
 <1414538749-14735-9-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1414538749-14735-9-git-send-email-dinguyen@opensource.altera.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.241]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: dinguyen@opensource.altera.com [mailto:dinguyen@opensource.altera.com]
> Sent: Tuesday, October 28, 2014 4:26 PM
> 
> Now that platform.c will get built for both Host and Gadget, if we leave the
> usb_disabled() call in platform.c, it results in the following build error
> when (!USB && USB_GADGET) condition is met.
> 
> ERROR: "usb_disabled" [drivers/usb/dwc2/dwc2_platform.ko] undefined!
> 
> Since usb_disabled() is mostly used to disable USB host functionality, move
> the call the host portion for the DWC2 driver.
> 
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> ---
>  drivers/usb/dwc2/hcd.c      | 3 +++
>  drivers/usb/dwc2/platform.c | 3 ---
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> index fa49c72..b741997 100644
> --- a/drivers/usb/dwc2/hcd.c
> +++ b/drivers/usb/dwc2/hcd.c
> @@ -2780,6 +2780,9 @@ int dwc2_hcd_init(struct dwc2_hsotg *hsotg, int irq,
>  	int i, num_channels;
>  	int retval;
> 
> +	if (usb_disabled())
> +		return -ENODEV;
> +
>  	dev_dbg(hsotg->dev, "DWC OTG HCD INIT\n");
> 
>  	/* Detect config values from hardware */
> diff --git a/drivers/usb/dwc2/platform.c b/drivers/usb/dwc2/platform.c
> index 77c8417..123cf54 100644
> --- a/drivers/usb/dwc2/platform.c
> +++ b/drivers/usb/dwc2/platform.c
> @@ -157,9 +157,6 @@ static int dwc2_driver_probe(struct platform_device *dev)
>  	int retval;
>  	int irq;
> 
> -	if (usb_disabled())
> -		return -ENODEV;
> -
>  	match = of_match_device(dwc2_of_match_table, &dev->dev);
>  	if (match && match->data) {
>  		params = match->data;

I'm confused. You are saying the build is broken until patch 8/8 is
applied? As always, that is not acceptable. You need to fix the
breakage at the point where it was introduced, not leave it broken
until the last patch in the series.

-- 
Paul

