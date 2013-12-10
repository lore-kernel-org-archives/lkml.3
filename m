Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3LJTBK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:01:10 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:46034 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab3LJTBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:01:05 -0500
Date: Tue, 10 Dec 2013 11:01:00 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 03/36] mtd: st_spi_fsm: Initialise and configure the
 FSM for normal working conditions
Message-ID: <20131210190100.GA27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Fri, Nov 29, 2013 at 12:18:52PM +0000, Lee Jones wrote:
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -25,11 +25,121 @@
>  
>  #include "st_spi_fsm.h"
>  
> +static inline uint32_t stfsm_fifo_available(struct stfsm *fsm)
> +{
> +	return (readl(fsm->base + SPI_FAST_SEQ_STA) >> 5) & 0x7f;
> +}
> +
> +static void stfsm_clear_fifo(struct stfsm *fsm)
> +{
> +	uint32_t avail;
> +
> +	for (;;) {
> +		avail = stfsm_fifo_available(fsm);
> +		if (!avail)
> +			break;
> +
> +		while (avail) {
> +			readl(fsm->base + SPI_FAST_SEQ_DATA_REG);
> +			avail--;
> +		}
> +	}
> +}
> +
> +static int stfsm_set_mode(struct stfsm *fsm, uint32_t mode)
> +{
> +	int ret, timeout = 10;
> +
> +	/* Wait for controller to accept mode change */
> +	while(--timeout) {

s/while(/while (/

You should run your series through scripts/checkpatch.pl. There are a
number of small things to fixup in a few of your patches.

> +		ret = readl(fsm->base + SPI_STA_MODE_CHANGE);
> +		if (ret & 0x1)
> +			break;
> +		udelay(1);
> +	}
> +
> +	if (!timeout)
> +		return -EBUSY;
> +
> +	writel(mode, fsm->base + SPI_MODESELECT);
> +
> +	return 0;
> +}
> +
> +static void stfsm_set_freq(struct stfsm *fsm, uint32_t spi_freq)
> +{
> +	uint32_t emi_freq;
> +	uint32_t clk_div;
> +
> +	/* TODO: Make this dynamic */
> +	emi_freq = STFSM_DEFAULT_EMI_FREQ;
> +
> +	/*
> +	 * Calculate clk_div - values between 2 and 128
> +	 * Multiple of 2, rounded up
> +	 */
> +	clk_div = 2*((emi_freq + (2*spi_freq - 1))/(2*spi_freq));

I think this can use the <linux/kerne.h> round_up() macro. Also, you're
missing some spacing. Possibly:

	clk_div = 2 * round_up(emi_freq, 2 * spi_freq);

> +	if (clk_div < 2)
> +		clk_div = 2;
> +	else if (clk_div > 128)
> +		clk_div = 128;
> +
> +	/*
> +	 * Determine a suitable delay for the IP to complete a change of
> +	 * direction of the FIFO. The required delay is related to the clock
> +	 * divider used. The following heuristics are based on empirical tests,
> +	 * using a 100MHz EMI clock.
> +	 */
> +	if (clk_div <= 4)
> +		fsm->fifo_dir_delay = 0;
> +	else if (clk_div <= 10)
> +		fsm->fifo_dir_delay = 1;
> +	else
> +		fsm->fifo_dir_delay = (clk_div + 9) / 10;

round_down()?

> +
> +	dev_dbg(fsm->dev, "emi_clk = %uHZ, spi_freq = %uHZ, clk_div = %u\n",
> +		emi_freq, spi_freq, clk_div);
> +
> +	writel(clk_div, fsm->base + SPI_CLOCKDIV);
> +}

Brian
