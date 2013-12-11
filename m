Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab3LKBGm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 20:06:42 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:34592 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989Ab3LKBGl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 20:06:41 -0500
Date: Tue, 10 Dec 2013 17:06:36 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 11/36] mtd: st_spi_fsm: Search for preferred FSM
 message sequence configurations
Message-ID: <20131211010636.GH27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-12-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-12-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:19:00PM +0000, Lee Jones wrote:
> Here we provide a means to traverse though all supplied FSM message
> sequence configurations and pick one based on our chip's capabilities.
> The first one we match will be the preferred one, as they are
> presented in order of preference.

This process sounds very much like something that is needed for other
controllers: a way to match controller capabilties with the opcodes
supported by the flash. But it still isn't quite flexible enough for
others, because it doesn't try to abstract the selection criteria -- it
just uses lists that you presorted, with exceptions for a few different
types of devices (I'm referring to a later patch now, I guess, since
this patch actually has no users for stfsm_search_seq_rw_configs() yet).

> ---
>  drivers/mtd/devices/st_spi_fsm.c | 15 +++++++++++++++
>  drivers/mtd/devices/st_spi_fsm.h | 12 ++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index ef177e5..5f21d14 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -124,6 +124,21 @@ static void stfsm_read_fifo(struct stfsm *fsm, uint32_t *buf,
>  	}
>  }
>  
> +/* Search for preferred configuration based on available flags */
> +static struct seq_rw_config *
> +stfsm_search_seq_rw_configs(struct stfsm *fsm,
> +			    struct seq_rw_config cfgs[])
> +{
> +	struct seq_rw_config *config;
> +	int flags = fsm->info->flags;
> +
> +	for (config = cfgs; cfgs->cmd != 0; config++)

This becomes an infinite loop if you can't find a matching config. You
probably meant 'config->cmd != 0':

	for (config = cfgs; config->cmd != 0; config++)

> +		if ((config->flags & flags) == config->flags)
> +			return config;
> +
> +	return NULL;
> +}
> +
>  static void stfsm_read_jedec(struct stfsm *fsm, uint8_t *const jedec)
>  {
>  	const struct stfsm_seq *seq = &stfsm_seq_read_jedec;
> diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
> index 0a6272c..6fafa07 100644
> --- a/drivers/mtd/devices/st_spi_fsm.h
> +++ b/drivers/mtd/devices/st_spi_fsm.h
> @@ -254,6 +254,18 @@ struct stfsm_seq {
>  } __attribute__((__packed__, aligned(4)));
>  #define STFSM_SEQ_SIZE sizeof(struct stfsm_seq)
>  
> +/* Parameters to configure a READ or WRITE FSM sequence */
> +struct seq_rw_config {
> +	uint32_t	flags;		/* flags to support config */
> +	uint8_t		cmd;		/* FLASH command */
> +	int		write;		/* Write Sequence */
> +	uint8_t		addr_pads;	/* No. of addr pads (MODE & DUMMY) */
> +	uint8_t		data_pads;	/* No. of data pads */

"pads" means "pins" here, right?

> +	uint8_t		mode_data;	/* MODE data */

What does this represent? As far as I can see, all the configurations
you provide so far have this entry as 0x00.

> +	uint8_t		mode_cycles;	/* No. of MODE cycles */

What are MODE cycles? (Sorry if these are dumb questions.)

> +	uint8_t		dummy_cycles;	/* No. of DUMMY cycles */
> +};

Several pieces of this sequence struct seems suspiciously similar to
what would be needed by several other controllers, while the remaining
pieces don't seem to be so special that they cannot be configured
beneath a SPI NOR framework. I'm becoming less convinced that your
controller/driver is as unique as you say it is.

> +
>  /* SPI Flash Device Table */
>  struct flash_info {
>  	char		*name;

Brian
