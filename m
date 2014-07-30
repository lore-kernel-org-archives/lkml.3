Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755713AbaG3THB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 15:07:01 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:46514 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410AbaG3TG7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 15:06:59 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>,
        "heiko@sntech.de" <heiko@sntech.de>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "galak@codeaurora.org" <galak@codeaurora.org>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "Paul.Zimmerman@synopsys.com" <Paul.Zimmerman@synopsys.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "kishon@ti.com" <kishon@ti.com>, "balbi@ti.com" <balbi@ti.com>
CC: "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "olof@lixom.net" <olof@lixom.net>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>
Subject: RE: [PATCH 4/4] usb: dwc2: add dr_mode support for dwc2
Thread-Topic: [PATCH 4/4] usb: dwc2: add dr_mode support for dwc2
Thread-Index: AQHPq5aYNGs/Zwzf4UCvK7bGjMkrNZu4+hTQ
Date: Wed, 30 Jul 2014 19:05:51 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844C2FA3@US01WEMBX2.internal.synopsys.com>
References: <1406683873-18194-1-git-send-email-kever.yang@rock-chips.com>
 <1406684129-18352-1-git-send-email-kever.yang@rock-chips.com>
In-Reply-To: <1406684129-18352-1-git-send-email-kever.yang@rock-chips.com>
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
> Sent: Tuesday, July 29, 2014 6:35 PM
> 
> Some devices with A female host port and without use of usb_id pin
> will need this for the otg controller works as device role
> during firmware period and works as host role in rich os.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>  drivers/usb/dwc2/core.c     |   13 +++++++++++++
>  drivers/usb/dwc2/core.h     |    2 ++
>  drivers/usb/dwc2/platform.c |    4 ++++
>  3 files changed, 19 insertions(+)
> 
> diff --git a/drivers/usb/dwc2/core.c b/drivers/usb/dwc2/core.c
> index 27d2c9b..6688951 100644
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
> @@ -148,6 +149,18 @@ static int dwc2_core_reset(struct dwc2_hsotg *hsotg)
>  		}
>  	} while (greset & GRSTCTL_CSFTRST);
> 
> +	if (hsotg->dr_mode == USB_DR_MODE_HOST) {
> +		gusbcfg = readl(hsotg->regs+GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEDEVMODE;
> +		gusbcfg |= GUSBCFG_FORCEHOSTMODE;
> +		writel(gusbcfg, hsotg->regs+GUSBCFG);
> +	} else if (hsotg->dr_mode == USB_DR_MODE_PERIPHERAL) {
> +		gusbcfg = readl(hsotg->regs+GUSBCFG);
> +		gusbcfg &= ~GUSBCFG_FORCEHOSTMODE;
> +		gusbcfg |= GUSBCFG_FORCEDEVMODE;
> +		writel(gusbcfg, hsotg->regs+GUSBCFG);
> +	}

Please put spaces around the '+' operator. Did you run these patches
through checkpatch?

> +
>  	/*
>  	 * NOTE: This long sleep is _very_ important, otherwise the core will
>  	 * not stay in host mode after a connector ID change!
> diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
> index 1efd10c..9fe960b 100644
> --- a/drivers/usb/dwc2/core.h
> +++ b/drivers/usb/dwc2/core.h
> @@ -501,6 +501,7 @@ struct dwc2_hw_params {
>   *                      a_peripheral and b_device=>b_host) this may not match
>   *                      the core, but allows the software to determine
>   *                      transitions
> + * @dr_mode:            requested mode of operation

Please expand this comment, e.g.
"Requested mode of operation (host/peripheral/dual-role)"

-- 
Paul

