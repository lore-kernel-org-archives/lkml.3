Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaJ1Qjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 12:39:51 -0400
Received: from mail-qc0-f180.google.com ([209.85.216.180]:32890 "EHLO
	mail-qc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbaJ1Qjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 12:39:48 -0400
MIME-Version: 1.0
In-Reply-To: <1414497280-3126-5-git-send-email-ray.huang@amd.com>
References: <1414497280-3126-1-git-send-email-ray.huang@amd.com> <1414497280-3126-5-git-send-email-ray.huang@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 28 Oct 2014 10:39:26 -0600
Message-ID: <CAErSpo5vRcGxu=e61tCEwNVL913_Lxne=1KW+JtQVpc6jgCaHg@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] usb: dwc3: add disscramble quirk
To: Huang Rui <ray.huang@amd.com>
Cc: Felipe Balbi <balbi@ti.com>, Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jason Chang <jason.chang@amd.com>, Vincent Wan <vincent.wan@amd.com>,
        Tony Li <tony.li@amd.com>, USB list <linux-usb@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 5:54 AM, Huang Rui <ray.huang@amd.com> wrote:
> This patch adds disscramble quirk, and it only needs to be enabled at fpga

"disscramble" (in subject and above) is not a real word.

I see that DWC3_GCTL_DISSCRAMBLE is already defined in
drivers/usb/dwc3/core.h even before your patches, so I suppose it's
something the hardware designers made up.

Maybe it means "descramble" (or "unscramble").  Or maybe it means
"disable scrambling"?  A comment might make this clearer.  A better
name would be even better.

> board on some vendor platforms.
>
> Signed-off-by: Huang Rui <ray.huang@amd.com>
> ---
>  drivers/usb/dwc3/core.c          | 14 +++++++++++++-
>  drivers/usb/dwc3/core.h          |  3 +++
>  drivers/usb/dwc3/platform_data.h |  2 ++
>  3 files changed, 18 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/usb/dwc3/core.c b/drivers/usb/dwc3/core.c
> index ddac372..c320835 100644
> --- a/drivers/usb/dwc3/core.c
> +++ b/drivers/usb/dwc3/core.c
> @@ -422,7 +422,6 @@ static int dwc3_core_init(struct dwc3 *dwc)
>
>         reg = dwc3_readl(dwc->regs, DWC3_GCTL);
>         reg &= ~DWC3_GCTL_SCALEDOWN_MASK;
> -       reg &= ~DWC3_GCTL_DISSCRAMBLE;
>
>         switch (DWC3_GHWPARAMS1_EN_PWROPT(dwc->hwparams.hwparams1)) {
>         case DWC3_GHWPARAMS1_EN_PWROPT_CLK:
> @@ -461,6 +460,14 @@ static int dwc3_core_init(struct dwc3 *dwc)
>                 dwc->is_fpga = true;
>         }
>
> +       WARN_ONCE(dwc->disable_scramble_quirk && !dwc->is_fpga,
> +                       "disable_scramble cannot be used on non-FPGA builds\n");
> +
> +       if (dwc->disable_scramble_quirk && dwc->is_fpga)
> +               reg |= DWC3_GCTL_DISSCRAMBLE;
> +       else
> +               reg &= ~DWC3_GCTL_DISSCRAMBLE;
> +
>         /*
>          * WORKAROUND: DWC3 revisions <1.90a have a bug
>          * where the device can fail to connect at SuperSpeed
> @@ -705,11 +712,16 @@ static int dwc3_probe(struct platform_device *pdev)
>
>                 dwc->needs_fifo_resize = of_property_read_bool(node, "tx-fifo-resize");
>                 dwc->dr_mode = of_usb_get_dr_mode(node);
> +
> +               dwc->disable_scramble_quirk = of_property_read_bool(node,
> +                               "snps,disable_scramble_quirk");
>         } else if (pdata) {
>                 dwc->maximum_speed = pdata->maximum_speed;
>
>                 dwc->needs_fifo_resize = pdata->tx_fifo_resize;
>                 dwc->dr_mode = pdata->dr_mode;
> +
> +               dwc->disable_scramble_quirk = pdata->disable_scramble_quirk;
>         }
>
>         /* default to superspeed if no maximum_speed passed */
> diff --git a/drivers/usb/dwc3/core.h b/drivers/usb/dwc3/core.h
> index f6ee623..56bada6 100644
> --- a/drivers/usb/dwc3/core.h
> +++ b/drivers/usb/dwc3/core.h
> @@ -672,6 +672,7 @@ struct dwc3_scratchpad_array {
>   * @setup_packet_pending: true when there's a Setup Packet in FIFO. Workaround
>   * @start_config_issued: true when StartConfig command has been issued
>   * @three_stage_setup: set if we perform a three phase setup
> + * @disable_scramble_quirk: set if we enable the disable scramble quirk
>   */
>  struct dwc3 {
>         struct usb_ctrlrequest  *ctrl_req;
> @@ -776,6 +777,8 @@ struct dwc3 {
>         unsigned                setup_packet_pending:1;
>         unsigned                start_config_issued:1;
>         unsigned                three_stage_setup:1;
> +
> +       unsigned                disable_scramble_quirk:1;
>  };
>
>  /* -------------------------------------------------------------------------- */
> diff --git a/drivers/usb/dwc3/platform_data.h b/drivers/usb/dwc3/platform_data.h
> index 7db34f0..9209d02 100644
> --- a/drivers/usb/dwc3/platform_data.h
> +++ b/drivers/usb/dwc3/platform_data.h
> @@ -24,4 +24,6 @@ struct dwc3_platform_data {
>         enum usb_device_speed maximum_speed;
>         enum usb_dr_mode dr_mode;
>         bool tx_fifo_resize;
> +
> +       unsigned disable_scramble_quirk:1;
>  };
> --
> 1.9.1
>
