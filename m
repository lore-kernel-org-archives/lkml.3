Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaAXRqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:46:31 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:47918 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaAXRq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:46:29 -0500
Message-ID: <52E2A6F7.7010301@cogentembedded.com>
Date: Fri, 24 Jan 2014 21:46:31 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, linux-usb@vger.kernel.org
CC: balbi@ti.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] usb: musb: musb_cppi41: Handle ISOCH differently
 and not use the hrtimer.
References: <1390572895-26428-1-git-send-email-george.cherian@ti.com> <1390572895-26428-4-git-send-email-george.cherian@ti.com>
In-Reply-To: <1390572895-26428-4-git-send-email-george.cherian@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 24-01-2014 18:14, George Cherian wrote:

> In case of ISOCH transfers the hrtimer workaround for the hardware issue
> is not very reliable. Instead of checking musb_is_tx_fifo_empty() in hrtimer
> routine, schedule a completion work and check the same in completion work.

> Signed-off-by: George Cherian <george.cherian@ti.com>
> ---
>   drivers/usb/musb/musb_cppi41.c | 54 +++++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 53 insertions(+), 1 deletion(-)

> diff --git a/drivers/usb/musb/musb_cppi41.c b/drivers/usb/musb/musb_cppi41.c
> index 39ee516..8075562 100644
> --- a/drivers/usb/musb/musb_cppi41.c
> +++ b/drivers/usb/musb/musb_cppi41.c
[...]
> @@ -165,6 +178,32 @@ static void cppi41_trans_done(struct cppi41_dma_channel *cppi41_channel)
>   	}
>   }
>
> +static void cppi_trans_done_work(struct work_struct *work)
> +{
> +	unsigned long flags;
> +	struct cppi41_dma_channel *cppi41_channel =
> +		container_of(work, struct cppi41_dma_channel, dma_completion);
> +	struct cppi41_dma_controller *controller = cppi41_channel->controller;
> +	struct musb *musb = controller->musb;
> +	struct musb_hw_ep *hw_ep = cppi41_channel->hw_ep;
> +	bool empty;
> +
> +	if (!cppi41_channel->is_tx && is_isoc(hw_ep, 1)) {
> +			spin_lock_irqsave(&musb->lock, flags);
> +			cppi41_trans_done(cppi41_channel);
> +			spin_unlock_irqrestore(&musb->lock, flags);

    This *if* arm is clearly over-indented by one tab. Compare with below 
*else* arm.

> +	} else {
> +		empty = musb_is_tx_fifo_empty(hw_ep);
> +		if (empty) {
> +			spin_lock_irqsave(&musb->lock, flags);
> +			cppi41_trans_done(cppi41_channel);
> +			spin_unlock_irqrestore(&musb->lock, flags);
> +		} else {
> +			schedule_work(&cppi41_channel->dma_completion);
> +		}
> +	}
> +}
> +

WBR, Sergei

