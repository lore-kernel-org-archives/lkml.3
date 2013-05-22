Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754951Ab3EVFq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 01:46:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752271Ab3EVFq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 01:46:56 -0400
Message-ID: <519C5BBE.3060407@redhat.com>
Date: Wed, 22 May 2013 13:46:38 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] virtio_net: enable napi after enabling new queues
References: <1369200149-11280-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1369200149-11280-1-git-send-email-jasowang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 01:22 PM, Jason Wang wrote:
> Commit 55257d72bd1c51f25106350f4983ec19f62ed1fa (virtio-net: fill only rx
> queues which are being used) forgets to enable napi for new enabled queues which
> breaks the multiqueue receiving. This patch fixes it.
>
> Cc: Sasha Levin <sasha.levin@oracle.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/virtio_net.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 2d6abac..9b2f59f 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -914,9 +914,11 @@ static int virtnet_set_queues(struct virtnet_info *vi, u16 queue_pairs)
>  			 queue_pairs);
>  		return -EINVAL;
>  	} else {
> -		for (i = vi->curr_queue_pairs; i < queue_pairs; i++)
> +		for (i = vi->curr_queue_pairs; i < queue_pairs; i++) {
>  			if (!try_fill_recv(&vi->rq[i], GFP_KERNEL))
>  				schedule_delayed_work(&vi->refill, 0);
> +			virtnet_napi_enable(&vi->rq[i]);
> +		}
>  		vi->curr_queue_pairs = queue_pairs;
>  	}
>  
A bug were found in this patch, will send a new version.
