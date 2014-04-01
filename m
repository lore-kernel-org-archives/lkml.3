Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751837AbaDAVY4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:24:56 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:53831
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaDAVYw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:24:52 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI148cI1432Izz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Tue, 1 Apr 2014 14:24:36 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Looijmans <mike.looijmans@topic.nl>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-doc@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>, Harini Katakam <harinik@xilinx.com>
Subject: Re: [PATCH v3 1/2] i2c: Add driver for Cadence I2C controller
References: <1394556613-11692-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140401005001.GA3590@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140401005001.GA3590@katana>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <91af7a0d-de36-4839-a52e-3bc64836824a@CH1EHSMHS023.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-04-01 at 02:50AM +0200, Wolfram Sang wrote:
> On Tue, Mar 11, 2014 at 09:50:12AM -0700, Soren Brinkmann wrote:
> > Add a driver for the Cadence I2C controller. This controller is for
> > example found in Xilinx Zynq.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> 
> ...
> 
> > +static irqreturn_t cdns_i2c_isr(int irq, void *ptr)
> > +{
> > +	unsigned int isr_status, avail_bytes;
> > +	unsigned int bytes_to_recv, bytes_to_send;
> > +	struct cdns_i2c *id = ptr;
> > +	/* Signal completion only after everything is updated */
> > +	int done_flag = 0;
> > +
> > +	isr_status = cdns_i2c_readreg(CDNS_I2C_ISR_OFFSET);
> > +
> > +	/* Handling nack and arbitration lost interrupt */
> > +	if (isr_status & (CDNS_I2C_IXR_NACK | CDNS_I2C_IXR_ARB_LOST))
> > +		done_flag = 1;
> > +
> > +	/* Handling Data interrupt */
> > +	if ((isr_status & CDNS_I2C_IXR_DATA) &&
> > +			(id->recv_count >= CDNS_I2C_DATA_INTR_DEPTH)) {
> > +		/* Always read data interrupt threshold bytes */
> > +		bytes_to_recv = CDNS_I2C_DATA_INTR_DEPTH;
> > +		id->recv_count = id->recv_count - CDNS_I2C_DATA_INTR_DEPTH;
> 
> Use '-='
> 
> ...
> 
> > +static int cdns_i2c_process_msg(struct cdns_i2c *id, struct i2c_msg *msg,
> > +		struct i2c_adapter *adap)
> > +{
> > +	int ret;
> > +	u32 reg;
> > +	bool retry = false;
> > +	unsigned retries = adap->retries;
> > +
> > +	id->p_msg = msg;
> > +	do {
> > +		id->err_status = 0;
> > +		init_completion(&id->xfer_done);
> 
> reinit_completion. And add init_completion in probe.
> 
> > +
> > +		/* Check for the TEN Bit mode on each msg */
> > +		reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> > +		if (msg->flags & I2C_M_TEN) {
> > +			if (reg & CDNS_I2C_CR_NEA)
> > +				cdns_i2c_writereg(reg & ~CDNS_I2C_CR_NEA,
> > +						CDNS_I2C_CR_OFFSET);
> > +		} else {
> > +			if (!(reg & CDNS_I2C_CR_NEA))
> > +				cdns_i2c_writereg(reg | CDNS_I2C_CR_NEA,
> > +						CDNS_I2C_CR_OFFSET);
> > +		}
> > +
> > +		/* Check for the R/W flag on each msg */
> > +		if (msg->flags & I2C_M_RD)
> > +			cdns_i2c_mrecv(id);
> > +		else
> > +			cdns_i2c_msend(id);
> > +
> > +		/* Wait for the signal of completion */
> > +		ret = wait_for_completion_timeout(&id->xfer_done, HZ);
> > +		if (!ret) {
> > +			cdns_i2c_master_reset(adap);
> > +			dev_err(id->adap.dev.parent,
> > +					"timeout waiting on completion\n");
> > +			return -ETIMEDOUT;
> > +		}
> > +
> > +		cdns_i2c_writereg(CDNS_I2C_IXR_ALL_INTR_MASK,
> > +				  CDNS_I2C_IDR_OFFSET);
> > +
> > +		/* If it is bus arbitration error, try again */
> > +		if (id->err_status & CDNS_I2C_IXR_ARB_LOST) {
> 
> Just return -EAGAIN here...
> 
> > +			dev_dbg(id->adap.dev.parent,
> > +				 "Lost ownership on bus, trying again\n");
> > +			if (retries--) {
> > +				mdelay(2);
> > +				retry = true;
> > +			} else {
> > +				dev_err(id->adap.dev.parent,
> > +					 "Retries completed, exit\n");
> > +				return -EREMOTEIO;
> > +			}
> > +		}
> 
> ... and you can skip this block since the core will do the retries.
> 
> > +	} while (retry);
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * cdns_i2c_master_xfer - The main i2c transfer function
> > + * @adap:	pointer to the i2c adapter driver instance
> > + * @msgs:	pointer to the i2c message structure
> > + * @num:	the number of messages to transfer
> > + *
> > + * Return: number of msgs processed on success, negative error otherwise
> > + *
> > + * This function waits for the bus idle condition and updates the timeout if
> > + * modified by user. Then initiates the send/recv activity based on the
> > + * transfer message received.
> > + */
> > +static int cdns_i2c_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs,
> > +				int num)
> > +{
> > +	struct cdns_i2c *id = adap->algo_data;
> > +	unsigned long timeout;
> > +	int ret, count;
> > +	u32 reg;
> > +
> > +	/* Waiting for bus-ready. If bus not ready, it returns after timeout */
> > +	timeout = jiffies + CDNS_I2C_TIMEOUT;
> > +	while (cdns_i2c_readreg(CDNS_I2C_SR_OFFSET) & CDNS_I2C_SR_BA) {
> > +		if (time_after(jiffies, timeout)) {
> > +			dev_warn(id->adap.dev.parent,
> > +					"timedout waiting for bus ready\n");
> > +			cdns_i2c_master_reset(adap);
> > +			return -ETIMEDOUT;
> > +		}
> > +		schedule_timeout(1);
> > +	}
> > +
> > +	/* The bus is free. Set the new timeout value if updated */
> > +	if (id->adap.timeout != id->cur_timeout) {
> > +		cdns_i2c_writereg(id->adap.timeout & CDNS_I2C_TIME_OUT_TO_MASK,
> > +					CDNS_I2C_TIME_OUT_OFFSET);
> > +		id->cur_timeout = id->adap.timeout;
> > +	}
> > +
> > +	/*
> > +	 * Set the flag to one when multiple messages are to be
> > +	 * processed with a repeated start.
> > +	 */
> > +	if (num > 1) {
> > +		id->bus_hold_flag = 1;
> > +		reg = cdns_i2c_readreg(CDNS_I2C_CR_OFFSET);
> > +		reg |= CDNS_I2C_CR_HOLD;
> > +		cdns_i2c_writereg(reg, CDNS_I2C_CR_OFFSET);
> > +	} else {
> > +		id->bus_hold_flag = 0;
> > +	}
> > +
> > +	/* Process the msg one by one */
> > +	for (count = 0; count < num; count++, msgs++) {
> > +		if (count == (num - 1))
> > +			id->bus_hold_flag = 0;
> > +
> > +		ret = cdns_i2c_process_msg(id, msgs, adap);
> > +		if (ret)
> > +			return ret;
> > +
> > +		/* Report the other error interrupts to application as EIO */
> > +		if (id->err_status & 0xE4) {
> 
> Please replace this magic hex value with something readable.
> 
> > +			cdns_i2c_master_reset(adap);
> > +			return -EIO;
> > +		}
> > +	}
> > +
> > +	return num;
> > +}
> > +
> 
> ...
> 
> > +/**
> > + * cdns_i2c_probe - Platform registration call
> > + * @pdev:	Handle to the platform device structure
> > + *
> > + * Return: 0 on success, negative error otherwise
> > + *
> > + * This function does all the memory allocation and registration for the i2c
> > + * device. User can modify the address mode to 10 bit address mode using the
> > + * ioctl call with option I2C_TENBIT.
> > + */
> > +static int cdns_i2c_probe(struct platform_device *pdev)
> > +{
> > +	struct resource *r_mem;
> > +	struct cdns_i2c *id;
> > +	int ret;
> > +
> > +	id = devm_kzalloc(&pdev->dev, sizeof(*id), GFP_KERNEL);
> > +	if (!id)
> > +		return -ENOMEM;
> > +
> > +	platform_set_drvdata(pdev, id);
> > +
> > +	r_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> > +	id->membase = devm_ioremap_resource(&pdev->dev, r_mem);
> > +	if (IS_ERR(id->membase))
> > +		return PTR_ERR(id->membase);
> > +
> > +	id->irq = platform_get_irq(pdev, 0);
> > +
> > +	id->adap.nr = pdev->id;
> 
> Drop this line and use i2c_add_adapter() later to let the core handle
> the numbering. This will also take aliases into account.
> 
> > +	id->adap.dev.of_node = pdev->dev.of_node;
> > +	id->adap.algo = &cdns_i2c_algo;
> > +	id->adap.timeout = 0x1F;	/* Default timeout value */
> 
> This value is in jiffies, so you probably want to use msecs_to_jiffies
> or alike.
> 
> > +	id->adap.retries = 3;		/* Default retry value. */
> > +	id->adap.algo_data = id;
> > +	id->adap.dev.parent = &pdev->dev;
> > +	snprintf(id->adap.name, sizeof(id->adap.name),
> > +		 "Cadence I2C at %08lx", (unsigned long)r_mem->start);
> > +
> > +	id->cur_timeout = id->adap.timeout;
> > +	id->clk = devm_clk_get(&pdev->dev, NULL);
> > +	if (IS_ERR(id->clk)) {
> > +		dev_err(&pdev->dev, "input clock not found.\n");
> > +		return PTR_ERR(id->clk);
> > +	}
> > +	ret = clk_prepare_enable(id->clk);
> > +	if (ret) {
> > +		dev_err(&pdev->dev, "Unable to enable clock.\n");
> > +		return ret;
> > +	}
> > +	id->clk_rate_change_nb.notifier_call = cdns_i2c_clk_notifier_cb;
> > +	if (clk_notifier_register(id->clk, &id->clk_rate_change_nb))
> > +		dev_warn(&pdev->dev, "Unable to register clock notifier.\n");
> > +	id->input_clk = clk_get_rate(id->clk);
> > +
> > +	ret = of_property_read_u32(pdev->dev.of_node, "clock-frequency",
> > +			&id->i2c_clk);
> > +	if (ret || (id->i2c_clk > CDNS_I2C_SPEED_MAX))
> > +		id->i2c_clk = CDNS_I2C_SPEED_MAX;
> > +
> > +	cdns_i2c_writereg(0xE, CDNS_I2C_CR_OFFSET);
> 
> Remove magic value. Please check the driver for more, in case I missed
> some.

Thanks for reviewing. I'll work on the next iteration.

	Sören


