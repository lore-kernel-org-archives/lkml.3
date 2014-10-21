Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaJUFwZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 01:52:25 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:35890 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaJUFwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 01:52:23 -0400
MIME-Version: 1.0
In-Reply-To: <20140930053522.GA24694@roeck-us.net>
References: <1412051169-9142-1-git-send-email-ankit.jindal@linaro.org>
 <1412051169-9142-5-git-send-email-ankit.jindal@linaro.org> <20140930053522.GA24694@roeck-us.net>
From: Ankit Jindal <ankit.jindal@linaro.org>
Date: Tue, 21 Oct 2014 11:22:02 +0530
Message-ID: <CAPTm99V3YgP8N-b5TY7cosbe-Z7gi+2yUATsiCQExT_scojGJw@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] drivers: uio: Add X-Gene QMTM UIO driver
To: Guenter Roeck <linux@roeck-us.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 September 2014 11:05, Guenter Roeck <linux@roeck-us.net> wrote:
> On Tue, Sep 30, 2014 at 09:56:07AM +0530, Ankit Jindal wrote:
>> The Applied Micro X-Gene SOC has on-chip QMTM (Queue manager
>> and Traffic manager) which is hardware based Queue or Ring
>> manager. This QMTM device can be used in conjunction with
>> other devices such as DMA Engine, Ethernet, Security Engine,
>> etc to assign work based on queues or rings.
>>
>> This patch allows user space access to X-Gene QMTM device.
>>
>> Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
>> Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
>> ---
>>  drivers/uio/Kconfig          |    8 ++
>>  drivers/uio/Makefile         |    1 +
>>  drivers/uio/uio_xgene_qmtm.c |  278 ++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 287 insertions(+)
>>  create mode 100644 drivers/uio/uio_xgene_qmtm.c
>>
>> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
>> index 5a90914..76b1858 100644
>> --- a/drivers/uio/Kconfig
>> +++ b/drivers/uio/Kconfig
>> @@ -135,4 +135,12 @@ config UIO_MF624
>>
>>         If you compile this as a module, it will be called uio_mf624.
>>
>> +config UIO_XGENE_QMTM
>> +     tristate "Applied Micro X-Gene QMTM driver"
>> +     depends on OF
>> +     help
>> +       Userspace I/O interface for the X-Gene QMTM. The userspace part of
>> +       this driver will be available for download from the Applied Micro
>> +       web site (http://www.apm.com/).
>> +
>>  endif
>> diff --git a/drivers/uio/Makefile b/drivers/uio/Makefile
>> index d3218bd..633eaa0 100644
>> --- a/drivers/uio/Makefile
>> +++ b/drivers/uio/Makefile
>> @@ -8,3 +8,4 @@ obj-$(CONFIG_UIO_PCI_GENERIC) += uio_pci_generic.o
>>  obj-$(CONFIG_UIO_NETX)       += uio_netx.o
>>  obj-$(CONFIG_UIO_PRUSS)         += uio_pruss.o
>>  obj-$(CONFIG_UIO_MF624)         += uio_mf624.o
>> +obj-$(CONFIG_UIO_XGENE_QMTM) += uio_xgene_qmtm.o
>> diff --git a/drivers/uio/uio_xgene_qmtm.c b/drivers/uio/uio_xgene_qmtm.c
>> new file mode 100644
>> index 0000000..36d9000
>> --- /dev/null
>> +++ b/drivers/uio/uio_xgene_qmtm.c
>> @@ -0,0 +1,278 @@
>> +/*
>> + * X-Gene Queue Manager Traffic Manager (QMTM) UIO driver (uio_xgene_qmtm)
>> + *
>> + * This driver exports QMTM CSRs, Fabric and memory for queues to user-space
>> + *
>> + * Copyright (C) 2014 Applied Micro - http://www.apm.com/
>> + * Copyright (C) 2014 Linaro Ltd.
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License as
>> + * published by the Free Software Foundation version 2.
>> + *
>> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any
>> + * kind, whether express or implied; without even the implied warranty
>> + * of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/device.h>
>> +#include <linux/delay.h>
>> +#include <linux/module.h>
>> +#include <linux/moduleparam.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/uio_driver.h>
>> +#include <linux/io.h>
>> +#include <linux/clk.h>
>> +#include <linux/slab.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_address.h>
>> +
>> +#define DRV_NAME "qmtm_uio"
>> +#define DRV_VERSION "1.0"
>> +
>> +#define QMTM_CFG_MEM_RAM_SHUTDOWN    0x0000d070
>> +
>> +#define QMTM_DEFAULT_QSIZE           65536
>> +
>> +struct uio_qmtm_dev {
>> +     struct uio_info *info;
>> +     struct clk *qmtm_clk;
>> +};
>> +
>> +/* QMTM CSR read/write routine */
>> +static inline void qmtm_csr_write(struct uio_qmtm_dev *qmtm_dev, u32 offset,
>> +             u32 data)
>> +{
>> +     void __iomem *addr = qmtm_dev->info->mem[0].internal_addr;
>> +
>> +     writel(data, addr + offset);
>> +}
>> +
>> +static inline u32 qmtm_csr_read(struct uio_qmtm_dev *qmtm_dev, u32 offset)
>> +{
>> +     void __iomem *addr = qmtm_dev->info->mem[0].internal_addr;
>> +
>> +     return readl(addr + offset);
>> +}
>> +
>> +static int qmtm_reset(struct uio_qmtm_dev *qmtm_dev)
>> +{
>> +     u32 val;
>> +     int wait = 1000;
>> +
>> +     /* reset the internal memory of the device */
>> +     qmtm_csr_write(qmtm_dev, QMTM_CFG_MEM_RAM_SHUTDOWN, 0);
>> +
>> +     /* check whether device internal memory is out of reset or not */
>> +     while (1) {
>
> Seems to me that
>         while (wait--) {
>                 ...
>         }
>         return -EBUSY;
>
> would be much easier to understand.
>
> Also, not sure if EBUSY is really appropriate here.
> ETIMEDOUT, maybe ?
>
>> +             val = qmtm_csr_read(qmtm_dev, QMTM_CFG_MEM_RAM_SHUTDOWN);
>> +
>> +             if (val != 0xffffffff)
>> +                     return 0;
>> +
>> +             if (!wait--)
>> +                     return -EBUSY;
>> +
>> +             udelay(1);
>> +     }
>> +}
>> +
>> +static void qmtm_cleanup(struct platform_device *pdev,
>> +             struct uio_qmtm_dev *qmtm_dev)
>> +{
>> +     struct uio_info *info = qmtm_dev->info;
>> +
>> +     uio_unregister_device(info);
>> +
>> +     clk_disable_unprepare(qmtm_dev->qmtm_clk);
>> +}
>> +
>> +static int qmtm_probe(struct platform_device *pdev)
>> +{
>> +     struct uio_info *info;
>> +     struct uio_qmtm_dev *qmtm_dev;
>> +     struct resource *csr;
>> +     struct resource *fabric;
>> +     struct resource qpool;
>> +     unsigned int num_queues;
>> +     unsigned int devid;
>> +     phandle qpool_phandle;
>> +     struct device_node *qpool_node;
>> +     int ret;
>> +
>> +     qmtm_dev = devm_kzalloc(&pdev->dev, sizeof(struct uio_qmtm_dev),
>> +                             GFP_KERNEL);
>> +     if (!qmtm_dev)
>> +             return -ENOMEM;
>> +
>> +     qmtm_dev->info = devm_kzalloc(&pdev->dev, sizeof(*info), GFP_KERNEL);
>> +     if (!qmtm_dev->info)
>> +             return -ENOMEM;
>> +
>> +     /* Power on qmtm in case its not done as part of boot-loader */
>> +     qmtm_dev->qmtm_clk = devm_clk_get(&pdev->dev, NULL);
>> +     if (IS_ERR(qmtm_dev->qmtm_clk)) {
>> +             dev_err(&pdev->dev, "Failed to get clock\n");
>> +             ret = PTR_ERR(qmtm_dev->qmtm_clk);
>> +             return ret;
>> +     } else {
>
> This else is really unnecessary.
>
>> +             clk_prepare_enable(qmtm_dev->qmtm_clk);
>
> If you would call this later, just before, say, qmtm_reset, could simplify
> the code a lot since it could return directly for most of the error cases.
>
>> +     }
>> +
>> +     csr = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     if (!csr) {
>> +             ret = -ENODEV;
>> +             dev_err(&pdev->dev, "No QMTM CSR resource specified\n");
>> +             goto out_free;
>> +     }
>> +
>> +     if (!csr->start) {
>> +             ret = -EINVAL;
>> +             dev_err(&pdev->dev, "Invalid CSR resource\n");
>> +             goto out_free;
>> +     }
>> +
>> +     fabric = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +     if (!fabric) {
>> +             ret = -ENODEV;
>> +             dev_err(&pdev->dev, "No QMTM Fabric resource specified\n");
>> +             goto out_free;
>> +     }
>> +
>> +     if (!fabric->start) {
>> +             ret = -EINVAL;
>> +             dev_err(&pdev->dev, "Invalid Fabric resource\n");
>> +             goto out_free;
>> +     }
>> +
>> +     ret = of_property_read_u32(pdev->dev.of_node, "qpool", &qpool_phandle);
>> +
> Unnecessary empty line before checking results.
> Doesn't checkpatch complain about that ?
>
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "No qpool resource specified\n");
>> +             goto out_free;
>> +     }
>> +
>> +     qpool_node = of_find_node_by_phandle(qpool_phandle);
>> +
>> +     if (IS_ERR_OR_NULL(qpool_node)) {
>> +             ret = PTR_ERR(qpool_node);
>> +             dev_err(&pdev->dev, "Failed to get node by phandle\n");
>> +             goto out_free;
>> +     }
>> +
>> +     ret = of_address_to_resource(qpool_node, 0, &qpool);
>> +
>> +     of_node_put(qpool_node);
>> +
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "Failed to get qpool resource from node\n");
>> +             goto out_free;
>> +     }
>> +
>> +     if (!qpool.start) {
>> +             ret = -EINVAL;
>> +             dev_err(&pdev->dev, "Invalid qpool resource\n");
>> +             goto out_free;
>> +     }
>> +
>> +     ret = of_property_read_u32(pdev->dev.of_node, "num-queues",
>> +                     &num_queues);
>> +
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "No num-queues resource specified\n");
>> +             goto out_free;
>> +     }
>> +
>> +     /* check whether sufficient memory is provided for the given queues */
>> +     if (!((num_queues * QMTM_DEFAULT_QSIZE) <= resource_size(&qpool))) {
>
> Some unnecessary ( ), and the negation is a bit odd. Why not just
>
>         if (num_queues * QMTM_DEFAULT_QSIZE > resource_size(&qpool)) {
>
> ?
>
>> +             ret = -ENOSPC;
>> +             dev_err(&pdev->dev, "Insufficient Qpool for the given queues\n");
>> +             goto out_free;
>> +     }
>> +
>> +     ret = of_property_read_u32(pdev->dev.of_node, "devid", &devid);
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "No devid resource specified\n");
>> +             goto out_free;
>> +     }
>> +
>> +     info = qmtm_dev->info;
>> +     info->mem[0].name = "csr";
>> +     info->mem[0].addr = csr->start;
>> +     info->mem[0].size = resource_size(csr);
>> +     info->mem[0].memtype = UIO_MEM_PHYS;
>> +     info->mem[0].internal_addr = devm_ioremap_resource(&pdev->dev, csr);
>> +
>> +     if (IS_ERR(info->mem[0].internal_addr)) {
>> +             ret = PTR_ERR(info->mem[0].internal_addr);
>> +             dev_err(&pdev->dev, "Failed to ioremap CSR region\n");
>> +             goto out_free;
>> +     }
>> +
>> +     info->mem[1].name = "fabric";
>> +     info->mem[1].addr = fabric->start;
>> +     info->mem[1].size = resource_size(fabric);
>> +     info->mem[1].memtype = UIO_MEM_PHYS;
>> +
>> +     info->mem[2].name = "qpool";
>> +     info->mem[2].addr = qpool.start;
>> +     info->mem[2].size = resource_size(&qpool);
>> +     info->mem[2].memtype = UIO_MEM_PHYS_CACHE;
>> +
>> +     info->name = devm_kasprintf(&pdev->dev, GFP_KERNEL, "qmtm%d", devid);
>> +     info->version = DRV_VERSION;
>> +
>> +     info->priv = qmtm_dev;
>> +
>> +     /* get the qmtm out of reset */
>> +     ret = qmtm_reset(qmtm_dev);
>> +     if (ret < 0) {
>> +             dev_err(&pdev->dev, "Failed to reset QMTM\n");
>> +             goto out_free;
>> +     }
>> +
>> +     /* register with uio framework */
>> +     ret = uio_register_device(&pdev->dev, info);
>> +     if (ret < 0)
>> +             goto out_free;
>> +
>> +     platform_set_drvdata(pdev, qmtm_dev);
>> +     return 0;
>> +
>> +out_free:
>
> Kind of misleading. This doesn't really free anything.
>
>> +     qmtm_cleanup(pdev, qmtm_dev);
>
> While it is technically ok to call uio_unregister_device if the device
> wasn't registerd, I don't really think it makes much sense here to
> call qmtm_cleanup and thus uio_unregister_device (the uio device is
> never registered).
>
> You might as well name the label out_clk or similar and call
> clk_disable_unprepare directly.

I will address all of your comments in next revision.

-Ankit
>
>> +     return ret;
>> +}
>> +
>> +static int qmtm_remove(struct platform_device *pdev)
>> +{
>> +     struct uio_qmtm_dev *qmtm_dev = platform_get_drvdata(pdev);
>> +
>> +     qmtm_cleanup(pdev, qmtm_dev);
>
> ... and drop this function entirely as it does not really provide any value.
>
>> +     return 0;
>> +}
>> +
>> +static struct of_device_id qmtm_match[] = {
>> +     {.compatible = "apm,xgene-qmtm",},
>> +     {},
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, qmtm_match);
>> +
>> +static struct platform_driver qmtm_driver = {
>> +     .driver = {
>> +             .name = DRV_NAME,
>> +             .owner = THIS_MODULE,
>> +             .of_match_table = qmtm_match,
>> +     },
>> +     .probe = qmtm_probe,
>> +     .remove = qmtm_remove,
>> +};
>> +
>> +module_platform_driver(qmtm_driver);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_VERSION(DRV_VERSION);
>> +MODULE_AUTHOR("Ankit Jindal <ankit.jindal@linaro.org>");
>> +MODULE_AUTHOR("Tushar Jagad <tushar.jagad@linaro.org>");
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>>
