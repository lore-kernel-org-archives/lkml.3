Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab3LKCda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 21:33:30 -0500
Received: from mail-oa0-f48.google.com ([209.85.219.48]:58835 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921Ab3LKCd2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 21:33:28 -0500
Date: Tue, 10 Dec 2013 18:33:23 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 24/36] mtd: st_spi_fsm: Supply the N25Qxxx chip
 specific configuration call-back
Message-ID: <20131211023323.GP27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-25-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-25-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:19:13PM +0000, Lee Jones wrote:
> In the FSM driver we handle chip differences by providing the possibility
> of calling back into a chip specific initialisation routine. In this patch
> we provide one for the N25Qxxx series, which endeavours to setup things
> like the read, write and erase sequences, as they differ from the
> default. We also configure 32bit support and the amount of dummy cycles to
> use.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/devices/st_spi_fsm.c | 77 ++++++++++++++++++++++++++++++++++++++++
>  drivers/mtd/devices/st_spi_fsm.h |  7 ++--
>  2 files changed, 82 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> index 3a6b233..2369da1 100644
> --- a/drivers/mtd/devices/st_spi_fsm.c
> +++ b/drivers/mtd/devices/st_spi_fsm.c
> @@ -98,6 +98,8 @@ static struct seq_rw_config n25q_read4_configs[] = {
>  	{0x00,			0,			0, 0, 0, 0x00, 0, 0},
>  };
>  
> +static struct stfsm_seq stfsm_seq_read; 	/* Dynamically populated */
> +static struct stfsm_seq stfsm_seq_write;	/* Dynamically populated */

These should be fields in struct stfsm, no?

>  static struct stfsm_seq stfsm_seq_en_32bit_addr;/* Dynamically populated */
>  
>  static struct stfsm_seq stfsm_seq_read_jedec = {
> diff --git a/drivers/mtd/devices/st_spi_fsm.h b/drivers/mtd/devices/st_spi_fsm.h
> index 6699174..b5ce07d 100644
> --- a/drivers/mtd/devices/st_spi_fsm.h
> +++ b/drivers/mtd/devices/st_spi_fsm.h
> @@ -304,6 +304,8 @@ struct flash_info {
>  	int		(*config)(struct stfsm *);
>  };
>  
> +static int stfsm_n25q_config(struct stfsm *fsm);
> +

I really dislike putting this static declaration in the header. (And for
now, I don't think you need this header at all, since very little of
your work is shareable yet.) Your table *looks* like it could be shared,
but it won't even compile if this header is included in other files,
since they don't have the definitions of your static functions.

Anyway, I think your table should be reworked if it's going to be useful
to others.

>  static struct flash_info flash_types[] = {
>  	/*
>  	 * ST Microelectronics/Numonyx --
> @@ -347,9 +349,10 @@ static struct flash_info flash_types[] = {
>  		   FLASH_FLAG_WRITE_1_2_2	| \
>  		   FLASH_FLAG_WRITE_1_1_4	| \
>  		   FLASH_FLAG_WRITE_1_4_4)
> -	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_FLAG, 108, NULL },
> +	{ "n25q128", 0x20ba18, 0, 64 * 1024,  256, N25Q_FLAG, 108,
> +	  stfsm_n25q_config },
>  	{ "n25q256", 0x20ba19, 0, 64 * 1024,  512,
> -	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, NULL },
> +	  N25Q_FLAG | FLASH_FLAG_32BIT_ADDR, 108, stfsm_n25q_config },
>  
>  	/*
>  	 * Spansion S25FLxxxP

Brian
