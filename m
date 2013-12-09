Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306Ab3LIPYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 10:24:55 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39659 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761273Ab3LIPYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 10:24:53 -0500
Date: Mon, 9 Dec 2013 10:24:52 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vikas Sajjan <vikas.sajjan@linaro.org>
cc: linux-samsung-soc@vger.kernel.org, <kgene.kim@samsung.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>, <vpalatin@chromium.org>,
        <jwerner@chromium.org>, <tianyu.lan@intel.com>,
        <burzalodowa@gmail.com>, <gregkh@linuxfoundation.org>,
        <gautam.vivek@samsung.com>, <dianders@chromium.org>, <balbi@ti.com>,
        <joshi@samsung.com>
Subject: Re: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed
 HUBs
In-Reply-To: <1386592158-12086-1-git-send-email-vikas.sajjan@linaro.org>
Message-ID: <Pine.LNX.4.44L0.1312091019400.1439-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Dec 2013, Vikas Sajjan wrote:

> Does warm reset while activating SuperSpeed HUBs if the hub activate type
> is HUB_RESET_RESUME.
> 
> When we do Suspend-to-RAM with (any one of the 16, 32, 64 Jetflash) transcend
> USB 3.0 device connected on 3.0 port, during resume I noticed that the
> XHCI controller has moved to sometimes RECOVERY, POLLING or INACTIVE STATE.
> This behaviour is inconsistent and the connection with connected USB 3.0 device
> on 3.0 port was LOST.
> 
> Doing warm reset while activating SuperSpeed HUBs if the hub
> activate type is HUB_RESET_RESUME, gets the connected device to the stable state.
> 
> Reviewed at https://chromium-review.googlesource.com/#/c/177132/
> 
> Tested on exynos5420 and exynos5250 with Transcend Jetflash USB 3.0 device (8564:1000)
> 
> rebased on Greg Kroah-Hartman's usb-next
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git
> 
> Signed-off-by: Vikas Sajjan <vikas.sajjan@samsung.com>
> ---
>  drivers/usb/core/hub.c |   41 +++++++++++++++++++++++++----------------
>  1 file changed, 25 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index a7c04e2..d8432b0 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c

> @@ -1093,6 +1108,16 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
>  		u16 portstatus, portchange;
>  
>  		portstatus = portchange = 0;
> +
> +		/* Some connected devices might be still in unknown state even
> +		 * after reset-resume, a WARM_RESET gets the connected device
> +		 * to the normal state.
> +		 */
> +		if (udev && hub_is_superspeed(hub->hdev) &&
> +						type == HUB_RESET_RESUME)
> +			hub_port_reset(hub, port1, NULL,
> +						HUB_BH_RESET_TIME, true);

Please don't do this all the time to every attached port.  Do it only 
when it is really needed.

Shouldn't you pass udev as the third argument?  If not, please explain
why not.

Finally, I don't see why you put this in hub_activate().  Isn't it more 
closely connected with the reset-resume procedure for the child device?

Alan Stern

