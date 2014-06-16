Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264AbaFPXMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 19:12:40 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:47363 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbaFPXMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 19:12:38 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYnFBP8RbOhePed+sq+tk=syME4Trwtd+PgfAyht+3Zqg@mail.gmail.com>
References: <1401457391-12242-1-git-send-email-mathieu.poirier@linaro.org>
	<1401457391-12242-3-git-send-email-mathieu.poirier@linaro.org>
	<CACRpkdYnFBP8RbOhePed+sq+tk=syME4Trwtd+PgfAyht+3Zqg@mail.gmail.com>
Date: Mon, 16 Jun 2014 17:12:38 -0600
Message-ID: <CANLsYky0keX_z0ZggTxst2SfLxB7i1YgcWBOkiV08KHo8mySSw@mail.gmail.com>
Subject: Re: [RFC PATCH 02/11] coresight: add CoreSight TMC driver
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Will Deacon <will.deacon@arm.com>,
        =?UTF-8?B?QXJ2ZSBIasO4bm5ldsOlZw==?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Pratik Patel <pratikp@codeaurora.org>,
        Vikas Varshney <varshney@ti.com>, Al Grant <Al.Grant@arm.com>,
        Jonas Svennebring <jonas.svennebring@avagotech.com>,
        James King <james.king@linaro.org>,
        Panchaxari Prasannamurthy Tumkur 
	<panchaxari.prasannamurthy@linaro.org>,
        Arnd Bergmann <arnd@linaro.org>,
        Marcin Jabrzyk <marcin.jabrzyk@gmail.com>, r.sengupta@samsung.com,
        Robert Marklund <robbelibobban@gmail.com>,
        Patch Tracking <patches@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Daniel Thompson <daniel.thompson@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the review - please see comments in-lined.

Mathieu

On 3 June 2014 03:09, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, May 30, 2014 at 3:43 PM,  <mathieu.poirier@linaro.org> wrote:
>
>> +#define tmc_writel(drvdata, val, off)  __raw_writel((val), drvdata->base + off)
>> +#define tmc_readl(drvdata, off)                __raw_readl(drvdata->base + off)
>
> Why not writel_relaxed()/readl_relaxed()?

Done.

>
> Using __raw* accessors seem a bit thick. (Applies to all such defines.)
>
>> +#define TMC_LOCK(drvdata)                                              \
>> +do {                                                                   \
>> +       /* settle everything first */                                   \
>> +       mb();                                                           \
>> +       tmc_writel(drvdata, 0x0, CORESIGHT_LAR);                        \
>> +} while (0)
>> +#define TMC_UNLOCK(drvdata)                                            \
>> +do {                                                                   \
>> +       tmc_writel(drvdata, CORESIGHT_UNLOCK, CORESIGHT_LAR);           \
>> +       /* make sure everyone sees this */                              \
>> +       mb();                                                           \
>> +} while (0)
>
> Convert these to static inlines. No need for them to be #defines
> at all really.

Done.

>
>> +#define BYTES_PER_WORD         4
>
> But please. Just using the number 4 everywhere is clear enough.
>
>> +struct tmc_drvdata {
>> +       void __iomem            *base;
>> +       struct device           *dev;
>> +       struct coresight_device *csdev;
>> +       struct miscdevice       miscdev;
>> +       struct clk              *clk;
>> +       spinlock_t              spinlock;
>> +       int                     read_count;
>
> Can this really be negative?

It is useful for debugging, as an example see "tmc_release()".  If the
count drops below '0' there is obviously a problem.  Do you see a cost
in keeping this as an 'int'?  What do you advise here?

>
>> +       bool                    reading;
>> +       char                    *buf;
>> +       dma_addr_t              paddr;
>> +       void __iomem            *vaddr;
>> +       uint32_t                size;
>
> Use u32
>
>> +       bool                    enable;
>> +       enum tmc_config_type    config_type;
>> +       uint32_t                trigger_cntr;
>
> Use u32
>
>> +};
>
> This struct overall could use some kerneldoc.

Would writing a comment for each field qualify?

>
>> +static void tmc_flush_and_stop(struct tmc_drvdata *drvdata)
>> +{
>> +       int count;
>
> Why not call this variable "i" as per convention.
>
>> +       uint32_t ffcr;
>
> u32
>
>> +
>> +       ffcr = tmc_readl(drvdata, TMC_FFCR);
>> +       ffcr |= BIT(12);
>> +       tmc_writel(drvdata, ffcr, TMC_FFCR);
>> +       ffcr |= BIT(6);
>
> A bit unclear what bit 12 and 6 does. Either #define them or add comments.
>
>> +       tmc_writel(drvdata, ffcr, TMC_FFCR);
>> +       /* Ensure flush completes */
>> +       for (count = TIMEOUT_US; BVAL(tmc_readl(drvdata, TMC_FFCR), 6) != 0
>> +                               && count > 0; count--)
>> +               udelay(1);
>> +       WARN(count == 0, "timeout while flushing TMC, TMC_FFCR: %#x\n",
>> +            tmc_readl(drvdata, TMC_FFCR));
>> +
>> +       tmc_wait_for_ready(drvdata);
>> +}
>> +
>> +static void __tmc_enable(struct tmc_drvdata *drvdata)
>> +{
>> +       tmc_writel(drvdata, 0x1, TMC_CTL);
>> +}
>> +
>> +static void __tmc_disable(struct tmc_drvdata *drvdata)
>> +{
>> +       tmc_writel(drvdata, 0x0, TMC_CTL);
>> +}
>
> I actually understand what bit 0 does in this register, but could
> also be #defined.
>
>> +static void __tmc_etb_enable(struct tmc_drvdata *drvdata)
>> +{
>> +       /* Zero out the memory to help with debug */
>> +       memset(drvdata->buf, 0, drvdata->size);
>> +
>> +       TMC_UNLOCK(drvdata);
>> +
>> +       tmc_writel(drvdata, TMC_MODE_CIRCULAR_BUFFER, TMC_MODE);
>> +       tmc_writel(drvdata, 0x133, TMC_FFCR);
>
> 0x133? Que ce que c'est?
>
>> +       tmc_writel(drvdata, drvdata->trigger_cntr, TMC_TRG);
>> +       __tmc_enable(drvdata);
>> +
>> +       TMC_LOCK(drvdata);
>> +}
>> +
>> +static void __tmc_etr_enable(struct tmc_drvdata *drvdata)
>> +{
>> +       uint32_t axictl;
>
> u32
>
>> +       /* Zero out the memory to help with debug */
>> +       memset(drvdata->vaddr, 0, drvdata->size);
>> +
>> +       TMC_UNLOCK(drvdata);
>> +
>> +       tmc_writel(drvdata, drvdata->size / BYTES_PER_WORD, TMC_RSZ);
>> +       tmc_writel(drvdata, TMC_MODE_CIRCULAR_BUFFER, TMC_MODE);
>> +
>> +       axictl = tmc_readl(drvdata, TMC_AXICTL);
>> +       axictl |= (0xF << 8);
>> +       tmc_writel(drvdata, axictl, TMC_AXICTL);
>> +       axictl &= ~(0x1 << 7);
>> +       tmc_writel(drvdata, axictl, TMC_AXICTL);
>> +       axictl = (axictl & ~0x3) | 0x2;
>> +       tmc_writel(drvdata, axictl, TMC_AXICTL);
>
> I don't understand these bits and shifts either.
>
>> +       tmc_writel(drvdata, drvdata->paddr, TMC_DBALO);
>> +       tmc_writel(drvdata, 0x0, TMC_DBAHI);
>> +       tmc_writel(drvdata, 0x133, TMC_FFCR);
>
> More magic...
>
>> +       tmc_writel(drvdata, drvdata->trigger_cntr, TMC_TRG);
>> +       __tmc_enable(drvdata);
>> +
>> +       TMC_LOCK(drvdata);
>> +}
>> +
>> +static void __tmc_etf_enable(struct tmc_drvdata *drvdata)
>> +{
>> +       TMC_UNLOCK(drvdata);
>> +
>> +       tmc_writel(drvdata, TMC_MODE_HARDWARE_FIFO, TMC_MODE);
>> +       tmc_writel(drvdata, 0x3, TMC_FFCR);
>> +       tmc_writel(drvdata, 0x0, TMC_BUFWM);
>
> More magic.
>
>> +       __tmc_enable(drvdata);
>> +
>> +       TMC_LOCK(drvdata);
>> +}
>> +
>> +static int tmc_enable(struct tmc_drvdata *drvdata, enum tmc_mode mode)
>> +{
>> +       int ret;
>> +       unsigned long flags;
>> +
>> +       ret = clk_prepare_enable(drvdata->clk);
>> +       if (ret)
>> +               return ret;
>> +
>> +       spin_lock_irqsave(&drvdata->spinlock, flags);
>> +       if (drvdata->reading) {
>> +               spin_unlock_irqrestore(&drvdata->spinlock, flags);
>> +               clk_disable_unprepare(drvdata->clk);
>> +               return -EBUSY;
>> +       }
>> +
>> +       if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
>> +               __tmc_etb_enable(drvdata);
>> +       } else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
>> +               __tmc_etr_enable(drvdata);
>> +       } else {
>> +               if (mode == TMC_MODE_CIRCULAR_BUFFER)
>> +                       __tmc_etb_enable(drvdata);
>> +               else
>> +                       __tmc_etf_enable(drvdata);
>> +       }
>> +       drvdata->enable = true;
>> +       spin_unlock_irqrestore(&drvdata->spinlock, flags);
>> +
>> +       dev_info(drvdata->dev, "TMC enabled\n");
>> +       return 0;
>> +}
>> +
>> +static int tmc_enable_sink(struct coresight_device *csdev)
>> +{
>> +       struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
>> +
>> +       return tmc_enable(drvdata, TMC_MODE_CIRCULAR_BUFFER);
>> +}
>> +
>> +static int tmc_enable_link(struct coresight_device *csdev, int inport,
>> +                          int outport)
>> +{
>> +       struct tmc_drvdata *drvdata = dev_get_drvdata(csdev->dev.parent);
>> +
>> +       return tmc_enable(drvdata, TMC_MODE_HARDWARE_FIFO);
>> +}
>> +
>> +static void __tmc_etb_dump(struct tmc_drvdata *drvdata)
>
> I'm no fan of prefixing functions with __underscores and cannot see why
> this is done here even, just seems like force of habit. Please cut them.
> Rename the function slightly to correspond to what it does if it collides
> with another function.

Done.

>
>> +{
>> +       enum tmc_mem_intf_width memwidth;
>> +       uint8_t memwords;
>
> u8
>
>> +       char *bufp;
>> +       uint32_t read_data;
>
> u32
>
> (...)
>> +       bufp = drvdata->buf;
>> +       while (1) {
>> +               for (i = 0; i < memwords; i++) {
>> +                       read_data = tmc_readl(drvdata, TMC_RRD);
>> +                       if (read_data == 0xFFFFFFFF)
>> +                               return;
>> +                       memcpy(bufp, &read_data, BYTES_PER_WORD);
>> +                       bufp += BYTES_PER_WORD;
>
> Use 4 rather than BYTES_PER_WORD please.
>
> (...)
>> +static void __tmc_etr_dump(struct tmc_drvdata *drvdata)
>
> Cut __
>
>> +{
>> +       uint32_t rwp, rwphi;
>
> u32
>
>> +       rwp = tmc_readl(drvdata, TMC_RWP);
>> +       rwphi = tmc_readl(drvdata, TMC_RWPHI);
>> +
>> +       if (BVAL(tmc_readl(drvdata, TMC_STS), 0))
>> +               drvdata->buf = drvdata->vaddr + rwp - drvdata->paddr;
>> +       else
>> +               drvdata->buf = drvdata->vaddr;
>> +}
>> +
>> +static void __tmc_etr_disable(struct tmc_drvdata *drvdata)
>
> Cut __
>
>> +{
>> +       TMC_UNLOCK(drvdata);
>> +
>> +       tmc_flush_and_stop(drvdata);
>> +       __tmc_etr_dump(drvdata);
>> +       __tmc_disable(drvdata);
>> +
>> +       TMC_LOCK(drvdata);
>> +}
>> +
>> +static void __tmc_etf_disable(struct tmc_drvdata *drvdata)
>
> Cut __
>
> (...)
>> +static int tmc_probe(struct platform_device *pdev)
>> +{
>> +       int ret = 0;
>> +       uint32_t devid;
>
> u32
>
>> +       struct device *dev = &pdev->dev;
>> +       struct coresight_platform_data *pdata = NULL;
>> +       struct tmc_drvdata *drvdata;
>> +       struct resource *res;
>> +       struct coresight_desc *desc;
>> +
>> +       if (pdev->dev.of_node) {
>> +               pdata = of_get_coresight_platform_data(dev, pdev->dev.of_node);
>> +               if (IS_ERR(pdata))
>> +                       return PTR_ERR(pdata);
>> +               pdev->dev.platform_data = pdata;
>> +       }
>> +
>> +       drvdata = devm_kzalloc(dev, sizeof(*drvdata), GFP_KERNEL);
>> +       if (!drvdata)
>> +               return -ENOMEM;
>> +       drvdata->dev = &pdev->dev;
>> +       platform_set_drvdata(pdev, drvdata);
>> +
>> +       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +       if (!res)
>> +               return -ENODEV;
>> +
>> +       drvdata->base = devm_ioremap(dev, res->start, resource_size(res));
>
> Use devm_ioremap_resource() instead.

I'm working on it.

>
>> +       if (drvdata->config_type == TMC_CONFIG_TYPE_ETB) {
>> +               desc->type = CORESIGHT_DEV_TYPE_SINK;
>> +               desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_BUFFER;
>> +               desc->ops = &tmc_etb_cs_ops;
>> +               desc->pdata = pdev->dev.platform_data;
>> +               desc->dev = &pdev->dev;
>> +               desc->debugfs_ops = tmc_etb_attr_grps;
>> +               desc->owner = THIS_MODULE;
>> +               drvdata->csdev = coresight_register(desc);
>> +               if (IS_ERR(drvdata->csdev)) {
>> +                       ret = PTR_ERR(drvdata->csdev);
>> +                       goto err0;
>> +               }
>> +       } else if (drvdata->config_type == TMC_CONFIG_TYPE_ETR) {
>> +               desc->type = CORESIGHT_DEV_TYPE_SINK;
>> +               desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_BUFFER;
>> +               desc->ops = &tmc_etr_cs_ops;
>> +               desc->pdata = pdev->dev.platform_data;
>> +               desc->dev = &pdev->dev;
>> +               desc->debugfs_ops = tmc_etr_attr_grps;
>> +               desc->owner = THIS_MODULE;
>> +               drvdata->csdev = coresight_register(desc);
>> +               if (IS_ERR(drvdata->csdev)) {
>> +                       ret = PTR_ERR(drvdata->csdev);
>> +                       goto err0;
>> +               }
>> +       } else {
>> +               desc->type = CORESIGHT_DEV_TYPE_LINKSINK;
>> +               desc->subtype.sink_subtype = CORESIGHT_DEV_SUBTYPE_SINK_BUFFER;
>> +               desc->subtype.link_subtype = CORESIGHT_DEV_SUBTYPE_LINK_FIFO;
>> +               desc->ops = &tmc_etf_cs_ops;
>> +               desc->pdata = pdev->dev.platform_data;
>> +               desc->dev = &pdev->dev;
>> +               desc->debugfs_ops = tmc_etf_attr_grps;
>> +               desc->owner = THIS_MODULE;
>> +               drvdata->csdev = coresight_register(desc);
>> +               if (IS_ERR(drvdata->csdev)) {
>> +                       ret = PTR_ERR(drvdata->csdev);
>> +                       goto err0;
>> +               }
>> +       }
>
> Actually you set some stuff like desc->dev and pdata to the
> same thing in all three clauses... Do it before the if/else-ladder
> and cut the repititions.

Sure thing.

>
>> +       drvdata->miscdev.name = ((struct coresight_platform_data *)
>> +                                (pdev->dev.platform_data))->name;
>> +       drvdata->miscdev.minor = MISC_DYNAMIC_MINOR;
>> +       drvdata->miscdev.fops = &tmc_fops;
>> +       ret = misc_register(&drvdata->miscdev);
>
> Miscdev really? Well, not that I know any better.
>
>> +static struct platform_driver tmc_driver = {
>> +       .probe          = tmc_probe,
>> +       .remove         = tmc_remove,
>> +       .driver         = {
>> +               .name   = "coresight-tmc",
>> +               .owner  = THIS_MODULE,
>> +               .of_match_table = tmc_match,
>> +       },
>> +};
>> +
>> +static int __init tmc_init(void)
>> +{
>> +       return platform_driver_register(&tmc_driver);
>> +}
>> +module_init(tmc_init);
>> +
>> +static void __exit tmc_exit(void)
>> +{
>> +       platform_driver_unregister(&tmc_driver);
>> +}
>> +module_exit(tmc_exit);
>
> Convert to use module_platform_driver()

Very well.

>
> I think these review comments apply to many of the patches,
> so please take each comment and iterate over the code.
>
> Yours,
> Linus Walleij
