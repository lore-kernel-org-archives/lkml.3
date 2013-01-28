Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3A1Mm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:42:56 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:57744 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751390Ab3A1Mmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:42:54 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Langsdorf <mark.langsdorf@calxeda.com>
Cc: linux-kernel@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Rob Herring <rob.herring@calxeda.com>,
        Omar Ramirez Luna <omar.luna@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 3/4 v11] arm highbank: add support for pl320 IPC
Date: Mon, 28 Jan 2013 13:49:01 +0100
Message-ID: <1457500.uzVh9cxXhS@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1359143205-20279-4-git-send-email-mark.langsdorf@calxeda.com>
References: <1351631056-25938-1-git-send-email-mark.langsdorf@calxeda.com> <1359143205-20279-1-git-send-email-mark.langsdorf@calxeda.com> <1359143205-20279-4-git-send-email-mark.langsdorf@calxeda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 25, 2013 01:46:44 PM Mark Langsdorf wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> The pl320 IPC allows for interprocessor communication between the highbank A9
> and the EnergyCore Management Engine. The pl320 implements a straightforward
> mailbox protocol.
> 
> Signed-off-by: Mark Langsdorf <mark.langsdorf@calxeda.com>
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Cc: Omar Ramirez Luna <omar.luna@linaro.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes from v10
> 	Removed deependency on Omar Ramirez Luna's mailbox code. Now the
> 	patch creates the directory itself.
> Changes from v9
>         Used to be the 4th patch in the series.
> Changes from v6, v7, v8
>         None.
> Changes from v5
>         Renamed ipc_transmit() to pl320_ipc_transmit().
>         Properly exported pl320_ipc_{un}register_notifier().
> Changes from v4
>         Moved pl320-ipc.c from arch/arm/mach-highbank to drivers/mailbox.
>         Moved header information to include/linux/mailbox.h.
>         Added Kconfig options to reflect the new code location.
>         Change drivers/mailbox/Makefile to build the omap mailboxes only 
>         when they are configured.
>         Removed ipc_call_fast and renamed ipc_call_slow ipc_transmit.
> Changes from v3, v2
>         None.
> Changes from v1
>         Removed erroneous changes for cpufreq Kconfig.
> 
>  arch/arm/mach-highbank/Kconfig |   2 +
>  drivers/mailbox/Kconfig        |  18 ++++
>  drivers/mailbox/Makefile       |   1 +
>  drivers/mailbox/pl320-ipc.c    | 199 +++++++++++++++++++++++++++++++++++++++++
>  include/linux/mailbox.h        |  18 ++++
>  5 files changed, 238 insertions(+)
>  create mode 100644 drivers/mailbox/Kconfig
>  create mode 100644 drivers/mailbox/Makefile
>  create mode 100644 drivers/mailbox/pl320-ipc.c
>  create mode 100644 include/linux/mailbox.h
> 
> diff --git a/arch/arm/mach-highbank/Kconfig b/arch/arm/mach-highbank/Kconfig
> index 551c97e..2388085 100644
> --- a/arch/arm/mach-highbank/Kconfig
> +++ b/arch/arm/mach-highbank/Kconfig
> @@ -11,5 +11,7 @@ config ARCH_HIGHBANK
>  	select GENERIC_CLOCKEVENTS
>  	select HAVE_ARM_SCU
>  	select HAVE_SMP
> +	select MAILBOX
> +	select PL320_MBOX
>  	select SPARSE_IRQ
>  	select USE_OF
> diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
> new file mode 100644
> index 0000000..9489554
> --- /dev/null
> +++ b/drivers/mailbox/Kconfig
> @@ -0,0 +1,18 @@
> +menuconfig MAILBOX
> +	bool "Mailbox Hardware Support"
> +	help
> +	  Mailbox is a framework to control hardware communication between
> +	  on-chip processors through queued messages and interrupt driven
> +	  signals. Say Y if your platform supports hardware mailboxes.
> +
> +if MAILBOX
> +config PL320_MBOX
> +	bool "ARM PL320 Mailbox"
> +	help
> +	  An implementation of the ARM PL320 Interprocessor Communication
> +	  Mailbox (IPCM), tailored for the Calxeda Highbank. It is used to
> +	  send short messages between Highbank's A9 cores and the EnergyCore
> +	  Management Engine, primarily for cpufreq. Say Y here if you want
> +	  to use the PL320 IPCM support.
> +
> +endif
> diff --git a/drivers/mailbox/Makefile b/drivers/mailbox/Makefile
> new file mode 100644
> index 0000000..543ad6a
> --- /dev/null
> +++ b/drivers/mailbox/Makefile
> @@ -0,0 +1 @@
> +obj-$(CONFIG_PL320_MBOX)	+= pl320-ipc.o
> diff --git a/drivers/mailbox/pl320-ipc.c b/drivers/mailbox/pl320-ipc.c
> new file mode 100644
> index 0000000..68c0d50
> --- /dev/null
> +++ b/drivers/mailbox/pl320-ipc.c
> @@ -0,0 +1,199 @@
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
> +
> +#include <linux/mailbox.h>
> +
> +#define IPCMxSOURCE(m)		((m) * 0x40)
> +#define IPCMxDSET(m)		(((m) * 0x40) + 0x004)
> +#define IPCMxDCLEAR(m)		(((m) * 0x40) + 0x008)
> +#define IPCMxDSTATUS(m)		(((m) * 0x40) + 0x00C)
> +#define IPCMxMODE(m)		(((m) * 0x40) + 0x010)
> +#define IPCMxMSET(m)		(((m) * 0x40) + 0x014)
> +#define IPCMxMCLEAR(m)		(((m) * 0x40) + 0x018)
> +#define IPCMxMSTATUS(m)		(((m) * 0x40) + 0x01C)
> +#define IPCMxSEND(m)		(((m) * 0x40) + 0x020)
> +#define IPCMxDR(m, dr)		(((m) * 0x40) + ((dr) * 4) + 0x024)
> +
> +#define IPCMMIS(irq)		(((irq) * 8) + 0x800)
> +#define IPCMRIS(irq)		(((irq) * 8) + 0x804)
> +
> +#define MBOX_MASK(n)		(1 << (n))
> +#define IPC_TX_MBOX		1
> +#define IPC_RX_MBOX		2
> +
> +#define CHAN_MASK(n)		(1 << (n))
> +#define A9_SOURCE		1
> +#define M3_SOURCE		0
> +
> +static void __iomem *ipc_base;
> +static int ipc_irq;
> +static DEFINE_MUTEX(ipc_m1_lock);
> +static DECLARE_COMPLETION(ipc_completion);
> +static ATOMIC_NOTIFIER_HEAD(ipc_notifier);
> +
> +static inline void set_destination(int source, int mbox)
> +{
> +	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDSET(mbox));
> +	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMSET(mbox));
> +}
> +
> +static inline void clear_destination(int source, int mbox)
> +{
> +	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxDCLEAR(mbox));
> +	__raw_writel(CHAN_MASK(source), ipc_base + IPCMxMCLEAR(mbox));
> +}
> +
> +static void __ipc_send(int mbox, u32 *data)
> +{
> +	int i;
> +	for (i = 0; i < 7; i++)
> +		__raw_writel(data[i], ipc_base + IPCMxDR(mbox, i));
> +	__raw_writel(0x1, ipc_base + IPCMxSEND(mbox));
> +}
> +
> +static u32 __ipc_rcv(int mbox, u32 *data)
> +{
> +	int i;
> +	for (i = 0; i < 7; i++)
> +		data[i] = __raw_readl(ipc_base + IPCMxDR(mbox, i));
> +	return data[1];
> +}
> +
> +/* blocking implmentation from the A9 side, not usuable in interrupts! */
> +int pl320_ipc_transmit(u32 *data)
> +{
> +	int ret;
> +
> +	mutex_lock(&ipc_m1_lock);
> +
> +	init_completion(&ipc_completion);
> +	__ipc_send(IPC_TX_MBOX, data);
> +	ret = wait_for_completion_timeout(&ipc_completion,
> +					  msecs_to_jiffies(1000));
> +	if (ret == 0) {
> +		ret = -ETIMEDOUT;
> +		goto out;
> +	}
> +
> +	ret = __ipc_rcv(IPC_TX_MBOX, data);
> +out:
> +	mutex_unlock(&ipc_m1_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL(pl320_ipc_transmit);
> +
> +irqreturn_t ipc_handler(int irq, void *dev)
> +{
> +	u32 irq_stat;
> +	u32 data[7];
> +
> +	irq_stat = __raw_readl(ipc_base + IPCMMIS(1));
> +	if (irq_stat & MBOX_MASK(IPC_TX_MBOX)) {
> +		__raw_writel(0, ipc_base + IPCMxSEND(IPC_TX_MBOX));
> +		complete(&ipc_completion);
> +	}
> +	if (irq_stat & MBOX_MASK(IPC_RX_MBOX)) {
> +		__ipc_rcv(IPC_RX_MBOX, data);
> +		atomic_notifier_call_chain(&ipc_notifier, data[0], data + 1);
> +		__raw_writel(2, ipc_base + IPCMxSEND(IPC_RX_MBOX));
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +int pl320_ipc_register_notifier(struct notifier_block *nb)
> +{
> +	return atomic_notifier_chain_register(&ipc_notifier, nb);
> +}
> +EXPORT_SYMBOL(pl320_ipc_register_notifier);
> +
> +int pl320_ipc_unregister_notifier(struct notifier_block *nb)
> +{
> +	return atomic_notifier_chain_unregister(&ipc_notifier, nb);
> +}
> +EXPORT_SYMBOL(pl320_ipc_unregister_notifier);

I need all of your symbols to be exported with EXPORT_SYMBOL_GPL().

Is it OK to make that change when applying the patch or do you want to send
a new one?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
