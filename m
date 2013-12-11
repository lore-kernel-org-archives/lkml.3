Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751785Ab3LKCNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:13:17 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:35585 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab3LKCNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:13:15 -0500
Date: Tue, 10 Dec 2013 18:13:11 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 28/36] mtd: st_spi_fsm: Supply a busy wait for
 post-write status
Message-ID: <20131211021311.GM27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-29-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-29-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:19:17PM +0000, Lee Jones wrote:
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -292,6 +308,42 @@ static int stfsm_enter_32bit_addr(struct stfsm *fsm, int enter)
>  	return 0;
>  }
>  
> +static uint8_t stfsm_wait_busy(struct stfsm *fsm)
> +{
> +	struct stfsm_seq *seq = &stfsm_seq_read_status_fifo;
> +	unsigned long deadline;
> +	uint32_t status;
> +
> +	/* Use RDRS1 */
> +	seq->seq_opc[0] = (SEQ_OPC_PADS_1 |
> +			   SEQ_OPC_CYCLES(8) |
> +			   SEQ_OPC_OPCODE(FLASH_CMD_RDSR));
> +
> +	/* Load read_status sequence */
> +	stfsm_load_seq(fsm, seq);
> +
> +	/* Repeat until busy bit is deasserted, or timeout */
> +	deadline = jiffies + FLASH_MAX_BUSY_WAIT;
> +	do {
> +		cond_resched();
> +
> +		stfsm_wait_seq(fsm);
> +
> +		stfsm_read_fifo(fsm, &status, 4);
> +
> +		if ((status & FLASH_STATUS_BUSY) == 0)
> +			return 0;
> +
> +		/* Restart */
> +		writel(seq->seq_cfg, fsm->base + SPI_FAST_SEQ_CFG);
> +
> +	} while (!time_after_eq(jiffies, deadline));

You have a timeout problem here, similar to the one I mentioned earlier,
except that in this one, your do/while at least ensures that you always
run the loop at least once... but still, what if "a long time" elapses
between stfsm_read_fifo() and checking time_after_eq()?

I think you want something like this after the while():

	stfsm_read_fifo(fsm, &status, 4);
	if ((status & FLASH_STATUS_BUSY) == 0)
		return 0;

> +	dev_err(fsm->dev, "timeout on wait_busy\n");
> +
> +	return -EIO;
> +}
> +
>  static int stfsm_wrvcr(struct stfsm *fsm, uint8_t data)
>  {
>  	struct stfsm_seq *seq = &stfsm_seq_wrvcr;

Brian
