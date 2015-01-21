Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602AbbAUDLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 22:11:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38920 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237AbbAUDLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 22:11:52 -0500
Date: Wed, 21 Jan 2015 03:19:36 +0008
From: Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v3 2/3] Drivers: hv: rename sc_lock to the more generic
 lock
To: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, devel@linuxdriverproject.org,
        Haiyang Zhang <haiyangz@microsoft.com>, linux-kernel@vger.kernel.org,
        Dexuan Cui <decui@microsoft.com>,
        Radim =?iso-8859-2?b?S3LobeH4?= <rkrcmar@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Message-Id: <1421809896.8384.1@smtp.corp.redhat.com>
In-Reply-To: <1421768706-5363-3-git-send-email-vkuznets@redhat.com>
References: <1421768706-5363-1-git-send-email-vkuznets@redhat.com>
	<1421768706-5363-3-git-send-email-vkuznets@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Jan 20, 2015 at 11:45 PM, Vitaly Kuznetsov 
<vkuznets@redhat.com> wrote:
> sc_lock spinlock in struct vmbus_channel is being used to not only 
> protect the
> sc_list field, e.g. vmbus_open() function uses it to implement 
> test-and-set
> access to the state field. Rename it to the more generic 'lock' and 
> add the
> description.
> 
> Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
> ---
>  drivers/hv/channel.c      |  6 +++---
>  drivers/hv/channel_mgmt.c | 10 +++++-----
>  include/linux/hyperv.h    |  7 ++++++-
>  3 files changed, 14 insertions(+), 9 deletions(-)

Acked-by: Jason Wang <jasowang@redhat.com>
> 
> diff --git a/drivers/hv/channel.c b/drivers/hv/channel.c
> index 433f72a..8608ed1 100644
> --- a/drivers/hv/channel.c
> +++ b/drivers/hv/channel.c
> @@ -73,14 +73,14 @@ int vmbus_open(struct vmbus_channel *newchannel, 
> u32 send_ringbuffer_size,
>  	unsigned long flags;
>  	int ret, t, err = 0;
>  
> -	spin_lock_irqsave(&newchannel->sc_lock, flags);
> +	spin_lock_irqsave(&newchannel->lock, flags);
>  	if (newchannel->state == CHANNEL_OPEN_STATE) {
>  		newchannel->state = CHANNEL_OPENING_STATE;
>  	} else {
> -		spin_unlock_irqrestore(&newchannel->sc_lock, flags);
> +		spin_unlock_irqrestore(&newchannel->lock, flags);
>  		return -EINVAL;
>  	}
> -	spin_unlock_irqrestore(&newchannel->sc_lock, flags);
> +	spin_unlock_irqrestore(&newchannel->lock, flags);
>  
>  	newchannel->onchannel_callback = onchannelcallback;
>  	newchannel->channel_callback_context = context;
> diff --git a/drivers/hv/channel_mgmt.c b/drivers/hv/channel_mgmt.c
> index 01f2c2b..c6fdd74 100644
> --- a/drivers/hv/channel_mgmt.c
> +++ b/drivers/hv/channel_mgmt.c
> @@ -146,7 +146,7 @@ static struct vmbus_channel *alloc_channel(void)
>  		return NULL;
>  
>  	spin_lock_init(&channel->inbound_lock);
> -	spin_lock_init(&channel->sc_lock);
> +	spin_lock_init(&channel->lock);
>  
>  	INIT_LIST_HEAD(&channel->sc_list);
>  	INIT_LIST_HEAD(&channel->percpu_list);
> @@ -246,9 +246,9 @@ static void vmbus_process_rescind_offer(struct 
> work_struct *work)
>  		spin_unlock_irqrestore(&vmbus_connection.channel_lock, flags);
>  	} else {
>  		primary_channel = channel->primary_channel;
> -		spin_lock_irqsave(&primary_channel->sc_lock, flags);
> +		spin_lock_irqsave(&primary_channel->lock, flags);
>  		list_del(&channel->sc_list);
> -		spin_unlock_irqrestore(&primary_channel->sc_lock, flags);
> +		spin_unlock_irqrestore(&primary_channel->lock, flags);
>  	}
>  	free_channel(channel);
>  }
> @@ -323,9 +323,9 @@ static void vmbus_process_offer(struct 
> work_struct *work)
>  			 * Process the sub-channel.
>  			 */
>  			newchannel->primary_channel = channel;
> -			spin_lock_irqsave(&channel->sc_lock, flags);
> +			spin_lock_irqsave(&channel->lock, flags);
>  			list_add_tail(&newchannel->sc_list, &channel->sc_list);
> -			spin_unlock_irqrestore(&channel->sc_lock, flags);
> +			spin_unlock_irqrestore(&channel->lock, flags);
>  
>  			if (newchannel->target_cpu != get_cpu()) {
>  				put_cpu();
> diff --git a/include/linux/hyperv.h b/include/linux/hyperv.h
> index 476c685..02dd978 100644
> --- a/include/linux/hyperv.h
> +++ b/include/linux/hyperv.h
> @@ -722,7 +722,12 @@ struct vmbus_channel {
>  	 */
>  	void (*sc_creation_callback)(struct vmbus_channel *new_sc);
>  
> -	spinlock_t sc_lock;
> +	/*
> +	 * The spinlock to protect the structure. It is being used to 
> protect
> +	 * test-and-set access to various attributes of the structure as 
> well
> +	 * as all sc_list operations.
> +	 */
> +	spinlock_t lock;
>  	/*
>  	 * All Sub-channels of a primary channel are linked here.
>  	 */
> -- 
> 1.9.3
> 

