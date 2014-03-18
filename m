Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754438AbaCRKW6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 06:22:58 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64133 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753189AbaCRKWz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 06:22:55 -0400
MIME-Version: 1.0
In-Reply-To: <1395057839-23871-2-git-send-email-ks.giri@samsung.com>
References: <1395057839-23871-1-git-send-email-ks.giri@samsung.com>
	<1395057839-23871-2-git-send-email-ks.giri@samsung.com>
Date: Tue, 18 Mar 2014 15:52:54 +0530
Message-ID: <CAKrE-KcA6VUUwUjAGuW+nYsFg0qknfZwECtdVS8ZtZb4GYoCvA@mail.gmail.com>
Subject: Re: [PATCH 1/2] mailbox: samsung: added support for samsung mailbox
From: Girish KS <girishks2000@gmail.com>
To: Girish K S <ks.giri@samsung.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jassi Singh <jassisinghbrar@gmail.com>, "Anna, Suman" <s-anna@ti.com>,
        Ilho Lee <ilho215.lee@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 5:33 PM, Girish K S <ks.giri@samsung.com> wrote:
> This patch adds support to the samsung mailbox driver.
>
> Signed-off-by: Girish K S <ks.giri@samsung.com>
> ---
>  drivers/mailbox/Kconfig           |    8 +
>  drivers/mailbox/Makefile          |    2 +
>  drivers/mailbox/mailbox-samsung.c |  354 +++++++++++++++++++++++++++++++++++++
>  include/linux/mailbox-samsung.h   |  112 ++++++++++++
>  4 files changed, 476 insertions(+)
>  create mode 100644 drivers/mailbox/mailbox-samsung.c
>  create mode 100644 include/linux/mailbox-samsung.h
>
> diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
> index c8b5c13..bce60ba 100644
> --- a/drivers/mailbox/Kconfig
> +++ b/drivers/mailbox/Kconfig
> @@ -23,6 +23,14 @@ config OMAP_MBOX
>           driver such as CONFIG_OMAP1_MBOX or CONFIG_OMAP2PLUS_MBOX. This
>           enables the common OMAP mailbox framework code.
>
> +config SAMSUNG_MBOX
> +       tristate "Samsung Mailbox Controller"
> +       help
> +         An implementation of the Samsung Interprocessor Communication
> +         Mailbox (IPCM). It is used to send short messages between A57 cores
> +         and the System Control Processor or Network Coprocessor firmware.
> +         Say Y here if you want to use the Samsung IPCM support.
> +
>  config OMAP1_MBOX
>         tristate "OMAP1 Mailbox framework support"
>         depends on ARCH_OMAP1
> diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
> index 2fa343a..7e83a7d 100644
> --- a/drivers/mailbox/Makefile
> +++ b/drivers/mailbox/Makefile
> @@ -9,3 +9,5 @@ obj-$(CONFIG_OMAP1_MBOX)        += mailbox_omap1.o
>  mailbox_omap1-objs             := mailbox-omap1.o
>  obj-$(CONFIG_OMAP2PLUS_MBOX)   += mailbox_omap2.o
>  mailbox_omap2-objs             := mailbox-omap2.o
> +obj-$(CONFIG_SAMSUNG_MBOX)     += mailbox_samsung.o
> +mailbox_samsung-objs           := mailbox-samsung.o
> diff --git a/drivers/mailbox/mailbox-samsung.c b/drivers/mailbox/mailbox-samsung.c
> new file mode 100644
> index 0000000..903e88a
> --- /dev/null
> +++ b/drivers/mailbox/mailbox-samsung.c
> @@ -0,0 +1,354 @@
> +/*
> + * Copyright 2013 Samsung Electronics Co. Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#include <linux/err.h>
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/jiffies.h>
> +#include <linux/mailbox_controller.h>
> +#include <linux/mailbox-samsung.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/of_irq.h>
> +#include <linux/platform_device.h>
> +
> +/*
> +   Mailbox Register offsets
> + */
> +
> +/* Offset of tx mailbox data registers */
> +#define MBOX_REG_RXDATA0       0
> +#define MBOX_REG_RXDATA1       4
> +
> +/* offset of tx mailbox lock registers */
> +#define MBOX_REG_RXLOCK                8
> +#define MBOX_REG_RXUNLOCK      12
> +
> +/* offset of tx mailbox interrupt registers */
> +#define MBOX_REG_RXINT         16
> +
> +/* Offset of rx mailbox data registers */
> +#define MBOX_REG_TXDATA0       32
> +#define MBOX_REG_TXDATA1       36
> +
> +/* offset of rx mailbox lock registers */
> +#define MBOX_REG_TXLOCK                40
> +#define MBOX_REG_TXUNLOCK      44
> +
> +/* offset of rx mailbox interrupt registers */
> +#define MBOX_REG_TXINT         48
> +
> +#define MBOX_RX_TX_FULL                1
> +#define MBOX_INT_ENABLE                1
> +
> +#define MBOX_LOCK_RESET                (-1)
> +#define MBOX_WAIT_TIMEOUT      (1)
> +
> +#define RXBUF_LEN      32
> +#define MAX_LINKS      1
> +
> +struct samsung_mlink {
> +       const char *name;
> +       struct ipc_link link;
> +       struct samsung_mbox *smc;
> +       int irq;
> +       void *data;
> +};
> +
> +struct samsung_mbox {
> +       struct device *dev;
> +       void __iomem *ipc_base;
> +       struct ipc_controller ipc_con;
> +       struct mutex lock;
> +       struct samsung_mlink samsung_link[MAX_LINKS];
> +};
> +
> +static inline struct samsung_mlink *to_samsung_mlink(struct ipc_link *plink)
> +{
> +       if (!plink)
> +               return NULL;
> +
> +       return container_of(plink, struct samsung_mlink, link);
> +}
> +
> +static inline struct samsung_mbox *to_samsung_mbox(struct ipc_link *plink)
> +{
> +       if (!plink)
> +               return NULL;
> +
> +       return to_samsung_mlink(plink)->smc;
> +}
> +
> +static void samsung_mbox_read(struct samsung_mlink *link)
> +{
> +       u64 data;
> +       void __iomem *ipc_base = link->smc->ipc_base;
> +
> +       /* Read both words which have information specific to client */
> +       data = readq(ipc_base + MBOX_REG_RXDATA0);
> +       link->data = phys_to_virt((phys_addr_t)data);
> +}
> +
> +static irqreturn_t samsung_ipc_handler(int irq, void *p)
> +{
> +       struct samsung_mlink *plink = p;
> +       void __iomem *ipc_base = plink->smc->ipc_base;
> +
> +       samsung_mbox_read(plink);
> +       ipc_link_received_data(&plink->link, plink->data);
> +
> +       /* Acknowledge the interrupt by clearing the interrupt register */
> +       writel(~MBOX_INT_ENABLE, ipc_base + MBOX_REG_RXINT);
> +       writel(readl(ipc_base + MBOX_REG_RXLOCK),
> +              ipc_base + MBOX_REG_RXUNLOCK);
> +
> +       return IRQ_HANDLED;
> +}
> +
> +static bool samsung_mbox_is_ready(struct ipc_link *link)
> +{
> +       struct samsung_mbox *samsung_mbox = to_samsung_mbox(link);
> +       void __iomem *ipc_base = samsung_mbox->ipc_base;
> +       int ret = true;
> +
> +       mutex_lock(&samsung_mbox->lock);
> +
> +       /* If the RX interrupt register is clear then mbox is empty */
> +       if (readl(ipc_base + MBOX_REG_TXLOCK) &&
> +           readl(ipc_base + MBOX_REG_TXINT))
> +               ret = false;
> +
> +       mutex_unlock(&samsung_mbox->lock);
> +       return ret;
> +}
> +
> +static int samsung_mbox_send_data(struct ipc_link *link, void *msg)
> +{
> +       u32 val;
> +       phys_addr_t addr;
> +       unsigned long timeout;
> +       struct samsung_mbox *samsung_mbox = to_samsung_mbox(link);
> +       void __iomem *ipc_base = samsung_mbox->ipc_base;
> +       int ret = 0;
> +
> +       mutex_lock(&samsung_mbox->lock);
> +
> +       timeout = jiffies + msecs_to_jiffies(MBOX_WAIT_TIMEOUT);
> +
> +       /* Check if the mailbox is busy transmitting data */
> +       if (readl(ipc_base + MBOX_REG_TXLOCK)) {
> +               ret = -EBUSY;
> +               goto unlock_mutex;
> +       }
> +
> +       addr = virt_to_phys(msg);
> +       val = samsung_get_client_id(msg);
> +
> +       /* Lock the mailbox for this transaction with the client id */
> +       writel(val, ipc_base + MBOX_REG_TXLOCK);
> +       do {
> +               if (time_after(jiffies, timeout)) {
> +                       pr_err("cannot aquire the lock\n");
> +                       ret = -EAGAIN;
> +                       goto unlock_mutex;
> +               }
> +       } while (readl(ipc_base + MBOX_REG_TXLOCK) != val);
> +
> +       writeq(addr, ipc_base + MBOX_REG_TXDATA0);
> +       val = readl(ipc_base + MBOX_REG_TXINT);
> +       val |= MBOX_INT_ENABLE;
> +       writel(val, ipc_base + MBOX_REG_TXINT);
> +
> +unlock_mutex:
> +       mutex_unlock(&samsung_mbox->lock);
> +       return ret;
> +}
> +
> +static int samsung_mbox_startup(struct ipc_link *link, void *ignored)
> +{
> +       int ret;
> +       struct samsung_mlink *samsung_link = to_samsung_mlink(link);
> +       struct samsung_mbox *samsung_mbox = to_samsung_mbox(link);
> +       void __iomem *ipc_base = samsung_mbox->ipc_base;
> +       struct device *dev = samsung_mbox->dev;
> +
> +       mutex_lock(&samsung_mbox->lock);
> +
> +       ret = devm_request_irq(dev, samsung_link->irq, samsung_ipc_handler,
> +                                       IRQF_SHARED, link->link_name,
> +                                       samsung_link);
> +       if (unlikely(ret)) {
> +               pr_err("failed to register mailbox interrupt:%d\n", ret);
> +               mutex_unlock(&samsung_mbox->lock);
> +               return ret;
> +       }
> +
> +       /*
> +        * On shutdown irrespective of what is the previous lock id
> +        * clear it. Dont have to do the same for RX lock. Remote
> +        * processor shall handle the RX lock clear on shutdown.
> +        */
> +       writel(~MBOX_INT_ENABLE, ipc_base + MBOX_REG_TXINT);
> +       writel(MBOX_LOCK_RESET, ipc_base + MBOX_REG_TXUNLOCK);
> +
> +       mutex_unlock(&samsung_mbox->lock);
> +       return 0;
> +}
> +
> +static void samsung_mbox_shutdown(struct ipc_link *link)
> +{
> +       struct samsung_mbox *samsung_mbox = to_samsung_mbox(link);
> +       struct samsung_mlink *samsung_link = to_samsung_mlink(link);
> +       void __iomem *ipc_base = samsung_mbox->ipc_base;
> +       struct device *dev = samsung_mbox->dev;
> +
> +       mutex_lock(&samsung_mbox->lock);
> +
> +       /*
> +        * On shutdown irrespective of what is the previous lock id
> +        * clear it. Dont have to do the same for RX lock. Remote
> +        * processor shall handle the RX lock clear on shutdown.
> +        */
> +       writel(~MBOX_INT_ENABLE, ipc_base + MBOX_REG_TXINT);
> +       writel(MBOX_LOCK_RESET, ipc_base + MBOX_REG_TXUNLOCK);
> +
> +       devm_free_irq(dev, samsung_link->irq, samsung_link);
> +
> +       mutex_unlock(&samsung_mbox->lock);
> +}
> +
> +static struct ipc_link_ops samsung_mbox_ops = {
> +       .is_ready = samsung_mbox_is_ready,
> +       .send_data = samsung_mbox_send_data,
> +       .startup = samsung_mbox_startup,
> +       .shutdown = samsung_mbox_shutdown,
> +};
> +
> +static int samsung_mbox_probe(struct platform_device *pdev)
> +{
> +       struct samsung_mbox *samsung_mbox;
> +       struct samsung_mlink *mbox_link;
> +       struct resource res;
> +       struct ipc_link **link;
> +       int loop, count, ret = 0;
> +       struct device_node *node = pdev->dev.of_node;
> +
> +       if (!node) {
> +               dev_err(&pdev->dev, "driver doesnt support"
> +                               "non-dt devices\n");
> +               return -ENODEV;
> +       }
> +
> +       count = of_property_count_strings(node,
> +                               "samsung,mbox-names");
> +       if (count <= 0) {
> +               dev_err(&pdev->dev, "no mbox devices found\n");
> +               return -ENODEV;
> +       }
> +
> +       samsung_mbox = devm_kzalloc(&pdev->dev,
> +                       sizeof(struct samsung_mbox), GFP_KERNEL);
> +       if (IS_ERR(samsung_mbox))
> +               return PTR_ERR(samsung_mbox);
> +
> +       link = devm_kzalloc(&pdev->dev, (count + 1) * sizeof(*link),
> +                       GFP_KERNEL);
> +       if (IS_ERR(link))
> +               return PTR_ERR(link);
> +
> +       samsung_mbox->dev = &pdev->dev;
> +
> +       samsung_mbox->ipc_base = devm_ioremap_resource(&pdev->dev, &res);
> +       if (IS_ERR(samsung_mbox->ipc_base))
> +               return PTR_ERR(samsung_mbox->ipc_base);
> +
> +       for (loop = 0; loop < count; loop++) {
> +               mbox_link = &samsung_mbox->samsung_link[loop];
> +
> +               ret = of_address_to_resource(node, 0, &res);
> +               if (ret < 0)
> +                       return ret;

Sorry posted a wrong version. Above code should be moved before ioremap

> +
> +               mbox_link->irq = irq_of_parse_and_map(node, loop);
> +               if (!mbox_link->irq)
> +                       return -ENODEV;
> +
> +               mbox_link->smc = samsung_mbox;
> +               link[loop] = &mbox_link->link;
> +
> +               if (of_property_read_string_index(node, "samsung,mbox-names",
> +                                                 loop, &mbox_link->name)) {
> +                       dev_err(&pdev->dev,
> +                               "mbox_name [%d] read failed\n", loop);
> +                       return -ENODEV;
> +               }
> +
> +               snprintf(link[loop]->link_name, 16, mbox_link->name);
> +       }
> +
> +       link[loop] = NULL; /* Terminating link */
> +
> +       mutex_init(&samsung_mbox->lock);
> +       samsung_mbox->ipc_con.links = link;
> +       samsung_mbox->ipc_con.txdone_irq = false;
> +       samsung_mbox->ipc_con.txdone_poll = true;
> +       samsung_mbox->ipc_con.txpoll_period = 1;
> +       samsung_mbox->ipc_con.ops = &samsung_mbox_ops;
> +       snprintf(samsung_mbox->ipc_con.controller_name, 16, "samsung_mbox");
> +
> +       ret = ipc_links_register(&samsung_mbox->ipc_con);
> +       if (ret) {
> +               pr_err("%s: IPC Link register failed\n", __func__);
> +               return ret;
> +       }
> +
> +       platform_set_drvdata(pdev, samsung_mbox);
> +
> +       return ret;
> +}
> +
> +static int samsung_mbox_remove(struct platform_device *pdev)
> +{
> +       struct samsung_mbox *samsung_mbox = platform_get_drvdata(pdev);
> +
> +       ipc_links_unregister(&samsung_mbox->ipc_con);
> +
> +       return 0;
> +}
> +
> +static const struct of_device_id mailbox_smc_match[] = {
> +       { .compatible = "samsung,gh7-mailbox" },
> +       {},
> +};
> +MODULE_DEVICE_TABLE(of, mailbox_smc_match);
> +
> +static struct platform_driver samsung_mbox_driver = {
> +       .probe  = samsung_mbox_probe,
> +       .remove = samsung_mbox_remove,
> +       .driver = {
> +               .name = "gh7-mailbox",
> +               .of_match_table = mailbox_smc_match,
> +       },
> +};
> +
> +module_platform_driver(samsung_mbox_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("Samsung Mailbox Driver");
> +MODULE_AUTHOR("Girish K S <ks.giri@samsung.com>");
> +MODULE_ALIAS("platform:gh7-mailbox");
> diff --git a/include/linux/mailbox-samsung.h b/include/linux/mailbox-samsung.h
> new file mode 100644
> index 0000000..c3f2d2c
> --- /dev/null
> +++ b/include/linux/mailbox-samsung.h
> @@ -0,0 +1,112 @@
> +
> +/*
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#ifndef _MAILBOX_SAMSUNG_H_
> +#define _MAILBOX_SAMSUNG_H_
> +
> +#include <linux/slab.h>
> +
> +#define SAMSUNG_MB_RESP_LEN    (4096)
> +#define SAMSUNG_MB_DRV_ID      (0xa5)
> +#define SAMSUNG_MB_DRV_LEN     (0x08)
> +#define REQUEST_PAGE_ORDER     (16)
> +
> +#define IRQ_TX                 (1)
> +#define IRQ_RX                 (2)
> +
> +struct samsung_packet {
> +       u8 version;
> +       u8 client_id;
> +       u8 remote_id;
> +       u16 req_len;
> +       u64 resp_addr;
> +       u16 resp_len;
> +       u8 reserved[16];
> +       u8 checksum;
> +};
> +
> +static inline unsigned long get_alligned_buffer(void)
> +{
> +       return __get_free_pages(GFP_KERNEL, REQUEST_PAGE_ORDER);
> +}
> +
> +static inline void put_alligned_buffer(unsigned long addr)
> +{
> +       free_pages(addr, REQUEST_PAGE_ORDER);
> +}
> +
> +static inline void samsung_put_version(void *buf, u8 version)
> +{
> +       struct samsung_packet *data = buf;
> +       data->version = version;
> +}
> +
> +static inline void samsung_put_client_id(void *buf, u8 id)
> +{
> +       struct samsung_packet *data = buf;
> +       data->client_id = (SAMSUNG_MB_DRV_ID << SAMSUNG_MB_DRV_LEN) | id;
> +}
> +
> +static inline void samsung_put_remote_id(void *buf, u8 id)
> +{
> +       struct samsung_packet *data = buf;
> +       data->remote_id = id;
> +}
> +
> +static inline void samsung_put_req_len(void *buf, u16 len)
> +{
> +       struct samsung_packet *data = buf;
> +       data->req_len = len;
> +}
> +
> +static inline void samsung_put_resp_addr(void *buf, u64 addr)
> +{
> +       struct samsung_packet *data = buf;
> +       data->resp_addr = addr;
> +}
> +
> +static inline void samsung_put_checksum(void *buf, u8 checksum)
> +{
> +       struct samsung_packet *data = buf;
> +       data->checksum = checksum;
> +}
> +
> +static inline int samsung_get_resp_size(void)
> +{
> +       /* The response buffer length can be max upto 4kb */
> +       return SAMSUNG_MB_RESP_LEN;
> +}
> +
> +static inline int samsung_get_resp_len(void *buf)
> +{
> +       struct samsung_packet *data = buf;
> +
> +       /* The actual lenght of response buffer is got from remote packet */
> +       return data->resp_len;
> +}
> +
> +static inline u64 samsung_get_resp_addr(void *buf)
> +{
> +       struct samsung_packet *data = buf;
> +       return data->resp_addr;
> +}
> +
> +static inline int samsung_get_client_id(const void *buf)
> +{
> +       const struct samsung_packet *data = buf;
> +       return data->client_id;
> +}
> +
> +#endif
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
