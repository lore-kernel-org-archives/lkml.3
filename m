Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759826Ab3BZQHc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 11:07:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:39803 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759744Ab3BZQHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 11:07:31 -0500
Date: Tue, 26 Feb 2013 11:07:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel J Blueman <daniel@numascale-asia.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH] Prevent USB hub remove oops
In-Reply-To: <1361890685-12247-1-git-send-email-daniel@numascale-asia.com>
Message-ID: <Pine.LNX.4.44L0.1302261100210.1832-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2013, Daniel J Blueman wrote:

> When initialisation of one or more USB hub ports fails, we can hit a null
> pointer dereference when dropping the hub. Analysis shows there's a false
> assumption about the ports being setup, so address this.

> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
> ---
>  drivers/usb/core/hub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index cbf7168..a7abc57 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1263,7 +1263,7 @@ static void hub_quiesce(struct usb_hub *hub, enum hub_quiescing_type type)
>  	if (type != HUB_SUSPEND) {
>  		/* Disconnect all the children */
>  		for (i = 0; i < hdev->maxchild; ++i) {
> -			if (hub->ports[i]->child)
> +			if (hub->ports[i] && hub->ports[i]->child)
>  				usb_disconnect(&hub->ports[i]->child);
>  		}
>  	}

You missed a case.  What happens if hub->ports is NULL?

Also, what about this code in hub_disconnect?

	for (i = 0; i < hdev->maxchild; i++)
		usb_hub_remove_port_device(hub, i + 1);

All of these problems can be fixed in hub_configure by setting
hub->maxchild to the total number of allocated ports (or 0 if hub_ports
can't be allocated).

Alan Stern

