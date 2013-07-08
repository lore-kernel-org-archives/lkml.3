Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab3GHMQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:16:14 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:45630 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442Ab3GHMQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:16:11 -0400
Message-ID: <51DAAD86.2060102@cogentembedded.com>
Date: Mon, 08 Jul 2013 16:16:06 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
CC: linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] usb/musb dma: add cppi41 dma driver
References: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de> <1373040764-3711-2-git-send-email-bigeasy@linutronix.de> <51D9817B.6080209@cogentembedded.com> <51DA7DD5.9060700@linutronix.de>
In-Reply-To: <51DA7DD5.9060700@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08.07.2013 12:52, Sebastian Andrzej Siewior wrote:
> On 07/07/2013 04:55 PM, Sergei Shtylyov wrote:
>> Hello.
>
> Hello Sergei,
>
>> On 05-07-2013 20:12, Sebastian Andrzej Siewior wrote:
>>
>>> This is a first shot of the cppi41 DMA driver.
>>
>>     Where have you been when I submitted my drivers back in 2009? :-)
>
> Not here it seems :) There is a driver I got which seem to work but it
> is not using the dma engine and is not really in shape so I'm doing
> this.

> And the current musb's cppi dma engine (3.1, different logic etc.) is

    3.0 I think.

> not using dmaengine and the network driver (cpsw) which is also using
> cppi 3.1 is having its own implementation of the cppi-dma part. So I
> think dma enggine implementation is a must here.

    Not at all. I'm not familiar with CPSW but DaVinci EMAC uses CPPI 
3.0 too but it's completely regisyter incompatible with USB. CPPI 3.0 
doesn't seem to be universal DMA engine, hence drivers/dma/ driver 
doesn't seem feasible.

>>> diff --git a/arch/arm/boot/dts/am33xx.dtsi
>>> b/arch/arm/boot/dts/am33xx.dtsi
>>> index bb2298c..fc29b54 100644
>>> --- a/arch/arm/boot/dts/am33xx.dtsi
>>> +++ b/arch/arm/boot/dts/am33xx.dtsi
>>> @@ -349,6 +349,18 @@
[...]

>>> +            compatible = "ti,am3359-cppi41";
>>> +            reg =  <0x47400000 0x1000    /* usbss */

>>     USB register are not a part of CPPI 4.1 DMA. They are not generic and
>> are different on e.g. DA8xx/OMAP-L1x. Besides this range is conflicting
>> with the next node.

> I will shorten them for the range conflict. usbss is only used for
> interrupt mask on/off. If there are different, a different compatible
> string will carry the difference.

    You don't quite understand. CPPI 4.1 specification as such (which I 
guess you haven't seen) doesn't include any interrupt registers.

> I think I will also add the usb
> string to it since a possible network engine will look different in
> terms of the queue used (which I plan to move away from DT).

    There are out of tree platform which uses CPPI 4.1 not only for USB 
but e.g. for Ethernet.

>> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
>>> new file mode 100644
>>> index 0000000..80dcb56
>>> --- /dev/null
>>> +++ b/drivers/dma/cppi41.c
>>> @@ -0,0 +1,777 @@
[...]

>>> +struct cppi41_dd {
>>> +    struct dma_device ddev;
>>> +
>>> +    void *qmgr_scratch;
>>> +    dma_addr_t scratch_phys;
>>> +
>>> +    struct cppi41_desc *cd;
>>> +    dma_addr_t descs_phys;
>>> +    struct cppi41_channel *chan_busy[ALLOC_DECS_NUM];
>>> +
>>> +    void __iomem *usbss_mem;

>>     Shouldn't be here.

>>> +    void __iomem *ctrl_mem;
>>> +    void __iomem *sched_mem;
>>> +    void __iomem *qmgr_mem;
>>> +    unsigned int irq;

>>     Shouldn't be here either.

> What is wrong with the four mem pointer here?

    I meant only IRQ (interrupt registers are not part of CPPI 4.1 spec).

>>> +static void cppi_writel(u32 val, void *__iomem *mem)
>>> +{
>>> +    writel(val, mem);
>>> +}
>>> +
>>> +static u32 cppi_readl(void *__iomem *mem)
>>> +{
>>> +    u32 val;
>>> +    val = readl(mem);
>>> +    return val;
>>> +}

>>     I don't see much sense in these functions. Besides, they should
>> probably be using __raw_{read|write}().

> I had printk() before posting for debugging. Using raw would require an
> explicit cache flush before triggering the engine, right?

    Don't think so -- I wasn't using it.

>>> +static irqreturn_t cppi41_irq(int irq, void *data)
>>> +{
>>> +    struct cppi41_dd *cdd = data;
>>> +    struct cppi41_channel *c;
>>> +    u32 status;
>>> +    int i;
>>> +
>>> +    status = cppi_readl(cdd->usbss_mem + USBSS_IRQ_STATUS);
>>> +    if (!(status & USBSS_IRQ_PD_COMP))
>>> +        return IRQ_NONE;

>>     No, this can't be here.

> again. Why not?

    This register is not part of CPPI 4.1 spec.

>>> +static u32 get_host_pd0(u32 length)
>>> +{
>>> +    u32 reg;
>>> +
>>> +    reg = DESC_TYPE_HOST << DESC_TYPE;
>>> +    reg |= length;
>>> +
>>> +    return reg;
>>> +}
>>> +
>>> +static u32 get_host_pd1(struct cppi41_channel *c)
>>> +{
>>> +    u32 reg;
>>> +
>>> +    reg = 0;
>>> +
>>> +    return reg;
>>> +}
>>> +
>>> +static u32 get_host_pd2(struct cppi41_channel *c)
>>> +{
>>> +    u32 reg;
>>> +
>>> +    reg = 5 << 26; /* USB TYPE */

>>     The driver shouldn't be tied to USB at all.

> For now it is USB only. Once we git different types we will have
> different compatible strings for that. But that shift could by hidden
> behind a define so to comment could vanish as well.

    I repeat: CPPI 4.1 is universal DMA engine. It's a pity that it's 
implemented as a part of USB peripheral on all in-tree platforms but 
it's implemented as an autonomous module on out-of-tree platforms.

>>> +static int cppi41_dma_probe(struct platform_device *pdev)
>>> +{
[...]
>>> +    irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
>>> +    if (!irq)
>>> +        goto err_irq;
>>> +
>>> +    cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem + USBSS_IRQ_ENABLER);

>>      Shouldn't be here.

>> [...]
>>> +static const struct of_device_id cppi41_dma_ids[] = {
>>> +    { .compatible = "ti,am3359-cppi41", },

>>      CPPI 4.1 driver should be generic, not SoC specific.

> So you want another driver around it to handle the SoC specific stuff?

    This can be handled as part of MUSB DMA driver in our case.

>>> diff --git a/drivers/usb/musb/musb_dmaeng.c
>>> b/drivers/usb/musb/musb_dmaeng.c
>>> new file mode 100644
>>> index 0000000..c12f42a
>>> --- /dev/null
>>> +++ b/drivers/usb/musb/musb_dmaeng.c
>>> @@ -0,0 +1,294 @@
>> [...]
>>> +static struct dma_channel *cppi41_dma_channel_allocate(struct
>>> dma_controller *c,
>>> +                struct musb_hw_ep *hw_ep, u8 is_tx)
>>> +{
>>> +    struct cppi41_dma_controller *controller = container_of(c,
>>> +            struct cppi41_dma_controller, controller);
>>> +    struct cppi41_dma_channel *cppi41_channel = NULL;
>>> +    struct musb *musb = controller->musb;
>>> +    u8 ch_num = hw_ep->epnum - 1;
>>> +
>>> +    if (ch_num >= MUSB_DMA_NUM_CHANNELS)
>>> +        return NULL;
>>> +
>>> +    if (!is_tx)
>>> +        return NULL;
>>> +    if (is_tx)

>>      You've just returned on '!is_tx'.

> As I said earlier, I have only TX completed so for RX channels there is
> nothing to do. If you want this to be removed wait for the next version
> which has RX also implemented :)

    I don't see why this *if* (which couldn't happen) is in current 
version exactly.

>> [...]
>>> +        musb_dma = &cppi41_channel->channel;
>>> +        musb_dma->private_data = cppi41_channel;
>>> +        musb_dma->status = MUSB_DMA_STATUS_FREE;
>>> +        musb_dma->max_len = SZ_4M;

>>     Really?

> The TRM says somewhere that it can handle a single transfer up to 4MiB.

    Strange, my DA8xx driver didn't seem to include such limitation.

> Sebastian

PS: Are you aware that TI has written CPPI 4.2 DMA engine driver in 
their Arago project?

http://linux.davincidsp.com/pipermail/davinci-linux-open-source/2013-February/026345.html

WBR, Sergei

