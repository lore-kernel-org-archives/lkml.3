Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751313AbaKFWLf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:11:35 -0500
Received: from mail-oi0-f45.google.com ([209.85.218.45]:54878 "EHLO
	mail-oi0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaKFWLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:11:33 -0500
MIME-Version: 1.0
In-Reply-To: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
References: <1415237402-24665-1-git-send-email-kever.yang@rock-chips.com>
Date: Thu, 6 Nov 2014 14:11:32 -0800
X-Google-Sender-Auth: EjDgPgMQY9CzRG3k7Qgr_O8nT6I
Message-ID: <CAODwPW_Udap8oYGhKSLWhpiLLhsOUKNsMbpxC7CLEz-Cg53JQw@mail.gmail.com>
Subject: Re: [PATCH v2] usb: dwc2: add bus suspend/resume for dwc2
From: Julius Werner <jwerner@chromium.org>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>, romain.perier@gmail.com,
        Heiko Stuebner <heiko@sntech.de>,
        Douglas Anderson <dianders@chromium.org>,
        Sonny Rao <sonnyrao@chromium.org>, addy ke <addy.ke@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, Jianqun Xu <xjq@rock-chips.com>,
        han jiang <hj@rock-chips.com>,
        =?UTF-8?B?5oi05YWL6ZyW?= <dkl@rock-chips.com>,
        Tao Huang <huangtao@rock-chips.com>,
        linux-rockchip@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 5:30 PM, Kever Yang <kever.yang@rock-chips.com> wrote:
> Hcd controller needs bus_suspend/resume, dwc2 controller make
> root hub generate suspend/resume signal with hprt0 register
> when work in host mode.
> After the root hub enter suspend, we can make controller enter
> low power state with PCGCTL register.

You say you do this, but I don't actually see you doing it (for the
not-connected case)?

>
> We also update the lx_state for hsotg state.
>
> This patch has tested on rk3288 with suspend/resume.
>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
>
> Changes in v2:
> - update commit message
> - make dwc2 suspend/resume sourcecode work
>
>  drivers/usb/dwc2/hcd.c | 78 +++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 67 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/usb/dwc2/hcd.c b/drivers/usb/dwc2/hcd.c
> index 0a0e6f0..01a415b 100644
> --- a/drivers/usb/dwc2/hcd.c
> +++ b/drivers/usb/dwc2/hcd.c
> @@ -1471,6 +1471,30 @@ static void dwc2_port_suspend(struct dwc2_hsotg *hsotg, u16 windex)
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
> +       /* according to USB2.0 Spec 7.1.7.7, the host must send the resume
> +        * signal for at least 20ms
> +        */
> +       usleep_range(20000, 25000);
> +
> +       hprt0 &= ~HPRT0_RES;
> +       writel(hprt0, hsotg->regs + HPRT0);
> +       hsotg->lx_state = DWC2_L0;
> +}
> +
>  /* Handles hub class-specific requests */
>  static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
>                                 u16 wvalue, u16 windex, char *buf, u16 wlength)
> @@ -1516,17 +1540,7 @@ static int dwc2_hcd_hub_control(struct dwc2_hsotg *hsotg, u16 typereq,
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

I'm curious why this didn't change lx_state back to DWC2_L0 before...
Paul, do you know?

> +                       dwc2_port_resume(hsotg);
>                         break;
>
>                 case USB_PORT_FEAT_POWER:
> @@ -2299,6 +2313,44 @@ static void _dwc2_hcd_stop(struct usb_hcd *hcd)
>         usleep_range(1000, 3000);
>  }
>
> +static int _dwc2_hcd_suspend(struct usb_hcd *hcd)
> +{
> +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +       u32 hprt0;
> +
> +       if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
> +               (hsotg->op_state == OTG_STATE_A_HOST)))
> +               return 0;
> +
> +       if (hsotg->lx_state != DWC2_L0)

What if the port is in L1 state? I don't think the driver supports LPM
right now, but the DWC2_L1 enum is defined so it may one day in the
future. Let's maybe at least add a TODO.

> +               return 0;

In your original ChromiumOS version of this patch, you also set
PCGCTL_STOPPCLK here if the port was not connected. Is there a reason
that changed (does it not actually save power or something)?

> +
> +       hprt0 = dwc2_read_hprt0(hsotg);
> +       if (hprt0 & HPRT0_CONNSTS)
> +               dwc2_port_suspend(hsotg, 1);

The contract for bus_suspend() is that it will suspend all ports not
yet suspended, keep track of those ports and then only resume those in
bus_resume() (compare, for example, how XHCI keeps track of that with
xhci_bus_state.bus_suspended in xhci_bus_suspend/resume()). So you
need something here to remember whether this function suspended the
port or whether it had already been suspended, and then only resume
the port in bus_resume() in the former case. Note that
dwc2_port_suspend() changes lx_state to DWC_L2 (at least in the
version I'm looking at right now), so you can't just rely on that
unless you explicitly set it back to something else here.

> +
> +       return 0;
> +}
> +
> +static int _dwc2_hcd_resume(struct usb_hcd *hcd)
> +{
> +       struct dwc2_hsotg *hsotg = dwc2_hcd_to_hsotg(hcd);
> +       u32 hprt0;
> +
> +       if (!((hsotg->op_state == OTG_STATE_B_HOST) ||
> +               (hsotg->op_state == OTG_STATE_A_HOST)))
> +               return 0;
> +
> +       if (hsotg->lx_state != DWC2_L2)
> +               return 0;
> +
> +       hprt0 = dwc2_read_hprt0(hsotg);
> +       if ((hprt0 & HPRT0_CONNSTS) && (hprt0 & HPRT0_SUSP))
> +               dwc2_port_resume(hsotg);
> +
> +       return 0;
> +}
> +
>  /* Returns the current frame number */
>  static int _dwc2_hcd_get_frame_number(struct usb_hcd *hcd)
>  {
> @@ -2669,6 +2721,10 @@ static struct hc_driver dwc2_hc_driver = {
>         .hub_status_data = _dwc2_hcd_hub_status_data,
>         .hub_control = _dwc2_hcd_hub_control,
>         .clear_tt_buffer_complete = _dwc2_hcd_clear_tt_buffer_complete,
> +#ifdef CONFIG_PM
> +       .bus_suspend = _dwc2_hcd_suspend,
> +       .bus_resume = _dwc2_hcd_resume,
> +#endif
>  };
>
>  /*
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
