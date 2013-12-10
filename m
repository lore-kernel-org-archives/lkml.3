Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751801Ab3LJVs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 16:48:56 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:41345 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226Ab3LJVsz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 16:48:55 -0500
Date: Tue, 10 Dec 2013 13:48:49 -0800
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dwmw2@infradead.org, angus.clark@st.com, linus.walleij@linaro.org,
        linux-mtd@lists.infradead.org
Subject: Re: [PATCH v3 08/36] mtd: devices: Provide header for shared
 OPCODEs and SFDP commands
Message-ID: <20131210214849.GE27149@ld-irv-0074.broadcom.com>
References: <1385727565-25794-1-git-send-email-lee.jones@linaro.org>
 <1385727565-25794-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385727565-25794-9-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 12:18:57PM +0000, Lee Jones wrote:
> JEDEC have helped to standardise a great deal of the commands which
> can be issued to a Serial Flash devices. Many of the OPCODEs and all
> of the Serial Flash Discoverable Parameters (SFDP) commands are
> generic across devices. This patch provides a shared point where
> these commands can be defined.

I think this is probably a good start for a shared header. In the near
term, we need to settle on one header that can store commands, at least.
I think both you and Huang are submitting patches that do similar opcode
relocation. Let's make sure we get the separation right, so that this
header contains exactly as much of the opcode-related stuff that can be
easily shared and reused.

> Suggested-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/mtd/devices/serial_flash_cmds.h | 91 +++++++++++++++++++++++++++++++++
>  drivers/mtd/devices/st_spi_fsm.c        |  1 +
>  drivers/mtd/devices/st_spi_fsm.h        |  2 +
>  3 files changed, 94 insertions(+)
>  create mode 100644 drivers/mtd/devices/serial_flash_cmds.h
> 
> diff --git a/drivers/mtd/devices/serial_flash_cmds.h b/drivers/mtd/devices/serial_flash_cmds.h
> new file mode 100644
> index 0000000..62aa420
> --- /dev/null
> +++ b/drivers/mtd/devices/serial_flash_cmds.h
> @@ -0,0 +1,91 @@
> +/*
> + * Generic/SFDP Flash Commands and Device Capabilities
> + *
> + * Copyright (C) 2013 Lee Jones <lee.jones@lianro.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

BTW, I think checkpatch.pl complains about putting the FSF address here.

> +/* JEDEC Standard - Serial Flash Discoverable Parmeters (SFDP) Commands */
> +#define FLASH_CMD_READ		0x03	/* READ */
> +#define FLASH_CMD_READ_FAST	0x0b	/* FAST READ */
> +#define FLASH_CMD_READ_1_1_2	0x3b	/* DUAL OUTPUT READ */
> +#define FLASH_CMD_READ_1_2_2	0xbb	/* DUAL I/O READ */
> +#define FLASH_CMD_READ_1_1_4	0x6b	/* QUAD OUTPUT READ */
> +#define FLASH_CMD_READ_1_4_4	0xeb	/* QUAD I/O READ */

All of these {1,2,4}_{1,2,4}_{1,2,4} suffixes are a little cryptic; I
ended up referring to the SFDP spec to figure out what the first number
meant. Can you document them briefly at the top of this SFDP list?

> +#define FLASH_CMD_WRITE		0x02	/* PAGE PROGRAM */
> +#define FLASH_CMD_WRITE_1_1_2	0xa2	/* DUAL INPUT PROGRAM */
> +#define FLASH_CMD_WRITE_1_2_2	0xd2	/* DUAL INPUT EXT PROGRAM */
> +#define FLASH_CMD_WRITE_1_1_4	0x32	/* QUAD INPUT PROGRAM */
> +#define FLASH_CMD_WRITE_1_4_4	0x12	/* QUAD INPUT EXT PROGRAM */
> +
> +#define FLASH_CMD_EN4B_ADDR	0xb7	/* Enter 4-byte address mode */
> +#define FLASH_CMD_EX4B_ADDR	0xe9	/* Exit 4-byte address mode */
> +
> +/* READ commands with 32-bit addressing */
> +#define FLASH_CMD_READ4		0x13
> +#define FLASH_CMD_READ4_FAST	0x0c
> +#define FLASH_CMD_READ4_1_1_2	0x3c
> +#define FLASH_CMD_READ4_1_2_2	0xbc
> +#define FLASH_CMD_READ4_1_1_4	0x6c
> +#define FLASH_CMD_READ4_1_4_4	0xec

Since you list these, does SFDP even describe the 32-bit addressing
commands? It seems like it assumes the device is switched (statefully)
between 24-bit and 32-bit address modes (or kept permanently in one or
the other).

> +/* Configuration flags */
> +#define FLASH_FLAG_SINGLE	0x000000ff
> +#define FLASH_FLAG_READ_WRITE	0x00000001
> +#define FLASH_FLAG_READ_FAST	0x00000002
> +#define FLASH_FLAG_SE_4K	0x00000004
> +#define FLASH_FLAG_SE_32K	0x00000008
> +#define FLASH_FLAG_CE		0x00000010
> +#define FLASH_FLAG_32BIT_ADDR	0x00000020
> +#define FLASH_FLAG_RESET	0x00000040
> +#define FLASH_FLAG_DYB_LOCKING	0x00000080
> +
> +#define FLASH_FLAG_DUAL		0x0000ff00
> +#define FLASH_FLAG_READ_1_1_2	0x00000100
> +#define FLASH_FLAG_READ_1_2_2	0x00000200
> +#define FLASH_FLAG_READ_2_2_2	0x00000400
> +#define FLASH_FLAG_WRITE_1_1_2	0x00001000
> +#define FLASH_FLAG_WRITE_1_2_2	0x00002000
> +#define FLASH_FLAG_WRITE_2_2_2	0x00004000
> +
> +#define FLASH_FLAG_QUAD		0x00ff0000
> +#define FLASH_FLAG_READ_1_1_4	0x00010000
> +#define FLASH_FLAG_READ_1_4_4	0x00020000
> +#define FLASH_FLAG_READ_4_4_4	0x00040000
> +#define FLASH_FLAG_WRITE_1_1_4	0x00100000
> +#define FLASH_FLAG_WRITE_1_4_4	0x00200000
> +#define FLASH_FLAG_WRITE_4_4_4	0x00400000

It doesn't look to me like the dual/quad bitfields are laid out very
usefully. Can't they be divided so that their bit position is more
meaningful? Like reserve bits [8:23] for dual/quad descriptions, then
give the following:

 [8:11]  number of pins for the opcode (1=single; 2=dual; 4=quad)
 [12:15] number of pins for the address (1=single; 2=dual; ...)
 [16:19] number of pins for the data
 [20]    read or write opcode (0=read; 1=write)

(you could easily pack these differently, but you get the idea)

Then:

#define FLASH_FLAG_DUAL_MASK	0x00022200
#define FLASH_FLAG_QUAD_MASK	0x00044400

And we could do things like:

#define FLASH_FLAG_OPCODE_PINS(x)	(((x) & 0x00000f00) >> 8)
#define FLASH_FLAG_ADDR_PINS(x)		(((x) & 0x0000f000) >> 12)
#define FLASH_FLAG_DATA_PINS(x)		(((x) & 0x000f0000) >> 16)

(and maybe replace those mask/shifts with macro names)

This could eliminate some redundancy in your tables, I think, so that
you can extract (from this flag) the number of "addr_pads" and
"data_pads" needed for the opcode. And I think this would be useful to
other controllers eventually. For instance, my quad-read driver might
support 4 data pins but it can't put the opcode or address out on more
than 1 pin.

Brian
