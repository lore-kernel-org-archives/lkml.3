Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755106Ab3GDEoZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 00:44:25 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:42376 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752863Ab3GDEoX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 00:44:23 -0400
Message-ID: <51D4FD7F.3020104@ti.com>
Date: Thu, 4 Jul 2013 10:13:43 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Florian Fainelli <florian@openwrt.org>
CC: <artem.bityutskiy@linux.intel.com>, <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, <manonuevo@micron.com>,
        <tqnguyen@micron.com>, <balbi@ti.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2] drivers: mtd: spinand: Add generic spinand frameowrk.
References: <1372851110-580-1-git-send-email-sourav.poddar@ti.com> <CAGVrzcbuK-xBeCVTsXhgEbX9CRqt8Dj7++ikoNZW8bY24Uz2Zg@mail.gmail.com>
In-Reply-To: <CAGVrzcbuK-xBeCVTsXhgEbX9CRqt8Dj7++ikoNZW8bY24Uz2Zg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Wednesday 03 July 2013 10:47 PM, Florian Fainelli wrote:
> Hello,
>
> 2013/7/3 Sourav Poddar<sourav.poddar@ti.com>:
>> From: Mona Anonuevo<manonuevo@micron.com>
>>
>> This patch adds support for a generic spinand framework(spinand_mtd.c).
>> This frameowrk can be used for other spi based flash devices. The idea
>> is to have a common model under drivers/mtd, as also present for other non spi
>> devices(there is a generic framework and device part simply attaches itself to it.)
> Resending my comments since your previous submissino
>
>> Signed-off-by: Mona Anonuevo<manonuevo@micron.com>
>> Signed-off-by: Tuan Nguyen<tqnguyen@micron.com>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> ----
>>
> [snip]
>
>> +if MTD_SPINAND
>> +
>> +config MTD_SPINAND_ONDIEECC
>> +       bool "Use SPINAND internal ECC"
>> +       help
>> +        Internel ECC
>> +
>> +config MTD_SPINAND_SWECC
>> +       bool "Use software ECC"
>> +       depends on MTD_NAND
>> +       help
>> +        software ECC
> Can this somehow be made a runtime thing?
>
Ahh..I think we might opt for a device tree entry and based on that
check for ECC.
> [snip]
>
>> +               if (count<  oob_num&&  ops->oobbuf&&  chip->oobbuf) {
>> +                       int size;
>> +                       int offset, len, temp;
>> +
>> +                       /* repack spare to oob */
>> +                       memset(chip->oobbuf, 0, info->ecclayout->oobavail);
>> +
>> +                       temp = 0;
>> +                       offset = info->ecclayout->oobfree[0].offset;
>> +                       len = info->ecclayout->oobfree[0].length;
>> +                       memcpy(chip->oobbuf + temp,
>> +                               chip->buf + info->page_main_size + offset, len);
> Sounds like a for look might be useful here
>
I dont think so, there is a while loop above under which it happens.
We are increasing count at the bottom of the while loop. So, I think
this should work fine.
>> +
>> +                       temp += len;
>> +                       offset = info->ecclayout->oobfree[1].offset;
>> +                       len = info->ecclayout->oobfree[1].length;
>> +                       memcpy(chip->oobbuf + temp,
>> +                               chip->buf + info->page_main_size + offset, len);
>> +
>> +                       temp += len;
>> +                       offset = info->ecclayout->oobfree[2].offset;
>> +                       len = info->ecclayout->oobfree[2].length;
>> +                       memcpy(chip->oobbuf + temp,
>> +                               chip->buf + info->page_main_size + offset, len);
>> +
>> +                       temp += len;
>> +                       offset = info->ecclayout->oobfree[3].offset;
>> +                       len = info->ecclayout->oobfree[3].length;
>> +                       memcpy(chip->oobbuf + temp,
>> +                               chip->buf + info->page_main_size + offset, len);
>> +
> [snip]
>
>> +                       /* repack oob to spare */
>> +                       temp = 0;
>> +                       offset = info->ecclayout->oobfree[0].offset;
>> +                       len = info->ecclayout->oobfree[0].length;
>> +                       memcpy(chip->buf + info->page_main_size + offset,
>> +                                       chip->oobbuf + temp, len);
> And here too.
>
>
Same as above.
>> +
>> +                       temp += len;
>> +                       offset = info->ecclayout->oobfree[1].offset;
>> +                       len = info->ecclayout->oobfree[1].length;
>> +                       memcpy(chip->buf + info->page_main_size + offset,
>> +                                       chip->oobbuf + temp, len);
>> +
>> +                       temp += len;
>> +                       offset = info->ecclayout->oobfree[2].offset;
>> +                       len = info->ecclayout->oobfree[2].length;
>> +                       memcpy(chip->buf + info->page_main_size + offset,
>> +                                       chip->oobbuf + temp, len);
>> +
>> +                       temp += len;
>> +                       offset = info->ecclayout->oobfree[3].offset;
>> +                       len = info->ecclayout->oobfree[3].length;
>> +                       memcpy(chip->buf + info->page_main_size + offset,
>> +                                       chip->oobbuf + temp, len);
>> +               }
> [snip]
>
>> +++ b/include/linux/mtd/spinand.h
>> @@ -0,0 +1,155 @@
>> +/*
>> + *  linux/include/linux/mtd/spinand.h
>> + *  Copyright (c) 2009-2010 Micron Technology, Inc.
>> + *  This software is licensed under the terms of the GNU General Public
>> + *  License version 2, as published by the Free Software Foundation, and
>> + *  may be copied, distributed, and modified under those terms.
>> +
>> + *  This program is distributed in the hope that it will be useful,
>> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + *  GNU General Public License for more details.
>> +/bin/bash: 4: command not found
>> + *
>> + *  based on nand.h
>> + */
>> +#ifndef __LINUX_MTD_SPI_NAND_H
>> +#define __LINUX_MTD_SPI_NAND_H
>> +
>> +#include<linux/wait.h>
>> +#include<linux/spinlock.h>
>> +#include<linux/mtd/mtd.h>
>> +
>> +/* cmd */
>> +#define CMD_READ                               0x13
>> +#define CMD_READ_RDM                   0x03
>> +#define CMD_PROG_PAGE_CLRCACHE 0x02
>> +#define CMD_PROG_PAGE                  0x84
>> +#define CMD_PROG_PAGE_EXC              0x10
>> +#define CMD_ERASE_BLK                  0xd8
>> +#define CMD_WR_ENABLE                  0x06
>> +#define CMD_WR_DISABLE                 0x04
>> +#define CMD_READ_ID                    0x9f
>> +#define CMD_RESET                              0xff
>> +#define CMD_READ_REG                   0x0f
>> +#define CMD_WRITE_REG                  0x1f
> Can we somehow namespace these defines so they are not so generic?
> Something like SPI_NAND_CMD_READ would be just fine I guess.
>
I think SPI_CMD_READ will make more sense then, since these
commands will be applicable for other type of flash devices also.
>> +
>> +/* feature/ status reg */
>> +#define REG_BLOCK_LOCK         0xa0
>> +#define REG_OTP                                0xb0
>> +#define REG_STATUS                     0xc0/* timing */
>> +
>> +/* status */
>> +#define STATUS_OIP_MASK                0x01
>> +#define STATUS_READY           (0<<  0)
>> +#define STATUS_BUSY                    (1<<  0)
>> +
>> +#define STATUS_E_FAIL_MASK     0x04
>> +#define STATUS_E_FAIL          (1<<  2)
>> +
>> +#define STATUS_P_FAIL_MASK     0x08
>> +#define STATUS_P_FAIL          (1<<  3)
>> +
>> +#define STATUS_ECC_MASK                0x30
>> +#define STATUS_ECC_1BIT_CORRECTED      (1<<  4)
>> +#define STATUS_ECC_ERROR                       (2<<  4)
>> +#define STATUS_ECC_RESERVED                    (3<<  4)
>> +
>> +
>> +/*ECC enable defines*/
>> +#define OTP_ECC_MASK           0x10
>> +#define OTP_ECC_OFF                    0
>> +#define OTP_ECC_ON                     1
>> +
>> +#define ECC_DISABLED
>> +#define ECC_IN_NAND
>> +#define ECC_SOFT
>> +
>> +/* block lock */
>> +#define BL_ALL_LOCKED      0x38
>> +#define BL_1_2_LOCKED      0x30
>> +#define BL_1_4_LOCKED      0x28
>> +#define BL_1_8_LOCKED      0x20
>> +#define BL_1_16_LOCKED     0x18
>> +#define BL_1_32_LOCKED     0x10
>> +#define BL_1_64_LOCKED     0x08
>> +#define BL_ALL_UNLOCKED    0
> --
> Florian

