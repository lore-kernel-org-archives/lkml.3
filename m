Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039Ab3HUOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 10:25:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44715 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751646Ab3HUOZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 10:25:57 -0400
Date: Wed, 21 Aug 2013 10:25:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Krzysztof Mazur <krzysiek@podlesie.net>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 2/2] usb: fail on usb_hub_create_port_device() errors
In-Reply-To: <20130821092515.GA3685@shrek.podlesie.net>
Message-ID: <Pine.LNX.4.44L0.1308211024450.1297-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Aug 2013, Krzysztof Mazur wrote:

> > We should never have maxchild < bNbrPorts (unless maxchild is 0).  But 
> > just in case we do, changing the code is a good idea.
> > 
> > Besides, "hub->maxchild" is shorter and easier to read than
> > "hub->descriptor->bNbrPorts".  :-)
> > 
> 
> It's "hub->hdev->maxchild", but it's still shorter and
> in many places it's just "hdev->maxchild" :)
> 
> I tested that with maxchild < bNbrPorts and there are no NULL pointer
> dereferences anymore.
> 
> Krzysiek
> -- >8 --
> Subject: [PATCH 3/2] usb: don't use bNbrPorts after initialization
> 
> After successful initialization hub->descriptor->bNbrPorts and
> hub->hdev->maxchild are equal, but using hub->hdev->maxchild is
> preferred because that value is explicitly used for initialization
> of hub->ports[].
> 
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> ---
>  drivers/usb/core/hub.c | 12 +++++-------
>  1 file changed, 5 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 292ffa8..86e353f 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -451,7 +451,7 @@ static void led_work (struct work_struct *work)
>  	if (hdev->state != USB_STATE_CONFIGURED || hub->quiescing)
>  		return;
>  
> -	for (i = 0; i < hub->descriptor->bNbrPorts; i++) {
> +	for (i = 0; i < hdev->maxchild; i++) {
>  		unsigned	selector, mode;
>  
>  		/* 30%-50% duty cycle */
> @@ -500,7 +500,7 @@ static void led_work (struct work_struct *work)
>  	}
>  	if (!changed && blinkenlights) {
>  		cursor++;
> -		cursor %= hub->descriptor->bNbrPorts;
> +		cursor %= hdev->maxchild;
>  		set_port_led(hub, cursor + 1, HUB_LED_GREEN);
>  		hub->indicator[cursor] = INDICATOR_CYCLE;
>  		changed++;
> @@ -826,7 +826,7 @@ static unsigned hub_power_on(struct usb_hub *hub, bool do_delay)
>  	else
>  		dev_dbg(hub->intfdev, "trying to enable port power on "
>  				"non-switchable hub\n");
> -	for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
> +	for (port1 = 1; port1 <= hub->hdev->maxchild; port1++)
>  		if (hub->ports[port1 - 1]->power_is_on)
>  			set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
>  		else
> @@ -4655,9 +4655,7 @@ static void hub_events(void)
>  		hub_dev = hub->intfdev;
>  		intf = to_usb_interface(hub_dev);
>  		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
> -				hdev->state, hub->descriptor
> -					? hub->descriptor->bNbrPorts
> -					: 0,
> +				hdev->state, hdev->maxchild,
>  				/* NOTE: expects max 15 ports... */
>  				(u16) hub->change_bits[0],
>  				(u16) hub->event_bits[0]);
> @@ -4702,7 +4700,7 @@ static void hub_events(void)
>  		}
>  
>  		/* deal with port status changes */
> -		for (i = 1; i <= hub->descriptor->bNbrPorts; i++) {
> +		for (i = 1; i <= hdev->maxchild; i++) {
>  			if (test_bit(i, hub->busy_bits))
>  				continue;
>  			connect_change = test_bit(i, hub->change_bits);
> 

This is good.  Combined with your other changes, it should fix all 
the problems you described.  You can add my Acked-by to these patches 
now.

Alan Stern

