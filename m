Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422688AbaKNU6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 15:58:12 -0500
Received: from smtprelay4.synopsys.com ([198.182.44.111]:50835 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161200AbaKNU6K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 15:58:10 -0500
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
Subject: RE: [PATCHv7 7/8] usb: dwc2: move usb_disabled() call to host
 driver only
Thread-Topic: [PATCHv7 7/8] usb: dwc2: move usb_disabled() call to host
 driver only
Thread-Index: AQHP/dN4r6syP3bW60qIHFvIYWVYGpxgnusg
Date: Fri, 14 Nov 2014 20:58:08 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844EBCF2@US01WEMBX2.internal.synopsys.com>
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com>
 <1415726020-19238-8-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1415726020-19238-8-git-send-email-dinguyen@opensource.altera.com>
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
> Sent: Tuesday, November 11, 2014 9:14 AM
> 
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
> 
> Since platform.c will get built for both Host and Gadget, if we leave the
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
> index fa60f4a..755e16b 100644
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
> index 3552602..57eb8a3 100644
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

This patch also fixes a minor buglet, in that we were missing the
usb_disabled() check in pci.c.

Acked-by: Paul Zimmerman <paulz@synopsys.com>

