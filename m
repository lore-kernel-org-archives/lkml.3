Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaGaSrT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 14:47:19 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:35498 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952AbaGaSrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 14:47:17 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>
CC: "heiko@sntech.de" <heiko@sntech.de>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>
Subject: RE: [PATCH v2 2/2] usb: dwc2: add dr_mode support for dwc2
Thread-Topic: [PATCH v2 2/2] usb: dwc2: add dr_mode support for dwc2
Thread-Index: AQHPrFusUE8wWYml/kewBklC7kcBUJu6hlwA
Date: Thu, 31 Jul 2014 18:47:13 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C3424@US01WEMBX2.internal.synopsys.com>
References: <1406766558-8156-1-git-send-email-kever.yang@rock-chips.com>
 <1406768764-9684-1-git-send-email-kever.yang@rock-chips.com>
In-Reply-To: <1406768764-9684-1-git-send-email-kever.yang@rock-chips.com>
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

> From: Kever Yang [mailto:kever.yang@rock-chips.com]
> Sent: Wednesday, July 30, 2014 6:06 PM
> 
> Some devices with A female host port and without use of usb_id pin
> will need this for the otg controller works as device role
> during firmware period and works as host role in rich os.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> 
> ---
> 
> Changes in v2:
> - put spaces around '+' operator
> - expand the comment for dr_mode
> - handle dr_mode is USB_DR_MODE_OTG
> 
>  drivers/usb/dwc2/core.c     |   18 ++++++++++++++++++
>  drivers/usb/dwc2/core.h     |    5 +++++
>  drivers/usb/dwc2/platform.c |    4 ++++
>  3 files changed, 27 insertions(+)
> 
> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> index 27d2c9b..738bec2 100644
> --- a/drivers/usb/dwc2/core.c
> +++ b/drivers/usb/dwc2/core.c
> @@ -118,6 +118,7 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>  {
>  	u32 greset;
>  	int count = 0;
> +	u32 gusbcfg;
> 
>  	dev_vdbg(hsotg->dev, "%s()\n", __func__);
> 
> @@ -148,6 +149,23 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>  		}
>  	} while (greset & GRSTCTL_CSFTRST);
> 
> +	if (hsotg->dr_mode == USB_DR_MODE_HOST) {
> +		gusbcfg = readl(hsotg->regs + GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
> +		gusbcfg |= GUSBCFG_FORCEHOSTMODE;
> +		writel(gusbcfg, hsotg->regs + GUSBCFG);
> +	} else if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
> +		gusbcfg = readl(hsotg->regs + GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
> +		gusbcfg |= GUSBCFG_FORCEDEVMODE;
> +		writel(gusbcfg, hsotg->regs + GUSBCFG);
> +	} else if (hsotg->dr_mode == USB_DR_MODE_OTG) {
> +		gusbcfg = readl(hsotg->regs + GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
> +		gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
> +		writel(gusbcfg, hsotg->regs + GUSBCFG);
> +	}
> +
>  	/*
>  	 * NOTE: This long sleep is _very_ important, otherwise the core will
>  	 * not stay in host mode after a connector ID change!
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index 1efd10c..a34681c 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -501,6 +501,10 @@ struct dwc2_hw_params {
>   *                      a_peripheral and b_device=>b_host) this may not match
>   *                      the core, but allows the software to determine
>   *                      transitions
> + * @dr_mode:            Requested mode of operation, one of following:
> + *                      - USB_DR_MODE_PERIPHERAL
> + *                      - USB_DR_MODE_HOST
> + *                      - USB_DR_MODE_OTG
>   * @queuing_high_bandwidth: True if multiple packets of a high-bandwidth
>   *                      transfer are in process of being queued
>   * @srp_success:        Stores status of SRP request in the case of a FS PHY
> @@ -592,6 +596,7 @@ struct dwc2_hsotg {
>  	/** Params to actually use */
>  	struct dwc2_core_params *core_params;
>  	enum usb_otg_state op_state;
> +	enum usb_dr_mode        dr_mode;

Can you please fix the odd spacing here? Once you do that, you can add
my acked-by.

-- 
Paul

