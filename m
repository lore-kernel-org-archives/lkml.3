Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757859Ab3JOATQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 20:19:16 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:23286 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757325Ab3JOATO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 20:19:14 -0400
X-IronPort-AV: E=Sophos;i="4.93,495,1378828800"; 
   d="scan'208";a="8755407"
Message-ID: <525C89D8.4020306@cn.fujitsu.com>
Date: Tue, 15 Oct 2013 08:18:32 +0800
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Reply-To: gaowanlong@cn.fujitsu.com
Organization: Fujitsu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Jason Wang <jasowang@redhat.com>
CC: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: [PATCH net 1/2] virtio-net: don't respond to cpu hotplug notifier
 if we're not ready
References: <1381744595-26881-1-git-send-email-jasowang@redhat.com>
In-Reply-To: <1381744595-26881-1-git-send-email-jasowang@redhat.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 08:16:54,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/10/15 08:16:56,
	Serialize complete at 2013/10/15 08:16:56
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2013 05:56 PM, Jason Wang wrote:
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

Thank you.

Reviewed-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>


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
> 

