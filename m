Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292AbbATCFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:05:08 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:62381 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552AbbATCFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:05:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAN1oZWxB5N=YMQcsJppZgp7TXodcR4tKZM+LNFXS7PSx3F-Yag@mail.gmail.com>
References: <CAN1oZWxB5N=YMQcsJppZgp7TXodcR4tKZM+LNFXS7PSx3F-Yag@mail.gmail.com>
Date: Tue, 20 Jan 2015 10:05:01 +0800
Message-ID: <CAN1oZWzeev-1uE7gxPnJA=L4Th65CRj8C_LQ7hMJLPHGssDjNQ@mail.gmail.com>
Subject: Re: [PATCH mtd] mtd:devices: Add Altera EPCQ Driver
From: Viet Nga Dao <vndao@altera.com>
To: Viet Nga Dao <vndao@altera.com>
Cc: Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        nga_chi86 <ngachi86@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 15, 2015 at 5:27 PM, Viet Nga Dao <vndao@altera.com> wrote:
> On Tue, Jan 13, 2015 at 11:33 AM, Brian Norris
> <computersforpeace@gmail.com> wrote:
>> On Thu, Dec 18, 2014 at 12:23:16AM -0800, vndao@altera.com wrote:
>>> From: Viet Nga Dao <vndao@altera.com>
>>>
>>> Altera EPCQ Controller is a soft IP which enables access to Altera EPCQ and
>>> EPCS flash chips. This patch adds driver for these devices.
>>>
>>> Signed-off-by: Viet Nga Dao <vndao@altera.com>
>>
>> This drivers seems awfully similar to (and so I infer it is likely
>> copy-and-pasted from) m25p80.c / spi-nor.c. Do you think it can be
>> rewritten as a SPI NOR driver, under drivers/mtd/spi-nor/ ? It looks
>> like these flash share most (all?) the same basic opcodes.
>>
> For Altera EPCQ flashes, almost operations are performed underline
> hardware. Software only able to perform the following through
> registers:
>  -  read status register
>  -  read id
>  -  write status registers bit SR_BP0,SR_BP1, SR_BP2,SR_BP3, SR_TB
> (http://www.altera.com.my/literature/hb/cfg/cfg_cf52012.pdf)
> For read/write data: all the operations like QUAD_READ/WRITE,
> FAST_READ/WRITE are handled by hardware as well. From software point
> of view, there is no difference between these 2 modes.
> That is why if rewrite the drivers to follow spi-nor structure, it
> will require extra decoding works for the only few used opcodes.
>
Is it OK to remain this driver structure?
>>> ---
>>>  .../devicetree/bindings/mtd/altera_epcq.txt        |   45 ++
>>>  drivers/mtd/devices/Kconfig                        |   12 +
>>>  drivers/mtd/devices/Makefile                       |    2 +-
>>>  drivers/mtd/devices/altera_epcq.c                  |  804 ++++++++++++++++++++
>>>  drivers/mtd/devices/altera_epcq.h                  |  130 ++++
>>>  5 files changed, 992 insertions(+), 1 deletions(-)
>>>  create mode 100644 Documentation/devicetree/bindings/mtd/altera_epcq.txt
>>>  create mode 100644 drivers/mtd/devices/altera_epcq.c
>>>  create mode 100644 drivers/mtd/devices/altera_epcq.h
>>>
>>> diff --git a/Documentation/devicetree/bindings/mtd/altera_epcq.txt b/Documentation/devicetree/bindings/mtd/altera_epcq.txt
>>> new file mode 100644
>>> index 0000000..d14f50e
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/mtd/altera_epcq.txt
>>> @@ -0,0 +1,45 @@
>>> +* MTD Altera EPCQ driver
>>> +
>>> +Required properties:
>>> +- compatible: Should be "altr,epcq-1.0"
>>> +- reg: Address and length of the register set  for the device. It contains
>>> +  the information of registers in the same order as described by reg-names
>>> +- reg-names: Should contain the reg names
>>> +  "csr_base": Should contain the register configuration base address
>>> +  "data_base": Should contain the data base address
>>> +- is-epcs: boolean type.
>>> +             If present, the device contains EPCS flashes.
>>> +             Otherwise, it contains EPCQ flashes.
>>> +- #address-cells: Must be <1>.
>>> +- #size-cells: Must be <0>.
>>> +- flash device tree subnode, there must be a node with the following fields:
>>
>> These subnodes definitely require a 'compatible' string. Perhaps they
>> should be used to differentiate EPCS vs. EPCQ. Does "is-epcs" really
>> need to be in the top-level controller node?
>>
>>> +     - reg: Should contain the flash id
>>
>> Should, or must? (This question is relevant, because you seem to make it
>> optional in your code.) And what does the "flash ID" mean? It seems like
>> you're using as a chip-select or bank index.
>>
>>> +     - #address-cells: please refer to /mtd/partition.txt
>>> +     - #size-cells: please refer to /mtd/partition.txt
>>> +     For partitions inside each flash, please refer to /mtd/partition.txt
>>> +
>>> +Example:
>>> +
>>> +                     epcq_controller_0: epcq@0x000000000 {
>>> +                             compatible = "altr,epcq-1.0";
>>> +                             reg = <0x00000001 0x00000000 0x00000020>,
>>> +                                     <0x00000000 0x00000000 0x02000000>;
>>> +                             reg-names = "csr_base", "data_base";
>>> +                             #address-cells = <1>;
>>> +                             #size-cells = <0>;
>>> +                             flash0: epcq256@0 {
>>> +                                     reg = <0>;
>>> +                                     #address-cells = <1>;
>>> +                                     #size-cells = <1>;
>>> +                                     partition@0 {
>>> +                                             /* 16 MB for raw data. */
>>> +                                             label = "EPCQ Flash 0 raw data";
>>> +                                             reg = <0x0 0x1000000>;
>>> +                                     };
>>> +                                     partition@1000000 {
>>> +                                             /* 16 MB for jffs2 data. */
>>> +                                             label = "EPCQ Flash 0 JFFS 2";
>>> +                                             reg = <0x1000000 0x1000000>;
>>> +                                     };
>>> +                             };
>>> +                     }; //end epcq@0x000000000 (epcq_controller_0)
>>> diff --git a/drivers/mtd/devices/Kconfig b/drivers/mtd/devices/Kconfig
>>> index c49d0b1..020b864 100644
>>> --- a/drivers/mtd/devices/Kconfig
>>> +++ b/drivers/mtd/devices/Kconfig
>>> @@ -218,6 +218,18 @@ config MTD_ST_SPI_FSM
>>>         SPI Fast Sequence Mode (FSM) Serial Flash Controller and support
>>>         for a subset of connected Serial Flash devices.
>>>
>>> +config MTD_ALTERA_EPCQ
>>> +     tristate "Support Altera EPCQ/EPCS Flash chips"
>>> +     depends on OF
>>> +     help
>>> +       This enables access to Altera EPCQ/EPCS flash chips, used for data
>>> +       storage. See the driver source for the current list,
>>> +       or to add other chips.
>>> +
>>> +       If you want to compile this driver as a module ( = code which can be
>>> +       inserted in and removed from the running kernel whenever you want),
>>> +       say M here and read <file:Documentation/kbuild/modules.txt>.
>>> +
>>>  if MTD_DOCG3
>>>  config BCH_CONST_M
>>>       default 14
>>> diff --git a/drivers/mtd/devices/Makefile b/drivers/mtd/devices/Makefile
>>> index f0b0e61..b429c4d 100644
>>> --- a/drivers/mtd/devices/Makefile
>>> +++ b/drivers/mtd/devices/Makefile
>>> @@ -16,6 +16,6 @@ obj-$(CONFIG_MTD_SPEAR_SMI) += spear_smi.o
>>>  obj-$(CONFIG_MTD_SST25L)     += sst25l.o
>>>  obj-$(CONFIG_MTD_BCM47XXSFLASH)      += bcm47xxsflash.o
>>>  obj-$(CONFIG_MTD_ST_SPI_FSM)    += st_spi_fsm.o
>>> -
>>> +obj-$(CONFIG_MTD_ALTERA_EPCQ)                += altera_epcq.o
>>>
>>>  CFLAGS_docg3.o                       += -I$(src)
>>> diff --git a/drivers/mtd/devices/altera_epcq.c b/drivers/mtd/devices/altera_epcq.c
>>> new file mode 100644
>>> index 0000000..09213d5
>>> --- /dev/null
>>> +++ b/drivers/mtd/devices/altera_epcq.c
>>> @@ -0,0 +1,804 @@
>>> +/*
>>> + * Copyright (C) 2014 Altera Corporation. All rights reserved
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms and conditions of the GNU General Public License,
>>> + * version 2, as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope it will be useful, but WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>>> + * more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License along with
>>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>>> + */
>>> +
>>> +#include <linux/clk.h>
>>> +#include <linux/delay.h>
>>> +#include <linux/device.h>
>>> +#include <linux/err.h>
>>> +#include <linux/errno.h>
>>> +#include <linux/interrupt.h>
>>> +#include <linux/io.h>
>>> +#include <linux/ioport.h>
>>> +#include <linux/jiffies.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/log2.h>
>>> +#include <linux/module.h>
>>> +#include <linux/mtd/mtd.h>
>>> +#include <linux/mtd/partitions.h>
>>> +#include <linux/mutex.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> +#include <linux/param.h>
>>> +#include <linux/platform_device.h>
>>> +#include <linux/pm.h>
>>> +#include <linux/sched.h>
>>> +#include <linux/slab.h>
>>> +#include <linux/wait.h>
>>> +
>>> +#include "altera_epcq.h"
>>> +
>>> +/* data structure to maintain flash ids from different vendors */
>>> +struct flash_device {
>>> +     char *name;
>>> +     bool is_epcs;
>>> +     u32 device_id;
>>> +     uint32_t sectorsize_inbytes;
>>> +     uint64_t size_inbytes;
>>> +     u32 pagesize;
>>> +};
>>> +
>>> +#define FLASH_ID(_n, _is_epcs, _id, _ssize, _size, _psize)   \
>>> +{                            \
>>> +     .name = (_n),           \
>>> +     .is_epcs = (_is_epcs),          \
>>> +     .device_id = (_id),     \
>>> +     .sectorsize_inbytes = (_ssize), \
>>> +     .size_inbytes = (_size),        \
>>> +     .pagesize = (_psize),   \
>>> +}
>>> +
>>> +static struct flash_device flash_devices[] = {
>>> +     FLASH_ID("epcq16"    , 0, 0x15, 0x10000, 0x200000, 0x100),
>>> +     FLASH_ID("epcq32"    , 0, 0x16, 0x10000, 0x400000, 0x100),
>>> +     FLASH_ID("epcq64"    , 0, 0x17, 0x10000, 0x800000, 0x100),
>>> +     FLASH_ID("epcq128"   , 0, 0x18, 0x10000, 0x1000000, 0x100),
>>> +     FLASH_ID("epcq256"   , 0, 0x19, 0x10000, 0x2000000, 0x100),
>>> +     FLASH_ID("epcq512"   , 0, 0x20, 0x10000, 0x4000000, 0x100),
>>> +
>>> +     FLASH_ID("epcs16"    , 1, 0x14, 0x10000, 0x200000, 0x100),
>>> +     FLASH_ID("epcs64"    , 1, 0x16, 0x10000, 0x800000, 0x100),
>>> +     FLASH_ID("epcs128"   , 1, 0x18, 0x40000, 0x1000000, 0x100),
>>> +};
>>> +
>>> +static inline struct altera_epcq_flash *get_flash_data(struct mtd_info *mtd)
>>> +{
>>> +     return container_of(mtd, struct altera_epcq_flash, mtd);
>>> +}
>>> +
>>> +static u32 altera_epcq_read_sr(struct altera_epcq *dev)
>>> +{
>>> +     return readl(dev->csr_base + EPCQ_SR_REG);
>>> +}
>>> +
>>> +static int altera_epcq_wait_till_ready(struct altera_epcq *dev)
>>> +{
>>> +     unsigned long finish;
>>> +     int status;
>>> +
>>> +     finish = jiffies + EPCQ_MAX_TIME_OUT;
>>> +     do {
>>> +             status = altera_epcq_read_sr(dev);
>>> +             if (status < 0)
>>> +                     return status;
>>> +             else if (!(status & EPCQ_SR_WIP))
>>> +                     return 0;
>>> +
>>> +             cond_resched();
>>> +     } while (!time_after_eq(jiffies, finish));
>>> +
>>> +     dev_err(&dev->pdev->dev, "epcq controller is busy, timeout\n");
>>> +     return -EBUSY;
>>> +}
>>> +
>>> +static int get_flash_index(u32 flash_id, bool is_epcs)
>>> +{
>>> +     int index;
>>> +
>>> +     for (index = 0; index < ARRAY_SIZE(flash_devices); index++) {
>>> +             if (flash_devices[index].device_id == flash_id &&
>>> +                 flash_devices[index].is_epcs == is_epcs)
>>> +                     return index;
>>> +     }
>>> +
>>> +     /* Memory chip is not listed and not supported */
>>> +     return -ENODEV;
>>> +}
>>> +
>>> +static int altera_epcq_write_erase_check(struct altera_epcq *dev,
>>> +                                      bool write_erase)
>>> +{
>>> +     u32 val;
>>> +     u32 mask;
>>> +
>>> +     if (write_erase)
>>> +             mask = EPCQ_ISR_ILLEGAL_WRITE_MASK;
>>> +     else
>>> +             mask = EPCQ_ISR_ILLEGAL_ERASE_MASK;
>>> +
>>> +     val = readl(dev->csr_base + EPCQ_ISR_REG);
>>> +     if (val & mask) {
>>> +             dev_err(&dev->pdev->dev,
>>> +                     "write/erase failed, sector might be protected\n");
>>> +             /*clear this status for next use*/
>>> +             writel(val, dev->csr_base + EPCQ_ISR_REG);
>>> +             return -EIO;
>>> +     }
>>> +     return 0;
>>> +}
>>> +
>>> +static int altera_epcq_erase_chip(struct mtd_info *mtd)
>>> +{
>>> +     int ret;
>>> +     u32 val;
>>> +     struct altera_epcq *dev = mtd->priv;
>>> +
>>> +     /* Wait until finished previous write command. */
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>
>> This pattern is pretty silly. We don't need to have every operation
>> check the status of the previous operation. Each operation should check
>> itself. You obviously copied this one... but we recently changed that:
>>
>>     commit dfa9c0cba4ea20e766bbb4f89152b05d00ab9ab3
>>     Author: Brian Norris <computersforpeace@gmail.com>
>>     Date:   Wed Aug 6 18:16:57 2014 -0700
>>
>>         mtd: spi-nor: move "wait-till-ready" checks into erase/write
>>         functions
>>
>>
>>     https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=dfa9c0cba4ea20e766bbb4f89152b05d00ab9ab3
>>
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     /* erase chip. */
>>> +     val = EPCQ_MEM_OP_BULK_ERASE_CMD;
>>> +     writel(val, dev->csr_base + EPCQ_MEM_OP_REG);
>>> +
>>> +     /* Wait until finished previous write command. */
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +      /* check whether write triggered a illegal write interrupt */
>>> +     ret = altera_epcq_write_erase_check(dev, 0);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int altera_epcq_addr_to_sector(struct altera_epcq_flash *flash,
>>> +                                   int addr_offset)
>>> +{
>>> +     int sector = 0;
>>> +     int i;
>>> +
>>> +     for (i = 0; i < flash->num_sectors; i++) {
>>> +             if (addr_offset >= i * flash->mtd.erasesize && addr_offset <
>>> +                 (i * flash->mtd.erasesize + flash->mtd.erasesize)) {
>>> +                     sector = i;
>>> +                     return sector;
>>> +             }
>>> +     }
>>
>> Uh, really? Am I crazy, or shouldn't this whole function just be a
>> really simple arithmetic operation? Like:
>>
>>         return addr_offset >> mtd->erasesize_shift;
>>
>>> +     return -1;
>>> +}
>>> +
>>> +static int altera_epcq_erase_sector(struct mtd_info *mtd,
>>> +                                 int addr_offset)
>>> +{
>>> +     struct altera_epcq_flash *flash = get_flash_data(mtd);
>>> +     struct altera_epcq *dev = mtd->priv;
>>> +     u32 val;
>>> +     int ret;
>>> +     int sector_value;
>>> +
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +     sector_value = altera_epcq_addr_to_sector(flash, addr_offset);
>>> +
>>> +     /* sanity check that block_offset is a valid sector number */
>>> +     if (sector_value < 0)
>>> +             return -EINVAL;
>>> +
>>> +     /* sector value should occupy bits 17:8 */
>>> +     val = (sector_value << 8) & EPCQ_MEM_OP_SECTOR_VALUE_MASK;
>>> +
>>> +     /* sector erase commands occupies lower 2 bits */
>>> +     val |= EPCQ_MEM_OP_SECTOR_ERASE_CMD;
>>> +
>>> +     /* write sector erase command to EPCQ_MEM_OP register*/
>>> +     writel(val, dev->csr_base + EPCQ_MEM_OP_REG);
>>> +
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             return ret;
>>> +
>>> +      /* check whether write triggered a illegal write interrupt */
>>
>> ^^ extra space here? You have <TAB><SPACE>/* check [...]
>>
>>> +     ret = altera_epcq_write_erase_check(dev, 0);
>>> +     if (ret < 0)
>>> +             return ret;
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int altera_epcq_erase(struct mtd_info *mtd, struct erase_info *e_info)
>>> +{
>>> +     u32 addr;
>>> +     int ret;
>>> +     u32 len;
>>> +     struct altera_epcq_flash *flash = get_flash_data(mtd);
>>> +     struct altera_epcq *dev = mtd->priv;
>>> +
>>> +     addr = e_info->addr;
>>> +     len = e_info->len;
>>> +
>>> +     if (flash->bank > dev->num_flashes - 1) {
>>> +             dev_err(&dev->pdev->dev, "Invalid chip id\n");
>>> +             return -EINVAL;
>>> +     }
>>> +     mutex_lock(&flash->lock);
>>> +
>>> +     /*erase whole chip*/
>>> +     if (len == mtd->size) {
>>> +             if (altera_epcq_erase_chip(mtd)) {
>>> +                     e_info->state = MTD_ERASE_FAILED;
>>> +                     mutex_unlock(&flash->lock);
>>> +                     return -EIO;
>>> +             }
>>> +     /*"sector"-at-a-time erase*/
>>> +     } else {
>>> +             while (len) {
>>> +                     ret = altera_epcq_erase_sector(mtd, addr);
>>> +                     if (ret) {
>>> +                             e_info->state = MTD_ERASE_FAILED;
>>> +                             mutex_unlock(&flash->lock);
>>> +                             return -EIO;
>>> +                     }
>>> +                     addr += mtd->erasesize;
>>> +                     if (len < mtd->erasesize)
>>> +                             len = 0;
>>> +                     else
>>> +                             len -= mtd->erasesize;
>>> +             }
>>> +     }
>>> +     mutex_unlock(&flash->lock);
>>> +     e_info->state = MTD_ERASE_DONE;
>>> +     mtd_erase_callback(e_info);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int altera_epcq_read(struct mtd_info *mtd, loff_t from, size_t len,
>>> +                         size_t *retlen, u8 *buf)
>>> +{
>>> +     struct altera_epcq_flash *flash = get_flash_data(mtd);
>>> +     struct altera_epcq *dev = mtd->priv;
>>> +     void *src;
>>> +     int ret = 0;
>>> +
>>> +     if (!flash || !dev)
>>> +             return -ENODEV;
>>
>> Why would either of these be 0? If they are, you have much bigger
>> problems, since you aren't checking these almost anywhere else. And the
>> !flash check is pretty odd, since get_flash_data() is using
>> container_of(), which is not likely to give you exactly 0...
>>
>>> +
>>> +     if (flash->bank > dev->num_flashes - 1) {
>>> +             dev_err(&dev->pdev->dev, "Invalid chip id\n");
>>> +             return -EINVAL;
>>> +     }
>>> +
>>> +     src = dev->data_base + from;
>>> +
>>> +     mutex_lock(&flash->lock);
>>> +     /* wait till previous write/erase is done. */
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     memcpy_fromio(buf, (u8 *)src, len);
>>
>> Drop the cast. Also, you get sparse warnings because you're dropping the
>> __iomem. Why not just this?
>>
>>         memcpy_fromio(buf, dev->data_base + from, len);
>>
>> (BTW, you might consider running sparse on all your code. See
>> Documentation/sparse.txt. It tells you how to get it, but you can often
>> just download it through your distro's package manager.)
>>
>>> +     *retlen = len;
>>> +
>>> +err:
>>> +     mutex_unlock(&flash->lock);
>>> +     return ret;
>>> +}
>>> +
>>> +static int altera_epcq_write(struct mtd_info *mtd, loff_t to, size_t len,
>>> +                          size_t *retlen, const u8 *buf)
>>> +{
>>> +     struct altera_epcq_flash *flash = get_flash_data(mtd);
>>> +     struct altera_epcq *dev = mtd->priv;
>>> +     void *dest;
>>> +     int ret = 0;
>>> +
>>> +     if (!flash || !dev)
>>> +             return -ENODEV;
>>
>> Also here. I don't think you need these checks.
>>
>>> +
>>> +     if (flash->bank > dev->num_flashes - 1) {
>>> +             dev_err(&dev->pdev->dev, "Invalid chip id\n");
>>> +             return -EINVAL;
>>> +     }
>>> +     dest = dev->data_base + to;
>>> +
>>> +     mutex_lock(&flash->lock);
>>> +
>>> +     /* wait until finished previous write command. */
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     memcpy_toio(dest, buf, len);
>>
>> Similar. Why not just this?
>>
>>         memcpy_toio(dev->data_base + to, buf, len);
>>
>>> +     *retlen += len;
>>> +
>>> +     /* wait until finished previous write command. */
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +      /* check whether write triggered a illegal write interrupt */
>>> +     ret = altera_epcq_write_erase_check(dev, 1);
>>> +     if (ret < 0)
>>> +             goto err;
>>> +
>>> +err:
>>> +     mutex_unlock(&flash->lock);
>>> +     return ret;
>>> +}
>>> +
>>> +static int altera_epcq_lock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>>> +{
>>> +     struct altera_epcq_flash *flash = get_flash_data(mtd);
>>> +     struct altera_epcq *dev = mtd->priv;
>>> +     uint32_t offset = ofs;
>>> +     int ret = 0;
>>> +     u32 sector_start, sector_end;
>>> +     u32 num_sectors;
>>> +     u32 mem_op;
>>> +     unsigned sr_bp = 0;
>>> +     unsigned sr_tb = 0;
>>> +
>>> +     sector_start = altera_epcq_addr_to_sector(flash, offset);
>>> +     sector_end = altera_epcq_addr_to_sector(flash, offset + len);
>>> +     num_sectors = flash->num_sectors;
>>> +     dev_dbg(&dev->pdev->dev,
>>> +             "%s: num_setor is %u,sector start is %u,sector end is %u\n",
>>> +             __func__, num_sectors, sector_start, sector_end);
>>> +
>>> +     mutex_lock(&flash->lock);
>>> +     /* wait until finished previous write command. */
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     if (sector_start >= num_sectors/2) {
>>
>> It's preferable to have spaces around operators. So 'num_sectors / 2'.
>> The same thing comes up in several other places.
>>
>>> +             if (sector_start < num_sectors-(num_sectors / 4))
>>> +                     sr_bp = __ilog2_u32(num_sectors);
>>> +             else if (sector_start < num_sectors-(num_sectors / 8))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 1;
>>> +             else if (sector_start < num_sectors-(num_sectors / 16))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 2;
>>> +             else if (sector_start < num_sectors-(num_sectors / 32))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 3;
>>> +             else if (sector_start < num_sectors-(num_sectors / 64))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 4;
>>> +             else if (sector_start < num_sectors-(num_sectors / 128))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 5;
>>> +             else if (sector_start < num_sectors-(num_sectors / 256))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 6;
>>> +             else if (sector_start < num_sectors-(num_sectors / 512))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 7;
>>> +             else if (sector_start < num_sectors-(num_sectors / 1024))
>>> +                     sr_bp = __ilog2_u32(num_sectors) - 8;
>>> +             else
>>> +                     sr_bp = 0;  /* non area protected */
>>
>> Yikes, that's ugly! And I'm not sure it matches the EPCQ doc I found.
>> I'm pretty sure you can rewrite this if/else-if/else block in about 1
>> line though.
>>
>>> +
>>> +             if (sr_bp < 0) {
>>
>> sr_bp is unsigned, so this is never true.
>>
>>> +                     dev_err(&dev->pdev->dev, "%s: address is out of range\n"
>>> +                             , __func__);
>>> +                     ret = -EINVAL;
>>> +                     goto err;
>>> +             }
>>> +             /*set TB = 0*/
>>> +             sr_tb = 0;
>>> +
>>> +     } else {
>>> +             if (sector_end < 1)
>>> +                     sr_bp = 1;
>>> +             else if (sector_end < 2)
>>> +                     sr_bp = 2;
>>> +             else if (sector_end < 4)
>>> +                     sr_bp = 3;
>>> +             else if (sector_end < 8)
>>> +                     sr_bp = 4;
>>> +             else if (sector_end < 16)
>>> +                     sr_bp = 5;
>>> +             else if (sector_end < 32)
>>> +                     sr_bp = 6;
>>> +             else if (sector_end < 64)
>>> +                     sr_bp = 7;
>>> +             else if (sector_end < 128)
>>> +                     sr_bp = 8;
>>> +             else if (sector_end < 256)
>>> +                     sr_bp = 9;
>>> +             else if (sector_end < 512)
>>> +                     sr_bp = 10;
>>> +             else
>>> +                     sr_bp = 16; /*protect all areas*/
>>
>> Again, this is ugly. How about this?
>>
>>         sr_bp = fls(sector_end) + 1;
>>
>>> +
>>> +             sr_tb = 1;
>>> +     }
>>> +
>>> +     mem_op = (sr_tb << 12) | (sr_bp << 8);
>>> +     mem_op &= EPCQ_MEM_OP_SECTOR_PROTECT_VALUE_MASK;
>>> +     mem_op |= EPCQ_MEM_OP_SECTOR_PROTECT_CMD;
>>> +     writel(mem_op, dev->csr_base + EPCQ_MEM_OP_REG);
>>> +
>>> +err:
>>> +     mutex_unlock(&flash->lock);
>>> +     return ret;
>>> +}
>>> +
>>> +static int altera_epcq_unlock(struct mtd_info *mtd, loff_t ofs, uint64_t len)
>>> +{
>>> +     struct altera_epcq_flash *flash = get_flash_data(mtd);
>>> +     struct altera_epcq *dev = mtd->priv;
>>> +
>>> +     int ret = 0;
>>> +     u32 mem_op;
>>> +
>>> +     mutex_lock(&flash->lock);
>>> +     /* wait until finished previous write command. */
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             goto err;
>>> +     dev_info(&dev->pdev->dev, "Unlock all protected area\n");
>>> +     mem_op = 0;
>>> +     mem_op &= EPCQ_MEM_OP_SECTOR_PROTECT_VALUE_MASK;
>>> +     mem_op |= EPCQ_MEM_OP_SECTOR_PROTECT_CMD;
>>> +     writel(mem_op, dev->csr_base + EPCQ_MEM_OP_REG);
>>> +
>>> +err:
>>> +     mutex_unlock(&flash->lock);
>>> +     return ret;
>>> +}
>>> +
>>> +static void altera_epcq_chip_select(struct altera_epcq *dev, u32 bank)
>>> +{
>>> +     u32 val = 0;
>>> +
>>> +     switch (bank) {
>>> +     case 0:
>>> +             val = EPCQ_CHIP_SELECT_0;
>>> +             break;
>>> +     case 1:
>>> +             val = EPCQ_CHIP_SELECT_1;
>>> +             break;
>>> +     case 2:
>>> +             val = EPCQ_CHIP_SELECT_2;
>>> +             break;
>>> +     default:
>>> +             return;
>>> +     }
>>> +
>>> +     writel(val, dev->csr_base + EPCQ_CHIP_SELECT_REG);
>>> +}
>>> +
>>> +static int altera_epcq_probe_flash(struct altera_epcq *dev, u32 bank)
>>> +{
>>> +     int ret = 0;
>>> +     u32 val = 0;
>>> +
>>> +     mutex_lock(&dev->lock);
>>> +
>>> +     /*select bank*/
>>
>> Comment spacing, here and elsewhere:
>>
>>         /* select bank */
>>
>>> +     altera_epcq_chip_select(dev, bank);
>>> +
>>> +     ret = altera_epcq_wait_till_ready(dev);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     /* get device sillicon id */
>>> +     if (dev->is_epcs)
>>> +             val = readl(dev->csr_base + EPCQ_SID_REG);
>>> +     else
>>> +             val = readl(dev->csr_base + EPCQ_RDID_REG);
>>> +
>>> +     /* get flash index based on the device list*/
>>> +     ret = get_flash_index(val, dev->is_epcs);
>>> +     return 0;
>>> +err:
>>> +     mutex_unlock(&dev->lock);
>>> +     return ret;
>>> +}
>>> +
>>> +static int altera_epcq_probe_config_dt(struct platform_device *pdev,
>>> +                                    struct device_node *np,
>>> +                                    struct altera_epcq_plat_data *pdata)
>>> +{
>>> +     struct device_node *pp = NULL;
>>> +     struct resource *epcq_res;
>>> +     int i = 0;
>>> +     u32 id;
>>> +
>>> +     pdata->is_epcs = of_property_read_bool(np, "is-epcs");
>>> +
>>> +     epcq_res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>>> +                                             "csr_base");
>>> +     if (!epcq_res) {
>>
>> devm_ioremap_resource() will check the that 'epcq_res' is valid, so you
>> don't need this whole 'if' block.
>>
>>> +             dev_err(&pdev->dev, "resource csr base is not defined\n");
>>> +             return -ENODEV;
>>> +     }
>>> +
>>> +     pdata->csr_base = devm_ioremap_resource(&pdev->dev, epcq_res);
>>> +     if (IS_ERR(pdata->csr_base)) {
>>> +             dev_err(&pdev->dev, "%s: ERROR: failed to map csr base\n",
>>> +                     __func__);
>>> +             return PTR_ERR(pdata->csr_base);
>>> +     }
>>> +
>>> +     epcq_res = platform_get_resource_byname(pdev, IORESOURCE_MEM,
>>> +                                             "data_base");
>>> +     if (!epcq_res) {
>>
>> Same here.
>>
>>> +             dev_err(&pdev->dev, "resource data base is not defined\n");
>>> +             return -ENODEV;
>>> +     }
>>> +
>>> +     pdata->data_base = devm_ioremap_resource(&pdev->dev, epcq_res);
>>> +     if (IS_ERR(pdata->data_base)) {
>>> +             dev_err(&pdev->dev, "%s: ERROR: failed to map data base\n",
>>> +                     __func__);
>>> +             return PTR_ERR(pdata->data_base);
>>> +     }
>>> +
>>> +     pdata->board_flash_info = devm_kzalloc(&pdev->dev,
>>> +                                            sizeof(*pdata->board_flash_info),
>>> +                                            GFP_KERNEL);
>>> +
>>> +     /* Fill structs for each subnode (flash device) */
>>> +     while ((pp = of_get_next_child(np, pp))) {
>>
>> for_each_available_child_of_node()?
>>
>>> +             struct altera_epcq_flash_info *flash_info;
>>> +
>>> +             flash_info = &pdata->board_flash_info[i];
>>
>> This is never used. Either use it below, or drop the local variable.
>>
>>> +             pdata->np[i] = pp;
>>> +
>>> +             /* Read bank id from DT */
>>> +             if (of_get_property(pp, "reg", &id))
>>
>> Is this property optional? Your DT binding doc doesn't make it clear,
>> but it seems like a property which would be wise to require (i.e., not
>> optional).
>>
>>> +                     pdata->board_flash_info[i].bank = id;
>>> +             i++;
>>> +     }
>>> +     pdata->num_flashes = i;
>>> +     return 0;
>>> +}
>>> +
>>> +static int altera_epcq_setup_banks(struct platform_device *pdev,
>>> +                                u32 bank, struct device_node *np,
>>> +                                struct altera_epcq_plat_data *pdata)
>>> +{
>>> +     struct altera_epcq *dev = platform_get_drvdata(pdev);
>>> +     struct mtd_part_parser_data ppdata = {};
>>> +     struct altera_epcq_flash_info *flash_info;
>>> +     struct altera_epcq_flash *flash;
>>> +     struct mtd_partition *parts = NULL;
>>
>> Drop this variable. Just use NULL directly below.
>>
>>> +     int count = 0;
>>
>> Same. Just use 0 below.
>>
>>> +     int flash_index;
>>> +     int ret = 0;
>>> +     uint64_t size;
>>> +     uint32_t sector_size;
>>> +
>>> +     flash_info = &pdata->board_flash_info[bank];
>>> +     if (!flash_info)
>>> +             return -ENODEV;
>>> +
>>> +     if (bank > pdata->num_flashes - 1)
>>> +             return -EINVAL;
>>> +
>>> +     flash = devm_kzalloc(&pdev->dev, sizeof(*flash), GFP_KERNEL);
>>> +     if (!flash)
>>> +             return -ENOMEM;
>>> +     flash->bank = bank;
>>> +
>>> +     mutex_init(&flash->lock);
>>> +
>>> +     /* verify whether flash is really present on board */
>>> +     flash_index = altera_epcq_probe_flash(dev, bank);
>>> +     if (flash_index < 0) {
>>> +             dev_info(&dev->pdev->dev, "epcq:flash%d not found\n",
>>> +                      flash->bank);
>>> +             return flash_index;
>>> +     }
>>> +
>>> +     dev->flash[bank] = flash;
>>> +
>>> +     size = flash_devices[flash_index].size_inbytes;
>>> +     sector_size = flash_devices[flash_index].sectorsize_inbytes;
>>> +     /*use do_div instead of plain div to avoid linker err*/
>>> +     do_div(size, sector_size);
>>> +     flash->num_sectors = size;
>>> +
>>> +     /*mtd framework */
>>> +     flash->mtd.priv = dev;
>>> +     flash->mtd.name = flash_devices[flash_index].name;
>>> +     flash->mtd.type = MTD_NORFLASH;
>>> +     flash->mtd.writesize = 1;
>>> +     flash->mtd.flags = MTD_CAP_NORFLASH;
>>> +     flash->mtd.size = flash_devices[flash_index].size_inbytes;
>>> +     flash->mtd.erasesize = flash_devices[flash_index].sectorsize_inbytes;
>>> +     flash->mtd._erase = altera_epcq_erase;
>>> +     flash->mtd._read = altera_epcq_read;
>>> +     flash->mtd._write = altera_epcq_write;
>>> +     flash->mtd._lock = altera_epcq_lock;
>>> +     flash->mtd._unlock = altera_epcq_unlock;
>>> +
>>> +     dev_info(&pdev->dev, "mtd .name=%s .size=0x%llx (%lluM)\n",
>>> +              flash->mtd.name, (long long)flash->mtd.size,
>>> +              (long long)(flash->mtd.size >> 20));
>>> +
>>> +     dev_info(&pdev->dev, ".erasesize = 0x%x(%uK)\n",
>>> +              flash->mtd.erasesize, flash->mtd.erasesize >> 10);
>>> +
>>> +     ppdata.of_node = np;
>>> +
>>> +     ret = mtd_device_parse_register(&flash->mtd, NULL, &ppdata, parts,
>>> +                                     count);
>>> +     if (ret) {
>>> +             dev_err(&pdev->dev, "Err MTD partition=%d\n", ret);
>>> +             goto err;
>>
>> You don't want to unregister a MTD that failed to register. The MTD core
>> code should handle that itself.
>>
>> Instead of this if (ret) {} block, I'd just make this:
>>
>>         return mtd_device_parse_register(&flash->mtd, NULL, &ppdata, NULL, 0);
>>
>>> +     }
>>> +
>>> +     return 0;
>>> +
>>> +err:
>>> +     mtd_device_unregister(&flash->mtd);
>>> +     return ret;
>>> +}
>>> +
>>> +static int altera_epcq_probe(struct platform_device *pdev)
>>> +{
>>> +     struct device_node *np = pdev->dev.of_node;
>>> +     struct altera_epcq_plat_data *pdata = NULL;
>>> +     struct altera_epcq *dev;
>>> +     int ret = 0;
>>> +     int i;
>>> +
>>> +     if (!np) {
>>> +             ret = -ENODEV;
>>> +             dev_err(&pdev->dev, "no device found\n");
>>> +             goto err;
>>> +     }
>>> +
>>> +     pdata = devm_kzalloc(&pdev->dev,
>>> +                          sizeof(struct altera_epcq_plat_data),
>>> +                          GFP_KERNEL);
>>> +
>>> +     if (!pdata) {
>>> +             ret = -ENOMEM;
>>> +             dev_err(&pdev->dev, "%s: ERROR: no memory\n", __func__);
>>
>> Unnecessary print. The MM code will print plenty of info if you're
>> out of memory.
>>
>>> +             goto err;
>>> +     }
>>> +     ret = altera_epcq_probe_config_dt(pdev, np, pdata);
>>> +     if (ret) {
>>> +             ret = -ENODEV;
>>> +             dev_err(&pdev->dev, "probe fail\n");
>>> +             goto err;
>>> +     }
>>> +
>>> +     dev = devm_kzalloc(&pdev->dev, sizeof(*dev), GFP_ATOMIC);
>>> +     if (!dev) {
>>> +             ret = -ENOMEM;
>>> +             dev_err(&pdev->dev, "mem alloc fail\n");
>>
>> Same here.
>>
>>> +             goto err;
>>> +     }
>>> +     mutex_init(&dev->lock);
>>> +     dev->pdev = pdev;
>>> +     dev->is_epcs = pdata->is_epcs;
>>> +     dev->csr_base = pdata->csr_base;
>>> +     dev->data_base = pdata->data_base;
>>> +
>>> +     /*check number of flashes*/
>>> +     dev->num_flashes = pdata->num_flashes;
>>> +     if (dev->num_flashes > MAX_NUM_FLASH_CHIP) {
>>> +             dev_err(&pdev->dev, "exceeding max number of flashes\n");
>>> +             dev->num_flashes = MAX_NUM_FLASH_CHIP;
>>> +     }
>>> +
>>> +     /* check clock*/
>>> +     dev->clk = devm_clk_get(&pdev->dev, NULL);
>>> +     if (IS_ERR(dev->clk)) {
>>> +             ret = PTR_ERR(dev->clk);
>>> +             goto err;
>>> +     }
>>> +     ret = clk_prepare_enable(dev->clk);
>>> +     if (ret)
>>> +             goto err;
>>> +
>>> +     platform_set_drvdata(pdev, dev);
>>> +
>>> +     /* loop for each serial flash which is connected to epcq */
>>> +     for (i = 0; i < dev->num_flashes; i++) {
>>> +             ret = altera_epcq_setup_banks(pdev, i, pdata->np[i], pdata);
>>> +             if (ret) {
>>> +                     dev_err(&pdev->dev, "bank setup failed\n");
>>> +                     goto err_bank_setup;
>>> +             }
>>> +     }
>>> +
>>> +     return 0;
>>> +
>>> +err_bank_setup:
>>> +     clk_disable_unprepare(dev->clk);
>>> +err:
>>> +     return ret;
>>> +}
>>> +
>>> +static int altera_epcq_remove(struct platform_device *pdev)
>>> +{
>>> +     struct altera_epcq *dev;
>>> +     struct altera_epcq_flash *flash;
>>> +     int ret, i;
>>> +
>>> +     dev = platform_get_drvdata(pdev);
>>> +
>>> +     /* clean up for all nor flash */
>>> +     for (i = 0; i < dev->num_flashes; i++) {
>>> +             flash = dev->flash[i];
>>> +             if (!flash)
>>> +                     continue;
>>> +
>>> +             /* clean up mtd stuff */
>>> +             ret = mtd_device_unregister(&flash->mtd);
>>> +             if (ret)
>>> +                     dev_err(&pdev->dev, "error removing mtd\n");
>>> +     }
>>> +
>>> +     clk_disable_unprepare(dev->clk);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +#ifdef CONFIG_PM
>>
>> Make this CONFIG_PM_SLEEP.
>>
>>> +static int altera_epcq_suspend(struct device *dev)
>>> +{
>>> +     struct altera_epcq *sdev = dev_get_drvdata(dev);
>>> +
>>> +     clk_disable_unprepare(sdev->clk);
>>> +
>>> +     return 0;
>>> +}
>>> +
>>> +static int altera_epcq_resume(struct device *dev)
>>> +{
>>> +     struct altera_epcq *sdev = dev_get_drvdata(dev);
>>> +     int ret = -EPERM;
>>
>> Drop 'ret'.
>>
>>> +
>>> +     ret = clk_prepare_enable(sdev->clk);
>>
>> Just:
>>
>>         return clk_prepare_enable(sdev->clk);
>>
>>> +
>>> +     return ret;
>>> +}
>>> +
>>> +static SIMPLE_DEV_PM_OPS(altera_epcq_pm_ops, altera_epcq_suspend,
>>> +                      altera_epcq_resume);
>>> +#endif
>>> +
>>> +static const struct of_device_id altera_epcq_id_table[] = {
>>> +     { .compatible = "altr,epcq-1.0" },
>>> +     {}
>>> +};
>>> +MODULE_DEVICE_TABLE(of, altera_epcq_id_table);
>>> +
>>> +static struct platform_driver altera_epcq_driver = {
>>> +     .driver = {
>>> +             .name = ALTERA_EPCQ_RESOURCE_NAME,
>>> +             .bus = &platform_bus_type,
>>> +             .owner = THIS_MODULE,
>>
>> The .owner assignment is no longer necessary.
>>
>>> +             .of_match_table = altera_epcq_id_table,
>>> +#ifdef CONFIG_PM
>>
>> Also CONFIG_PM_SLEEP.
>>
>>> +             .pm = &altera_epcq_pm_ops,
>>> +#endif
>>> +     },
>>> +     .probe = altera_epcq_probe,
>>> +     .remove = altera_epcq_remove,
>>> +};
>>> +module_platform_driver(altera_epcq_driver);
>>> +
>>> +MODULE_AUTHOR("Viet Nga Dao <vndao@altera.com>");
>>> +MODULE_DESCRIPTION("MTD Altera EPCQ Driver");
>>> +MODULE_LICENSE("GPL v2");
>>> diff --git a/drivers/mtd/devices/altera_epcq.h b/drivers/mtd/devices/altera_epcq.h
>>> new file mode 100644
>>> index 0000000..c3d15e5
>>> --- /dev/null
>>> +++ b/drivers/mtd/devices/altera_epcq.h
>>> @@ -0,0 +1,130 @@
>>> +/*
>>> + * Copyright (C) 2014 Altera Corporation. All rights reserved
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify it
>>> + * under the terms and conditions of the GNU General Public License,
>>> + * version 2, as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope it will be useful, but WITHOUT
>>> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
>>> + * more details.
>>> + *
>>> + * You should have received a copy of the GNU General Public License along with
>>> + * this program.  If not, see <http://www.gnu.org/licenses/>.
>>> + */
>>> +
>>> +#ifndef __ALTERA_ECPQ_H
>>> +#define __ALTERA_ECPQ_H
>>> +
>>> +#define ALTERA_EPCQ_RESOURCE_NAME        "altera_epcq"
>>> +/* max possible slots for serial flash chip in the EPCQ controller */
>>> +#define MAX_NUM_FLASH_CHIP   3
>>> +
>>> +/* macro to define partitions for flash devices */
>>> +#define DEFINE_PARTS(n, of, s)               \
>>
>> This macro is not used anywhere. Drop it?
>>
>>> +{                                    \
>>> +     .name = n,                      \
>>> +     .offset = of,                   \
>>> +     .size = s,                      \
>>> +}
>>> +
>>> +struct altera_epcq_flash_info {
>>> +     u32 bank;
>>> +     struct mtd_partition *partitions;
>>> +     int nr_partitions;
>>> +};
>>> +
>>> +struct altera_epcq_plat_data {
>>> +     void __iomem *csr_base;
>>> +     void __iomem *data_base;
>>> +     bool is_epcs;
>>> +     u32 num_flashes;
>>> +     struct altera_epcq_flash_info *board_flash_info;
>>> +     struct device_node *np[MAX_NUM_FLASH_CHIP];
>>> +};
>>> +
>>> +struct altera_epcq {
>>> +     struct clk *clk;
>>> +     bool is_epcs;
>>> +     struct mutex lock;      /*device lock*/
>>> +     void __iomem *csr_base;
>>> +     void __iomem *data_base;
>>> +     struct platform_device *pdev;
>>> +     u32 num_flashes;
>>> +     struct altera_epcq_flash *flash[MAX_NUM_FLASH_CHIP];
>>> +};
>>> +
>>> +struct altera_epcq_flash {
>>> +     u32 bank;
>>> +     u32 num_sectors;
>>> +     u32 num_parts;
>>> +     struct mtd_partition *parts;
>>> +     struct mutex lock;      /*flash lock*/
>>> +     struct mtd_info mtd;
>>> +};
>>> +
>>> +/* Define max times to check status register before we give up. */
>>> +#define EPCQ_MAX_TIME_OUT                    (40 * HZ)
>>> +
>>> +/* defines for status register */
>>> +#define EPCQ_SR_REG                          0x0
>>> +#define EPCQ_SR_WIP_MASK                     0x00000001
>>> +#define EPCQ_SR_WIP                          0x1
>>> +#define EPCQ_SR_WEL                          0x2
>>> +#define EPCQ_SR_BP0                          0x4
>>> +#define EPCQ_SR_BP1                          0x8
>>> +#define EPCQ_SR_BP2                          0x10
>>> +#define EPCQ_SR_BP3                          0x40
>>> +#define EPCQ_SR_TB                           0x20
>>> +
>>> +/* defines for device id register */
>>> +#define EPCQ_SID_REG                         0x4
>>> +#define EPCQ_RDID_REG                                0x8
>>> +#define EPCQ_RDID_MASK                               0x000000FF
>>> +/*
>>> + * EPCQ_MEM_OP register offset
>>> + *
>>> + * The EPCQ_MEM_OP register is used to do memory protect and erase operations
>>> + *
>>> + */
>>> +#define EPCQ_MEM_OP_REG                              0xC
>>> +
>>> +#define EPCQ_MEM_OP_CMD_MASK                 0x00000003
>>> +#define EPCQ_MEM_OP_BULK_ERASE_CMD           0x00000001
>>> +#define EPCQ_MEM_OP_SECTOR_ERASE_CMD         0x00000002
>>> +#define EPCQ_MEM_OP_SECTOR_PROTECT_CMD               0x00000003
>>> +#define EPCQ_MEM_OP_SECTOR_VALUE_MASK                0x0003FF00
>>> +#define EPCQ_MEM_OP_SECTOR_PROTECT_VALUE_MASK        0x00001F00
>>> +#define EPCQ_MEM_OP_SECTOR_PROTECT_SHIFT     8
>>> +/*
>>> + * EPCQ_ISR register offset
>>> + *
>>> + * The EPCQ_ISR register is used to determine whether an invalid write or erase
>>> + * operation trigerred an interrupt
>>> + *
>>> + */
>>> +#define EPCQ_ISR_REG                         0x10
>>> +
>>> +#define EPCQ_ISR_ILLEGAL_ERASE_MASK          0x00000001
>>> +#define EPCQ_ISR_ILLEGAL_WRITE_MASK          0x00000002
>>> +
>>> +/*
>>> + * EPCQ_IMR register offset
>>> + *
>>> + * The EPCQ_IMR register is used to mask the invalid erase or the invalid write
>>> + * interrupts.
>>> + *
>>> + */
>>> +#define EPCQ_IMR_REG                         0x14
>>> +#define EPCQ_IMR_ILLEGAL_ERASE_MASK          0x00000001
>>> +
>>> +#define EPCQ_IMR_ILLEGAL_WRITE_MASK          0x00000002
>>> +
>>> +#define EPCQ_CHIP_SELECT_REG                 0x18
>>> +#define EPCQ_CHIP_SELECT_MASK                        0x00000007
>>> +#define EPCQ_CHIP_SELECT_0                   0x00000001
>>> +#define EPCQ_CHIP_SELECT_1                   0x00000002
>>> +#define EPCQ_CHIP_SELECT_2                   0x00000004
>>> +
>>> +#endif /* __ALTERA_ECPQ_H */
>>
>> Brian
