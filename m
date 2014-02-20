Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbaBTSha (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 13:37:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42738 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753733AbaBTSh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 13:37:28 -0500
Message-ID: <53064B63.2050803@infradead.org>
Date: Thu, 20 Feb 2014 10:37:23 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: linux-next: Tree for Feb 19 (netdev)
References: <20140219164733.781c782bc5ad4f5eaf25a636@canb.auug.org.au>	<5304C8D9.5000906@infradead.org> <20140220.021320.1623323851847472760.davem@davemloft.net>
In-Reply-To: <20140220.021320.1623323851847472760.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/14 23:13, David Miller wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> Date: Wed, 19 Feb 2014 07:08:09 -0800
> 
>> on i386:
>>
>> net/built-in.o:(.rodata+0x1707c): undefined reference to `ip_tunnel_get_stats64'
>>
>> Full randconfig file is attached.
> 
> Thanks for the report Randy, this should do it:

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 6d430ff..7b19528 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -119,52 +119,6 @@ static struct rtable *tunnel_rtable_get(struct ip_tunnel *t, u32 cookie)
>  	return (struct rtable *)dst;
>  }
>  
> -/* Often modified stats are per cpu, other are shared (netdev->stats) */
> -struct rtnl_link_stats64 *ip_tunnel_get_stats64(struct net_device *dev,
> -						struct rtnl_link_stats64 *tot)
> -{
> -	int i;
> -
> -	for_each_possible_cpu(i) {
> -		const struct pcpu_sw_netstats *tstats =
> -						   per_cpu_ptr(dev->tstats, i);
> -		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
> -		unsigned int start;
> -
> -		do {
> -			start = u64_stats_fetch_begin_bh(&tstats->syncp);
> -			rx_packets = tstats->rx_packets;
> -			tx_packets = tstats->tx_packets;
> -			rx_bytes = tstats->rx_bytes;
> -			tx_bytes = tstats->tx_bytes;
> -		} while (u64_stats_fetch_retry_bh(&tstats->syncp, start));
> -
> -		tot->rx_packets += rx_packets;
> -		tot->tx_packets += tx_packets;
> -		tot->rx_bytes   += rx_bytes;
> -		tot->tx_bytes   += tx_bytes;
> -	}
> -
> -	tot->multicast = dev->stats.multicast;
> -
> -	tot->rx_crc_errors = dev->stats.rx_crc_errors;
> -	tot->rx_fifo_errors = dev->stats.rx_fifo_errors;
> -	tot->rx_length_errors = dev->stats.rx_length_errors;
> -	tot->rx_frame_errors = dev->stats.rx_frame_errors;
> -	tot->rx_errors = dev->stats.rx_errors;
> -
> -	tot->tx_fifo_errors = dev->stats.tx_fifo_errors;
> -	tot->tx_carrier_errors = dev->stats.tx_carrier_errors;
> -	tot->tx_dropped = dev->stats.tx_dropped;
> -	tot->tx_aborted_errors = dev->stats.tx_aborted_errors;
> -	tot->tx_errors = dev->stats.tx_errors;
> -
> -	tot->collisions  = dev->stats.collisions;
> -
> -	return tot;
> -}
> -EXPORT_SYMBOL_GPL(ip_tunnel_get_stats64);
> -
>  static bool ip_tunnel_key_match(const struct ip_tunnel_parm *p,
>  				__be16 flags, __be32 key)
>  {
> diff --git a/net/ipv4/ip_tunnel_core.c b/net/ipv4/ip_tunnel_core.c
> index 6156f4e..8d69626 100644
> --- a/net/ipv4/ip_tunnel_core.c
> +++ b/net/ipv4/ip_tunnel_core.c
> @@ -148,3 +148,49 @@ error:
>  	return ERR_PTR(err);
>  }
>  EXPORT_SYMBOL_GPL(iptunnel_handle_offloads);
> +
> +/* Often modified stats are per cpu, other are shared (netdev->stats) */
> +struct rtnl_link_stats64 *ip_tunnel_get_stats64(struct net_device *dev,
> +						struct rtnl_link_stats64 *tot)
> +{
> +	int i;
> +
> +	for_each_possible_cpu(i) {
> +		const struct pcpu_sw_netstats *tstats =
> +						   per_cpu_ptr(dev->tstats, i);
> +		u64 rx_packets, rx_bytes, tx_packets, tx_bytes;
> +		unsigned int start;
> +
> +		do {
> +			start = u64_stats_fetch_begin_bh(&tstats->syncp);
> +			rx_packets = tstats->rx_packets;
> +			tx_packets = tstats->tx_packets;
> +			rx_bytes = tstats->rx_bytes;
> +			tx_bytes = tstats->tx_bytes;
> +		} while (u64_stats_fetch_retry_bh(&tstats->syncp, start));
> +
> +		tot->rx_packets += rx_packets;
> +		tot->tx_packets += tx_packets;
> +		tot->rx_bytes   += rx_bytes;
> +		tot->tx_bytes   += tx_bytes;
> +	}
> +
> +	tot->multicast = dev->stats.multicast;
> +
> +	tot->rx_crc_errors = dev->stats.rx_crc_errors;
> +	tot->rx_fifo_errors = dev->stats.rx_fifo_errors;
> +	tot->rx_length_errors = dev->stats.rx_length_errors;
> +	tot->rx_frame_errors = dev->stats.rx_frame_errors;
> +	tot->rx_errors = dev->stats.rx_errors;
> +
> +	tot->tx_fifo_errors = dev->stats.tx_fifo_errors;
> +	tot->tx_carrier_errors = dev->stats.tx_carrier_errors;
> +	tot->tx_dropped = dev->stats.tx_dropped;
> +	tot->tx_aborted_errors = dev->stats.tx_aborted_errors;
> +	tot->tx_errors = dev->stats.tx_errors;
> +
> +	tot->collisions  = dev->stats.collisions;
> +
> +	return tot;
> +}
> +EXPORT_SYMBOL_GPL(ip_tunnel_get_stats64);
> --


-- 
~Randy
