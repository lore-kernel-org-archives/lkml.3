Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab3LWPMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 10:12:40 -0500
Received: from netrider.rowland.org ([192.131.102.5]:37478 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753518Ab3LWPMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 10:12:38 -0500
Date: Mon, 23 Dec 2013 10:12:37 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Du, ChangbinX" <changbinx.du@intel.com>
cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "sarah.a.sharp@linux.intel.com" <sarah.a.sharp@linux.intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>,
        "burzalodowa@gmail.com" <burzalodowa@gmail.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb/core: fix NULL pointer dereference in
 recursively_mark_NOTATTACHED
In-Reply-To: <0C18FE92A7765D4EB9EE5D38D86A563A01A2EDE9@SHSMSX103.ccr.corp.intel.com>
Message-ID: <Pine.LNX.4.44L0.1312231003550.5503-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Dec 2013, Du, ChangbinX wrote:

> From ee48b3736d437af79d4fe858cdf64f241c76c339 Mon Sep 17 00:00:00 2001
> From: "Du, Changbin" <changbinx.du@intel.com>
> Date: Wed, 18 Dec 2013 16:47:21 +0800
> Subject: [PATCH] usb/core: fix NULL pointer dereference in
>  recursively_mark_NOTATTACHED
> 
> usb_hub_to_struct_hub() can return NULL if the hub without active
> configuration. So the result must be checked.
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000015c
> IP: [<c16d5fb0>] recursively_mark_NOTATTACHED+0x20/0x60
> Call Trace:
>  [<c16d5fc4>] recursively_mark_NOTATTACHED+0x34/0x60
>  [<c16d5fc4>] recursively_mark_NOTATTACHED+0x34/0x60
>  [<c16d5fc4>] recursively_mark_NOTATTACHED+0x34/0x60
>  [<c16d5fc4>] recursively_mark_NOTATTACHED+0x34/0x60
>  [<c16d6082>] usb_set_device_state+0x92/0x120
>  [<c16d862b>] usb_disconnect+0x2b/0x1a0
>  [<c16dd4c0>] usb_remove_hcd+0xb0/0x160
>  [<c19ca846>] ? _raw_spin_unlock_irqrestore+0x26/0x50
>  [<c1704efc>] ehci_mid_remove+0x1c/0x30
>  [<c1704f26>] ehci_mid_stop_host+0x16/0x30
>  [<c16f7698>] penwell_otg_work+0xd28/0x3520
>  [<c19c945b>] ? __schedule+0x39b/0x7f0
>  [<c19cdb9d>] ? sub_preempt_count+0x3d/0x50
>  [<c125e97d>] process_one_work+0x11d/0x3d0
>  [<c19c7f4d>] ? mutex_unlock+0xd/0x10
>  [<c125e0e5>] ? manage_workers.isra.24+0x1b5/0x270
>  [<c125f009>] worker_thread+0xf9/0x320
>  [<c19ca846>] ? _raw_spin_unlock_irqrestore+0x26/0x50
>  [<c125ef10>] ? rescuer_thread+0x2b0/0x2b0
>  [<c1264ac4>] kthread+0x94/0xa0
>  [<c19d0f77>] ret_from_kernel_thread+0x1b/0x28
>  [<c1264a30>] ? kthread_create_on_node+0xc0/0xc0
> 
> Signed-off-by: Du, Changbin <changbinx.du@intel.com>
> ---
>  drivers/usb/core/hub.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index bd9dc35..01a1fe6 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1870,9 +1870,11 @@ static void recursively_mark_NOTATTACHED(struct usb_device *udev)
>  	struct usb_hub *hub = usb_hub_to_struct_hub(udev);
>  	int i;
>  
> -	for (i = 0; i < udev->maxchild; ++i) {
> -		if (hub->ports[i]->child)
> -			recursively_mark_NOTATTACHED(hub->ports[i]->child);
> +	if (hub) {
> +		for (i = 0; i < udev->maxchild; ++i) {
> +			if (hub->ports[i]->child)
> +				recursively_mark_NOTATTACHED(hub->ports[i]->child);
> +		}
>  	}
>  	if (udev->state == USB_STATE_SUSPENDED)
>  		udev->active_duration -= jiffies;

How did you manage to trigger this BUG?  If hub is NULL then 
udev->maxchild should be 0.  See the code in hub_disconnect().

Alan Stern

