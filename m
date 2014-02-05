Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaBEMfX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 07:35:23 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:16726 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbaBEMfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 07:35:18 -0500
Date: Wed, 5 Feb 2014 15:34:46 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Merello <andrea.merello@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Stefan Lippers-Hollmann <s.L-H@gmx.de>, Dave Jones <davej@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linux Driver Project <devel@linuxdriverproject.org>
Subject: Re: rtl8821ae.
Message-ID: <20140205123446.GI26722@mwanda>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
 <20140202160512.GA4946@redhat.com>
 <201402021807.37772.s.L-H@gmx.de>
 <52EFCC66.9020304@lwfinger.net>
 <20140203201228.GE26722@mwanda>
 <CA+55aFyHZfw9rtZQJ9i2p7MQAVX4iM0QCdzRZzaivD2nRDHeLQ@mail.gmail.com>
 <CAN8YU5PJWqnaBN_oaZ-yZjV-s9oCkKPa4ebk-kNbhPSgpd3_wQ@mail.gmail.com>
 <20140204092836.GG26776@mwanda>
 <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN8YU5PfJ2ijHzghJ-FJPYJeFwTfoGN-qpJ5R5ctYp3R1p13hA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 04, 2014 at 03:41:46PM +0100, Andrea Merello wrote:
> Yes, I attach a cumulative patch for latest version of my work.
> 

Looks good.  It would be best to submit the bugfixes first like where
you add error checking for pci_map_single().  Then the white space
changes.  You add too many blank lines btw, you should never have two
consecutive blank lines.  Don't add a blank line in the middle of the
declaration block or before a close curly brace '}' line.  After that
maybe the patch to change "if (priv->r8185)" to
"if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)". Then the patch
to add rtl8225se support.

Some minor things below.

regards,
dan carpenter

> When I will send this asking for merge in kernel, I will split it in
> some patches, because I also also included fix and improvements for
> other already supported cards (not directly related to rtl8187se
> support).
> 
> About this, I will produce separate patches for rtl8180 driver if
> finally the drivers will be merged and also in case I'll split them..
> 
> Any suggestion/advice will be appreciated :)
> 
> Thanks
> Andrea
> 
> On Tue, Feb 4, 2014 at 10:28 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > Nice.  Thanks for doing that.  Do you have some patches we could review
> > of the merged driver?
> >
> > regards,
> > dan carpenter
> >

> diff --git a/drivers/net/wireless/rtl818x/Kconfig b/drivers/net/wireless/rtl818x/Kconfig
> index 3033217..2f640a2 100644
> --- a/drivers/net/wireless/rtl818x/Kconfig
> +++ b/drivers/net/wireless/rtl818x/Kconfig
> @@ -2,7 +2,7 @@
>  # RTL818X Wireless LAN device configuration
>  #
>  config RTL8180
> -	tristate "Realtek 8180/8185 PCI support"
> +	tristate "Realtek 8180/8185/8187SE PCI support"
>  	depends on MAC80211 && PCI
>  	select EEPROM_93CX6
>  	---help---
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/Makefile b/drivers/net/wireless/rtl818x/rtl8180/Makefile
> index cb4fb85..08b056d 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/Makefile
> +++ b/drivers/net/wireless/rtl818x/rtl8180/Makefile
> @@ -1,4 +1,4 @@
> -rtl8180-objs		:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o
> +rtl8180-objs		:= dev.o rtl8225.o sa2400.o max2820.o grf5101.o rtl8225se.o
>  
>  obj-$(CONFIG_RTL8180)	+= rtl8180.o
>  
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/dev.c b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> index a91506b..de37693 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/dev.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180/dev.c
> @@ -27,16 +27,23 @@
>  
>  #include "rtl8180.h"
>  #include "rtl8225.h"
> +#include "rtl8225se.h"
>  #include "sa2400.h"
>  #include "max2820.h"
>  #include "grf5101.h"
> +#include "rtl8225se.h"
> +

Don't include this twice.  Only put one blank line, not two consecutive
blank lines.

>  
>  MODULE_AUTHOR("Michael Wu <flamingice@sourmilk.net>");
>  MODULE_AUTHOR("Andrea Merello <andrea.merello@gmail.com>");
> -MODULE_DESCRIPTION("RTL8180 / RTL8185 PCI wireless driver");
> +MODULE_DESCRIPTION("RTL8180 / RTL8185 / RTL8187SE PCI wireless driver");
>  MODULE_LICENSE("GPL");
>  
>  static DEFINE_PCI_DEVICE_TABLE(rtl8180_table) = {
> +
> +	/* rtl8187se */
> +	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8199) },
> +
>  	/* rtl8185 */
>  	{ PCI_DEVICE(PCI_VENDOR_ID_REALTEK, 0x8185) },
>  	{ PCI_DEVICE(PCI_VENDOR_ID_BELKIN, 0x700f) },
> @@ -86,33 +93,166 @@ static const struct ieee80211_channel rtl818x_channels[] = {
>  	{ .center_freq = 2484 },
>  };
>  
> +/* Queues for rtl8187se card
> + *
> + * name | reg  |  queue
> + *  BC  |  7   |   6
> + *  MG  |  1   |   0
> + *  HI  |  6   |   1
> + *  VO  |  5   |   2
> + *  VI  |  4   |   3
> + *  BE  |  3   |   4
> + *  BK  |  2   |   5
> + *
> + * The complete map for DMA kick reg using use all queue is:
> + * static const int rtl8187se_queues_map[RTL8187SE_NR_TX_QUEUES] =
> + *	{1, 6, 5, 4, 3, 2, 7};
> + *
> + * .. but.. Because for mac80211 4 queues are enough for QoS we use this
> + *
> + * name | reg  |  queue
> + *  BC  |  7   |   4  <- used, not reported to stack (beacon)
> + *  MG  |  1   |   x  <- Not used
> + *  HI  |  6   |   x  <- Not used
> + *  VO  |  5   |   0  <- used
> + *  VI  |  4   |   1  <- used
> + *  BE  |  3   |   2  <- used
> + *  BK  |  2   |   3  <- used
> + *
> + * I thougth about using the other two queues but I decided not to do this:
> + *
> + * - I could route MGMT frames (currently sent over VO queue) to the MGMT
> + *   queue but since mac80211 will do not know about it, I will probably gain
> + *   some HW priority whenever the VO queue is not empty, but this gain is
> + *   limited by the fact that I had to stop the mac80211 queue whenever one of
> + *   the VO or MGMT queues is full, stopping also submitting of MGMT frame
> + *   to the driver.
> + *
> + * - I'm don' know how to set in the HW the contention window params for MGMT
> + *   and HI-prio queues.
> + *
> + * - I'm unsure whether the mac80211 will ever try to use more than 4 queues
> + */
> +
> +static const int rtl8187se_queues_map[RTL8187SE_NR_TX_QUEUES] = {5, 4, 3, 2, 7};
> +
> +/* Queues for rtl8180/rtl8185 cards
> + *
> + * name | reg  |  prio
> + *  BC  |  7   |   3
> + *  HI  |  6   |   0
> + *  NO  |  5   |   1
> + *  LO  |  4   |   2
> + *
> + * The complete map for DMA kick reg using all queue is:
> + * static const int rtl8180_queues_map[RTL8180_NR_TX_QUEUES] = {6, 5, 4, 7};


This comment is out of date.  RTL8180_NR_TX_QUEUES is 2.  I haven't
really understood the changes to rtl8180_queues_map[].  It used to have
4 elements and now it only has 2.  Is this change needed to support
rtl8225se or is it a separate bugfix which should go in a separate
patch?

Also this change which I have pulled out of context:

+     if (ring->entries - skb_queue_len(&ring->queue) < 2) {
+             if (prio != dev->queues)
+                     ieee80211_stop_queue(dev, prio);
+             else
+                     priv->beacon_queue_stop = 1;
+     }

This is a separate bugfix?

> + *
> + * .. but .. Because the mac80211 needs at least 4 queues for QoS or
> + * otherwise QoS can't be done, we use this:
> + *
> + * name | reg  |  prio
> + *  BC  |  7   |   1  <- used, not reported to stack (beacon)
> + *  HI  |  6   |   x  <- not used
> + *  NO  |  5   |   x  <- not used
> + *  LO  |  4   |   0  <- used
> + *
> + */
> +
> +static const int rtl8180_queues_map[RTL8180_NR_TX_QUEUES] = {4, 7};
> +
> +
> +static void rtl8180_write_phy_(struct ieee80211_hw *dev, u8 addr, u32 data)

This is a temporary name to not conflight with rtl8180_write_phy()?

> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	rtl818x_iowrite8(priv, &priv->map->PHY[1],
> +			 (u8)(data  & 0xFF));
> +	rtl818x_ioread8(priv, &priv->map->PHY[1]);
> +
> +	rtl818x_iowrite8(priv, &priv->map->PHY[2],
> +			 (u8)((data >> 8) & 0xFF));
> +	rtl818x_ioread8(priv, &priv->map->PHY[2]);
> +
> +	rtl818x_iowrite8(priv, &priv->map->PHY[3],
> +			 (u8)((data >> 16) & 0xFF));
> +	rtl818x_ioread8(priv, &priv->map->PHY[3]);
> +
> +	rtl818x_iowrite8(priv, &priv->map->PHY[0],
> +			 (u8)(addr));
> +}

These don't go over the 80 character limit so we don't need the line
breaks.  The casts are not needed either.

{
	struct rtl8180_priv *priv = dev->priv;

	rtl818x_iowrite8(priv, &priv->map->PHY[1], (data & 0xFF));
	rtl818x_ioread8(priv, &priv->map->PHY[1]);

	rtl818x_iowrite8(priv, &priv->map->PHY[2], ((data >> 8) & 0xFF));
	rtl818x_ioread8(priv, &priv->map->PHY[2]);

	rtl818x_iowrite8(priv, &priv->map->PHY[3], ((data >> 16) & 0xFF));
	rtl818x_ioread8(priv, &priv->map->PHY[3]);

	rtl818x_iowrite8(priv, &priv->map->PHY[0], addr);
}

>  
>  void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data)
>  {
>  	struct rtl8180_priv *priv = dev->priv;
> -	int i = 10;
> -	u32 buf;
> +	int i;
> +	u8 tmp;
> +	u8 readback;
> +	u32 rb_mask = 0xff;
> +
> +	if ((addr == 0xa) && (
> +		    priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185))
> +		rb_mask = 0x7f;

Write it like this:

	if (addr == 0xa && priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185)
		rb_mask = 0x7f;

If you really want to add parenthesis then do this:

	if ((addr == 0xa) &&
	    (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185))
		rb_mask = 0x7f;


> +
> +	for (i = 0; i < 30; i++) {
> +		tmp = rtl818x_ioread8(priv, &priv->map->PHY[0]);
> +		if (!(tmp & 0x80))
> +			break;
> +		mdelay(10);
> +	}
>  
> -	buf = (data << 8) | addr;
> +	if (tmp & 0x80)
> +		printk(KERN_WARNING
> +		       "rtl818x failed to write BB (busy) adr:%x data:%x\n",
> +		       addr, data);

Checkpatch.pl will complain that you should use netdev_warn() or
something.

> +
> +	rtl8180_write_phy_(dev, addr | 0x80, data);
> +
> +	for (i = 0; i < 30; i++) {
> +		rtl8180_write_phy_(dev, addr & ~0x80, data);
> +
> +		readback = rtl818x_ioread8(priv, &priv->map->PHY[2]);
> +
> +		if (readback == (data & rb_mask))
> +			break;
>  
> -	rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->PHY[0], buf | 0x80);
> -	while (i--) {
> -		rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->PHY[0], buf);
> -		if (rtl818x_ioread8(priv, &priv->map->PHY[2]) == (data & 0xFF))
> -			return;
>  	}
> +
> +	if (readback != (data & rb_mask))
> +		printk(KERN_WARNING
> +		       "rtl818x failed to write BB adr:%x data:%x rb:%x\n",
> +		       addr, data, readback);
>  }
>  
> +
>  static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>  {
>  	struct rtl8180_priv *priv = dev->priv;
> +	struct rtl818x_rx_cmd_desc *cmd_desc;
>  	unsigned int count = 32;
>  	u8 signal, agc, sq;
> +	dma_addr_t mapping;
>  
>  	while (count--) {
> -		struct rtl8180_rx_desc *entry = &priv->rx_ring[priv->rx_idx];
> +		void *entry = priv->rx_ring + priv->rx_idx * priv->rx_ring_sz;
>  		struct sk_buff *skb = priv->rx_buf[priv->rx_idx];
> -		u32 flags = le32_to_cpu(entry->flags);
> +

Don't put a blank line here in the middle of the declaration block.

> +		u32 flags, flags2;
> +		u64 tsft;
> +
> +		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +			struct rtl8187se_rx_desc *desc = entry;
> +
> +			flags = le32_to_cpu(desc->flags);
> +			flags2 = le32_to_cpu(desc->flags2);
> +			tsft = le64_to_cpu(desc->tsft);
> +
> +		} else {
> +			struct rtl8180_rx_desc *desc = entry;
> +
> +			flags = le32_to_cpu(desc->flags);
> +			flags2 = le32_to_cpu(desc->flags2);
> +			tsft = le64_to_cpu(desc->tsft);
> +		}
>  
>  		if (flags & RTL818X_RX_DESC_FLAG_OWN)
>  			return;
> @@ -122,54 +262,75 @@ static void rtl8180_handle_rx(struct ieee80211_hw *dev)
>  				      RTL818X_RX_DESC_FLAG_RX_ERR)))
>  			goto done;
>  		else {
> -			u32 flags2 = le32_to_cpu(entry->flags2);
> +
>  			struct ieee80211_rx_status rx_status = {0};
>  			struct sk_buff *new_skb = dev_alloc_skb(MAX_RX_SIZE);
>  
>  			if (unlikely(!new_skb))
>  				goto done;
>  
> +			mapping = pci_map_single(priv->pdev,
> +					       skb_tail_pointer(new_skb),
> +					       MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
> +
> +			if (pci_dma_mapping_error(priv->pdev, mapping)) {
> +				kfree_skb(new_skb);
> +				dev_err(&priv->pdev->dev, "TX DMA map error\n");
> +
> +				goto done;
> +			}
> +
>  			pci_unmap_single(priv->pdev,
>  					 *((dma_addr_t *)skb->cb),
>  					 MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
>  			skb_put(skb, flags & 0xFFF);
>  
> +
>  			rx_status.antenna = (flags2 >> 15) & 1;
>  			rx_status.rate_idx = (flags >> 20) & 0xF;
>  			agc = (flags2 >> 17) & 0x7F;
> -			if (priv->r8185) {
> +
> +			if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
>  				if (rx_status.rate_idx > 3)
>  					signal = 90 - clamp_t(u8, agc, 25, 90);
>  				else
>  					signal = 95 - clamp_t(u8, agc, 30, 95);
> -			} else {
> +
> +			} else if (priv->chip_family ==
> +				   RTL818X_CHIP_FAMILY_RTL8180) {
>  				sq = flags2 & 0xff;
>  				signal = priv->rf->calc_rssi(agc, sq);
> +			} else {
> +				/* TODO: rtl8187se rssi */
> +				signal = 10;
>  			}
> +
>  			rx_status.signal = signal;
>  			rx_status.freq = dev->conf.chandef.chan->center_freq;
>  			rx_status.band = dev->conf.chandef.chan->band;
> -			rx_status.mactime = le64_to_cpu(entry->tsft);
> +			rx_status.mactime = tsft;
>  			rx_status.flag |= RX_FLAG_MACTIME_START;
>  			if (flags & RTL818X_RX_DESC_FLAG_CRC32_ERR)
>  				rx_status.flag |= RX_FLAG_FAILED_FCS_CRC;
>  
> -			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status, sizeof(rx_status));
> +			memcpy(IEEE80211_SKB_RXCB(skb), &rx_status,
> +			       sizeof(rx_status));
>  			ieee80211_rx_irqsafe(dev, skb);
>  
>  			skb = new_skb;
> +
>  			priv->rx_buf[priv->rx_idx] = skb;
> -			*((dma_addr_t *) skb->cb) =
> -				pci_map_single(priv->pdev, skb_tail_pointer(skb),
> -					       MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
> +			*((dma_addr_t *) skb->cb) = mapping;
>  		}
>  
>  	done:
> -		entry->rx_buf = cpu_to_le32(*((dma_addr_t *)skb->cb));
> -		entry->flags = cpu_to_le32(RTL818X_RX_DESC_FLAG_OWN |
> +		cmd_desc = entry;
> +		cmd_desc->rx_buf = cpu_to_le32(*((dma_addr_t *)skb->cb));
> +		cmd_desc->flags = cpu_to_le32(RTL818X_RX_DESC_FLAG_OWN |
>  					   MAX_RX_SIZE);
>  		if (priv->rx_idx == 31)
> -			entry->flags |= cpu_to_le32(RTL818X_RX_DESC_FLAG_EOR);
> +			cmd_desc->flags |=
> +				cpu_to_le32(RTL818X_RX_DESC_FLAG_EOR);
>  		priv->rx_idx = (priv->rx_idx + 1) % 32;
>  	}
>  }
> @@ -185,9 +346,30 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
>  		struct ieee80211_tx_info *info;
>  		u32 flags = le32_to_cpu(entry->flags);
>  
> -		if (flags & RTL818X_TX_DESC_FLAG_OWN)
> +
> +#if 0
> +		/* it seems that rtl8187se sometimes does not set
> +		 * the OWN flag on descriptors even if it has processed them.
> +		 * Maybe it happen when the TX is not done because of
> +		 * certains errors
> +		 */
> +		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +
> +			if (!(flags & RTL818X_TX_DESC_FLAG_DMA)) {
> +				flags &= ~RTL818X_TX_DESC_FLAG_OWN;
> +					entry->flags = cpu_to_le32(flags);
> +			}
> +
> +		}
> +#endif
> +
> +		if (flags & RTL818X_TX_DESC_FLAG_OWN) {
>  			return;
> +		}
>  
> +#ifdef DEBUG_PY_TOOL
> +		entry->reserved |= 0x8000;
> +#endif
>  		ring->idx = (ring->idx + 1) % ring->entries;
>  		skb = __skb_dequeue(&ring->queue);
>  		pci_unmap_single(priv->pdev, le32_to_cpu(entry->tx_buf),
> @@ -204,11 +386,74 @@ static void rtl8180_handle_tx(struct ieee80211_hw *dev, unsigned int prio)
>  		info->status.rates[1].idx = -1;
>  
>  		ieee80211_tx_status_irqsafe(dev, skb);
> -		if (ring->entries - skb_queue_len(&ring->queue) == 2)
> -			ieee80211_wake_queue(dev, prio);
> +		if (ring->entries - skb_queue_len(&ring->queue) == 2) {
> +			if (prio != dev->queues)
> +				ieee80211_wake_queue(dev, prio);
> +			else
> +				priv->beacon_queue_stop = 0;
> +
> +		}
>  	}
> +
>  }
>  
> +
> +static irqreturn_t rtl8187se_interrupt(int irq, void *dev_id)
> +{
> +	struct ieee80211_hw *dev = dev_id;
> +	struct rtl8180_priv *priv = dev->priv;
> +	u32 reg;
> +	unsigned long flags;
> +	static int desc_err;
> +
> +	spin_lock_irqsave(&priv->lock, flags);
> +	/* Note: 32-bit interrupt status */
> +	reg = rtl818x_ioread32(priv, &priv->map->INT_STATUS_SE);
> +	if (unlikely(reg == 0xFFFFFFFF)) {
> +		spin_unlock_irqrestore(&priv->lock, flags);
> +		return IRQ_HANDLED;
> +	}
> +
> +	rtl818x_iowrite32(priv, &priv->map->INT_STATUS_SE, reg);
> +
> +	if (reg & IMR_TIMEOUT1)
> +		rtl818x_iowrite32(priv, &priv->map->INT_TIMEOUT, 0);
> +
> +	if (reg & (IMR_TBDOK | IMR_TBDER))
> +		rtl8180_handle_tx(dev, 4);
> +#if 0
> +	if (reg & IMR_TMGDOK)
> +		rtl8180_handle_tx(dev, 0);
> +
> +	if (reg & (IMR_THPDOK | IMR_THPDER))
> +		rtl8180_handle_tx(dev, 1);
> +#endif
> +	if (reg & (IMR_TVODOK | IMR_TVODER))
> +		rtl8180_handle_tx(dev, 0);
> +
> +	if (reg & (IMR_TVIDOK | IMR_TVIDER))
> +		rtl8180_handle_tx(dev, 1);
> +
> +	if (reg & (IMR_TBEDOK | IMR_TBEDER))
> +		rtl8180_handle_tx(dev, 2);
> +
> +	if (reg & (IMR_TBKDOK | IMR_TBKDER))
> +		rtl8180_handle_tx(dev, 3);
> +
> +	if (reg & (IMR_ROK | IMR_RER | RTL818X_INT_SE_RX_DU | IMR_RQOSOK))
> +		rtl8180_handle_rx(dev);
> +	/* The interface sometimes generates several RX DMA descriptor errors
> +	 * at startup. Do not report these.
> +	 */
> +	if ((reg & RTL818X_INT_SE_RX_DU) && desc_err++ > 2)
> +		if (net_ratelimit())
> +			printk(KERN_ERR "No RX DMA Descriptor avail\n");
> +
> +	spin_unlock_irqrestore(&priv->lock, flags);
> +	return IRQ_HANDLED;
> +}
> +
> +
>  static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
>  {
>  	struct ieee80211_hw *dev = dev_id;
> @@ -225,14 +470,14 @@ static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
>  	rtl818x_iowrite16(priv, &priv->map->INT_STATUS, reg);
>  
>  	if (reg & (RTL818X_INT_TXB_OK | RTL818X_INT_TXB_ERR))
> -		rtl8180_handle_tx(dev, 3);
> -
> +		rtl8180_handle_tx(dev, 1);
> +#if 0
>  	if (reg & (RTL818X_INT_TXH_OK | RTL818X_INT_TXH_ERR))
> -		rtl8180_handle_tx(dev, 2);
> +		rtl8180_handle_tx(dev, 0);
>  
>  	if (reg & (RTL818X_INT_TXN_OK | RTL818X_INT_TXN_ERR))
>  		rtl8180_handle_tx(dev, 1);
> -
> +#endif
>  	if (reg & (RTL818X_INT_TXL_OK | RTL818X_INT_TXL_ERR))
>  		rtl8180_handle_tx(dev, 0);
>  
> @@ -244,6 +489,7 @@ static irqreturn_t rtl8180_interrupt(int irq, void *dev_id)
>  	return IRQ_HANDLED;
>  }
>  
> +
>  static void rtl8180_tx(struct ieee80211_hw *dev,
>  		       struct ieee80211_tx_control *control,
>  		       struct sk_buff *skb)
> @@ -254,79 +500,189 @@ static void rtl8180_tx(struct ieee80211_hw *dev,
>  	struct rtl8180_tx_ring *ring;
>  	struct rtl8180_tx_desc *entry;
>  	unsigned long flags;
> -	unsigned int idx, prio;
> +	unsigned int idx, prio, hw_prio;
> +	u8 not_used_mask;
>  	dma_addr_t mapping;
>  	u32 tx_flags;
>  	u8 rc_flags;
>  	u16 plcp_len = 0;
>  	__le16 rts_duration = 0;
> +	/* do arithmetic and then convert to le16 */
> +	u16 frame_duration = 0;
> +
> +	WARN_ON(skb->len > 0xfff);
>  
>  	prio = skb_get_queue_mapping(skb);
> +
>  	ring = &priv->tx_ring[prio];
>  
>  	mapping = pci_map_single(priv->pdev, skb->data,
>  				 skb->len, PCI_DMA_TODEVICE);
>  
> +	if (pci_dma_mapping_error(priv->pdev, mapping)) {
> +		kfree_skb(skb);
> +		dev_err(&priv->pdev->dev, "TX DMA mapping error\n");
> +		return;
> +
> +	}
> +
> +
>  	tx_flags = RTL818X_TX_DESC_FLAG_OWN | RTL818X_TX_DESC_FLAG_FS |
>  		   RTL818X_TX_DESC_FLAG_LS |
>  		   (ieee80211_get_tx_rate(dev, info)->hw_value << 24) |
>  		   skb->len;
>  
> -	if (priv->r8185)
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
>  		tx_flags |= RTL818X_TX_DESC_FLAG_DMA |
>  			    RTL818X_TX_DESC_FLAG_NO_ENC;
> +	}
>  
>  	rc_flags = info->control.rates[0].flags;
> +
> +
>  	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS) {
>  		tx_flags |= RTL818X_TX_DESC_FLAG_RTS;
>  		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
> +
>  	} else if (rc_flags & IEEE80211_TX_RC_USE_CTS_PROTECT) {
>  		tx_flags |= RTL818X_TX_DESC_FLAG_CTS;
>  		tx_flags |= ieee80211_get_rts_cts_rate(dev, info)->hw_value << 19;
> +
>  	}
>  
>  	if (rc_flags & IEEE80211_TX_RC_USE_RTS_CTS)
>  		rts_duration = ieee80211_rts_duration(dev, priv->vif, skb->len,
>  						      info);
>  
> -	if (!priv->r8185) {
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180) {
>  		unsigned int remainder;
>  
>  		plcp_len = DIV_ROUND_UP(16 * (skb->len + 4),
> -				(ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
> +			(ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
>  		remainder = (16 * (skb->len + 4)) %
>  			    ((ieee80211_get_tx_rate(dev, info)->bitrate * 2) / 10);
>  		if (remainder <= 6)
>  			plcp_len |= 1 << 15;
>  	}
>  
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +
> +		/* SIFS time (required by HW) is already included by
> +		 * ieee80211_generic_frame_duration
> +		 */
> +		frame_duration =  priv->ack_time + le16_to_cpu(
> +			ieee80211_generic_frame_duration(dev, priv->vif,
> +					IEEE80211_BAND_2GHZ, skb->len,
> +					ieee80211_get_tx_rate(dev, info)));

Use a temporary variable:

		__le16 duration;

		duration = ieee80211_generic_frame_duration(dev, priv->vif,
					IEEE80211_BAND_2GHZ, skb->len,
					ieee80211_get_tx_rate(dev, info)));

		frame_duration =  priv->ack_time + le16_to_cpu(duraction);



> +	}
> +
>  	spin_lock_irqsave(&priv->lock, flags);
>  
>  	if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> +
>  		if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
>  			priv->seqno += 0x10;
>  		hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
>  		hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
>  	}
>  
> +
>  	idx = (ring->idx + skb_queue_len(&ring->queue)) % ring->entries;
>  	entry = &ring->desc[idx];
>  
> +#ifdef DEBUG_PY_TOOL
> +	entry->reserved = 0x0fff & priv->seqno;
> +#endif
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		entry->frame_duration = cpu_to_le16(frame_duration);
> +		entry->frame_len_se = cpu_to_le16(skb->len);
> +
> +		/* tpc polarity */
> +		entry->flags3 = cpu_to_le16(1<<4);
> +	} else {
> +		entry->frame_len = cpu_to_le32(skb->len);
> +	}
> +
>  	entry->rts_duration = rts_duration;
>  	entry->plcp_len = cpu_to_le16(plcp_len);
>  	entry->tx_buf = cpu_to_le32(mapping);
> -	entry->frame_len = cpu_to_le32(skb->len);
> +
>  	entry->flags2 = info->control.rates[1].idx >= 0 ?
> -		ieee80211_get_alt_retry_rate(dev, info, 0)->bitrate << 4 : 0;
> +		ieee80211_get_alt_retry_rate(dev, info, 0)->hw_value << 4 : 0;
> +
>  	entry->retry_limit = info->control.rates[0].count;
> +
> +	/* must be written last */
>  	entry->flags = cpu_to_le32(tx_flags);

Why must this be written last?  The CPU can re-order it anyway unless
there is some locking.

> +
>  	__skb_queue_tail(&ring->queue, skb);
> -	if (ring->entries - skb_queue_len(&ring->queue) < 2)
> -		ieee80211_stop_queue(dev, prio);
> +
> +	if (ring->entries - skb_queue_len(&ring->queue) < 2) {
> +		if (prio != dev->queues)
> +			ieee80211_stop_queue(dev, prio);
> +		else
> +			priv->beacon_queue_stop = 1;
> +	}
>  
>  	spin_unlock_irqrestore(&priv->lock, flags);
>  
> -	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING, (1 << (prio + 4)));
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +
> +		hw_prio = rtl8187se_queues_map[prio];
> +		/* TPPollStop reg is used */
> +		not_used_mask = 0;
> +	} else {
> +		hw_prio = rtl8180_queues_map[prio];
> +		not_used_mask = (1<<1) | (1<<2);
> +	}
> +
> +
> +	rtl818x_iowrite8(priv, &priv->map->TX_DMA_POLLING,
> +			 (1 << hw_prio) | not_used_mask);
> +
> +}
> +
> +
> +static void rtl8180_set_anaparam3(struct rtl8180_priv *priv, u16 anaparam3)
> +{
> +	u8 reg;
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +			 RTL818X_EEPROM_CMD_CONFIG);
> +
> +	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
> +		 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
> +
> +	rtl818x_iowrite16(priv, &priv->map->ANAPARAM3, anaparam3);
> +
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
> +		 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +			 RTL818X_EEPROM_CMD_NORMAL);
> +}
> +
> +void rtl8180_set_anaparam2(struct rtl8180_priv *priv, u32 anaparam2)
> +{
> +	u8 reg;
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +			 RTL818X_EEPROM_CMD_CONFIG);
> +
> +	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
> +		 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
> +
> +	rtl818x_iowrite32(priv, &priv->map->ANAPARAM2, anaparam2);
> +
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
> +		 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +			 RTL818X_EEPROM_CMD_NORMAL);
>  }
>  
>  void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
> @@ -334,31 +690,358 @@ void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam)
>  	u8 reg;
>  
>  	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
> +
>  	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
>  	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
>  		 reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
> +
>  	rtl818x_iowrite32(priv, &priv->map->ANAPARAM, anaparam);
> +
>  	rtl818x_iowrite8(priv, &priv->map->CONFIG3,
>  		 reg & ~RTL818X_CONFIG3_ANAPARAM_WRITE);
> -	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +			 RTL818X_EEPROM_CMD_NORMAL);
>  }
>  
> -static int rtl8180_init_hw(struct ieee80211_hw *dev)
> +
> +static void rtl8187se_mac_config(struct ieee80211_hw *dev)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +
> +	rtl818x_iowrite32(priv, REG_ADDR4(0x1F0), 0);
> +	rtl818x_ioread32(priv, REG_ADDR4(0x1F0));
> +	rtl818x_iowrite32(priv, REG_ADDR4(0x1F4), 0);
> +	rtl818x_ioread32(priv, REG_ADDR4(0x1F4));
> +	rtl818x_iowrite8(priv, REG_ADDR1(0x1F8), 0);
> +	rtl818x_ioread8(priv, REG_ADDR1(0x1F8));
> +	/* Enable DA10 TX power saving */
> +	rtl818x_iowrite8(priv, &priv->map->PHY_PR,
> +			 rtl818x_ioread8(priv, &priv->map->PHY_PR) | 0x04);

Use a temporary variable:

	reg = rtl818x_ioread8(priv, &priv->map->PHY_PR);
	rtl818x_iowrite8(priv, &priv->map->PHY_PR, reg | 0x40);

> +	/* Power */
> +	rtl818x_iowrite16(priv, PI_DATA_REG, 0x1000);
> +	rtl818x_iowrite16(priv, SI_DATA_REG, 0x1000);
> +	/* AFE - default to power ON */
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x370), 0x0560);
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x372), 0x0560);
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x374), 0x0DA4);
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x376), 0x0DA4);
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x378), 0x0560);
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x37A), 0x0560);
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x37C), 0x00EC);
> +	rtl818x_iowrite16(priv, REG_ADDR2(0x37E), 0x00EC);
> +	rtl818x_iowrite8(priv, REG_ADDR1(0x24E), 0x01);
> +	/* unknown, needed for suspend to RAM resume */
> +	rtl818x_iowrite8(priv, REG_ADDR1(0x0A), 0x72);
> +}
> +
> +
> +/* TODO use this reference code for BB/AFE power state handling */
> +#if 0
> +static bool rtl8187se_set_zebra_rf_power_state(struct ieee80211_hw *dev,
> +				   enum rtl8187se_power_state state)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +	u8 cmdreg;
> +	u8 config3;
> +	u8 tmp;
> +	int i;
> +	bool turn_off = true;
> +
> +
> +	/* this enables anaparams.
> +	 * here portions are written in bytes access
> +	 * TODO: uniform all the anaparmas  logic/names
> +	 */
> +	cmdreg = rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
> +	config3 = rtl818x_ioread8(priv, &priv->map->CONFIG3);
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG3, config3 | 0x40);
> +	switch (state) {
> +	case  RTL8187SE_POWER_ON:
> +
> +		rtl818x_iowrite16(priv, REG_ADDR2(0x37C), 0xEC);
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x054), 0x00);
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x062), 0x00);
> +
> +		/* turn on RF */
> +		rtl8187se_rf_writereg(dev, 0x00, 0x009F); udelay(500);
> +		rtl8187se_rf_writereg(dev, 0x04, 0x0972); udelay(500);
> +		/* turn on RF again */
> +		rtl8187se_rf_writereg(dev, 0x00, 0x009F); udelay(500);
> +		rtl8187se_rf_writereg(dev, 0x04, 0x0972); udelay(500);
> +
> +		/* turn on BB */
> +		rtl8225_write_phy_ofdm(dev, 0x10, 0x40);
> +		rtl8225_write_phy_ofdm(dev, 0x12, 0x40);
> +
> +		/* avoid power down at init time */
> +		rtl818x_iowrite8(priv, &priv->map->CONFIG4, priv->rf_prog_type);
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x24E), rtl818x_ioread8(priv,
> +				 REG_ADDR1(0x24E)) & ~(0x60));
> +		break;
> +	case RTL8187SE_POWER_SLEEP:
> +		/* TODO: This routine has some logic that is not understood.
> +		 * For now, it is doing what the vendor driver does, but
> +		 * probably should be fixed.
> +		 */
> +		/* turn off BB */
> +		rtl8225_write_phy_ofdm(dev, 0x10, 0x40);
> +		rtl8225_write_phy_ofdm(dev, 0x12, 0x40);
> +
> +
> +		/* turn off RF */
> +		rtl8187se_rf_writereg(dev, 0x04, 0x0000);
> +		rtl8187se_rf_writereg(dev, 0x00, 0x0000);
> +
> +		/* Turn off AFE except PLL */
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x62), 0xFF);
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x54), 0xEC);
> +		tmp = rtl818x_ioread8(priv, REG_ADDR1(0x24F));
> +		if (tmp == 0x01 || tmp == 0x09) {
> +			rtl818x_iowrite8(priv, REG_ADDR1(0x24E),
> +				   rtl818x_ioread8(priv, REG_ADDR1(0x24E)) |
> +				   0x60);
> +			/* Turn off AFE PLL */
> +			rtl818x_iowrite8(priv, REG_ADDR1(0x54), 0xFC);
> +			rtl818x_iowrite16(priv, REG_ADDR2(0x37C), 0x00FC);
> +		}
> +		break;
> +	case RTL8187SE_POWER_OFF:
> +		/* turn off BB RXIQ matrix to cut off rx signal */
> +		rtl8225_write_phy_ofdm(dev, 0x10, 0x00);
> +		rtl8225_write_phy_ofdm(dev, 0x12, 0x00);
> +
> +
> +		/* turn off RF */
> +		rtl8187se_rf_writereg(dev, 0x04, 0x0000);
> +		rtl8187se_rf_writereg(dev, 0x00, 0x0000);
> +
> +		/* turn off AFE except PLL */
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x62), 0xff);
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x54), 0xec);
> +		msleep(1);
> +		i = 0;
> +		for (;;) {
> +			tmp = rtl818x_ioread8(priv, REG_ADDR1(0x24F));
> +			if ((tmp == 1) || (tmp == 0x09)) {
> +				turn_off = true;
> +				break;
> +			} else {
> +				udelay(10);
> +				if (i++ > 5) {
> +					turn_off = false;
> +					break;
> +				}
> +			}
> +		}

		turn_off = false;
		for (i = 0; i < 6; i++) {
			tmp = rtl818x_ioread8(priv, REG_ADDR1(0x24F));
			if ((tmp == 1) || (tmp == 0x09)) {
				turn_off = true;
				break;
			}
			udelay(10);
		}

> +		if (turn_off) {
> +			/* turn off BB */
> +			rtl818x_iowrite8(priv, REG_ADDR1(0x24E),
> +					rtl818x_ioread8(priv, REG_ADDR1(0x24E)) |
> +					0x60);
> +			rtl818x_iowrite8(priv, REG_ADDR1(0x54), 0xFC);
> +			rtl818x_iowrite16(priv, REG_ADDR2(0x37C), 0x00FC);
> +		}
> +		break;
> +	}
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG3, config3 & ~(0x40));
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, cmdreg & ~(0xC0));
> +
> +	return true;
> +}
> +#endif
> +
> +
> +
> +static void rtl8187se_set_antenna_config(struct ieee80211_hw *dev, u8 def_ant,
> +					 bool use_diver)

Could you rename "use_diver" to "diversity"?  I misread it every time.

> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	rtl8225_write_phy_cck(dev, 0x0C, 0x09);
> +	if (use_diver) {
> +		if (def_ant == 1) {
> +			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x00);
> +			rtl8225_write_phy_cck(dev, 0x11, 0xBB);
> +			rtl8225_write_phy_cck(dev, 0x01, 0xC7);
> +			rtl8225_write_phy_ofdm(dev, 0x0D, 0x54);
> +			rtl8225_write_phy_ofdm(dev, 0x18, 0xB2);
> +		} else { /* main antenna */
> +			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
> +			rtl8225_write_phy_cck(dev, 0x11, 0x9B);
> +			rtl8225_write_phy_cck(dev, 0x01, 0xC7);
> +			rtl8225_write_phy_ofdm(dev, 0x0D, 0x5C);
> +			rtl8225_write_phy_ofdm(dev, 0x18, 0xB2);
> +		}
> +	} else { /* disable antenna diversity */
> +		if (def_ant == 1) {
> +			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x00);
> +			rtl8225_write_phy_cck(dev, 0x11, 0xBB);
> +			rtl8225_write_phy_cck(dev, 0x01, 0x47);
> +			rtl8225_write_phy_ofdm(dev, 0x0D, 0x54);
> +			rtl8225_write_phy_ofdm(dev, 0x18, 0x32);
> +		} else { /* main antenna */
> +			rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
> +			rtl8225_write_phy_cck(dev, 0x11, 0x9B);
> +			rtl8225_write_phy_cck(dev, 0x01, 0x47);
> +			rtl8225_write_phy_ofdm(dev, 0x0D, 0x5C);
> +			rtl8225_write_phy_ofdm(dev, 0x18, 0x32);
> +		}
> +	}
> +	/* priv->curr_ant = def_ant; */
> +}
> +
> +#if 0
> +static void rtl8187se_power_tracking(struct ieee80211_hw *dev)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +	u8 tmp = rtl818x_ioread8(priv, REG_ADDR1(0x238));
> +	u8 current_temp;
> +	int i;
> +	char cck_idx, ofdm_idx;
> +
> +	current_temp = (tmp & 0xF0) >> 4;
> +	current_temp = (current_temp > 0x0C) ? current_temp : 0x0C;

	curent_temp = max_t(u8, current_temp, 0x0C);

I prefer max_t because it looks more deliberate and people won't think
you intended to use the minimum value.

> +	if (current_temp != priv->thermal_meter_val) {
> +		for (i = 1; i < 15; i++) {
> +			cck_idx = priv->channels[i - 1].hw_value & 0xFF;
> +			ofdm_idx = (priv->channels[i - 1].hw_value) >> 8;
> +			cck_idx += (current_temp - priv->thermal_meter_val) * 2;
> +			ofdm_idx += (current_temp - priv->thermal_meter_val) * 2;
> +			cck_idx = clamp((u8)cck_idx, (u8)0, (u8)35);
> +			ofdm_idx = clamp((u8)ofdm_idx, (u8)0, (u8)35);
> +			priv->channels[i - 1].hw_value = ofdm_idx << 8 | cck_idx;
> +		}
> +		rtl8225se_rf_set_tx_power(dev, priv->cur_chan);
> +	}
> +	priv->thermal_meter_val = current_temp;
> +}
> +
> +
> +static void rtl8187se_init_power_tracking(struct ieee80211_hw *dev)
> +{
> +	rtl8187se_rf_writereg(dev, 0x02, rtl8187se_rf_readreg(dev, 0x02) | 2);
> +	mdelay(1);
> +}
> +
> +#endif
> +
> +
> +
> +static void rtl8180_int_enable(struct ieee80211_hw *dev)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +
> +		rtl818x_iowrite32(priv, &priv->map->IMR, IMR_TMGDOK |
> +			  IMR_TBDER | IMR_THPDER |
> +			  IMR_THPDER | IMR_THPDOK |
> +			  IMR_TVODER | IMR_TVODOK |
> +			  IMR_TVIDER | IMR_TVIDOK |
> +			  IMR_TBEDER | IMR_TBEDOK |
> +			  IMR_TBKDER | IMR_TBKDOK |
> +			  IMR_RDU | IMR_RER |
> +			  IMR_ROK | IMR_RQOSOK);
> +	} else {
> +
> +		rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
> +	}
> +
> +}
> +
> +static void rtl8180_int_disable(struct ieee80211_hw *dev)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		rtl818x_iowrite32(priv, &priv->map->IMR, 0);
> +	} else {
> +		rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
> +	}
> +
> +}
> +
> +
> +static void rtl8180_conf_basic_rates(struct ieee80211_hw *dev,
> +			    u32 rates_mask)
>  {
>  	struct rtl8180_priv *priv = dev->priv;
> +
> +	u8 max, min;
>  	u16 reg;
>  
> +	max = fls(rates_mask);
> +	min = ffs(rates_mask);
> +
> +	switch (priv->chip_family) {
> +
> +	case RTL818X_CHIP_FAMILY_RTL8180:
> +
> +		/* in 8180 this is NOT a BITMAP */
> +		reg = rtl818x_ioread16(priv, &priv->map->BRSR);
> +		reg &= ~3;
> +		reg |= max;
> +		rtl818x_iowrite16(priv, &priv->map->BRSR, reg);
> +
> +		break;
> +
> +	case RTL818X_CHIP_FAMILY_RTL8185:
> +		/* in 8185 this is a BITMAP */
> +		rtl818x_iowrite16(priv, &priv->map->BRSR, rates_mask);
> +
> +		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (max << 4) | min);
> +		break;
> +
> +	case RTL818X_CHIP_FAMILY_RTL8187SE:
> +		/* in 8187se this is a BITMAP */
> +		rtl818x_iowrite16(priv, &priv->map->BRSR_8187SE, rates_mask);
> +
> +		break;
> +
> +	}
> +}
> +
> +static void rtl8180_config_cardbus(struct ieee80211_hw *dev)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +	u32 reg32;
> +	u8 reg8;
> +
> +	reg8 = rtl818x_ioread8(priv, &priv->map->CONFIG3);
> +	reg8 |= 1 << 1;
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg8);
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		rtl818x_iowrite16(priv, FEMR_SE, 0xffff);
> +	} else {
> +		reg32 = rtl818x_ioread32(priv, &priv->map->FEMR);
> +			reg32 |= (1 << 15) | (1 << 14) | (1 << 4);
> +		rtl818x_iowrite32(priv, &priv->map->FEMR, reg32);
> +	}
> +
> +}
> +
> +static int rtl8180_init_hw(struct ieee80211_hw *dev)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	u8 reg8;
> +	u32 reg32;
> +
>  	rtl818x_iowrite8(priv, &priv->map->CMD, 0);
>  	rtl818x_ioread8(priv, &priv->map->CMD);
>  	msleep(10);
>  
>  	/* reset */
> -	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
> +	rtl8180_int_disable(dev);
> +
>  	rtl818x_ioread8(priv, &priv->map->CMD);
>  
> -	reg = rtl818x_ioread8(priv, &priv->map->CMD);
> -	reg &= (1 << 1);
> -	reg |= RTL818X_CMD_RESET;
> +	reg8 = rtl818x_ioread8(priv, &priv->map->CMD);
> +	reg8 &= (1 << 1);
> +	reg8 |= RTL818X_CMD_RESET;
>  	rtl818x_iowrite8(priv, &priv->map->CMD, RTL818X_CMD_RESET);
>  	rtl818x_ioread8(priv, &priv->map->CMD);
>  	msleep(200);
> @@ -374,78 +1057,161 @@ static int rtl8180_init_hw(struct ieee80211_hw *dev)
>  	msleep(200);
>  
>  	if (rtl818x_ioread8(priv, &priv->map->CONFIG3) & (1 << 3)) {
> -		/* For cardbus */
> -		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
> -		reg |= 1 << 1;
> -		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg);
> -		reg = rtl818x_ioread16(priv, &priv->map->FEMR);
> -		reg |= (1 << 15) | (1 << 14) | (1 << 4);
> -		rtl818x_iowrite16(priv, &priv->map->FEMR, reg);
> +		rtl8180_config_cardbus(dev);
>  	}
>  
> -	rtl818x_iowrite8(priv, &priv->map->MSR, 0);
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		rtl818x_iowrite8(priv, &priv->map->MSR, RTL818X_MSR_ENEDCA);
> +	} else {
> +		rtl818x_iowrite8(priv, &priv->map->MSR, 0);
> +	}
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180)
> +		rtl8180_set_anaparam(priv, priv->anaparam);
> +
> +	/* TODO: necessary? specs indicate not */
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +			 RTL818X_EEPROM_CMD_CONFIG);
> +
> +	reg8 = rtl818x_ioread8(priv, &priv->map->CONFIG2);
> +	rtl818x_iowrite8(priv, &priv->map->CONFIG2,
> +			 reg8 & ~(1 << 3));
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
> +		reg8 = rtl818x_ioread8(priv, &priv->map->CONFIG2);
> +		rtl818x_iowrite8(priv, &priv->map->CONFIG2,
> +				 reg8 | (1 << 4));
> +	}
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +			 RTL818X_EEPROM_CMD_NORMAL);
> +
> +	/* TODO: set CONFIG5 for calibrating AGC on rtl8180 + philips radio? */
> +
> +	/* TODO: turn off hw wep on rtl8180 */
> +
> +	rtl818x_iowrite32(priv, &priv->map->INT_TIMEOUT, 0);
> +
> +	/* default basic rates are 1,2,6,9,12,18,24 Mbps
> +	 * bitmask = 0x01f3
> +	 */
> +	rtl8180_conf_basic_rates(dev, 0x1f3);
> +
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
> +		rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
> +
> +		/* Auto rate fallback control */
> +		reg8 = rtl818x_ioread8(priv, &priv->map->RATE_FALLBACK) & 0x7C;
> +		reg8 |= RTL818X_RATE_FALLBACK_ENABLE |
> +			RTL818X_RATE_FALLBACK_AUTO_STEP1;
> +		rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, reg8);
> +
> +	} else {
> +
> +		rtl818x_iowrite8(priv, &priv->map->SECURITY, 0);
> +
> +		rtl818x_iowrite8(priv, &priv->map->PHY_DELAY, 0x6);
> +		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x4C);
> +	}
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
> +
> +		reg8 = rtl818x_ioread8(priv, &priv->map->GP_ENABLE);
> +		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, reg8 & ~(1 << 6));
> +	}
> +
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +
> +		/* the set auto rate fallback bitmask from 1M to 54 Mb/s */
> +		rtl818x_iowrite16(priv, ARFR, 0xFFF);
> +		rtl818x_ioread16(priv, ARFR);
> +
> +		rtl818x_iowrite16(priv, FEMR_SE, 0xFFFF);
> +		rtl818x_ioread16(priv, FEMR_SE);
> +
> +		/* stop unused queus (no dma alloc) */
> +		rtl818x_iowrite8(priv, &priv->map->TPPOLL_STOP,
> +			       RTL818x_TPPOLL_STOP_MG | RTL818x_TPPOLL_STOP_HI);
> +
> +		rtl818x_iowrite8(priv, &priv->map->ACM_CONTROL, 0x00);
> +		rtl818x_iowrite16(priv, &priv->map->TID_AC_MAP, 0xFA50);
> +
> +		rtl818x_iowrite16(priv, &priv->map->INT_MIG, 0);
> +
> +		/* some black magic here.. */
> +		rtl8187se_mac_config(dev);
> +
> +		rtl818x_iowrite16(priv, RFSW_CTRL, 0x569A);
> +		rtl818x_ioread16(priv, RFSW_CTRL);
>  
> -	if (!priv->r8185)
> -		rtl8180_set_anaparam(priv, priv->anaparam);
> +		rtl8180_set_anaparam(priv, RTL8225SE_ANAPARAM_ON);
> +		rtl8180_set_anaparam2(priv, RTL8225SE_ANAPARAM2_ON);
> +		rtl8180_set_anaparam3(priv, RTL8225SE_ANAPARAM3);
>  
> -	rtl818x_iowrite32(priv, &priv->map->RDSAR, priv->rx_ring_dma);
> -	rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[3].dma);
> -	rtl818x_iowrite32(priv, &priv->map->THPDA, priv->tx_ring[2].dma);
> -	rtl818x_iowrite32(priv, &priv->map->TNPDA, priv->tx_ring[1].dma);
> -	rtl818x_iowrite32(priv, &priv->map->TLPDA, priv->tx_ring[0].dma);
>  
> -	/* TODO: necessary? specs indicate not */
> -	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
> -	reg = rtl818x_ioread8(priv, &priv->map->CONFIG2);
> -	rtl818x_iowrite8(priv, &priv->map->CONFIG2, reg & ~(1 << 3));
> -	if (priv->r8185) {
> -		reg = rtl818x_ioread8(priv, &priv->map->CONFIG2);
> -		rtl818x_iowrite8(priv, &priv->map->CONFIG2, reg | (1 << 4));
> -	}
> -	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
> +		rtl818x_iowrite8(priv, &priv->map->CONFIG5,
> +			    rtl818x_ioread8(priv, &priv->map->CONFIG5) & 0x7F);
>  
> -	/* TODO: set CONFIG5 for calibrating AGC on rtl8180 + philips radio? */
> +		/*probably this switch led on */
> +		rtl818x_iowrite8(priv, &priv->map->PGSELECT,
> +			    rtl818x_ioread8(priv, &priv->map->PGSELECT) | 0x08);
>  
> -	/* TODO: turn off hw wep on rtl8180 */
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1BFF);
> +		rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x2488);
>  
> -	rtl818x_iowrite32(priv, &priv->map->INT_TIMEOUT, 0);
> +		rtl818x_iowrite32(priv, &priv->map->RF_TIMING, 0x4003);
>  
> -	if (priv->r8185) {
> -		rtl818x_iowrite8(priv, &priv->map->WPA_CONF, 0);
> -		rtl818x_iowrite8(priv, &priv->map->RATE_FALLBACK, 0x81);
> -		rtl818x_iowrite8(priv, &priv->map->RESP_RATE, (8 << 4) | 0);
> -
> -		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
> -
> -		/* TODO: set ClkRun enable? necessary? */
> -		reg = rtl818x_ioread8(priv, &priv->map->GP_ENABLE);
> -		rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, reg & ~(1 << 6));
> -		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
> -		reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
> -		rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | (1 << 2));
> -		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
> -	} else {
> -		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x1);
> -		rtl818x_iowrite8(priv, &priv->map->SECURITY, 0);
> +		/* the reference code mac hardcode table write
> +		 * this reg by doing byte-wide accesses.
> +		 * It does it just for lowest and highest byte..
> +		 */
> +		reg32 = rtl818x_ioread32(priv, &priv->map->RF_PARA);
> +		reg32 &= 0x00ffff00;
> +		reg32 |= 0xb8000054;
> +		rtl818x_iowrite32(priv, &priv->map->RF_PARA, reg32);
>  
> -		rtl818x_iowrite8(priv, &priv->map->PHY_DELAY, 0x6);
> -		rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, 0x4C);
> +		priv->rf_prog_type = rtl818x_ioread8(priv,
> +						    &priv->map->CONFIG4) & 0x03;
>  	}
>  
>  	priv->rf->init(dev);
> -	if (priv->r8185)
> -		rtl818x_iowrite16(priv, &priv->map->BRSR, 0x01F3);
> +
> +	/* TODO: fix this block */
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +
> +		rtl8187se_set_antenna_config(dev,
> +					     priv->antenna_diversity_default,
> +					     priv->antenna_diversity_en);
> +
> +		/* todo power tracking */
> +#if 0
> +		if (priv->thermal_meter_en)
> +			rtl8187se_init_power_tracking(dev);
> +#endif
> +	}
> +
>  	return 0;
>  }
>  
> +
> +
> +
>  static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
>  {
>  	struct rtl8180_priv *priv = dev->priv;
> -	struct rtl8180_rx_desc *entry;
> +	struct rtl818x_rx_cmd_desc *entry;
> +	int dma_map_fail_count = 0;
>  	int i;
>  
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE)
> +		priv->rx_ring_sz = sizeof(struct rtl8187se_rx_desc);
> +	else
> +		priv->rx_ring_sz = sizeof(struct rtl8180_rx_desc);
> +
>  	priv->rx_ring = pci_alloc_consistent(priv->pdev,
> -					     sizeof(*priv->rx_ring) * 32,
> +					     priv->rx_ring_sz * 32,
>  					     &priv->rx_ring_dma);
>  
>  	if (!priv->rx_ring || (unsigned long)priv->rx_ring & 0xFF) {
> @@ -453,25 +1219,41 @@ static int rtl8180_init_rx_ring(struct ieee80211_hw *dev)
>  		return -ENOMEM;
>  	}
>  
> -	memset(priv->rx_ring, 0, sizeof(*priv->rx_ring) * 32);
> +	memset(priv->rx_ring, 0, priv->rx_ring_sz * 32);
>  	priv->rx_idx = 0;
>  
>  	for (i = 0; i < 32; i++) {
>  		struct sk_buff *skb = dev_alloc_skb(MAX_RX_SIZE);
>  		dma_addr_t *mapping;
> -		entry = &priv->rx_ring[i];
> -		if (!skb)
> -			return 0;
> -
> +		entry = priv->rx_ring + priv->rx_ring_sz*i;
> +		if (!skb) {
> +			wiphy_err(dev->wiphy, "Cannot allocate RX skb\n");
> +			return -ENOMEM;
> +		}
>  		priv->rx_buf[i] = skb;
>  		mapping = (dma_addr_t *)skb->cb;
>  		*mapping = pci_map_single(priv->pdev, skb_tail_pointer(skb),
>  					  MAX_RX_SIZE, PCI_DMA_FROMDEVICE);
> +
> +		if (pci_dma_mapping_error(priv->pdev, *mapping)) {
> +			kfree_skb(skb);
> +			if (dma_map_fail_count++ > 32) {
> +				wiphy_err(dev->wiphy, "Cannot map RX skb\n");
> +				return -ENOMEM;
> +			}
> +
> +			i--;
> +			wiphy_err(dev->wiphy, "Warn retry alloc\n");
> +			continue;
> +		}
> +
> +
>  		entry->rx_buf = cpu_to_le32(*mapping);
>  		entry->flags = cpu_to_le32(RTL818X_RX_DESC_FLAG_OWN |
>  					   MAX_RX_SIZE);
>  	}
>  	entry->flags |= cpu_to_le32(RTL818X_RX_DESC_FLAG_EOR);
> +
>  	return 0;
>  }
>  
> @@ -491,7 +1273,7 @@ static void rtl8180_free_rx_ring(struct ieee80211_hw *dev)
>  		kfree_skb(skb);
>  	}
>  
> -	pci_free_consistent(priv->pdev, sizeof(*priv->rx_ring) * 32,
> +	pci_free_consistent(priv->pdev, priv->rx_ring_sz * 32,
>  			    priv->rx_ring, priv->rx_ring_dma);
>  	priv->rx_ring = NULL;
>  }
> @@ -555,31 +1337,86 @@ static int rtl8180_start(struct ieee80211_hw *dev)
>  	if (ret)
>  		return ret;
>  
> -	for (i = 0; i < 4; i++)
> +	for (i = 0; i < RTL818X_NR_TX_QUEUES; i++)
>  		if ((ret = rtl8180_init_tx_ring(dev, i, 16)))
>  			goto err_free_rings;
>  
> +#ifdef DEBUG_PY_TOOL
> +	for (i = 0; i < RTL818X_NR_TX_QUEUES; i++) {
> +		printk("ring prio %d -- virt: 0x%lx, DMA: 0x%lx, idx: 0x%lx\n", i,
> +		       (unsigned long) priv->tx_ring[i].desc,
> +		       (unsigned long) priv->tx_ring[i].dma,
> +		       (unsigned long) &priv->tx_ring[i].idx);
> +	}
> +#endif
> +
>  	ret = rtl8180_init_hw(dev);
>  	if (ret)
>  		goto err_free_rings;
>  
>  	rtl818x_iowrite32(priv, &priv->map->RDSAR, priv->rx_ring_dma);
> -	rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[3].dma);
> -	rtl818x_iowrite32(priv, &priv->map->THPDA, priv->tx_ring[2].dma);
> -	rtl818x_iowrite32(priv, &priv->map->TNPDA, priv->tx_ring[1].dma);
> -	rtl818x_iowrite32(priv, &priv->map->TLPDA, priv->tx_ring[0].dma);
>  
> -	ret = request_irq(priv->pdev->irq, rtl8180_interrupt,
> +
> +
> +	/* mac80211 queue have higher prio for lower index. The last queue
> +	 * (that mac80211 is not aware of) is reserved for beacons (and have
> +	 * the highest priority on the NIC)
> +	 */
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[1].dma);
> +		/*
> +		not used
> +		rtl818x_iowrite32(priv, &priv->map->THPDA, priv->tx_ring[0].dma);
> +		rtl818x_iowrite32(priv, &priv->map->TNPDA, priv->tx_ring[1].dma);
> +		*/
> +		rtl818x_iowrite32(priv, &priv->map->TLPDA, priv->tx_ring[0].dma);
> +	} else {
> +		rtl818x_iowrite32(priv, &priv->map->TBDA, priv->tx_ring[4].dma);
> +		/*
> +		not used
> +		rtl818x_iowrite32(priv,&priv->map->TMGDA, priv->tx_ring[0].dma);
> +		rtl818x_iowrite32(priv,&priv->map->THPDA, priv->tx_ring[1].dma);
> +		*/
> +		rtl818x_iowrite32(priv, &priv->map->TVODA, priv->tx_ring[0].dma);
> +		rtl818x_iowrite32(priv, &priv->map->TVIDA, priv->tx_ring[1].dma);
> +		rtl818x_iowrite32(priv, &priv->map->TBEDA, priv->tx_ring[2].dma);
> +		rtl818x_iowrite32(priv, &priv->map->TBKDA, priv->tx_ring[3].dma);
> +
> +	}
> +
> +#if 0
> +	printk("reg TBDA adr %x\n", &priv->map->TBDA);
> +	printk("reg TMGDA adr %x\n", &priv->map->TMGDA);
> +	printk("reg THPDA adr %x\n", &priv->map->THPDA);
> +	printk("reg TVIDA adr %x\n", &priv->map->TVIDA);
> +	printk("reg TVODA adr %x\n", &priv->map->TVODA);
> +	printk("reg TBEDA adr %x\n", &priv->map->TBEDA);
> +	printk("reg TBKDA adr %x\n", &priv->map->TBKDA);
> +#endif
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		ret = request_irq(priv->pdev->irq, rtl8187se_interrupt,
>  			  IRQF_SHARED, KBUILD_MODNAME, dev);
> +	} else {
> +
> +		ret = request_irq(priv->pdev->irq, rtl8180_interrupt,
> +			  IRQF_SHARED, KBUILD_MODNAME, dev);
> +	}
> +
>  	if (ret) {
>  		wiphy_err(dev->wiphy, "failed to register IRQ handler\n");
>  		goto err_free_rings;
>  	}
>  
> -	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0xFFFF);
> +	rtl8180_int_enable(dev);
>  
> -	rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
> -	rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
> +	/* in rtl8187se at MAR regs offset there is the management
> +	 * TX descriptor DMA addres..
> +	 */
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		rtl818x_iowrite32(priv, &priv->map->MAR[0], ~0);
> +		rtl818x_iowrite32(priv, &priv->map->MAR[1], ~0);
> +	}
>  
>  	reg = RTL818X_RX_CONF_ONLYERLPKT |
>  	      RTL818X_RX_CONF_RX_AUTORESETPHY |
> @@ -589,27 +1426,45 @@ static int rtl8180_start(struct ieee80211_hw *dev)
>  	      RTL818X_RX_CONF_BROADCAST |
>  	      RTL818X_RX_CONF_NICMAC;
>  
> -	if (priv->r8185)
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
>  		reg |= RTL818X_RX_CONF_CSDM1 | RTL818X_RX_CONF_CSDM2;
> -	else {
> +
> +	} else if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180) {
> +
>  		reg |= (priv->rfparam & RF_PARAM_CARRIERSENSE1)
>  			? RTL818X_RX_CONF_CSDM1 : 0;
>  		reg |= (priv->rfparam & RF_PARAM_CARRIERSENSE2)
>  			? RTL818X_RX_CONF_CSDM2 : 0;
> +	} else {
> +		reg &= ~(RTL818X_RX_CONF_CSDM1 | RTL818X_RX_CONF_CSDM2);
>  	}
>  
>  	priv->rx_conf = reg;
>  	rtl818x_iowrite32(priv, &priv->map->RX_CONF, reg);
>  
> -	if (priv->r8185) {
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
> +
>  		reg = rtl818x_ioread8(priv, &priv->map->CW_CONF);
> -		reg &= ~RTL818X_CW_CONF_PERPACKET_CW_SHIFT;
> -		reg |= RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT;
> +
> +		/* CW is not on per-packet basis.
> +		 * in rtl8185 the CW_VALUE reg is used.
> +		 * in rtl8187se the AC param regs are used.
> +		 */
> +		reg &= ~RTL818X_CW_CONF_PERPACKET_CW;
> +		/* retry limit IS on per-packet basis.
> +		 * the short and long retry limit in TX_CONF
> +		 * reg are ignored
> +		 */
> +		reg |= RTL818X_CW_CONF_PERPACKET_RETRY;
>  		rtl818x_iowrite8(priv, &priv->map->CW_CONF, reg);
>  
>  		reg = rtl818x_ioread8(priv, &priv->map->TX_AGC_CTL);
> -		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT;
> -		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT;
> +		/* TX antenna and TX gain are not on per-packet basis.
> +		 * TX Antenna is selected by ANTSEL reg (RX in BB regs).
> +		 * TX gain is selected with CCK_TX_AGC and OFDM_TX_AGC regs
> +		 */
> +		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_GAIN;
> +		reg &= ~RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL;
>  		reg |=  RTL818X_TX_AGC_CTL_FEEDBACK_ANT;
>  		rtl818x_iowrite8(priv, &priv->map->TX_AGC_CTL, reg);
>  
> @@ -621,10 +1476,22 @@ static int rtl8180_start(struct ieee80211_hw *dev)
>  	reg |= (6 << 21 /* MAX TX DMA */) |
>  	       RTL818X_TX_CONF_NO_ICV;
>  
> -	if (priv->r8185)
> +
> +
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
>  		reg &= ~RTL818X_TX_CONF_PROBE_DTS;
> -	else
> -		reg &= ~RTL818X_TX_CONF_HW_SEQNUM;
> +	} else {
> +		reg &= ~RTL818X_TX_CONF_CW_MIN;
> +		reg |= RTL818X_TX_CONF_SW_SEQNUM;
> +		/* TODO:  set_SRL_LRL */
> +	}
> +
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		reg |= 1<<30;  /*  "duration procedure mode" */
> +	}
> +
> +	reg &= ~RTL818X_TX_CONF_DISCW;
>  
>  	/* different meaning, same value on both rtl8185 and rtl8180 */
>  	reg &= ~RTL818X_TX_CONF_SAT_HWPLCP;
> @@ -640,7 +1507,7 @@ static int rtl8180_start(struct ieee80211_hw *dev)
>  
>   err_free_rings:
>  	rtl8180_free_rx_ring(dev);
> -	for (i = 0; i < 4; i++)
> +	for (i = 0; i < RTL818X_NR_TX_QUEUES; i++)
>  		if (priv->tx_ring[i].desc)
>  			rtl8180_free_tx_ring(dev, i);
>  
> @@ -653,7 +1520,7 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
>  	u8 reg;
>  	int i;
>  
> -	rtl818x_iowrite16(priv, &priv->map->INT_MASK, 0);
> +	rtl8180_int_disable(dev);
>  
>  	reg = rtl818x_ioread8(priv, &priv->map->CMD);
>  	reg &= ~RTL818X_CMD_TX_ENABLE;
> @@ -670,7 +1537,7 @@ static void rtl8180_stop(struct ieee80211_hw *dev)
>  	free_irq(priv->pdev->irq, dev);
>  
>  	rtl8180_free_rx_ring(dev);
> -	for (i = 0; i < 4; i++)
> +	for (i = 0; i < RTL818X_NR_TX_QUEUES; i++)
>  		rtl8180_free_tx_ring(dev, i);
>  }
>  
> @@ -690,11 +1557,15 @@ static void rtl8180_beacon_work(struct work_struct *work)
>  	struct ieee80211_vif *vif =
>  		container_of((void *)vif_priv, struct ieee80211_vif, drv_priv);
>  	struct ieee80211_hw *dev = vif_priv->dev;
> +	struct rtl8180_priv *priv = dev->priv;
>  	struct ieee80211_mgmt *mgmt;
>  	struct sk_buff *skb;
>  
> +	/* bacon queue is the last one, that is 1+ queue num declared to mac80211 */
> +	const int beacon_queue = dev->queues;
> +
>  	/* don't overflow the tx ring */
> -	if (ieee80211_queue_stopped(dev, 0))
> +	if (priv->beacon_queue_stop)
>  		goto resched;
>  
>  	/* grab a fresh beacon */
> @@ -709,8 +1580,7 @@ static void rtl8180_beacon_work(struct work_struct *work)
>  	mgmt = (struct ieee80211_mgmt *)skb->data;
>  	mgmt->u.beacon.timestamp = cpu_to_le64(rtl8180_get_tsf(dev, vif));
>  
> -	/* TODO: use actual beacon queue */
> -	skb_set_queue_mapping(skb, 0);
> +	skb_set_queue_mapping(skb, beacon_queue);
>  
>  	rtl8180_tx(dev, NULL, skb);
>  
> @@ -773,11 +1643,147 @@ static int rtl8180_config(struct ieee80211_hw *dev, u32 changed)
>  	struct rtl8180_priv *priv = dev->priv;
>  	struct ieee80211_conf *conf = &dev->conf;
>  
> +	int chan =
> +		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
> +

You could avoid the split line by doing this:

	struct ieee80211_conf *conf = &dev->conf;
	int chan;

	chan = ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);

> +
>  	priv->rf->set_chan(dev, conf);
>  
> +	priv->cur_chan = chan;
> +	return 0;
> +}
> +
> +static void rtl8187se_conf_ac_parm(struct ieee80211_hw *dev, u8 queue)
> +{
> +	const struct ieee80211_tx_queue_params *params;
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	/* hw value */
> +	u32 ac_param;
> +
> +	u8 aifs;
> +	u8 txop;
> +	u8 cw_min, cw_max;
> +
> +	params = &priv->queue_param[queue];
> +
> +	cw_min = fls(params->cw_min);
> +	cw_max = fls(params->cw_max);
> +
> +
> +	aifs = 10 + params->aifs * priv->slot_time;
> +
> +	/* TODO: check if txop HW is in us (mult by 32) */
> +	txop = params->txop;
> +
> +	ac_param = txop << AC_PARAM_TXOP_LIMIT_SHIFT |
> +		cw_max << AC_PARAM_ECW_MAX_SHIFT |
> +		cw_min << AC_PARAM_ECW_MIN_SHIFT |
> +		aifs << AC_PARAM_AIFS_SHIFT;
> +
> +	switch (queue) {
> +	case IEEE80211_AC_BK:
> +		rtl818x_iowrite32(priv, &priv->map->AC_BK_PARAM, ac_param);
> +		break;
> +	case IEEE80211_AC_BE:
> +		rtl818x_iowrite32(priv, &priv->map->AC_BE_PARAM, ac_param);
> +		break;
> +	case IEEE80211_AC_VI:
> +		rtl818x_iowrite32(priv, &priv->map->AC_VI_PARAM, ac_param);
> +		break;
> +	case IEEE80211_AC_VO:
> +		rtl818x_iowrite32(priv, &priv->map->AC_VO_PARAM, ac_param);
> +		break;
> +	}
> +
> +}
> +
> +static int rtl8180_conf_tx(struct ieee80211_hw *dev,
> +			    struct ieee80211_vif *vif, u16 queue,
> +			    const struct ieee80211_tx_queue_params *params)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	u8 cw_min, cw_max;
> +
> +	/* nothing to do ? */
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180)
> +		return 0;
> +
> +	cw_min = fls(params->cw_min);
> +	cw_max = fls(params->cw_max);
> +
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		priv->queue_param[queue] = *params;
> +		rtl8187se_conf_ac_parm(dev, queue);
> +	} else {
> +		rtl818x_iowrite8(priv, &priv->map->CW_VAL, (cw_max<<4) | cw_min);
> +
> +	}
> +
>  	return 0;
>  }
>  
> +static void rtl8180_conf_erp(struct ieee80211_hw *dev,
> +			    struct ieee80211_bss_conf *info)
> +{
> +
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +	u8 sifs, difs;
> +	int eifs;
> +	u8 hw_eifs;
> +
> +	/* TODO: should we do something ? */
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180)
> +		return;
> +
> +	/* I _hope_ this means 10uS for the HW.
> +	 * In reference code it is 0x22 for
> +	 * both rtl8187L and rtl8187SE
> +	 */
> +	sifs = 0x22;
> +
> +	if (info->use_short_slot) {
> +		priv->slot_time = 9;
> +	} else {
> +		priv->slot_time = 20;
> +	}
> +
> +	/* 10 is SIFS time in uS */
> +	difs = 10 + 2 * priv->slot_time;
> +	eifs = 10 + difs + priv->ack_time;
> +
> +	/* HW should use 4uS units for EIFS (I'm sure for rtl8185)*/
> +	hw_eifs = DIV_ROUND_UP(eifs, 4);
> +
> +
> +	rtl818x_iowrite8(priv, &priv->map->SLOT, priv->slot_time);
> +	rtl818x_iowrite8(priv, &priv->map->SIFS, sifs);
> +	rtl818x_iowrite8(priv, &priv->map->DIFS, difs);
> +
> +	/* from reference code. set ack timeout reg = eifs reg */
> +	rtl818x_iowrite8(priv, &priv->map->CARRIER_SENSE_COUNTER, hw_eifs);
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +
> +
> +		rtl818x_iowrite8(priv, &priv->map->EIFS_8187SE, hw_eifs);
> +
> +
> +	} else if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8185) {
> +
> +		/* rtl8187/rtl8185 HW bug. After EIFS is elapsed,
> +		 * the HW still wait for DIFS.
> +		 * HW uses 4uS units for EIFS.
> +		 */
> +		hw_eifs = DIV_ROUND_UP(eifs - difs, 4);
> +
> +		rtl818x_iowrite8(priv, &priv->map->EIFS, hw_eifs);
> +	}
> +}
> +
>  static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
>  				     struct ieee80211_vif *vif,
>  				     struct ieee80211_bss_conf *info,
> @@ -790,11 +1796,25 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
>  
>  	vif_priv = (struct rtl8180_vif *)&vif->drv_priv;
>  
> +	if (changed & BSS_CHANGED_BEACON_INT)
> +		rtl818x_iowrite16(priv, &priv->map->BEACON_INTERVAL,
> +				  info->beacon_int);
> +
>  	if (changed & BSS_CHANGED_BSSID) {
> +
> +		/* access bssid in config mode has been seen in rtl8187se code..
> +		 * TODO: check if needed
> +		 */
> +		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +				 RTL818X_EEPROM_CMD_CONFIG);
> +
>  		for (i = 0; i < ETH_ALEN; i++)
>  			rtl818x_iowrite8(priv, &priv->map->BSSID[i],
>  					 info->bssid[i]);
>  
> +		rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD,
> +				 RTL818X_EEPROM_CMD_NORMAL);
> +
>  		if (is_valid_ether_addr(info->bssid)) {
>  			if (vif->type == NL80211_IFTYPE_ADHOC)
>  				reg = RTL818X_MSR_ADHOC;
> @@ -802,11 +1822,41 @@ static void rtl8180_bss_info_changed(struct ieee80211_hw *dev,
>  				reg = RTL818X_MSR_INFRA;
>  		} else
>  			reg = RTL818X_MSR_NO_LINK;
> +
> +
> +		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +			reg |= RTL818X_MSR_ENEDCA;
> +		}
> +
>  		rtl818x_iowrite8(priv, &priv->map->MSR, reg);
>  	}
>  
> -	if (changed & BSS_CHANGED_ERP_SLOT && priv->rf->conf_erp)
> -		priv->rf->conf_erp(dev, info);
> +	if (changed & BSS_CHANGED_BASIC_RATES)
> +		rtl8180_conf_basic_rates(dev, info->basic_rates);
> +
> +	if (changed & (BSS_CHANGED_ERP_SLOT | BSS_CHANGED_ERP_PREAMBLE)) {
> +
> +		/* when preamble changes, acktime duration changes, and erp must
> +		 * be recalculated. ACK time is calculated at lowest rate.
> +		 * Since mac80211 include SIFS timewe remove it (-10)
> +		 */
> +		priv->ack_time = le16_to_cpu(ieee80211_generic_frame_duration(dev,
> +					priv->vif,
> +					IEEE80211_BAND_2GHZ, 10,
> +					&priv->rates[0])) - 10;
> +
> +		rtl8180_conf_erp(dev, info);
> +
> +		/* mac80211 supplies aifs_n to driver and calls
> +		 * conf_tx callback whether aifs_n changes, NOT
> +		 * when aifs changes.
> +		 * Aifs should be recalculated if slot changes.
> +		 */
> +		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +			for (i = 0; i < 4; i++)
> +				rtl8187se_conf_ac_parm(dev, i);
> +		}
> +	}
>  
>  	if (changed & BSS_CHANGED_BEACON_ENABLED)
>  		vif_priv->enable_beacon = info->enable_beacon;
> @@ -864,6 +1914,7 @@ static const struct ieee80211_ops rtl8180_ops = {
>  	.remove_interface	= rtl8180_remove_interface,
>  	.config			= rtl8180_config,
>  	.bss_info_changed	= rtl8180_bss_info_changed,
> +	.conf_tx		= rtl8180_conf_tx,
>  	.prepare_multicast	= rtl8180_prepare_multicast,
>  	.configure_filter	= rtl8180_configure_filter,
>  	.get_tsf		= rtl8180_get_tsf,
> @@ -871,8 +1922,8 @@ static const struct ieee80211_ops rtl8180_ops = {
>  
>  static void rtl8180_eeprom_register_read(struct eeprom_93cx6 *eeprom)
>  {
> -	struct ieee80211_hw *dev = eeprom->data;
> -	struct rtl8180_priv *priv = dev->priv;
> +
> +	struct rtl8180_priv *priv = eeprom->data;
>  	u8 reg = rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
>  
>  	eeprom->reg_data_in = reg & RTL818X_EEPROM_CMD_WRITE;
> @@ -883,8 +1934,8 @@ static void rtl8180_eeprom_register_read(struct eeprom_93cx6 *eeprom)
>  
>  static void rtl8180_eeprom_register_write(struct eeprom_93cx6 *eeprom)
>  {
> -	struct ieee80211_hw *dev = eeprom->data;
> -	struct rtl8180_priv *priv = dev->priv;
> +
> +	struct rtl8180_priv *priv = eeprom->data;
>  	u8 reg = 2 << 6;
>  
>  	if (eeprom->reg_data_in)
> @@ -901,6 +1952,86 @@ static void rtl8180_eeprom_register_write(struct eeprom_93cx6 *eeprom)
>  	udelay(10);
>  }
>  
> +static void rtl8180_eeprom_read(struct rtl8180_priv *priv)
> +{
> +
> +	struct eeprom_93cx6 eeprom;
> +	int eeprom_cck_table_adr;
> +	u16 eeprom_val;
> +	int i;
> +
> +
> +	eeprom.data = priv;
> +	eeprom.register_read = rtl8180_eeprom_register_read;
> +	eeprom.register_write = rtl8180_eeprom_register_write;
> +	if (rtl818x_ioread32(priv, &priv->map->RX_CONF) & (1 << 6))
> +		eeprom.width = PCI_EEPROM_WIDTH_93C66;
> +	else
> +		eeprom.width = PCI_EEPROM_WIDTH_93C46;
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_PROGRAM);
> +	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
> +	udelay(10);
> +
> +	eeprom_93cx6_read(&eeprom, 0x06, &eeprom_val);
> +	eeprom_val &= 0xFF;
> +	priv->rf_type = eeprom_val;
> +
> +	eeprom_93cx6_read(&eeprom, 0x17, &eeprom_val);
> +	priv->csthreshold = eeprom_val >> 8;
> +
> +	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)priv->mac_addr, 3);
> +
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		eeprom_cck_table_adr = 0x30;
> +	} else {
> +		eeprom_cck_table_adr = 0x10;
> +	}
> +
> +	/* CCK TX power */
> +	for (i = 0; i < 14; i += 2) {
> +		u16 txpwr;
> +		eeprom_93cx6_read(&eeprom, eeprom_cck_table_adr + (i >> 1), &txpwr);
> +		priv->channels[i].hw_value = txpwr & 0xFF;
> +		priv->channels[i + 1].hw_value = txpwr >> 8;
> +	}
> +
> +	/* OFDM TX power */
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
> +		for (i = 0; i < 14; i += 2) {
> +			u16 txpwr;
> +			eeprom_93cx6_read(&eeprom, 0x20 + (i >> 1), &txpwr);
> +			priv->channels[i].hw_value |= (txpwr & 0xFF) << 8;
> +			priv->channels[i + 1].hw_value |= txpwr & 0xFF00;
> +		}
> +	}
> +
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8180) {
> +		__le32 anaparam;
> +		eeprom_93cx6_multiread(&eeprom, 0xD, (__le16 *)&anaparam, 2);
> +		priv->anaparam = le32_to_cpu(anaparam);
> +		eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
> +	}
> +
> +
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		eeprom_93cx6_read(&eeprom, 0x3F, &eeprom_val);
> +		priv->antenna_diversity_en = !!(eeprom_val & 0x100);
> +		priv->antenna_diversity_default = (eeprom_val & 0xC00) == 0x400;
> +
> +		eeprom_93cx6_read(&eeprom, 0x7C, &eeprom_val);
> +		priv->xtal_out = eeprom_val & 0xF;
> +		priv->xtal_in = (eeprom_val & 0xF0) >> 4;
> +		priv->xtal_cal = !!(eeprom_val & 0x1000);
> +		priv->thermal_meter_val = (eeprom_val & 0xF00) >> 8;
> +		priv->thermal_meter_en = !!(eeprom_val & 0x2000);
> +	}
> +
> +	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
> +}
> +
>  static int rtl8180_probe(struct pci_dev *pdev,
>  				   const struct pci_device_id *id)
>  {
> @@ -908,12 +2039,9 @@ static int rtl8180_probe(struct pci_dev *pdev,
>  	struct rtl8180_priv *priv;
>  	unsigned long mem_addr, mem_len;
>  	unsigned int io_addr, io_len;
> -	int err, i;
> -	struct eeprom_93cx6 eeprom;
> +	int err;
>  	const char *chip_name, *rf_name = NULL;
>  	u32 reg;
> -	u16 eeprom_val;
> -	u8 mac_addr[ETH_ALEN];
>  
>  	err = pci_enable_device(pdev);
>  	if (err) {
> @@ -942,8 +2070,8 @@ static int rtl8180_probe(struct pci_dev *pdev,
>  		goto err_free_reg;
>  	}
>  
> -	if ((err = pci_set_dma_mask(pdev, DMA_BIT_MASK(32))) ||
> -	    (err = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32)))) {
> +	if ((err = pci_set_dma_mask(pdev, 0xFFFFFF00UL)) ||
> +	    (err = pci_set_consistent_dma_mask(pdev, 0xFFFFFF00UL))) {
>  		printk(KERN_ERR "%s (rtl8180): No suitable DMA available\n",
>  		       pci_name(pdev));
>  		goto err_free_reg;
> @@ -995,51 +2123,70 @@ static int rtl8180_probe(struct pci_dev *pdev,
>  	dev->vif_data_size = sizeof(struct rtl8180_vif);
>  	dev->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
>  					BIT(NL80211_IFTYPE_ADHOC);
> -	dev->queues = 1;
> +
>  	dev->max_signal = 65;
>  
>  	reg = rtl818x_ioread32(priv, &priv->map->TX_CONF);
>  	reg &= RTL818X_TX_CONF_HWVER_MASK;
> +
>  	switch (reg) {
>  	case RTL818X_TX_CONF_R8180_ABCD:
>  		chip_name = "RTL8180";
> +		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8180;
>  		break;
> +
>  	case RTL818X_TX_CONF_R8180_F:
>  		chip_name = "RTL8180vF";
> +		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8180;
>  		break;
> +
>  	case RTL818X_TX_CONF_R8185_ABC:
>  		chip_name = "RTL8185";
> +		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8185;
>  		break;
> +
>  	case RTL818X_TX_CONF_R8185_D:
>  		chip_name = "RTL8185vD";
> +		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8185;
>  		break;
> +
> +	case RTL818X_TX_CONF_RTL8187SE:
> +		chip_name = "RTL8187SE";
> +		priv->chip_family = RTL818X_CHIP_FAMILY_RTL8187SE;
> +		break;
> +
>  	default:
>  		printk(KERN_ERR "%s (rtl8180): Unknown chip! (0x%x)\n",
>  		       pci_name(pdev), reg >> 25);
>  		goto err_iounmap;
>  	}
>  
> -	priv->r8185 = reg & RTL818X_TX_CONF_R8185_ABC;
> -	if (priv->r8185) {
> +
> +	/* we declare to MAC80211 all the queues except for beacon queue
> +	 * that is handled by DRV. TX rings are arranged in such a way
> +	 * that lower is the IDX, higher is the priority, in order to
> +	 * achieve direct mapping with mac80211, however the beacon
> +	 * queue is an exception and it is mapped on the highst tx ring IDX
> +	 */
> +	if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +		dev->queues = RTL8187SE_NR_TX_QUEUES - 1;
> +	} else {
> +		dev->queues = RTL8180_NR_TX_QUEUES - 1;
> +	}
> +	/* this does NOT means we are sending beacons, this means that the
> +	 * HW beacon queue is not full
> +	 */
> +	priv->beacon_queue_stop = false;
> +
> +
> +	if (priv->chip_family != RTL818X_CHIP_FAMILY_RTL8180) {
>  		priv->band.n_bitrates = ARRAY_SIZE(rtl818x_rates);
>  		pci_try_set_mwi(pdev);
>  	}
>  
> -	eeprom.data = dev;
> -	eeprom.register_read = rtl8180_eeprom_register_read;
> -	eeprom.register_write = rtl8180_eeprom_register_write;
> -	if (rtl818x_ioread32(priv, &priv->map->RX_CONF) & (1 << 6))
> -		eeprom.width = PCI_EEPROM_WIDTH_93C66;
> -	else
> -		eeprom.width = PCI_EEPROM_WIDTH_93C46;
> -
> -	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_PROGRAM);
> -	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
> -	udelay(10);
> +	rtl8180_eeprom_read(priv);
>  
> -	eeprom_93cx6_read(&eeprom, 0x06, &eeprom_val);
> -	eeprom_val &= 0xFF;
> -	switch (eeprom_val) {
> +	switch (priv->rf_type) {
>  	case 1:	rf_name = "Intersil";
>  		break;
>  	case 2:	rf_name = "RFMD";
> @@ -1050,14 +2197,19 @@ static int rtl8180_probe(struct pci_dev *pdev,
>  		break;
>  	case 5:	priv->rf = &grf5101_rf_ops;
>  		break;
> -	case 9:	priv->rf = rtl8180_detect_rf(dev);
> +	case 9:
> +		if (priv->chip_family == RTL818X_CHIP_FAMILY_RTL8187SE) {
> +			priv->rf = rtl8187se_detect_rf(dev);
> +		} else {
> +			priv->rf = rtl8180_detect_rf(dev);
> +		}
>  		break;
>  	case 10:
>  		rf_name = "RTL8255";
>  		break;
>  	default:
>  		printk(KERN_ERR "%s (rtl8180): Unknown RF! (0x%x)\n",
> -		       pci_name(pdev), eeprom_val);
> +		       pci_name(pdev), priv->rf_type);
>  		goto err_iounmap;
>  	}
>  
> @@ -1067,42 +2219,15 @@ static int rtl8180_probe(struct pci_dev *pdev,
>  		goto err_iounmap;
>  	}
>  
> -	eeprom_93cx6_read(&eeprom, 0x17, &eeprom_val);
> -	priv->csthreshold = eeprom_val >> 8;
> -	if (!priv->r8185) {
> -		__le32 anaparam;
> -		eeprom_93cx6_multiread(&eeprom, 0xD, (__le16 *)&anaparam, 2);
> -		priv->anaparam = le32_to_cpu(anaparam);
> -		eeprom_93cx6_read(&eeprom, 0x19, &priv->rfparam);
> -	}
>  
> -	eeprom_93cx6_multiread(&eeprom, 0x7, (__le16 *)mac_addr, 3);
> -	if (!is_valid_ether_addr(mac_addr)) {
> +
> +	if (!is_valid_ether_addr(priv->mac_addr)) {
>  		printk(KERN_WARNING "%s (rtl8180): Invalid hwaddr! Using"
>  		       " randomly generated MAC addr\n", pci_name(pdev));
> -		eth_random_addr(mac_addr);
> -	}
> -	SET_IEEE80211_PERM_ADDR(dev, mac_addr);
> -
> -	/* CCK TX power */
> -	for (i = 0; i < 14; i += 2) {
> -		u16 txpwr;
> -		eeprom_93cx6_read(&eeprom, 0x10 + (i >> 1), &txpwr);
> -		priv->channels[i].hw_value = txpwr & 0xFF;
> -		priv->channels[i + 1].hw_value = txpwr >> 8;
> -	}
> -
> -	/* OFDM TX power */
> -	if (priv->r8185) {
> -		for (i = 0; i < 14; i += 2) {
> -			u16 txpwr;
> -			eeprom_93cx6_read(&eeprom, 0x20 + (i >> 1), &txpwr);
> -			priv->channels[i].hw_value |= (txpwr & 0xFF) << 8;
> -			priv->channels[i + 1].hw_value |= txpwr & 0xFF00;
> -		}
> +		eth_random_addr(priv->mac_addr);
>  	}
> +	SET_IEEE80211_PERM_ADDR(dev, priv->mac_addr);
>  
> -	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_NORMAL);
>  
>  	spin_lock_init(&priv->lock);
>  
> @@ -1114,7 +2239,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
>  	}
>  
>  	wiphy_info(dev->wiphy, "hwaddr %pm, %s + %s\n",
> -		   mac_addr, chip_name, priv->rf->name);
> +		   priv->mac_addr, chip_name, priv->rf->name);
>  
>  	return 0;
>  
> @@ -1122,6 +2247,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
>  	iounmap(priv->map);
>  
>   err_free_dev:
> +	pci_set_drvdata(pdev, NULL);
>  	ieee80211_free_hw(dev);
>  
>   err_free_reg:
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
> index 3052331..b4c7204 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
> +++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8180.h
> @@ -11,42 +11,80 @@
>  #define RF_PARAM_CARRIERSENSE2	(1 << 3)
>  
>  #define BB_ANTATTEN_CHAN14	0x0C
> -#define BB_ANTENNA_B 		0x40
> +#define BB_ANTENNA_B		0x40
>  
> -#define BB_HOST_BANG 		(1 << 30)
> -#define BB_HOST_BANG_EN 	(1 << 2)
> -#define BB_HOST_BANG_CLK 	(1 << 1)
> +#define BB_HOST_BANG		(1 << 30)
> +#define BB_HOST_BANG_EN		(1 << 2)
> +#define BB_HOST_BANG_CLK	(1 << 1)
>  #define BB_HOST_BANG_DATA	1
>  
>  #define ANAPARAM_TXDACOFF_SHIFT	27
>  #define ANAPARAM_PWR0_SHIFT	28
> -#define ANAPARAM_PWR0_MASK 	(0x07 << ANAPARAM_PWR0_SHIFT)
> +#define ANAPARAM_PWR0_MASK	(0x07 << ANAPARAM_PWR0_SHIFT)
>  #define ANAPARAM_PWR1_SHIFT	20
>  #define ANAPARAM_PWR1_MASK	(0x7F << ANAPARAM_PWR1_SHIFT)
>  
> +/* rtl8180/rtl8185 have 3 queue + beacon queue.
> + * mac80211 can use just one, + beacon = 2 tot.
> + */
> +#define RTL8180_NR_TX_QUEUES 2
> +
> +/* rtl8187SE have 6 queues + beacon queues
> + * mac80211 can use 4 QoS data queue, + beacon = 5 tot
> + */
> +#define RTL8187SE_NR_TX_QUEUES 5
> +
> +/* for array static allocation, it is the max of above */
> +#define RTL818X_NR_TX_QUEUES 5
> +
>  struct rtl8180_tx_desc {
>  	__le32 flags;
>  	__le16 rts_duration;
>  	__le16 plcp_len;
>  	__le32 tx_buf;
> -	__le32 frame_len;
> +	union{
> +		__le32 frame_len;
> +		struct {
> +			__le16 frame_len_se;
> +			__le16 frame_duration;
> +		} __attribute__ ((packed));
> +	} __attribute__ ((packed));
>  	__le32 next_tx_desc;
>  	u8 cw;
>  	u8 retry_limit;
>  	u8 agc;
>  	u8 flags2;
> -	u32 reserved[2];
> +	/* rsvd for 8180/8185.
> +	 * valid for 8187se but we dont use it
> +	 */
> +	u32 reserved;
> +	/* all rsvd for 8180/8185 */
> +	__le16 flags3;
> +	__le16 frag_qsize;
> +} __packed;
> +
> +struct rtl818x_rx_cmd_desc {
> +	__le32 flags;
> +	u32 reserved;
> +	__le32 rx_buf;
>  } __packed;
>  
>  struct rtl8180_rx_desc {
>  	__le32 flags;
>  	__le32 flags2;
> -	union {
> -		__le32 rx_buf;
> -		__le64 tsft;
> -	};
> +	__le64 tsft;
> +
> +} __packed;
> +
> +struct rtl8187se_rx_desc {
> +	__le32 flags;
> +	__le64 tsft;
> +	__le32 flags2;
> +	__le32 flags3;
> +	u32 reserved[3];
>  } __packed;
>  
> +
>  struct rtl8180_tx_ring {
>  	struct rtl8180_tx_desc *desc;
>  	dma_addr_t dma;
> @@ -63,6 +101,13 @@ struct rtl8180_vif {
>  	bool enable_beacon;
>  };
>  
> +typedef enum {
> +	RTL818X_CHIP_FAMILY_RTL8180,
> +	RTL818X_CHIP_FAMILY_RTL8185,
> +	RTL818X_CHIP_FAMILY_RTL8187SE
> +
> +} rtl818x_chip_family;
> +
>  struct rtl8180_priv {
>  	/* common between rtl818x drivers */
>  	struct rtl818x_csr __iomem *map;
> @@ -71,28 +116,43 @@ struct rtl8180_priv {
>  
>  	/* rtl8180 driver specific */
>  	spinlock_t lock;
> -	struct rtl8180_rx_desc *rx_ring;
> +	void *rx_ring;
> +	u8 rx_ring_sz;
>  	dma_addr_t rx_ring_dma;
>  	unsigned int rx_idx;
>  	struct sk_buff *rx_buf[32];
> -	struct rtl8180_tx_ring tx_ring[4];
> +	struct rtl8180_tx_ring tx_ring[RTL818X_NR_TX_QUEUES];
>  	struct ieee80211_channel channels[14];
>  	struct ieee80211_rate rates[12];
>  	struct ieee80211_supported_band band;
> +	struct ieee80211_tx_queue_params queue_param[4];
>  	struct pci_dev *pdev;
> +	rtl818x_chip_family chip_family;
>  	u32 rx_conf;
> -
> -	int r8185;
> +	u8 slot_time;
> +	u16 ack_time;
> +	bool beacon_queue_stop;
>  	u32 anaparam;
>  	u16 rfparam;
>  	u8 csthreshold;
> -
> +	u8 mac_addr[ETH_ALEN];
> +	u8 rf_type;
> +	u8 rf_prog_type;
> +	u8 xtal_out;
> +	u8 cur_chan;
> +	u8 xtal_in;
> +	u8 xtal_cal;
> +	u8 thermal_meter_val;
> +	u8 thermal_meter_en;
> +	u8 antenna_diversity_en;
> +	u8 antenna_diversity_default;
>  	/* sequence # */
>  	u16 seqno;
>  };
>  
>  void rtl8180_write_phy(struct ieee80211_hw *dev, u8 addr, u32 data);
>  void rtl8180_set_anaparam(struct rtl8180_priv *priv, u32 anaparam);
> +void rtl8180_set_anaparam2(struct rtl8180_priv *priv, u32 anaparam2);
>  
>  static inline u8 rtl818x_ioread8(struct rtl8180_priv *priv, u8 __iomem *addr)
>  {
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
> index ee638d0..56ce3ba 100644
> --- a/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
> +++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225.c
> @@ -23,6 +23,121 @@
>  #include "rtl8180.h"
>  #include "rtl8225.h"
>  
> +static const u8 rtl8225_gain[] = {
> +	0x23, 0x88, 0x7c, 0xa5, /* -82dbm */
> +	0x23, 0x88, 0x7c, 0xb5, /* -82dbm */
> +	0x23, 0x88, 0x7c, 0xc5, /* -82dbm */
> +	0x33, 0x80, 0x79, 0xc5, /* -78dbm */
> +	0x43, 0x78, 0x76, 0xc5, /* -74dbm */
> +	0x53, 0x60, 0x73, 0xc5, /* -70dbm */
> +	0x63, 0x58, 0x70, 0xc5, /* -66dbm */
> +};
> +
> +static const u8 rtl8225_threshold[] = {
> +	0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd
> +};
> +
> +static const u8 rtl8225_tx_gain_cck_ofdm[] = {
> +	0x02, 0x06, 0x0e, 0x1e, 0x3e, 0x7e
> +};
> +
> +static const u8 rtl8225_tx_power_cck[] = {
> +	0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02,
> +	0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02,
> +	0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02,
> +	0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02,
> +	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03,
> +	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03
> +};
> +
> +static const u8 rtl8225_tx_power_cck_ch14[] = {
> +	0x18, 0x17, 0x15, 0x0c, 0x00, 0x00, 0x00, 0x00,
> +	0x1b, 0x1a, 0x17, 0x0e, 0x00, 0x00, 0x00, 0x00,
> +	0x1f, 0x1e, 0x1a, 0x0f, 0x00, 0x00, 0x00, 0x00,
> +	0x22, 0x21, 0x1d, 0x11, 0x00, 0x00, 0x00, 0x00,
> +	0x26, 0x25, 0x21, 0x13, 0x00, 0x00, 0x00, 0x00,
> +	0x2b, 0x2a, 0x25, 0x15, 0x00, 0x00, 0x00, 0x00
> +};
> +
> +static const u8 rtl8225_tx_power_ofdm[] = {
> +	0x80, 0x90, 0xa2, 0xb5, 0xcb, 0xe4
> +};
> +
> +static const u32 rtl8225_chan[] = {
> +	0x085c, 0x08dc, 0x095c, 0x09dc, 0x0a5c, 0x0adc, 0x0b5c,
> +	0x0bdc, 0x0c5c, 0x0cdc, 0x0d5c, 0x0ddc, 0x0e5c, 0x0f72
> +};
> +
> +
> +static const u8 rtl8225z2_tx_power_cck_ch14[] = {
> +	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
> +};
> +
> +static const u8 rtl8225z2_tx_power_cck_B[] = {
> +	0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x04
> +};
> +
> +static const u8 rtl8225z2_tx_power_cck_A[] = {
> +	0x33, 0x32, 0x2b, 0x23, 0x1a, 0x11, 0x08, 0x04
> +};
> +
> +static const u8 rtl8225z2_tx_power_cck[] = {
> +	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
> +};
> +
> +
> +static const u16 rtl8225bcd_rxgain[] = {
> +	0x0400, 0x0401, 0x0402, 0x0403, 0x0404, 0x0405, 0x0408, 0x0409,
> +	0x040a, 0x040b, 0x0502, 0x0503, 0x0504, 0x0505, 0x0540, 0x0541,
> +	0x0542, 0x0543, 0x0544, 0x0545, 0x0580, 0x0581, 0x0582, 0x0583,
> +	0x0584, 0x0585, 0x0588, 0x0589, 0x058a, 0x058b, 0x0643, 0x0644,
> +	0x0645, 0x0680, 0x0681, 0x0682, 0x0683, 0x0684, 0x0685, 0x0688,
> +	0x0689, 0x068a, 0x068b, 0x068c, 0x0742, 0x0743, 0x0744, 0x0745,
> +	0x0780, 0x0781, 0x0782, 0x0783, 0x0784, 0x0785, 0x0788, 0x0789,
> +	0x078a, 0x078b, 0x078c, 0x078d, 0x0790, 0x0791, 0x0792, 0x0793,
> +	0x0794, 0x0795, 0x0798, 0x0799, 0x079a, 0x079b, 0x079c, 0x079d,
> +	0x07a0, 0x07a1, 0x07a2, 0x07a3, 0x07a4, 0x07a5, 0x07a8, 0x07a9,
> +	0x07aa, 0x07ab, 0x07ac, 0x07ad, 0x07b0, 0x07b1, 0x07b2, 0x07b3,
> +	0x07b4, 0x07b5, 0x07b8, 0x07b9, 0x07ba, 0x07bb, 0x07bb
> +};
> +
> +
> +static const u16 rtl8225z2_rxgain[] = {
> +	0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0008, 0x0009,
> +	0x000a, 0x000b, 0x0102, 0x0103, 0x0104, 0x0105, 0x0140, 0x0141,
> +	0x0142, 0x0143, 0x0144, 0x0145, 0x0180, 0x0181, 0x0182, 0x0183,
> +	0x0184, 0x0185, 0x0188, 0x0189, 0x018a, 0x018b, 0x0243, 0x0244,
> +	0x0245, 0x0280, 0x0281, 0x0282, 0x0283, 0x0284, 0x0285, 0x0288,
> +	0x0289, 0x028a, 0x028b, 0x028c, 0x0342, 0x0343, 0x0344, 0x0345,
> +	0x0380, 0x0381, 0x0382, 0x0383, 0x0384, 0x0385, 0x0388, 0x0389,
> +	0x038a, 0x038b, 0x038c, 0x038d, 0x0390, 0x0391, 0x0392, 0x0393,
> +	0x0394, 0x0395, 0x0398, 0x0399, 0x039a, 0x039b, 0x039c, 0x039d,
> +	0x03a0, 0x03a1, 0x03a2, 0x03a3, 0x03a4, 0x03a5, 0x03a8, 0x03a9,
> +	0x03aa, 0x03ab, 0x03ac, 0x03ad, 0x03b0, 0x03b1, 0x03b2, 0x03b3,
> +	0x03b4, 0x03b5, 0x03b8, 0x03b9, 0x03ba, 0x03bb, 0x03bb
> +};
> +
> +
> +static const u8 rtl8225_agc[] = {
> +	0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e,
> +	0x9d, 0x9c, 0x9b, 0x9a, 0x99, 0x98, 0x97, 0x96,
> +	0x95, 0x94, 0x93, 0x92, 0x91, 0x90, 0x8f, 0x8e,
> +	0x8d, 0x8c, 0x8b, 0x8a, 0x89, 0x88, 0x87, 0x86,
> +	0x85, 0x84, 0x83, 0x82, 0x81, 0x80, 0x3f, 0x3e,
> +	0x3d, 0x3c, 0x3b, 0x3a, 0x39, 0x38, 0x37, 0x36,
> +	0x35, 0x34, 0x33, 0x32, 0x31, 0x30, 0x2f, 0x2e,
> +	0x2d, 0x2c, 0x2b, 0x2a, 0x29, 0x28, 0x27, 0x26,
> +	0x25, 0x24, 0x23, 0x22, 0x21, 0x20, 0x1f, 0x1e,
> +	0x1d, 0x1c, 0x1b, 0x1a, 0x19, 0x18, 0x17, 0x16,
> +	0x15, 0x14, 0x13, 0x12, 0x11, 0x10, 0x0f, 0x0e,
> +	0x0d, 0x0c, 0x0b, 0x0a, 0x09, 0x08, 0x07, 0x06,
> +	0x05, 0x04, 0x03, 0x02, 0x01, 0x01, 0x01, 0x01,
> +	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> +	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
> +};
> +
> +
>  static void rtl8225_write(struct ieee80211_hw *dev, u8 addr, u16 data)
>  {
>  	struct rtl8180_priv *priv = dev->priv;
> @@ -177,84 +292,10 @@ static u16 rtl8225_read(struct ieee80211_hw *dev, u8 addr)
>  	return out;
>  }
>  
> -static const u16 rtl8225bcd_rxgain[] = {
> -	0x0400, 0x0401, 0x0402, 0x0403, 0x0404, 0x0405, 0x0408, 0x0409,
> -	0x040a, 0x040b, 0x0502, 0x0503, 0x0504, 0x0505, 0x0540, 0x0541,
> -	0x0542, 0x0543, 0x0544, 0x0545, 0x0580, 0x0581, 0x0582, 0x0583,
> -	0x0584, 0x0585, 0x0588, 0x0589, 0x058a, 0x058b, 0x0643, 0x0644,
> -	0x0645, 0x0680, 0x0681, 0x0682, 0x0683, 0x0684, 0x0685, 0x0688,
> -	0x0689, 0x068a, 0x068b, 0x068c, 0x0742, 0x0743, 0x0744, 0x0745,
> -	0x0780, 0x0781, 0x0782, 0x0783, 0x0784, 0x0785, 0x0788, 0x0789,
> -	0x078a, 0x078b, 0x078c, 0x078d, 0x0790, 0x0791, 0x0792, 0x0793,
> -	0x0794, 0x0795, 0x0798, 0x0799, 0x079a, 0x079b, 0x079c, 0x079d,
> -	0x07a0, 0x07a1, 0x07a2, 0x07a3, 0x07a4, 0x07a5, 0x07a8, 0x07a9,
> -	0x07aa, 0x07ab, 0x07ac, 0x07ad, 0x07b0, 0x07b1, 0x07b2, 0x07b3,
> -	0x07b4, 0x07b5, 0x07b8, 0x07b9, 0x07ba, 0x07bb, 0x07bb
> -};
>  
> -static const u8 rtl8225_agc[] = {
> -	0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e, 0x9e,
> -	0x9d, 0x9c, 0x9b, 0x9a, 0x99, 0x98, 0x97, 0x96,
> -	0x95, 0x94, 0x93, 0x92, 0x91, 0x90, 0x8f, 0x8e,
> -	0x8d, 0x8c, 0x8b, 0x8a, 0x89, 0x88, 0x87, 0x86,
> -	0x85, 0x84, 0x83, 0x82, 0x81, 0x80, 0x3f, 0x3e,
> -	0x3d, 0x3c, 0x3b, 0x3a, 0x39, 0x38, 0x37, 0x36,
> -	0x35, 0x34, 0x33, 0x32, 0x31, 0x30, 0x2f, 0x2e,
> -	0x2d, 0x2c, 0x2b, 0x2a, 0x29, 0x28, 0x27, 0x26,
> -	0x25, 0x24, 0x23, 0x22, 0x21, 0x20, 0x1f, 0x1e,
> -	0x1d, 0x1c, 0x1b, 0x1a, 0x19, 0x18, 0x17, 0x16,
> -	0x15, 0x14, 0x13, 0x12, 0x11, 0x10, 0x0f, 0x0e,
> -	0x0d, 0x0c, 0x0b, 0x0a, 0x09, 0x08, 0x07, 0x06,
> -	0x05, 0x04, 0x03, 0x02, 0x01, 0x01, 0x01, 0x01,
> -	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> -	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
> -	0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01
> -};
> -
> -static const u8 rtl8225_gain[] = {
> -	0x23, 0x88, 0x7c, 0xa5, /* -82dbm */
> -	0x23, 0x88, 0x7c, 0xb5, /* -82dbm */
> -	0x23, 0x88, 0x7c, 0xc5, /* -82dbm */
> -	0x33, 0x80, 0x79, 0xc5, /* -78dbm */
> -	0x43, 0x78, 0x76, 0xc5, /* -74dbm */
> -	0x53, 0x60, 0x73, 0xc5, /* -70dbm */
> -	0x63, 0x58, 0x70, 0xc5, /* -66dbm */
> -};
> -
> -static const u8 rtl8225_threshold[] = {
> -	0x8d, 0x8d, 0x8d, 0x8d, 0x9d, 0xad, 0xbd
> -};
> -
> -static const u8 rtl8225_tx_gain_cck_ofdm[] = {
> -	0x02, 0x06, 0x0e, 0x1e, 0x3e, 0x7e
> -};
> -
> -static const u8 rtl8225_tx_power_cck[] = {
> -	0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02,
> -	0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02,
> -	0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02,
> -	0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02,
> -	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03,
> -	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03
> -};
>  
> -static const u8 rtl8225_tx_power_cck_ch14[] = {
> -	0x18, 0x17, 0x15, 0x0c, 0x00, 0x00, 0x00, 0x00,
> -	0x1b, 0x1a, 0x17, 0x0e, 0x00, 0x00, 0x00, 0x00,
> -	0x1f, 0x1e, 0x1a, 0x0f, 0x00, 0x00, 0x00, 0x00,
> -	0x22, 0x21, 0x1d, 0x11, 0x00, 0x00, 0x00, 0x00,
> -	0x26, 0x25, 0x21, 0x13, 0x00, 0x00, 0x00, 0x00,
> -	0x2b, 0x2a, 0x25, 0x15, 0x00, 0x00, 0x00, 0x00
> -};
>  
> -static const u8 rtl8225_tx_power_ofdm[] = {
> -	0x80, 0x90, 0xa2, 0xb5, 0xcb, 0xe4
> -};
>  
> -static const u32 rtl8225_chan[] = {
> -	0x085c, 0x08dc, 0x095c, 0x09dc, 0x0a5c, 0x0adc, 0x0b5c,
> -	0x0bdc, 0x0c5c, 0x0cdc, 0x0d5c, 0x0ddc, 0x0e5c, 0x0f72
> -};
>  
>  static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
>  {
> @@ -283,6 +324,7 @@ static void rtl8225_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
>  
>  	msleep(1); /* FIXME: optional? */
>  
> +	/* TODO: use_anaparam2_dev.c_func*/
>  	/* anaparam2 on */
>  	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
>  	reg = rtl818x_ioread8(priv, &priv->map->CONFIG3);
> @@ -313,6 +355,7 @@ static void rtl8225_rf_init(struct ieee80211_hw *dev)
>  	rtl818x_iowrite16(priv, &priv->map->RFPinsOutput, 0x0480);
>  	rtl818x_iowrite16(priv, &priv->map->RFPinsEnable, 0x1FFF);
>  	rtl818x_iowrite16(priv, &priv->map->RFPinsSelect, 0x0488);
> +
>  	rtl818x_iowrite8(priv, &priv->map->GP_ENABLE, 0);
>  	rtl818x_ioread8(priv, &priv->map->EEPROM_CMD);
>  	msleep(200);	/* FIXME: ehh?? */
> @@ -456,22 +499,6 @@ static void rtl8225_rf_init(struct ieee80211_hw *dev)
>  	rtl8225_write_phy_cck(dev, 0x41, rtl8225_threshold[0]);
>  }
>  
> -static const u8 rtl8225z2_tx_power_cck_ch14[] = {
> -	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
> -};
> -
> -static const u8 rtl8225z2_tx_power_cck_B[] = {
> -	0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x04
> -};
> -
> -static const u8 rtl8225z2_tx_power_cck_A[] = {
> -	0x33, 0x32, 0x2b, 0x23, 0x1a, 0x11, 0x08, 0x04
> -};
> -
> -static const u8 rtl8225z2_tx_power_cck[] = {
> -	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
> -};
> -
>  static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
>  {
>  	struct rtl8180_priv *priv = dev->priv;
> @@ -516,21 +543,6 @@ static void rtl8225z2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
>  	msleep(1);
>  }
>  
> -static const u16 rtl8225z2_rxgain[] = {
> -	0x0000, 0x0001, 0x0002, 0x0003, 0x0004, 0x0005, 0x0008, 0x0009,
> -	0x000a, 0x000b, 0x0102, 0x0103, 0x0104, 0x0105, 0x0140, 0x0141,
> -	0x0142, 0x0143, 0x0144, 0x0145, 0x0180, 0x0181, 0x0182, 0x0183,
> -	0x0184, 0x0185, 0x0188, 0x0189, 0x018a, 0x018b, 0x0243, 0x0244,
> -	0x0245, 0x0280, 0x0281, 0x0282, 0x0283, 0x0284, 0x0285, 0x0288,
> -	0x0289, 0x028a, 0x028b, 0x028c, 0x0342, 0x0343, 0x0344, 0x0345,
> -	0x0380, 0x0381, 0x0382, 0x0383, 0x0384, 0x0385, 0x0388, 0x0389,
> -	0x038a, 0x038b, 0x038c, 0x038d, 0x0390, 0x0391, 0x0392, 0x0393,
> -	0x0394, 0x0395, 0x0398, 0x0399, 0x039a, 0x039b, 0x039c, 0x039d,
> -	0x03a0, 0x03a1, 0x03a2, 0x03a3, 0x03a4, 0x03a5, 0x03a8, 0x03a9,
> -	0x03aa, 0x03ab, 0x03ac, 0x03ad, 0x03b0, 0x03b1, 0x03b2, 0x03b3,
> -	0x03b4, 0x03b5, 0x03b8, 0x03b9, 0x03ba, 0x03bb, 0x03bb
> -};
> -
>  static void rtl8225z2_rf_init(struct ieee80211_hw *dev)
>  {
>  	struct rtl8180_priv *priv = dev->priv;
> @@ -731,32 +743,13 @@ static void rtl8225_rf_set_channel(struct ieee80211_hw *dev,
>  	msleep(10);
>  }
>  
> -static void rtl8225_rf_conf_erp(struct ieee80211_hw *dev,
> -				struct ieee80211_bss_conf *info)
> -{
> -	struct rtl8180_priv *priv = dev->priv;
> -
> -	if (info->use_short_slot) {
> -		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x9);
> -		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x22);
> -		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x14);
> -		rtl818x_iowrite8(priv, &priv->map->EIFS, 81);
> -		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0x73);
> -	} else {
> -		rtl818x_iowrite8(priv, &priv->map->SLOT, 0x14);
> -		rtl818x_iowrite8(priv, &priv->map->SIFS, 0x44);
> -		rtl818x_iowrite8(priv, &priv->map->DIFS, 0x24);
> -		rtl818x_iowrite8(priv, &priv->map->EIFS, 81);
> -		rtl818x_iowrite8(priv, &priv->map->CW_VAL, 0xa5);
> -	}
> -}
>  
>  static const struct rtl818x_rf_ops rtl8225_ops = {
>  	.name		= "rtl8225",
>  	.init		= rtl8225_rf_init,
>  	.stop		= rtl8225_rf_stop,
>  	.set_chan	= rtl8225_rf_set_channel,
> -	.conf_erp	= rtl8225_rf_conf_erp,
> +
>  };
>  
>  static const struct rtl818x_rf_ops rtl8225z2_ops = {
> @@ -764,7 +757,7 @@ static const struct rtl818x_rf_ops rtl8225z2_ops = {
>  	.init		= rtl8225z2_rf_init,
>  	.stop		= rtl8225_rf_stop,
>  	.set_chan	= rtl8225_rf_set_channel,
> -	.conf_erp	= rtl8225_rf_conf_erp,
> +
>  };
>  
>  const struct rtl818x_rf_ops * rtl8180_detect_rf(struct ieee80211_hw *dev)
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c b/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c
> new file mode 100644
> index 0000000..ca4d148
> --- /dev/null
> +++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.c
> @@ -0,0 +1,500 @@
> +
> +/*
> + * Radio tuning for RTL8225 on RTL8187SE
> + *
> + * Copyright 2009 Larry Finger <Larry.Finger@lwfinger.net>
> + *
> + * Based on the r8180 and Realtek r8187se drivers, which are:
> + * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
> + *
> + * Also based on the rtl8187 driver, which is:
> + * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
> + * Copyright 2007 Andrea Merello <andreamrl@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <net/mac80211.h>
> +
> +#include "rtl8180.h"
> +#include "rtl8225se.h"
> +
> +
> +#define PFX "rtl8225 (se)"
> +
> +static const u32 RF_GAIN_TABLE[] = {
> +	0x0096, 0x0076, 0x0056, 0x0036, 0x0016, 0x01f6, 0x01d6, 0x01b6,
> +	0x0196, 0x0176, 0x00F7, 0x00D7, 0x00B7, 0x0097, 0x0077, 0x0057,
> +	0x0037, 0x00FB, 0x00DB, 0x00BB, 0x00FF, 0x00E3, 0x00C3, 0x00A3,
> +	0x0083, 0x0063, 0x0043, 0x0023, 0x0003, 0x01E3, 0x01C3, 0x01A3,
> +	0x0183, 0x0163, 0x0143, 0x0123, 0x0103
> +};
> +
> +
> +static const u8 cck_ofdm_gain_settings[] = {
> +	0x00, 0x01, 0x02, 0x03, 0x04, 0x05,
> +	0x06, 0x07, 0x08, 0x09, 0x0a, 0x0b,
> +	0x0c, 0x0d, 0x0e, 0x0f, 0x10, 0x11,
> +	0x12, 0x13, 0x14, 0x15, 0x16, 0x17,
> +	0x18, 0x19, 0x1a, 0x1b, 0x1c, 0x1d,
> +	0x1e, 0x1f, 0x20, 0x21, 0x22, 0x23,
> +};
> +
> +
> +
> +static const u8 rtl8225se_tx_gain_cck_ofdm[] = {
> +	0x02, 0x06, 0x0e, 0x1e, 0x3e, 0x7e
> +};
> +
> +static const u8 rtl8225se_tx_power_cck[] = {
> +	0x18, 0x17, 0x15, 0x11, 0x0c, 0x08, 0x04, 0x02,
> +	0x1b, 0x1a, 0x17, 0x13, 0x0e, 0x09, 0x04, 0x02,
> +	0x1f, 0x1e, 0x1a, 0x15, 0x10, 0x0a, 0x05, 0x02,
> +	0x22, 0x21, 0x1d, 0x18, 0x11, 0x0b, 0x06, 0x02,
> +	0x26, 0x25, 0x21, 0x1b, 0x14, 0x0d, 0x06, 0x03,
> +	0x2b, 0x2a, 0x25, 0x1e, 0x16, 0x0e, 0x07, 0x03
> +};
> +
> +static const u8 rtl8225se_tx_power_cck_ch14[] = {
> +	0x18, 0x17, 0x15, 0x0c, 0x00, 0x00, 0x00, 0x00,
> +	0x1b, 0x1a, 0x17, 0x0e, 0x00, 0x00, 0x00, 0x00,
> +	0x1f, 0x1e, 0x1a, 0x0f, 0x00, 0x00, 0x00, 0x00,
> +	0x22, 0x21, 0x1d, 0x11, 0x00, 0x00, 0x00, 0x00,
> +	0x26, 0x25, 0x21, 0x13, 0x00, 0x00, 0x00, 0x00,
> +	0x2b, 0x2a, 0x25, 0x15, 0x00, 0x00, 0x00, 0x00
> +};
> +
> +static const u8 rtl8225se_tx_power_ofdm[] = {
> +	0x80, 0x90, 0xa2, 0xb5, 0xcb, 0xe4
> +};
> +
> +static const u32 rtl8225se_chan[] = {
> +	0x0080, 0x0100, 0x0180, 0x0200, 0x0280, 0x0300, 0x0380,
> +	0x0400, 0x0480, 0x0500, 0x0580, 0x0600, 0x0680, 0x074A,
> +};
> +
> +static const u8 rtl8225sez2_tx_power_cck_ch14[] = {
> +	0x36, 0x35, 0x2e, 0x1b, 0x00, 0x00, 0x00, 0x00
> +};
> +
> +static const u8 rtl8225sez2_tx_power_cck_B[] = {
> +	0x30, 0x2f, 0x29, 0x21, 0x19, 0x10, 0x08, 0x04
> +};
> +
> +static const u8 rtl8225sez2_tx_power_cck_A[] = {
> +	0x33, 0x32, 0x2b, 0x23, 0x1a, 0x11, 0x08, 0x04
> +};
> +
> +static const u8 rtl8225sez2_tx_power_cck[] = {
> +	0x36, 0x35, 0x2e, 0x25, 0x1c, 0x12, 0x09, 0x04
> +};
> +
> +static const u8 ZEBRA_AGC[] = {
> +	0x7E, 0x7E, 0x7E, 0x7E, 0x7D, 0x7C, 0x7B, 0x7A,
> +	0x79, 0x78, 0x77, 0x76, 0x75, 0x74, 0x73, 0x72,
> +	0x71, 0x70, 0x6F, 0x6E, 0x6D, 0x6C, 0x6B, 0x6A,
> +	0x69, 0x68, 0x67, 0x66, 0x65, 0x64, 0x63, 0x62,
> +	0x48, 0x47, 0x46, 0x45, 0x44, 0x29, 0x28, 0x27,
> +	0x26, 0x25, 0x24, 0x23, 0x22, 0x21, 0x08, 0x07,
> +	0x06, 0x05, 0x04, 0x03, 0x02, 0x01, 0x00, 0x00,
> +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> +	0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f, 0x0f,
> +	0x0f, 0x0f, 0x10, 0x11, 0x12, 0x13, 0x15, 0x16,
> +	0x17, 0x17, 0x18, 0x18, 0x19, 0x1a, 0x1a, 0x1b,
> +	0x1b, 0x1c, 0x1c, 0x1d, 0x1d, 0x1d, 0x1e, 0x1e,
> +	0x1f, 0x1f, 0x1f, 0x20, 0x20, 0x20, 0x20, 0x21,
> +	0x21, 0x21, 0x22, 0x22, 0x22, 0x23, 0x23, 0x24,
> +	0x24, 0x25, 0x25, 0x25, 0x26, 0x26, 0x27, 0x27,
> +	0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F, 0x2F
> +};
> +
> +static const u8 OFDM_CONFIG[] = {
> +	0x10, 0x0F, 0x0A, 0x0C, 0x14, 0xFA, 0xFF, 0x50,
> +	0x00, 0x50, 0x00, 0x00, 0x00, 0x5C, 0x00, 0x00,
> +	0x40, 0x00, 0x40, 0x00, 0x00, 0x00, 0xA8, 0x26,
> +	0x32, 0x33, 0x06, 0xA5, 0x6F, 0x55, 0xC8, 0xBB,
> +	0x0A, 0xE1, 0x2C, 0x4A, 0x86, 0x83, 0x34, 0x00,
> +	0x4F, 0x24, 0x6F, 0xC2, 0x03, 0x40, 0x80, 0x00,
> +	0xC0, 0xC1, 0x58, 0xF1, 0x00, 0xC4, 0x90, 0x3e,
> +	0xD8, 0x3C, 0x7B, 0x10, 0x10
> +};
> +
> +
> +
> +
> +
> +static void rtl8187se_three_wire_io(struct ieee80211_hw *dev, u8 *data,
> +				    u8 len, bool write)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +	int i;
> +	u8 tmp;
> +
> +	do {
> +		for (i = 0; i < 5; i++) {
> +			tmp = rtl818x_ioread8(priv, SW_3W_CMD1);
> +			if (!(tmp & 0x3))
> +				break;
> +			udelay(10);
> +		}
> +		if (i == 5)
> +			printk(KERN_ERR  PFX "CmdReg: 0x%x RE/WE bits are not"
> +			       " clear\n", tmp);
> +		tmp = rtl818x_ioread8(priv, &priv->map->rf_sw_config) | 0x02;
> +		rtl818x_iowrite8(priv, &priv->map->rf_sw_config, tmp);
> +
> +		tmp = rtl818x_ioread8(priv, REG_ADDR1(0x84)) & 0xF7;
> +		rtl818x_iowrite8(priv, REG_ADDR1(0x84), tmp);
> +		if (write) {
> +			if (len == 16) {
> +				rtl818x_iowrite16(priv, SW_3W_DB0,
> +				  *(u16 *)data);
> +			} else if (len == 64) {
> +				rtl818x_iowrite32(priv, SW_3W_DB0_4,
> +				  *((u32 *)data));
> +				rtl818x_iowrite32(priv, SW_3W_DB1_4,
> +				  *((u32 *)(data + 4)));
> +			} else
> +				printk(KERN_ERR PFX "Unimplemented length\n");
> +		} else {
> +			rtl818x_iowrite16(priv, SW_3W_DB0, *(u16 *)data);
> +		}
> +		if (write)
> +			tmp = 2;
> +		else
> +			tmp = 1;
> +		rtl818x_iowrite8(priv, SW_3W_CMD1, tmp);
> +		for (i = 0; i < 5; i++) {
> +			tmp = rtl818x_ioread8(priv, SW_3W_CMD1);
> +			if (!(tmp & 0x3))
> +				break;
> +			udelay(10);
> +		}
> +		rtl818x_iowrite8(priv, SW_3W_CMD1, 0);
> +		if (!write) {
> +			*((u16 *)data) = rtl818x_ioread16(priv, SI_DATA_REG);
> +			*((u16 *)data) &= 0x0FFF;
> +		}
> +	} while (0);
> +}
> +
> +static u32 rtl8187se_rf_readreg(struct ieee80211_hw *dev, u8 addr)
> +{
> +	u32 dataread = addr & 0x0F;
> +	rtl8187se_three_wire_io(dev, (u8 *)&dataread, 16, 0);
> +	return dataread;
> +}
> +
> +static void rtl8187se_rf_writereg(struct ieee80211_hw *dev, u8 addr, u32 data)
> +{
> +	u32 outdata = (data << 4) | (u32)(addr & 0x0F);
> +	rtl8187se_three_wire_io(dev, (u8 *)&outdata, 16, 1);
> +}
> +
> +
> +static void rtl8225se_write_zebra_agc(struct ieee80211_hw *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i < 128; i++) {
> +
> +		rtl8225se_write_phy_ofdm(dev, 0xF, ZEBRA_AGC[i]);
> +		rtl8225se_write_phy_ofdm(dev, 0xE, i+0x80);
> +		rtl8225se_write_phy_ofdm(dev, 0xE, 0);
> +
> +	}
> +}
> +
> +static void rtl8187se_write_ofdm_config(struct ieee80211_hw *dev)
> +{
> +	/* write OFDM_CONFIG table */
> +	int i;
> +
> +	for (i = 0; i < 60; i++)
> +		rtl8225se_write_phy_ofdm(dev, i, OFDM_CONFIG[i]);
> +
> +}
> +
> +static void rtl8225sez2_rf_set_tx_power(struct ieee80211_hw *dev, int channel)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +	u8 cck_power, ofdm_power;
> +
> +	cck_power = priv->channels[channel - 1].hw_value & 0xFF;
> +	if (cck_power > 35)
> +		cck_power = 35;
> +	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK,
> +			 cck_ofdm_gain_settings[cck_power]);
> +
> +	msleep(1);
> +	ofdm_power = priv->channels[channel - 1].hw_value >> 8;
> +	if (ofdm_power > 35)
> +		ofdm_power = 35;
> +#if 0
> +	if (!do_once) {
> +		rtl8225se_write_phy_ofdm(dev, 2, 0x42);
> +		rtl8225se_write_phy_ofdm(dev, 5, 0x00);
> +		rtl8225se_write_phy_ofdm(dev, 6, 0x40);
> +		rtl8225se_write_phy_ofdm(dev, 7, 0x00);
> +		rtl8225se_write_phy_ofdm(dev, 8, 0x40);
> +		do_once++;
> +	}
> +#endif
> +
> +	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM,
> +			 cck_ofdm_gain_settings[ofdm_power]);
> +	if (ofdm_power < 12) {
> +		rtl8225se_write_phy_ofdm(dev, 7, 0x5C);
> +		rtl8225se_write_phy_ofdm(dev, 9, 0x5C);
> +	}
> +	if (ofdm_power < 18) {
> +		rtl8225se_write_phy_ofdm(dev, 7, 0x54);
> +		rtl8225se_write_phy_ofdm(dev, 9, 0x54);
> +	} else {
> +		rtl8225se_write_phy_ofdm(dev, 7, 0x50);
> +		rtl8225se_write_phy_ofdm(dev, 9, 0x50);
> +	}
> +
> +	msleep(1);
> +}
> +
> +
> +static void rtl8187se_write_rf_gain(struct ieee80211_hw *dev)
> +{
> +	int i;
> +
> +	for (i = 0; i <= 36; i++) {
> +		rtl8187se_rf_writereg(dev, 0x01, i); mdelay(1);
> +		rtl8187se_rf_writereg(dev, 0x02, RF_GAIN_TABLE[i]); mdelay(1);
> +	}
> +}
> +
> +static void rtl8187se_write_initial_gain(struct ieee80211_hw *dev, int init_gain)
> +{
> +
> +	switch (init_gain) {
> +	default:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x26); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0x86); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFA); mdelay(1);
> +		break;
> +	case 2:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x36); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0x86); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFA); mdelay(1);
> +		break;
> +	case 3:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x36); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0x86); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFB); mdelay(1);
> +		break;
> +	case 4:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x46); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0x86); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFB); mdelay(1);
> +		break;
> +	case 5:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x46); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0x96); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFB); mdelay(1);
> +		break;
> +	case 6:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x56); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0x96); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFC); mdelay(1);
> +		break;
> +	case 7:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x56); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0xA6); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFC); mdelay(1);
> +		break;
> +	case 8:
> +		rtl8225se_write_phy_ofdm(dev, 0x17, 0x66); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x24, 0xB6); mdelay(1);
> +		rtl8225se_write_phy_ofdm(dev, 0x05, 0xFC); mdelay(1);
> +		break;
> +	}
> +}
> +
> +
> +void rtl8225se_rf_init(struct ieee80211_hw *dev)
> +{
> +	struct rtl8180_priv *priv = dev->priv;
> +	u32 rf23, rf24;
> +	u8 d_cut = 0;
> +	u8 tmp;
> +
> +	/* Page 1 */
> +	rtl8187se_rf_writereg(dev, 0x00, 0x013F); mdelay(1);
> +	rf23 = rtl8187se_rf_readreg(dev, 0x08); mdelay(1);
> +	rf24 = rtl8187se_rf_readreg(dev, 0x09); mdelay(1);
> +	if (rf23 == 0x0818 && rf24 == 0x070C)
> +		d_cut = 1;
> +
> +	printk(KERN_INFO"RTL8225-SE version %s\n", d_cut ? "D" : "not-D");
> +
> +	/* Page 0: reg 0 - 15 */
> +	rtl8187se_rf_writereg(dev, 0x00, 0x009F); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x01, 0x06E0); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x02, 0x004D); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x03, 0x07F1); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x04, 0x0975); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x05, 0x0C72); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x06, 0x0AE6); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x07, 0x00CA); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x08, 0x0E1C); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x09, 0x02F0); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0A, 0x09D0); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0B, 0x01BA); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0C, 0x0640); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0D, 0x08DF); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0E, 0x0020); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0F, 0x0990); mdelay(1);
> +	/* page 1: reg 16-30 */
> +	rtl8187se_rf_writereg(dev, 0x00, 0x013F); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x03, 0x0806); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x04, 0x03A7); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x05, 0x059B); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x06, 0x0081); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x07, 0x01A0); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0A, 0x0001); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0B, 0x0418); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0C, 0x0FBE); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0D, 0x0008); mdelay(1);
> +	if (d_cut)
> +		rtl8187se_rf_writereg(dev, 0x0E, 0x0807);
> +	else
> +		rtl8187se_rf_writereg(dev, 0x0E, 0x0806);
> +	mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0F, 0x0ACC); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x00, 0x01D7); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x03, 0x0E00); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x04, 0x0E50); mdelay(1);
> +
> +	rtl8187se_write_rf_gain(dev);
> +
> +	rtl8187se_rf_writereg(dev, 0x05, 0x0203); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x06, 0x0200); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x00, 0x0137); mdelay(11);
> +	rtl8187se_rf_writereg(dev, 0x0D, 0x0008); mdelay(11);
> +	rtl8187se_rf_writereg(dev, 0x00, 0x0037); mdelay(11);
> +	rtl8187se_rf_writereg(dev, 0x04, 0x0160); mdelay(11);
> +	rtl8187se_rf_writereg(dev, 0x07, 0x0080); mdelay(11);
> +	rtl8187se_rf_writereg(dev, 0x02, 0x088D); mdelay(221);
> +	rtl8187se_rf_writereg(dev, 0x00, 0x0137); mdelay(11);
> +	rtl8187se_rf_writereg(dev, 0x07, 0x0000); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x07, 0x0180); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x07, 0x0220); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x07, 0x03E0); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x06, 0x00C1); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0A, 0x0001); mdelay(1);
> +	if (priv->xtal_cal) {
> +		tmp = (priv->xtal_in << 4) | (priv->xtal_out << 1) |
> +		      (1 << 11) | (1 << 9);
> +		rtl8187se_rf_writereg(dev, 0x0F, tmp);
> +		printk("Xtal cal\n");
> +		mdelay(1);
> +	} else {
> +		printk("NO Xtal cal\n");
> +		rtl8187se_rf_writereg(dev, 0x0F, 0x0ACC);
> +		mdelay(1);
> +	}
> +	/* page 0 */
> +	rtl8187se_rf_writereg(dev, 0x00, 0x00BF); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x0D, 0x08DF); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x02, 0x004D); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x04, 0x0975); mdelay(31);
> +	rtl8187se_rf_writereg(dev, 0x00, 0x0197); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x05, 0x05AB); mdelay(1);
> +
> +	rtl8187se_rf_writereg(dev, 0x00, 0x009F); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x01, 0x0000); mdelay(1);
> +	rtl8187se_rf_writereg(dev, 0x02, 0x0000); mdelay(1);
> +	/* power save parameters */
> +	/* TODO: move to dev.c */
> +	rtl818x_iowrite8(priv, REG_ADDR1(0x024E),
> +		 rtl818x_ioread8(priv, REG_ADDR1(0x24E)) & 0x9F);
> +	rtl8225se_write_phy_cck(dev, 0x00, 0xC8);
> +	rtl8225se_write_phy_cck(dev, 0x06, 0x1C);
> +	rtl8225se_write_phy_cck(dev, 0x10, 0x78);
> +	rtl8225se_write_phy_cck(dev, 0x2E, 0xD0);
> +	rtl8225se_write_phy_cck(dev, 0x2F, 0x06);
> +	rtl8225se_write_phy_cck(dev, 0x01, 0x46);
> +
> +	/* power control */
> +	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_CCK, 0x10);
> +	rtl818x_iowrite8(priv, &priv->map->TX_GAIN_OFDM, 0x1B);
> +
> +	rtl818x_iowrite8(priv, &priv->map->TX_ANTENNA, 0x03);
> +	rtl8225se_write_phy_ofdm(dev, 0x00, 0x12);
> +
> +	rtl8225se_write_zebra_agc(dev);
> +
> +	rtl8225se_write_phy_ofdm(dev, 0x10, 0x00);
> +
> +	rtl8187se_write_ofdm_config(dev);
> +
> +	/* turn on RF */
> +	rtl8187se_rf_writereg(dev, 0x00, 0x009F); udelay(500);
> +	rtl8187se_rf_writereg(dev, 0x04, 0x0972); udelay(500);
> +	/* turn on RF again */
> +	rtl8187se_rf_writereg(dev, 0x00, 0x009F); udelay(500);
> +	rtl8187se_rf_writereg(dev, 0x04, 0x0972); udelay(500);
> +	/* turn on BB */
> +	rtl8225se_write_phy_ofdm(dev, 0x10, 0x40);
> +	rtl8225se_write_phy_ofdm(dev, 0x12, 0x40);
> +
> +	rtl8187se_write_initial_gain(dev, 4);
> +}
> +
> +
> +void rtl8225se_rf_stop(struct ieee80211_hw *dev)
> +{
> +	/* checked for 8187se */
> +	struct rtl8180_priv *priv = dev->priv;
> +
> +
> +	/* turn off BB RXIQ matrix to cut off rx signal */
> +	rtl8225se_write_phy_ofdm(dev, 0x10, 0x00);
> +	rtl8225se_write_phy_ofdm(dev, 0x12, 0x00);
> +	/* turn off RF */
> +	rtl8187se_rf_writereg(dev, 0x04, 0x0000);
> +	rtl8187se_rf_writereg(dev, 0x00, 0x0000);
> +
> +	msleep(1);
> +	/* turn off A/D and D/A */
> +	rtl8180_set_anaparam(priv, RTL8225SE_ANAPARAM_OFF);
> +	rtl8180_set_anaparam2(priv, RTL8225SE_ANAPARAM2_OFF);
> +}
> +
> +void rtl8225se_rf_set_channel(struct ieee80211_hw *dev,
> +				   struct ieee80211_conf *conf)
> +{
> +
> +	int chan =
> +		ieee80211_frequency_to_channel(conf->chandef.chan->center_freq);
> +
> +
> +	rtl8225sez2_rf_set_tx_power(dev, chan);
> +	rtl8187se_rf_writereg(dev, 0x7, rtl8225se_chan[chan - 1]);
> +	if ((rtl8187se_rf_readreg(dev, 0x7) & 0x0F80) != rtl8225se_chan[chan - 1])
> +		rtl8187se_rf_writereg(dev, 0x7, rtl8225se_chan[chan - 1]);
> +	msleep(1);
> +
> +	msleep(10);
> +}
> +
> +
> +static const struct rtl818x_rf_ops rtl8225se_ops = {
> +	.name		= "rtl8225-se",
> +	.init		= rtl8225se_rf_init,
> +	.stop		= rtl8225se_rf_stop,
> +	.set_chan	= rtl8225se_rf_set_channel,
> +};
> +
> +const struct rtl818x_rf_ops *rtl8187se_detect_rf(struct ieee80211_hw *dev)
> +{
> +	return &rtl8225se_ops;
> +}
> diff --git a/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h b/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h
> new file mode 100644
> index 0000000..a1f92bc
> --- /dev/null
> +++ b/drivers/net/wireless/rtl818x/rtl8180/rtl8225se.h
> @@ -0,0 +1,64 @@
> +/*
> + * Definitions for RTL8187SE hardware
> + *
> + * Copyright 2009 Larry Finger <Larry.Finger@lwfinger.net>
> + * Copyright 2014 Andrea Merello <andrea.merello@gmail.com>
> + *
> + * Based on the r8180 and Realtek r8187se drivers, which are:
> + * Copyright 2004-2005 Andrea Merello <andrea.merello@gmail.com>, et al.
> + *
> + * Also based on the rtl8187 driver, which is:
> + * Copyright 2007 Michael Wu <flamingice@sourmilk.net>
> + * Copyright 2007 Andrea Merello <andreamrl@tiscali.it>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#ifndef RTL8187SE_RTL8225_H
> +#define RTL8187SE_RTL8225_H
> +
> +#define RTL8225SE_ANAPARAM_ON	0xb0054d00
> +#define RTL8225SE_ANAPARAM2_ON	0x000004c6
> +
> +/* all off except PLL */
> +#define RTL8225SE_ANAPARAM_OFF	0xb0054dec
> +/* all on including PLL */
> +#define RTL8225SE_ANAPARAM_OFF2	0xb0054dfc
> +
> +#define RTL8225SE_ANAPARAM2_OFF	0x00ff04c6
> +
> +#define RTL8225SE_ANAPARAM3 	0x10
> +
> +enum rtl8187se_power_state {
> +	RTL8187SE_POWER_ON,
> +	RTL8187SE_POWER_OFF,
> +	RTL8187SE_POWER_SLEEP
> +};
> +
> +
> +static inline void rtl8225se_write_phy_ofdm(struct ieee80211_hw *dev,
> +					  u8 addr, u8 data)
> +{
> +	rtl8180_write_phy(dev, addr, data);
> +}
> +
> +static inline void rtl8225se_write_phy_cck(struct ieee80211_hw *dev,
> +					 u8 addr, u8 data)
> +{
> +	rtl8180_write_phy(dev, addr, data | 0x10000);
> +}
> +
> +
> +const struct rtl818x_rf_ops *rtl8187se_detect_rf(struct ieee80211_hw *);
> +void rtl8225se_rf_stop(struct ieee80211_hw *dev);
> +void rtl8225se_rf_set_channel(struct ieee80211_hw *dev,
> +				     struct ieee80211_conf *conf);
> +void rtl8225se_rf_conf_erp(struct ieee80211_hw *dev,
> +				  struct ieee80211_bss_conf *info);
> +void rtl8225se_rf_init(struct ieee80211_hw *dev);
> +
> +
> +#endif /* RTL8187SE_RTL8225_H */
> +
> diff --git a/drivers/net/wireless/rtl818x/rtl818x.h b/drivers/net/wireless/rtl818x/rtl818x.h
> index ce23dfd..69a0edf 100644
> --- a/drivers/net/wireless/rtl818x/rtl818x.h
> +++ b/drivers/net/wireless/rtl818x/rtl818x.h
> @@ -15,31 +15,91 @@
>  #ifndef RTL818X_H
>  #define RTL818X_H
>  
> +
>  struct rtl818x_csr {
> -	u8	MAC[6];
> +
> +	union {
> +		u8	MAC[6];
> +		u8	offset1[6];     /* upper page indexing helpers */
> +		__le16	offset2[1];
> +		__le32	offset4[1];
> +	} __attribute__((__packed__));
> +
> +
>  	u8	reserved_0[2];
> -	__le32	MAR[2];
> -	u8	RX_FIFO_COUNT;
> -	u8	reserved_1;
> -	u8	TX_FIFO_COUNT;
> -	u8	BQREQ;
> -	u8	reserved_2[4];
> +
> +	union {
> +		__le32	MAR[2];  /* 0x8 */
> +
> +		struct{ /* rtl8187se */
> +			u8 rf_sw_config; /* 0x8 */
> +			u8 reserved_01[3];
> +			__le32 TMGDA; /* 0xc */
> +		} __attribute__((__packed__));
> +	} __attribute__((__packed__));
> +
> +	union { /*  0x10  */
> +		struct {
> +			u8	RX_FIFO_COUNT;
> +			u8	reserved_1;
> +			u8	TX_FIFO_COUNT;
> +			u8	BQREQ;
> +		} __attribute__((__packed__));
> +
> +		__le32 TBKDA; /* for 8187se */
> +	} __attribute__((__packed__));
> +
> +	__le32 TBEDA; /* 0x14 - for rtl8187se */
> +
>  	__le32	TSFT[2];
> -	__le32	TLPDA;
> -	__le32	TNPDA;
> -	__le32	THPDA;
> -	__le16	BRSR;
> -	u8	BSSID[6];
> -	u8	RESP_RATE;
> -	u8	EIFS;
> -	u8	reserved_3[1];
> -	u8	CMD;
> +
> +	union { /* 0x20 */
> +		__le32	TLPDA;
> +		__le32  TVIDA; /* for 8187se */
> +	} __attribute__((__packed__));
> +
> +	union { /* 0x24 */
> +		__le32	TNPDA;
> +		__le32  TVODA; /* for 8187se */
> +	} __attribute__((__packed__));
> +
> +	/* hi pri ring for all cards */
> +	__le32	THPDA; /* 0x28 */
> +
> +	union { /* 0x2c */
> +		struct {
> +			u8 reserved_2a;
> +			u8 EIFS_8187SE;
> +		} __attribute__((__packed__));
> +
> +		__le16	BRSR;
> +	} __attribute__((__packed__));
> +
> +	u8	BSSID[6]; /* 0x2e */
> +
> +	union { /* 0x34 */
> +		struct {
> +			u8 RESP_RATE;
> +			u8 EIFS;
> +		} __attribute__((__packed__));
> +		__le16 BRSR_8187SE;
> +	} __attribute__((__packed__));
> +
> +	u8	reserved_3[1]; /* 0x36 */
> +	u8	CMD; /* 0x37 */
>  #define RTL818X_CMD_TX_ENABLE		(1 << 2)
>  #define RTL818X_CMD_RX_ENABLE		(1 << 3)
>  #define RTL818X_CMD_RESET		(1 << 4)
> -	u8	reserved_4[4];
> -	__le16	INT_MASK;
> -	__le16	INT_STATUS;
> +	u8	reserved_4[4]; /* 0x38 */
> +	union {
> +		struct {
> +			__le16	INT_MASK;
> +			__le16	INT_STATUS;
> +		} __attribute__ ((__packed__));
> +
> +		__le32	INT_STATUS_SE; /* 0x3c */
> +	} __attribute__ ((__packed__));
> +/* status bits for rtl8187 and rtl8180/8185 */
>  #define RTL818X_INT_RX_OK		(1 <<  0)
>  #define RTL818X_INT_RX_ERR		(1 <<  1)
>  #define RTL818X_INT_TXL_OK		(1 <<  2)
> @@ -56,7 +116,34 @@ struct rtl818x_csr {
>  #define RTL818X_INT_BEACON		(1 << 13)
>  #define RTL818X_INT_TIME_OUT		(1 << 14)
>  #define RTL818X_INT_TX_FO		(1 << 15)
> -	__le32	TX_CONF;
> +/* status bits for rtl8187se */
> +#define RTL818X_INT_SE_TIMER3		(1 <<  0)
> +#define RTL818X_INT_SE_TIMER2		(1 <<  1)
> +#define RTL818X_INT_SE_RQ0SOR		(1 <<  2)
> +#define RTL818X_INT_SE_TXBED_OK		(1 <<  3)
> +#define RTL818X_INT_SE_TXBED_ERR	(1 <<  4)
> +#define RTL818X_INT_SE_TXBE_OK		(1 <<  5)
> +#define RTL818X_INT_SE_TXBE_ERR		(1 <<  6)
> +#define RTL818X_INT_SE_RX_OK		(1 <<  7)
> +#define RTL818X_INT_SE_RX_ERR		(1 <<  8)
> +#define RTL818X_INT_SE_TXL_OK		(1 <<  9)
> +#define RTL818X_INT_SE_TXL_ERR		(1 << 10)
> +#define RTL818X_INT_SE_RX_DU		(1 << 11)
> +#define RTL818X_INT_SE_RX_FIFO		(1 << 12)
> +#define RTL818X_INT_SE_TXN_OK		(1 << 13)
> +#define RTL818X_INT_SE_TXN_ERR		(1 << 14)
> +#define RTL818X_INT_SE_TXH_OK		(1 << 15)
> +#define RTL818X_INT_SE_TXH_ERR		(1 << 16)
> +#define RTL818X_INT_SE_TXB_OK		(1 << 17)
> +#define RTL818X_INT_SE_TXB_ERR		(1 << 18)
> +#define RTL818X_INT_SE_ATIM_TO		(1 << 19)
> +#define RTL818X_INT_SE_BK_TO		(1 << 20)
> +#define RTL818X_INT_SE_TIMER1		(1 << 21)
> +#define RTL818X_INT_SE_TX_FIFO		(1 << 22)
> +#define RTL818X_INT_SE_WAKEUP		(1 << 23)
> +#define RTL818X_INT_SE_BK_DMA		(1 << 24)
> +#define RTL818X_INT_SE_TMGD_OK		(1 << 30)
> +	__le32	TX_CONF; /* 0x40 */
>  #define RTL818X_TX_CONF_LOOPBACK_MAC	(1 << 17)
>  #define RTL818X_TX_CONF_LOOPBACK_CONT	(3 << 17)
>  #define RTL818X_TX_CONF_NO_ICV		(1 << 19)
> @@ -68,17 +155,21 @@ struct rtl818x_csr {
>  #define RTL818X_TX_CONF_R8185_D		(5 << 25)
>  #define RTL818X_TX_CONF_R8187vD		(5 << 25)
>  #define RTL818X_TX_CONF_R8187vD_B	(6 << 25)
> +#define RTL818X_TX_CONF_RTL8187SE	(6 << 25)
>  #define RTL818X_TX_CONF_HWVER_MASK	(7 << 25)
>  #define RTL818X_TX_CONF_DISREQQSIZE	(1 << 28)
>  #define RTL818X_TX_CONF_PROBE_DTS	(1 << 29)
> -#define RTL818X_TX_CONF_HW_SEQNUM	(1 << 30)
> +#define RTL818X_TX_CONF_SW_SEQNUM	(1 << 30)
>  #define RTL818X_TX_CONF_CW_MIN		(1 << 31)
> -	__le32	RX_CONF;
> +	__le32	RX_CONF; /* 0x44 */
>  #define RTL818X_RX_CONF_MONITOR		(1 <<  0)
>  #define RTL818X_RX_CONF_NICMAC		(1 <<  1)
>  #define RTL818X_RX_CONF_MULTICAST	(1 <<  2)
>  #define RTL818X_RX_CONF_BROADCAST	(1 <<  3)
>  #define RTL818X_RX_CONF_FCS		(1 <<  5)
> +#define RTL818X_RX_CONF_9356SEL		(1 <<  6)
> +#define RTL818X_RX_CONF_MAXDMA		(7 <<  8)
> +#define RTL818X_RX_CONF_FIFO		(7 << 13)
>  #define RTL818X_RX_CONF_DATA		(1 << 18)
>  #define RTL818X_RX_CONF_CTRL		(1 << 19)
>  #define RTL818X_RX_CONF_MGMT		(1 << 20)
> @@ -89,9 +180,9 @@ struct rtl818x_csr {
>  #define RTL818X_RX_CONF_CSDM1		(1 << 29)
>  #define RTL818X_RX_CONF_CSDM2		(1 << 30)
>  #define RTL818X_RX_CONF_ONLYERLPKT	(1 << 31)
> -	__le32	INT_TIMEOUT;
> -	__le32	TBDA;
> -	u8	EEPROM_CMD;
> +	__le32	INT_TIMEOUT; /* 0x48 */
> +	__le32	TBDA; /* 0x4c */
> +	u8	EEPROM_CMD; /* 0x50 */
>  #define RTL818X_EEPROM_CMD_READ		(1 << 0)
>  #define RTL818X_EEPROM_CMD_WRITE	(1 << 1)
>  #define RTL818X_EEPROM_CMD_CK		(1 << 2)
> @@ -100,74 +191,113 @@ struct rtl818x_csr {
>  #define RTL818X_EEPROM_CMD_LOAD		(1 << 6)
>  #define RTL818X_EEPROM_CMD_PROGRAM	(2 << 6)
>  #define RTL818X_EEPROM_CMD_CONFIG	(3 << 6)
> -	u8	CONFIG0;
> -	u8	CONFIG1;
> -	u8	CONFIG2;
> +	u8	CONFIG0; /* 0x51 */
> +	u8	CONFIG1; /* 0x52 */
> +	u8	CONFIG2; /* 0x53 */
>  #define RTL818X_CONFIG2_ANTENNA_DIV	(1 << 6)
> -	__le32	ANAPARAM;
> -	u8	MSR;
> +	__le32	ANAPARAM; /* 0x54 */
> +	u8	MSR; /* 0x58 */
>  #define RTL818X_MSR_NO_LINK		(0 << 2)
>  #define RTL818X_MSR_ADHOC		(1 << 2)
>  #define RTL818X_MSR_INFRA		(2 << 2)
>  #define RTL818X_MSR_MASTER		(3 << 2)
>  #define RTL818X_MSR_ENEDCA		(4 << 2)
> -	u8	CONFIG3;
> +	u8	CONFIG3; /* 0x59 */
>  #define RTL818X_CONFIG3_ANAPARAM_WRITE	(1 << 6)
>  #define RTL818X_CONFIG3_GNT_SELECT	(1 << 7)
> -	u8	CONFIG4;
> +	u8	CONFIG4; /* 0x5A */
>  #define RTL818X_CONFIG4_POWEROFF	(1 << 6)
>  #define RTL818X_CONFIG4_VCOOFF		(1 << 7)
> -	u8	TESTR;
> -	u8	reserved_9[2];
> -	u8	PGSELECT;
> -	u8	SECURITY;
> -	__le32	ANAPARAM2;
> -	u8	reserved_10[12];
> -	__le16	BEACON_INTERVAL;
> -	__le16	ATIM_WND;
> -	__le16	BEACON_INTERVAL_TIME;
> -	__le16	ATIMTR_INTERVAL;
> -	u8	PHY_DELAY;
> -	u8	CARRIER_SENSE_COUNTER;
> -	u8	reserved_11[2];
> -	u8	PHY[4];
> -	__le16	RFPinsOutput;
> -	__le16	RFPinsEnable;
> -	__le16	RFPinsSelect;
> -	__le16	RFPinsInput;
> -	__le32	RF_PARA;
> -	__le32	RF_TIMING;
> -	u8	GP_ENABLE;
> -	u8	GPIO0;
> -	u8	GPIO1;
> -	u8	reserved_12;
> -	__le32	HSSI_PARA;
> -	u8	reserved_13[4];
> -	u8	TX_AGC_CTL;
> -#define RTL818X_TX_AGC_CTL_PERPACKET_GAIN_SHIFT		(1 << 0)
> -#define RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL_SHIFT	(1 << 1)
> -#define RTL818X_TX_AGC_CTL_FEEDBACK_ANT			(1 << 2)
> -	u8	TX_GAIN_CCK;
> -	u8	TX_GAIN_OFDM;
> -	u8	TX_ANTENNA;
> -	u8	reserved_14[16];
> -	u8	WPA_CONF;
> -	u8	reserved_15[3];
> -	u8	SIFS;
> -	u8	DIFS;
> -	u8	SLOT;
> +	u8	TESTR; /* 0x5b */
> +	u8	reserved_9[2]; /* 0x5c */
> +	u8	PGSELECT; /* 0x5e */
> +	u8	SECURITY; /* 0x5f */
> +	__le32	ANAPARAM2; /* 0x60 */
> +	u8	reserved_10[8]; /* 0x64 */
> +	__le32  IMR;		/* 0x6c	- Interrupt mask reg for 8187se */
> +#define IMR_TMGDOK      ((1 << 30))
> +#define IMR_DOT11HINT	((1 << 25))	/* 802.11h Measurement Interrupt */
> +#define IMR_BCNDMAINT	((1 << 24))	/* Beacon DMA Interrupt */
> +#define IMR_WAKEINT	((1 << 23))	/* Wake Up Interrupt */
> +#define IMR_TXFOVW	((1 << 22))	/* Tx FIFO Overflow */
> +#define IMR_TIMEOUT1	((1 << 21))	/* Time Out Interrupt 1 */
> +#define IMR_BCNINT	((1 << 20))	/* Beacon Time out */
> +#define IMR_ATIMINT	((1 << 19))	/* ATIM Time Out */
> +#define IMR_TBDER	((1 << 18))	/* Tx Beacon Descriptor Error */
> +#define IMR_TBDOK	((1 << 17))	/* Tx Beacon Descriptor OK */
> +#define IMR_THPDER	((1 << 16))	/* Tx High Priority Descriptor Error */
> +#define IMR_THPDOK	((1 << 15))	/* Tx High Priority Descriptor OK */
> +#define IMR_TVODER	((1 << 14))	/* Tx AC_VO Descriptor Error Int */
> +#define IMR_TVODOK	((1 << 13))	/* Tx AC_VO Descriptor OK Interrupt */
> +#define IMR_FOVW	((1 << 12))	/* Rx FIFO Overflow Interrupt */
> +#define IMR_RDU		((1 << 11))	/* Rx Descriptor Unavailable */
> +#define IMR_TVIDER	((1 << 10))	/* Tx AC_VI Descriptor Error */
> +#define IMR_TVIDOK	((1 << 9))	/* Tx AC_VI Descriptor OK Interrupt */
> +#define IMR_RER		((1 << 8))	/* Rx Error Interrupt */
> +#define IMR_ROK		((1 << 7))	/* Receive OK Interrupt */
> +#define IMR_TBEDER	((1 << 6))	/* Tx AC_BE Descriptor Error */
> +#define IMR_TBEDOK	((1 << 5))	/* Tx AC_BE Descriptor OK */
> +#define IMR_TBKDER	((1 << 4))	/* Tx AC_BK Descriptor Error */
> +#define IMR_TBKDOK	((1 << 3))	/* Tx AC_BK Descriptor OK */
> +#define IMR_RQOSOK	((1 << 2))	/* Rx QoS OK Interrupt */
> +#define IMR_TIMEOUT2	((1 << 1))	/* Time Out Interrupt 2 */
> +#define IMR_TIMEOUT3	((1 << 0))	/* Time Out Interrupt 3 */
> +	__le16	BEACON_INTERVAL; /* 0x70 */
> +	__le16	ATIM_WND; /*  0x72 */
> +	__le16	BEACON_INTERVAL_TIME; /*  0x74 */
> +	__le16	ATIMTR_INTERVAL; /*  0x76 */
> +	u8	PHY_DELAY; /*  0x78 */
> +	u8	CARRIER_SENSE_COUNTER; /* 0x79 */
> +	u8	reserved_11[2]; /* 0x7a */
> +	u8	PHY[4]; /* 0x7c  */
> +	__le16	RFPinsOutput; /* 0x80 */
> +	__le16	RFPinsEnable; /* 0x82 */
> +	__le16	RFPinsSelect; /* 0x84 */
> +	__le16	RFPinsInput;  /* 0x86 */
> +	__le32	RF_PARA; /*  0x88 */
> +	__le32	RF_TIMING; /*  0x8c */
> +	u8	GP_ENABLE; /*  0x90 */
> +	u8	GPIO0; /*  0x91 */
> +	u8	GPIO1; /*  0x92 */
> +	u8	TPPOLL_STOP; /*  0x93 - rtl8187se only */
> +#define RTL818x_TPPOLL_STOP_BQ			(1 << 7)
> +#define RTL818x_TPPOLL_STOP_VI			(1 << 4)
> +#define RTL818x_TPPOLL_STOP_VO			(1 << 5)
> +#define RTL818x_TPPOLL_STOP_BE			(1 << 3)
> +#define RTL818x_TPPOLL_STOP_BK			(1 << 2)
> +#define RTL818x_TPPOLL_STOP_MG			(1 << 1)
> +#define RTL818x_TPPOLL_STOP_HI			(1 << 6)
> +
> +	__le32	HSSI_PARA; /*  0x94 */
> +	u8	reserved_13[4]; /* 0x98 */
> +	u8	TX_AGC_CTL; /*  0x9c */
> +#define RTL818X_TX_AGC_CTL_PERPACKET_GAIN	(1 << 0)
> +#define RTL818X_TX_AGC_CTL_PERPACKET_ANTSEL	(1 << 1)
> +#define RTL818X_TX_AGC_CTL_FEEDBACK_ANT		(1 << 2)
> +	u8	TX_GAIN_CCK; /* 0x9d */
> +	u8	TX_GAIN_OFDM; /* 0x9e */
> +	u8	TX_ANTENNA; /*  0x9f */
> +	u8	reserved_14[16]; /*  0xa0 */
> +	u8	WPA_CONF; /*  0xb0 */
> +	u8	reserved_15[3]; /*  0xb1 */
> +	u8	SIFS; /* 0xb4 */
> +	u8	DIFS; /* 0xb5 */
> +	u8	SLOT; /*  0xb6 */
>  	u8	reserved_16[5];
>  	u8	CW_CONF;
> -#define RTL818X_CW_CONF_PERPACKET_CW_SHIFT	(1 << 0)
> -#define RTL818X_CW_CONF_PERPACKET_RETRY_SHIFT	(1 << 1)
> +#define RTL818X_CW_CONF_PERPACKET_CW	(1 << 0)
> +#define RTL818X_CW_CONF_PERPACKET_RETRY	(1 << 1)
>  	u8	CW_VAL;
>  	u8	RATE_FALLBACK;
>  #define RTL818X_RATE_FALLBACK_ENABLE	(1 << 7)
> +#define RTL818X_RATE_FALLBACK_AUTO_STEP1	0x01
> +
>  	u8	ACM_CONTROL;
>  	u8	reserved_17[24];
> -	u8	CONFIG5;
> -	u8	TX_DMA_POLLING;
> -	u8	reserved_18[2];
> +	u8	CONFIG5; /*  0xd8 */
> +	u8	TX_DMA_POLLING; /*  0xd9 */
> +	u8	PHY_PR;
> +	u8	reserved_18;
>  	__le16	CWR;
>  	u8	RETRY_CTR;
>  	u8	reserved_19[3];
> @@ -176,23 +306,69 @@ struct rtl818x_csr {
>  #define RTL818X_R8187B_B	0
>  #define RTL818X_R8187B_D	1
>  #define RTL818X_R8187B_E	2
> -	__le32	RDSAR;
> -	__le16	TID_AC_MAP;
> +	__le32	RDSAR; /* 0xe4 */
> +	__le16	TID_AC_MAP; /* 0xe8 */
>  	u8	reserved_20[4];
> -	u8	ANAPARAM3;
> -	u8	reserved_21[5];
> -	__le16	FEMR;
> -	u8	reserved_22[4];
> -	__le16	TALLY_CNT;
> -	u8	TALLY_SEL;
> -} __packed;
> +	__le16	ANAPARAM3; /* 0xee */
> +
> +#define AC_PARAM_TXOP_LIMIT_SHIFT	16
> +#define AC_PARAM_ECW_MAX_SHIFT		12
> +#define AC_PARAM_ECW_MIN_SHIFT		8
> +#define AC_PARAM_AIFS_SHIFT		0
> +
> +	__le32 AC_VO_PARAM; /* 0xf0 */
> +
> +	union { /* 0xf4 */
> +		__le32 AC_VI_PARAM;
> +		__le32 FEMR;
> +	} __attribute__ ((__packed__));
> +
> +	union{ /* 0xf8 */
> +		__le32  AC_BE_PARAM; /* rtl8187se */
> +		struct{
> +			u8      reserved_21[2];
> +			__le16	TALLY_CNT; /* 0xfa */
> +		} __attribute__ ((__packed__));
> +	} __attribute__ ((__packed__));
> +
> +	union {
> +		u8	TALLY_SEL; /* 0xfc */
> +		__le32  AC_BK_PARAM;
> +
> +	} __attribute__ ((__packed__));
> +
> +} __attribute__ ((__packed__));
> +
> +
> +/* These are addresses with NON-standard usage.
> + * They have offsets very far from this struct.
> + * I don't like to introduce a ton of "reserved"..
> + * They are for RTL8187SE
> + */
> +
> +#define REG_ADDR1(addr)	((u8 __iomem *)(&priv->map->offset1[(addr)]))
> +#define REG_ADDR2(addr)	((__le16 __iomem *)(&priv->map->offset2[((addr) >> 1)]))
> +#define REG_ADDR4(addr)	((__le32 __iomem *)(&priv->map->offset4[((addr) >> 2)]))
> +
> +
> +#define FEMR_SE		REG_ADDR2(0x1D4)
> +#define ARFR		REG_ADDR2(0x1E0)
> +#define RFSW_CTRL	REG_ADDR2(0x272)
> +#define SW_3W_DB0	REG_ADDR2(0x274)
> +#define SW_3W_DB0_4	REG_ADDR4(0x274)
> +#define SW_3W_DB1	REG_ADDR2(0x278)
> +#define SW_3W_DB1_4	REG_ADDR4(0x278)
> +#define SW_3W_CMD1	REG_ADDR1(0x27D)
> +#define PI_DATA_REG	REG_ADDR2(0x360)
> +#define SI_DATA_REG     REG_ADDR2(0x362)
> +
> +
>  
>  struct rtl818x_rf_ops {
>  	char *name;
>  	void (*init)(struct ieee80211_hw *);
>  	void (*stop)(struct ieee80211_hw *);
>  	void (*set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
> -	void (*conf_erp)(struct ieee80211_hw *, struct ieee80211_bss_conf *);
>  	u8 (*calc_rssi)(u8 agc, u8 sq);
>  };
>  

