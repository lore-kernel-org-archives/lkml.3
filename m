Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804AbaKRQHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 11:07:37 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34826 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755773AbaKRQHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 11:07:35 -0500
Date: Tue, 18 Nov 2014 11:07:34 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kever Yang <kever.yang@rock-chips.com>
cc: Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        <romain.perier@gmail.com>, Heiko Stuebner <heiko@sntech.de>,
        <dianders@chromium.org>, <sonnyrao@chromium.org>,
        <addy.ke@rock-chips.com>, <cf@rock-chips.com>, <wulf@rock-chips.com>,
        <huangtao@rock-chips.com>, <linux-rockchip@lists.infradead.org>,
        Roy Li <roy.li@rock-chips.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: dwc2: resume root hub when device detect with
 suspend state
In-Reply-To: <1416273684-11300-1-git-send-email-kever.yang@rock-chips.com>
Message-ID: <Pine.LNX.4.44L0.1411181104280.1500-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014, Kever Yang wrote:

> After we implement the bus_suspend/resume, auto suspend id enabled.
> The root hub will be auto suspend if there is no device connected,
> we need to resume the root hub when a device connect detect.
> 
> This patch tested on rk3288.
> 
> Signed-off-by: Roy Li <roy.li@rock-chips.com>
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
> Changes in v2:
> - add definition for hcd structure
> - remove check for bus->root_hub
> 
>  drivers/usb/dwc2/hcd_intr.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/dwc2/hcd_intr.c b/drivers/usb/dwc2/hcd_intr.c
> index 551ba87..680206f 100644
> --- a/drivers/usb/dwc2/hcd_intr.c
> +++ b/drivers/usb/dwc2/hcd_intr.c
> @@ -329,6 +329,7 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
>  {
>  	u32 hprt0;
>  	u32 hprt0_modify;
> +	struct usb_hcd *hcd = (struct usb_hcd *)hsotg->priv;
>  
>  	dev_vdbg(hsotg->dev, "--Port Interrupt--\n");
>  
> @@ -354,6 +355,10 @@ static void dwc2_port_intr(struct dwc2_hsotg *hsotg)
>  		hsotg->flags.b.port_connect_status = 1;
>  		hprt0_modify |= HPRT0_CONNDET;
>  
> +		/* resume root hub? */
> +		if (hcd->state == HC_STATE_SUSPENDED)
> +			usb_hcd_resume_root_hub(hcd);

You should be aware that it's not safe to use hcd->state for anything 
in a host controller driver.  That field is owned by usbcore, not by 
the HCD, and it is not protected by any locks.

Thus, for example, hcd->state does not get set to HC_STATE_SUSPENDED
until some time after the bus_suspend routine has returned.  A
port-change interrupt might occur during that time interval.

Alan Stern

