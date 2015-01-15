Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752895AbbAOKfZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 05:35:25 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:52781 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbbAOKfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 05:35:20 -0500
Message-ID: <54B797E5.6070503@atmel.com>
Date: Thu, 15 Jan 2015 11:35:17 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Xander Huff <xander.huff@ni.com>, <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <jaeden.amero@ni.com>, <rich.tollerton@ni.com>,
        <ben.shelton@ni.com>, <brad.mouring@ni.com>,
        <linux-kernel@vger.kernel.org>, <cyrille.pitchen@atmel.com>
Subject: Re: [PATCH v2 2/2] fixup! net/macb: improved ethtool statistics support
References: <20150114.165220.2282566005036464131.davem@davemloft.net> <1421274051-21588-1-git-send-email-xander.huff@ni.com> <1421274051-21588-2-git-send-email-xander.huff@ni.com>
In-Reply-To: <1421274051-21588-2-git-send-email-xander.huff@ni.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 14/01/2015 23:20, Xander Huff a écrit :
> Add spaces around arithmetic operators.
> Make a separate gem_ethtool_ops for the new statistics functions.
> Adjust new block comments to match the existing comments in macb.h.

I wouldn't have mixed the 3 modification in one patch.

More comments below...

> Signed-off-by: Xander Huff <xander.huff@ni.com>
> ---
>  drivers/net/ethernet/cadence/macb.c |  25 +++--
>  drivers/net/ethernet/cadence/macb.h | 203 +++++++++---------------------------
>  2 files changed, 68 insertions(+), 160 deletions(-)
> 
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index dd8c202..f60f8f8 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -1832,15 +1832,15 @@ static void gem_update_stats(struct macb *bp)
>  
>  	for (i = 0; i < GEM_STATS_LEN; ++i, ++p) {
>  		u32 offset = gem_statistics[i].offset;
> -		u64 val = __raw_readl(bp->regs+offset);
> +		u64 val = __raw_readl(bp->regs + offset);
>  
>  		bp->ethtool_stats[i] += val;
>  		*p += val;
>  
>  		if (offset == GEM_OCTTXL || offset == GEM_OCTRXL) {
>  			/* Add GEM_OCTTXH, GEM_OCTRXH */
> -			val = __raw_readl(bp->regs+offset+4);
> -			bp->ethtool_stats[i] += ((u64)val)<<32;
> +			val = __raw_readl(bp->regs+offset + 4);
> +			bp->ethtool_stats[i] += ((u64)val) << 32;
>  			*(++p) += val;
>  		}
>  	}
> @@ -1891,7 +1891,7 @@ static void gem_get_ethtool_stats(struct net_device *dev,
>  
>  	bp = netdev_priv(dev);
>  	gem_update_stats(bp);
> -	memcpy(data, &bp->ethtool_stats, sizeof(u64)*GEM_STATS_LEN);
> +	memcpy(data, &bp->ethtool_stats, sizeof(u64) * GEM_STATS_LEN);
>  }
>  
>  static int gem_get_sset_count(struct net_device *dev, int sset)
> @@ -2032,11 +2032,21 @@ const struct ethtool_ops macb_ethtool_ops = {
>  	.get_regs		= macb_get_regs,
>  	.get_link		= ethtool_op_get_link,
>  	.get_ts_info		= ethtool_op_get_ts_info,
> +};
> +EXPORT_SYMBOL_GPL(macb_ethtool_ops);
> +
> +const struct ethtool_ops gem_ethtool_ops = {
> +	.get_settings		= macb_get_settings,
> +	.set_settings		= macb_set_settings,
> +	.get_regs_len		= macb_get_regs_len,
> +	.get_regs		= macb_get_regs,
> +	.get_link		= ethtool_op_get_link,
> +	.get_ts_info		= ethtool_op_get_ts_info,
>  	.get_ethtool_stats	= gem_get_ethtool_stats,
>  	.get_strings		= gem_get_ethtool_strings,
>  	.get_sset_count		= gem_get_sset_count,
>  };
> -EXPORT_SYMBOL_GPL(macb_ethtool_ops);
> +EXPORT_SYMBOL_GPL(gem_ethtool_ops);
>  
>  int macb_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>  {
> @@ -2325,7 +2335,10 @@ static int __init macb_probe(struct platform_device *pdev)
>  
>  	dev->netdev_ops = &macb_netdev_ops;
>  	netif_napi_add(dev, &bp->napi, macb_poll, 64);
> -	dev->ethtool_ops = &macb_ethtool_ops;
> +	if (macb_is_gem(bp))

There is such a test 3 lines after: why not insert these setup there? It
seems to me that ethtool_ops is not used in the gap.


> +		dev->ethtool_ops = &gem_ethtool_ops;
> +	else
> +		dev->ethtool_ops = &macb_ethtool_ops;
>  
>  	dev->base_addr = regs->start;
>  
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index d7b93d0..2ea5355 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -82,159 +82,52 @@
>  #define GEM_SA4B				0x00A0 /* Specific4 Bottom */
>  #define GEM_SA4T				0x00A4 /* Specific4 Top */
>  #define GEM_OTX					0x0100 /* Octets transmitted */

I see, it's modified hereafter! Why not integrate this part in previous
patch?


> -#define GEM_OCTTXL				0x0100 /* Octets transmitted
> -							* [31:0]
> -							*/
> -#define GEM_OCTTXH				0x0104 /* Octets transmitted
> -							* [47:32]
> -							*/
> -#define GEM_TXCNT				0x0108 /* Error-free Frames
> -							* Transmitted counter
> -							*/
> -#define GEM_TXBCCNT				0x010c /* Error-free Broadcast
> -							* Frames counter
> -							*/
> -#define GEM_TXMCCNT				0x0110 /* Error-free Multicast
> -							* Frames counter
> -							*/
> -#define GEM_TXPAUSECNT				0x0114 /* Pause Frames
> -							* Transmitted Counter
> -							*/
> -#define GEM_TX64CNT				0x0118 /* Error-free 64 byte
> -							* Frames Transmitted
> -							* counter
> -							*/
> -#define GEM_TX65CNT				0x011c /* Error-free 65-127 byte
> -							* Frames Transmitted
> -							* counter
> -							*/
> -#define GEM_TX128CNT				0x0120 /* Error-free 128-255
> -							* byte Frames
> -							* Transmitted counter
> -							*/
> -#define GEM_TX256CNT				0x0124 /* Error-free 256-511
> -							* byte Frames
> -							* transmitted counter
> -							*/
> -#define GEM_TX512CNT				0x0128 /* Error-free 512-1023
> -							* byte Frames
> -							* transmitted counter
> -							*/
> -#define GEM_TX1024CNT				0x012c /* Error-free 1024-1518
> -							* byte Frames
> -							* transmitted counter
> -							*/
> -#define GEM_TX1519CNT				0x0130 /* Error-free larger than
> -							* 1519 byte Frames
> -							* tranmitted counter
> -							*/
> -#define GEM_TXURUNCNT				0x0134 /* TX under run error
> -							* counter
> -							*/
> -#define GEM_SNGLCOLLCNT				0x0138 /* Single Collision Frame
> -							* Counter
> -							*/
> -#define GEM_MULTICOLLCNT			0x013c /* Multiple Collision
> -							* Frame Counter
> -							*/
> -#define GEM_EXCESSCOLLCNT			0x0140 /* Excessive Collision
> -							* Frame Counter
> -							*/
> -#define GEM_LATECOLLCNT				0x0144 /* Late Collision Frame
> -							* Counter
> -							*/
> -#define GEM_TXDEFERCNT				0x0148 /* Deferred Transmission
> -							* Frame Counter
> -							*/
> -#define GEM_TXCSENSECNT				0x014c /* Carrier Sense Error
> -							* Counter
> -							*/
> +#define GEM_OCTTXL				0x0100 /* Octets transmitted [31:0] */
> +#define GEM_OCTTXH				0x0104 /* Octets transmitted [47:32] */
> +#define GEM_TXCNT				0x0108 /* Error-free Frames Transmitted counter */
> +#define GEM_TXBCCNT				0x010c /* Error-free Broadcast Frames counter */
> +#define GEM_TXMCCNT				0x0110 /* Error-free Multicast Frames counter */
> +#define GEM_TXPAUSECNT				0x0114 /* Pause Frames Transmitted Counter */
> +#define GEM_TX64CNT				0x0118 /* Error-free 64 byte Frames Transmitted counter */
> +#define GEM_TX65CNT				0x011c /* Error-free 65-127 byte Frames Transmitted counter */
> +#define GEM_TX128CNT				0x0120 /* Error-free 128-255 byte Frames Transmitted counter */
> +#define GEM_TX256CNT				0x0124 /* Error-free 256-511 byte Frames transmitted counter */
> +#define GEM_TX512CNT				0x0128 /* Error-free 512-1023 byte Frames transmitted counter */
> +#define GEM_TX1024CNT				0x012c /* Error-free 1024-1518 byte Frames transmitted counter */
> +#define GEM_TX1519CNT				0x0130 /* Error-free larger than 1519 byte Frames tranmitted counter */
> +#define GEM_TXURUNCNT				0x0134 /* TX under run error counter */
> +#define GEM_SNGLCOLLCNT				0x0138 /* Single Collision Frame Counter */
> +#define GEM_MULTICOLLCNT			0x013c /* Multiple Collision Frame Counter */
> +#define GEM_EXCESSCOLLCNT			0x0140 /* Excessive Collision Frame Counter */
> +#define GEM_LATECOLLCNT				0x0144 /* Late Collision Frame Counter */
> +#define GEM_TXDEFERCNT				0x0148 /* Deferred Transmission Frame Counter */
> +#define GEM_TXCSENSECNT				0x014c /* Carrier Sense Error Counter */
>  #define GEM_ORX					0x0150 /* Octets received */
> -#define GEM_OCTRXL				0x0150 /* Octets received
> -							* [31:0]
> -							*/
> -#define GEM_OCTRXH				0x0154 /* Octets received
> -							* [47:32]
> -							*/
> -#define GEM_RXCNT				0x0158 /* Error-free Frames
> -							* Received Counter
> -							*/
> -#define GEM_RXBROADCNT				0x015c /* Error-free Broadcast
> -							* Frames Received
> -							* Counter
> -							*/
> -#define GEM_RXMULTICNT				0x0160 /* Error-free Multicast
> -							* Frames Received
> -							* Counter
> -							*/
> -#define GEM_RXPAUSECNT				0x0164 /* Error-free Pause
> -							* Frames Received
> -							* Counter
> -							*/
> -#define GEM_RX64CNT				0x0168 /* Error-free 64 byte
> -							* Frames Received
> -							* Counter
> -							*/
> -#define GEM_RX65CNT				0x016c /* Error-free 65-127 byte
> -							* Frames Received
> -							* Counter
> -							*/
> -#define GEM_RX128CNT				0x0170 /* Error-free 128-255
> -							* byte Frames Received
> -							* Counter
> -							*/
> -#define GEM_RX256CNT				0x0174 /* Error-free 256-511
> -							* byte Frames Received
> -							* Counter
> -							*/
> -#define GEM_RX512CNT				0x0178 /* Error-free 512-1023
> -							* byte Frames Received
> -							* Counter
> -							*/
> -#define GEM_RX1024CNT				0x017c /* Error-free 1024-1518
> -							* byte Frames Received
> -							* Counter
> -							*/
> -#define GEM_RX1519CNT				0x0180 /* Error-free larger than
> -							* 1519 Frames Received
> -							* Counter
> -							*/
> -#define GEM_RXUNDRCNT				0x0184 /* Undersize Frames
> -							* Received Counter
> -							*/
> -#define GEM_RXOVRCNT				0x0188 /* Oversize Frames
> -							* Received Counter
> -							*/
> -#define GEM_RXJABCNT				0x018c /* Jabbers Received
> -							* Counter
> -							*/
> -#define GEM_RXFCSCNT				0x0190 /* Frame Check Sequence
> -							* Error Counter
> -							*/
> -#define GEM_RXLENGTHCNT				0x0194 /* Length Field Error
> -							* Counter
> -							*/
> -#define GEM_RXSYMBCNT				0x0198 /* Symbol Error
> -							* Counter
> -							*/
> -#define GEM_RXALIGNCNT				0x019c /* Alignment Error
> -							* Counter
> -							*/
> -#define GEM_RXRESERRCNT				0x01a0 /* Receive Resource Error
> -							* Counter
> -							*/
> -#define GEM_RXORCNT				0x01a4 /* Receive Overrun
> -							* Counter
> -							*/
> -#define GEM_RXIPCCNT				0x01a8 /* IP header Checksum
> -							* Error Counter
> -							*/
> -#define GEM_RXTCPCCNT				0x01ac /* TCP Checksum Error
> -							* Counter
> -							*/
> -#define GEM_RXUDPCCNT				0x01b0 /* UDP Checksum Error
> -							* Counter
> -							*/
> +#define GEM_OCTRXL				0x0150 /* Octets received [31:0] */
> +#define GEM_OCTRXH				0x0154 /* Octets received [47:32] */
> +#define GEM_RXCNT				0x0158 /* Error-free Frames Received Counter */
> +#define GEM_RXBROADCNT				0x015c /* Error-free Broadcast Frames Received Counter */
> +#define GEM_RXMULTICNT				0x0160 /* Error-free Multicast Frames Received Counter */
> +#define GEM_RXPAUSECNT				0x0164 /* Error-free Pause Frames Received Counter */
> +#define GEM_RX64CNT				0x0168 /* Error-free 64 byte Frames Received Counter */
> +#define GEM_RX65CNT				0x016c /* Error-free 65-127 byte Frames Received Counter */
> +#define GEM_RX128CNT				0x0170 /* Error-free 128-255 byte Frames Received Counter */
> +#define GEM_RX256CNT				0x0174 /* Error-free 256-511 byte Frames Received Counter */
> +#define GEM_RX512CNT				0x0178 /* Error-free 512-1023 byte Frames Received Counter */
> +#define GEM_RX1024CNT				0x017c /* Error-free 1024-1518 byte Frames Received Counter */
> +#define GEM_RX1519CNT				0x0180 /* Error-free larger than 1519 Frames Received Counter */
> +#define GEM_RXUNDRCNT				0x0184 /* Undersize Frames Received Counter */
> +#define GEM_RXOVRCNT				0x0188 /* Oversize Frames Received Counter */
> +#define GEM_RXJABCNT				0x018c /* Jabbers Received Counter */
> +#define GEM_RXFCSCNT				0x0190 /* Frame Check Sequence Error Counter */
> +#define GEM_RXLENGTHCNT				0x0194 /* Length Field Error Counter */
> +#define GEM_RXSYMBCNT				0x0198 /* Symbol Error Counter */
> +#define GEM_RXALIGNCNT				0x019c /* Alignment Error Counter */
> +#define GEM_RXRESERRCNT				0x01a0 /* Receive Resource Error Counter */
> +#define GEM_RXORCNT				0x01a4 /* Receive Overrun Counter */
> +#define GEM_RXIPCCNT				0x01a8 /* IP header Checksum Error Counter */
> +#define GEM_RXTCPCCNT				0x01ac /* TCP Checksum Error Counter */
> +#define GEM_RXUDPCCNT				0x01b0 /* UDP Checksum Error Counter */
>  #define GEM_DCFG1				0x0280 /* Design Config 1 */
>  #define GEM_DCFG2				0x0284 /* Design Config 2 */
>  #define GEM_DCFG3				0x0288 /* Design Config 3 */
> @@ -748,7 +641,8 @@ struct gem_stats {
>  	u32	rx_udp_checksum_errors;
>  };
>  
> -/* Describes the name and offset of an individual statistic register, as
> +/*
> + * Describes the name and offset of an individual statistic register, as
>   * returned by `ethtool -S`. Also describes which net_device_stats statistics
>   * this register should contribute to.
>   */
> @@ -778,7 +672,8 @@ struct gem_statistic {
>  	.stat_bits = bits				\
>  }
>  
> -/* list of gem statistic registers. The names MUST match the
> +/*
> + * list of gem statistic registers. The names MUST match the
>   * corresponding GEM_* definitions.
>   */
>  static const struct gem_statistic gem_statistics[] = {

Anyway, thanks for having posted a new revision. Can you prepare another
series?

Bye,
-- 
Nicolas Ferre
