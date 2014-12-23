Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586AbaLWW2W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 17:28:22 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:53961 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691AbaLWW2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 17:28:20 -0500
MIME-Version: 1.0
In-Reply-To: <20141214203759.GA36053@dtor-ws>
References: <1418408748-9797-1-git-send-email-vishnupatekar0510@gmail.com>
	<1418408748-9797-3-git-send-email-vishnupatekar0510@gmail.com>
	<20141214203759.GA36053@dtor-ws>
Date: Wed, 24 Dec 2014 03:58:18 +0530
Message-ID: <CAEzqOZsYk=McwkUfeeknvmJjOvwRL3bjJVCrGSHbRVu_shhxUA@mail.gmail.com>
Subject: Re: [PATCHv3 2/5] ARM:sunxi:drivers:input Add support for A10/A20 PS2
From: Vishnu Patekar <vishnupatekar0510@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "pawel.moll@arm.com" <pawel.moll@arm.com>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>,
        "msalter@redhat.com" <msalter@redhat.com>,
        "ralf@linux-mips.org" <ralf@linux-mips.org>,
        "jdelvare@suse.de" <jdelvare@suse.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,
Sorry for delayed response. please find my comment in-lined.
Please let me know in case I am wrong.

On Mon, Dec 15, 2014 at 2:07 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Hi Vishnu,
>
> On Fri, Dec 12, 2014 at 11:55:45PM +0530, VishnuPatekar wrote:
>>
>> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
>> ---
>>  drivers/input/serio/Kconfig     |   11 ++
>>  drivers/input/serio/Makefile    |    1 +
>>  drivers/input/serio/sun4i-ps2.c |  362 +++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 374 insertions(+)
>>  create mode 100644 drivers/input/serio/sun4i-ps2.c
>>
>> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
>> index bc2d474..964afc5 100644
>> --- a/drivers/input/serio/Kconfig
>> +++ b/drivers/input/serio/Kconfig
>> @@ -281,4 +281,15 @@ config HYPERV_KEYBOARD
>>         To compile this driver as a module, choose M here: the module will
>>         be called hyperv_keyboard.
>>
>> +config SERIO_SUN4I_PS2
>> +     tristate "Allwinner A10 PS/2 controller support"
>> +     default n
>> +     depends on ARCH_SUNXI || COMPILE_TEST
>> +     help
>> +       This selects support for the PS/2 Host Controller on
>> +       Allwinner A10.
>> +
>> +       To compile this driver as a module, choose M here: the
>> +       module will be called sun4i-ps2.
>> +
>>  endif
>> diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
>> index 815d874..c600089 100644
>> --- a/drivers/input/serio/Makefile
>> +++ b/drivers/input/serio/Makefile
>> @@ -29,3 +29,4 @@ obj-$(CONFIG_SERIO_ARC_PS2) += arc_ps2.o
>>  obj-$(CONFIG_SERIO_APBPS2)   += apbps2.o
>>  obj-$(CONFIG_SERIO_OLPC_APSP)        += olpc_apsp.o
>>  obj-$(CONFIG_HYPERV_KEYBOARD)        += hyperv-keyboard.o
>> +obj-$(CONFIG_SERIO_SUN4I_PS2)        += sun4i-ps2.o
>> diff --git a/drivers/input/serio/sun4i-ps2.c b/drivers/input/serio/sun4i-ps2.c
>> new file mode 100644
>> index 0000000..e6d22ae
>> --- /dev/null
>> +++ b/drivers/input/serio/sun4i-ps2.c
>> @@ -0,0 +1,362 @@
>> +/*
>> + *   Driver for Allwinner A10 PS2 host controller
>> + *
>> + *   Author: Vishnu Patekar <vishnupatekar0510@gmail.com>
>> + *           Aaron.maoye <leafy.myeh@newbietech.com>
>> + *
>> + *
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/serio.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/errno.h>
>> +#include <linux/slab.h>
>> +#include <linux/list.h>
>> +#include <linux/io.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/clk.h>
>> +#include <linux/delay.h>
>> +
>> +#define DRIVER_NAME          "sun4i-ps2"
>> +
>> +/* register offset definitions */
>> +#define PS2_REG_GCTL         (0x00)  /*  PS2 Module Global Control Reg */
>> +#define PS2_REG_DATA         (0x04)  /*  PS2 Module Data Reg         */
>> +#define PS2_REG_LCTL         (0x08)  /*  PS2 Module Line Control Reg */
>> +#define PS2_REG_LSTS         (0x0C)  /*  PS2 Module Line Status Reg  */
>> +#define PS2_REG_FCTL         (0x10)  /*  PS2 Module FIFO Control Reg */
>> +#define PS2_REG_FSTS         (0x14)  /*  PS2 Module FIFO Status Reg  */
>> +#define PS2_REG_CLKDR                (0x18)  /*  PS2 Module Clock Divider Reg*/
>
> You do not need parenthesis around simple constants.
Okie, I'll remove.
>
>> +
>> +/*  PS2 GLOBAL CONTROL REGISTER PS2_GCTL */
>> +#define PS2_GCTL_INTFLAG     BIT(4)
>> +#define PS2_GCTL_INTEN               BIT(3)
>> +#define PS2_GCTL_RESET               BIT(2)
>> +#define PS2_GCTL_MASTER              BIT(1)
>> +#define PS2_GCTL_BUSEN               BIT(0)
>> +
>> +/* PS2 LINE CONTROL REGISTER */
>> +#define PS2_LCTL_NOACK               BIT(18)
>> +#define PS2_LCTL_TXDTOEN     BIT(8)
>> +#define PS2_LCTL_STOPERREN   BIT(3)
>> +#define PS2_LCTL_ACKERREN    BIT(2)
>> +#define PS2_LCTL_PARERREN    BIT(1)
>> +#define PS2_LCTL_RXDTOEN     BIT(0)
>> +
>> +/* PS2 LINE STATUS REGISTER */
>> +#define PS2_LSTS_TXTDO               BIT(8)
>> +#define PS2_LSTS_STOPERR     BIT(3)
>> +#define PS2_LSTS_ACKERR              BIT(2)
>> +#define PS2_LSTS_PARERR              BIT(1)
>> +#define PS2_LSTS_RXTDO               BIT(0)
>> +
>> +#define PS2_LINE_ERROR_BIT \
>> +     (PS2_LSTS_TXTDO | PS2_LSTS_STOPERR | PS2_LSTS_ACKERR | \
>> +     PS2_LSTS_PARERR | PS2_LSTS_RXTDO)
>> +
>> +/* PS2 FIFO CONTROL REGISTER */
>> +#define PS2_FCTL_TXRST               BIT(17)
>> +#define PS2_FCTL_RXRST               BIT(16)
>> +#define PS2_FCTL_TXUFIEN     BIT(10)
>> +#define PS2_FCTL_TXOFIEN     BIT(9)
>> +#define PS2_FCTL_TXRDYIEN    BIT(8)
>> +#define PS2_FCTL_RXUFIEN     BIT(2)
>> +#define PS2_FCTL_RXOFIEN     BIT(1)
>> +#define PS2_FCTL_RXRDYIEN    BIT(0)
>> +
>> +/* PS2 FIFO STATUS REGISTER */
>> +#define PS2_FSTS_TXUF                BIT(10)
>> +#define PS2_FSTS_TXOF                BIT(9)
>> +#define PS2_FSTS_TXRDY               BIT(8)
>> +#define PS2_FSTS_RXUF                BIT(2)
>> +#define PS2_FSTS_RXOF                BIT(1)
>> +#define PS2_FSTS_RXRDY               BIT(0)
>> +
>> +#define PS2_FIFO_ERROR_BIT \
>> +     (PS2_FSTS_TXUF | PS2_FSTS_TXOF | PS2_FSTS_RXUF | PS2_FSTS_RXOF)
>> +
>> +#define PS2_SAMPLE_CLK               (1000000)
>> +#define PS2_SCLK             (125000)
I'll remove these parenthesis around simple constants.
>> +
>> +struct sun4i_ps2data {
>> +     struct serio *serio;
>> +     struct device *dev;
>> +
>> +     /* IO mapping base */
>> +     void __iomem    *reg_base;
>> +
>> +     /* clock management */
>> +     struct clk      *clk;
>> +
>> +     /* irq */
>> +     spinlock_t      lock;
>> +     int             irq;
>> +};
>> +
>> +/*********************/
>> +/* Interrupt handler */
>> +/*********************/
>> +static irqreturn_t sun4i_ps2_interrupt(int irq, void *dev_id)
>> +{
>> +     struct sun4i_ps2data *drvdata = dev_id;
>> +     u32 intr_status;
>> +     u32 fifo_status;
>> +     unsigned char byte;
>> +     u32 rval;
>> +     u32 error = 0;
>> +
>> +     spin_lock(&drvdata->lock);
>> +
>> +     /* Get the PS/2 interrupts and clear them */
>> +     intr_status  = readl(drvdata->reg_base + PS2_REG_LSTS);
>> +     fifo_status  = readl(drvdata->reg_base + PS2_REG_FSTS);
>> +
>> +     /*Check Line Status Register*/
>> +     if (intr_status & PS2_LINE_ERROR_BIT) {
>> +             if (intr_status & PS2_LSTS_STOPERR)
>> +                     dev_info(drvdata->dev, "PS/2 Stop Bit Error!");
>
> The stop bit error is I believe should be reported to consumers as
> SSERIO_FRAME, receive timeout as SERIO_TIMEOUT and parity as
> SERIO_PARITY.
Yes, this can be passed via flags in setio_interrpt. I'll add this.
>
>> +             if (intr_status & PS2_LSTS_ACKERR)
>> +                     dev_info(drvdata->dev, "PS/2 Acknowledge Error!\n");
>
> When is this error signalled?
this is signaled when ACK is not received after data transmitted.

>
>> +             if (intr_status & PS2_LSTS_PARERR)
>> +                     dev_info(drvdata->dev, "PS/2 Parity Error!\n");
>> +             if (intr_status & PS2_LSTS_TXTDO)
>> +                     dev_info(drvdata->dev, "PS/2 Transmit Data Timeout!\n");
>
> Should not you check this status in serio_write() instead of here?
I never get transmit data timeout in serio_write(), even if PS2
keyboard is not connected.
However, it generates this interrupt.
Yes, in case of timeout/failure in serio_write SERIO_TIMEOUT can be returned.
>
>> +             if (intr_status & PS2_LSTS_RXTDO)
>> +                     dev_info(drvdata->dev, "PS/2 Receive Data Timeout!\n");
>> +
>> +             /*reset PS/2 controller*/
>> +             rval = readl(drvdata->reg_base + PS2_REG_GCTL);
>> +             writel(rval | PS2_GCTL_RESET, drvdata->reg_base + PS2_REG_GCTL);
>
> Why do we need to reset controller in case of, let's say, parity glitch?
As per the Reference Manual :
Setting SOFT RESET bit will reset transmitter and receiver of PS2
Module, and the status of transmitter and receiver will revert
to the default state, but not affect any control bits in register,
and data in TXFIFO/RXFIFO.

I think, there is no harm in soft resetting PS2 instead of writing to
multiple registers.
>
>> +
>> +             rval = PS2_LSTS_TXTDO | PS2_LSTS_STOPERR | PS2_LSTS_ACKERR |
>> +                     PS2_LSTS_PARERR | PS2_LSTS_RXTDO;
>> +             writel(rval, drvdata->reg_base + PS2_REG_LSTS);
>> +             error = 1;
>> +     }
>> +
>> +     /*Check FIFO Status Register*/
>> +     if (fifo_status & PS2_FIFO_ERROR_BIT) {
>> +             if (fifo_status & PS2_FSTS_TXUF)
>> +                     dev_info(drvdata->dev, "PS/2 Tx FIFO Underflow!\n");
>> +             if (fifo_status & PS2_FSTS_TXOF)
>> +                     dev_info(drvdata->dev, "PS/2 Tx FIFO Overflow!\n");
>> +             if (fifo_status & PS2_FSTS_RXUF)
>> +                     dev_info(drvdata->dev, "PS/2 Rx FIFO Underflow!\n");
>> +             if (fifo_status & PS2_FSTS_RXOF)
>> +                     dev_info(drvdata->dev, "PS/2 Rx FIFO Overflow!\n");
>> +             /*reset PS/2 controller*/
>> +             writel(readl(drvdata->reg_base + PS2_REG_GCTL) | PS2_GCTL_RESET,
>> +                     drvdata->reg_base + PS2_REG_GCTL);
>
> Again, we do we need to reset controller? Does it stop receiving data
> after RX overflow condition?
After RX overflow it just set the overflow flag in FSTS reg, then we
can reset FIFO to get more data.

>
>> +
>> +             rval = PS2_FSTS_TXUF | PS2_FSTS_TXOF | PS2_FSTS_TXRDY |
>> +                     PS2_FSTS_RXUF | PS2_FSTS_RXOF | PS2_FSTS_RXRDY;
>> +             writel(rval, drvdata->reg_base + PS2_REG_FSTS);
>> +             error = 1;
>> +     }
>> +
>> +     rval = (fifo_status >> 16) & 0x3;
>> +     while (!error && rval--) {
>> +             byte = readl(drvdata->reg_base + PS2_REG_DATA) & 0xff;
>> +             serio_interrupt(drvdata->serio, byte, 0);
>> +     }
>> +
>> +     writel(intr_status, drvdata->reg_base + PS2_REG_LSTS);
>> +     writel(fifo_status, drvdata->reg_base + PS2_REG_FSTS);
>> +
>> +     spin_unlock(&drvdata->lock);
>> +
>> +     return IRQ_HANDLED;
>> +}
>> +
>> +
>> +static int sun4i_ps2_open(struct serio *pserio)
>> +{
>> +     struct sun4i_ps2data *drvdata = pserio->port_data;
>> +     u32 src_clk = 0;
>> +     u32 clk_scdf;
>> +     u32 clk_pcdf;
>> +     u32 rval;
>> +     unsigned long flags;
>> +
>> +     /*Set Line Control And Enable Interrupt*/
>> +     rval = PS2_LCTL_TXDTOEN | PS2_LCTL_STOPERREN | PS2_LCTL_ACKERREN
>> +             | PS2_LCTL_PARERREN | PS2_LCTL_RXDTOEN;
>> +     writel(rval, drvdata->reg_base + PS2_REG_LCTL);
>> +
>> +     /*Reset FIFO*/
>> +     rval = PS2_FCTL_TXRST | PS2_FCTL_RXRST | PS2_FCTL_TXUFIEN
>> +             | PS2_FCTL_TXOFIEN | PS2_FCTL_RXUFIEN
>> +             | PS2_FCTL_RXOFIEN | PS2_FCTL_RXRDYIEN;
>> +
>> +     writel(rval, drvdata->reg_base + PS2_REG_FCTL);
>> +
>> +     src_clk = clk_get_rate(drvdata->clk);
>> +     /*Set Clock Divider Register*/
>> +     clk_scdf = DIV_ROUND_UP(src_clk, PS2_SAMPLE_CLK) - 1;
>> +     clk_pcdf = DIV_ROUND_UP(PS2_SAMPLE_CLK, PS2_SCLK) - 1;
>> +     rval = (clk_scdf<<8) | clk_pcdf;
>> +     writel(rval, drvdata->reg_base + PS2_REG_CLKDR);
>> +
>> +
>> +     /*Set Global Control Register*/
>> +     rval = PS2_GCTL_RESET | PS2_GCTL_INTEN | PS2_GCTL_MASTER
>> +             | PS2_GCTL_BUSEN;
>> +
>> +     spin_lock_irqsave(&drvdata->lock, flags);
>> +     writel(rval, drvdata->reg_base + PS2_REG_GCTL);
>> +     spin_unlock_irqrestore(&drvdata->lock, flags);
>> +
>> +     return 0;
>> +}
>> +
>> +static void sun4i_ps2_close(struct serio *pserio)
>> +{
>> +     struct sun4i_ps2data *drvdata = pserio->port_data;
>> +     unsigned long flags;
>> +
>> +     spin_lock_irqsave(&drvdata->lock, flags);
>> +     /* Disable the PS2 interrupts */
>> +     writel(0, drvdata->reg_base + PS2_REG_GCTL);
>> +     spin_unlock_irqrestore(&drvdata->lock, flags);
>
>
> I think you want to add synchronize_irq() here to make sure pending
> interrupt handler runs to completion before you return.
Yes, synchronize_irq()
>
>> +}
>> +
>> +static int sun4i_ps2_write(struct serio *pserio, unsigned char val)
>> +{
>> +     unsigned long expire = jiffies + msecs_to_jiffies(10000);
>> +     struct sun4i_ps2data *drvdata;
>> +
>> +     drvdata = (struct sun4i_ps2data *)pserio->port_data;
>> +
>> +     do {
>> +             if (readl(drvdata->reg_base + PS2_REG_FSTS) & PS2_FSTS_TXRDY) {
>> +                     writel(val, drvdata->reg_base + PS2_REG_DATA);
>> +                     return 0;
>> +             }
>> +     } while (time_before(jiffies, expire));
>> +
>> +     return 0;
>> +}
>> +
>> +static int sun4i_ps2_probe(struct platform_device *pdev)
>> +{
>> +     struct resource *res; /* IO mem resources */
>> +     struct sun4i_ps2data *drvdata;
>> +     struct serio *serio;
>> +     struct device *dev = &pdev->dev;
>> +     unsigned int irq;
>> +     int error;
>> +
>> +     drvdata = devm_kzalloc(dev, sizeof(struct sun4i_ps2data), GFP_KERNEL);
>> +     serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
>> +     if (!drvdata || !serio) {
>> +             error = -ENOMEM;
>> +             goto err_free_mem;
>> +     }
>> +
>> +     spin_lock_init(&drvdata->lock);
>> +
>> +     /* IO */
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     drvdata->reg_base = devm_ioremap_resource(dev, res);
>> +     if (IS_ERR(drvdata->reg_base)) {
>> +             dev_err(dev, "failed to map registers\n");
>> +             error = PTR_ERR(drvdata->reg_base);
>> +             goto err_free_mem;
>> +     }
>> +
>> +     drvdata->clk = devm_clk_get(dev, NULL);
>> +     if (IS_ERR(drvdata->clk)) {
>> +             error = PTR_ERR(drvdata->clk);
>> +             dev_err(dev, "couldn't get clock %d\n", error);
>> +             goto err_free_mem;
>> +     }
>> +
>> +     error = clk_prepare_enable(drvdata->clk);
>> +     if (error) {
>> +             dev_err(dev, "failed to enable clock %d\n", error);
>> +             goto err_free_mem;
>> +     }
>> +
>
> I think you should explicitly prohibit the device generating interrupts
> by writing to PS2_ERG_CTRL here.
Okie.
>
>> +     serio->id.type = SERIO_8042;
>> +     serio->write = sun4i_ps2_write;
>> +     serio->open = sun4i_ps2_open;
>> +     serio->close = sun4i_ps2_close;
>> +     serio->port_data = drvdata;
>> +     serio->dev.parent = dev;
>> +     strlcpy(serio->name, dev_name(dev), sizeof(serio->name));
>> +     strlcpy(serio->phys, dev_name(dev), sizeof(serio->phys));
>> +
>> +     /* Get IRQ for the device */
>> +     irq = platform_get_irq(pdev, 0);
>> +     if (!irq) {
>> +             dev_err(dev, "no IRQ found\n");
>> +             error = -ENXIO;
>> +             goto error_disable_clk;
>> +     }
>> +
>> +     drvdata->irq = irq;
>> +     drvdata->serio = serio;
>> +     drvdata->dev = dev;
>> +     error = devm_request_threaded_irq(dev, drvdata->irq,
>> +             sun4i_ps2_interrupt, NULL, 0, DRIVER_NAME, drvdata);
>> +
>> +     if (error) {
>> +             dev_err(drvdata->dev, "Interrupt alloc failed %d:error:%d\n",
>> +                     drvdata->irq, error);
>> +             goto error_disable_clk;
>> +     }
>> +
>> +     serio_register_port(serio);
>> +     platform_set_drvdata(pdev, drvdata);
>> +
>> +     return 0;       /* success */
>> +
>> +error_disable_clk:
>> +     clk_disable_unprepare(drvdata->clk);
>> +
>> +err_free_mem:
>> +     kfree(serio);
>> +     return error;
>> +}
>> +
>> +static int sun4i_ps2_remove(struct platform_device *pdev)
>> +{
>> +     struct sun4i_ps2data *drvdata = platform_get_drvdata(pdev);
>> +
>> +     serio_unregister_port(drvdata->serio);
>> +     disable_irq(drvdata->irq);
>
> I do not think you need to disable irq here - serio_close will make sure
> that the device does not generate interrupts.
Okie
>
>> +
>> +     if (!IS_ERR(drvdata->clk))
>> +             clk_disable_unprepare(drvdata->clk);
>> +     kfree(drvdata->serio);
>> +
>> +     return 0;
>> +}
>> +
>> +/* Match table for of_platform binding */
>> +static const struct of_device_id sun4i_ps2_match[] = {
>> +     { .compatible = "allwinner,sun4i-a10-ps2", },
>> +     { },
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, sun4i_ps2_match);
>> +
>> +/*platform driver structure*/
>
> I do not think we should keep the obvious comments like this one.
Okie, I'll remove it.
>
>> +static struct platform_driver sun4i_ps2_driver = {
>> +     .probe          = sun4i_ps2_probe,
>> +     .remove         = sun4i_ps2_remove,
>> +     .driver = {
>> +             .name = DRIVER_NAME,
>> +             .of_match_table = sun4i_ps2_match,
>> +     },
>> +};
>> +module_platform_driver(sun4i_ps2_driver);
>> +
>> +MODULE_AUTHOR("Vishnu Patekar <vishnupatekar0510@gmail.com>");
>> +MODULE_AUTHOR("Aaron.maoye <leafy.myeh@newbietech.com>");
>> +MODULE_DESCRIPTION("Allwinner A10/Sun4i PS/2 driver");
>> +MODULE_LICENSE("GPL v2");
>> --
>> 1.7.9.5
>>
>
> Thanks.
>
> --
> Dmitry
