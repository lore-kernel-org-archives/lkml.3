Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3GHMic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 08:38:32 -0400
Received: from www.linutronix.de ([62.245.132.108]:52818 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3GHMib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 08:38:31 -0400
Message-ID: <51DAB2C3.6060303@linutronix.de>
Date: Mon, 08 Jul 2013 14:38:27 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130630 Icedove/17.0.7
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: linux-usb@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Felipe Balbi <balbi@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/2] usb/musb dma: add cppi41 dma driver
References: <1373040764-3711-1-git-send-email-bigeasy@linutronix.de> <1373040764-3711-2-git-send-email-bigeasy@linutronix.de> <51D9817B.6080209@cogentembedded.com> <51DA7DD5.9060700@linutronix.de> <51DAAD86.2060102@cogentembedded.com>
In-Reply-To: <51DAAD86.2060102@cogentembedded.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2013 02:16 PM, Sergei Shtylyov wrote:
>> not using dmaengine and the network driver (cpsw) which is also using
>> cppi 3.1 is having its own implementation of the cppi-dma part. So I
>> think dma enggine implementation is a must here.
> 
>    Not at all. I'm not familiar with CPSW but DaVinci EMAC uses CPPI 3.0
> too but it's completely regisyter incompatible with USB. CPPI 3.0
> doesn't seem to be universal DMA engine, hence drivers/dma/ driver
> doesn't seem feasible.

So you suggest to avoid drivers/dma and create drivers/usb
/musb/cpp41-dma.c instead?

cpsw is using davinci_cpdma.c and you say it is completely different
from what musb is using? I just browsed over the spec it looked very
familiar.

>> I will shorten them for the range conflict. usbss is only used for
>> interrupt mask on/off. If there are different, a different compatible
>> string will carry the difference.
> 
>    You don't quite understand. CPPI 4.1 specification as such (which I
> guess you haven't seen) doesn't include any interrupt registers.

Yes but you do have them somewhere. So all its needs is just the SoC
type which brings the register specification.

>> I think I will also add the usb
>> string to it since a possible network engine will look different in
>> terms of the queue used (which I plan to move away from DT).
> 
>    There are out of tree platform which uses CPPI 4.1 not only for USB
> but e.g. for Ethernet.

So what? The binding will be different, you get a different register
for interrupt. I'm still not buying that part where you want skip the
dmaengine framework and introduce custom callbacks for this kind of
things.

>>> diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
>>>> new file mode 100644
>>>> index 0000000..80dcb56
>>>> --- /dev/null
>>>> +++ b/drivers/dma/cppi41.c
>>>> @@ -0,0 +1,777 @@
> [...]
> 
>>>> +struct cppi41_dd {
>>>> +    struct dma_device ddev;
>>>> +
>>>> +    void *qmgr_scratch;
>>>> +    dma_addr_t scratch_phys;
>>>> +
>>>> +    struct cppi41_desc *cd;
>>>> +    dma_addr_t descs_phys;
>>>> +    struct cppi41_channel *chan_busy[ALLOC_DECS_NUM];
>>>> +
>>>> +    void __iomem *usbss_mem;
> 
>>>     Shouldn't be here.
> 
>>>> +    void __iomem *ctrl_mem;
>>>> +    void __iomem *sched_mem;
>>>> +    void __iomem *qmgr_mem;
>>>> +    unsigned int irq;
> 
>>>     Shouldn't be here either.
> 
>> What is wrong with the four mem pointer here?
> 
>    I meant only IRQ (interrupt registers are not part of CPPI 4.1 spec).
> 
>>>> +static void cppi_writel(u32 val, void *__iomem *mem)
>>>> +{
>>>> +    writel(val, mem);
>>>> +}
>>>> +
>>>> +static u32 cppi_readl(void *__iomem *mem)
>>>> +{
>>>> +    u32 val;
>>>> +    val = readl(mem);
>>>> +    return val;
>>>> +}
> 
>>>     I don't see much sense in these functions. Besides, they should
>>> probably be using __raw_{read|write}().
> 
>> I had printk() before posting for debugging. Using raw would require an
>> explicit cache flush before triggering the engine, right?
> 
>    Don't think so -- I wasn't using it.
> 
>>>> +static irqreturn_t cppi41_irq(int irq, void *data)
>>>> +{
>>>> +    struct cppi41_dd *cdd = data;
>>>> +    struct cppi41_channel *c;
>>>> +    u32 status;
>>>> +    int i;
>>>> +
>>>> +    status = cppi_readl(cdd->usbss_mem + USBSS_IRQ_STATUS);
>>>> +    if (!(status & USBSS_IRQ_PD_COMP))
>>>> +        return IRQ_NONE;
> 
>>>     No, this can't be here.
> 
>> again. Why not?
> 
>    This register is not part of CPPI 4.1 spec.
> 
>>>> +static u32 get_host_pd0(u32 length)
>>>> +{
>>>> +    u32 reg;
>>>> +
>>>> +    reg = DESC_TYPE_HOST << DESC_TYPE;
>>>> +    reg |= length;
>>>> +
>>>> +    return reg;
>>>> +}
>>>> +
>>>> +static u32 get_host_pd1(struct cppi41_channel *c)
>>>> +{
>>>> +    u32 reg;
>>>> +
>>>> +    reg = 0;
>>>> +
>>>> +    return reg;
>>>> +}
>>>> +
>>>> +static u32 get_host_pd2(struct cppi41_channel *c)
>>>> +{
>>>> +    u32 reg;
>>>> +
>>>> +    reg = 5 << 26; /* USB TYPE */
> 
>>>     The driver shouldn't be tied to USB at all.
> 
>> For now it is USB only. Once we git different types we will have
>> different compatible strings for that. But that shift could by hidden
>> behind a define so to comment could vanish as well.
> 
>    I repeat: CPPI 4.1 is universal DMA engine. It's a pity that it's
> implemented as a part of USB peripheral on all in-tree platforms but
> it's implemented as an autonomous module on out-of-tree platforms.

It can be still extended to use normal/generic memcpy() operation if
this is supported somewhere. That one here tight to USB and can't do
anything else. I do not start to include a bunch of function pointer if
there is no need it for it. I didn't do anything that it made
impossible to do so, right?

>>>> +static int cppi41_dma_probe(struct platform_device *pdev)
>>>> +{
> [...]
>>>> +    irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
>>>> +    if (!irq)
>>>> +        goto err_irq;
>>>> +
>>>> +    cppi_writel(USBSS_IRQ_PD_COMP, cdd->usbss_mem +
>>>> USBSS_IRQ_ENABLER);
> 
>>>      Shouldn't be here.
> 
>>> [...]
>>>> +static const struct of_device_id cppi41_dma_ids[] = {
>>>> +    { .compatible = "ti,am3359-cppi41", },
> 
>>>      CPPI 4.1 driver should be generic, not SoC specific.
> 
>> So you want another driver around it to handle the SoC specific stuff?
> 
>    This can be handled as part of MUSB DMA driver in our case.

The glue layer you say. Okay. This does not look that bad. I will
try to push it there. But then I need to pass pointers somehow between
cppi41 which is behind dma-engine and this glue layer.

>> As I said earlier, I have only TX completed so for RX channels there is
>> nothing to do. If you want this to be removed wait for the next version
>> which has RX also implemented :)
> 
>    I don't see why this *if* (which couldn't happen) is in current
> version exactly.

Because RX path will be added. It won't stay like that for ever.

>> Sebastian
> 
> PS: Are you aware that TI has written CPPI 4.2 DMA engine driver in
> their Arago project?
> 
> http://linux.davincidsp.com/pipermail/davinci-linux-open-source/2013-February/026345.html

No I wasn't. They could bring their code upstream…

> WBR, Sergei

Sebastian
