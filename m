Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754667Ab3JPOka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 10:40:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59464 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751081Ab3JPOk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 10:40:28 -0400
Date: Wed, 16 Oct 2013 10:40:27 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Julius Werner <jwerner@chromium.org>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Benson Leung <bleung@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Duncan Laurie <dlaurie@chromium.org>
Subject: Re: [PATCH v2] usb: hub: Clear Port Reset Change during init/resume
In-Reply-To: <1381884300-403-1-git-send-email-jwerner@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1310161040160.1264-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Oct 2013, Julius Werner wrote:

> This patch adds the Port Reset Change flag to the set of bits that are
> preemptively cleared on init/resume of a hub. In theory this bit should
> never be set unexpectedly... in practice it can still happen if BIOS,
> SMM or ACPI code plays around with USB devices without cleaning up
> correctly. This is especially dangerous for XHCI root hubs, which don't
> generate any more Port Status Change Events until all change bits are
> cleared, so this is a good precaution to have (similar to how it's
> already done for the Warm Port Reset Change flag).
> 
> Signed-off-by: Julius Werner <jwerner@chromium.org>
> ---
>  drivers/usb/core/hub.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index e6b682c..c3dd64c 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -1130,6 +1130,11 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
>  			usb_clear_port_feature(hub->hdev, port1,
>  					USB_PORT_FEAT_C_ENABLE);
>  		}
> +		if (portchange & USB_PORT_STAT_C_RESET) {
> +			need_debounce_delay = true;
> +			usb_clear_port_feature(hub->hdev, port1,
> +					USB_PORT_FEAT_C_RESET);
> +		}
>  		if ((portchange & USB_PORT_STAT_C_BH_RESET) &&
>  				hub_is_superspeed(hub->hdev)) {
>  			need_debounce_delay = true;

Acked-by: Alan Stern <stern@rowland.harvard.edu>

