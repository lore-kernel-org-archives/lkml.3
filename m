Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755638AbaEHUEF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 16:04:05 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49574 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbaEHUEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 16:04:02 -0400
X-Sasl-enc: kCGJBMPam396Wk92bc5boOxVmxDSwKwY/rmzAvzw91Wc 1399579441
Date: Thu, 8 May 2014 22:03:52 +0200
From: Greg KH <greg@kroah.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, olaf@aepfle.de,
        jasowang@redhat.com, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next, v2] Add support for netvsc build without
 CONFIG_SYSFS flag
Message-ID: <20140508200352.GB8847@kroah.com>
References: <1399581693-25050-1-git-send-email-haiyangz@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399581693-25050-1-git-send-email-haiyangz@microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 08, 2014 at 01:41:33PM -0700, Haiyang Zhang wrote:
> This change ensures the driver can be built successfully without the
> CONFIG_SYSFS flag.
> MS-TFS: 182270
> 
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> Reviewed-by: K. Y. Srinivasan <kys@microsoft.com>
> ---
>  drivers/net/hyperv/hyperv_net.h   |   28 ++++++++++++++++++++++++++++
>  drivers/net/hyperv/netvsc_drv.c   |   13 +++++++------
>  drivers/net/hyperv/rndis_filter.c |    4 ++--
>  3 files changed, 37 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/net/hyperv/hyperv_net.h b/drivers/net/hyperv/hyperv_net.h
> index 4b7df5a..02358cb 100644
> --- a/drivers/net/hyperv/hyperv_net.h
> +++ b/drivers/net/hyperv/hyperv_net.h
> @@ -87,6 +87,8 @@ struct ndis_recv_scale_cap { /* NDIS_RECEIVE_SCALE_CAPABILITIES */
>  #define HASH_KEYLEN NDIS_RSS_HASH_SECRET_KEY_MAX_SIZE_REVISION_2
>  extern u8 netvsc_hash_key[];
>  
> +extern unsigned int netvsc_num_queue;
> +
>  struct ndis_recv_scale_param { /* NDIS_RECEIVE_SCALE_PARAMETERS */
>  	struct ndis_obj_header hdr;
>  
> @@ -178,6 +180,32 @@ struct rndis_device {
>  	unsigned char hw_mac_adr[ETH_ALEN];
>  };
>  
> +static inline void netvsc_record_rx_queue(struct sk_buff *skb,
> +					  struct hv_netvsc_packet *packet,
> +					  struct net_device *ndev)
> +{
> +#ifdef CONFIG_SYSFS
> +	skb_record_rx_queue(skb, packet->channel->
> +			    offermsg.offer.sub_channel_index %
> +			    ndev->real_num_rx_queues);
> +#endif

Really?  Do all other wireless drivers have this type of #ifdef needed?

> +}
> +
> +static inline void netvsc_show_num_queue(struct device *dev,
> +					 struct net_device *ndev)
> +{
> +#ifdef CONFIG_SYSFS
> +	dev_info(dev, "real num tx,rx queues:%u, %u\n",
> +		 ndev->real_num_tx_queues, ndev->real_num_rx_queues);
> +#endif

Do network drivers really spam the kernel log with this type of thing?
If you have sysfs, why is this needed in the kernel log?

> +}
> +
> +static inline void netvsc_set_num_queue(unsigned int *nq)
> +{
> +#ifdef CONFIG_SYSFS
> +	*nq = num_online_cpus();
> +#endif
> +}

I really feel that something is odd here...

