Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaJaR6d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:58:33 -0400
Received: from us01smtprelay-2.synopsys.com ([198.182.44.111]:56984 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbaJaR6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:58:32 -0400
From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>
To: Kever Yang <kever.yang@rock-chips.com>
CC: Dinh Nguyen <dinguyen@opensource.altera.com>, Felipe Balbi <balbi@ti.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "lyz@rock-chips.com" <lyz@rock-chips.com>,
        "wulf@rock-chips.com" <wulf@rock-chips.com>,
        "jwerner@chromium.org" <jwerner@chromium.org>,
        "linux-rockchip@lists.infradead.org" 
	<linux-rockchip@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] usb: dwc2: add bus suspend/resume for dwc2
Thread-Topic: [PATCH] usb: dwc2: add bus suspend/resume for dwc2
Thread-Index: AQHP9RNuYsjYHEYyNUqk7nrh3VO5cZxKfKiQ
Date: Fri, 31 Oct 2014 17:58:13 +0000
Message-ID: <A2CA0424C0A6F04399FB9E1CD98E0304844E7ED5@US01WEMBX2.internal.synopsys.com>
References: <1414764171-11110-1-git-send-email-kever.yang@rock-chips.com>
In-Reply-To: <1414764171-11110-1-git-send-email-kever.yang@rock-chips.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.9.64.240]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Kever Yang [mailto:kever.yang@gmail.com] On Behalf Of Kever Yang
> Sent: Friday, October 31, 2014 7:03 AM
> 
> This patch adds suspend/resume for dwc2 hcd controller.
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
>  drivers/usb/dwc2/hcd.c | 74 ++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 63 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> index fa49c72..df68449 100644
> --- a/drivers/usb/dwc2/hcd.c
> +++ b/drivers/usb/dwc2/hcd.c
> @@ -1473,6 +1473,29 @@ static void dwc2_port_suspend(struct dwc2_hsotg *hsotg, u16 windex)
>  	}
>  }
> 
> +static void dwc2_port_resume(struct dwc2_hsotg *hsotg)
> +{
> +	u32 hprt0;
> +
> +	/* After clear the Stop PHY clock bit, we should wait for a moment
> +	 * for PLL work stable with clock output.
> +	 */
> +	writel(0, hsotg->regs + PCGCTL);
> +	usleep_range(2000, 4000);
> +
> +	hprt0 = dwc2_read_hprt0(hsotg);
> +	hprt0 |= HPRT0_RES;
> +	writel(hprt0, hsotg->regs + HPRT0);
> +	hprt0 &= ~HPRT0_SUSP;
> +	/* according to USB2.0 Spec 7.1.7.7, the host most send the resume
> +	 * signal for at least 20ms
> +	 */
> +	usleep_range(20000, 25000);
> +
> +	hprt0 &= ~HPRT0_RES;
> +	writel(hprt0, hsotg->regs + HPRT0);
> +}
> +
>  /* Handles hub class-specific requests */
>  static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
>  				u16 wvalue, u16 windex, char *buf, u16 wlength)
> @@ -1518,17 +1541,7 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
>  		case USB_PORT_FEAT_SUSPEND:
>  			dev_dbg(hsotg->dev,
>  				"ClearPortFeature USB_PORT_FEAT_SUSPEND\n");
> -			writel(0, hsotg->regs + PCGCTL);
> -			usleep_range(20000, 40000);
> -
> -			hprt0 = dwc2_read_hprt0(hsotg);
> -			hprt0 |= HPRT0_RES;
> -			writel(hprt0, hsotg->regs + HPRT0);
> -			hprt0 &= ~HPRT0_SUSP;
> -			usleep_range(100000, 150000);
> -
> -			hprt0 &= ~HPRT0_RES;
> -			writel(hprt0, hsotg->regs + HPRT0);
> +			dwc2_port_resume(hsotg);
>  			break;
> 
>  		case USB_PORT_FEAT_POWER:
> @@ -2301,6 +2314,42 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
>  	usleep_range(1000, 3000);
>  }
> 
> +static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
> +{
> +	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +	u32 hprt0;
> +
> +	if (hsotg->op_state != OTG_STATE_B_HOST)
> +		return 0;
> +
> +	if (hsotg->lx_state != DWC2_L0)
> +		return 0;
> +
> +	hprt0 = dwc2_read_hprt0(hsotg);
> +	if (hprt0 & HPRT0_CONNSTS)
> +		dwc2_port_suspend(hsotg, 1);
> +
> +	return 0;
> +}
> +
> +static int _dwc2_hcd_resume(struct usb_hcd *hcd)
> +{
> +	struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +	u32 hprt0;
> +
> +	if (hsotg->op_state != OTG_STATE_B_HOST)
> +		return 0;
> +
> +	if (hsotg->lx_state != DWC2_L2)
> +		return 0;
> +
> +	hprt0 = dwc2_read_hprt0(hsotg);
> +	if ((hprt0 | HPRT0_CONNSTS) && (hprt0 | HPRT0_SUSP))

This isn't right, the condition will always be true.

Per your previous email, you are not able to test this because your
platform does not support suspend/resume yet, is that right? I don't
want to apply any untested patches to the driver.

-- 
Paul

