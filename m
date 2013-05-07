Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882Ab3EGB6f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:58:35 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59776 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759852Ab3EGB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:58:31 -0400
Message-ID: <51885FC4.7000401@gmail.com>
Date: Mon, 06 May 2013 20:58:28 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jassi Brar <jassisinghbrar@gmail.com>
CC: s-anna@ti.com, loic.pallardy@st.com, linux-arm-kernel@lists.infradead.org,
        Jassi Brar <jaswinder.singh@linaro.org>, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Mark Langsdorf <mark.langsdorf@calxeda.com>
Subject: Re: [PATCHv2 3/4] mailbox: pl320: Introduce common API driver
References: <1367824946-6160-1-git-send-email-jaswinder.singh@linaro.org> <1367825063-6263-1-git-send-email-jaswinder.singh@linaro.org>
In-Reply-To: <1367825063-6263-1-git-send-email-jaswinder.singh@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 02:24 AM, Jassi Brar wrote:
> Convert the PL320 controller driver to work with the common
> mailbox API. Also convert the only user of PL320, highbank-cpufreq.c
> to work with thee API. Drop the obsoleted driver pl320-ipc.c
> 
> Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
> ---
>  drivers/cpufreq/highbank-cpufreq.c |   22 +++-
>  drivers/mailbox/Makefile           |    2 +-
>  drivers/mailbox/pl320-ipc.c        |  198 ---------------------------------
>  drivers/mailbox/pl320.c            |  212 ++++++++++++++++++++++++++++++++++++

Can you resend this using git format-patch -M option.

Rob

>  include/linux/pl320-ipc.h          |   17 ---
>  5 files changed, 233 insertions(+), 218 deletions(-)
>  delete mode 100644 drivers/mailbox/pl320-ipc.c
>  create mode 100644 drivers/mailbox/pl320.c
>  delete mode 100644 include/linux/pl320-ipc.h
> 
> diff --git a/drivers/cpufreq/highbank-cpufreq.c b/drivers/cpufreq/highbank-cpufreq.c
> index 3118b87..5c057e0 100644
> --- a/drivers/cpufreq/highbank-cpufreq.c
> +++ b/drivers/cpufreq/highbank-cpufreq.c
> @@ -19,7 +19,7 @@
>  #include <linux/cpu.h>
>  #include <linux/err.h>
>  #include <linux/of.h>
> -#include <linux/pl320-ipc.h>
> +#include <linux/mailbox_client.h>
>  #include <linux/platform_device.h>
>  
>  #define HB_CPUFREQ_CHANGE_NOTE	0x80000001
> @@ -29,8 +29,26 @@
>  static int hb_voltage_change(unsigned int freq)
>  {
>  	u32 msg[HB_CPUFREQ_IPC_LEN] = {HB_CPUFREQ_CHANGE_NOTE, freq / 1000000};
> +	struct ipc_client cl;
> +	int ret = -ETIMEDOUT;
> +	void *chan;
>  
> -	return pl320_ipc_transmit(msg);
> +	cl.rxcb = NULL;
> +	cl.txcb = NULL;
> +	cl.tx_block = true;
> +	cl.tx_tout = 1000; /* 1 sec */
> +	cl.cntlr_data = NULL;
> +	cl.knows_txdone = false;
> +	cl.chan_name = "pl320:A9_to_M3";
> +
> +	chan = ipc_request_channel(&cl);
> +
> +	if (ipc_send_message(chan, (void *)msg))
> +		ret = msg[1]; /* PL320 updates buffer with FIFO after ACK */
> +
> +	ipc_free_channel(chan);
> +
> +	return ret;
>  }
>  
>  static int hb_cpufreq_clk_notify(struct notifier_block *nb,
> diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
> index fefef7e..7b897f3 100644
> --- a/drivers/mailbox/Makefile
> +++ b/drivers/mailbox/Makefile
> @@ -2,4 +2,4 @@
>  
>  obj-$(CONFIG_MAILBOX)		+= mailbox.o
>  
> -obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
> +obj-$(CONFIG_PL320_MBOX)	+= pl320.o
> diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
> deleted file mode 100644
> index f3755e0..0000000
> --- a/drivers/mailbox/pl320-ipc.c
> +++ /dev/null
> @@ -1,198 +0,0 @@
> -/*
> - * Copyright 2012 Calxeda, Inc.
> - *
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program.  If not, see <http://www.gnu.org/licenses/>.
> - */
> -#include <linux/types.h>
> -#include <linux/err.h>
> -#include <linux/delay.h>
> -#include <linux/export.h>
> -#include <linux/io.h>
> -#include <linux/interrupt.h>
> -#include <linux/completion.h>
> -#include <linux/mutex.h>
> -#include <linux/notifier.h>
> -#include <linux/spinlock.h>
> -#include <linux/device.h>
> -#include <linux/amba/bus.h>
> -
> -#include <linux/pl320-ipc.h>
> -
> -#define IPCMxSOURCE(m)		((m) * 0x40)
> -#define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
> -#define IPCMxDCLEAR(m)		(((m) * 0x40) + 0x008)
> -#define IPCMxDSTATUS(m)		(((m) * 0x40) + 0x00C)
> -#define IPCMxMODE(m)		(((m) * 0x40) + 0x010)
> -#define IPCMxMSET(m)		(((m) * 0x40) + 0x014)
> -#define IPCMxMCLEAR(m)		(((m) * 0x40) + 0x018)
> -#define IPCMxMSTATUS(m)		(((m) * 0x40) + 0x01C)
> -#define IPCMxSEND(m)		(((m) * 0x40) + 0x020)
> -#define IPCMxDR(m, dr)		(((m) * 0x40) + ((dr) * 4) + 0x024)
> -
> -#define IPCMMIS(irq)		(((irq) * 8) + 0x800)
> -#define IPCMRIS(irq)		(((irq) * 8) + 0x804)
> -
> -#define MBOX_MASK(n)		(1 << (n))
> -#define IPC_TX_MBOX		1
> -#define IPC_RX_MBOX		2
> -
> -#define CHAN_MASK(n)		(1 << (n))
> -#define A9_SOURCE		1
> -#define M3_SOURCE		0
> -
> -static void __iomem *ipc_base;
> -static int ipc_irq;
> -static DEFINE_MUTEX(ipc_m1_lock);
> -static DECLARE_COMPLETION(ipc_completion);
> -static ATOMIC_NOTIFIER_HEAD(ipc_notifier);
> -
> -static inline void set_destination(int source, int mbox)
> -{
> -	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDSET(mbox));
> -	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMSET(mbox));
> -}
> -
> -static inline void clear_destination(int source, int mbox)
> -{
> -	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDCLEAR(mbox));
> -	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMCLEAR(mbox));
> -}
> -
> -static void __ipc_send(int mbox, u32 *data)
> -{
> -	int i;
> -	for (i = 0; i < 7; i++)
> -		__raw_writel(data[i], ipc_base + IPCMxDR(mbox, i));
> -	__raw_writel(0x1, ipc_base + IPCMxSEND(mbox));
> -}
> -
> -static u32 __ipc_rcv(int mbox, u32 *data)
> -{
> -	int i;
> -	for (i = 0; i < 7; i++)
> -		data[i] = __raw_readl(ipc_base + IPCMxDR(mbox, i));
> -	return data[1];
> -}
> -
> -/* blocking implmentation from the A9 side, not usuable in interrupts! */
> -int pl320_ipc_transmit(u32 *data)
> -{
> -	int ret;
> -
> -	mutex_lock(&ipc_m1_lock);
> -
> -	init_completion(&ipc_completion);
> -	__ipc_send(IPC_TX_MBOX, data);
> -	ret = wait_for_completion_timeout(&ipc_completion,
> -					  msecs_to_jiffies(1000));
> -	if (ret == 0) {
> -		ret = -ETIMEDOUT;
> -		goto out;
> -	}
> -
> -	ret = __ipc_rcv(IPC_TX_MBOX, data);
> -out:
> -	mutex_unlock(&ipc_m1_lock);
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(pl320_ipc_transmit);
> -
> -static irqreturn_t ipc_handler(int irq, void *dev)
> -{
> -	u32 irq_stat;
> -	u32 data[7];
> -
> -	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
> -	if (irq_stat & MBOX_MASK(IPC_TX_MBOX)) {
> -		__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
> -		complete(&ipc_completion);
> -	}
> -	if (irq_stat & MBOX_MASK(IPC_RX_MBOX)) {
> -		__ipc_rcv(IPC_RX_MBOX, data);
> -		atomic_notifier_call_chain(&ipc_notifier, data[0], data + 1);
> -		__raw_writel(2, ipc_base + IPCMxSEND(IPC_RX_MBOX));
> -	}
> -
> -	return IRQ_HANDLED;
> -}
> -
> -int pl320_ipc_register_notifier(struct notifier_block *nb)
> -{
> -	return atomic_notifier_chain_register(&ipc_notifier, nb);
> -}
> -EXPORT_SYMBOL_GPL(pl320_ipc_register_notifier);
> -
> -int pl320_ipc_unregister_notifier(struct notifier_block *nb)
> -{
> -	return atomic_notifier_chain_unregister(&ipc_notifier, nb);
> -}
> -EXPORT_SYMBOL_GPL(pl320_ipc_unregister_notifier);
> -
> -static int pl320_probe(struct amba_device *adev, const struct amba_id *id)
> -{
> -	int ret;
> -
> -	ipc_base = ioremap(adev->res.start, resource_size(&adev->res));
> -	if (ipc_base == NULL)
> -		return -ENOMEM;
> -
> -	__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
> -
> -	ipc_irq = adev->irq[0];
> -	ret = request_irq(ipc_irq, ipc_handler, 0, dev_name(&adev->dev), NULL);
> -	if (ret < 0)
> -		goto err;
> -
> -	/* Init slow mailbox */
> -	__raw_writel(CHAN_MASK(A9_SOURCE),
> -			ipc_base + IPCMxSOURCE(IPC_TX_MBOX));
> -	__raw_writel(CHAN_MASK(M3_SOURCE),
> -			ipc_base + IPCMxDSET(IPC_TX_MBOX));
> -	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
> -		     ipc_base + IPCMxMSET(IPC_TX_MBOX));
> -
> -	/* Init receive mailbox */
> -	__raw_writel(CHAN_MASK(M3_SOURCE),
> -			ipc_base + IPCMxSOURCE(IPC_RX_MBOX));
> -	__raw_writel(CHAN_MASK(A9_SOURCE),
> -			ipc_base + IPCMxDSET(IPC_RX_MBOX));
> -	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
> -		     ipc_base + IPCMxMSET(IPC_RX_MBOX));
> -
> -	return 0;
> -err:
> -	iounmap(ipc_base);
> -	return ret;
> -}
> -
> -static struct amba_id pl320_ids[] = {
> -	{
> -		.id	= 0x00041320,
> -		.mask	= 0x000fffff,
> -	},
> -	{ 0, 0 },
> -};
> -
> -static struct amba_driver pl320_driver = {
> -	.drv = {
> -		.name	= "pl320",
> -	},
> -	.id_table	= pl320_ids,
> -	.probe		= pl320_probe,
> -};
> -
> -static int __init ipc_init(void)
> -{
> -	return amba_driver_register(&pl320_driver);
> -}
> -module_init(ipc_init);
> diff --git a/drivers/mailbox/pl320.c b/drivers/mailbox/pl320.c
> new file mode 100644
> index 0000000..7ddae5c
> --- /dev/null
> +++ b/drivers/mailbox/pl320.c
> @@ -0,0 +1,212 @@
> +/*
> + * Copyright 2012 Calxeda, Inc.
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
> +#include <linux/types.h>
> +#include <linux/err.h>
> +#include <linux/delay.h>
> +#include <linux/export.h>
> +#include <linux/io.h>
> +#include <linux/interrupt.h>
> +#include <linux/completion.h>
> +#include <linux/mutex.h>
> +#include <linux/notifier.h>
> +#include <linux/spinlock.h>
> +#include <linux/device.h>
> +#include <linux/amba/bus.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/mailbox_controller.h>
> +
> +#define IPCMSOURCE(m)		((m) * 0x40)
> +#define IPCMDSET(m)		(((m) * 0x40) + 0x004)
> +#define IPCMDCLEAR(m)		(((m) * 0x40) + 0x008)
> +#define IPCMDSTATUS(m)		(((m) * 0x40) + 0x00C)
> +#define IPCMMODE(m)		(((m) * 0x40) + 0x010)
> +#define IPCMMSET(m)		(((m) * 0x40) + 0x014)
> +#define IPCMMCLEAR(m)		(((m) * 0x40) + 0x018)
> +#define IPCMMSTATUS(m)		(((m) * 0x40) + 0x01C)
> +#define IPCMSEND(m)		(((m) * 0x40) + 0x020)
> +#define IPCMDR(m, dr)		(((m) * 0x40) + ((dr) * 4) + 0x024)
> +
> +#define IPCMMIS(irq)		(((irq) * 8) + 0x800)
> +#define IPCMRIS(irq)		(((irq) * 8) + 0x804)
> +
> +#define MBOX_MASK(n)		(1 << (n))
> +#define IPC_TX_MBOX		1
> +
> +#define CHAN_MASK(n)		(1 << (n))
> +#define A9_SOURCE		1
> +#define M3_SOURCE		0
> +
> +struct pl320_con {
> +	u32 *data;
> +	int ipc_irq;
> +	struct device *dev;
> +	struct ipc_link link;
> +	void __iomem *ipc_base;
> +	struct ipc_controller ipc_con;
> +};
> +
> +static inline struct pl320_con *to_pl320(struct ipc_link *l)
> +{
> +	if (!l)
> +		return NULL;
> +
> +	return container_of(l, struct pl320_con, link);
> +}
> +
> +static irqreturn_t ipc_handler(int irq, void *p)
> +{
> +	struct ipc_link *link = (struct ipc_link *)p;
> +	struct pl320_con *pl320 = to_pl320(link);
> +	void __iomem *ipc_base = pl320->ipc_base;
> +	u32 irq_stat;
> +
> +	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
> +	if (irq_stat & MBOX_MASK(IPC_TX_MBOX)) {
> +		u32 *data = pl320->data;
> +		int i;
> +
> +		__raw_writel(0, ipc_base + IPCMSEND(IPC_TX_MBOX));
> +
> +		/*
> +		 * The PL320 driver specifies that the send buffer
> +		 * will be overwritten by same fifo upon TX ACK.
> +		 */
> +		for (i = 0; i < 7; i++)
> +			data[i] = __raw_readl(ipc_base
> +					 + IPCMDR(IPC_TX_MBOX, i));
> +
> +		ipc_link_txdone(link, XFER_OK);
> +
> +		pl320->data = NULL;
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int pl320_send_data(struct ipc_link *link, void *msg)
> +{
> +	struct pl320_con *pl320 = to_pl320(link);
> +	void __iomem *ipc_base = pl320->ipc_base;
> +	u32 *data = (u32 *)msg;
> +	int i;
> +
> +	pl320->data = data;
> +
> +	for (i = 0; i < 7; i++)
> +		__raw_writel(data[i], ipc_base + IPCMDR(IPC_TX_MBOX, i));
> +
> +	__raw_writel(0x1, ipc_base + IPCMSEND(IPC_TX_MBOX));
> +
> +	return 0;
> +}
> +
> +static int pl320_startup(struct ipc_link *link, void *ignored)
> +{
> +	struct pl320_con *pl320 = to_pl320(link);
> +	void __iomem *ipc_base = pl320->ipc_base;
> +	int err, ipc_irq = pl320->ipc_irq;
> +
> +	__raw_writel(0, ipc_base + IPCMSEND(IPC_TX_MBOX));
> +
> +	err = request_irq(ipc_irq, ipc_handler, 0, dev_name(pl320->dev), link);
> +	if (err)
> +		return err;
> +
> +	/* Init slow mailbox */
> +	__raw_writel(CHAN_MASK(A9_SOURCE),
> +			ipc_base + IPCMSOURCE(IPC_TX_MBOX));
> +	__raw_writel(CHAN_MASK(M3_SOURCE),
> +			ipc_base + IPCMDSET(IPC_TX_MBOX));
> +	__raw_writel(CHAN_MASK(M3_SOURCE) | CHAN_MASK(A9_SOURCE),
> +		     ipc_base + IPCMMSET(IPC_TX_MBOX));
> +
> +	pl320->data = NULL;
> +	return 0;
> +}
> +
> +static void pl320_shutdown(struct ipc_link *link)
> +{
> +	struct pl320_con *pl320 = to_pl320(link);
> +
> +	pl320->data = NULL;
> +	free_irq(pl320->ipc_irq, link);
> +}
> +
> +static struct ipc_link_ops pl320_ops = {
> +	.send_data = pl320_send_data,
> +	.startup = pl320_startup,
> +	.shutdown = pl320_shutdown,
> +};
> +
> +static int pl320_probe(struct amba_device *adev, const struct amba_id *id)
> +{
> +	struct pl320_con *pl320;
> +	struct ipc_link *l[2];
> +	int ret;
> +
> +	pl320 = kzalloc(sizeof(struct pl320_con), GFP_KERNEL);
> +	if (!pl320)
> +		return -ENOMEM;
> +
> +	pl320->ipc_base = ioremap(adev->res.start, resource_size(&adev->res));
> +	if (pl320->ipc_base == NULL) {
> +		kfree(pl320);
> +		return -ENOMEM;
> +	}
> +
> +	pl320->dev = &adev->dev;
> +	pl320->ipc_irq = adev->irq[0];
> +	amba_set_drvdata(adev, pl320);
> +
> +	l[0] = &pl320->link;
> +	l[1] = NULL;
> +	pl320->ipc_con.links = l;
> +	pl320->ipc_con.txdone_irq = true;
> +	pl320->ipc_con.ops = &pl320_ops;
> +	snprintf(pl320->link.link_name, 16, "A9_to_M3");
> +	snprintf(pl320->ipc_con.controller_name, 16, "pl320");
> +
> +	ret = ipc_links_register(&pl320->ipc_con);
> +	if (ret) {
> +		iounmap(pl320->ipc_base);
> +		kfree(pl320);
> +	}
> +
> +	return ret;
> +}
> +
> +static struct amba_id pl320_ids[] = {
> +	{
> +		.id	= 0x00041320,
> +		.mask	= 0x000fffff,
> +	},
> +	{ 0, 0 },
> +};
> +
> +static struct amba_driver pl320_driver = {
> +	.drv = {
> +		.name	= "pl320",
> +	},
> +	.id_table	= pl320_ids,
> +	.probe		= pl320_probe,
> +};
> +
> +static int __init ipc_init(void)
> +{
> +	return amba_driver_register(&pl320_driver);
> +}
> +module_init(ipc_init);
> diff --git a/include/linux/pl320-ipc.h b/include/linux/pl320-ipc.h
> deleted file mode 100644
> index 5161f63..0000000
> --- a/include/linux/pl320-ipc.h
> +++ /dev/null
> @@ -1,17 +0,0 @@
> -/*
> - * This program is free software; you can redistribute it and/or modify it
> - * under the terms and conditions of the GNU General Public License,
> - * version 2, as published by the Free Software Foundation.
> - *
> - * This program is distributed in the hope it will be useful, but WITHOUT
> - * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> - * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> - * more details.
> - *
> - * You should have received a copy of the GNU General Public License along with
> - * this program.  If not, see <http://www.gnu.org/licenses/>.
> - */
> -
> -int pl320_ipc_transmit(u32 *data);
> -int pl320_ipc_register_notifier(struct notifier_block *nb);
> -int pl320_ipc_unregister_notifier(struct notifier_block *nb);
> 

