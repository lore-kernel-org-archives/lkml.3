Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752177AbbABURr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 15:17:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:43524 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779AbbABURo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 15:17:44 -0500
Date: Fri, 2 Jan 2015 14:16:43 -0600
From: Felipe Balbi <balbi@ti.com>
To: Dave Gerlach <d-gerlach@ti.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 2/3] soc: ti: Add wkup_m3_ipc driver
Message-ID: <20150102201643.GE4920@saruman>
Reply-To: <balbi@ti.com>
References: <1420228817-41310-1-git-send-email-d-gerlach@ti.com>
 <1420228817-41310-3-git-send-email-d-gerlach@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wTWi5aaYRw9ix9vO"
Content-Disposition: inline
In-Reply-To: <1420228817-41310-3-git-send-email-d-gerlach@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--wTWi5aaYRw9ix9vO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 02, 2015 at 02:00:16PM -0600, Dave Gerlach wrote:
> Introduce a wkup_m3_ipc driver to handle communication between the MPU
> and Cortex M3 wkup_m3 present on am335x.
>=20
> This driver is responsible for actually booting the wkup_m3_rproc and
> also handling all IPC which is done using the IPC registers in the control
> module, a mailbox, and a separate interrupt back from the wkup_m3. A small
> API is exposed for executing specific power commands, which include
> configuring for low power mode, request a transition to a low power mode,
> and status info on a previous transition.
>=20
> Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
> ---
>  drivers/soc/ti/Kconfig       |  11 ++
>  drivers/soc/ti/Makefile      |   1 +
>  drivers/soc/ti/wkup_m3_ipc.c | 451 +++++++++++++++++++++++++++++++++++++=
++++++
>  include/linux/wkup_m3_ipc.h  |  33 ++++
>  4 files changed, 496 insertions(+)
>  create mode 100644 drivers/soc/ti/wkup_m3_ipc.c
>  create mode 100644 include/linux/wkup_m3_ipc.h
>=20
> diff --git a/drivers/soc/ti/Kconfig b/drivers/soc/ti/Kconfig
> index 7266b21..61cda85 100644
> --- a/drivers/soc/ti/Kconfig
> +++ b/drivers/soc/ti/Kconfig
> @@ -28,4 +28,15 @@ config KEYSTONE_NAVIGATOR_DMA
> =20
>  	  If unsure, say N.
> =20
> +config WKUP_M3_IPC
> +	bool "TI AM33XX Wkup-M3 IPC Driver"

tristate ?

> +	depends on WKUP_M3_RPROC
> +	select MAILBOX
> +	select OMAP2PLUS_MBOX

selects are usually frowned upon.

> +	help
> +	  TI AM33XX has a Cortex M3 to handle low power transitions. This IPC
> +	  driver provides the necessary API to communicate and use the wkup m3
> +	  for PM features like Suspend/Resume and boots the wkup_m3 using
> +	  wkup_m3_rproc driver.
> +
>  endif # SOC_TI
> diff --git a/drivers/soc/ti/Makefile b/drivers/soc/ti/Makefile
> index 6bed611..b6b8c8b 100644
> --- a/drivers/soc/ti/Makefile
> +++ b/drivers/soc/ti/Makefile
> @@ -3,3 +3,4 @@
>  #
>  obj-$(CONFIG_KEYSTONE_NAVIGATOR_QMSS)	+=3D knav_qmss_queue.o knav_qmss_a=
cc.o
>  obj-$(CONFIG_KEYSTONE_NAVIGATOR_DMA)	+=3D knav_dma.o
> +obj-$(CONFIG_WKUP_M3_IPC)		+=3D wkup_m3_ipc.o
> diff --git a/drivers/soc/ti/wkup_m3_ipc.c b/drivers/soc/ti/wkup_m3_ipc.c
> new file mode 100644
> index 0000000..4dcf748
> --- /dev/null
> +++ b/drivers/soc/ti/wkup_m3_ipc.c
> @@ -0,0 +1,451 @@
> +/*
> + * AMx3 Wkup M3 IPC driver
> + *
> + * Copyright (C) 2014 Texas Instruments, Inc.
> + *
> + * Dave Gerlach <d-gerlach@ti.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * version 2 as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/err.h>
> +#include <linux/kernel.h>
> +#include <linux/kthread.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/mailbox_client.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/omap-mailbox.h>
> +#include <linux/platform_device.h>
> +#include <linux/remoteproc.h>
> +#include <linux/suspend.h>
> +#include <linux/wkup_m3_ipc.h>
> +
> +#define AM33XX_CTRL_IPC_REG_COUNT	0x8
> +#define AM33XX_CTRL_IPC_REG_OFFSET(m)	(0x4 + 4 * (m))
> +
> +/* AM33XX M3_TXEV_EOI register */
> +#define AM33XX_CONTROL_M3_TXEV_EOI	0x00
> +
> +#define AM33XX_M3_TXEV_ACK		(0x1 << 0)
> +#define AM33XX_M3_TXEV_ENABLE		(0x0 << 0)
> +
> +#define IPC_CMD_DS0			0x4
> +#define IPC_CMD_STANDBY			0xc
> +#define IPC_CMD_RESET			0xe
> +#define DS_IPC_DEFAULT			0xffffffff
> +#define M3_VERSION_UNKNOWN		0x0000ffff
> +#define M3_BASELINE_VERSION		0x187
> +#define M3_STATUS_RESP_MASK		(0xffff << 16)
> +#define M3_FW_VERSION_MASK		0xffff
> +
> +#define M3_STATE_UNKNOWN		0
> +#define M3_STATE_RESET			1
> +#define M3_STATE_INITED			2
> +#define M3_STATE_MSG_FOR_LP		3
> +#define M3_STATE_MSG_FOR_RESET		4
> +
> +struct wkup_m3_ipc {
> +	struct rproc *rproc;
> +
> +	void __iomem *ipc_mem_base;
> +	struct device *dev;
> +
> +	int mem_type;
> +	unsigned long resume_addr;
> +	int state;
> +
> +	struct mbox_client mbox_client;
> +	struct mbox_chan *mbox;
> +};
> +
> +static struct wkup_m3_ipc m3_ipc_state;
> +
> +static DECLARE_COMPLETION(m3_ipc_sync);

either move this inside struct wkup_m3_ipc or make this
DECLARE_COMPLETION_ONSTACK();

> +
> +static inline void am33xx_txev_eoi(struct wkup_m3_ipc *m3_ipc)
> +{
> +	writel(AM33XX_M3_TXEV_ACK,
> +	       m3_ipc->ipc_mem_base + AM33XX_CONTROL_M3_TXEV_EOI);
> +}
> +
> +static inline void am33xx_txev_enable(struct wkup_m3_ipc *m3_ipc)
> +{
> +	writel(AM33XX_M3_TXEV_ENABLE,
> +	       m3_ipc->ipc_mem_base + AM33XX_CONTROL_M3_TXEV_EOI);
> +}
> +
> +static inline void wkup_m3_ctrl_ipc_write(struct wkup_m3_ipc *m3_ipc,
> +					  u32 val, int ipc_reg_num)
> +{
> +	if (ipc_reg_num < 0 || ipc_reg_num > AM33XX_CTRL_IPC_REG_COUNT)
> +		return;

you should probably add a WARN() here as this should never happen. Also,
you might want to remove all "inline" modifiers and let compiler decide
what to inline.

> +
> +	writel(val, m3_ipc->ipc_mem_base +
> +	       AM33XX_CTRL_IPC_REG_OFFSET(ipc_reg_num));
> +}
> +
> +static inline unsigned int wkup_m3_ctrl_ipc_read(struct wkup_m3_ipc *m3_=
ipc,
> +						 int ipc_reg_num)
> +{
> +	if (ipc_reg_num < 0 || ipc_reg_num > AM33XX_CTRL_IPC_REG_COUNT)
> +		return 0;
> +
> +	return readl(m3_ipc->ipc_mem_base +
> +		     AM33XX_CTRL_IPC_REG_OFFSET(ipc_reg_num));
> +}
> +
> +static int wkup_m3_fw_version_read(void)

you can very easily pass struct wkup_m3_ipc pointer as argument here.

> +{
> +	int val;
> +
> +	val =3D wkup_m3_ctrl_ipc_read(&m3_ipc_state, 2);
> +
> +	return val & M3_FW_VERSION_MASK;
> +}
> +
> +static irqreturn_t wkup_m3_txev_handler(int irq, void *ipc_data)
> +{
> +	struct wkup_m3_ipc *m3_ipc =3D (struct wkup_m3_ipc *)ipc_data;

unnecessary cast

> +	struct device *dev =3D m3_ipc->dev;
> +	int ver =3D 0;
> +
> +	am33xx_txev_eoi(m3_ipc);
> +
> +	switch (m3_ipc->state) {
> +	case M3_STATE_RESET:
> +		ver =3D wkup_m3_fw_version_read();
> +
> +		if (ver =3D=3D M3_VERSION_UNKNOWN ||
> +		    ver < M3_BASELINE_VERSION) {
> +			dev_warn(dev, "CM3 Firmware Version %x not supported\n",
> +				 ver);
> +		} else {
> +			dev_info(dev, "CM3 Firmware Version =3D 0x%x\n", ver);
> +		}
> +
> +		m3_ipc->state =3D M3_STATE_INITED;
> +		complete(&m3_ipc_sync);
> +		break;
> +	case M3_STATE_MSG_FOR_RESET:
> +		m3_ipc->state =3D M3_STATE_INITED;
> +		complete(&m3_ipc_sync);
> +		break;
> +	case M3_STATE_MSG_FOR_LP:
> +		complete(&m3_ipc_sync);
> +		break;
> +	case M3_STATE_UNKNOWN:
> +		dev_warn(dev, "Unknown CM3 State\n");
> +	}
> +
> +	am33xx_txev_enable(m3_ipc);
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static void wkup_m3_mbox_callback(struct mbox_client *client, void *data)
> +{
> +	struct wkup_m3_ipc *m3_ipc =3D container_of(client, struct wkup_m3_ipc,
> +						  mbox_client);
> +
> +	omap_mbox_disable_irq(m3_ipc->mbox, IRQ_RX);
> +}
> +
> +static int wkup_m3_ping(void)

same here, pass wkup_m3_ipc pointer as argument.

> +{
> +	struct device *dev =3D m3_ipc_state.dev;
> +	mbox_msg_t dummy_msg =3D 0;
> +	int ret;
> +
> +	if (!m3_ipc_state.mbox) {
> +		dev_err(m3_ipc_state.dev,

you already have a local dev pointer, why don't you use it ?

> +			"No IPC channel to communicate with wkup_m3!\n");
> +		return -EIO;
> +	}
> +
> +	/*
> +	 * Write a dummy message to the mailbox in order to trigger the RX
> +	 * interrupt to alert the M3 that data is available in the IPC
> +	 * registers. We must enable the IRQ here and disable it after in
> +	 * the RX callback to avoid multiple interrupts being received
> +	 * by the CM3.
> +	 */
> +	omap_mbox_enable_irq(m3_ipc_state.mbox, IRQ_RX);
> +	ret =3D mbox_send_message(m3_ipc_state.mbox, (void *)dummy_msg);

unnecessary cast.

> +	if (ret < 0) {
> +		dev_err(dev, "%s: mbox_send_message() failed: %d\n",
> +			__func__, ret);
> +		return ret;
> +	}
> +
> +	ret =3D wait_for_completion_timeout(&m3_ipc_sync,

yeah, why couldn't you ?

	wait_for_completion_timeout(&m3_ipc_state->complete, [...]

why does it have to be declared on the stack as a global variable ?

> +					  msecs_to_jiffies(500));
> +	if (!ret) {
> +		dev_err(dev, "MPU<->CM3 sync failure\n");
> +		m3_ipc_state.state =3D M3_STATE_UNKNOWN;
> +		return -EIO;
> +	}
> +
> +	return 0;
> +}
> +
> +static int wkup_m3_is_available(void)

should pass wkup_m3_ipc pointer as argument.

> +{
> +	return (m3_ipc_state.state !=3D M3_STATE_RESET);
> +}
> +
> +/* Public functions */
> +/**
> + * wkup_m3_set_mem_type - Pass wkup_m3 which type of memory is in use
> + * @mem_type: memory type value read directly from emif
> + *
> + * wkup_m3 must know what memory type is in use to properly suspend
> + * and resume.
> + */
> +void wkup_m3_set_mem_type(int mem_type)
> +{
> +	m3_ipc_state.mem_type =3D mem_type;
> +}
> +
> +/**
> + * wkup_m3_set_resume_address - Pass wkup_m3 resume address
> + * @addr: Physical address from which resume code should execute
> + */
> +void wkup_m3_set_resume_address(void *addr)
> +{
> +	m3_ipc_state.resume_addr =3D (unsigned long)addr;
> +}
> +
> +/**
> + * wkup_m3_set_resume_address - Retrieve wkup_m3 status code after suspe=
nd
> + *
> + * Returns code representing the status of a low power mode transition.
> + *	0 - Successful transition
> + *	1 - Failure to transition to low power state
> + */
> +int wkup_m3_request_pm_status(void)
> +{
> +	unsigned int i;
> +	int val;
> +
> +	val =3D wkup_m3_ctrl_ipc_read(&m3_ipc_state, 1);
> +
> +	i =3D M3_STATUS_RESP_MASK & val;
> +	i >>=3D __ffs(M3_STATUS_RESP_MASK);
> +
> +	return i;
> +}
> +
> +/**
> + * wkup_m3_prepare_low_power - Request preparation for transition to
> + *			       low power state
> + * @state: A kernel suspend state to enter, either MEM or STANDBY
> + *
> + * Returns 0 if preparation was successful, otherwise returns error code
> + */
> +int wkup_m3_prepare_low_power(int state)
> +{
> +	struct device *dev =3D m3_ipc_state.dev;
> +	int m3_power_state;
> +	int ret =3D 0;
> +
> +	if (!wkup_m3_is_available()) {
> +		dev_err(dev, "wkup_m3 not available. DeepSleep entry not possible.\n");
> +		return -ENODEV;
> +	}
> +
> +	switch (state) {
> +	case PM_SUSPEND_MEM:
> +		m3_power_state =3D IPC_CMD_DS0;
> +		break;
> +	default:
> +		return 1;
> +	}
> +
> +	/* Program each required IPC register then write defaults to others */
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, m3_ipc_state.resume_addr, 0);
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, m3_power_state, 1);
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, m3_ipc_state.mem_type, 4);
> +
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 2);
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 3);
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 5);
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 6);
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 7);
> +
> +	m3_ipc_state.state =3D M3_STATE_MSG_FOR_LP;
> +
> +	ret =3D wkup_m3_ping();
> +	if (ret) {
> +		dev_err(dev, "Unable to ping CM3\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * wkup_m3_finish_low_power - Return m3 to reset state
> + *
> + * Returns 0 if reset was successful, otherwise returns error code
> + */
> +int wkup_m3_finish_low_power(void)
> +{
> +	struct device *dev =3D m3_ipc_state.dev;
> +	int ret =3D 0;
> +
> +	if (!wkup_m3_is_available())
> +		return -ENODEV;
> +
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, IPC_CMD_RESET, 1);
> +	wkup_m3_ctrl_ipc_write(&m3_ipc_state, DS_IPC_DEFAULT, 2);
> +
> +	m3_ipc_state.state =3D M3_STATE_MSG_FOR_RESET;
> +
> +	ret =3D wkup_m3_ping();
> +	if (ret) {
> +		dev_err(dev, "Unable to ping CM3\n");
> +		return ret;
> +	}
> +
> +	return 0;
> +}

I'm very much against exposed functions like this, but at least declare
them as EXPORT_SYMBOL_GPL().

> +static void wkup_m3_rproc_boot_thread(struct rproc *rproc)
> +{
> +	struct device *dev =3D &rproc->dev;
> +	int ret;
> +
> +	wait_for_completion(&rproc->firmware_loading_complete);
> +
> +	ret =3D rproc_boot(rproc);
> +	if (ret)
> +		dev_err(dev, "rproc_boot failed\n");
> +
> +	do_exit(0);
> +}
> +
> +static int wkup_m3_ipc_probe(struct platform_device *pdev)
> +{
> +	struct device *dev =3D &pdev->dev;
> +	int irq, ret;
> +	uint32_t rproc_phandle;
> +	struct rproc *m3_rproc;
> +	struct resource *res;
> +	struct task_struct *task;
> +
> +	res =3D platform_get_resource_byname(pdev, IORESOURCE_MEM, "ipc_regs");
> +	m3_ipc_state.ipc_mem_base =3D devm_ioremap_resource(dev, res);
> +	if (IS_ERR(m3_ipc_state.ipc_mem_base)) {
> +		dev_err(dev, "could not ioremap ipc_mem\n");
> +		ret =3D PTR_ERR(m3_ipc_state.ipc_mem_base);
> +		goto err;
> +	}
> +
> +	irq =3D platform_get_irq(pdev, 0);
> +	if (!irq) {
> +		dev_err(&pdev->dev, "no irq resource\n");
> +		ret =3D -ENXIO;
> +		goto err;
> +	}
> +
> +	ret =3D devm_request_irq(dev, irq, wkup_m3_txev_handler,
> +			       IRQF_DISABLED, "wkup_m3_txev", &m3_ipc_state);
> +	if (ret) {
> +		dev_err(dev, "request_irq failed\n");
> +		goto err;
> +	}
> +
> +	m3_ipc_state.mbox_client.dev =3D dev;
> +	m3_ipc_state.mbox_client.tx_done =3D NULL;
> +	m3_ipc_state.mbox_client.rx_callback =3D wkup_m3_mbox_callback;
> +	m3_ipc_state.mbox_client.tx_block =3D false;
> +	m3_ipc_state.mbox_client.knows_txdone =3D false;
> +
> +	m3_ipc_state.mbox =3D mbox_request_channel(&m3_ipc_state.mbox_client, 0=
);
> +	if (IS_ERR(m3_ipc_state.mbox)) {
> +		dev_err(dev, "IPC Request for A8->M3 Channel failed! %ld\n",
> +			PTR_ERR(m3_ipc_state.mbox));
> +		ret =3D PTR_ERR(m3_ipc_state.mbox);
> +		m3_ipc_state.mbox =3D NULL;
> +		return ret;
> +	}
> +
> +	if (of_property_read_u32(dev->of_node, "ti,rproc", &rproc_phandle)) {
> +		dev_err(&pdev->dev, "could not get rproc phandle\n");
> +		ret =3D -ENODEV;
> +		goto err;
> +	}
> +
> +	m3_rproc =3D rproc_get_by_phandle(rproc_phandle);
> +	if (!m3_rproc) {
> +		dev_err(&pdev->dev, "could not get rproc handle\n");
> +		ret =3D -EPROBE_DEFER;
> +		goto err;
> +	}
> +
> +	m3_ipc_state.rproc =3D m3_rproc;
> +	m3_ipc_state.dev =3D dev;
> +	m3_ipc_state.state =3D M3_STATE_RESET;
> +
> +	/*
> +	 * Wait for firmware loading completion in a thread so we
> +	 * can boot the wkup_m3 as soon as it's ready without holding
> +	 * up kernel boot
> +	 */
> +	task =3D kthread_run((void *)wkup_m3_rproc_boot_thread, m3_rproc,
> +			   "wkup_m3_rproc_loader");

I wonder two things:

1) This thread will only be used during boot up. Do we really need a
thread or would request_firmware_nowait() be enough ?

2) what's the size of the firmware ? Is it really so large that we must
run this as a separate thread ? Meaning, why isn't request_firmware()
enough ? How much time would we be waiting ?

> +
> +	if (IS_ERR(task)) {
> +		dev_err(dev, "can't create rproc_boot thread\n");
> +		goto err_put_rproc;
> +	}
> +
> +	return 0;
> +
> +err_put_rproc:
> +	rproc_put(m3_rproc);
> +err:
> +	mbox_free_channel(m3_ipc_state.mbox);
> +	return ret;
> +}
> +
> +static int wkup_m3_ipc_remove(struct platform_device *pdev)
> +{

	struct wkup_m3_ipc *m3 =3D platform_get_drvdata(pdev);

> +	if (m3_ipc_state.mbox)

if your request mailbox fails, you're bailing out on probe, this check
is useless.

> +		mbox_free_channel(m3_ipc_state.mbox);
> +
> +	if (m3_ipc_state.rproc) {

likewise.

> +		rproc_shutdown(m3_ipc_state.rproc);
> +		rproc_put(m3_ipc_state.rproc);
> +	}
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id wkup_m3_ipc_of_match[] =3D {
> +	{ .compatible =3D "ti,am3353-wkup-m3-ipc", .data =3D NULL, },

unnnecessary zero initialization.

> +	{},
> +};
> +
> +static struct platform_driver wkup_m3_ipc_driver =3D {
> +	.probe =3D wkup_m3_ipc_probe,
> +	.remove =3D wkup_m3_ipc_remove,
> +	.driver =3D {
> +		.name =3D "wkup_m3_ipc",
> +		.of_match_table =3D wkup_m3_ipc_of_match,
> +	},
> +};
> +
> +module_platform_driver(wkup_m3_ipc_driver);
> +
> +MODULE_LICENSE("GPL v2");
> +MODULE_DESCRIPTION("wkup m3 remote processor ipc driver");

MODULE_AUTHOR() ??

> diff --git a/include/linux/wkup_m3_ipc.h b/include/linux/wkup_m3_ipc.h
> new file mode 100644
> index 0000000..a0c2722
> --- /dev/null
> +++ b/include/linux/wkup_m3_ipc.h
> @@ -0,0 +1,33 @@
> +/*
> + * TI Wakeup M3 for AMx3 SoCs Power Management Routines
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com/

actually, it's 2015 already, so you probably want:

* Copyright (C) 2013-2015 Texas Instruments Incorporated - http://www.ti.co=
m/

--=20
balbi

--wTWi5aaYRw9ix9vO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUpvyrAAoJEIaOsuA1yqREqPkQAJFRjXiyxYdJdLWe0lGDJPgD
NpUzhxgAVkcwcUPbdG1GCUMiCqpHnjOSx187fMepJS5ki+DFud/IlPFAjwwMPtwW
Q1KgYcl0eb8or11BB/X4JVcBMX3khIrgpLx5YaSnLjQ+BpBROVaeLFveqVR0x93G
6rJHQw2ziuqNo/PSxgPCwdf+o5kllxUl6aNqRJPR0poKURM6HESp44yWXQmZIaWY
RR2vRXni8mgaG+1MLG2uIVKVQoJHthG5JrpdElOHVcy/4kkevHJcY+D8xZlR9Dd2
R8+oyQTu1nlClwXyyojmCDvhAajdbsQVFTiTGyLZF2F1cKVki/CPyb+E0b5n6w7Q
swI+60oxOzyhnzauTZm6r5MrUA3p7l+/dGrMa/PVTm8VVLlzaHQLnX9GIsfWHZjI
El7BsbmjPmbdxwPhc5ohN/1ZRQ1/WJ9zfX+6/GTdFOGS326sB2/WR42iG1YPW0nD
TN7I0xqARxXZwfgXV40nKkkXErf52iR3f34ODZZKgPAQqQMIJo61PZSMfRKcboZp
MtwvM9XrOz6fqgWiu3BgQgfyyVVMygsSCgbzjZ9oIL5ADuBcXhTf6UHR5r4kRX63
U7/xE562xq1ZO8L3eQ4skMHXe0HznIM9nOQcPz8P1zTvbp7Usfq1RhYDK07tKzx2
dkANMPhEHT2RjR7vKf04
=/Xk6
-----END PGP SIGNATURE-----

--wTWi5aaYRw9ix9vO--
