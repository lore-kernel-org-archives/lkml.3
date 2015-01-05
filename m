Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284AbbAEWtm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:49:42 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53913 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279AbbAEWtj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:49:39 -0500
Message-ID: <54AB14E4.2010607@ti.com>
Date: Mon, 5 Jan 2015 16:49:08 -0600
From: Dave Gerlach <d-gerlach@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2/3] soc: ti: Add wkup_m3_ipc driver
References: <1420228817-41310-1-git-send-email-d-gerlach@ti.com> <1420228817-41310-3-git-send-email-d-gerlach@ti.com> <20150102201643.GE4920@saruman>
In-Reply-To: <20150102201643.GE4920@saruman>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,
On 01/02/2015 02:16 PM, Felipe Balbi wrote:
> On Fri, Jan 02, 2015 at 02:00:16PM -0600, Dave Gerlach wrote:
>> Introduce a wkup_m3_ipc driver to handle communication between the MPU
>> and Cortex M3 wkup_m3 present on am335x.
>>
>> This driver is responsible for actually booting the wkup_m3_rproc and
>> also handling all IPC which is done using the IPC registers in the control
>> module, a mailbox, and a separate interrupt back from the wkup_m3. A small
>> API is exposed for executing specific power commands, which include
>> configuring for low power mode, request a transition to a low power mode,
>> and status info on a previous transition.
>>
>> Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
>> ---
>>  drivers/soc/ti/Kconfig       |  11 ++
>>  drivers/soc/ti/Makefile      |   1 +
>>  drivers/soc/ti/wkup_m3_ipc.c | 451 +++++++++++++++++++++++++++++++++++++++++++
>>  include/linux/wkup_m3_ipc.h  |  33 ++++
>>  4 files changed, 496 insertions(+)
>>  create mode 100644 drivers/soc/ti/wkup_m3_ipc.c
>>  create mode 100644 include/linux/wkup_m3_ipc.h
>>
>> diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
>> index 7266b21..61cda85 100644
>> --- a/drivers/soc/ti/Kconfig
>> +++ b/drivers/soc/ti/Kconfig
>> @@ -28,4 +28,15 @@ config KEYSTONE_NAVIGATOR_DMA
>>  
>>  	  If unsure, say N.
>>  
>> +config WKUP_M3_IPC
>> +	bool "TI AM33XX Wkup-M3 IPC Driver"
> 
> tristate ?

If we want to allow this and the rproc driver to be built as modules than we can
change this.

> 
>> +	depends on WKUP_M3_RPROC
>> +	select MAILBOX
>> +	select OMAP2PLUS_MBOX
> 
> selects are usually frowned upon.

Followed example set by OMAP_REMOTEPROC which selects the mailbox, thought that
would be alright.

> 
>> +	help
>> +	  TI AM33XX has a Cortex M3 to handle low power transitions. This IPC
>> +	  driver provides the necessary API to communicate and use the wkup m3
>> +	  for PM features like Suspend/Resume and boots the wkup_m3 using
>> +	  wkup_m3_rproc driver.
>> +
>>  endif # SOC_TI
>> diff --git a/drivers/soc/ti/Makefile b/drivers/soc/ti/Makefile
>> index 6bed611..b6b8c8b 100644
>> --- a/drivers/soc/ti/Makefile
>> +++ b/drivers/soc/ti/Makefile
>> @@ -3,3 +3,4 @@
>>  #
>>  obj-$(CONFIG_KEYSTONE_NAVIGATOR_QMSS)	+= knav_qmss_queue.o knav_qmss_acc.o
>>  obj-$(CONFIG_KEYSTONE_NAVIGATOR_DMA)	+= knav_dma.o
>> +obj-$(CONFIG_WKUP_M3_IPC)		+= wkup_m3_ipc.o
>> diff --git a/drivers/soc/ti/wkup_m3_ipc.c b/drivers/soc/ti/wkup_m3_ipc.c
>> new file mode 100644
>> index 0000000..4dcf748
>> --- /dev/null
>> +++ b/drivers/soc/ti/wkup_m3_ipc.c
>> @@ -0,0 +1,451 @@
>> +/*
>> + * AMx3 Wkup M3 IPC driver
>> + *
>> + * Copyright (C) 2014 Texas Instruments, Inc.
>> + *
>> + * Dave Gerlach <d-gerlach@ti.com>
>> + *
>> + * This program is free software; you can redistribute it and/or
>> + * modify it under the terms of the GNU General Public License
>> + * version 2 as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/err.h>
>> +#include <linux/kernel.h>
>> +#include <linux/kthread.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/irq.h>
>> +#include <linux/mailbox_client.h>
>> +#include <linux/module.h>
>> +#include <linux/of.h>
>> +#include <linux/omap-mailbox.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/remoteproc.h>
>> +#include <linux/suspend.h>
>> +#include <linux/wkup_m3_ipc.h>
>> +
>> +#define AM33XX_CTRL_IPC_REG_COUNT	0x8
>> +#define AM33XX_CTRL_IPC_REG_OFFSET(m)	(0x4 + 4 * (m))
>> +
>> +/* AM33XX M3_TXEV_EOI register */
>> +#define AM33XX_CONTROL_M3_TXEV_EOI	0x00
>> +
>> +#define AM33XX_M3_TXEV_ACK		(0x1 << 0)
>> +#define AM33XX_M3_TXEV_ENABLE		(0x0 << 0)
>> +
>> +#define IPC_CMD_DS0			0x4
>> +#define IPC_CMD_STANDBY			0xc
>> +#define IPC_CMD_RESET			0xe
>> +#define DS_IPC_DEFAULT			0xffffffff
>> +#define M3_VERSION_UNKNOWN		0x0000ffff
>> +#define M3_BASELINE_VERSION		0x187
>> +#define M3_STATUS_RESP_MASK		(0xffff << 16)
>> +#define M3_FW_VERSION_MASK		0xffff
>> +
>> +#define M3_STATE_UNKNOWN		0
>> +#define M3_STATE_RESET			1
>> +#define M3_STATE_INITED			2
>> +#define M3_STATE_MSG_FOR_LP		3
>> +#define M3_STATE_MSG_FOR_RESET		4
>> +
>> +struct wkup_m3_ipc {
>> +	struct rproc *rproc;
>> +
>> +	void __iomem *ipc_mem_base;
>> +	struct device *dev;
>> +
>> +	int mem_type;
>> +	unsigned long resume_addr;
>> +	int state;
>> +
>> +	struct mbox_client mbox_client;
>> +	struct mbox_chan *mbox;
>> +};
>> +
>> +static struct wkup_m3_ipc m3_ipc_state;
>> +
>> +static DECLARE_COMPLETION(m3_ipc_sync);
> 
> either move this inside struct wkup_m3_ipc or make this
> DECLARE_COMPLETION_ONSTACK();

There is no reason this can't be in the struct, I will move it.

> 
>> +
>> +static inline void am33xx_txev_eoi(struct wkup_m3_ipc *m3_ipc)
>> +{
>> +	writel(AM33XX_M3_TXEV_ACK,
>> +	       m3_ipc->ipc_mem_base + AM33XX_CONTROL_M3_TXEV_EOI);
>> +}
>> +
>> +static inline void am33xx_txev_enable(struct wkup_m3_ipc *m3_ipc)
>> +{
>> +	writel(AM33XX_M3_TXEV_ENABLE,
>> +	       m3_ipc->ipc_mem_base + AM33XX_CONTROL_M3_TXEV_EOI);
>> +}
>> +
>> +static inline void wkup_m3_ctrl_ipc_write(struct wkup_m3_ipc *m3_ipc,
>> +					  u32 val, int ipc_reg_num)
>> +{
>> +	if (ipc_reg_num < 0 || ipc_reg_num > AM33XX_CTRL_IPC_REG_COUNT)
>> +		return;
> 
> you should probably add a WARN() here as this should never happen. Also,
> you might want to remove all "inline" modifiers and let compiler decide
> what to inline.

Good point about the warn, I should switch to that.

> 
>> +
>> +	writel(val, m3_ipc->ipc_mem_base +
>> +	       AM33XX_CTRL_IPC_REG_OFFSET(ipc_reg_num));
>> +}
>> +
>> +static inline unsigned int wkup_m3_ctrl_ipc_read(struct wkup_m3_ipc *m3_ipc,
>> +						 int ipc_reg_num)
>> +{
>> +	if (ipc_reg_num < 0 || ipc_reg_num > AM33XX_CTRL_IPC_REG_COUNT)
>> +		return 0;
>> +
>> +	return readl(m3_ipc->ipc_mem_base +
>> +		     AM33XX_CTRL_IPC_REG_OFFSET(ipc_reg_num));
>> +}
>> +
>> +static int wkup_m3_fw_version_read(void)
> 
> you can very easily pass struct wkup_m3_ipc pointer as argument here.

I can modify all of these static functions to take the wkup_m3_ipc pointer as an
argument.

> 
>> +{
>> +	int val;
>> +
>> +	val = wkup_m3_ctrl_ipc_read(&m3_ipc_state, 2);
>> +
>> +	return val & M3_FW_VERSION_MASK;
>> +}
>> +
>> +static irqreturn_t wkup_m3_txev_handler(int irq, void *ipc_data)
>> +{
>> +	struct wkup_m3_ipc *m3_ipc = (struct wkup_m3_ipc *)ipc_data;
> 
> unnecessary cast

Ok.

> 
>> +	struct device *dev = m3_ipc->dev;
>> +	int ver = 0;
>> +
>> +	am33xx_txev_eoi(m3_ipc);
>> +
>> +	switch (m3_ipc->state) {
>> +	case M3_STATE_RESET:
>> +		ver = wkup_m3_fw_version_read();
>> +
>> +		if (ver == M3_VERSION_UNKNOWN ||
>> +		    ver < M3_BASELINE_VERSION) {
>> +			dev_warn(dev, "CM3 Firmware Version %x not supported\n",
>> +				 ver);
>> +		} else {
>> +			dev_info(dev, "CM3 Firmware Version = 0x%x\n", ver);
>> +		}
>> +
>> +		m3_ipc->state = M3_STATE_INITED;
>> +		complete(&m3_ipc_sync);
>> +		break;
>> +	case M3_STATE_MSG_FOR_RESET:
>> +		m3_ipc->state = M3_STATE_INITED;
>> +		complete(&m3_ipc_sync);
>> +		break;
>> +	case M3_STATE_MSG_FOR_LP:
>> +		complete(&m3_ipc_sync);
>> +		break;
>> +	case M3_STATE_UNKNOWN:
>> +		dev_warn(dev, "Unknown CM3 State\n");
>> +	}
>> +
>> +	am33xx_txev_enable(m3_ipc);
>> +
>> +	return IRQ_HANDLED;
>> +}
>> +
>> +static void wkup_m3_mbox_callback(struct mbox_client *client, void *data)
>> +{
>> +	struct wkup_m3_ipc *m3_ipc = container_of(client, struct wkup_m3_ipc,
>> +						  mbox_client);
>> +
>> +	omap_mbox_disable_irq(m3_ipc->mbox, IRQ_RX);
>> +}
>> +
>> +static int wkup_m3_ping(void)
> 
> same here, pass wkup_m3_ipc pointer as argument.

Yep.

> 
>> +{
>> +	struct device *dev = m3_ipc_state.dev;
>> +	mbox_msg_t dummy_msg = 0;
>> +	int ret;
>> +
>> +	if (!m3_ipc_state.mbox) {
>> +		dev_err(m3_ipc_state.dev,
> 
> you already have a local dev pointer, why don't you use it ?

Thanks for catching this, just a mistake on my part.

> 
>> +			"No IPC channel to communicate with wkup_m3!\n");
>> +		return -EIO;
>> +	}
>> +
>> +	/*
>> +	 * Write a dummy message to the mailbox in order to trigger the RX
>> +	 * interrupt to alert the M3 that data is available in the IPC
>> +	 * registers. We must enable the IRQ here and disable it after in
>> +	 * the RX callback to avoid multiple interrupts being received
>> +	 * by the CM3.
>> +	 */
>> +	omap_mbox_enable_irq(m3_ipc_state.mbox, IRQ_RX);
>> +	ret = mbox_send_message(m3_ipc_state.mbox, (void *)dummy_msg);
> 
> unnecessary cast.

I get a compiler warning without this one, may need it.

> 
>> +	if (ret < 0) {
>> +		dev_err(dev, "%s: mbox_send_message() failed: %d\n",
>> +			__func__, ret);
>> +		return ret;
>> +	}
>> +
>> +	ret = wait_for_completion_timeout(&m3_ipc_sync,
> 
> yeah, why couldn't you ?
> 
> 	wait_for_completion_timeout(&m3_ipc_state->complete, [...]
> 
> why does it have to be declared on the stack as a global variable ?

As I mentioned before, it doesn't and your approach is better.

> 
>> +					  msecs_to_jiffies(500));
>> +	if (!ret) {
>> +		dev_err(dev, "MPU<->CM3 sync failure\n");
>> +		m3_ipc_state.state = M3_STATE_UNKNOWN;
>> +		return -EIO;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static int wkup_m3_is_available(void)
> 
> should pass wkup_m3_ipc pointer as argument.

Yep.

> 
>> +{
>> +	return (m3_ipc_state.state != M3_STATE_RESET);
>> +}
>> +
>> +/* Public functions */
>> +/**
>> + * wkup_m3_set_mem_type - Pass wkup_m3 which type of memory is in use
>> + * @mem_type: memory type value read directly from emif
>> + *
>> + * wkup_m3 must know what memory type is in use to properly suspend
>> + * and resume.
>> + */
>> +void wkup_m3_set_mem_type(int mem_type)
>> +{
>> +	m3_ipc_state.mem_type = mem_type;
>> +}
>> +
>> +/**
>> + * wkup_m3_set_resume_address - Pass wkup_m3 resume address
>> + * @addr: Physical address from which resume code should execute
>> + */
>> +void wkup_m3_set_resume_address(void *addr)
>> +{
>> +	m3_ipc_state.resume_addr = (unsigned long)addr;
>> +}
>> +
>> +/**
>> + * wkup_m3_set_resume_address - Retrieve wkup_m3 status code after suspend
>> + *
>> + * Returns code representing the status of a low power mode transition.
>> + *	0 - Successful transition
>> + *	1 - Failure to transition to low power state
>> + */
>> +int wkup_m3_request_pm_status(void)
>> +{
>> +	unsigned int i;
>> +	int val;
>> +
>> +	val = wkup_m3_ctrl_ipc_read(&m3_ipc_state, 1);
>> +
>> +	i = M3_STATUS_RESP_MASK & val;
>> +	i >>= __ffs(M3_STATUS_RESP_MASK);
>> +
>> +	return i;
>> +}
>> +
>> +/**
>> + * wkup_m3_prepare_low_power - Request preparation for transition to
>> + *			       low power state
>> + * @state: A kernel suspend state to enter, either MEM or STANDBY
>> + *
>> + * Returns 0 if preparation was successful, otherwise returns error code
>> + */
>> +int wkup_m3_prepare_low_power(int state)
>> +{
>> +	struct device *dev = m3_ipc_state.dev;
>> +	int m3_power_state;
>> +	int ret = 0;
>> +
>> +	if (!wkup_m3_is_available()) {
>> +		dev_err(dev, "wkup_m3 not available. DeepSleep entry not possible.\n");
>> +		return -ENODEV;
>> +	}
>> +
>> +	switch (state) {
>> +	case PM_SUSPEND_MEM:
>> +		m3_power_state = IPC_CMD_DS0;
>> +		break;
>> +	default:
>> +		return 1;
>> +	}
>> +
>> +	/* Program each required IPC register then write defaults to others */
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, m3_ipc_state.resume_addr, 0);
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, m3_power_state, 1);
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, m3_ipc_state.mem_type, 4);
>> +
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 2);
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 3);
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 5);
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 6);
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 7);
>> +
>> +	m3_ipc_state.state = M3_STATE_MSG_FOR_LP;
>> +
>> +	ret = wkup_m3_ping();
>> +	if (ret) {
>> +		dev_err(dev, "Unable to ping CM3\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +/**
>> + * wkup_m3_finish_low_power - Return m3 to reset state
>> + *
>> + * Returns 0 if reset was successful, otherwise returns error code
>> + */
>> +int wkup_m3_finish_low_power(void)
>> +{
>> +	struct device *dev = m3_ipc_state.dev;
>> +	int ret = 0;
>> +
>> +	if (!wkup_m3_is_available())
>> +		return -ENODEV;
>> +
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, IPC_CMD_RESET, 1);
>> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 2);
>> +
>> +	m3_ipc_state.state = M3_STATE_MSG_FOR_RESET;
>> +
>> +	ret = wkup_m3_ping();
>> +	if (ret) {
>> +		dev_err(dev, "Unable to ping CM3\n");
>> +		return ret;
>> +	}
>> +
>> +	return 0;
>> +}
> 
> I'm very much against exposed functions like this, but at least declare
> them as EXPORT_SYMBOL_GPL().

Alright, if we do plan to make this buildable as a module then I'll have to add
these anyway.
> 
>> +static void wkup_m3_rproc_boot_thread(struct rproc *rproc)
>> +{
>> +	struct device *dev = &rproc->dev;
>> +	int ret;
>> +
>> +	wait_for_completion(&rproc->firmware_loading_complete);
>> +
>> +	ret = rproc_boot(rproc);
>> +	if (ret)
>> +		dev_err(dev, "rproc_boot failed\n");
>> +
>> +	do_exit(0);
>> +}
>> +
>> +static int wkup_m3_ipc_probe(struct platform_device *pdev)
>> +{
>> +	struct device *dev = &pdev->dev;
>> +	int irq, ret;
>> +	uint32_t rproc_phandle;
>> +	struct rproc *m3_rproc;
>> +	struct resource *res;
>> +	struct task_struct *task;
>> +
>> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "ipc_regs");
>> +	m3_ipc_state.ipc_mem_base = devm_ioremap_resource(dev, res);
>> +	if (IS_ERR(m3_ipc_state.ipc_mem_base)) {
>> +		dev_err(dev, "could not ioremap ipc_mem\n");
>> +		ret = PTR_ERR(m3_ipc_state.ipc_mem_base);
>> +		goto err;
>> +	}
>> +
>> +	irq = platform_get_irq(pdev, 0);
>> +	if (!irq) {
>> +		dev_err(&pdev->dev, "no irq resource\n");
>> +		ret = -ENXIO;
>> +		goto err;
>> +	}
>> +
>> +	ret = devm_request_irq(dev, irq, wkup_m3_txev_handler,
>> +			       IRQF_DISABLED, "wkup_m3_txev", &m3_ipc_state);
>> +	if (ret) {
>> +		dev_err(dev, "request_irq failed\n");
>> +		goto err;
>> +	}
>> +
>> +	m3_ipc_state.mbox_client.dev = dev;
>> +	m3_ipc_state.mbox_client.tx_done = NULL;
>> +	m3_ipc_state.mbox_client.rx_callback = wkup_m3_mbox_callback;
>> +	m3_ipc_state.mbox_client.tx_block = false;
>> +	m3_ipc_state.mbox_client.knows_txdone = false;
>> +
>> +	m3_ipc_state.mbox = mbox_request_channel(&m3_ipc_state.mbox_client, 0);
>> +	if (IS_ERR(m3_ipc_state.mbox)) {
>> +		dev_err(dev, "IPC Request for A8->M3 Channel failed! %ld\n",
>> +			PTR_ERR(m3_ipc_state.mbox));
>> +		ret = PTR_ERR(m3_ipc_state.mbox);
>> +		m3_ipc_state.mbox = NULL;
>> +		return ret;
>> +	}
>> +
>> +	if (of_property_read_u32(dev->of_node, "ti,rproc", &rproc_phandle)) {
>> +		dev_err(&pdev->dev, "could not get rproc phandle\n");
>> +		ret = -ENODEV;
>> +		goto err;
>> +	}
>> +
>> +	m3_rproc = rproc_get_by_phandle(rproc_phandle);
>> +	if (!m3_rproc) {
>> +		dev_err(&pdev->dev, "could not get rproc handle\n");
>> +		ret = -EPROBE_DEFER;
>> +		goto err;
>> +	}
>> +
>> +	m3_ipc_state.rproc = m3_rproc;
>> +	m3_ipc_state.dev = dev;
>> +	m3_ipc_state.state = M3_STATE_RESET;
>> +
>> +	/*
>> +	 * Wait for firmware loading completion in a thread so we
>> +	 * can boot the wkup_m3 as soon as it's ready without holding
>> +	 * up kernel boot
>> +	 */
>> +	task = kthread_run((void *)wkup_m3_rproc_boot_thread, m3_rproc,
>> +			   "wkup_m3_rproc_loader");
> 
> I wonder two things:
> 
> 1) This thread will only be used during boot up. Do we really need a
> thread or would request_firmware_nowait() be enough ?
> 
> 2) what's the size of the firmware ? Is it really so large that we must
> run this as a separate thread ? Meaning, why isn't request_firmware()
> enough ? How much time would we be waiting ?

The issue here comes from the case where you attempt to load a firmware stored
in the rootfs which is the typical use case for this. Remoteproc core requests
the firmware twice, first with _nowait to load the resource table and then again
without nowait to boot the rproc. rproc_boot requires the resource table to be
loaded. The thread is really to wait for the firmware loaded completion, which
gets set after the resource table has been loaded, to let boot proceed. System
boot will get stuck otherwise as this driver can probe before rootfs is available.

> 
>> +
>> +	if (IS_ERR(task)) {
>> +		dev_err(dev, "can't create rproc_boot thread\n");
>> +		goto err_put_rproc;
>> +	}
>> +
>> +	return 0;
>> +
>> +err_put_rproc:
>> +	rproc_put(m3_rproc);
>> +err:
>> +	mbox_free_channel(m3_ipc_state.mbox);
>> +	return ret;
>> +}
>> +
>> +static int wkup_m3_ipc_remove(struct platform_device *pdev)
>> +{
> 
> 	struct wkup_m3_ipc *m3 = platform_get_drvdata(pdev);
> 
>> +	if (m3_ipc_state.mbox)
> 
> if your request mailbox fails, you're bailing out on probe, this check
> is useless.
> 
>> +		mbox_free_channel(m3_ipc_state.mbox);
>> +
>> +	if (m3_ipc_state.rproc) {
> 
> likewise.

Good points, can drop those.

> 
>> +		rproc_shutdown(m3_ipc_state.rproc);
>> +		rproc_put(m3_ipc_state.rproc);
>> +	}
>> +
>> +	return 0;
>> +}
>> +
>> +static const struct of_device_id wkup_m3_ipc_of_match[] = {
>> +	{ .compatible = "ti,am3353-wkup-m3-ipc", .data = NULL, },
> 
> unnnecessary zero initialization.

Yes, will fix.

> 
>> +	{},
>> +};
>> +
>> +static struct platform_driver wkup_m3_ipc_driver = {
>> +	.probe = wkup_m3_ipc_probe,
>> +	.remove = wkup_m3_ipc_remove,
>> +	.driver = {
>> +		.name = "wkup_m3_ipc",
>> +		.of_match_table = wkup_m3_ipc_of_match,
>> +	},
>> +};
>> +
>> +module_platform_driver(wkup_m3_ipc_driver);
>> +
>> +MODULE_LICENSE("GPL v2");
>> +MODULE_DESCRIPTION("wkup m3 remote processor ipc driver");
> 
> MODULE_AUTHOR() ??

Yeah I'll add it.

> 
>> diff --git a/include/linux/wkup_m3_ipc.h b/include/linux/wkup_m3_ipc.h
>> new file mode 100644
>> index 0000000..a0c2722
>> --- /dev/null
>> +++ b/include/linux/wkup_m3_ipc.h
>> @@ -0,0 +1,33 @@
>> +/*
>> + * TI Wakeup M3 for AMx3 SoCs Power Management Routines
>> + *
>> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/
> 
> actually, it's 2015 already, so you probably want:
> 
> * Copyright (C) 2013-2015 Texas Instruments Incorporated - http://www.ti.com/
> 

Whoops, seems I lost track of time there, thansk for the comments.

Regards,
Dave
