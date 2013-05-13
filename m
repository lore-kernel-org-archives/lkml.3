Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3EMQGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 12:06:09 -0400
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:58100 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753799Ab3EMQGH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 12:06:07 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
X-Ovh-Mailout: 178.32.228.5 (mo5.mail-out.ovh.net)
Subject: Re: [PATCH] net/macb: fix ISR clear-on-write behavior only for some SoC
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
In-Reply-To: <1368461105-23128-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 14 May 2013 00:05:56 +0800
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        <hein_tibosch@yahoo.es>, <michal.simek@xilinx.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        <s.trumtrar@pengutronix.de>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <FE065E51-1EAA-47ED-8C7B-0F2E6418F349@jcrosoft.com>
References: <1368461105-23128-1-git-send-email-nicolas.ferre@atmel.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
X-Mailer: Apple Mail (2.1503)
X-Ovh-Tracer-Id: 1101974534951840620
X-Ovh-Remote: 116.230.58.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeifedrjeeiucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 14, 2013, at 12:05 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> Commit 749a2b6 (net/macb: clear tx/rx completion flags in ISR)
> introduces clear-on-write on ISR register. This behavior is not always
> implemented when using Cadence MACB/GEM and is breaking other platforms.
> We are using a new Device Tree compatibility string and a capability
> property to actually activate this clear-on-write behavior on ISR.
> 
> Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

can we detect it via the IP?
> ---
> Documentation/devicetree/bindings/net/macb.txt |  2 ++
> drivers/net/ethernet/cadence/macb.c            | 15 +++++++++++++--
> drivers/net/ethernet/cadence/macb.h            |  5 +++++
> 3 files changed, 20 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/macb.txt b/Documentation/devicetree/bindings/net/macb.txt
> index 44afa0e..13ec4f6 100644
> --- a/Documentation/devicetree/bindings/net/macb.txt
> +++ b/Documentation/devicetree/bindings/net/macb.txt
> @@ -6,6 +6,8 @@ Required properties:
>   Use "cdns,at32ap7000-macb" for other 10/100 usage or use the generic form: "cdns,macb".
>   Use "cnds,pc302-gem" for Picochip picoXcell pc302 and later devices based on
>   the Cadence GEM, or the generic form: "cdns,gem".
> +  Use "cdns,zynq-7000-gem" for devices based on Cadence GEM with alternative
> +  options enabled (ISR clear on write).
> - reg: Address and length of the register set for the device
> - interrupts: Should contain macb interrupt
> - phy-mode: String, operation mode of the PHY interface.
> diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
> index 6be513d..628f2b0 100644
> --- a/drivers/net/ethernet/cadence/macb.c
> +++ b/drivers/net/ethernet/cadence/macb.c
> @@ -485,7 +485,8 @@ static void macb_tx_interrupt(struct macb *bp)
> 	status = macb_readl(bp, TSR);
> 	macb_writel(bp, TSR, status);
> 
> -	macb_writel(bp, ISR, MACB_BIT(TCOMP));
> +	if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> +		macb_writel(bp, ISR, MACB_BIT(TCOMP));
> 
> 	netdev_vdbg(bp->dev, "macb_tx_interrupt status = 0x%03lx\n",
> 		(unsigned long)status);
> @@ -738,7 +739,8 @@ static irqreturn_t macb_interrupt(int irq, void *dev_id)
> 			 * now.
> 			 */
> 			macb_writel(bp, IDR, MACB_RX_INT_FLAGS);
> -			macb_writel(bp, ISR, MACB_BIT(RCOMP));
> +			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
> +				macb_writel(bp, ISR, MACB_BIT(RCOMP));
> 
> 			if (napi_schedule_prep(&bp->napi)) {
> 				netdev_vdbg(bp->dev, "scheduling RX softirq\n");
> @@ -1474,6 +1476,10 @@ static const struct of_device_id macb_dt_ids[] = {
> 	{ .compatible = "cdns,macb" },
> 	{ .compatible = "cdns,pc302-gem" },
> 	{ .compatible = "cdns,gem" },
> +	{
> +		.compatible = "cdns,zynq-7000-gem",
> +		.data = (void *)MACB_CAPS_ISR_CLEAR_ON_WRITE,
> +	},
> 	{ /* sentinel */ }
> };
> MODULE_DEVICE_TABLE(of, macb_dt_ids);
> @@ -1484,6 +1490,7 @@ static int __init macb_probe(struct platform_device *pdev)
> 	struct macb_platform_data *pdata;
> 	struct resource *regs;
> 	struct net_device *dev;
> +	const struct of_device_id *dev_id;
> 	struct macb *bp;
> 	struct phy_device *phydev;
> 	u32 config;
> @@ -1558,6 +1565,10 @@ static int __init macb_probe(struct platform_device *pdev)
> 
> 	dev->base_addr = regs->start;
> 
> +	dev_id = of_match_device(macb_dt_ids, &pdev->dev);
> +	if (dev_id)
> +		bp->caps = (u32)dev_id->data;
> +
> 	/* Set MII management clock divider */
> 	config = macb_mdc_clk_div(bp);
> 	config |= macb_dbw(bp);
> diff --git a/drivers/net/ethernet/cadence/macb.h b/drivers/net/ethernet/cadence/macb.h
> index 993d703..5d622fe 100644
> --- a/drivers/net/ethernet/cadence/macb.h
> +++ b/drivers/net/ethernet/cadence/macb.h
> @@ -323,6 +323,9 @@
> #define MACB_MAN_READ				2
> #define MACB_MAN_CODE				2
> 
> +/* Capability mask bits */
> +#define MACB_CAPS_ISR_CLEAR_ON_WRITE		0x1
> +
> /* Bit manipulation macros */
> #define MACB_BIT(name)					\
> 	(1 << MACB_##name##_OFFSET)
> @@ -574,6 +577,8 @@ struct macb {
> 	unsigned int 		speed;
> 	unsigned int 		duplex;
> 
> +	u32			caps;
> +
> 	phy_interface_t		phy_interface;
> 
> 	/* AT91RM9200 transmit */
> -- 
> 1.8.0
> 

