Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192AbaIHI3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:29:15 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:51276 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542AbaIHI3O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:29:14 -0400
X-Originating-IP: 50.43.15.134
Date: Mon, 8 Sep 2014 01:29:00 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-mtd@lists.infradead.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Huang Shijie <shijie8@gmail.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] mtd: denali: fix the format of comment blocks
Message-ID: <20140908082900.GA5361@thin>
References: <1410163813-31783-1-git-send-email-yamada.m@jp.panasonic.com>
 <1410163813-31783-2-git-send-email-yamada.m@jp.panasonic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410163813-31783-2-git-send-email-yamada.m@jp.panasonic.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 05:10:07PM +0900, Masahiro Yamada wrote:
> We should use
> /*
>  * Blah Blah ...
>  * ...
>  */
> 
> for multi-line comment blocks.
> 
> In addition, refactor some comments where it seems reasonable and
> remove some comments where the code is clear enough such as:
> 
>     /* clear interrupts */
>     clear_interrupts(denali);
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

All of the cases seem to match the preferred style; seems reasonable.

And thanks for applying the additional cleanup of removing entirely
unnecessary comments.

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

> 
>  drivers/mtd/nand/denali.c | 311 ++++++++++++++++++++++++++++------------------
>  1 file changed, 188 insertions(+), 123 deletions(-)
> 
> diff --git a/drivers/mtd/nand/denali.c b/drivers/mtd/nand/denali.c
> index da0fcc2..44a5f159 100644
> --- a/drivers/mtd/nand/denali.c
> +++ b/drivers/mtd/nand/denali.c
> @@ -29,7 +29,8 @@
>  
>  MODULE_LICENSE("GPL");
>  
> -/* We define a module parameter that allows the user to override
> +/*
> + * We define a module parameter that allows the user to override
>   * the hardware and decide what timing mode should be used.
>   */
>  #define NAND_DEFAULT_TIMINGS	-1
> @@ -41,8 +42,10 @@ MODULE_PARM_DESC(onfi_timing_mode, "Overrides default ONFI setting."
>  
>  #define DENALI_NAND_NAME    "denali-nand"
>  
> -/* We define a macro here that combines all interrupts this driver uses into
> - * a single constant value, for convenience. */
> +/*
> + * We define a macro here that combines all interrupts this driver uses into
> + * a single constant value, for convenience.
> + */
>  #define DENALI_IRQ_ALL	(INTR_STATUS__DMA_CMD_COMP | \
>  			INTR_STATUS__ECC_TRANSACTION_DONE | \
>  			INTR_STATUS__ECC_ERR | \
> @@ -54,23 +57,30 @@ MODULE_PARM_DESC(onfi_timing_mode, "Overrides default ONFI setting."
>  			INTR_STATUS__RST_COMP | \
>  			INTR_STATUS__ERASE_COMP)
>  
> -/* indicates whether or not the internal value for the flash bank is
> - * valid or not */
> +/*
> + * indicates whether or not the internal value for the flash bank is
> + * valid or not
> + */
>  #define CHIP_SELECT_INVALID	-1
>  
>  #define SUPPORT_8BITECC		1
>  
> -/* This macro divides two integers and rounds fractional values up
> - * to the nearest integer value. */
> +/*
> + * This macro divides two integers and rounds fractional values up
> + * to the nearest integer value.
> + */
>  #define CEIL_DIV(X, Y) (((X)%(Y)) ? ((X)/(Y)+1) : ((X)/(Y)))
>  
> -/* this macro allows us to convert from an MTD structure to our own
> +/*
> + * this macro allows us to convert from an MTD structure to our own
>   * device context (denali) structure.
>   */
>  #define mtd_to_denali(m) container_of(m, struct denali_nand_info, mtd)
>  
> -/* These constants are defined by the driver to enable common driver
> - * configuration options. */
> +/*
> + * These constants are defined by the driver to enable common driver
> + * configuration options.
> + */
>  #define SPARE_ACCESS		0x41
>  #define MAIN_ACCESS		0x42
>  #define MAIN_SPARE_ACCESS	0x43
> @@ -84,8 +94,10 @@ MODULE_PARM_DESC(onfi_timing_mode, "Overrides default ONFI setting."
>  #define ADDR_CYCLE	1
>  #define STATUS_CYCLE	2
>  
> -/* this is a helper macro that allows us to
> - * format the bank into the proper bits for the controller */
> +/*
> + * this is a helper macro that allows us to
> + * format the bank into the proper bits for the controller
> + */
>  #define BANK(x) ((x) << 24)
>  
>  /* forward declarations */
> @@ -96,12 +108,12 @@ static void denali_irq_enable(struct denali_nand_info *denali,
>  							uint32_t int_mask);
>  static uint32_t read_interrupt_status(struct denali_nand_info *denali);
>  
> -/* Certain operations for the denali NAND controller use
> - * an indexed mode to read/write data. The operation is
> - * performed by writing the address value of the command
> - * to the device memory followed by the data. This function
> +/*
> + * Certain operations for the denali NAND controller use an indexed mode to
> + * read/write data. The operation is performed by writing the address value
> + * of the command to the device memory followed by the data. This function
>   * abstracts this common operation.
> -*/
> + */
>  static void index_addr(struct denali_nand_info *denali,
>  				uint32_t address, uint32_t data)
>  {
> @@ -117,8 +129,10 @@ static void index_addr_read_data(struct denali_nand_info *denali,
>  	*pdata = ioread32(denali->flash_mem + 0x10);
>  }
>  
> -/* We need to buffer some data for some of the NAND core routines.
> - * The operations manage buffering that data. */
> +/*
> + * We need to buffer some data for some of the NAND core routines.
> + * The operations manage buffering that data.
> + */
>  static void reset_buf(struct denali_nand_info *denali)
>  {
>  	denali->buf.head = denali->buf.tail = 0;
> @@ -192,7 +206,8 @@ static uint16_t denali_nand_reset(struct denali_nand_info *denali)
>  	return PASS;
>  }
>  
> -/* this routine calculates the ONFI timing values for a given mode and
> +/*
> + * this routine calculates the ONFI timing values for a given mode and
>   * programs the clocking register accordingly. The mode is determined by
>   * the get_onfi_nand_para routine.
>   */
> @@ -298,9 +313,11 @@ static void nand_onfi_timing_set(struct denali_nand_info *denali,
>  static uint16_t get_onfi_nand_para(struct denali_nand_info *denali)
>  {
>  	int i;
> -	/* we needn't to do a reset here because driver has already
> +
> +	/*
> +	 * we needn't to do a reset here because driver has already
>  	 * reset all the banks before
> -	 * */
> +	 */
>  	if (!(ioread32(denali->flash_reg + ONFI_TIMING_MODE) &
>  		ONFI_TIMING_MODE__VALUE))
>  		return FAIL;
> @@ -313,8 +330,10 @@ static uint16_t get_onfi_nand_para(struct denali_nand_info *denali)
>  
>  	nand_onfi_timing_set(denali, i);
>  
> -	/* By now, all the ONFI devices we know support the page cache */
> -	/* rw feature. So here we enable the pipeline_rw_ahead feature */
> +	/*
> +	 * By now, all the ONFI devices we know support the page cache
> +	 * rw feature. So here we enable the pipeline_rw_ahead feature
> +	 */
>  	/* iowrite32(1, denali->flash_reg + CACHE_WRITE_ENABLE); */
>  	/* iowrite32(1, denali->flash_reg + CACHE_READ_ENABLE);  */
>  
> @@ -340,8 +359,10 @@ static void get_toshiba_nand_para(struct denali_nand_info *denali)
>  {
>  	uint32_t tmp;
>  
> -	/* Workaround to fix a controller bug which reports a wrong */
> -	/* spare area size for some kind of Toshiba NAND device */
> +	/*
> +	 * Workaround to fix a controller bug which reports a wrong
> +	 * spare area size for some kind of Toshiba NAND device
> +	 */
>  	if ((ioread32(denali->flash_reg + DEVICE_MAIN_AREA_SIZE) == 4096) &&
>  		(ioread32(denali->flash_reg + DEVICE_SPARE_AREA_SIZE) == 64)) {
>  		iowrite32(216, denali->flash_reg + DEVICE_SPARE_AREA_SIZE);
> @@ -391,7 +412,8 @@ static void get_hynix_nand_para(struct denali_nand_info *denali,
>  	}
>  }
>  
> -/* determines how many NAND chips are connected to the controller. Note for
> +/*
> + * determines how many NAND chips are connected to the controller. Note for
>   * Intel CE4100 devices we don't support more than one device.
>   */
>  static void find_valid_banks(struct denali_nand_info *denali)
> @@ -421,7 +443,8 @@ static void find_valid_banks(struct denali_nand_info *denali)
>  	}
>  
>  	if (denali->platform == INTEL_CE4100) {
> -		/* Platform limitations of the CE4100 device limit
> +		/*
> +		 * Platform limitations of the CE4100 device limit
>  		 * users to a single chip solution for NAND.
>  		 * Multichip support is not enabled.
>  		 */
> @@ -449,12 +472,13 @@ static void detect_max_banks(struct denali_nand_info *denali)
>  
>  static void detect_partition_feature(struct denali_nand_info *denali)
>  {
> -	/* For MRST platform, denali->fwblks represent the
> +	/*
> +	 * For MRST platform, denali->fwblks represent the
>  	 * number of blocks firmware is taken,
>  	 * FW is in protect partition and MTD driver has no
>  	 * permission to access it. So let driver know how many
>  	 * blocks it can't touch.
> -	 * */
> +	 */
>  	if (ioread32(denali->flash_reg + FEATURES) & FEATURES__PARTITION) {
>  		if ((ioread32(denali->flash_reg + PERM_SRC_ID(1)) &
>  			PERM_SRC_ID__SRCID) == SPECTRA_PARTITION_ID) {
> @@ -481,11 +505,11 @@ static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
>  			"%s, Line %d, Function: %s\n",
>  			__FILE__, __LINE__, __func__);
>  
> -	/* Use read id method to get device ID and other
> -	 * params. For some NAND chips, controller can't
> -	 * report the correct device ID by reading from
> -	 * DEVICE_ID register
> -	 * */
> +	/*
> +	 * Use read id method to get device ID and other params.
> +	 * For some NAND chips, controller can't report the correct
> +	 * device ID by reading from DEVICE_ID register
> +	 */
>  	addr = (uint32_t)MODE_11 | BANK(denali->flash_bank);
>  	index_addr(denali, (uint32_t)addr | 0, 0x90);
>  	index_addr(denali, (uint32_t)addr | 1, 0);
> @@ -524,7 +548,8 @@ static uint16_t denali_nand_timing_set(struct denali_nand_info *denali)
>  
>  	detect_partition_feature(denali);
>  
> -	/* If the user specified to override the default timings
> +	/*
> +	 * If the user specified to override the default timings
>  	 * with a specific ONFI mode, we apply those changes here.
>  	 */
>  	if (onfi_timing_mode != NAND_DEFAULT_TIMINGS)
> @@ -545,7 +570,8 @@ static void denali_set_intr_modes(struct denali_nand_info *denali,
>  		iowrite32(0, denali->flash_reg + GLOBAL_INT_ENABLE);
>  }
>  
> -/* validation function to verify that the controlling software is making
> +/*
> + * validation function to verify that the controlling software is making
>   * a valid request
>   */
>  static inline bool is_flash_bank_valid(int flash_bank)
> @@ -585,7 +611,8 @@ static void denali_irq_enable(struct denali_nand_info *denali,
>  		iowrite32(int_mask, denali->flash_reg + INTR_EN(i));
>  }
>  
> -/* This function only returns when an interrupt that this driver cares about
> +/*
> + * This function only returns when an interrupt that this driver cares about
>   * occurs. This is to reduce the overhead of servicing interrupts
>   */
>  static inline uint32_t denali_irq_detected(struct denali_nand_info *denali)
> @@ -625,9 +652,9 @@ static uint32_t read_interrupt_status(struct denali_nand_info *denali)
>  	return ioread32(denali->flash_reg + intr_status_reg);
>  }
>  
> -/* This is the interrupt service routine. It handles all interrupts
> - * sent to this device. Note that on CE4100, this is a shared
> - * interrupt.
> +/*
> + * This is the interrupt service routine. It handles all interrupts
> + * sent to this device. Note that on CE4100, this is a shared interrupt.
>   */
>  static irqreturn_t denali_isr(int irq, void *dev_id)
>  {
> @@ -637,19 +664,21 @@ static irqreturn_t denali_isr(int irq, void *dev_id)
>  
>  	spin_lock(&denali->irq_lock);
>  
> -	/* check to see if a valid NAND chip has
> -	 * been selected.
> -	 */
> +	/* check to see if a valid NAND chip has been selected. */
>  	if (is_flash_bank_valid(denali->flash_bank)) {
> -		/* check to see if controller generated
> -		 * the interrupt, since this is a shared interrupt */
> +		/*
> +		 * check to see if controller generated the interrupt,
> +		 * since this is a shared interrupt
> +		 */
>  		irq_status = denali_irq_detected(denali);
>  		if (irq_status != 0) {
>  			/* handle interrupt */
>  			/* first acknowledge it */
>  			clear_interrupt(denali, irq_status);
> -			/* store the status in the device context for someone
> -			   to read */
> +			/*
> +			 * store the status in the device context for someone
> +			 * to read
> +			 */
>  			denali->irq_status |= irq_status;
>  			/* notify anyone who cares that it happened */
>  			complete(&denali->complete);
> @@ -681,8 +710,10 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
>  			/* our interrupt was detected */
>  			break;
>  		} else {
> -			/* these are not the interrupts you are looking for -
> -			 * need to wait again */
> +			/*
> +			 * these are not the interrupts you are looking for -
> +			 * need to wait again
> +			 */
>  			spin_unlock_irq(&denali->irq_lock);
>  			retry = true;
>  		}
> @@ -698,8 +729,10 @@ static uint32_t wait_for_irq(struct denali_nand_info *denali, uint32_t irq_mask)
>  	return intr_status;
>  }
>  
> -/* This helper function setups the registers for ECC and whether or not
> - * the spare area will be transferred. */
> +/*
> + * This helper function setups the registers for ECC and whether or not
> + * the spare area will be transferred.
> + */
>  static void setup_ecc_for_xfer(struct denali_nand_info *denali, bool ecc_en,
>  				bool transfer_spare)
>  {
> @@ -715,7 +748,8 @@ static void setup_ecc_for_xfer(struct denali_nand_info *denali, bool ecc_en,
>  			denali->flash_reg + TRANSFER_SPARE_REG);
>  }
>  
> -/* sends a pipeline command operation to the controller. See the Denali NAND
> +/*
> + * sends a pipeline command operation to the controller. See the Denali NAND
>   * controller's user guide for more information (section 4.2.3.6).
>   */
>  static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
> @@ -737,7 +771,6 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
>  
>  	setup_ecc_for_xfer(denali, ecc_en, transfer_spare);
>  
> -	/* clear interrupts */
>  	clear_interrupts(denali);
>  
>  	addr = BANK(denali->flash_bank) | denali->page;
> @@ -757,9 +790,10 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
>  		cmd = MODE_10 | addr;
>  		index_addr(denali, (uint32_t)cmd, access_type);
>  
> -		/* page 33 of the NAND controller spec indicates we should not
> -		   use the pipeline commands in Spare area only mode. So we
> -		   don't.
> +		/*
> +		 * page 33 of the NAND controller spec indicates we should not
> +		 * use the pipeline commands in Spare area only mode.
> +		 * So we don't.
>  		 */
>  		if (access_type == SPARE_ACCESS) {
>  			cmd = MODE_01 | addr;
> @@ -768,10 +802,11 @@ static int denali_send_pipeline_cmd(struct denali_nand_info *denali,
>  			index_addr(denali, (uint32_t)cmd,
>  					PIPELINE_ACCESS | op | page_count);
>  
> -			/* wait for command to be accepted
> +			/*
> +			 * wait for command to be accepted
>  			 * can always use status0 bit as the
> -			 * mask is identical for each
> -			 * bank. */
> +			 * mask is identical for each bank.
> +			 */
>  			irq_status = wait_for_irq(denali, irq_mask);
>  
>  			if (irq_status == 0) {
> @@ -796,8 +831,10 @@ static int write_data_to_flash_mem(struct denali_nand_info *denali,
>  {
>  	uint32_t i = 0, *buf32;
>  
> -	/* verify that the len is a multiple of 4. see comment in
> -	 * read_data_from_flash_mem() */
> +	/*
> +	 * verify that the len is a multiple of 4.
> +	 * see comment in read_data_from_flash_mem()
> +	 */
>  	BUG_ON((len % 4) != 0);
>  
>  	/* write the data to the flash memory */
> @@ -814,14 +851,12 @@ static int read_data_from_flash_mem(struct denali_nand_info *denali,
>  {
>  	uint32_t i = 0, *buf32;
>  
> -	/* we assume that len will be a multiple of 4, if not
> -	 * it would be nice to know about it ASAP rather than
> -	 * have random failures...
> -	 * This assumption is based on the fact that this
> -	 * function is designed to be used to read flash pages,
> -	 * which are typically multiples of 4...
> +	/*
> +	 * we assume that len will be a multiple of 4, if not it would be nice
> +	 * to know about it ASAP rather than have random failures...
> +	 * This assumption is based on the fact that this function is designed
> +	 * to be used to read flash pages, which are typically multiples of 4.
>  	 */
> -
>  	BUG_ON((len % 4) != 0);
>  
>  	/* transfer the data from the flash */
> @@ -873,16 +908,19 @@ static void read_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
>  							DENALI_READ) == PASS) {
>  		read_data_from_flash_mem(denali, buf, mtd->oobsize);
>  
> -		/* wait for command to be accepted
> -		 * can always use status0 bit as the mask is identical for each
> -		 * bank. */
> +		/*
> +		 * wait for command to be accepted
> +		 * can always use status0 bit as the
> +		 * mask is identical for each bank.
> +		 */
>  		irq_status = wait_for_irq(denali, irq_mask);
>  
>  		if (irq_status == 0)
>  			dev_err(denali->dev, "page on OOB timeout %d\n",
>  					denali->page);
>  
> -		/* We set the device back to MAIN_ACCESS here as I observed
> +		/*
> +		 * We set the device back to MAIN_ACCESS here as I observed
>  		 * instability with the controller if you do a block erase
>  		 * and the last transaction was a SPARE_ACCESS. Block erase
>  		 * is reliable (according to the MTD test infrastructure)
> @@ -894,7 +932,8 @@ static void read_oob_data(struct mtd_info *mtd, uint8_t *buf, int page)
>  	}
>  }
>  
> -/* this function examines buffers to see if they contain data that
> +/*
> + * this function examines buffers to see if they contain data that
>   * indicate that the buffer is part of an erased region of flash.
>   */
>  static bool is_erased(uint8_t *buf, int len)
> @@ -940,13 +979,14 @@ static bool handle_ecc(struct denali_nand_info *denali, uint8_t *buf,
>  			err_device = ECC_ERR_DEVICE(err_correction_info);
>  
>  			if (ECC_ERROR_CORRECTABLE(err_correction_info)) {
> -				/* If err_byte is larger than ECC_SECTOR_SIZE,
> +				/*
> +				 * If err_byte is larger than ECC_SECTOR_SIZE,
>  				 * means error happened in OOB, so we ignore
>  				 * it. It's no need for us to correct it
>  				 * err_device is represented the NAND error
>  				 * bits are happened in if there are more
>  				 * than one NAND connected.
> -				 * */
> +				 */
>  				if (err_byte < ECC_SECTOR_SIZE) {
>  					int offset;
>  					offset = (err_sector *
> @@ -960,17 +1000,19 @@ static bool handle_ecc(struct denali_nand_info *denali, uint8_t *buf,
>  					bitflips++;
>  				}
>  			} else {
> -				/* if the error is not correctable, need to
> +				/*
> +				 * if the error is not correctable, need to
>  				 * look at the page to see if it is an erased
>  				 * page. if so, then it's not a real ECC error
> -				 * */
> +				 */
>  				check_erased_page = true;
>  			}
>  		} while (!ECC_LAST_ERR(err_correction_info));
> -		/* Once handle all ecc errors, controller will triger
> +		/*
> +		 * Once handle all ecc errors, controller will triger
>  		 * a ECC_TRANSACTION_DONE interrupt, so here just wait
>  		 * for a while for this interrupt
> -		 * */
> +		 */
>  		while (!(read_interrupt_status(denali) &
>  				INTR_STATUS__ECC_TRANSACTION_DONE))
>  			cpu_relax();
> @@ -1013,12 +1055,14 @@ static void denali_setup_dma(struct denali_nand_info *denali, int op)
>  	/* 3. set memory low address bits 23:8 */
>  	index_addr(denali, mode | ((uint16_t)addr << 8), 0x2300);
>  
> -	/* 4.  interrupt when complete, burst len = 64 bytes*/
> +	/* 4. interrupt when complete, burst len = 64 bytes */
>  	index_addr(denali, mode | 0x14000, 0x2400);
>  }
>  
> -/* writes a page. user specifies type, and this function handles the
> - * configuration details. */
> +/*
> + * writes a page. user specifies type, and this function handles the
> + * configuration details.
> + */
>  static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
>  			const uint8_t *buf, bool raw_xfer)
>  {
> @@ -1031,8 +1075,8 @@ static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
>  	uint32_t irq_mask = INTR_STATUS__DMA_CMD_COMP |
>  						INTR_STATUS__PROGRAM_FAIL;
>  
> -	/* if it is a raw xfer, we want to disable ecc, and send
> -	 * the spare area.
> +	/*
> +	 * if it is a raw xfer, we want to disable ecc and send the spare area.
>  	 * !raw_xfer - enable ecc
>  	 * raw_xfer - transfer spare
>  	 */
> @@ -1075,27 +1119,33 @@ static int write_page(struct mtd_info *mtd, struct nand_chip *chip,
>  
>  /* NAND core entry points */
>  
> -/* this is the callback that the NAND core calls to write a page. Since
> +/*
> + * this is the callback that the NAND core calls to write a page. Since
>   * writing a page with ECC or without is similar, all the work is done
>   * by write_page above.
> - * */
> + */
>  static int denali_write_page(struct mtd_info *mtd, struct nand_chip *chip,
>  				const uint8_t *buf, int oob_required)
>  {
> -	/* for regular page writes, we let HW handle all the ECC
> -	 * data written to the device. */
> +	/*
> +	 * for regular page writes, we let HW handle all the ECC
> +	 * data written to the device.
> +	 */
>  	return write_page(mtd, chip, buf, false);
>  }
>  
> -/* This is the callback that the NAND core calls to write a page without ECC.
> +/*
> + * This is the callback that the NAND core calls to write a page without ECC.
>   * raw access is similar to ECC page writes, so all the work is done in the
>   * write_page() function above.
>   */
>  static int denali_write_page_raw(struct mtd_info *mtd, struct nand_chip *chip,
>  					const uint8_t *buf, int oob_required)
>  {
> -	/* for raw page writes, we want to disable ECC and simply write
> -	   whatever data is in the buffer. */
> +	/*
> +	 * for raw page writes, we want to disable ECC and simply write
> +	 * whatever data is in the buffer.
> +	 */
>  	return write_page(mtd, chip, buf, true);
>  }
>  
> @@ -1240,7 +1290,6 @@ static int denali_erase(struct mtd_info *mtd, int page)
>  
>  	uint32_t cmd = 0x0, irq_status = 0;
>  
> -	/* clear interrupts */
>  	clear_interrupts(denali);
>  
>  	/* setup page read request for access type */
> @@ -1270,10 +1319,11 @@ static void denali_cmdfunc(struct mtd_info *mtd, unsigned int cmd, int col,
>  	case NAND_CMD_READID:
>  	case NAND_CMD_PARAM:
>  		reset_buf(denali);
> -		/*sometimes ManufactureId read from register is not right
> +		/*
> +		 * sometimes ManufactureId read from register is not right
>  		 * e.g. some of Micron MT29F32G08QAA MLC NAND chips
>  		 * So here we send READID cmd to NAND insteand
> -		 * */
> +		 */
>  		addr = (uint32_t)MODE_11 | BANK(denali->flash_bank);
>  		index_addr(denali, (uint32_t)addr | 0, 0x90);
>  		index_addr(denali, (uint32_t)addr | 1, 0);
> @@ -1333,11 +1383,12 @@ static void denali_ecc_hwctl(struct mtd_info *mtd, int mode)
>  /* Initialization code to bring the device up to a known good state */
>  static void denali_hw_init(struct denali_nand_info *denali)
>  {
> -	/* tell driver how many bit controller will skip before
> +	/*
> +	 * tell driver how many bit controller will skip before
>  	 * writing ECC code in OOB, this register may be already
>  	 * set by firmware. So we read this value out.
>  	 * if this value is 0, just let it be.
> -	 * */
> +	 */
>  	denali->bbtskipbytes = ioread32(denali->flash_reg +
>  						SPARE_AREA_SKIP_BYTES);
>  	detect_max_banks(denali);
> @@ -1355,10 +1406,11 @@ static void denali_hw_init(struct denali_nand_info *denali)
>  	denali_irq_init(denali);
>  }
>  
> -/* Althogh controller spec said SLC ECC is forceb to be 4bit,
> +/*
> + * Althogh controller spec said SLC ECC is forceb to be 4bit,
>   * but denali controller in MRST only support 15bit and 8bit ECC
>   * correction
> - * */
> + */
>  #define ECC_8BITS	14
>  static struct nand_ecclayout nand_8bit_oob = {
>  	.eccbytes = 14,
> @@ -1398,13 +1450,16 @@ static void denali_drv_init(struct denali_nand_info *denali)
>  	denali->idx = 0;
>  
>  	/* setup interrupt handler */
> -	/* the completion object will be used to notify
> -	 * the callee that the interrupt is done */
> +	/*
> +	 * the completion object will be used to notify
> +	 * the callee that the interrupt is done
> +	 */
>  	init_completion(&denali->complete);
>  
> -	/* the spinlock will be used to synchronize the ISR
> -	 * with any element that might be access shared
> -	 * data (interrupt status) */
> +	/*
> +	 * the spinlock will be used to synchronize the ISR with any
> +	 * element that might be access shared data (interrupt status)
> +	 */
>  	spin_lock_init(&denali->irq_lock);
>  
>  	/* indicate that MTD has not selected a valid bank yet */
> @@ -1419,7 +1474,8 @@ int denali_init(struct denali_nand_info *denali)
>  	int ret;
>  
>  	if (denali->platform == INTEL_CE4100) {
> -		/* Due to a silicon limitation, we can only support
> +		/*
> +		 * Due to a silicon limitation, we can only support
>  		 * ONFI timing mode 1 and below.
>  		 */
>  		if (onfi_timing_mode < -1 || onfi_timing_mode > 1) {
> @@ -1438,8 +1494,10 @@ int denali_init(struct denali_nand_info *denali)
>  	denali_hw_init(denali);
>  	denali_drv_init(denali);
>  
> -	/* denali_isr register is done after all the hardware
> -	 * initilization is finished*/
> +	/*
> +	 * denali_isr register is done after all the hardware
> +	 * initilization is finished
> +	 */
>  	if (request_irq(denali->irq, denali_isr, IRQF_SHARED,
>  			DENALI_NAND_NAME, denali)) {
>  		pr_err("Spectra: Unable to allocate IRQ\n");
> @@ -1458,9 +1516,11 @@ int denali_init(struct denali_nand_info *denali)
>  	denali->nand.read_byte = denali_read_byte;
>  	denali->nand.waitfunc = denali_waitfunc;
>  
> -	/* scan for NAND devices attached to the controller
> +	/*
> +	 * scan for NAND devices attached to the controller
>  	 * this is the first stage in a two step process to register
> -	 * with the nand subsystem */
> +	 * with the nand subsystem
> +	 */
>  	if (nand_scan_ident(&denali->mtd, denali->max_banks, NULL)) {
>  		ret = -ENXIO;
>  		goto failed_req_irq;
> @@ -1492,10 +1552,10 @@ int denali_init(struct denali_nand_info *denali)
>  		goto failed_req_irq;
>  	}
>  
> -	/* support for multi nand
> -	 * MTD known nothing about multi nand,
> -	 * so we should tell it the real pagesize
> -	 * and anything necessery
> +	/*
> +	 * support for multi nand
> +	 * MTD known nothing about multi nand, so we should tell it
> +	 * the real pagesize and anything necessery
>  	 */
>  	denali->devnum = ioread32(denali->flash_reg + DEVICES_CONNECTED);
>  	denali->nand.chipsize <<= (denali->devnum - 1);
> @@ -1511,9 +1571,11 @@ int denali_init(struct denali_nand_info *denali)
>  	denali->mtd.size = denali->nand.numchips * denali->nand.chipsize;
>  	denali->bbtskipbytes *= denali->devnum;
>  
> -	/* second stage of the NAND scan
> +	/*
> +	 * second stage of the NAND scan
>  	 * this stage requires information regarding ECC and
> -	 * bad block management. */
> +	 * bad block management.
> +	 */
>  
>  	/* Bad block management */
>  	denali->nand.bbt_td = &bbt_main_descr;
> @@ -1524,7 +1586,8 @@ int denali_init(struct denali_nand_info *denali)
>  	denali->nand.options |= NAND_SKIP_BBTSCAN;
>  	denali->nand.ecc.mode = NAND_ECC_HW_SYNDROME;
>  
> -	/* Denali Controller only support 15bit and 8bit ECC in MRST,
> +	/*
> +	 * Denali Controller only support 15bit and 8bit ECC in MRST,
>  	 * so just let controller do 15bit ECC for MLC and 8bit ECC for
>  	 * SLC if possible.
>  	 * */
> @@ -1560,18 +1623,20 @@ int denali_init(struct denali_nand_info *denali)
>  		denali->mtd.oobsize - denali->nand.ecc.layout->eccbytes -
>  		denali->bbtskipbytes;
>  
> -	/* Let driver know the total blocks number and
> -	 * how many blocks contained by each nand chip.
> -	 * blksperchip will help driver to know how many
> -	 * blocks is taken by FW.
> -	 * */
> +	/*
> +	 * Let driver know the total blocks number and how many blocks
> +	 * contained by each nand chip. blksperchip will help driver to
> +	 * know how many blocks is taken by FW.
> +	 */
>  	denali->totalblks = denali->mtd.size >>
>  				denali->nand.phys_erase_shift;
>  	denali->blksperchip = denali->totalblks / denali->nand.numchips;
>  
> -	/* These functions are required by the NAND core framework, otherwise,
> +	/*
> +	 * These functions are required by the NAND core framework, otherwise,
>  	 * the NAND core will assert. However, we don't need them, so we'll stub
> -	 * them out. */
> +	 * them out.
> +	 */
>  	denali->nand.ecc.calculate = denali_ecc_calculate;
>  	denali->nand.ecc.correct = denali_ecc_correct;
>  	denali->nand.ecc.hwctl = denali_ecc_hwctl;
> -- 
> 1.9.1
> 
