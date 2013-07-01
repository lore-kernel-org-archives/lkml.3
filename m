Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3GAUlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 16:41:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38596 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754776Ab3GAUlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 16:41:18 -0400
Date: Mon, 1 Jul 2013 16:41:17 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: William Gulland <wgulland@google.com>
cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Ming Lei <ming.lei@canonical.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: Clear both buffers when clearing a control transfer
 TT buffer.
In-Reply-To: <1372374620-11790-1-git-send-email-wgulland@google.com>
Message-ID: <Pine.LNX.4.44L0.1307011636530.1547-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jun 2013, William Gulland wrote:

>     Control transfers have both IN and OUT (or SETUP) packets, so when
>     clearing TT buffers for a control transfer it's necessary to send
>     two HUB_CLEAR_TT_BUFFER requests to the hub.
> 
> Signed-off-by: William Gulland <wgulland@google.com>
> ---
>  drivers/usb/core/hub.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index feef935..868ad74 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -668,6 +668,15 @@ resubmit:
>  static inline int
>  hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
>  {
> +	/* Need to clear both directions for control ep */
> +	if (((devinfo >> 11) & USB_ENDPOINT_XFERTYPE_MASK) ==
> +			USB_ENDPOINT_XFER_CONTROL) {
> +		int status = usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
> +				HUB_CLEAR_TT_BUFFER, USB_RT_PORT,
> +				devinfo ^ 0x8000, tt, NULL, 0, 1000);
> +		if (status)
> +			return status;
> +	}
>  	return usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
>  			       HUB_CLEAR_TT_BUFFER, USB_RT_PORT, devinfo,
>  			       tt, NULL, 0, 1000);

Well, this won't hurt much.  And since it does seem to fix a hardware
problem,

Acked-by: Alan Stern <stern@rowland.harvard.edu>

