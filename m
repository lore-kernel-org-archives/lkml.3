Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab3GHIwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 04:52:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:51978 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3GHIwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 04:52:40 -0400
Message-ID: <51DA7DD5.9060700@linutronix.de>
Date: Mon, 08 Jul 2013 10:52:37 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] usb/musb dma: add cppi41 dma driver
References: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de> <1373040764-3711-2-git-send-email-bigeasy@linutronix.de> <51D9817B.6080209@cogentembedded.com>
In-Reply-To: <51D9817B.6080209@cogentembedded.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2013 04:55 PM, Sergei Shtylyov wrote:
> Hello.

Hello Sergei,

> On 05-07-2013 20:12, Sebastian Andrzej Siewior wrote:
> 
>> This is a first shot of the cppi41 DMA driver.
> 
>    Where have you been when I submitted my drivers back in 2009? :-)

Not here it seems :) There is a driver I got which seem to work but it
is not using the dma engine and is not really in shape so I'm doing
this.

And the current musb's cppi dma engine (3.1, different logic etc.) is
not using dmaengine and the network driver (cpsw) which is also using
cppi 3.1 is having its own implementation of the cppi-dma part. So I
think dma enggine implementation is a must here.

>    MUSB DMA engine support can't be generic unfortunately. There are
> some non-generic DMA registers in each MUSB implementation that used
> CPPI 4.1.

I haven't got to it yet. The TX part seem generic enough so far. There
seem to be two cases of how DMA is used:
- hard wired dma channel like cppi
- mostly free dma channel, the transfer requires the FIFO address

A big win is we move as much as possible of the dma code to drivers/dma
so the driver can be used by other driver's like network. However if we
manage to have better abstraction of the DMA interface within musb we
maybe get even to a point where we can enable multiple engines.

>> diff --git a/arch/arm/boot/dts/am33xx.dtsi
>> b/arch/arm/boot/dts/am33xx.dtsi
>> index bb2298c..fc29b54 100644
>> --- a/arch/arm/boot/dts/am33xx.dtsi
>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>> @@ -349,6 +349,18 @@
>>               status = "disabled";
>>           };
>>
>> +        cppi41dma: dma@07402000 {
> 
>    @47402000? maybe?

maybe, I will double check.

>> +            compatible = "ti,am3359-cppi41";
>> +            reg =  <0x47400000 0x1000    /* usbss */
> 
>    USB register are not a part of CPPI 4.1 DMA. They are not generic and
> are different on e.g. DA8xx/OMAP-L1x. Besides this range is conflicting
> with the next node.

I will shorten them for the range conflict. usbss is only used for
interrupt mask on/off. If there are different, a different compatible
string will carry the difference. I think I will also add the usb
string to it since a possible network engine will look different in
terms of the queue used (which I plan to move away from DT).

>> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
>> index 3215a3c..c19a593 100644
>> --- a/drivers/dma/Kconfig
>> +++ b/drivers/dma/Kconfig
>> @@ -305,6 +305,15 @@ config DMA_OMAP
>>       select DMA_ENGINE
>>       select DMA_VIRTUAL_CHANNELS
>>
>> +config TI_CPPI41
>> +    tristate "AM33xx CPPI41 DMA support"
> 
>    It shouldn't be specific to AM33xx.

Okay.

> 
>> +    depends on ARCH_OMAP
> 
>    And shouldn't depend on ARCH_OMAP only, also on ARCH_DAVINCI_DA8XX.

Okay

> 
> [...]
>> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
>> new file mode 100644
>> index 0000000..80dcb56
>> --- /dev/null
>> +++ b/drivers/dma/cppi41.c
>> @@ -0,0 +1,777 @@
>> +/* USB SS */
>> +#define USBSS_IRQ_STATUS    (0x28)
>> +#define USBSS_IRQ_ENABLER    (0x2c)
>> +#define USBSS_IRQ_CLEARR    (0x30)
> 
>    These shouldn't be here. Why enclose them in () BTW?

The enclose is not on purpose and will be removed. I would keep them
and distinguish different regs via compatible string once we have
different implementations.

>> +#define USBSS_IRQ_RX1        (1 << 11)
>> +#define USBSS_IRQ_TX1        (1 << 10)
>> +#define USBSS_IRQ_RX0        (1 <<  9)
>> +#define USBSS_IRQ_TX0        (1 <<  8)
>> +#define USBSS_IRQ_PD_COMP    (1 <<  2)
>> +
>> +#define USBSS_IRQ_RXTX1        (USBSS_IRQ_RX1 | USBSS_IRQ_TX1)
>> +#define USBSS_IRQ_RXTX0        (USBSS_IRQ_RX0 | USBSS_IRQ_TX0)
>> +#define USBSS_IRQ_RXTX01    (USBSS_IRQ_RXTX0 | USBSS_IRQ_RXTX1)
>> +
> 
>    Neither these shouldn't be here.

Se above.

> 
>> +/* Queue manager */
>> +/* 4 KiB of memory for descriptors, 2 for each endpoint */
> 
>    Endpoints shouldn't be mentioned. CPPI 4.1 is universal DMA engine,
> not USB specific.

Okay. My current plan is to keep 4kib of descriptors memory but add
dynamic allocation.

>> +struct cppi41_dd {
>> +    struct dma_device ddev;
>> +
>> +    void *qmgr_scratch;
>> +    dma_addr_t scratch_phys;
>> +
>> +    struct cppi41_desc *cd;
>> +    dma_addr_t descs_phys;
>> +    struct cppi41_channel *chan_busy[ALLOC_DECS_NUM];
>> +
>> +    void __iomem *usbss_mem;
> 
>    Shouldn't be here.
> 
>> +    void __iomem *ctrl_mem;
>> +    void __iomem *sched_mem;
>> +    void __iomem *qmgr_mem;
>> +    unsigned int irq;
> 
>    Shouldn't be here either.

What is wrong with the four mem pointer here?

>> +static struct cppi41_channel *desc_to_chan(struct cppi41_dd *cdd, u32
>> desc)
>> +{
>> +    struct cppi41_channel *c;
>> +    u32 descs_size;
>> +    u32 desc_num;
>> +
>> +    descs_size = sizeof(struct cppi41_desc) * ALLOC_DECS_NUM;
>> +
>> +    if (!((desc >= cdd->descs_phys) &&
>> +            (desc < (cdd->descs_phys + descs_size)))) {
>> +        return NULL;
>> +    }
> 
>    checkpatch.pl would complain about single statement in {}.

It did not, but I agree.

>> +static void cppi_writel(u32 val, void *__iomem *mem)
>> +{
>> +    writel(val, mem);
>> +}
>> +
>> +static u32 cppi_readl(void *__iomem *mem)
>> +{
>> +    u32 val;
>> +    val = readl(mem);
>> +    return val;
>> +}
> 
>    I don't see much sense in these functions. Besides, they should
> probably be using __raw_{read|write}().

I had printk() before posting for debugging. Using raw would require an
explicit cache flush before triggering the engine, right?

>> +static irqreturn_t cppi41_irq(int irq, void *data)
>> +{
>> +    struct cppi41_dd *cdd = data;
>> +    struct cppi41_channel *c;
>> +    u32 status;
>> +    int i;
>> +
>> +    status = cppi_readl(cdd->usbss_mem + USBSS_IRQ_STATUS);
>> +    if (!(status & USBSS_IRQ_PD_COMP))
>> +        return IRQ_NONE;
> 
>    No, this can't be here.

again. Why not?

>> +static u32 get_host_pd0(u32 length)
>> +{
>> +    u32 reg;
>> +
>> +    reg = DESC_TYPE_HOST << DESC_TYPE;
>> +    reg |= length;
>> +
>> +    return reg;
>> +}
>> +
>> +static u32 get_host_pd1(struct cppi41_channel *c)
>> +{
>> +    u32 reg;
>> +
>> +    reg = 0;
>> +
>> +    return reg;
>> +}
>> +
>> +static u32 get_host_pd2(struct cppi41_channel *c)
>> +{
>> +    u32 reg;
>> +
>> +    reg = 5 << 26; /* USB TYPE */
> 
>    The driver shouldn't be tied to USB at all.

For now it is USB only. Once we git different types we will have
different compatible strings for that. But that shift could by hidden
behind a define so to comment could vanish as well.

>> +static int cppi41_dma_probe(struct platform_device *pdev)
>> +{
>> +    struct cppi41_dd *cdd;
>> +    int irq;
>> +    int ret;
>> +
>> +    cdd = kzalloc(sizeof(*cdd), GFP_KERNEL);
>> +    if (!cdd)
>> +        return -ENOMEM;
>> +
>> +    dma_cap_set(DMA_SLAVE, cdd->ddev.cap_mask);
>> +    cdd->ddev.device_alloc_chan_resources =
>> cppi41_dma_alloc_chan_resources;
>> +    cdd->ddev.device_free_chan_resources =
>> cppi41_dma_free_chan_resources;
>> +    cdd->ddev.device_tx_status = cppi41_dma_tx_status;
>> +    cdd->ddev.device_issue_pending = cppi41_dma_issue_pending;
>> +    cdd->ddev.device_prep_slave_sg = cppi41_dma_prep_slave_sg;
>> +    cdd->ddev.device_control = cppi41_dma_control;
>> +    cdd->ddev.dev = &pdev->dev;
>> +    INIT_LIST_HEAD(&cdd->ddev.channels);
>> +    cpp41_dma_info.dma_cap = cdd->ddev.cap_mask;
>> +
>> +    cdd->usbss_mem = of_iomap(pdev->dev.of_node, 0);
> 
>     You should use the generic platform_get_resource()/
> devm_ioremap_resource() functions.
> 
>> +    irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
>> +    if (!irq)
>> +        goto err_irq;
>> +
>> +    cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);
> 
>     Shouldn't be here.
> 
> [...]
>> +static const struct of_device_id cppi41_dma_ids[] = {
>> +    { .compatible = "ti,am3359-cppi41", },
> 
>     CPPI 4.1 driver should be generic, not SoC specific.

So you want another driver around it to handle the SoC specific stuff?

> 
>> diff --git a/drivers/usb/musb/musb_dma.h b/drivers/usb/musb/musb_dma.h
>> index c8e67fd..bfe2993 100644
>> --- a/drivers/usb/musb/musb_dma.h
>> +++ b/drivers/usb/musb/musb_dma.h
>> @@ -71,7 +71,7 @@ struct musb_hw_ep;
>>   #ifdef CONFIG_USB_TI_CPPI_DMA
>>   #define    is_cppi_enabled()    1
>>   #else
>> -#define    is_cppi_enabled()    0
>> +#define    is_cppi_enabled()    1
> 
>    What does that mean?

This isn't meant for final. It is just for me to easy hacking.

> 
>> diff --git a/drivers/usb/musb/musb_dmaeng.c
>> b/drivers/usb/musb/musb_dmaeng.c
>> new file mode 100644
>> index 0000000..c12f42a
>> --- /dev/null
>> +++ b/drivers/usb/musb/musb_dmaeng.c
>> @@ -0,0 +1,294 @@
> [...]
>> +static struct dma_channel *cppi41_dma_channel_allocate(struct
>> dma_controller *c,
>> +                struct musb_hw_ep *hw_ep, u8 is_tx)
>> +{
>> +    struct cppi41_dma_controller *controller = container_of(c,
>> +            struct cppi41_dma_controller, controller);
>> +    struct cppi41_dma_channel *cppi41_channel = NULL;
>> +    struct musb *musb = controller->musb;
>> +    u8 ch_num = hw_ep->epnum - 1;
>> +
>> +    if (ch_num >= MUSB_DMA_NUM_CHANNELS)
>> +        return NULL;
>> +
>> +    if (!is_tx)
>> +        return NULL;
>> +    if (is_tx)
> 
>     You've just returned on '!is_tx'.

As I said earlier, I have only TX completed so for RX channels there is
nothing to do. If you want this to be removed wait for the next version
which has RX also implemented :)

> [...]
>> +static void cppi41_release_all_dma_chans(struct cppi41_dma_controller
>> *ctrl)
>> +{
>> +    struct dma_chan *dc;
>> +    int i;
>> +
>> +    for (i = 0; i < MUSB_DMA_NUM_CHANNELS; i++) {
>> +        dc = ctrl->tx_channel[i].dc;
>> +        if (dc)
>> +            dma_release_channel(dc);
>> +        dc = ctrl->rx_channel[i].dc;
>> +        if (dc)
>> +            dma_release_channel(dc);
>> +    }
>> +}
>> +
>> +static void cppi41_dma_controller_stop(struct cppi41_dma_controller
>> *controller)
>> +{
>> +    cppi41_release_all_dma_chans(controller);
> 
>    Why not just expand it inline?

Will do so once I'm done and sure that there is nothing else coming
here.

>> +}
>> +
>> +static int cppi41_dma_controller_start(struct cppi41_dma_controller
>> *controller)
>> +{
>> +    struct musb *musb = controller->musb;
>> +    struct device *dev = musb->controller;
>> +    struct device_node *np = dev->of_node;
>> +    struct cppi41_dma_channel *cppi41_channel;
>> +    int count;
>> +    int i;
>> +    int ret;
>> +    dma_cap_mask_t mask;
>> +
>> +    dma_cap_zero(mask);
>> +    dma_cap_set(DMA_SLAVE, mask);
> 
>    You don't seem to use 'mask'.

Strange. That is true but I assumed that I passed it somehow to the
dma-engine code.

> [...]
>> +        musb_dma = &cppi41_channel->channel;
>> +        musb_dma->private_data = cppi41_channel;
>> +        musb_dma->status = MUSB_DMA_STATUS_FREE;
>> +        musb_dma->max_len = SZ_4M;
> 
>    Really?

The TRM says somewhere that it can handle a single transfer up to 4MiB.

> 
> WBR, Sergei
> 

Sebastian
