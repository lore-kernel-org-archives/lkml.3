Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaH2OxA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 10:53:00 -0400
Received: from top.free-electrons.com ([176.31.233.9]:49582 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752528AbaH2Ow6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 10:52:58 -0400
Date: Fri, 29 Aug 2014 11:51:45 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Antoine Tenart <antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, thomas.petazzoni@free-electrons.com,
        alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] net: mvberlin_eth: add an Ethernet driver for
 Marvell Berlin
Message-ID: <20140829145145.GA7735@arch.cereza>
References: <1409320263-10295-1-git-send-email-antoine.tenart@free-electrons.com>
 <1409320263-10295-2-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1409320263-10295-2-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

A quick look...

On 29 Aug 03:50 PM, Antoine Tenart wrote:
> This patch introduces the Marvell Berlin network unit driver, which uses
> the MVMDIO interface to communicate to the PHY. This is a fast Ethernet
> driver.
> 
> This driver is highly based on the mv643xx_eth driver, and reuse some of
> its functions. But lots of differences are there:
> - They do not have the same registers.
> - The mvberlin_eth driver only supports fast Ethernet.
> - The rx/tx handling functions logic is different.
> - The mv643xx_eth driver supports TSO.

TSO is just a software feature which needs just some basic hardware features
to work. I guess there's no point in implementing it for a fast Ethernet
controller?

> - The mvberlin_eth driver uses a hash table to filter incoming packets.
> 
> No packet is dropped during a ping flood (ping -f) and an iperf test
> shows:
> ------------------------------------------------------------
> Client connecting to 192.168.0.11, TCP port 5001
> TCP window size: 85.0 KByte (default)
> ------------------------------------------------------------
> [  3] local 192.168.0.20 port 44183 connected with 192.168.0.11 port 5001
> [ ID] Interval       Transfer     Bandwidth
> [  3]  0.0-10.0 sec   113 MBytes  94.8 Mbits/sec
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> ---
>  drivers/net/ethernet/marvell/Kconfig        |    9 +
>  drivers/net/ethernet/marvell/Makefile       |    1 +
>  drivers/net/ethernet/marvell/mvberlin_eth.c | 2081 +++++++++++++++++++++++++++
>  3 files changed, 2091 insertions(+)
>  create mode 100644 drivers/net/ethernet/marvell/mvberlin_eth.c
> 
> diff --git a/drivers/net/ethernet/marvell/Kconfig b/drivers/net/ethernet/marvell/Kconfig
> index 1b4fc7c639e6..a4f12257d099 100644
> --- a/drivers/net/ethernet/marvell/Kconfig
> +++ b/drivers/net/ethernet/marvell/Kconfig
> @@ -18,6 +18,15 @@ config NET_VENDOR_MARVELL
>  
>  if NET_VENDOR_MARVELL
>  
> +config MVBERLIN_ETH
> +	tristate "Marvell Berlin ethernet support"
> +	depends on ARCH_BERLIN && INET
> +	select PHYLIB
> +	select MVMDIO
> +	---help---
> +	  This driver supports the ethernet interface of the Marvell
> +	  Berlin SoCs.
> +
>  config MV643XX_ETH
>  	tristate "Marvell Discovery (643XX) and Orion ethernet support"
>  	depends on (MV64X60 || PPC32 || PLAT_ORION) && INET
> diff --git a/drivers/net/ethernet/marvell/Makefile b/drivers/net/ethernet/marvell/Makefile
> index f6425bd2884b..a802dba2503e 100644
> --- a/drivers/net/ethernet/marvell/Makefile
> +++ b/drivers/net/ethernet/marvell/Makefile
> @@ -2,6 +2,7 @@
>  # Makefile for the Marvell device drivers.
>  #
>  
> +obj-$(CONFIG_MVBERLIN_ETH) += mvberlin_eth.o
>  obj-$(CONFIG_MVMDIO) += mvmdio.o
>  obj-$(CONFIG_MV643XX_ETH) += mv643xx_eth.o
>  obj-$(CONFIG_MVNETA) += mvneta.o
> diff --git a/drivers/net/ethernet/marvell/mvberlin_eth.c b/drivers/net/ethernet/marvell/mvberlin_eth.c
> new file mode 100644
> index 000000000000..5f1874b58017
> --- /dev/null
> +++ b/drivers/net/ethernet/marvell/mvberlin_eth.c
> @@ -0,0 +1,2081 @@
> +/*
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Tenart <antoine.tenart@free-electrons.com>
> + * Jisheng Zhang <jszhang@marvell.com>
> + *
> + * Based on the driver for Marvell Discovery (MV643XX) and Marvell Orion
> + * ethernet ports
> + * Copyright (C) 2002 Matthew Dharm <mdharm@momenco.com>
> + *
> + * Based on the 64360 driver from:
> + * Copyright (C) 2002 Rabeeh Khoury <rabeeh@galileo.co.il>
> + *		      Rabeeh Khoury <rabeeh@marvell.com>
> + *
> + * Copyright (C) 2003 PMC-Sierra, Inc.,
> + *	written by Manish Lachwani
> + *
> + * Copyright (C) 2003 Ralf Baechle <ralf@linux-mips.org>
> + *
> + * Copyright (C) 2004-2006 MontaVista Software, Inc.
> + *			   Dale Farnsworth <dale@farnsworth.org>
> + *
> + * Copyright (C) 2004 Steven J. Hill <sjhill1@rockwellcollins.com>
> + *				     <sjhill@realitydiluted.com>
> + *
> + * Copyright (C) 2007-2008 Marvell Semiconductor
> + *			   Lennert Buytenhek <buytenh@marvell.com>
> + *
> + * Copyright (C) 2013 Michael Stapelberg <michael@stapelberg.de>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/etherdevice.h>
> +#include <linux/ethtool.h>
> +#include <linux/in.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/ip.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mv643xx_eth.h>
> +#include <linux/of.h>
> +#include <linux/of_irq.h>
> +#include <linux/of_net.h>
> +#include <linux/of_mdio.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/tcp.h>
> +#include <linux/types.h>
> +#include <linux/udp.h>
> +#include <linux/workqueue.h>
> +
> +static const char mvberlin_eth_driver_name[] = "mvberlin_eth";
> +static const char mvberlin_eth_driver_version[] = "1.0";
> +
> +/* Main per-port registers. These live at offset 0x0400 */
> +#define PORT_CONFIG			0x0000
> +#define  PROMISCUOUS_MODE		0x00000001

I think that using BIT() makes the code more readable.

> +
> +/* SDMA configuration register default value */
> +#if defined(__BIG_ENDIAN)
> +#define PORT_SDMA_CONFIG_DEFAULT_VALUE		\
> +		(BURST_SIZE_8_64BIT	|	\
> +		 0x3c			|	\
> +		 RX_FRAME_INTERRUPT)
> +#elif defined(__LITTLE_ENDIAN)
> +#define PORT_SDMA_CONFIG_DEFAULT_VALUE		\
> +		(BURST_SIZE_8_64BIT	|	\
> +		 BLM_RX_LE		|	\
> +		 BLM_TX_LE		|	\
> +		 0x3c			|	\
> +		 RX_FRAME_INTERRUPT)
> +#else
> +#error One of __BIG_ENDIAN or __LITTLE_ENDIAN must be defined
> +#endif
> +
> +/* Misc definitions */
> +#define DEFAULT_RX_QUEUE_SIZE	128
> +#define DEFAULT_TX_QUEUE_SIZE	512
> +#define SKB_DMA_REALIGN		((PAGE_SIZE - NET_SKB_PAD) % SMP_CACHE_BYTES)
> +
> +/* RX/TX descriptors */
> +#if defined(__BIG_ENDIAN)

Maybe you can pack this inside the above ifdef and squash all the
endian-dependent stuff?

> +struct rx_desc {
> +	u16 buf_size;		/* Buffer size				*/
> +	u16 byte_cnt;		/* Descriptor buffer byte count		*/
> +	u32 cmd_sts;		/* Command/status field			*/
> +	u32 next_desc_ptr;	/* Next descriptor pointer		*/
> +	u32 buf_ptr;		/* Descriptor buffer pointer		*/
> +};
> +
> +struct tx_desc {
> +	u16 byte_cnt;		/* buffer byte count			*/
> +	u16 l4i_chk;		/* CPU provided TCP checksum		*/
> +	u32 cmd_sts;		/* Command/status field			*/
> +	u32 next_desc_ptr;	/* Pointer to next descriptor		*/
> +	u32 buf_ptr;		/* pointer to buffer for this descriptor*/
> +};
> +#elif defined(__LITTLE_ENDIAN)
> +struct rx_desc {
> +	u32 cmd_sts;		/* Descriptor command status		*/
> +	u16 byte_cnt;		/* Descriptor buffer byte count		*/
> +	u16 buf_size;		/* Buffer size				*/
> +	u32 buf_ptr;		/* Descriptor buffer pointer		*/
> +	u32 next_desc_ptr;	/* Next descriptor pointer		*/
> +};
> +
> +struct tx_desc {
> +	u32 cmd_sts;		/* Command/status field			*/
> +	u16 l4i_chk;		/* CPU provided TCP checksum		*/
> +	u16 byte_cnt;		/* buffer byte count			*/
> +	u32 buf_ptr;		/* pointer to buffer for this descriptor*/
> +	u32 next_desc_ptr;	/* Pointer to next descriptor		*/
> +};
> +#else
> +#error One of __BIG_ENDIAN or __LITTLE_ENDIAN must be defined
> +#endif
> +
> +/* RX & TX descriptor command */
> +#define BUFFER_OWNED_BY_DMA		0x80000000
> +

Ditto about BIT() usage.

> +static netdev_tx_t mvberlin_eth_xmit(struct sk_buff *skb,
> +				     struct net_device *dev)
> +{
> +	struct mvberlin_eth_private *mp = netdev_priv(dev);
> +	int length, queue;
> +	struct tx_queue *txq;
> +	struct netdev_queue *nq;
> +
> +	queue = skb_get_queue_mapping(skb);
> +	txq = mp->txq + queue;
> +	nq = netdev_get_tx_queue(dev, queue);
> +
> +	if (has_tiny_unaligned_frags(skb) && __skb_linearize(skb)) {
> +		netdev_printk(KERN_DEBUG, dev,
> +			      "failed to linearize skb with tiny unaligned fragment\n");

netdev_dbg?

> +		return NETDEV_TX_BUSY;
> +	}
> +
> +	length = skb->len;
> +
> +	if (!txq_submit_skb(txq, skb, dev)) {
> +		txq->tx_bytes += length;
> +		txq->tx_packets++;
> +
> +		if (txq->tx_desc_count >= txq->tx_stop_threshold)
> +			netif_tx_stop_queue(nq);
> +	} else {
> +		txq->tx_dropped++;
> +		dev_kfree_skb_any(skb);
> +	}
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +
> +static void handle_link_event(struct mvberlin_eth_private *mp)
> +{
> +	struct net_device *dev = mp->dev;
> +	u32 port_status;
> +	int speed;
> +	int duplex;
> +	int fc;
> +
> +	port_status = rdlp(mp, PORT_STATUS);
> +	if (!(port_status & LINK_UP)) {
> +		if (netif_carrier_ok(dev)) {
> +			int i;
> +
> +			netdev_info(dev, "link down\n");
> +
> +			netif_carrier_off(dev);
> +
> +			for (i = 0; i < mp->txq_count; i++) {
> +				struct tx_queue *txq = mp->txq + i;
> +
> +				txq_reclaim(txq, txq->tx_ring_size, 1);
> +				txq_reset_hw_ptr(txq);
> +			}
> +		}
> +		return;
> +	}
> +
> +	switch (port_status & PORT_SPEED_MASK) {
> +	case PORT_SPEED_10:
> +		speed = 10;
> +		break;
> +	case PORT_SPEED_100:
> +		speed = 100;
> +		break;
> +	default:
> +		speed = -1;
> +		break;
> +	}
> +
> +	duplex = (port_status & FULL_DUPLEX) ? 1 : 0;
> +	fc = (port_status & FLOW_CONTROL_ENABLED) ? 1 : 0;
> +
> +	netdev_info(dev, "link up, %d Mb/s, %s duplex, flow control %sabled\n",
> +		    speed, duplex ? "full" : "half", fc ? "en" : "dis");

Maybe you can use phy_print_status() instead of rolling your own?

> +
> +	if (!netif_carrier_ok(dev))
> +		netif_carrier_on(dev);
> +}
> +
> +static irqreturn_t mvberlin_eth_irq(int irq, void *dev_id)
> +{
> +	struct net_device *dev = (struct net_device *)dev_id;
> +	struct mvberlin_eth_private *mp = netdev_priv(dev);
> +	u32 int_cause, txstatus;
> +	int i;
> +
> +	int_cause = rdlp(mp, INT_CAUSE) & mp->int_mask;
> +
> +	if (int_cause == 0)
> +		return IRQ_NONE;
> +	wrlp(mp, INT_CAUSE, ~int_cause);
> +
> +	if (int_cause & INT_RX) {
> +		wrlp(mp, INT_MASK, mp->int_mask & ~INT_RX);
> +		napi_schedule(&mp->napi);
> +	}
> +
> +	if (int_cause & INT_EXT)
> +		handle_link_event(mp);
> +
> +	txstatus = int_cause & INT_TX;
> +	for (i = 0; i < mp->txq_count; ++i) {
> +		if (txstatus & INT_TX_0 << i) {
> +			txq_reclaim(mp->txq + i, 16, 0);
> +			txq_maybe_wake(mp->txq + i);
> +		}
> +	}
> +
> +	txstatus = ((int_cause & INT_TX_END) >> 6) &
> +		   ~((rdlp(mp, SDMA_COMMAND) >> 16) & 0x3);
> +	for (i = 0; i < mp->txq_count; ++i) {
> +		if (txstatus & 1 << i)
> +			txq_kick(mp->txq + i);
> +	}
> +
> +	return IRQ_HANDLED;
> +}

> +static void set_params(struct mvberlin_eth_private *mp,
> +		       struct mv643xx_eth_platform_data *pd)
> +{
> +	struct net_device *dev = mp->dev;
> +
> +	if (is_valid_ether_addr(pd->mac_addr))
> +		memcpy(dev->dev_addr, pd->mac_addr, ETH_ALEN);
> +	else
> +		uc_addr_get(mp, dev->dev_addr);
> +
> +	mp->rx_ring_size = DEFAULT_RX_QUEUE_SIZE;
> +	if (pd->rx_queue_size)
> +		mp->rx_ring_size = pd->rx_queue_size;
> +	mp->rx_desc_sram_addr = pd->rx_sram_addr;
> +	mp->rx_desc_sram_size = pd->rx_sram_size;
> +
> +	mp->rxq_count = pd->rx_queue_count ? : 1;
> +
> +	mp->tx_ring_size = DEFAULT_TX_QUEUE_SIZE;
> +	if (pd->tx_queue_size)
> +		mp->tx_ring_size = pd->tx_queue_size;
> +
> +	mp->tx_desc_sram_addr = pd->tx_sram_addr;
> +	mp->tx_desc_sram_size = pd->tx_sram_size;
> +
> +	mp->txq_count = pd->tx_queue_count ? : 1;
> +}
> +
> +static const struct net_device_ops mvberlin_eth_netdev_ops = {
> +	.ndo_open		= mvberlin_eth_open,
> +	.ndo_stop		= mvberlin_eth_stop,
> +	.ndo_start_xmit		= mvberlin_eth_xmit,
> +	.ndo_set_rx_mode	= mvberlin_eth_set_multicast_list,
> +	.ndo_set_mac_address	= mvberlin_eth_set_mac_address,
> +	.ndo_validate_addr	= eth_validate_addr,
> +	.ndo_do_ioctl		= mvberlin_eth_ioctl,
> +	.ndo_change_mtu		= mvberlin_eth_change_mtu,
> +	.ndo_tx_timeout		= mvberlin_eth_tx_timeout,
> +	.ndo_get_stats		= mvberlin_eth_get_stats,
> +#ifdef CONFIG_NET_POLL_CONTROLLER
> +	.ndo_poll_controller	= mvberlin_eth_netpoll,
> +#endif
> +};
> +
> +static int mvberlin_eth_probe(struct platform_device *pdev)
> +{
> +	struct mv643xx_eth_platform_data *pd;

mv643xx_eth_platform_data? You really lost me here :) I'm having a hard
time figuring out who will set this platform data. I guess I'm overlooking
something?

> +	struct mvberlin_eth_private *mp;
> +	struct net_device *dev;
> +	struct resource *res;
> +	int ret;
> +
> +	dev = alloc_etherdev_mq(sizeof(struct mvberlin_eth_private), 8);
> +	if (!dev)
> +		return -ENOMEM;
> +
> +	pd = devm_kzalloc(&pdev->dev, sizeof(*pd), GFP_KERNEL);
> +	if (!pd)
> +		return -ENOMEM;
> +
> +	mp = netdev_priv(dev);
> +	platform_set_drvdata(pdev, mp);
> +	mp->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	if (!res)
> +		return -ENOMEM;
> +
> +	mp->shared = devm_kzalloc(&pdev->dev,
> +				  sizeof(struct mvberlin_eth_shared_private),
> +				  GFP_KERNEL);
> +	if (!mp->shared)
> +		return -ENOMEM;
> +
> +	mp->shared->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(mp->shared->base))
> +		return PTR_ERR(mp->shared->base);
> +	mp->base = mp->shared->base + 0x400;
> +
> +	mp->clk = devm_clk_get(&pdev->dev, NULL);
> +	if (!IS_ERR(mp->clk)) {
> +		clk_prepare_enable(mp->clk);
> +		mp->t_clk = clk_get_rate(mp->clk);
> +	}
> +

The binding doesn't declare the clock as optional, I'd say you should enforce
the requirement here.

> +	set_params(mp, pd);
> +	netif_set_real_num_tx_queues(dev, mp->txq_count);
> +	netif_set_real_num_rx_queues(dev, mp->rxq_count);
> +
> +	pd->phy_node = of_parse_phandle(pdev->dev.of_node, "phy-handle", 0);
> +	if (!pd->phy_node) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	mp->phy = of_phy_connect(dev, pd->phy_node,
> +				 mvberlin_eth_adjust_link, 0,
> +				 PHY_INTERFACE_MODE_RGMII);
> +	if (!mp->phy) {
> +		ret = -EPROBE_DEFER;
> +		goto out;
> +	}
> +
> +	dev->ethtool_ops = &mvberlin_eth_ethtool_ops;
> +
> +	init_pscr(mp);
> +
> +	init_hash_table(mp);
> +	mvberlin_eth_program_unicast_filter(mp, NULL, dev->dev_addr);
> +
> +	mib_counters_clear(mp);
> +
> +	INIT_WORK(&mp->tx_timeout_task, tx_timeout_task);
> +
> +	netif_napi_add(dev, &mp->napi, mvberlin_eth_poll, NAPI_POLL_WEIGHT);
> +
> +	init_timer(&mp->rx_oom);
> +	mp->rx_oom.data = (unsigned long)mp;
> +	mp->rx_oom.function = oom_timer_wrapper;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
> +	BUG_ON(!res);

Hm... BUG_ON!?!? Are you sure you want to kill the entire system?

There's another BUG_ON above, and since this is just network driver,
I think it can be relaxed.

> +	dev->irq = res->start;
> +
> +	dev->netdev_ops = &mvberlin_eth_netdev_ops;
> +
> +	dev->watchdog_timeo = 2 * HZ;
> +	dev->base_addr = 0;
> +
> +	SET_NETDEV_DEV(dev, &pdev->dev);
> +
> +	wrlp(mp, SDMA_CONFIG, PORT_SDMA_CONFIG_DEFAULT_VALUE);
> +
> +	ret = register_netdev(dev);
> +	if (ret)
> +		goto out;
> +
> +	netif_carrier_off(dev);
> +
> +	return 0;
> +
> +out:
> +	if (!IS_ERR(mp->clk))
> +		clk_disable_unprepare(mp->clk);
> +	free_netdev(dev);
> +
> +	return ret;
> +}
> +
> +static int mvberlin_eth_remove(struct platform_device *pdev)
> +{
> +	struct mvberlin_eth_private *mp = platform_get_drvdata(pdev);
> +
> +	unregister_netdev(mp->dev);
> +	if (mp->phy != NULL)
> +		phy_disconnect(mp->phy);
> +	cancel_work_sync(&mp->tx_timeout_task);
> +
> +	if (!IS_ERR(mp->clk))
> +		clk_disable_unprepare(mp->clk);
> +

Ditto for the optional clock.

-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com
