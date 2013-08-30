Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755389Ab3H3VKa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 17:10:30 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:43096 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab3H3VK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 17:10:28 -0400
Message-ID: <1377881073.2065.10.camel@bwh-desktop.uk.level5networks.com>
Subject: Re: [PATCH V2 5/6] vhost_net: poll vhost queue after marking DMA
 is done
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jason Wang <jasowang@redhat.com>
CC: <mst@redhat.com>, <kvm@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
In-Reply-To: <1377836962-49780-6-git-send-email-jasowang@redhat.com>
References: <1377836962-49780-1-git-send-email-jasowang@redhat.com>
	 <1377836962-49780-6-git-send-email-jasowang@redhat.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Aug 2013 17:44:33 +0100
MIME-Version: 1.0
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-20114.005
X-TM-AS-Result: No--15.732400-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-30 at 12:29 +0800, Jason Wang wrote:
> We used to poll vhost queue before making DMA is done, this is racy if vhost
> thread were waked up before marking DMA is done which can result the signal to
> be missed. Fix this by always poll the vhost thread before DMA is done.

Does this bug only exist in net-next or is it older?  Should the fix go
to net and stable branches?

Ben.

> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/vhost/net.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index ff60c2a..d09c17c 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -308,6 +308,11 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  	struct vhost_virtqueue *vq = ubufs->vq;
>  	int cnt = atomic_read(&ubufs->kref.refcount);
>  
> +	/* set len to mark this desc buffers done DMA */
> +	vq->heads[ubuf->desc].len = success ?
> +		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
> +	vhost_net_ubuf_put(ubufs);
> +
>  	/*
>  	 * Trigger polling thread if guest stopped submitting new buffers:
>  	 * in this case, the refcount after decrement will eventually reach 1
> @@ -318,10 +323,6 @@ static void vhost_zerocopy_callback(struct ubuf_info *ubuf, bool success)
>  	 */
>  	if (cnt <= 2 || !(cnt % 16))
>  		vhost_poll_queue(&vq->poll);
> -	/* set len to mark this desc buffers done DMA */
> -	vq->heads[ubuf->desc].len = success ?
> -		VHOST_DMA_DONE_LEN : VHOST_DMA_FAILED_LEN;
> -	vhost_net_ubuf_put(ubufs);
>  }
>  
>  /* Expects to be always run from workqueue - which acts as

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

