Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab3JNLD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 07:03:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7341 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755306Ab3JNLDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 07:03:55 -0400
Date: Mon, 14 Oct 2013 14:06:21 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH net 1/2] virtio-net: don't respond to cpu hotplug
 notifier if we're not ready
Message-ID: <20131014110621.GF30954@redhat.com>
References: <1381744595-26881-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381744595-26881-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 05:56:34PM +0800, Jason Wang wrote:
> We're trying to re-configure the affinity unconditionally in cpu hotplug
> callback. This may lead the issue during resuming from s3/s4 since
> 
> - virt queues haven't been allocated at that time.
> - it's unnecessary since thaw method will re-configure the affinity.
> 
> Fix this issue by checking the config_enable and do nothing is we're not ready.
> 
> The bug were introduced by commit 8de4b2f3ae90c8fc0f17eeaab87d5a951b66ee17
> (virtio-net: reset virtqueue affinity when doing cpu hotplug).
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
> The patch is need for 3.8 and above.
> ---
>  drivers/net/virtio_net.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index defec2b..c4bc1cc 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -1116,6 +1116,11 @@ static int virtnet_cpu_callback(struct notifier_block *nfb,
>  {
>  	struct virtnet_info *vi = container_of(nfb, struct virtnet_info, nb);
>  
> +	mutex_lock(&vi->config_lock);
> +
> +	if (!vi->config_enable)
> +		goto done;
> +
>  	switch(action & ~CPU_TASKS_FROZEN) {
>  	case CPU_ONLINE:
>  	case CPU_DOWN_FAILED:
> @@ -1128,6 +1133,9 @@ static int virtnet_cpu_callback(struct notifier_block *nfb,
>  	default:
>  		break;
>  	}
> +
> +done:
> +	mutex_unlock(&vi->config_lock);
>  	return NOTIFY_OK;
>  }
>  
> -- 
> 1.8.1.2
