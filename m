Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab3LJWDq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 17:03:46 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:59408 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3LJWDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 17:03:42 -0500
Date: Tue, 10 Dec 2013 14:03:38 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 09/36] mtd: st_spi_fsm: Provide device look-up table
Message-ID: <20131210220338.GF27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-10-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:18:58PM +0000, Lee Jones wrote:
> --- a/drivers/mtd/devices/st_spi_fsm.h
> +++ b/drivers/mtd/devices/st_spi_fsm.h
> @@ -253,4 +253,141 @@ struct stfsm_seq {
>  } __attribute__((__packed__, aligned(4)));
>  #define STFSM_SEQ_SIZE sizeof(struct stfsm_seq)
>  
> +/* SPI Flash Device Table */
> +struct flash_info {
> +	char		*name;
> +	/*
> +	 * JEDEC id zero means "no ID" (most older chips); otherwise it has
> +	 * a high byte of zero plus three data bytes: the manufacturer id,
> +	 * then a two byte device id.
> +	 */
> +	u32		jedec_id;
> +	u16             ext_id;

Will 5 bytes of ID be enough? I think we're running into a need for 6
bytes of ID in m25p80.c right about now. Might make sense to start with
the right number of bytes.

> +	/*
> +	 * The size listed here is what works with FLASH_CMD_SE, which isn't
> +	 * necessarily called a "sector" by the vendor.
> +	 */
> +	unsigned	sector_size;
> +	u16		n_sectors;
> +	u32		flags;
> +	/*
> +	 * Note, where FAST_READ is supported, freq_max specifies the
> +	 * FAST_READ frequency, not the READ frequency.
> +	 */
> +	u32		max_freq;
> +	int		(*config)(struct stfsm *);

Do you *really* need a configuration callback? Can the callback be
represented as simply a flag for the special configuration behavior that
is needed, then your driver calls the appropriate "callback" when it
sees the flag?

BTW, your later patches have to introduce static declarations in this
header, which seems very ugly to me; you are entwining data with your
driver's implementation.

So this callback field can only be used by your driver, and it is one of
the main reasons that your table structure can't be used in other
drivers.

> +};
> +
> +static struct flash_info flash_types[] = {
> +	/*
> +	 * ST Microelectronics/Numonyx --
> +	 * (newer production versions may have feature updates
> +	 * (eg faster operating frequency)
> +	 */
> +#define M25P_FLAG (FLASH_FLAG_READ_WRITE | FLASH_FLAG_READ_FAST)

Please don't define macros in the middle of your table like this. (You
have several of these.)

> +	{ "m25p40",  0x202013, 0,  64 * 1024,   8, M25P_FLAG, 25, NULL },
> +	{ "m25p80",  0x202014, 0,  64 * 1024,  16, M25P_FLAG, 25, NULL },
> +	{ "m25p16",  0x202015, 0,  64 * 1024,  32, M25P_FLAG, 25, NULL },
> +	{ "m25p32",  0x202016, 0,  64 * 1024,  64, M25P_FLAG, 50, NULL },
> +	{ "m25p64",  0x202017, 0,  64 * 1024, 128, M25P_FLAG, 50, NULL },
> +	{ "m25p128", 0x202018, 0, 256 * 1024,  64, M25P_FLAG, 50, NULL },

[snip]

Brian
