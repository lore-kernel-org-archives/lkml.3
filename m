Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab3LJUTt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 15:19:49 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:40171 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab3LJUTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 15:19:48 -0500
Date: Tue, 10 Dec 2013 12:19:43 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 04/36] mtd: st_spi_fsm: Supply framework for device
 requests
Message-ID: <20131210201943.GC27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-5-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-5-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:18:53PM +0000, Lee Jones wrote:
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -46,6 +51,36 @@ static void stfsm_clear_fifo(struct stfsm *fsm)
>  	}
>  }
>  
> +static inline void stfsm_load_seq(struct stfsm *fsm,
> +				  const struct stfsm_seq *seq)
> +{
> +	void __iomem *dst = fsm->base + SPI_FAST_SEQ_TRANSFER_SIZE;
> +	const uint32_t *src = (const uint32_t *)seq;
> +	int words = STFSM_SEQ_SIZE / sizeof(uint32_t);

I think this is clearer as:

	int words = sizeof(*seq) / sizeof(*src);

> +
> +	BUG_ON(!stfsm_is_idle(fsm));
> +
> +	while (words--) {
> +		writel(*src, dst);
> +		src++;
> +		dst += 4;
> +	}
> +}
> +
> +static void stfsm_wait_seq(struct stfsm *fsm)
> +{
> +	unsigned long timeo = jiffies + HZ;
> +
> +	while (time_before(jiffies, timeo)) {
> +		if (stfsm_is_idle(fsm))
> +			return;
> +
> +		cond_resched();
> +	}
> +
> +	dev_err(fsm->dev, "timeout on sequence completion\n");

I believe the timeout logic is incorrect. What if we wait a "long time"
to call stfsm_wait_seq() (due to scheduling, or otherwise)? Then the
while loop might not even run once (time_before(x, y) is false). Or what
if cond_resched() waits for a long time...

So you need an extra check of stfsm_is_idle() after the while loop,
before you declare a timeout.

> +}
> +
>  static int stfsm_set_mode(struct stfsm *fsm, uint32_t mode)
>  {
>  	int ret, timeout = 10;
> diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
> index 4e92e58..6164142 100644
> --- a/drivers/mtd/devices/st_spi_fsm.h
> +++ b/drivers/mtd/devices/st_spi_fsm.h
> @@ -199,4 +199,18 @@ struct stfsm {
>  	uint32_t		fifo_dir_delay;
>  };
>  
> +struct stfsm_seq {
> +	uint32_t data_size;
> +	uint32_t addr1;
> +	uint32_t addr2;
> +	uint32_t addr_cfg;
> +	uint32_t seq_opc[5];
> +	uint32_t mode;
> +	uint32_t dummy;
> +	uint32_t status;
> +	uint8_t  seq[16];
> +	uint32_t seq_cfg;
> +} __attribute__((__packed__, aligned(4)));

I think checkpatch.pl prefers these attributes use the kernel macros:

  struct stfsm_seq {
  ...
  } __packed __aligned(4);

> +#define STFSM_SEQ_SIZE sizeof(struct stfsm_seq)

If you agree with my earlier comment, you won't need this macro.

> +
>  #endif	/* ST_SPI_FSM_H */

Brian
