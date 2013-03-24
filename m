Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3CXTEM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 15:04:12 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:49625 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab3CXTEK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 15:04:10 -0400
From: Florian Fainelli <florian@openwrt.org>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/5] net: Add EMAC ethernet driver found on Allwinner A10 SoC's
Date: Sun, 24 Mar 2013 20:03:52 +0100
User-Agent: KMail/1.13.7 (Linux/3.7-trunk-amd64; KDE/4.8.4; x86_64; ; )
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-doc@vger.kernel.org, Alejandro Mery <amery@geeks.cl>,
        netdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Landley <rob@landley.net>, sunny@allwinnertech.com,
        shuge@allwinnertech.com, Stefan Roese <sr@denx.de>,
        kevin@allwinnertech.com
References: <1364077814-2233-1-git-send-email-maxime.ripard@free-electrons.com> <1364077814-2233-2-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1364077814-2233-2-git-send-email-maxime.ripard@free-electrons.com>
Organization: OpenWrt
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201303242003.52827.florian@openwrt.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Your phylib implementation looks good now, just some minor comments below:

Le samedi 23 mars 2013 23:30:10, Maxime Ripard a écrit :
> From: Stefan Roese <sr@denx.de>
> 
> The Allwinner A10 has an ethernet controller that seem to be developped
> internally by them.
> 
> The exact feature set of this controller is unknown, since there is no
> public documentation for this IP, and this driver is mostly the one
> published by Allwinner that has been heavily cleaned up.
> 
> Signed-off-by: Stefan Roese <sr@denx.de>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  .../bindings/net/allwinner,sun4i-emac.txt          |   19 +
>  drivers/net/ethernet/Kconfig                       |    1 +
>  drivers/net/ethernet/Makefile                      |    1 +
>  drivers/net/ethernet/allwinner/Kconfig             |   36 +
>  drivers/net/ethernet/allwinner/Makefile            |    5 +
>  drivers/net/ethernet/allwinner/sun4i-emac.c        | 1033
> ++++++++++++++++++++ drivers/net/ethernet/allwinner/sun4i-emac.h        | 
> 114 +++
>  7 files changed, 1209 insertions(+)
>  create mode 100644
> Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt create mode
> 100644 drivers/net/ethernet/allwinner/Kconfig
>  create mode 100644 drivers/net/ethernet/allwinner/Makefile
>  create mode 100644 drivers/net/ethernet/allwinner/sun4i-emac.c
>  create mode 100644 drivers/net/ethernet/allwinner/sun4i-emac.h
> 
> diff --git a/Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt
> b/Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt new file
> mode 100644
> index 0000000..aaf5013
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/allwinner,sun4i-emac.txt
> @@ -0,0 +1,19 @@
> +* Allwinner EMAC ethernet controller
> +
> +Required properties:
> +- compatible: should be "allwinner,sun4i-emac".
> +- reg: address and length of the register set for the device.
> +- interrupts: interrupt for the device
> +
> +Optional properties:
> +- phy-supply: phandle to a regulator if the PHY needs one
> +- (local-)mac-address: mac address to be used by this driver
> +
> +Example:
> +
> +emac: ethernet@01c0b000 {
> +       compatible = "allwinner,sun4i-emac";
> +       reg = <0x01c0b000 0x1000>;
> +       phy-supply = <&reg_emac_3v3>;
> +       interrupts = <55>;

Also include a standard PHY device tree binding and use the device tree 
helpers to find and connect to your PHY device.
[snip]

> +if NET_VENDOR_ALLWINNER
> +
> +config SUN4I_EMAC
> +        tristate "Allwinner A10 EMAC support"
> +	depends on ARCH_SUNXI
> +	depends on OF
> +	select CRC32
> +	select NET_CORE
> +	select MII

You should select PHYLIB now that you implement it.
[snip]

> +static int emac_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
> +{
> +	struct emac_board_info *db = bus->priv;
> +	int value;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, db->membase + EMAC_MAC_MADR_REG);
> +	/* pull up the phy io line */
> +	writel(0x1, db->membase + EMAC_MAC_MCMD_REG);
> +
> +	/* Wait read complete */
> +	while (readl(db->membase + EMAC_MAC_MIND_REG) & 0x1)
> +		cpu_relax();

This needs proper timeout handling.

> +
> +	/* push down the phy io line */
> +	writel(0x0, db->membase + EMAC_MAC_MCMD_REG);
> +	/* and read data */
> +	value = readl(db->membase + EMAC_MAC_MRDD_REG);
> +
> +	return value;
> +}
> +
> +static int emac_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
> +			    u16 value)
> +{
> +	struct emac_board_info *db = bus->priv;
> +
> +	/* issue the phy address and reg */
> +	writel((mii_id << 8) | regnum, db->membase + EMAC_MAC_MADR_REG);
> +	/* pull up the phy io line */
> +	writel(0x1, db->membase + EMAC_MAC_MCMD_REG);
> +
> +	/* Wait read complete */
> +	while (readl(db->membase + EMAC_MAC_MIND_REG) & 0x1)
> +		cpu_relax();

Same here.
[snip]

> +static void emac_init_emac(struct net_device *dev);
> +static void emac_handle_link_change(struct net_device *dev)
> +{
> +	struct emac_board_info *db = netdev_priv(dev);
> +	struct phy_device *phydev = db->phy_dev;
> +	unsigned long flags;
> +	int status_change = 0;
> +
> +	spin_lock_irqsave(&db->lock, flags);

a phylib adjust_link callback is already called with a mutex hold, so your 
spinlock could be moved down to emac_init_emac() where the RMW sequence is 
performed.

> +
> +	if (phydev->link) {
> +		if ((db->speed != phydev->speed) ||
> +		    (db->duplex != phydev->duplex)) {
> +			/* Re-init EMAC with new settings */
> +			emac_init_emac(dev);

emac_init_emac() (the name could be change BTW) is not just changing the 
duplex setting of the MAC but also touches the transmitter/receiver enable 
bits, is that what you want as well?

[snip]

> +static int emac_mii_probe(struct net_device *dev)
> +{
> +	struct emac_board_info *db = netdev_priv(dev);
> +	struct phy_device *phydev;
> +	int ret;
> +
> +	phydev = phy_find_first(db->mii_bus);
> +	if (!phydev) {
> +		netdev_err(dev, "no PHY found\n");
> +		return -1;
> +	}
> +
> +	/* to-do: PHY interrupts are currently not supported */
> +
> +	/* attach the mac to the phy */
> +	ret = phy_connect_direct(dev, phydev, &emac_handle_link_change,
> +				 db->phy_interface);
> +	if (ret) {
> +		netdev_err(dev, "Could not attach to PHY\n");
> +		return ret;
> +	}

You could use of_phy_connect() here to eliminate some boilerplate code.

[snip]

> +unsigned int emac_powerup(struct net_device *ndev)
> +{
> +	struct emac_board_info *db = netdev_priv(ndev);
> +	unsigned int reg_val;
> +
> +	/* initial EMAC */
> +	/* flush RX FIFO */
> +	reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> +	reg_val |= 0x8;
> +	writel(reg_val, db->membase + EMAC_RX_CTL_REG);
> +	udelay(1);
> +
> +	/* initial MAC */
> +	/* soft reset MAC */
> +	reg_val = readl(db->membase + EMAC_MAC_CTL0_REG);
> +	reg_val &= ~EMAC_MAC_CTL0_SOFT_RESET;
> +	writel(reg_val, db->membase + EMAC_MAC_CTL0_REG);
> +
> +	/* set MII clock */
> +	reg_val = readl(db->membase + EMAC_MAC_MCFG_REG);
> +	reg_val &= (~(0xf << 2));
> +	reg_val |= (0xD << 2);
> +	writel(reg_val, db->membase + EMAC_MAC_MCFG_REG);
> +
> +	/* clear RX counter */
> +	writel(0x0, db->membase + EMAC_RX_FBC_REG);
> +
> +	/* disable all interrupt and clear interrupt status */
> +	writel(0, db->membase + EMAC_INT_CTL_REG);
> +	reg_val = readl(db->membase + EMAC_INT_STA_REG);
> +	writel(reg_val, db->membase + EMAC_INT_STA_REG);
> +
> +	udelay(1);
> +
> +	/* set up EMAC */
> +	emac_setup(ndev);
> +
> +	/* set mac_address to chip */
> +	writel(ndev->dev_addr[0] << 16 | ndev->dev_addr[1] << 8 | ndev->
> +	       dev_addr[2], db->membase + EMAC_MAC_A1_REG);
> +	writel(ndev->dev_addr[3] << 16 | ndev->dev_addr[4] << 8 | ndev->
> +	       dev_addr[5], db->membase + EMAC_MAC_A0_REG);
> +
> +	mdelay(1);
> +
> +	return 1;

Either return 0 to be consistent, or do not return anything
[snip]

> +static int emac_start_xmit(struct sk_buff *skb, struct net_device *dev)
> +{
> +	struct emac_board_info *db = netdev_priv(dev);
> +	unsigned long channel;
> +	unsigned long flags;
> +
> +	channel = db->tx_fifo_stat & 3;
> +	if (channel == 3)
> +		return NETDEV_TX_BUSY;

NETDEV_TX_BUSY really is a hard condition, your initial submission had 
something like netif_stop_queue(dev) and return 1 and this was actually 
better.

[snip]

> +
> +/* Received a packet and pass to upper layer
> + */
> +static void emac_rx(struct net_device *dev)
> +{
> +	struct emac_board_info *db = netdev_priv(dev);
> +	struct sk_buff *skb;
> +	u8 *rdptr;
> +	bool good_packet;
> +	static int rxlen_last;
> +	unsigned int reg_val;
> +	u32 rxhdr, rxstatus, rxcount, rxlen;
> +
> +	/* Check packet ready or not */
> +	while (1) {
> +		/* race warning: the first packet might arrive with
> +		 * the interrupts disabled, but the second will fix
> +		 * it
> +		 */
> +		rxcount = readl(db->membase + EMAC_RX_FBC_REG);
> +
> +		if (netif_msg_rx_status(db))
> +			dev_dbg(db->dev, "RXCount: %x\n", rxcount);
> +
> +		if ((db->skb_last != NULL) && (rxlen_last > 0)) {
> +			dev->stats.rx_bytes += rxlen_last;
> +
> +			/* Pass to upper layer */
> +			db->skb_last->protocol = eth_type_trans(db->skb_last,
> +								dev);
> +			netif_rx(db->skb_last);
> +			dev->stats.rx_packets++;
> +			db->skb_last = NULL;
> +			rxlen_last = 0;
> +
> +			reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> +			reg_val &= ~EMAC_RX_CTL_DMA_EN;
> +			writel(reg_val, db->membase + EMAC_RX_CTL_REG);
> +		}
> +
> +		if (!rxcount) {
> +			db->emacrx_completed_flag = 1;
> +			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> +			reg_val |= (0xf << 0) | (0x01 << 8);
> +			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> +
> +			/* had one stuck? */
> +			rxcount = readl(db->membase + EMAC_RX_FBC_REG);
> +			if (!rxcount)
> +				return;
> +		}
> +
> +		reg_val = readl(db->membase + EMAC_RX_IO_DATA_REG);
> +		if (netif_msg_rx_status(db))
> +			dev_dbg(db->dev, "receive header: %x\n", reg_val);
> +		if (reg_val != EMAC_UNDOCUMENTED_MAGIC) {
> +			/* disable RX */
> +			reg_val = readl(db->membase + EMAC_CTL_REG);
> +			writel(reg_val & ~EMAC_CTL_RX_EN,
> +			       db->membase + EMAC_CTL_REG);
> +
> +			/* Flush RX FIFO */
> +			reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> +			writel(reg_val | (1 << 3),
> +			       db->membase + EMAC_RX_CTL_REG);
> +
> +			do {
> +				reg_val = readl(db->membase + EMAC_RX_CTL_REG);
> +			} while (reg_val & (1 << 3));
> +
> +			/* enable RX */
> +			reg_val = readl(db->membase + EMAC_CTL_REG);
> +			writel(reg_val | EMAC_CTL_RX_EN,
> +			       db->membase + EMAC_CTL_REG);
> +			reg_val = readl(db->membase + EMAC_INT_CTL_REG);
> +			reg_val |= (0xf << 0) | (0x01 << 8);
> +			writel(reg_val, db->membase + EMAC_INT_CTL_REG);
> +
> +			db->emacrx_completed_flag = 1;
> +
> +			return;
> +		}
> +
> +		/* A packet ready now  & Get status/length */
> +		good_packet = true;
> +
> +		emac_inblk_32bit(db->membase + EMAC_RX_IO_DATA_REG,
> +				&rxhdr, sizeof(rxhdr));
> +
> +		if (netif_msg_rx_status(db))
> +			dev_dbg(db->dev, "rxhdr: %x\n", *((int *)(&rxhdr)));
> +
> +		rxlen = EMAC_RX_IO_DATA_LEN(rxhdr);
> +		rxstatus = EMAC_RX_IO_DATA_STATUS(rxhdr);
> +
> +		if (netif_msg_rx_status(db))
> +			dev_dbg(db->dev, "RX: status %02x, length %04x\n",
> +				rxstatus, rxlen);
> +
> +		/* Packet Status check */
> +		if (rxlen < 0x40) {
> +			good_packet = false;
> +			if (netif_msg_rx_err(db))
> +				dev_dbg(db->dev, "RX: Bad Packet (runt)\n");
> +		}
> +
> +		if (unlikely(!(rxstatus & EMAC_RX_IO_DATA_STATUS_OK))) {
> +			good_packet = false;
> +
> +			if (rxstatus & EMAC_RX_IO_DATA_STATUS_CRC_ERR) {
> +				if (netif_msg_rx_err(db))
> +					dev_dbg(db->dev, "crc error\n");
> +				dev->stats.rx_crc_errors++;
> +			}
> +
> +			if (rxstatus & EMAC_RX_IO_DATA_STATUS_LEN_ERR) {
> +				if (netif_msg_rx_err(db))
> +					dev_dbg(db->dev, "length error\n");
> +				dev->stats.rx_length_errors++;
> +			}
> +		}
> +
> +		/* Move data from EMAC */
> +		skb = dev_alloc_skb(rxlen + 4);
> +		if (good_packet && skb) {
> +			skb_reserve(skb, 2);
> +			rdptr = (u8 *) skb_put(skb, rxlen - 4);
> +
> +			/* Read received packet from RX SRAM */
> +			if (netif_msg_rx_status(db))
> +				dev_dbg(db->dev, "RxLen %x\n", rxlen);
> +
> +			emac_inblk_32bit(db->membase + EMAC_RX_IO_DATA_REG,
> +					rdptr, rxlen);
> +			dev->stats.rx_bytes += rxlen;
> +
> +			/* Pass to upper layer */
> +			skb->protocol = eth_type_trans(skb, dev);
> +			netif_rx(skb);
> +			dev->stats.rx_packets++;
> +		}
> +	}
> +}
> +
> +static irqreturn_t emac_interrupt(int irq, void *dev_id)
> +{

You should implement NAPI, you do not have much to change to actually be able 
to do it.

> +	netif_stop_queue(ndev);
> +	netif_carrier_off(ndev);

phy_stop() is missing here.
-- 
Florian
