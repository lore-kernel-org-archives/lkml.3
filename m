Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641AbbAZOhp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 09:37:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50850 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124AbbAZOhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 09:37:40 -0500
Message-ID: <54C6511E.2000608@redhat.com>
Date: Mon, 26 Jan 2015 15:37:18 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: jin.can.zhuang@intel.com, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, dan.j.williams@intel.com, pmladek@suse.cz,
        peter.chen@freescale.com, mathias.nyman@linux.intel.com
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Revert "usb: Reset USB-3 devices on USB-3 link bounce"
References: <20150126153039.GA18043@intel.com>
In-Reply-To: <20150126153039.GA18043@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 26-01-15 16:30, Zhuang Jin Can wrote:
> This revert a82b76f7fa6154e8ab2d8071842a3e38b9c0d0ff.
>
> The commit causes an extra reset in remote wakeup as described in:
> http://www.spinics.net/lists/linux-usb/msg119080.html
>
> Signed-off-by: Zhuang Jin Can <jin.can.zhuang@intel.com>

No objection from me (*) against reverting this, as it was fixing a
rather obscure (but non the less real) issue, and the issue it
causes seems to be a bigger one.

Regards,

Hans

*) I'm the author of the original patch


> ---
>   drivers/usb/core/hub.c |   34 +++++++++-------------------------
>   1 file changed, 9 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index aeb50bb..89d009a 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -4882,7 +4882,7 @@ static void hub_port_connect_change(struct usb_hub *hub, int port1,
>   static void port_event(struct usb_hub *hub, int port1)
>   		__must_hold(&port_dev->status_lock)
>   {
> -	int connect_change, reset_device = 0;
> +	int connect_change;
>   	struct usb_port *port_dev = hub->ports[port1 - 1];
>   	struct usb_device *udev = port_dev->child;
>   	struct usb_device *hdev = hub->hdev;
> @@ -4970,30 +4970,14 @@ static void port_event(struct usb_hub *hub, int port1)
>   			if (hub_port_reset(hub, port1, NULL,
>   					HUB_BH_RESET_TIME, true) < 0)
>   				hub_port_disable(hub, port1, 1);
> -		} else
> -			reset_device = 1;
> -	}
> -
> -	/*
> -	 * On disconnect USB3 protocol ports transit from U0 to
> -	 * SS.Inactive to Rx.Detect. If this happens a warm-
> -	 * reset is not needed, but a (re)connect may happen
> -	 * before hub_wq runs and sees the disconnect, and the
> -	 * device may be an unknown state.
> -	 *
> -	 * If the port went through SS.Inactive without hub_wq
> -	 * seeing it the C_LINK_STATE change flag will be set,
> -	 * and we reset the dev to put it in a known state.
> -	 */
> -	if (reset_device || (udev && hub_is_superspeed(hub->hdev)
> -				&& (portchange & USB_PORT_STAT_C_LINK_STATE)
> -				&& (portstatus & USB_PORT_STAT_CONNECTION))) {
> -		usb_unlock_port(port_dev);
> -		usb_lock_device(udev);
> -		usb_reset_device(udev);
> -		usb_unlock_device(udev);
> -		usb_lock_port(port_dev);
> -		connect_change = 0;
> +		} else {
> +			usb_unlock_port(port_dev);
> +			usb_lock_device(udev);
> +			usb_reset_device(udev);
> +			usb_unlock_device(udev);
> +			usb_lock_port(port_dev);
> +			connect_change = 0;
> +		}
>   	}
>
>   	if (connect_change)
>
