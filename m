Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab3F1NyV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:54:21 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:41564 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262Ab3F1NyU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:54:20 -0400
Message-ID: <51CD9588.5010305@cogentembedded.com>
Date: Fri, 28 Jun 2013 17:54:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: William Gulland <wgulland@google.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>, Ming Lei <ming.lei@canonical.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: Clear both buffers when clearing a control transfer
 TT buffer.
References: <1372374620-11790-1-git-send-email-wgulland@google.com>
In-Reply-To: <1372374620-11790-1-git-send-email-wgulland@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-06-2013 3:10, William Gulland wrote:

>      Control transfers have both IN and OUT (or SETUP) packets, so when
>      clearing TT buffers for a control transfer it's necessary to send
>      two HUB_CLEAR_TT_BUFFER requests to the hub.

> Signed-off-by: William Gulland <wgulland@google.com>
> ---
>   drivers/usb/core/hub.c | 9 +++++++++
>   1 file changed, 9 insertions(+)

> diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
> index feef935..868ad74 100644
> --- a/drivers/usb/core/hub.c
> +++ b/drivers/usb/core/hub.c
> @@ -668,6 +668,15 @@ resubmit:
>   static inline int
>   hub_clear_tt_buffer (struct usb_device *hdev, u16 devinfo, u16 tt)
>   {
> +	/* Need to clear both directions for control ep */
> +	if (((devinfo >> 11) & USB_ENDPOINT_XFERTYPE_MASK) ==
> +			USB_ENDPOINT_XFER_CONTROL) {
> +		int status = usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
> +				HUB_CLEAR_TT_BUFFER, USB_RT_PORT,
> +				devinfo ^ 0x8000, tt, NULL, 0, 1000);

    Could you use consistent indentation style with the below call?
Also, empty line wouldn't hurt after declaration...

> +		if (status)
> +			return status;
> +	}
>   	return usb_control_msg(hdev, usb_sndctrlpipe(hdev, 0),
>   			       HUB_CLEAR_TT_BUFFER, USB_RT_PORT, devinfo,
>   			       tt, NULL, 0, 1000);

WBR, Sergei

