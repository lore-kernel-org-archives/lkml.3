Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757079Ab3FGT7S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 15:59:18 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39066 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756046Ab3FGT7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 15:59:16 -0400
Date: Fri, 7 Jun 2013 20:57:54 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Ike Pan <ike.pan@canonical.com>, Nadav Haklai <nadavh@marvell.com>,
        David Marlin <dmarlin@redhat.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Eran Ben-Avi <benavi@marvell.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Jon Masters <jcm@redhat.com>,
        Zbigniew Bodek <zbb@semihalf.com>,
        linux-arm-kernel@lists.infradead.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Piotr Ziecik <kosmo@semihalf.com>, Nicolas Pitre <nico@fluxnic.net>,
        linux-kernel@vger.kernel.org, Maen Suleiman <maen@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>
Subject: Re: [PATCH 1/2] i2c-mv64xxx: Add I2C Transaction Generator support
Message-ID: <20130607195754.GA18614@n2100.arm.linux.org.uk>
References: <1370619743-15245-1-git-send-email-gregory.clement@free-electrons.com> <1370619743-15245-2-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370619743-15245-2-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:42:22PM +0200, Gregory CLEMENT wrote:
> From: Zbigniew Bodek <zbb@semihalf.com>
> 
> The I2C Transaction Generator offloads CPU from managing I2C
> transfer step by step.
> 
> This feature is currently only available on Armada XP, so usage of
> this mechanism is activated through device tree.
> 
> [gregory.clement@free-electrons.com: Rewrite some part to be applied
> on the the code modified by Russell King's fixes]
> [gregory.clement@free-electrons.com: Merge and split the commits to
> push them to the accurate maintainer i2c and of]]
> [gregory.clement@free-electrons.com: Reword the commit log]
> 
> Signed-off-by: Piotr Ziecik <kosmo@semihalf.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> ---
>  drivers/i2c/busses/i2c-mv64xxx.c | 143 +++++++++++++++++++++++++++++++++++++--
>  1 file changed, 139 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-mv64xxx.c b/drivers/i2c/busses/i2c-mv64xxx.c
> index 6356439..5376dc3 100644
> --- a/drivers/i2c/busses/i2c-mv64xxx.c
> +++ b/drivers/i2c/busses/i2c-mv64xxx.c
> @@ -24,7 +24,7 @@
>  #include <linux/clk.h>
>  #include <linux/err.h>
>  
> -/* Register defines */
> +/* Register defines (I2C port) */
>  #define	MV64XXX_I2C_REG_SLAVE_ADDR			0x00
>  #define	MV64XXX_I2C_REG_DATA				0x04
>  #define	MV64XXX_I2C_REG_CONTROL				0x08
> @@ -59,6 +59,29 @@
>  #define	MV64XXX_I2C_STATUS_MAST_RD_ADDR_2_NO_ACK	0xe8
>  #define	MV64XXX_I2C_STATUS_NO_STATUS			0xf8
>  
> +/* Register defines (I2C bridge) */
> +#define	MV64XXX_I2C_REG_TX_DATA_LO			0xC0
> +#define	MV64XXX_I2C_REG_TX_DATA_HI			0xC4
> +#define	MV64XXX_I2C_REG_RX_DATA_LO			0xC8
> +#define	MV64XXX_I2C_REG_RX_DATA_HI			0xCC
> +#define	MV64XXX_I2C_REG_BRIDGE_CONTROL			0xD0
> +#define	MV64XXX_I2C_REG_BRIDGE_STATUS			0xD4
> +#define	MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE		0xD8
> +#define	MV64XXX_I2C_REG_BRIDGE_INTR_MASK		0xDC
> +#define	MV64XXX_I2C_REG_BRIDGE_TIMING			0xE0
> +
> +/* Bridge Control values */
> +#define	MV64XXX_I2C_BRIDGE_CONTROL_WR			0x00000001
> +#define	MV64XXX_I2C_BRIDGE_CONTROL_RD			0x00000002
> +#define	MV64XXX_I2C_BRIDGE_CONTROL_ADDR_SHIFT		2
> +#define	MV64XXX_I2C_BRIDGE_CONTROL_ADDR_EXT		0x00001000
> +#define	MV64XXX_I2C_BRIDGE_CONTROL_TX_SIZE_SHIFT	13
> +#define	MV64XXX_I2C_BRIDGE_CONTROL_RX_SIZE_SHIFT	16
> +#define	MV64XXX_I2C_BRIDGE_CONTROL_ENABLE		0x00080000
> +
> +/* Bridge Status values */
> +#define	MV64XXX_I2C_BRIDGE_STATUS_ERROR			0x00000001
> +
>  /* Driver states */
>  enum {
>  	MV64XXX_I2C_STATE_INVALID,
> @@ -110,6 +133,7 @@ struct mv64xxx_i2c_data {
>  	spinlock_t		lock;
>  	struct i2c_msg		*msg;
>  	struct i2c_adapter	adapter;
> +	int			bridge_enabled;
>  };
>  
>  static void
> @@ -157,6 +181,16 @@ mv64xxx_i2c_hw_init(struct mv64xxx_i2c_data *drv_data)
>  	writel(0, drv_data->reg_base + MV64XXX_I2C_REG_EXT_SLAVE_ADDR);
>  	writel(MV64XXX_I2C_REG_CONTROL_TWSIEN | MV64XXX_I2C_REG_CONTROL_STOP,
>  		drv_data->reg_base + MV64XXX_I2C_REG_CONTROL);
> +
> +	if (drv_data->bridge_enabled) {
> +		writel(0, drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_CONTROL);
> +		writel(0, drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_TIMING);
> +		writel(0, drv_data->reg_base +
> +			MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE);
> +		writel(0, drv_data->reg_base +
> +			MV64XXX_I2C_REG_BRIDGE_INTR_MASK);
> +	}
> +
>  	drv_data->state = MV64XXX_I2C_STATE_IDLE;
>  }
>  
> @@ -368,6 +402,19 @@ mv64xxx_i2c_intr(int irq, void *dev_id)
>  	irqreturn_t	rc = IRQ_NONE;
>  
>  	spin_lock_irqsave(&drv_data->lock, flags);
> +
> +	if (drv_data->bridge_enabled) {
> +		if (readl(drv_data->reg_base +
> +				MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE)) {
> +			writel(0, drv_data->reg_base +
> +				MV64XXX_I2C_REG_BRIDGE_CONTROL);
> +			writel(0, drv_data->reg_base +
> +				MV64XXX_I2C_REG_BRIDGE_INTR_CAUSE);
> +			drv_data->block = 0;
> +			wake_up(&drv_data->waitq);
> +			rc = IRQ_HANDLED;
> +		}
> +	}
>  	while (readl(drv_data->reg_base + MV64XXX_I2C_REG_CONTROL) &
>  						MV64XXX_I2C_REG_CONTROL_IFLG) {
>  		status = readl(drv_data->reg_base + MV64XXX_I2C_REG_STATUS);
> @@ -446,6 +493,81 @@ mv64xxx_i2c_execute_msg(struct mv64xxx_i2c_data *drv_data, struct i2c_msg *msg,
>  	return drv_data->rc;
>  }
>  
> +static int
> +mv64xxx_i2c_offload_msg(struct mv64xxx_i2c_data *drv_data, struct i2c_msg *msg)
> +{
> +	unsigned long data_reg_hi = 0;
> +	unsigned long data_reg_lo = 0;
> +	unsigned long status_reg;
> +	unsigned long ctrl_reg;
> +	unsigned long flags;
> +	unsigned int i;
> +
> +	/* Only regular transactions can be offloaded */
> +	if ((msg->flags & ~(I2C_M_TEN | I2C_M_RD)) != 0)
> +		return 1;
> +
> +	/* Only 1-8 byte transfers can be offloaded */
> +	if (msg->len < 1 || msg->len > 8)
> +		return 1;
> +
> +	/* Build transaction */
> +	ctrl_reg = MV64XXX_I2C_BRIDGE_CONTROL_ENABLE |
> +		   (msg->addr << MV64XXX_I2C_BRIDGE_CONTROL_ADDR_SHIFT);
> +
> +	if ((msg->flags & I2C_M_TEN) != 0)
> +		ctrl_reg |=  MV64XXX_I2C_BRIDGE_CONTROL_ADDR_EXT;
> +
> +	if ((msg->flags & I2C_M_RD) == 0) {
> +		for (i = 0; i < 4 && i < msg->len; i++)
> +			data_reg_lo = data_reg_lo |
> +					(msg->buf[i] << ((i & 0x3) * 8));
> +
> +		for (i = 4; i < 8 && i < msg->len; i++)
> +			data_reg_hi = data_reg_hi |
> +					(msg->buf[i] << ((i & 0x3) * 8));
> +
> +		ctrl_reg |= MV64XXX_I2C_BRIDGE_CONTROL_WR |
> +		    (msg->len - 1) << MV64XXX_I2C_BRIDGE_CONTROL_TX_SIZE_SHIFT;
> +	} else {
> +		ctrl_reg |= MV64XXX_I2C_BRIDGE_CONTROL_RD |
> +		    (msg->len - 1) << MV64XXX_I2C_BRIDGE_CONTROL_RX_SIZE_SHIFT;
> +	}
> +
> +	/* Execute transaction */
> +	spin_lock_irqsave(&drv_data->lock, flags);
> +	drv_data->block = 1;
> +	writel(data_reg_lo, drv_data->reg_base + MV64XXX_I2C_REG_TX_DATA_LO);
> +	writel(data_reg_hi, drv_data->reg_base + MV64XXX_I2C_REG_TX_DATA_HI);

You can use writel_relaxed with the above two writes - you don't need any
synchronization with memory as you aren't doing DMA.

> +	writel(ctrl_reg, drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_CONTROL);
> +	spin_unlock_irqrestore(&drv_data->lock, flags);

You can also probably dispense with the spinlock too - the interface should
be idle before you start writing to these registers, and nothing should start
happening until after this last write.  Moreover, the I2C core layer will
ensure that there can't be two concurrent transactions.

> +
> +	mv64xxx_i2c_wait_for_completion(drv_data);
> +
> +	spin_lock_irqsave(&drv_data->lock, flags);
> +	status_reg = readl(drv_data->reg_base + MV64XXX_I2C_REG_BRIDGE_STATUS);
> +	data_reg_lo = readl(drv_data->reg_base + MV64XXX_I2C_REG_RX_DATA_LO);
> +	data_reg_hi = readl(drv_data->reg_base + MV64XXX_I2C_REG_RX_DATA_HI);
> +	spin_unlock_irqrestore(&drv_data->lock, flags);

And same here - after the completion returns, the interface should now be
idle again, so there should be no concurrency.

> -
> -	rc = mv64xxx_i2c_execute_msg(drv_data, &msgs[0], num == 1);
> +	if (drv_data->bridge_enabled)
> +		rc = mv64xxx_i2c_offload_msg(drv_data, &msgs[0]);

Note that you're only dealing with the first message, so this is buggy.
mv64xxx_i2c_execute_msg() below now deals with the entire transaction
(so all the i2c_msg structures) in one go from interrupt context,
unlike prior to my patch where messages were dealt with one at a time
(and thereby buggily too!)
