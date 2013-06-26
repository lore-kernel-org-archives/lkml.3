Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab3FZOQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:16:40 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:40502 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3FZOQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:16:37 -0400
MIME-Version: 1.0
In-Reply-To: <1372232472-2641-2-git-send-email-sourav.poddar@ti.com>
References: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com> <1372232472-2641-2-git-send-email-sourav.poddar@ti.com>
From: Florian Fainelli <florian@openwrt.org>
Date: Wed, 26 Jun 2013 15:15:56 +0100
X-Google-Sender-Auth: J32_u_Z91xI3pKSgOhSMollRetQ
Message-ID: <CAGVrzcY6Writ9Ehs=tiumjfDinETgS_kL5C02eZtKG5ENaWGfQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] drivers: mtd: spinand: Add generic spinand frameowrk
 and micron driver.
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: linux-mtd@lists.infradead.org, spi-devel-general@lists.sourceforge.net,
        broonie@kernel.org, dwmw2@infradead.org, manonuevo@micron.com,
        tqnguyen@micron.com, Grant Likely <grant.likely@linaro.org>,
        linux-omap@vger.kernel.org, rnayak@ti.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        balbi@ti.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

2013/6/26 Sourav Poddar <sourav.poddar@ti.com>:
> From: Mona Anonuevo <manonuevo@micron.com>
>
> This patch adds support for a generic spinand framework(spinand_mtd.c).
> This frameowrk can be used for other spi based flash devices also. The idea
> is to have a common model under drivers/mtd, as also present for other no spi
> devices(there is a generic framework and device part simply attaches itself to it.)
>
> The generic frework will be used later by me for a SPI based spansion S25FL256 device.
> The patch also contains a micron driver attaching itself to generic framework.

Some general comments below, I do not have any SPI NAND devices, just
reading through the code.

> +
> +config MTD_SPINAND_ONDIEECC
> +       bool "Use SPINAND internal ECC"
> +       help
> +        Internel ECC
> +
> +config MTD_SPINAND_SWECC
> +       bool "Use software ECC"
> +       depends on MTD_NAND
> +       help
> +        software ECC

Cannot both of these be somehow detected by the identification bytes?
Or maybe explicitely specified in an identification table?

> +#define mu_spi_nand_driver_version "Beagle-MTD_01.00_Linux2.6.33_20100507"

You probably want to remove this.

> +#define SPI_NAND_MICRON_DRIVER_KEY 0x1233567

Ditto.

> +
> +/****************************************************************************/
> +
> +/**
> +   OOB area specification layout:  Total 32 available free bytes.
> +*/
> +static struct nand_ecclayout spinand_oob_64 = {
> +       .eccbytes = 24,
> +       .eccpos = {
> +                  1, 2, 3, 4, 5, 6,
> +                  17, 18, 19, 20, 21, 22,
> +                  33, 34, 35, 36, 37, 38,
> +                  49, 50, 51, 52, 53, 54, },
> +       .oobavail = 32,
> +       .oobfree = {
> +               {.offset = 8,
> +                .length = 8},
> +               {.offset = 24,
> +                .length = 8},
> +               {.offset = 40,
> +                .length = 8},
> +               {.offset = 56,
> +                .length = 8}, }
> +};

This should probably be per-device, or at best supplied by platform data?

> +/**
> + * spinand_cmd - to process a command to send to the SPI Nand
> + *
> + * Description:
> + *    Set up the command buffer to send to the SPI controller.
> + *    The command buffer has to initized to 0
> + */
> +int spinand_cmd(struct spi_device *spi, struct spinand_cmd *cmd)
> +{
> +       int                                     ret;
> +       struct spi_message      message;
> +       struct spi_transfer             x[4];
> +       u8 dummy = 0xff;
> +
> +       spi_message_init(&message);
> +       memset(x, 0, sizeof(x));
> +
> +       x[0].len = 1;
> +       x[0].tx_buf = &cmd->cmd;
> +       spi_message_add_tail(&x[0], &message);
> +
> +       if (cmd->n_addr) {
> +               x[1].len = cmd->n_addr;
> +               x[1].tx_buf = cmd->addr;
> +               spi_message_add_tail(&x[1], &message);
> +       }
> +
> +       if (cmd->n_dummy) {
> +               x[2].len = cmd->n_dummy;
> +               x[2].tx_buf = &dummy;
> +               spi_message_add_tail(&x[2], &message);
> +       }
> +
> +       if (cmd->n_tx) {
> +               x[3].len = cmd->n_tx;
> +               x[3].tx_buf = cmd->tx_buf;
> +               spi_message_add_tail(&x[3], &message);
> +       }
> +
> +       if (cmd->n_rx) {
> +               x[3].len = cmd->n_rx;
> +               x[3].rx_buf = cmd->rx_buf;
> +               spi_message_add_tail(&x[3], &message);
> +       }
> +
> +       ret = spi_sync(spi, &message);

If any kind of locking is implicitely done by the SPI layer, you might
want to add a comment to specify it.

[snip]

> +       retval = spinand_cmd(spi_nand, &cmd);
> +
> +       if (retval != 0) {
> +               dev_err(&spi_nand->dev, "error %d reading id\n",
> +                               (int) retval);
> +               return retval;
> +       }

Just:

if (retval)
          dev_err(&spi_nand->dev, "...

return retval

[snip]

> +       retval = spinand_cmd(spi_nand, &cmd);
> +
> +       if (retval != 0) {
> +               dev_err(&spi_nand->dev, "error %d lock block\n",
> +                               (int) retval);
> +               return retval;
> +       }

Same here

[snip]

> +       if (retval != 0) {
> +               dev_err(&spi_nand->dev, "error %d reading status register\n",
> +                               (int) retval);
> +               return retval;
> +       }

And here

[snip]

> +       if (retval != 0) {
> +               dev_err(&spi_nand->dev, "error %d get otp\n",
> +                               (int) retval);
> +               return retval;
> +       }

And here

[snip]

> +       if (retval != 0) {
> +               dev_err(&spi_nand->dev, "error %d set otp\n",
> +                       (int) retval);
> +               return retval;

And here

[snip]

> +*/
> +#ifdef CONFIG_MTD_SPINAND_ONDIEECC

Same comment as above, you could probably do not make this enclosed
within an ifdef, but always compile it and test for a device flag for
instance.

> +static int spinand_enable_ecc(struct spi_device *spi_nand,
> +                       struct spinand_info *info)
> +{
> +       ssize_t retval;
> +       u8 otp = 0;
> +
> +       retval = spinand_get_otp(spi_nand, info, &otp);
> +
> +       if ((otp & OTP_ECC_MASK) == OTP_ECC_MASK) {
> +               return 0;
> +       } else {
> +               otp |= OTP_ECC_MASK;
> +               retval = spinand_set_otp(spi_nand, info, &otp);
> +               retval = spinand_get_otp(spi_nand, info, &otp);
> +               return retval;
> +       }

You probably do not need the if() else() because the if branch returns
immediately.

[snip]

> +       if ((otp & OTP_ECC_MASK) == OTP_ECC_MASK) {
> +               otp &= ~OTP_ECC_MASK;
> +               retval = spinand_set_otp(spi_nand, info, &otp);
> +               retval = spinand_get_otp(spi_nand, info, &otp);
> +               return retval;
> +       } else {
> +               return 0;

Same here

[snip]

> +static int spinand_read_page(struct spi_device *spi_nand,
> +               struct spinand_info *info, u16 page_id, u16 offset,
> +                       u16 len, u8 *rbuf)
> +{
> +       ssize_t retval;
> +       u8 status = 0;
> +
> +       retval = spinand_read_page_to_cache(spi_nand, info, page_id);

Either you check the value and return or you do not.

> +
> +       while (1) {
> +               retval = spinand_read_status(spi_nand, info, &status);
> +               if (retval < 0) {
> +                       dev_err(&spi_nand->dev, "error %d reading status register\n",
> +                                       (int) retval);
> +                       return retval;
> +               }
> +
> +               if ((status & STATUS_OIP_MASK) == STATUS_READY) {
> +                       if ((status & STATUS_ECC_MASK) == STATUS_ECC_ERROR) {
> +                               dev_err(&spi_nand->dev,
> +                                       "ecc error, page=%d\n", page_id);
> +                       }
> +                       break;
> +               }

Should not we somehow call cpu_relax() or wait for some delay here
before issuing multiple READ_STATUS commands?

[snip]

> +       retval = spinand_write_enable(spi_nand, info);
> +
> +       retval = spinand_program_data_to_cache(spi_nand, info, offset,
> +                       len, wbuf);
> +
> +       retval = spinand_program_execute(spi_nand, info, page_id);

Same here either check return value and return or do not check the
return value at all.

[snip]

> +static int spinand_get_info(struct spi_device *spi_nand,
> +               struct spinand_info *info, u8 *id)
> +{
> +       if (id[0] == 0x2C && (id[1] == 0x11 ||
> +               id[1] == 0x12 || id[1] == 0x13)) {
> +               info->mid = id[0];
> +               info->did = id[1];
> +               info->name = "MT29F1G01ZAC";
> +               info->nand_size = (1024 * 64 * 2112);
> +               info->usable_size = (1024 * 64 * 2048);
> +               info->block_size = (2112*64);
> +               info->block_main_size = (2048*64);
> +               info->block_num_per_chip = 1024;
> +               info->page_size = 2112;
> +               info->page_main_size = 2048;
> +               info->page_spare_size = 64;
> +               info->page_num_per_block = 64;
> +
> +               info->block_shift = 17;
> +               info->block_mask = 0x1ffff;
> +
> +               info->page_shift = 11;
> +               info->page_mask = 0x7ff;
> +
> +               info->ecclayout = &spinand_oob_64;
> +       }

Even if there is just one device supported by this driver, you
definitively want to use an identification table so that people can
easily add new chips without much pain.

> +       return 0;
> +}
> +
> +/**
> + * spinand_probe - [spinand Interface]
> + * @spi_nand: registered device driver.
> + *
> + * Description:
> + *   To set up the device driver parameters to make the device available.
> +*/
> +static int spinand_probe(struct spi_device *spi_nand)
> +{
> +       ssize_t retval;
> +       struct mtd_info *mtd;
> +       struct spinand_chip *chip;
> +       struct spinand_info *info;
> +       struct flash_platform_data      *data;
> +       struct mtd_part_parser_data     ppdata;
> +       u8 id[2] = {0};
> +
> +       retval = spinand_reset(spi_nand);
> +       retval = spinand_reset(spi_nand);
> +       retval = spinand_read_id(spi_nand, (u8 *)&id);
> +       if (id[0] == 0 && id[1] == 0) {
> +               pr_info(KERN_INFO "SPINAND: read id error! 0x%02x, 0x%02x!\n",
> +                       id[0], id[1]);
> +               return 0;
> +       }
> +
> +       data = spi_nand->dev.platform_data;
> +       info  = kzalloc(sizeof(struct spinand_info), GFP_KERNEL);
> +       if (!info)
> +               return -ENOMEM;

You can use devm_kzalloc() to get your chunks of memory freed upon
driver removal.

> +
> +       retval = spinand_get_info(spi_nand, info, (u8 *)&id);
> +       pr_info(KERN_INFO "SPINAND: 0x%02x, 0x%02x, %s\n",
> +               id[0], id[1], info->name);
> +       pr_info(KERN_INFO "%s\n", mu_spi_nand_driver_version);
> +       retval = spinand_lock_block(spi_nand, info, BL_ALL_UNLOCKED);
> +
> +#ifdef CONFIG_MTD_SPINAND_ONDIEECC
> +       retval = spinand_enable_ecc(spi_nand, info);
> +#else
> +       retval = spinand_disable_ecc(spi_nand, info);
> +#endif
> +
> +       ppdata.of_node = spi_nand->dev.of_node;

You could probably go along and define Device Tree bindings for this
driver at the same time, such that they are directly usable once the
driver is merged.

> diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
> new file mode 100644
> index 0000000..3b8802a
> --- /dev/null
> +++ b/include/linux/mtd/spinand.h
> @@ -0,0 +1,155 @@
> +/*
> + *  linux/include/linux/mtd/spinand.h
> + *  Copyright (c) 2009-2010 Micron Technology, Inc.
> + *  This software is licensed under the terms of the GNU General Public
> + *  License version 2, as published by the Free Software Foundation, and
> + *  may be copied, distributed, and modified under those terms.
> +
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> +/bin/bash: 4: command not found

?

> + *
> + *  based on nand.h
> + */
> +#ifndef __LINUX_MTD_SPI_NAND_H
> +#define __LINUX_MTD_SPI_NAND_H
> +
> +#include <linux/wait.h>
> +#include <linux/spinlock.h>
> +#include <linux/mtd/mtd.h>
> +
> +/* cmd */
> +#define CMD_READ                               0x13
> +#define CMD_READ_RDM                   0x03
> +#define CMD_PROG_PAGE_CLRCACHE 0x02
> +#define CMD_PROG_PAGE                  0x84
> +#define CMD_PROG_PAGE_EXC              0x10
> +#define CMD_ERASE_BLK                  0xd8
> +#define CMD_WR_ENABLE                  0x06
> +#define CMD_WR_DISABLE                 0x04
> +#define CMD_READ_ID                    0x9f
> +#define CMD_RESET                              0xff
> +#define CMD_READ_REG                   0x0f
> +#define CMD_WRITE_REG                  0x1f

Please prefix all of them with SPI_NAND_CMD just to be consistent with
what is defined in include/linux/mtd/nand.h?

> +
> +/* feature/ status reg */
> +#define REG_BLOCK_LOCK         0xa0
> +#define REG_OTP                                0xb0
> +#define REG_STATUS                     0xc0/* timing */
> +
> +/* status */
> +#define STATUS_OIP_MASK                0x01
> +#define STATUS_READY           (0 << 0)
> +#define STATUS_BUSY                    (1 << 0)
> +
> +#define STATUS_E_FAIL_MASK     0x04
> +#define STATUS_E_FAIL          (1 << 2)
> +
> +#define STATUS_P_FAIL_MASK     0x08
> +#define STATUS_P_FAIL          (1 << 3)
> +
> +#define STATUS_ECC_MASK                0x30
> +#define STATUS_ECC_1BIT_CORRECTED      (1 << 4)
> +#define STATUS_ECC_ERROR                       (2 << 4)
> +#define STATUS_ECC_RESERVED                    (3 << 4)
> +
> +
> +/*ECC enable defines*/
> +#define OTP_ECC_MASK           0x10
> +#define OTP_ECC_OFF                    0
> +#define OTP_ECC_ON                     1
> +
> +#define ECC_DISABLED
> +#define ECC_IN_NAND
> +#define ECC_SOFT
> +
> +/* block lock */
> +#define BL_ALL_LOCKED      0x38
> +#define BL_1_2_LOCKED      0x30
> +#define BL_1_4_LOCKED      0x28
> +#define BL_1_8_LOCKED      0x20
> +#define BL_1_16_LOCKED     0x18
> +#define BL_1_32_LOCKED     0x10
> +#define BL_1_64_LOCKED     0x08
> +#define BL_ALL_UNLOCKED    0
> +
> +struct spinand_info {
> +       u8              mid;
> +       u8              did;
> +       char            *name;
> +       u64             nand_size;
> +       u64             usable_size;
> +
> +       u32             block_size;
> +       u32             block_main_size;
> +       /*u32           block_spare_size; */
> +       u16             block_num_per_chip;
> +       u16             page_size;
> +       u16             page_main_size;
> +       u16             page_spare_size;
> +       u16             page_num_per_block;
> +       u8              block_shift;
> +       u32             block_mask;
> +       u8              page_shift;
> +       u16             page_mask;
> +
> +       struct nand_ecclayout *ecclayout;
> +};
> +
> +typedef enum {
> +       FL_READY,
> +       FL_READING,
> +       FL_WRITING,
> +       FL_ERASING,
> +       FL_SYNCING,
> +       FL_LOCKING,
> +       FL_RESETING,
> +       FL_OTPING,
> +       FL_PM_SUSPENDED,
> +} spinand_state_t;

Maybe flstate_t from include/linux/mtd/flashchip.h should be made
move/made nore generic such that you can use these defines too?
--
Florian
