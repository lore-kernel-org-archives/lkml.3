Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbbAGNYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:24:15 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:39125 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133AbbAGNYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:24:12 -0500
Message-ID: <54AD3161.6070201@vanguardiasur.com.ar>
Date: Wed, 07 Jan 2015 10:15:13 -0300
From: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Organization: VanguardiaSur
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Graham Moore <grmoore@opensource.altera.com>,
        linux-mtd@lists.infradead.org
CC: David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-kernel@vger.kernel.org, Alan Tull <atull@opensource.altera.com>,
        Dinh Nguyen <dinguyen@opensource.altera.com>,
        Yves Vandervennet <yvanderv@opensource.altera.com>
Subject: Re: [PATCH V2 1/2] mtd: spi-nor: Add driver for Cadence Quad SPI
 Flash Controller.
References: <1420564094-1086-1-git-send-email-grmoore@opensource.altera.com>
In-Reply-To: <1420564094-1086-1-git-send-email-grmoore@opensource.altera.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/06/2015 02:08 PM, Graham Moore wrote:
> +
> +static unsigned int cqspi_wait_idle(struct cqspi_st *cqspi)
> +{
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int count = 0;
> +	unsigned timeout;
> +
> +	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
> +	while (cqspi_check_timeout(timeout)) {
> +		if (CQSPI_REG_IS_IDLE(reg_base)) {
> +			/* Read few times in succession to ensure it does
> +			   not transition low again */

Nitpick: the style for multi-lines comments is:

/*
 * Read few times in succession to ensure it does
 * not transition low again
 */

See Documentation/CodingStyle. Maybe checkpatch.pl would complain as well.

> +			count++;
> +			if (count >= CQSPI_POLL_IDLE_RETRY)
> +				return 1;
> +		} else {
> +			count = 0;
> +		}
> +		cpu_relax();
> +	}
> +
> +	/* Timeout, in busy mode. */
> +	dev_err(&cqspi->pdev->dev, "QSPI is still busy after %dms timeout.\n",
> +		CQSPI_TIMEOUT_MS);
> +	return 0;
> +}
> +
> +static int cqspi_exec_flash_cmd(struct cqspi_st *cqspi, unsigned int reg)
> +{
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int timeout;
> +
> +	/* Write the CMDCTRL without start execution. */
> +	writel(reg, reg_base + CQSPI_REG_CMDCTRL);
> +	/* Start execute */
> +	reg |= CQSPI_REG_CMDCTRL_EXECUTE_MASK;
> +	writel(reg, reg_base + CQSPI_REG_CMDCTRL);
> +
> +	/* Polling for completion. */
> +	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
> +	while (cqspi_check_timeout(timeout)) {
> +		reg = readl(reg_base + CQSPI_REG_CMDCTRL) &
> +		    CQSPI_REG_CMDCTRL_INPROGRESS_MASK;
> +		if (!reg)
> +			break;
> +	}
> +
> +	if (reg != 0) {
> +		dev_err(&cqspi->pdev->dev, "flash cmd execute time out\n");
> +		return -EIO;
> +	}
> +
> +	/* Polling QSPI idle status. */
> +	if (!cqspi_wait_idle(cqspi))
> +		return -EIO;
> +
> +	return 0;
> +}
> +
> +static int cqspi_command_read(struct spi_nor *nor,
> +			      const u8 *txbuf, unsigned n_tx,
> +			      u8 *rxbuf, unsigned n_rx)
> +{
> +	unsigned int reg;
> +	unsigned int read_len;
> +	int status;
> +	struct cqspi_st *cqspi = nor->priv;
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int rdreg;
> +
> +	if (!n_rx || n_rx > CQSPI_STIG_DATA_LEN_MAX || rxbuf == NULL) {
> +		dev_err(nor->dev,
> +			"Invalid input argument, len %d rxbuf 0x%08x\n", n_rx,
> +			(unsigned int)rxbuf);
> +		return -EINVAL;
> +	}
> +
> +	reg = txbuf[0] << CQSPI_REG_CMDCTRL_OPCODE_LSB;
> +
> +	rdreg = cqspi_calc_rdreg(nor, txbuf[0]);
> +	writel(rdreg, reg_base + CQSPI_REG_RD_INSTR);
> +
> +	reg |= (0x1 << CQSPI_REG_CMDCTRL_RD_EN_LSB);
> +
> +	/* 0 means 1 byte. */
> +	reg |= (((n_rx - 1) & CQSPI_REG_CMDCTRL_RD_BYTES_MASK)
> +		<< CQSPI_REG_CMDCTRL_RD_BYTES_LSB);
> +	status = cqspi_exec_flash_cmd(cqspi, reg);
> +	if (status != 0)
> +		return status;
> +
> +	reg = readl(reg_base + CQSPI_REG_CMDREADDATALOWER);
> +
> +	/* Put the read value into rx_buf */
> +	read_len = (n_rx > 4) ? 4 : n_rx;
> +	memcpy(rxbuf, &reg, read_len);
> +	rxbuf += read_len;
> +
> +	if (n_rx > 4) {
> +		reg = readl(reg_base + CQSPI_REG_CMDREADDATAUPPER);
> +
> +		read_len = n_rx - read_len;
> +		memcpy(rxbuf, &reg, read_len);
> +	}
> +
> +	return 0;
> +}
> +
> +static int cqspi_command_write(struct spi_nor *nor,
> +			       u8 opcode, const u8 *txbuf, unsigned n_tx)
> +{
> +	unsigned int reg;
> +	unsigned int data;
> +	struct cqspi_st *cqspi = nor->priv;
> +	void __iomem *reg_base = cqspi->iobase;
> +
> +	if (n_tx > 4 || (n_tx && txbuf == NULL)) {
> +		dev_err(nor->dev,
> +			"Invalid input argument, cmdlen %d txbuf 0x%08x\n",
> +			n_tx, (unsigned int)txbuf);
> +		return -EINVAL;
> +	}
> +
> +	reg = opcode << CQSPI_REG_CMDCTRL_OPCODE_LSB;
> +	if (n_tx) {
> +		reg |= (0x1 << CQSPI_REG_CMDCTRL_WR_EN_LSB);
> +		reg |= ((n_tx - 1) & CQSPI_REG_CMDCTRL_WR_BYTES_MASK)
> +		    << CQSPI_REG_CMDCTRL_WR_BYTES_LSB;
> +		data = 0;
> +		memcpy(&data, txbuf, n_tx);
> +		writel(data, reg_base + CQSPI_REG_CMDWRITEDATALOWER);
> +	}
> +
> +	return cqspi_exec_flash_cmd(cqspi, reg);
> +}
> +
> +static int cqspi_command_write_addr(struct spi_nor *nor,
> +				    u8 opcode, unsigned int addr)
> +{
> +	unsigned int reg;
> +	struct cqspi_st *cqspi = nor->priv;
> +	void __iomem *reg_base = cqspi->iobase;
> +
> +	reg = opcode << CQSPI_REG_CMDCTRL_OPCODE_LSB;
> +	reg |= (0x1 << CQSPI_REG_CMDCTRL_ADDR_EN_LSB);
> +	reg |= ((nor->addr_width - 1) & CQSPI_REG_CMDCTRL_ADD_BYTES_MASK)
> +	    << CQSPI_REG_CMDCTRL_ADD_BYTES_LSB;
> +
> +	writel(addr, reg_base + CQSPI_REG_CMDADDRESS);
> +
> +	return cqspi_exec_flash_cmd(cqspi, reg);
> +}
> +
> +static int cqspi_indirect_read_setup(struct spi_nor *nor,
> +				     unsigned int from_addr)
> +{
> +	unsigned int reg;
> +	unsigned int dummy_clk = 0;
> +	unsigned int dummy_bytes;
> +	struct cqspi_st *cqspi = nor->priv;
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int ahb_phy_addr = cqspi->ahb_phy_addr;
> +
> +	writel((ahb_phy_addr & CQSPI_INDIRECTTRIGGER_ADDR_MASK),
> +	       reg_base + CQSPI_REG_INDIRECTTRIGGER);
> +	writel(from_addr, reg_base + CQSPI_REG_INDIRECTRDSTARTADDR);
> +
> +	reg = nor->read_opcode << CQSPI_REG_RD_INSTR_OPCODE_LSB;
> +	reg |= cqspi_calc_rdreg(nor, nor->read_opcode);
> +
> +	/* Setup dummy clock cycles */
> +	dummy_bytes = nor->read_dummy / 8;
> +	if (dummy_bytes) {
> +		struct cqspi_flash_pdata *f_pdata;
> +
> +		f_pdata = &cqspi->f_pdata[cqspi->current_cs];
> +
> +		if (dummy_bytes > CQSPI_DUMMY_BYTES_MAX)
> +			dummy_bytes = CQSPI_DUMMY_BYTES_MAX;
> +
> +		reg |= (1 << CQSPI_REG_RD_INSTR_MODE_EN_LSB);
> +		/* Set mode bits high to ensure chip doesn't enter XIP */
> +		writel(0xFF, reg_base + CQSPI_REG_MODE_BIT);
> +
> +		/* Convert to clock cycles. */
> +		dummy_clk = dummy_bytes * CQSPI_DUMMY_CLKS_PER_BYTE;
> +		/* Need to subtract the mode byte (8 clocks). */
> +		dummy_clk -= CQSPI_DUMMY_CLKS_PER_BYTE;
> +
> +		if (dummy_clk)
> +			reg |= (dummy_clk & CQSPI_REG_RD_INSTR_DUMMY_MASK)
> +			    << CQSPI_REG_RD_INSTR_DUMMY_LSB;
> +	}
> +
> +	writel(reg, reg_base + CQSPI_REG_RD_INSTR);
> +
> +	/* Set address width */
> +	reg = readl(reg_base + CQSPI_REG_SIZE);
> +	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
> +	reg |= (nor->addr_width - 1);
> +	writel(reg, reg_base + CQSPI_REG_SIZE);
> +	return 0;
> +}
> +
> +static int cqspi_indirect_read_execute(struct spi_nor *nor,
> +				       u8 *rxbuf, unsigned n_rx)
> +{
> +	int ret = 0;
> +	unsigned int reg = 0;
> +	unsigned int bytes_to_read = 0;
> +	unsigned int timeout;
> +	unsigned int watermark;
> +	struct cqspi_st *cqspi = nor->priv;
> +	void __iomem *reg_base = cqspi->iobase;
> +	void __iomem *ahb_base = cqspi->ahb_base;
> +	int remaining = (int)n_rx;
> +
> +	watermark = cqspi->fifo_depth * CQSPI_FIFO_WIDTH / 2;
> +	writel(watermark, reg_base + CQSPI_REG_INDIRECTRDWATERMARK);
> +	writel(remaining, reg_base + CQSPI_REG_INDIRECTRDBYTES);
> +
> +	/* Clear all interrupts. */
> +	writel(CQSPI_IRQ_STATUS_MASK, reg_base + CQSPI_REG_IRQSTATUS);
> +
> +	cqspi->irq_mask = CQSPI_IRQ_MASK_RD;
> +	writel(cqspi->irq_mask, reg_base + CQSPI_REG_IRQMASK);
> +
> +	reinit_completion(&cqspi->transfer_complete);
> +	writel(CQSPI_REG_INDIRECTRD_START_MASK,
> +	       reg_base + CQSPI_REG_INDIRECTRD);
> +
> +	while (remaining > 0) {
> +		ret = wait_for_completion_timeout(&cqspi->transfer_complete,
> +						  msecs_to_jiffies
> +						  (CQSPI_READ_TIMEOUT_MS));
> +
> +		bytes_to_read = CQSPI_GET_RD_SRAM_LEVEL(reg_base);
> +
> +		if (!ret && bytes_to_read == 0) {
> +			dev_err(nor->dev, "Indirect read timeout, no bytes\n");
> +			ret = -ETIMEDOUT;
> +			goto failrd;
> +		}
> +
> +		while (bytes_to_read != 0) {
> +			bytes_to_read *= CQSPI_FIFO_WIDTH;
> +			bytes_to_read = bytes_to_read > remaining
> +			    ? remaining : bytes_to_read;
> +			cqspi_fifo_read(rxbuf, ahb_base, bytes_to_read);
> +			rxbuf += bytes_to_read;
> +			remaining -= bytes_to_read;
> +			bytes_to_read = CQSPI_GET_RD_SRAM_LEVEL(reg_base);
> +		}
> +	}
> +
> +	/* Check indirect done status */
> +	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
> +	while (cqspi_check_timeout(timeout)) {
> +		reg = readl(reg_base + CQSPI_REG_INDIRECTRD);
> +		if (reg & CQSPI_REG_INDIRECTRD_DONE_MASK)
> +			break;
> +	}
> +
> +	if (!(reg & CQSPI_REG_INDIRECTRD_DONE_MASK)) {
> +		dev_err(nor->dev,
> +			"Indirect read completion error 0x%08x\n", reg);
> +		ret = -ETIMEDOUT;
> +		goto failrd;
> +	}
> +
> +	/* Disable interrupt */
> +	writel(0, reg_base + CQSPI_REG_IRQMASK);
> +
> +	/* Clear indirect completion status */
> +	writel(CQSPI_REG_INDIRECTRD_DONE_MASK, reg_base + CQSPI_REG_INDIRECTRD);
> +
> +	return 0;
> +
> + failrd:
> +	/* Disable interrupt */
> +	writel(0, reg_base + CQSPI_REG_IRQMASK);
> +
> +	/* Cancel the indirect read */
> +	writel(CQSPI_REG_INDIRECTWR_CANCEL_MASK,
> +	       reg_base + CQSPI_REG_INDIRECTRD);
> +	return ret;
> +}
> +
> +static int cqspi_indirect_write_setup(struct spi_nor *nor, unsigned int to_addr)
> +{
> +	unsigned int reg;
> +	struct cqspi_st *cqspi = nor->priv;
> +	void __iomem *reg_base = cqspi->iobase;
> +
> +	/* Set opcode. */
> +	reg = nor->program_opcode << CQSPI_REG_WR_INSTR_OPCODE_LSB;
> +	writel(reg, reg_base + CQSPI_REG_WR_INSTR);
> +	reg = cqspi_calc_rdreg(nor, nor->program_opcode);
> +	writel(reg, reg_base + CQSPI_REG_RD_INSTR);
> +
> +	writel(to_addr, reg_base + CQSPI_REG_INDIRECTWRSTARTADDR);
> +
> +	reg = readl(reg_base + CQSPI_REG_SIZE);
> +	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
> +	reg |= (nor->addr_width - 1);
> +	writel(reg, reg_base + CQSPI_REG_SIZE);
> +	return 0;
> +}
> +
> +static int cqspi_indirect_write_execute(struct spi_nor *nor,
> +					const u8 *txbuf, unsigned n_tx)
> +{
> +	int ret;
> +	unsigned int timeout;
> +	unsigned int reg = 0;
> +	struct cqspi_st *cqspi = nor->priv;
> +	void __iomem *reg_base = cqspi->iobase;
> +	void __iomem *ahb_base = cqspi->ahb_base;
> +	int remaining = (int)n_tx;
> +	struct cqspi_flash_pdata *f_pdata;
> +	unsigned int page_size;
> +	unsigned int write_bytes;
> +
> +	f_pdata = &cqspi->f_pdata[cqspi->current_cs];
> +	page_size = f_pdata->page_size;
> +
> +	writel(remaining, reg_base + CQSPI_REG_INDIRECTWRBYTES);
> +
> +	writel(CQSPI_REG_SRAM_THRESHOLD_BYTES, reg_base +
> +	       CQSPI_REG_INDIRECTWRWATERMARK);
> +
> +	/* Clear all interrupts. */
> +	writel(CQSPI_IRQ_STATUS_MASK, reg_base + CQSPI_REG_IRQSTATUS);
> +
> +	cqspi->irq_mask = CQSPI_IRQ_MASK_WR;
> +	writel(cqspi->irq_mask, reg_base + CQSPI_REG_IRQMASK);
> +
> +	reinit_completion(&cqspi->transfer_complete);
> +	writel(CQSPI_REG_INDIRECTWR_START_MASK,
> +	       reg_base + CQSPI_REG_INDIRECTWR);
> +
> +	/* Write a page or remaining bytes. */
> +	write_bytes = remaining > page_size ? page_size : remaining;
> +	/* Fill up the data at the beginning */
> +	cqspi_fifo_write(ahb_base, txbuf, write_bytes);
> +	txbuf += write_bytes;
> +	remaining -= write_bytes;
> +
> +	while (remaining > 0) {
> +		ret = wait_for_completion_timeout(&cqspi->transfer_complete,
> +						  msecs_to_jiffies
> +						  (CQSPI_TIMEOUT_MS));
> +		if (!ret) {
> +			dev_err(nor->dev, "Indirect write timeout\n");
> +			ret = -ETIMEDOUT;
> +			goto failwr;
> +		}
> +
> +		write_bytes = remaining > page_size ? page_size : remaining;
> +		cqspi_fifo_write(ahb_base, txbuf, write_bytes);
> +		txbuf += write_bytes;
> +		remaining -= write_bytes;
> +	}
> +
> +	ret = wait_for_completion_timeout(&cqspi->transfer_complete,
> +					  msecs_to_jiffies(CQSPI_TIMEOUT_MS));
> +	if (!ret) {
> +		dev_err(nor->dev, "Indirect write timeout\n");
> +		ret = -ETIMEDOUT;
> +		goto failwr;
> +	}
> +
> +	/* Check indirect done status */
> +	timeout = cqspi_init_timeout(CQSPI_TIMEOUT_MS);
> +	while (cqspi_check_timeout(timeout)) {
> +		reg = readl(reg_base + CQSPI_REG_INDIRECTWR);
> +		if (reg & CQSPI_REG_INDIRECTWR_DONE_MASK)
> +			break;
> +	}
> +
> +	if (!(reg & CQSPI_REG_INDIRECTWR_DONE_MASK)) {
> +		dev_err(nor->dev,
> +			"Indirect write completion error 0x%08x\n", reg);
> +		ret = -ETIMEDOUT;
> +		goto failwr;
> +	}
> +
> +	/* Disable interrupt. */
> +	writel(0, reg_base + CQSPI_REG_IRQMASK);
> +
> +	/* Clear indirect completion status */
> +	writel(CQSPI_REG_INDIRECTWR_DONE_MASK, reg_base + CQSPI_REG_INDIRECTWR);
> +
> +	cqspi_wait_idle(cqspi);
> +
> +	return 0;
> +
> + failwr:
> +	/* Disable interrupt. */
> +	writel(0, reg_base + CQSPI_REG_IRQMASK);
> +
> +	/* Cancel the indirect write */
> +	writel(CQSPI_REG_INDIRECTWR_CANCEL_MASK,
> +	       reg_base + CQSPI_REG_INDIRECTWR);
> +	return ret;
> +}
> +
> +static void cqspi_write(struct spi_nor *nor, loff_t to,
> +			size_t len, size_t *retlen, const u_char *buf)
> +{
> +	int ret;
> +
> +	ret = cqspi_indirect_write_setup(nor, to);
> +	if (ret == 0) {
> +		ret = cqspi_indirect_write_execute(nor, buf, len);
> +		if (ret == 0)
> +			*retlen += len;
> +	}
> +}
> +
> +static int cqspi_read(struct spi_nor *nor, loff_t from,
> +		      size_t len, size_t *retlen, u_char *buf)
> +{
> +	int ret;
> +
> +	ret = cqspi_indirect_read_setup(nor, from);
> +	if (ret == 0) {
> +		ret = cqspi_indirect_read_execute(nor, buf, len);
> +		if (ret == 0)
> +			*retlen += len;
> +	}
> +	return ret;
> +}
> +
> +static int cqspi_erase(struct spi_nor *nor, loff_t offs)
> +{
> +	int ret;
> +
> +	/* Send write enable, then erase commands. */
> +	ret = nor->write_reg(nor, SPINOR_OP_WREN, NULL, 0, 0);
> +	if (ret)
> +		return ret;
> +
> +	/* Set up command buffer. */
> +	ret = cqspi_command_write_addr(nor, nor->erase_opcode, offs);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static unsigned int calculate_ticks_for_ns(unsigned int ref_clk_hz,
> +					   unsigned int ns_val)
> +{
> +	unsigned int ticks;
> +
> +	ticks = ref_clk_hz;
> +	ticks /= 1000;
> +	ticks *= ns_val;
> +	ticks += 999999;
> +	ticks /= 1000000;
> +	return ticks;
> +}
> +
> +static void cqspi_delay(struct cqspi_st *cqspi,
> +			unsigned int ref_clk_hz, unsigned int sclk_hz)
> +{
> +	void __iomem *iobase = cqspi->iobase;
> +	struct cqspi_flash_pdata *f_pdata;
> +	unsigned int ref_clk_ns;
> +	unsigned int sclk_ns;
> +	unsigned int tshsl, tchsh, tslch, tsd2d;
> +	unsigned int reg;
> +	unsigned int tsclk;
> +
> +	f_pdata = &cqspi->f_pdata[cqspi->current_cs];
> +
> +	/* Convert to ns. */
> +	ref_clk_ns = NSEC_PER_SEC / ref_clk_hz;
> +
> +	/* Convert to ns. */
> +	sclk_ns = NSEC_PER_SEC / sclk_hz;
> +
> +	/* calculate the number of ref ticks for one sclk tick */
> +	tsclk = (ref_clk_hz + sclk_hz - 1) / sclk_hz;
> +
> +	tshsl = calculate_ticks_for_ns(ref_clk_hz, f_pdata->tshsl_ns);
> +	/* this particular value must be at least one sclk */
> +	if (tshsl < tsclk)
> +		tshsl = tsclk;
> +
> +	tchsh = calculate_ticks_for_ns(ref_clk_hz, f_pdata->tchsh_ns);
> +	tslch = calculate_ticks_for_ns(ref_clk_hz, f_pdata->tslch_ns);
> +	tsd2d = calculate_ticks_for_ns(ref_clk_hz, f_pdata->tsd2d_ns);
> +
> +	reg = ((tshsl & CQSPI_REG_DELAY_TSHSL_MASK)
> +	       << CQSPI_REG_DELAY_TSHSL_LSB);
> +	reg |= ((tchsh & CQSPI_REG_DELAY_TCHSH_MASK)
> +		<< CQSPI_REG_DELAY_TCHSH_LSB);
> +	reg |= ((tslch & CQSPI_REG_DELAY_TSLCH_MASK)
> +		<< CQSPI_REG_DELAY_TSLCH_LSB);
> +	reg |= ((tsd2d & CQSPI_REG_DELAY_TSD2D_MASK)
> +		<< CQSPI_REG_DELAY_TSD2D_LSB);
> +	writel(reg, iobase + CQSPI_REG_DELAY);
> +}
> +
> +static void cqspi_config_baudrate_div(struct cqspi_st *cqspi,
> +				      unsigned int ref_clk_hz,
> +				      unsigned int sclk_hz)
> +{
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int reg;
> +	unsigned int div;
> +
> +	reg = readl(reg_base + CQSPI_REG_CONFIG);
> +	reg &= ~(CQSPI_REG_CONFIG_BAUD_MASK << CQSPI_REG_CONFIG_BAUD_LSB);
> +
> +	div = ref_clk_hz / sclk_hz;
> +
> +	/* Recalculate the baudrate divisor based on QSPI specification. */
> +	if (div > 32)
> +		div = 32;
> +
> +	/* Check if even number. */
> +	if (div & 1)
> +		div = (div / 2);
> +	else
> +		div = (div / 2) - 1;
> +
> +	div = (div & CQSPI_REG_CONFIG_BAUD_MASK) << CQSPI_REG_CONFIG_BAUD_LSB;
> +	reg |= div;
> +	writel(reg, reg_base + CQSPI_REG_CONFIG);
> +}
> +
> +static void cqspi_readdata_capture(struct cqspi_st *cqspi,
> +				   unsigned int bypass, unsigned int delay)
> +{
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int reg;
> +
> +	reg = readl(reg_base + CQSPI_REG_READCAPTURE);
> +
> +	if (bypass)
> +		reg |= (1 << CQSPI_REG_READCAPTURE_BYPASS_LSB);
> +	else
> +		reg &= ~(1 << CQSPI_REG_READCAPTURE_BYPASS_LSB);
> +
> +	reg &= ~(CQSPI_REG_READCAPTURE_DELAY_MASK
> +		 << CQSPI_REG_READCAPTURE_DELAY_LSB);
> +
> +	reg |= ((delay & CQSPI_REG_READCAPTURE_DELAY_MASK)
> +		<< CQSPI_REG_READCAPTURE_DELAY_LSB);
> +
> +	writel(reg, reg_base + CQSPI_REG_READCAPTURE);
> +}
> +
> +static void cqspi_chipselect(struct cqspi_st *cqspi,
> +			     unsigned int chip_select,
> +			     unsigned int decoder_enable)
> +{
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int reg;
> +
> +	reg = readl(reg_base + CQSPI_REG_CONFIG);
> +	if (decoder_enable) {
> +		reg |= CQSPI_REG_CONFIG_DECODE_MASK;
> +	} else {
> +		reg &= ~CQSPI_REG_CONFIG_DECODE_MASK;
> +
> +		/* Convert CS if without decoder.
> +		 * CS0 to 4b'1110
> +		 * CS1 to 4b'1101
> +		 * CS2 to 4b'1011
> +		 * CS3 to 4b'0111
> +		 */
> +		chip_select = 0xF & ~(1 << chip_select);
> +	}
> +
> +	reg &= ~(CQSPI_REG_CONFIG_CHIPSELECT_MASK
> +		 << CQSPI_REG_CONFIG_CHIPSELECT_LSB);
> +	reg |= (chip_select & CQSPI_REG_CONFIG_CHIPSELECT_MASK)
> +	    << CQSPI_REG_CONFIG_CHIPSELECT_LSB;
> +	writel(reg, reg_base + CQSPI_REG_CONFIG);
> +}
> +
> +static void cqspi_controller_enable(struct cqspi_st *cqspi)
> +{
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int reg;
> +
> +	reg = readl(reg_base + CQSPI_REG_CONFIG);
> +	reg |= CQSPI_REG_CONFIG_ENABLE_MASK;
> +	writel(reg, reg_base + CQSPI_REG_CONFIG);
> +}
> +
> +static void cqspi_controller_disable(struct cqspi_st *cqspi)
> +{
> +	void __iomem *reg_base = cqspi->iobase;
> +	unsigned int reg;
> +
> +	reg = readl(reg_base + CQSPI_REG_CONFIG);
> +	reg &= ~CQSPI_REG_CONFIG_ENABLE_MASK;
> +	writel(reg, reg_base + CQSPI_REG_CONFIG);
> +}
> +
> +static void cqspi_switch_cs(struct cqspi_st *cqspi, unsigned int cs)
> +{
> +	unsigned int reg;
> +	struct cqspi_flash_pdata *f_pdata = &cqspi->f_pdata[cs];
> +	void __iomem *iobase = cqspi->iobase;
> +	struct spi_nor *nor = &f_pdata->nor;
> +
> +	cqspi_controller_disable(cqspi);
> +
> +	/* configure page size and block size. */
> +	reg = readl(iobase + CQSPI_REG_SIZE);
> +	reg &= ~(CQSPI_REG_SIZE_PAGE_MASK << CQSPI_REG_SIZE_PAGE_LSB);
> +	reg &= ~(CQSPI_REG_SIZE_BLOCK_MASK << CQSPI_REG_SIZE_BLOCK_LSB);
> +	reg |= (f_pdata->page_size << CQSPI_REG_SIZE_PAGE_LSB);
> +	reg |= (f_pdata->block_size << CQSPI_REG_SIZE_BLOCK_LSB);
> +	reg &= ~CQSPI_REG_SIZE_ADDRESS_MASK;
> +	reg |= (nor->addr_width - 1);
> +	writel(reg, iobase + CQSPI_REG_SIZE);
> +
> +	/* configure the chip select */
> +	cqspi_chipselect(cqspi, cs, cqspi->ext_decoder);
> +
> +	cqspi_controller_enable(cqspi);
> +}
> +
> +static int cqspi_prep(struct spi_nor *nor, enum spi_nor_ops ops)
> +{
> +	struct cqspi_st *cqspi = nor->priv;
> +	int cs = cqspi_find_chipselect(nor);
> +	struct cqspi_flash_pdata *f_pdata;
> +	unsigned int sclk;
> +
> +	/* Switch chip select. */
> +	if (cqspi->current_cs != cs) {
> +		cqspi->current_cs = cs;
> +		cqspi_switch_cs(cqspi, cs);
> +	}
> +
> +	/* Setup baudrate divisor and delays */
> +	f_pdata = &cqspi->f_pdata[cqspi->current_cs];
> +	sclk = f_pdata->clk_rate;
> +	if (cqspi->sclk != sclk) {
> +		cqspi->sclk = sclk;
> +		cqspi_controller_disable(cqspi);
> +		cqspi_config_baudrate_div(cqspi,
> +					  cqspi->master_ref_clk_hz, sclk);
> +		cqspi_delay(cqspi, cqspi->master_ref_clk_hz, sclk);
> +		cqspi_readdata_capture(cqspi, 1, f_pdata->read_delay);
> +		cqspi_controller_enable(cqspi);
> +	}
> +	return 0;
> +}
> +
> +static void cqspi_unprep(struct spi_nor *nor, enum spi_nor_ops ops)
> +{
> +}
> +
> +static int cqspi_read_reg(struct spi_nor *nor, u8 opcode, u8 *buf, int len)
> +{
> +	int ret;
> +
> +	cqspi_prep(nor, SPI_NOR_OPS_READ);
> +
> +	ret = cqspi_command_read(nor, &opcode, 1, buf, len);
> +	return ret;
> +}
> +
> +static int cqspi_write_reg(struct spi_nor *nor, u8 opcode, u8 *buf, int len,
> +			   int write_enable)
> +{
> +	int ret = 0;
> +
> +	cqspi_prep(nor, SPI_NOR_OPS_WRITE);
> +
> +	ret = cqspi_command_write(nor, opcode, buf, len);
> +	return ret;
> +}
> +
> +static int cqspi_of_get_flash_pdata(struct platform_device *pdev,
> +				    struct cqspi_flash_pdata *f_pdata,
> +				    struct device_node *np)
> +{
> +	if (of_property_read_u32(np, "cdns,page-size", &f_pdata->page_size)) {
> +		dev_err(&pdev->dev, "couldn't determine page-size\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "cdns,block-size", &f_pdata->block_size)) {
> +		dev_err(&pdev->dev, "couldn't determine block-size\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "cdns,read-delay", &f_pdata->read_delay)) {
> +		dev_err(&pdev->dev, "couldn't determine read-delay\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "cdns,tshsl-ns", &f_pdata->tshsl_ns)) {
> +		dev_err(&pdev->dev, "couldn't determine tshsl-ns\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "cdns,tsd2d-ns", &f_pdata->tsd2d_ns)) {
> +		dev_err(&pdev->dev, "couldn't determine tsd2d-ns\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "cdns,tchsh-ns", &f_pdata->tchsh_ns)) {
> +		dev_err(&pdev->dev, "couldn't determine tchsh-ns\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "cdns,tslch-ns", &f_pdata->tslch_ns)) {
> +		dev_err(&pdev->dev, "couldn't determine tslch-ns\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "spi-max-frequency", &f_pdata->clk_rate)) {
> +		dev_err(&pdev->dev, "couldn't determine spi-max-frequency\n");
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int cqspi_of_get_pdata(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct cqspi_st *cqspi = platform_get_drvdata(pdev);
> +
> +	if (of_property_read_u32(np, "ext-decoder", &cqspi->ext_decoder)) {
> +		dev_err(&pdev->dev, "couldn't determine ext-decoder\n");
> +		return -ENXIO;
> +	}
> +
> +	if (of_property_read_u32(np, "fifo-depth", &cqspi->fifo_depth)) {

Fifo-depth is something specific to this controller (not related to MTD or
spi-nor) so it should have a vendor prefix. On the other side, the property
is generic enough; and moreover:

$ git grep fifo-depth Documentation/devicetree/bindings

shows we are using 'fifo-depth' in other places.

However, 'ext-decoder' does look like something specific here. I think it would
be better to use it as a bool property, something like: "cdns,use-ext-decoder".
Lack of property, means no external decoder.

> +		dev_err(&pdev->dev, "couldn't determine fifo-depth\n");
> +		return -ENXIO;
> +	}
> +
> +	return 0;
> +}
> +


-- 
Ezequiel Garcia, VanguardiaSur
www.vanguardiasur.com.ar
