Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933814AbaJaP0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:26:43 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:59816 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932326AbaJaP0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:26:41 -0400
MIME-Version: 1.0
In-Reply-To: <1414764171-11110-1-git-send-email-kever.yang@rock-chips.com>
References: <1414764171-11110-1-git-send-email-kever.yang@rock-chips.com>
Date: Fri, 31 Oct 2014 16:26:40 +0100
Message-ID: <CABgxDoKnRRtAXn-8neB3Mxu2M11qJokOrnX=Mg2J0TRtxVTYZw@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: add bus suspend/resume for dwc2
From: Romain Perier <romain.perier@gmail.com>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-rockchip@lists.infradead.org, lyz@rock-chips.com,
        jwerner@chromium.org, cf@rock-chips.com, wulf@rock-chips.com,
        Dinh Nguyen <dinguyen@opensource.altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kever,

2014-10-31 15:02 GMT+01:00 Kever Yang <kever.yang@rock-chips.com>:
> This patch adds suspend/resume for dwc2 hcd controller.
>

Could you add a more explicit and detailed message ? It is redundant
with the commit subject and explains almost the same thing.

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
>         }
>  }
>
> +static void dwc2_port_resume(struct dwc2_hsotg *hsotg)
> +{
> +       u32 hprt0;
> +
> +       /* After clear the Stop PHY clock bit, we should wait for a moment
> +        * for PLL work stable with clock output.
> +        */
> +       writel(0, hsotg->regs + PCGCTL);
> +       usleep_range(2000, 4000);
> +
> +       hprt0 = dwc2_read_hprt0(hsotg);
> +       hprt0 |= HPRT0_RES;
> +       writel(hprt0, hsotg->regs + HPRT0);
> +       hprt0 &= ~HPRT0_SUSP;
> +       /* according to USB2.0 Spec 7.1.7.7, the host most send the resume
> +        * signal for at least 20ms
> +        */

Typo here, most => must .

> +       usleep_range(20000, 25000);
> +
> +       hprt0 &= ~HPRT0_RES;
> +       writel(hprt0, hsotg->regs + HPRT0);
> +}
> +
>  /* Handles hub class-specific requests */
>  static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
>                                 u16 wvalue, u16 windex, char *buf, u16 wlength)
> @@ -1518,17 +1541,7 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
>                 case USB_PORT_FEAT_SUSPEND:
>                         dev_dbg(hsotg->dev,
>                                 "ClearPortFeature USB_PORT_FEAT_SUSPEND\n");
> -                       writel(0, hsotg->regs + PCGCTL);
> -                       usleep_range(20000, 40000);
> -
> -                       hprt0 = dwc2_read_hprt0(hsotg);
> -                       hprt0 |= HPRT0_RES;
> -                       writel(hprt0, hsotg->regs + HPRT0);
> -                       hprt0 &= ~HPRT0_SUSP;
> -                       usleep_range(100000, 150000);
> -
> -                       hprt0 &= ~HPRT0_RES;
> -                       writel(hprt0, hsotg->regs + HPRT0);
> +                       dwc2_port_resume(hsotg);
>                         break;
>
>                 case USB_PORT_FEAT_POWER:
> @@ -2301,6 +2314,42 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
>         usleep_range(1000, 3000);
>  }
>
> +static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
> +{
> +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +       u32 hprt0;
> +
> +       if (hsotg->op_state != OTG_STATE_B_HOST)
> +               return 0;
> +
> +       if (hsotg->lx_state != DWC2_L0)
> +               return 0;
> +
> +       hprt0 = dwc2_read_hprt0(hsotg);
> +       if (hprt0 & HPRT0_CONNSTS)
> +               dwc2_port_suspend(hsotg, 1);
> +
> +       return 0;
> +}
> +
> +static int _dwc2_hcd_resume(struct usb_hcd *hcd)
> +{
> +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +       u32 hprt0;
> +
> +       if (hsotg->op_state != OTG_STATE_B_HOST)
> +               return 0;
> +
> +       if (hsotg->lx_state != DWC2_L2)
> +               return 0;
> +
> +       hprt0 = dwc2_read_hprt0(hsotg);
> +       if ((hprt0 | HPRT0_CONNSTS) && (hprt0 | HPRT0_SUSP))
> +               dwc2_port_resume(hsotg);
> +
> +       return 0;
> +}
> +
>  /* Returns the current frame number */
>  static int _dwc2_hcd_get_frame_number(struct usb_hcd *hcd)
>  {
> @@ -2671,6 +2720,9 @@ static struct hc_driver dwc2_hc_driver = {
>         .hub_status_data = _dwc2_hcd_hub_status_data,
>         .hub_control = _dwc2_hcd_hub_control,
>         .clear_tt_buffer_complete = _dwc2_hcd_clear_tt_buffer_complete,
> +
> +       .bus_suspend = _dwc2_hcd_suspend,
> +       .bus_resume = _dwc2_hcd_resume,

These functions should be defined and registered conditionnally under
#ifdef CONFIG_PM.

Romain
