Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651Ab3GGO4G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 10:56:06 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:44692 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318Ab3GGO4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 10:56:00 -0400
Message-ID: <51D9817B.6080209@cogentembedded.com>
Date: Sun, 07 Jul 2013 18:55:55 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] usb/musb dma: add cppi41 dma driver
References: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de> <1373040764-3711-2-git-send-email-bigeasy@linutronix.de>
In-Reply-To: <1373040764-3711-2-git-send-email-bigeasy@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 05-07-2013 20:12, Sebastian Andrzej Siewior wrote:

> This is a first shot of the cppi41 DMA driver.

    Where have you been when I submitted my drivers back in 2009? :-)

> It is currently used by
> a new musb dma-engine implementation. I have to test it somehow.

> The state of the cpp41 (and the using dmaengine) is in very early stage.
> I was able to send TX packets over DMA and enumerate an USB masstorage
> device.
> Things that need to be taken care of:
> - RX path
> - cancel of transfers
> - dynamic descriptor allocation
> - re-think the current device tree nodes.
>    Currently a node looks like:
>    	&cppi41dma X Y Z Q
>    that means:
>     - X: dma channel
>     - Y: RX/TX
>     - Z: start queue
>     - Q: complete queue
>    Each value number is hardwired with the USB endpoint it is using. The
>    DMA channels are hardwired with USB endpoints and the start/complete
>    is hardwired with the DMA channel.

> I add each DMA channel twice: once for RX the other for TX (that is why
> I need the direction (Y) uppon lookup).
> The RX/TX channel can be used simultaneously i.e. program & start RX,
> program & start TX and TX can complete before RX.
> Currently I think that it would be best to remove the queue logic from
> the device and put it into the driver.

> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>   arch/arm/boot/dts/am33xx.dtsi  |  50 +++
>   drivers/dma/Kconfig            |   9 +
>   drivers/dma/Makefile           |   1 +
>   drivers/dma/cppi41.c           | 777 +++++++++++++++++++++++++++++++++++++++++
>   drivers/usb/musb/Kconfig       |   4 +
>   drivers/usb/musb/Makefile      |   1 +
>   drivers/usb/musb/musb_dma.h    |   2 +-
>   drivers/usb/musb/musb_dmaeng.c | 294 ++++++++++++++++

    MUSB DMA engine support can't be generic unfortunately. There are 
some non-generic DMA registers in each MUSB implementation that used 
CPPI 4.1.

>   8 files changed, 1137 insertions(+), 1 deletion(-)
>   create mode 100644 drivers/dma/cppi41.c
>   create mode 100644 drivers/usb/musb/musb_dmaeng.c
>
> diff --git a/arch/arm/boot/dts/am33xx.dtsi b/arch/arm/boot/dts/am33xx.dtsi
> index bb2298c..fc29b54 100644
> --- a/arch/arm/boot/dts/am33xx.dtsi
> +++ b/arch/arm/boot/dts/am33xx.dtsi
> @@ -349,6 +349,18 @@
>   			status = "disabled";
>   		};
>
> +		cppi41dma: dma@07402000 {

    @47402000? maybe?

> +			compatible = "ti,am3359-cppi41";
> +			reg =  <0x47400000 0x1000	/* usbss */

    USB register are not a part of CPPI 4.1 DMA. They are not generic 
and are different on e.g. DA8xx/OMAP-L1x. Besides this range is 
conflicting with the next node.

> +				0x47402000 0x1000	/* controller */
> +				0x47403000 0x1000	/* scheduler */
> +				0x47404000 0x4000>;	/* queue manager */
> +			interrupts = <17>;
> +			#dma-cells = <4>;
> +			#dma-channels = <30>;
> +			#dma-requests = <256>;
> +		};
> +
>   		musb: usb@47400000 {
>   			compatible = "ti,musb-am33xx";
>   			reg = <0x47400000 0x1000>;
[...]
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 3215a3c..c19a593 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -305,6 +305,15 @@ config DMA_OMAP
>   	select DMA_ENGINE
>   	select DMA_VIRTUAL_CHANNELS
>
> +config TI_CPPI41
> +	tristate "AM33xx CPPI41 DMA support"

    It shouldn't be specific to AM33xx.

> +	depends on ARCH_OMAP

    And shouldn't depend on ARCH_OMAP only, also on ARCH_DAVINCI_DA8XX.

[...]
> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
> new file mode 100644
> index 0000000..80dcb56
> --- /dev/null
> +++ b/drivers/dma/cppi41.c
> @@ -0,0 +1,777 @@
> +#include <linux/dmaengine.h>
> +#include <linux/dma-mapping.h>
> +#include <linux/platform_device.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/slab.h>
> +#include <linux/of_dma.h>
> +#include <linux/of_irq.h>
> +#include <linux/dmapool.h>
> +#include <linux/interrupt.h>
> +#include <linux/of_address.h>
> +#include "dmaengine.h"
> +
> +#define DESC_TYPE	27
> +#define DESC_TYPE_HOST	0x10
> +#define DESC_TYPE_TEARD	0x13
> +
> +#define TD_DESC_TX_RX	16
> +#define TD_DESC_DMA_NUM	10
> +
> +/* USB SS */
> +#define USBSS_IRQ_STATUS	(0x28)
> +#define USBSS_IRQ_ENABLER	(0x2c)
> +#define USBSS_IRQ_CLEARR	(0x30)

    These shouldn't be here. Why enclose them in () BTW?

> +
> +#define USBSS_IRQ_RX1		(1 << 11)
> +#define USBSS_IRQ_TX1		(1 << 10)
> +#define USBSS_IRQ_RX0		(1 <<  9)
> +#define USBSS_IRQ_TX0		(1 <<  8)
> +#define USBSS_IRQ_PD_COMP	(1 <<  2)
> +
> +#define USBSS_IRQ_RXTX1		(USBSS_IRQ_RX1 | USBSS_IRQ_TX1)
> +#define USBSS_IRQ_RXTX0		(USBSS_IRQ_RX0 | USBSS_IRQ_TX0)
> +#define USBSS_IRQ_RXTX01	(USBSS_IRQ_RXTX0 | USBSS_IRQ_RXTX1)
> +

    Neither these shouldn't be here.

> +/* Queue manager */
> +/* 4 KiB of memory for descriptors, 2 for each endpoint */

    Endpoints shouldn't be mentioned. CPPI 4.1 is universal DMA engine, 
not USB specific.

> +struct cppi41_dd {
> +	struct dma_device ddev;
> +
> +	void *qmgr_scratch;
> +	dma_addr_t scratch_phys;
> +
> +	struct cppi41_desc *cd;
> +	dma_addr_t descs_phys;
> +	struct cppi41_channel *chan_busy[ALLOC_DECS_NUM];
> +
> +	void __iomem *usbss_mem;

    Shouldn't be here.

> +	void __iomem *ctrl_mem;
> +	void __iomem *sched_mem;
> +	void __iomem *qmgr_mem;
> +	unsigned int irq;

    Shouldn't be here either.

> +static struct cppi41_channel *desc_to_chan(struct cppi41_dd *cdd, u32 desc)
> +{
> +	struct cppi41_channel *c;
> +	u32 descs_size;
> +	u32 desc_num;
> +
> +	descs_size = sizeof(struct cppi41_desc) * ALLOC_DECS_NUM;
> +
> +	if (!((desc >= cdd->descs_phys) &&
> +			(desc < (cdd->descs_phys + descs_size)))) {
> +		return NULL;
> +	}

    checkpatch.pl would complain about single statement in {}.

> +static void cppi_writel(u32 val, void *__iomem *mem)
> +{
> +	writel(val, mem);
> +}
> +
> +static u32 cppi_readl(void *__iomem *mem)
> +{
> +	u32 val;
> +	val = readl(mem);
> +	return val;
> +}

    I don't see much sense in these functions. Besides, they should 
probably be using __raw_{read|write}().

> +static irqreturn_t cppi41_irq(int irq, void *data)
> +{
> +	struct cppi41_dd *cdd = data;
> +	struct cppi41_channel *c;
> +	u32 status;
> +	int i;
> +
> +	status = cppi_readl(cdd->usbss_mem + USBSS_IRQ_STATUS);
> +	if (!(status & USBSS_IRQ_PD_COMP))
> +		return IRQ_NONE;

    No, this can't be here.

> +static u32 get_host_pd0(u32 length)
> +{
> +	u32 reg;
> +
> +	reg = DESC_TYPE_HOST << DESC_TYPE;
> +	reg |= length;
> +
> +	return reg;
> +}
> +
> +static u32 get_host_pd1(struct cppi41_channel *c)
> +{
> +	u32 reg;
> +
> +	reg = 0;
> +
> +	return reg;
> +}
> +
> +static u32 get_host_pd2(struct cppi41_channel *c)
> +{
> +	u32 reg;
> +
> +	reg = 5 << 26; /* USB TYPE */

    The driver shouldn't be tied to USB at all.

> +static int cppi41_dma_probe(struct platform_device *pdev)
> +{
> +	struct cppi41_dd *cdd;
> +	int irq;
> +	int ret;
> +
> +	cdd = kzalloc(sizeof(*cdd), GFP_KERNEL);
> +	if (!cdd)
> +		return -ENOMEM;
> +
> +	dma_cap_set(DMA_SLAVE, cdd->ddev.cap_mask);
> +	cdd->ddev.device_alloc_chan_resources = cppi41_dma_alloc_chan_resources;
> +	cdd->ddev.device_free_chan_resources = cppi41_dma_free_chan_resources;
> +	cdd->ddev.device_tx_status = cppi41_dma_tx_status;
> +	cdd->ddev.device_issue_pending = cppi41_dma_issue_pending;
> +	cdd->ddev.device_prep_slave_sg = cppi41_dma_prep_slave_sg;
> +	cdd->ddev.device_control = cppi41_dma_control;
> +	cdd->ddev.dev = &pdev->dev;
> +	INIT_LIST_HEAD(&cdd->ddev.channels);
> +	cpp41_dma_info.dma_cap = cdd->ddev.cap_mask;
> +
> +	cdd->usbss_mem = of_iomap(pdev->dev.of_node, 0);

     You should use the generic platform_get_resource()/ 
devm_ioremap_resource() functions.

> +	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
> +	if (!irq)
> +		goto err_irq;
> +
> +	cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);

     Shouldn't be here.

[...]
> +static const struct of_device_id cppi41_dma_ids[] = {
> +	{ .compatible = "ti,am3359-cppi41", },

     CPPI 4.1 driver should be generic, not SoC specific.

> diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
> index c8e67fd..bfe2993 100644
> --- a/drivers/usb/musb/musb_dma.h
> +++ b/drivers/usb/musb/musb_dma.h
> @@ -71,7 +71,7 @@ struct musb_hw_ep;
>   #ifdef CONFIG_USB_TI_CPPI_DMA
>   #define	is_cppi_enabled()	1
>   #else
> -#define	is_cppi_enabled()	0
> +#define	is_cppi_enabled()	1

    What does that mean?

> diff --git a/drivers/usb/musb/musb_dmaeng.c b/drivers/usb/musb/musb_dmaeng.c
> new file mode 100644
> index 0000000..c12f42a
> --- /dev/null
> +++ b/drivers/usb/musb/musb_dmaeng.c
> @@ -0,0 +1,294 @@
[...]
> +static struct dma_channel *cppi41_dma_channel_allocate(struct dma_controller *c,
> +				struct musb_hw_ep *hw_ep, u8 is_tx)
> +{
> +	struct cppi41_dma_controller *controller = container_of(c,
> +			struct cppi41_dma_controller, controller);
> +	struct cppi41_dma_channel *cppi41_channel = NULL;
> +	struct musb *musb = controller->musb;
> +	u8 ch_num = hw_ep->epnum - 1;
> +
> +	if (ch_num >= MUSB_DMA_NUM_CHANNELS)
> +		return NULL;
> +
> +	if (!is_tx)
> +		return NULL;
> +	if (is_tx)

     You've just returned on '!is_tx'.

[...]
> +static void cppi41_release_all_dma_chans(struct cppi41_dma_controller *ctrl)
> +{
> +	struct dma_chan *dc;
> +	int i;
> +
> +	for (i = 0; i < MUSB_DMA_NUM_CHANNELS; i++) {
> +		dc = ctrl->tx_channel[i].dc;
> +		if (dc)
> +			dma_release_channel(dc);
> +		dc = ctrl->rx_channel[i].dc;
> +		if (dc)
> +			dma_release_channel(dc);
> +	}
> +}
> +
> +static void cppi41_dma_controller_stop(struct cppi41_dma_controller *controller)
> +{
> +	cppi41_release_all_dma_chans(controller);

    Why not just expand it inline?

> +}
> +
> +static int cppi41_dma_controller_start(struct cppi41_dma_controller *controller)
> +{
> +	struct musb *musb = controller->musb;
> +	struct device *dev = musb->controller;
> +	struct device_node *np = dev->of_node;
> +	struct cppi41_dma_channel *cppi41_channel;
> +	int count;
> +	int i;
> +	int ret;
> +	dma_cap_mask_t mask;
> +
> +	dma_cap_zero(mask);
> +	dma_cap_set(DMA_SLAVE, mask);

    You don't seem to use 'mask'.

[...]
> +		musb_dma = &cppi41_channel->channel;
> +		musb_dma->private_data = cppi41_channel;
> +		musb_dma->status = MUSB_DMA_STATUS_FREE;
> +		musb_dma->max_len = SZ_4M;

    Really?

WBR, Sergei

