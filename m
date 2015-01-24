Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbbAXPtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 10:49:15 -0500
Received: from netrider.rowland.org ([192.131.102.5]:54837 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753430AbbAXPtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 10:49:12 -0500
Date: Sat, 24 Jan 2015 10:49:11 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Douglas Anderson <dianders@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>, Wu Liang feng <wulf@rock-chips.com>
Subject: Re: [PATCH] usb: Retry port status check on resume to work around
 RH bugs
In-Reply-To: <1422057688-18956-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1501241046550.7435-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Jan 2015, Julius Werner wrote:

> The EHCI controller on the RK3288 SoC is violating basic parts of the
> USB spec and thereby unable to properly resume a suspended port. It does
> not start SOF generation within 3ms of finishing resume signaling, so
> the attached device will drop off the bus again. This is a particular
> problem with runtime PM, where accessing the device will trigger a
> resume that immediately makes it unavailabe (and reenumerate with a new
> handle).
> 
> Thankfully, the persist feature is generally able to work around stuff
> like that. Unfortunately, it doesn't quite work in this particular case
> because the controller will turn off the CurrentConnectStatus bit for an
> instant while the device is reconnecting, which causes the kernel to
> conclude that it permanently disappeared. This patch adds a tiny retry
> mechanism to the core port resume code which will catch this case and
> shouldn't have any notable impact on other controllers.
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/core/hub.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index aeb50bb..d1d0a66 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -2896,10 +2896,12 @@ static int port_is_suspended(struct usb_hub *hub, unsigned portstatus)
>   */
>  static int check_port_resume_type(struct usb_device *udev,
>  		struct usb_hub *hub, int port1,
> -		int status, unsigned portchange, unsigned portstatus)
> +		int status, u16 portchange, u16 portstatus)
>  {
>  	struct usb_port *port_dev = hub->ports[port1 - 1];
> +	int retries = 3;
>  
> +retry:
>  	/* Is a warm reset needed to recover the connection? */
>  	if (status == 0 && udev->reset_resume
>  		&& hub_port_warm_reset_required(hub, port1, portstatus)) {
> @@ -2909,8 +2911,15 @@ static int check_port_resume_type(struct usb_device *udev,
>  	else if (status || port_is_suspended(hub, portstatus) ||
>  			!port_is_power_on(hub, portstatus) ||
>  			!(portstatus & USB_PORT_STAT_CONNECTION)) {
> -		if (status >= 0)
> +		if (status >= 0) {
> +			if (retries--) {
> +				udelay(200);

You should use a sleeping function call, not a delay.

> +				status = hub_port_status(hub, port1,
> +						&portstatus, &portchange);
> +				goto retry;
> +			}
>  			status = -ENODEV;
> +		}
>  	}
>  
>  	/* Can't do a normal resume if the port isn't enabled,

Otherwise this is okay.

Alan Stern

