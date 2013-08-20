Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751863Ab3HTSOo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 14:14:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41310 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751633Ab3HTSOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 14:14:43 -0400
Date: Tue, 20 Aug 2013 14:14:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Krzysztof Mazur <krzysiek@podlesie.net>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>,
        Daniel J Blueman <daniel@numascale-asia.com>
Subject: Re: [PATCH 1/2] usb: fix cleanup after failure in hub_configure()
In-Reply-To: <1377019476-7701-2-git-send-email-krzysiek@podlesie.net>
Message-ID: <Pine.LNX.4.44L0.1308201412220.1591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Krzysztof Mazur wrote:

> If the hub_configure() fails after setting the hdev->maxchild
> the hub->ports might be NULL or point to uninitialized kzallocated
> memory causing NULL pointer dereference in hub_quiesce() during cleanup.
> 
> Now after such error the hdev->maxchild is set to 0 to avoid cleanup
> of uninitialized ports.

The idea is good, but the implementation is a little silly...

> Suggested-by: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
> ---
>  drivers/usb/core/hub.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index 558313d..588c3a3 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1339,7 +1339,7 @@ static int hub_configure(struct usb_hub *hub,
>  			     GFP_KERNEL);
>  	if (!hub->ports) {
>  		ret = -ENOMEM;
> -		goto fail;
> +		goto fail_maxchild;
>  	}
>  
>  	wHubCharacteristics = le16_to_cpu(hub->descriptor->wHubCharacteristics);

> @@ -1567,6 +1567,8 @@ static int hub_configure(struct usb_hub *hub,
>  	hub_activate(hub, HUB_INIT);
>  	return 0;
>  
> +fail_maxchild:
> +	hdev->maxchild = 0;
>  fail:
>  	dev_err (hub_dev, "config failed, %s (err %d)\n",
>  			message, ret);

Why bother with a separate jump label?  Just set maxchild to 0 whenever 
a failure occurs.

Alan Stern

