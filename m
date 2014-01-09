Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbaAIMUU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 07:20:20 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37722 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbaAIMUN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 07:20:13 -0500
Date: Thu, 9 Jan 2014 07:20:04 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: Jason Wang <jasowang@redhat.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, John Fastabend <john.r.fastabend@intel.com>
Subject: Re: [PATCH net V2 1/2] macvlan: forbid L2 fowarding offload for
 macvtap
Message-ID: <20140109122004.GB16701@hmsreliant.think-freely.org>
References: <1389260252-48591-1-git-send-email-jasowang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389260252-48591-1-git-send-email-jasowang@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 05:37:31PM +0800, Jason Wang wrote:
> L2 fowarding offload will bypass the rx handler of real device. This will make
> the packet could not be forwarded to macvtap device. Another problem is the
> dev_hard_start_xmit() called for macvtap does not have any synchronization.
> 
> Fix this by forbidding L2 forwarding for macvtap.
> 
> Cc: John Fastabend <john.r.fastabend@intel.com>
> Cc: Neil Horman <nhorman@tuxdriver.com>
> Signed-off-by: Jason Wang <jasowang@redhat.com>
> ---
>  drivers/net/macvlan.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
> index 60406b0..5360f73 100644
> --- a/drivers/net/macvlan.c
> +++ b/drivers/net/macvlan.c
> @@ -338,6 +338,8 @@ static const struct header_ops macvlan_hard_header_ops = {
>  	.cache_update	= eth_header_cache_update,
>  };
>  
> +static struct rtnl_link_ops macvlan_link_ops;
> +
>  static int macvlan_open(struct net_device *dev)
>  {
>  	struct macvlan_dev *vlan = netdev_priv(dev);
> @@ -353,7 +355,8 @@ static int macvlan_open(struct net_device *dev)
>  		goto hash_add;
>  	}
>  
> -	if (lowerdev->features & NETIF_F_HW_L2FW_DOFFLOAD) {
> +	if (lowerdev->features & NETIF_F_HW_L2FW_DOFFLOAD &&
> +	    dev->rtnl_link_ops == &macvlan_link_ops) {
>  		vlan->fwd_priv =
>  		      lowerdev->netdev_ops->ndo_dfwd_add_station(lowerdev, dev);
>  

Acked-by: Neil Horman <nhorman@tuxdriver.com>

