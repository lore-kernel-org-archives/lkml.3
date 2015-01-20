Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752510AbbATAfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 19:35:43 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:55358 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbbATAfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 19:35:41 -0500
Date: Mon, 19 Jan 2015 16:35:36 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Vishnu Patekar <vishnupatekar0510@gmail.com>
Cc: Hans de Goede <hdegoede@redhat.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        "maxime.ripard@free-electrons.com" <maxime.ripard@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sunxi@googlegroups.com" <linux-sunxi@googlegroups.com>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 2/5] ARM:sunxi:drivers:input Add support for A10/A20
 PS2
Message-ID: <20150120003536.GA29820@dtor-glaptop>
References: <1421417021-3247-1-git-send-email-vishnupatekar0510@gmail.com>
 <1421417021-3247-3-git-send-email-vishnupatekar0510@gmail.com>
 <20150117222529.GC38334@dtor-ws>
 <CAEzqOZtOBOdpdUHvRqqf+d5GoR_8gpumZX9hfFntXDOzNog+mQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEzqOZtOBOdpdUHvRqqf+d5GoR_8gpumZX9hfFntXDOzNog+mQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 11:37:38AM +0530, Vishnu Patekar wrote:
> Hello Dmitry,
> 
> Thank you for review comments. Please see in-lined.
> 
> On Sun, Jan 18, 2015 at 3:55 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Vishnu,
> >
> > On Fri, Jan 16, 2015 at 07:33:38PM +0530, Vishnu Patekar wrote:
> >> Signed-off-by: VishnuPatekar <vishnupatekar0510@gmail.com>
> >> ---
> >>  drivers/input/serio/Kconfig     |   11 ++
> >>  drivers/input/serio/Makefile    |    1 +
> >>  drivers/input/serio/sun4i-ps2.c |  330 +++++++++++++++++++++++++++++++++++++++
> >>  3 files changed, 342 insertions(+)
> >>  create mode 100644 drivers/input/serio/sun4i-ps2.c
> >>
> >> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> >> index bc2d474..964afc5 100644
> >> --- a/drivers/input/serio/Kconfig
> >> +++ b/drivers/input/serio/Kconfig
> >> @@ -281,4 +281,15 @@ config HYPERV_KEYBOARD
> >>         To compile this driver as a module, choose M here: the module will
> >>         be called hyperv_keyboard.
> >>
> >> +config SERIO_SUN4I_PS2
> >> +     tristate "Allwinner A10 PS/2 controller support"
> >> +     default n
> >> +     depends on ARCH_SUNXI || COMPILE_TEST
> >> +     help
> >> +       This selects support for the PS/2 Host Controller on
> >> +       Allwinner A10.
> >> +
> >> +       To compile this driver as a module, choose M here: the
> >> +       module will be called sun4i-ps2.
> >> +
> >>  endif
> >> diff --git a/drivers/input/serio/Makefile b/drivers/input/serio/Makefile
> >> index 815d874..c600089 100644
> >> --- a/drivers/input/serio/Makefile
> >> +++ b/drivers/input/serio/Makefile
> >> @@ -29,3 +29,4 @@ obj-$(CONFIG_SERIO_ARC_PS2) += arc_ps2.o
> >>  obj-$(CONFIG_SERIO_APBPS2)   += apbps2.o
> >>  obj-$(CONFIG_SERIO_OLPC_APSP)        += olpc_apsp.o
> >>  obj-$(CONFIG_HYPERV_KEYBOARD)        += hyperv-keyboard.o
> >> +obj-$(CONFIG_SERIO_SUN4I_PS2)        += sun4i-ps2.o
> >> diff --git a/drivers/input/serio/sun4i-ps2.c b/drivers/input/serio/sun4i-ps2.c
> >> new file mode 100644
> >> index 0000000..06b3fef
> >> --- /dev/null
> >> +++ b/drivers/input/serio/sun4i-ps2.c
> >> @@ -0,0 +1,330 @@
> >> +/*
> >> + *   Driver for Allwinner A10 PS2 host controller
> >> + *
> >> + *   Author: Vishnu Patekar <vishnupatekar0510@gmail.com>
> >> + *           Aaron.maoye <leafy.myeh@newbietech.com>
> >> + *
> >> + *
> >> + */
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/serio.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/errno.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/list.h>
> >> +#include <linux/io.h>
> >> +#include <linux/of_address.h>
> >> +#include <linux/of_device.h>
> >> +#include <linux/of_irq.h>
> >> +#include <linux/of_platform.h>
> >> +#include <linux/clk.h>
> >> +#include <linux/delay.h>
> >> +
> >> +#define DRIVER_NAME          "sun4i-ps2"
> >> +
> >> +/* register offset definitions */
> >> +#define PS2_REG_GCTL         0x00    /*  PS2 Module Global Control Reg */
> >> +#define PS2_REG_DATA         0x04    /*  PS2 Module Data Reg         */
> >> +#define PS2_REG_LCTL         0x08    /*  PS2 Module Line Control Reg */
> >> +#define PS2_REG_LSTS         0x0C    /*  PS2 Module Line Status Reg  */
> >> +#define PS2_REG_FCTL         0x10    /*  PS2 Module FIFO Control Reg */
> >> +#define PS2_REG_FSTS         0x14    /*  PS2 Module FIFO Status Reg  */
> >> +#define PS2_REG_CLKDR                0x18    /*  PS2 Module Clock Divider Reg*/
> >> +
> >> +/*  PS2 GLOBAL CONTROL REGISTER PS2_GCTL */
> >> +#define PS2_GCTL_INTFLAG     BIT(4)
> >> +#define PS2_GCTL_INTEN               BIT(3)
> >> +#define PS2_GCTL_RESET               BIT(2)
> >> +#define PS2_GCTL_MASTER              BIT(1)
> >> +#define PS2_GCTL_BUSEN               BIT(0)
> >> +
> >> +/* PS2 LINE CONTROL REGISTER */
> >> +#define PS2_LCTL_NOACK               BIT(18)
> >> +#define PS2_LCTL_TXDTOEN     BIT(8)
> >> +#define PS2_LCTL_STOPERREN   BIT(3)
> >> +#define PS2_LCTL_ACKERREN    BIT(2)
> >> +#define PS2_LCTL_PARERREN    BIT(1)
> >> +#define PS2_LCTL_RXDTOEN     BIT(0)
> >> +
> >> +/* PS2 LINE STATUS REGISTER */
> >> +#define PS2_LSTS_TXTDO               BIT(8)
> >> +#define PS2_LSTS_STOPERR     BIT(3)
> >> +#define PS2_LSTS_ACKERR              BIT(2)
> >> +#define PS2_LSTS_PARERR              BIT(1)
> >> +#define PS2_LSTS_RXTDO               BIT(0)
> >> +
> >> +#define PS2_LINE_ERROR_BIT \
> >> +     (PS2_LSTS_TXTDO | PS2_LSTS_STOPERR | PS2_LSTS_ACKERR | \
> >> +     PS2_LSTS_PARERR | PS2_LSTS_RXTDO)
> >> +
> >> +/* PS2 FIFO CONTROL REGISTER */
> >> +#define PS2_FCTL_TXRST               BIT(17)
> >> +#define PS2_FCTL_RXRST               BIT(16)
> >> +#define PS2_FCTL_TXUFIEN     BIT(10)
> >> +#define PS2_FCTL_TXOFIEN     BIT(9)
> >> +#define PS2_FCTL_TXRDYIEN    BIT(8)
> >> +#define PS2_FCTL_RXUFIEN     BIT(2)
> >> +#define PS2_FCTL_RXOFIEN     BIT(1)
> >> +#define PS2_FCTL_RXRDYIEN    BIT(0)
> >> +
> >> +/* PS2 FIFO STATUS REGISTER */
> >> +#define PS2_FSTS_TXUF                BIT(10)
> >> +#define PS2_FSTS_TXOF                BIT(9)
> >> +#define PS2_FSTS_TXRDY               BIT(8)
> >> +#define PS2_FSTS_RXUF                BIT(2)
> >> +#define PS2_FSTS_RXOF                BIT(1)
> >> +#define PS2_FSTS_RXRDY               BIT(0)
> >> +
> >> +#define PS2_FIFO_ERROR_BIT \
> >> +     (PS2_FSTS_TXUF | PS2_FSTS_TXOF | PS2_FSTS_RXUF | PS2_FSTS_RXOF)
> >> +
> >> +#define PS2_SAMPLE_CLK               1000000
> >> +#define PS2_SCLK             125000
> >> +
> >> +struct sun4i_ps2data {
> >> +     struct serio *serio;
> >> +     struct device *dev;
> >> +
> >> +     /* IO mapping base */
> >> +     void __iomem    *reg_base;
> >> +
> >> +     /* clock management */
> >> +     struct clk      *clk;
> >> +
> >> +     /* irq */
> >> +     spinlock_t      lock;
> >> +     int             irq;
> >> +};
> >> +
> >> +/*********************/
> >> +/* Interrupt handler */
> >> +/*********************/
> >> +static irqreturn_t sun4i_ps2_interrupt(int irq, void *dev_id)
> >> +{
> >> +     struct sun4i_ps2data *drvdata = dev_id;
> >> +     u32 intr_status;
> >> +     u32 fifo_status;
> >> +     unsigned char byte;
> >> +     unsigned int rxflags = 0;
> >> +     u32 rval;
> >> +
> >> +     spin_lock(&drvdata->lock);
> >> +
> >> +     /* Get the PS/2 interrupts and clear them */
> >> +     intr_status  = readl(drvdata->reg_base + PS2_REG_LSTS);
> >> +     fifo_status  = readl(drvdata->reg_base + PS2_REG_FSTS);
> >> +
> >> +     /*Check Line Status Register*/
> >> +     if (intr_status & PS2_LINE_ERROR_BIT) {
> >> +             rxflags = (intr_status & PS2_LINE_ERROR_BIT) ? SERIO_FRAME : 0;
> >> +             rxflags |= (intr_status & PS2_LSTS_PARERR) ? SERIO_PARITY : 0;
> >> +             rxflags |= (intr_status & PS2_LSTS_PARERR) ? SERIO_TIMEOUT : 0;
> >> +
> >> +             rval = PS2_LSTS_TXTDO | PS2_LSTS_STOPERR | PS2_LSTS_ACKERR |
> >> +                     PS2_LSTS_PARERR | PS2_LSTS_RXTDO;
> >> +             writel(rval, drvdata->reg_base + PS2_REG_LSTS);
> >> +     }
> >> +
> >> +     /*Check FIFO Status Register*/
> >> +     if (fifo_status & PS2_FIFO_ERROR_BIT) {
> >> +             rval = PS2_FSTS_TXUF | PS2_FSTS_TXOF | PS2_FSTS_TXRDY |
> >> +                     PS2_FSTS_RXUF | PS2_FSTS_RXOF | PS2_FSTS_RXRDY;
> >> +             writel(rval, drvdata->reg_base + PS2_REG_FSTS);
> >> +     }
> >> +
> >> +     rval = (fifo_status >> 16) & 0x3;
> >> +     while (rval--) {
> >> +             byte = readl(drvdata->reg_base + PS2_REG_DATA) & 0xff;
> >> +             serio_interrupt(drvdata->serio, byte, rxflags);
> >> +     }
> >> +
> >> +     writel(intr_status, drvdata->reg_base + PS2_REG_LSTS);
> >> +     writel(fifo_status, drvdata->reg_base + PS2_REG_FSTS);
> >> +
> >> +     spin_unlock(&drvdata->lock);
> >> +
> >> +     return IRQ_HANDLED;
> >> +}
> >> +
> >> +
> >> +static int sun4i_ps2_open(struct serio *pserio)
> >> +{
> >> +     struct sun4i_ps2data *drvdata = pserio->port_data;
> >> +     u32 src_clk = 0;
> >> +     u32 clk_scdf;
> >> +     u32 clk_pcdf;
> >> +     u32 rval;
> >> +     unsigned long flags;
> >> +
> >> +     /*Set Line Control And Enable Interrupt*/
> >> +     rval = PS2_LCTL_STOPERREN | PS2_LCTL_ACKERREN
> >> +             | PS2_LCTL_PARERREN | PS2_LCTL_RXDTOEN;
> >> +     writel(rval, drvdata->reg_base + PS2_REG_LCTL);
> >> +
> >> +     /*Reset FIFO*/
> >> +     rval = PS2_FCTL_TXRST | PS2_FCTL_RXRST | PS2_FCTL_TXUFIEN
> >> +             | PS2_FCTL_TXOFIEN | PS2_FCTL_RXUFIEN
> >> +             | PS2_FCTL_RXOFIEN | PS2_FCTL_RXRDYIEN;
> >> +
> >> +     writel(rval, drvdata->reg_base + PS2_REG_FCTL);
> >> +
> >> +     src_clk = clk_get_rate(drvdata->clk);
> >> +     /*Set Clock Divider Register*/
> >> +     clk_scdf = src_clk / PS2_SAMPLE_CLK - 1;
> >> +     clk_pcdf = PS2_SAMPLE_CLK / PS2_SCLK - 1;
> >> +     rval = (clk_scdf<<8) | clk_pcdf;
> >> +     writel(rval, drvdata->reg_base + PS2_REG_CLKDR);
> >> +
> >> +
> >> +     /*Set Global Control Register*/
> >> +     rval = PS2_GCTL_RESET | PS2_GCTL_INTEN | PS2_GCTL_MASTER
> >> +             | PS2_GCTL_BUSEN;
> >> +
> >> +     spin_lock_irqsave(&drvdata->lock, flags);
> >> +     writel(rval, drvdata->reg_base + PS2_REG_GCTL);
> >> +     spin_unlock_irqrestore(&drvdata->lock, flags);
> >> +
> >> +     return 0;
> >> +}
> >> +
> >> +static void sun4i_ps2_close(struct serio *pserio)
> >> +{
> >> +     struct sun4i_ps2data *drvdata = pserio->port_data;
> >> +
> >> +     synchronize_irq(drvdata->irq);
> >
> > synchronize_irq() on it's own is not very useful. You also need to shut
> > off interrupts on the chip (I suppose by clearing PS2_GCTL_INTEN?)
> > before calling synchronize_irq.
> Okie, I'll do it. Yes, clearing PS2_GCTL_INTEN will shut off the interrupts.

Please also do shut off interrupts on the chip before requesting IRQ.

> >
> >> +}
> >> +
> >> +static int sun4i_ps2_write(struct serio *pserio, unsigned char val)
> >> +{
> >> +     unsigned long expire = jiffies + msecs_to_jiffies(10000);
> >> +     struct sun4i_ps2data *drvdata;
> >> +
> >> +     drvdata = (struct sun4i_ps2data *)pserio->port_data;
> >> +
> >> +     do {
> >> +             if (readl(drvdata->reg_base + PS2_REG_FSTS) & PS2_FSTS_TXRDY) {
> >> +                     writel(val, drvdata->reg_base + PS2_REG_DATA);
> >> +                     return 0;
> >> +             }
> >> +     } while (time_before(jiffies, expire));
> >> +
> >> +     return SERIO_TIMEOUT;
> >> +}
> >> +
> >> +static int sun4i_ps2_probe(struct platform_device *pdev)
> >> +{
> >> +     struct resource *res; /* IO mem resources */
> >> +     struct sun4i_ps2data *drvdata;
> >> +     struct serio *serio;
> >> +     struct device *dev = &pdev->dev;
> >> +     unsigned int irq;
> >> +     int error;
> >> +
> >> +     drvdata = devm_kzalloc(dev, sizeof(struct sun4i_ps2data), GFP_KERNEL);
> >> +     serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
> >> +     if (!drvdata || !serio) {
> >> +             error = -ENOMEM;
> >> +             goto err_free_mem;
> >> +     }
> >> +
> >> +     spin_lock_init(&drvdata->lock);
> >> +
> >> +     /* IO */
> >> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> >> +     drvdata->reg_base = devm_ioremap_resource(dev, res);
> >> +     if (IS_ERR(drvdata->reg_base)) {
> >> +             dev_err(dev, "failed to map registers\n");
> >> +             error = PTR_ERR(drvdata->reg_base);
> >> +             goto err_free_mem;
> >> +     }
> >> +
> >> +     drvdata->clk = devm_clk_get(dev, NULL);
> >> +     if (IS_ERR(drvdata->clk)) {
> >> +             error = PTR_ERR(drvdata->clk);
> >> +             dev_err(dev, "couldn't get clock %d\n", error);
> >> +             goto err_free_mem;
> >> +     }
> >> +
> >> +     error = clk_prepare_enable(drvdata->clk);
> >> +     if (error) {
> >> +             dev_err(dev, "failed to enable clock %d\n", error);
> >> +             goto err_free_mem;
> >> +     }
> >> +
> >> +     serio->id.type = SERIO_8042;
> >> +     serio->write = sun4i_ps2_write;
> >> +     serio->open = sun4i_ps2_open;
> >> +     serio->close = sun4i_ps2_close;
> >> +     serio->port_data = drvdata;
> >> +     serio->dev.parent = dev;
> >> +     strlcpy(serio->name, dev_name(dev), sizeof(serio->name));
> >> +     strlcpy(serio->phys, dev_name(dev), sizeof(serio->phys));
> >> +
> >> +     /* Get IRQ for the device */
> >> +     irq = platform_get_irq(pdev, 0);
> >> +     if (!irq) {
> >> +             dev_err(dev, "no IRQ found\n");
> >> +             error = -ENXIO;
> >> +             goto error_disable_clk;
> >> +     }
> >> +
> >> +     drvdata->irq = irq;
> >> +     drvdata->serio = serio;
> >> +     drvdata->dev = dev;
> >> +     error = devm_request_threaded_irq(dev, drvdata->irq,
> >> +             sun4i_ps2_interrupt, NULL, 0, DRIVER_NAME, drvdata);
> >> +
> >> +     if (error) {
> >> +             dev_err(drvdata->dev, "Interrupt alloc failed %d:error:%d\n",
> >> +                     drvdata->irq, error);
> >> +             goto error_disable_clk;
> >> +     }
> >> +
> >> +     serio_register_port(serio);
> >> +     platform_set_drvdata(pdev, drvdata);
> >> +
> >> +     return 0;       /* success */
> >> +
> >> +error_disable_clk:
> >> +     clk_disable_unprepare(drvdata->clk);
> >> +
> >> +err_free_mem:
> >> +     kfree(serio);
> >> +     return error;
> >> +}
> >> +
> >> +static int sun4i_ps2_remove(struct platform_device *pdev)
> >> +{
> >> +     struct sun4i_ps2data *drvdata = platform_get_drvdata(pdev);
> >> +
> >> +     serio_unregister_port(drvdata->serio);
> >> +
> >> +     if (!IS_ERR(drvdata->clk))
> >> +             clk_disable_unprepare(drvdata->clk);
> >> +     kfree(drvdata->serio);
> >
> > Serio is refcounted, you do not free it after its has been registered.
> > Overall I'd rather you did not use devm* interfaces here since you are
> > forced to mix managed and manually freed resources.
> Okie, No need to free serio here.
> If serio is not manually freed here, It is not freeing anything else manually.

You are still unregistering the port manually and disabling the clock manually.
> 
> do you still feel I should not use devm* interfaces here?

Yes, because of above. My rule of thumb - when using devm* API there should not
be remove() at all.

BTW, if one added devm_* API to serio, similar to devm* in input core, I'd take
such patch.

Thanks.

-- 
Dmitry
