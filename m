Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102Ab3GZQWm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 12:22:42 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:50310 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757043Ab3GZQWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 12:22:39 -0400
Date: Fri, 26 Jul 2013 17:22:31 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "ian.campbell@citrix.com" <ian.campbell@citrix.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH 4/5] sata, highbank: set tx_atten override bits
Message-ID: <20130726162231.GD3528@e106331-lin.cambridge.arm.com>
References: <1374851518-4802-1-git-send-email-mark.langsdorf@calxeda.com>
 <1374851518-4802-4-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374851518-4802-4-git-send-email-mark.langsdorf@calxeda.com>
Thread-Topic: [PATCH 4/5] sata, highbank: set tx_atten override bits
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 04:11:57PM +0100, Mark Langsdorf wrote:
> Some board designs do not drive the SATA transmit lines within the
> specification. The ECME can provide override settings, on a per board
> basis, to bring the transmit lines within spec. Read those settings
> from the DTB and program them in.

How variable is the use of this property going to be? Would it instead
be possible to decide that this was necessary, and choose the
appropriate values based on a compatible property?

> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> ---
>  .../devicetree/bindings/ata/sata_highbank.txt      |  2 +
>  drivers/ata/sata_highbank.c                        | 57 +++++++++++++++++-----
>  2 files changed, 47 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/ata/sata_highbank.txt b/Documentation/devicetree/bindings/ata/sata_highbank.txt
> index aa1b798..d692e9e 100644
> --- a/Documentation/devicetree/bindings/ata/sata_highbank.txt
> +++ b/Documentation/devicetree/bindings/ata/sata_highbank.txt
> @@ -20,6 +20,8 @@ Optional properties:
>  			indicator lights using the indicated GPIOs
>  - calxeda,led-order : a u32 array that map port numbers to offsets within the
>  			SGPIO bitstream.
> +- calxeda,tx-atten  : a u8 array that contains TX attenuation override
> +			codes, one per port.

Is this a u8 array / binary string, or is this an array of u32 cells, of
which only 8 bits are used in each cell? The code seems to suggest the
latter.

Which of the follwoing do you expect?

	calxeda,tx-atten = [ 0x00 0x01 0x02 0x03 ];
	calxeda,tx-atten = < 0x00 0x01 0x02 0x03 >;

Thanks,
Mark.

>  
>  Example:
>          sata@ffe08000 {

Please amend the example.

> diff --git a/drivers/ata/sata_highbank.c b/drivers/ata/sata_highbank.c
> index 8b40025..4c8444f 100644
> --- a/drivers/ata/sata_highbank.c
> +++ b/drivers/ata/sata_highbank.c
> @@ -46,14 +46,19 @@
>  #define CR_BUSY				0x0001
>  #define CR_START			0x0001
>  #define CR_WR_RDN			0x0002
> +#define CPHY_TX_INPUT_STS		0x2001
>  #define CPHY_RX_INPUT_STS		0x2002
> -#define CPHY_SATA_OVERRIDE	 	0x4000
> -#define CPHY_OVERRIDE			0x2005
> +#define CPHY_SATA_TX_OVERRIDE		0x8000
> +#define CPHY_SATA_RX_OVERRIDE	 	0x4000
> +#define CPHY_TX_OVERRIDE		0x2004
> +#define CPHY_RX_OVERRIDE		0x2005
>  #define SPHY_LANE			0x100
>  #define SPHY_HALF_RATE			0x0001
>  #define CPHY_SATA_DPLL_MODE		0x0700
>  #define CPHY_SATA_DPLL_SHIFT		8
>  #define CPHY_SATA_DPLL_RESET		(1 << 11)
> +#define CPHY_SATA_TX_ATTEN		0x1c00
> +#define CPHY_SATA_TX_ATTEN_SHIFT	10
>  #define CPHY_PHY_COUNT			6
>  #define CPHY_LANE_COUNT			4
>  #define CPHY_PORT_COUNT			(CPHY_PHY_COUNT * CPHY_LANE_COUNT)
> @@ -66,6 +71,7 @@ struct phy_lane_info {
>  	void __iomem *phy_base;
>  	u8 lane_mapping;
>  	u8 phy_devs;
> +	u8 tx_atten;
>  };
>  static struct phy_lane_info port_data[CPHY_PORT_COUNT];
>  
> @@ -259,8 +265,27 @@ static void highbank_cphy_disable_overrides(u8 sata_port)
>  	if (unlikely(port_data[sata_port].phy_base == NULL))
>  		return;
>  	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
> -	tmp &= ~CPHY_SATA_OVERRIDE;
> -	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +	tmp &= ~CPHY_SATA_RX_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
> +}
> +
> +static void cphy_override_tx_attenuation(u8 sata_port, u32 val)
> +{
> +	u8 lane = port_data[sata_port].lane_mapping;
> +	u32 tmp;
> +
> +	if (val & 0x8)
> +		return;
> +
> +	tmp = combo_phy_read(sata_port, CPHY_TX_INPUT_STS + lane * SPHY_LANE);
> +	tmp &= ~CPHY_SATA_TX_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_TX_OVERRIDE + lane * SPHY_LANE, tmp);
> +
> +	tmp |= CPHY_SATA_TX_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_TX_OVERRIDE + lane * SPHY_LANE, tmp);
> +
> +	tmp |= (val << CPHY_SATA_TX_ATTEN_SHIFT) & CPHY_SATA_TX_ATTEN;
> +	combo_phy_write(sata_port, CPHY_TX_OVERRIDE + lane * SPHY_LANE, tmp);
>  }
>  
>  static void cphy_override_rx_mode(u8 sata_port, u32 val)
> @@ -268,21 +293,21 @@ static void cphy_override_rx_mode(u8 sata_port, u32 val)
>  	u8 lane = port_data[sata_port].lane_mapping;
>  	u32 tmp;
>  	tmp = combo_phy_read(sata_port, CPHY_RX_INPUT_STS + lane * SPHY_LANE);
> -	tmp &= ~CPHY_SATA_OVERRIDE;
> -	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +	tmp &= ~CPHY_SATA_RX_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
>  
> -	tmp |= CPHY_SATA_OVERRIDE;
> -	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +	tmp |= CPHY_SATA_RX_OVERRIDE;
> +	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
>  
>  	tmp &= ~CPHY_SATA_DPLL_MODE;
>  	tmp |= val << CPHY_SATA_DPLL_SHIFT;
> -	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
>  
>  	tmp |= CPHY_SATA_DPLL_RESET;
> -	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
>  
>  	tmp &= ~CPHY_SATA_DPLL_RESET;
> -	combo_phy_write(sata_port, CPHY_OVERRIDE + lane * SPHY_LANE, tmp);
> +	combo_phy_write(sata_port, CPHY_RX_OVERRIDE + lane * SPHY_LANE, tmp);
>  
>  	msleep(15);
>  }
> @@ -299,16 +324,20 @@ static void highbank_cphy_override_lane(u8 sata_port)
>  						lane * SPHY_LANE);
>  	} while ((tmp & SPHY_HALF_RATE) && (k++ < 1000));
>  	cphy_override_rx_mode(sata_port, 3);
> +	cphy_override_tx_attenuation(sata_port, port_data[sata_port].tx_atten);
>  }
>  
>  static int highbank_initialize_phys(struct device *dev, void __iomem *addr)
>  {
>  	struct device_node *sata_node = dev->of_node;
> -	int phy_count = 0, phy, port = 0;
> +	int phy_count = 0, phy, port = 0, i;
>  	void __iomem *cphy_base[CPHY_PHY_COUNT];
>  	struct device_node *phy_nodes[CPHY_PHY_COUNT];
> +	u32 tx_atten[CPHY_PORT_COUNT];
> +
>  	memset(port_data, 0, sizeof(struct phy_lane_info) * CPHY_PORT_COUNT);
>  	memset(phy_nodes, 0, sizeof(struct device_node*) * CPHY_PHY_COUNT);
> +	memset(tx_atten, 0xff, CPHY_PORT_COUNT);
>  
>  	do {
>  		u32 tmp;
> @@ -336,6 +365,10 @@ static int highbank_initialize_phys(struct device *dev, void __iomem *addr)
>  		of_node_put(phy_data.np);
>  		port += 1;
>  	} while (port < CPHY_PORT_COUNT);
> +	of_property_read_u32_array(sata_node, "calxeda,tx-atten",
> +				tx_atten, port);
> +	for (i = 0; i < port; i++)
> +		port_data[i].tx_atten = (u8) tx_atten[i];
>  	return 0;
>  }
>  
> -- 
> 1.8.1.2
> 
> 
