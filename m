Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311Ab3AWPMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:12:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825Ab3AWPMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:12:30 -0500
Date: Wed, 23 Jan 2013 17:16:27 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 1/2] tuntap: reduce memory using of queues
Message-ID: <20130123151627.GB1613@redhat.com>
References: <1358949553-30309-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358949553-30309-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 09:59:12PM +0800, Jason Wang wrote:
> A MAX_TAP_QUEUES(1024) queues of tuntap device is always allocated
> unconditionally even userspace only requires a single queue device. This is
> unnecessary and will lead a very high order of page allocation when has a high
> possibility to fail. Solving this by creating a one queue net device when
> userspace only use one queue and also reduce MAX_TAP_QUEUES to
> DEFAULT_MAX_NUM_RSS_QUEUES which can guarantee the success of
> the allocation.
> 
> Reported-by: Dirk Hohndel <dirk@hohndel.org>
> Cc: Eric Dumazet <eric.dumazet@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>

Note: this is a 3.8 patch, it fixes a regression.

Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/net/tun.c |   15 ++++++++-------
>  1 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index c81680d..8939d21 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -109,11 +109,10 @@ struct tap_filter {
>  	unsigned char	addr[FLT_EXACT_COUNT][ETH_ALEN];
>  };
>  
> -/* 1024 is probably a high enough limit: modern hypervisors seem to support on
> - * the order of 100-200 CPUs so this leaves us some breathing space if we want
> - * to match a queue per guest CPU.
> - */
> -#define MAX_TAP_QUEUES 1024
> +/* DEFAULT_MAX_NUM_RSS_QUEUES were choosed to let the rx/tx queues allocated for
> + * the netdevice to be fit in one page. So we can make sure the success of
> + * memory allocation. TODO: increase the limit. */
> +#define MAX_TAP_QUEUES DEFAULT_MAX_NUM_RSS_QUEUES
>  
>  #define TUN_FLOW_EXPIRE (3 * HZ)
>  
> @@ -1583,6 +1582,8 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  	else {
>  		char *name;
>  		unsigned long flags = 0;
> +		int queues = ifr->ifr_flags & IFF_MULTI_QUEUE ?
> +			     MAX_TAP_QUEUES : 1;
>  
>  		if (!ns_capable(net->user_ns, CAP_NET_ADMIN))
>  			return -EPERM;
> @@ -1606,8 +1607,8 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
>  			name = ifr->ifr_name;
>  
>  		dev = alloc_netdev_mqs(sizeof(struct tun_struct), name,
> -				       tun_setup,
> -				       MAX_TAP_QUEUES, MAX_TAP_QUEUES);
> +				       tun_setup, queues, queues);
> +
>  		if (!dev)
>  			return -ENOMEM;
>  
> -- 
> 1.7.1
