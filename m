Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbbA2NWe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 08:22:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751851AbbA2NWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 08:22:33 -0500
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: Dexuan Cui <decui@microsoft.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        driverdev-devel@linuxdriverproject.org, olaf@aepfle.de,
        apw@canonical.com, jasowang@redhat.com, kys@microsoft.com,
        haiyangz@microsoft.com
Subject: Re: [PATCH 3/3] hv: vmbus_open(): reset the channel state on ENOMEM
References: <1422529370-28261-1-git-send-email-decui@microsoft.com>
Date: Thu, 29 Jan 2015 14:22:20 +0100
In-Reply-To: <1422529370-28261-1-git-send-email-decui@microsoft.com> (Dexuan
	Cui's message of "Thu, 29 Jan 2015 03:02:50 -0800")
Message-ID: <87fvat7mcz.fsf@vitty.brq.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dexuan Cui <decui@microsoft.com> writes:

> Without this patch, the state is put to CHANNEL_OPENING_STATE, and when
> the driver is loaded next time, vmbus_open() will fail immediately due to
> newchannel->state != CHANNEL_OPEN_STATE.

The patch makes sense, but I have one small doubt. We call vmbus_open
from probe functions of various devices. E.g. in hyperv-keyboard we
have:
 error = vmbus_open(...)
 if (error)
     goto err_free_mem;

and we don't call vmbus_close(...) on this path so no
CHANNELMSG_CLOSECHANNEL will be send. Who's gonna retry probe? Wouldn't
it be better to close the channel?

>
> CC: "K. Y. Srinivasan" <kys@microsoft.com>
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  drivers/hv/channel.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 2978f5e..26dcf26 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -89,9 +89,10 @@ int vmbus_open(struct vmbus_channel *newchannel, u32 send_ringbuffer_size,
>  	out = (void *)__get_free_pages(GFP_KERNEL|__GFP_ZERO,
>  		get_order(send_ringbuffer_size + recv_ringbuffer_size));
>
> -	if (!out)
> -		return -ENOMEM;
> -
> +	if (!out) {
> +		err = -ENOMEM;
> +		goto error0;
> +	}
>
>  	in = (void *)((unsigned long)out + send_ringbuffer_size);
>
> @@ -199,6 +200,7 @@ error0:
>  	free_pages((unsigned long)out,
>  		get_order(send_ringbuffer_size + recv_ringbuffer_size));
>  	kfree(open_info);
> +	newchannel->state = CHANNEL_OPEN_STATE;
>  	return err;
>  }
>  EXPORT_SYMBOL_GPL(vmbus_open);

-- 
  Vitaly
