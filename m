Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbaAJKaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:30:06 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:39764 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbaAJKaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:30:03 -0500
Message-ID: <52CFCBA2.9010705@mev.co.uk>
Date: Fri, 10 Jan 2014 10:29:54 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Rostislav Lisovy <lisovy@gmail.com>, Ian Abbott <ian.abbott@mev.co.uk>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: "pisa@cmp.felk.cvut.cz" <pisa@cmp.felk.cvut.cz>
Subject: Re: [PATCH] comedi: Humusoft MF634 and MF624 DAQ cards driver
References: <1389307606-6392-1-git-send-email-lisovy@gmail.com> <1389307606-6392-2-git-send-email-lisovy@gmail.com>
In-Reply-To: <1389307606-6392-2-git-send-email-lisovy@gmail.com>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-09 22:46, Rostislav Lisovy wrote:
> This patch adds Comedi driver for Humusoft MF634 (PCIe) and
> MF624 (PCI) data acquisition cards. The legacy card Humusoft
> MF614 is not supported. More info about the cards may be found
> at http://humusoft.cz/produkty/datacq/
> The driver was tested with both cards. Everything seems to work
> properly. Just the basic functionality of the card (DIO, ADC, DAC)
> is supported by this driver.
>
> Signed-off-by: Rostislav Lisovy <lisovy@gmail.com>
> ---
>   create mode 100644 drivers/staging/comedi/drivers/mf6x4.c
>
> diff --git a/drivers/staging/comedi/Kconfig b/drivers/staging/comedi/Kconfig
> index bfa27e7..89e25b4 100644
> --- a/drivers/staging/comedi/Kconfig
> +++ b/drivers/staging/comedi/Kconfig
> @@ -884,6 +884,12 @@ config COMEDI_GSC_HPDI
>            To compile this driver as a module, choose M here: the module will be
>            called gsc_hpdi.
>
> +config COMEDI_MF6X4
> +       tristate "Humusoft MF634 and MF624 DAQ Card support"
> +       ---help---
> +         This driver supports both Humusoft MF634 and MF624 Data acquisition
> +         cards. The legacy Humusoft MF614 card is not supported.
> +
>   config COMEDI_ICP_MULTI
>          tristate "Inova ICP_MULTI support"
>          ---help---
> diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
> index 143be80..161bdd2 100644
> --- a/drivers/staging/comedi/comedidev.h
> +++ b/drivers/staging/comedi/comedidev.h
> @@ -410,6 +410,7 @@ void comedi_driver_unregister(struct comedi_driver *);
>   #define PCI_VENDOR_ID_IOTECH           0x1616
>   #define PCI_VENDOR_ID_CONTEC           0x1221
>   #define PCI_VENDOR_ID_RTD              0x1435
> +#define PCI_VENDOR_ID_HUMUSOFT         0x186c
>
>   struct pci_dev;
>   struct pci_driver;
> diff --git a/drivers/staging/comedi/drivers/Makefile b/drivers/staging/comedi/drivers/Makefile
> index 94cbd26..9e979a9 100644
> --- a/drivers/staging/comedi/drivers/Makefile
> +++ b/drivers/staging/comedi/drivers/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_COMEDI_NI_PCIMIO)              += ni_pcimio.o
>   obj-$(CONFIG_COMEDI_RTD520)            += rtd520.o
>   obj-$(CONFIG_COMEDI_S626)              += s626.o
>   obj-$(CONFIG_COMEDI_SSV_DNP)           += ssv_dnp.o
> +obj-$(CONFIG_COMEDI_MF6X4)             += mf6x4.o
>
>   # Comedi PCMCIA drivers
>   obj-$(CONFIG_COMEDI_CB_DAS16_CS)       += cb_das16_cs.o
> diff --git a/drivers/staging/comedi/drivers/mf6x4.c b/drivers/staging/comedi/drivers/mf6x4.c
> new file mode 100644
> index 0000000..81b78e0
> --- /dev/null
> +++ b/drivers/staging/comedi/drivers/mf6x4.c
> @@ -0,0 +1,354 @@
> +/*
> + *  comedi/drivers/mf6x4.c
> + *  Driver for Humusoft MF634 and MF624 Data acquisition cards
> + *
> + *  COMEDI - Linux Control and Measurement Device Interface
> + *  Copyright (C) 2000 David A. Schleef <ds@schleef.org>
> + *
> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + *  This program is distributed in the hope that it will be useful,
> + *  but WITHOUT ANY WARRANTY; without even the implied warranty of
> + *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + *  GNU General Public License for more details.
> + */
> +/*
> + * Driver: mf6x4
> + * Description: Humusoft MF634 and MF624 Data acquisition card driver
> + * Devices: Humusoft MF634, Humusoft MF624
> + * Author: Rostislav Lisovy <lisovy@gmail.com>
> + * Status: works
> + * Updated:
> + * Configuration Options: none
> + */
> +
> +#include <linux/module.h>
> +#include <linux/pci.h>
> +#include <linux/delay.h>
> +#include "../comedidev.h"
> +
> +/* Registers present in BAR0 memory region */
> +#define MF624_GPIOC_R                                  0x54
> +
> +#define MF6X4_GPIOC_EOLC /* End Of Last Conversion */  (1 << 17)
> +#define MF6X4_GPIOC_LDAC /* Load DACs */               (1 << 23)
> +#define MF6X4_GPIOC_DACEN                              (1 << 26)
> +
> +/* BAR1 registers */
> +#define MF6X4_DIN_R                                    0x10
> +#define MF6X4_DIN_M                                    0xff
> +#define MF6X4_DOUT_R                                   0x10
> +#define MF6X4_DOUT_M                                   0xff
> +
> +#define MF6X4_ADSTART_R                                        0x20
> +#define MF6X4_ADDATA_R                                 0x00
> +#define MF6X4_ADCTRL_R                                 0x00
> +#define MF6X4_ADCTRL_M                                 0xff
> +
> +#define MF6X4_DA0_R                                    0x20
> +#define MF6X4_DA1_R                                    0x22
> +#define MF6X4_DA2_R                                    0x24
> +#define MF6X4_DA3_R                                    0x26
> +#define MF6X4_DA4_R                                    0x28
> +#define MF6X4_DA5_R                                    0x2a
> +#define MF6X4_DA6_R                                    0x2c
> +#define MF6X4_DA7_R                                    0x2e
> +/* Map DAC cahnnel id to real HW-dependent offset value */
> +#define MF6X4_DAC_R(x)                                 (0x20 + ((x) * 2))
> +#define MF6X4_DA_M                                     0x3fff
> +
> +/* BAR2 registers */
> +#define MF634_GPIOC_R                                  0x68
> +
> +enum mf6x4_boardid {
> +       BOARD_MF634,
> +       BOARD_MF624,
> +};
> +
> +struct mf6x4_board {
> +       const char *name;
> +       unsigned int bar_nums[3]; /* We need to keep track of the
> +                                    order of BARs used by the cards */
> +};
> +
> +static const struct mf6x4_board mf6x4_boards[] = {
> +       [BOARD_MF634] = {
> +               .name           = "mf634",
> +               .bar_nums       = {0, 2, 3},
> +       },
> +       [BOARD_MF624] = {
> +               .name           = "mf624",
> +               .bar_nums       = {0, 2, 4},
> +       },
> +};
> +
> +struct mf6x4_private {
> +       /*
> +        * Documentation for both MF634 and MF624 describes registers
> +        * present in BAR0, 1 and 2 regions.
> +        * The real (i.e. in HW) BAR numbers are different for MF624
> +        * and MF634 yet we will call them 0, 1, 2
> +        */
> +       void __iomem *bar0_mem;
> +       void __iomem *bar1_mem;
> +       void __iomem *bar2_mem;
> +
> +       /*
> +        * This configuration register has the same function and fields
> +        * for both cards however it lies in different BARs on different
> +        * offsets -- this variable makes the access easier
> +        */
> +       void __iomem *gpioc_R;
> +
> +       /* DAC value cache -- used for insn_read function */
> +       int ao_readback[8];
> +};
> +
> +static int mf6x4_di_insn_bits(struct comedi_device *dev,
> +                              struct comedi_subdevice *s,
> +                              struct comedi_insn *insn, unsigned int *data)
> +{
> +       struct mf6x4_private *devpriv = dev->private;
> +
> +       data[1] = ioread16(devpriv->bar1_mem + MF6X4_DIN_R) & MF6X4_DIN_M;
> +
> +       return insn->n;
> +}
> +
> +static int mf6x4_do_insn_bits(struct comedi_device *dev,
> +                              struct comedi_subdevice *s,
> +                              struct comedi_insn *insn, unsigned int *data)
> +{
> +       struct mf6x4_private *devpriv = dev->private;
> +
> +       if (comedi_dio_update_state(s, data))
> +               iowrite16(s->state & MF6X4_DOUT_M,
> +                         devpriv->bar1_mem + MF6X4_DOUT_R);
> +
> +       data[1] = s->state;
> +
> +       return insn->n;
> +}
> +
> +static int mf6x4_ai_wait_for_eoc(struct comedi_device *dev,
> +                                unsigned int timeout)
> +{
> +       struct mf6x4_private *devpriv = dev->private;
> +       unsigned int eolc;
> +
> +       while (timeout--) {
> +               eolc = ioread32(devpriv->gpioc_R) & MF6X4_GPIOC_EOLC;
> +               if (eolc)
> +                       return 0;
> +
> +               udelay(1);
> +       }
> +
> +       return -ETIME;
> +}
> +
> +static int mf6x4_ai_insn_read(struct comedi_device *dev,
> +                             struct comedi_subdevice *s,
> +                             struct comedi_insn *insn, unsigned int *data)
> +{
> +       struct mf6x4_private *devpriv = dev->private;
> +       int chan = CR_CHAN(insn->chanspec);
> +       int ret;
> +       int i;
> +       int d;
> +
> +       /* Set the ADC channel number in the scan list */
> +       iowrite16((1 << chan) & MF6X4_ADCTRL_M,
> +                 devpriv->bar1_mem + MF6X4_ADCTRL_R);
> +
> +       for (i = 0; i < insn->n; i++) {
> +               /* Trigger ADC conversion by reading ADSTART */
> +               ioread16(devpriv->bar1_mem + MF6X4_ADSTART_R);
> +
> +               ret = mf6x4_ai_wait_for_eoc(dev, 100);
> +               if (ret)
> +                       return ret;
> +
> +               /* Read the actual value */
> +               d = ioread16(devpriv->bar1_mem + MF6X4_ADDATA_R);
> +               d &= s->maxdata;
> +               data[i] = d;
> +       }
> +
> +       iowrite16(0x0, devpriv->bar1_mem + MF6X4_ADCTRL_R);
> +
> +       return insn->n;
> +}
> +
> +static int mf6x4_ao_insn_write(struct comedi_device *dev,
> +                              struct comedi_subdevice *s,
> +                              struct comedi_insn *insn, unsigned int *data)
> +{
> +       struct mf6x4_private *devpriv = dev->private;
> +       unsigned int chan = CR_CHAN(insn->chanspec);
> +       uint32_t gpioc;
> +       int i;
> +
> +       /* Enable instantaneous update of converters outputs + Enable DACs */
> +       gpioc = ioread32(devpriv->gpioc_R);
> +       iowrite32((gpioc & ~MF6X4_GPIOC_LDAC) | MF6X4_GPIOC_DACEN,
> +                 devpriv->gpioc_R);
> +
> +       for (i = 0; i < insn->n; i++) {
> +               iowrite16(data[i] & MF6X4_DA_M,
> +                         devpriv->bar1_mem + MF6X4_DAC_R(chan));
> +
> +               devpriv->ao_readback[chan] = data[i];
> +       }
> +
> +       return insn->n;
> +}
> +
> +static int mf6x4_ao_insn_read(struct comedi_device *dev,
> +                             struct comedi_subdevice *s,
> +                             struct comedi_insn *insn, unsigned int *data)
> +{
> +       struct mf6x4_private *devpriv = dev->private;
> +       unsigned int chan = CR_CHAN(insn->chanspec);
> +       int i;
> +
> +       for (i = 0; i < insn->n; i++)
> +               data[i] = devpriv->ao_readback[chan];
> +
> +       return insn->n;
> +}
> +
> +static int mf6x4_auto_attach(struct comedi_device *dev, unsigned long context)
> +{
> +       struct pci_dev *pcidev = comedi_to_pci_dev(dev);
> +       const struct mf6x4_board *board = NULL;
> +       struct mf6x4_private *devpriv;
> +       struct comedi_subdevice *s;
> +       int ret;
> +
> +       if (context < ARRAY_SIZE(mf6x4_boards))
> +               board = &mf6x4_boards[context];
> +       else
> +               return -ENODEV;
> +
> +       dev->board_ptr = board;
> +       dev->board_name = board->name;
> +
> +       ret = comedi_pci_enable(dev);
> +       if (ret)
> +               return ret;
> +
> +       devpriv = comedi_alloc_devpriv(dev, sizeof(*devpriv));
> +       if (!devpriv)
> +               return -ENOMEM;
> +
> +       devpriv->bar0_mem = pci_ioremap_bar(pcidev, board->bar_nums[0]);
> +       if (!devpriv->bar0_mem)
> +               return -ENODEV;
> +
> +       devpriv->bar1_mem = pci_ioremap_bar(pcidev, board->bar_nums[1]);
> +       if (!devpriv->bar1_mem)
> +               return -ENODEV;
> +
> +       devpriv->bar2_mem = pci_ioremap_bar(pcidev, board->bar_nums[2]);
> +       if (!devpriv->bar2_mem)
> +               return -ENODEV;
> +
> +       if (board == &mf6x4_boards[BOARD_MF634])
> +               devpriv->gpioc_R = devpriv->bar2_mem + MF634_GPIOC_R;
> +       else
> +               devpriv->gpioc_R = devpriv->bar0_mem + MF624_GPIOC_R;
> +
> +
> +       ret = comedi_alloc_subdevices(dev, 4);
> +       if (ret)
> +               return ret;
> +
> +       /* ADC */
> +       s = &dev->subdevices[0];
> +       s->type = COMEDI_SUBD_AI;
> +       s->subdev_flags = SDF_READABLE | SDF_GROUND;
> +       s->n_chan = 8;
> +       s->maxdata = 0x3fff; /* 14 bits ADC */
> +       s->range_table = &range_bipolar10;
> +       s->insn_read = mf6x4_ai_insn_read;
> +
> +       /* DAC */
> +       s = &dev->subdevices[1];
> +       s->type = COMEDI_SUBD_AO;
> +       s->subdev_flags = SDF_WRITABLE;
> +       s->n_chan = 8;
> +       s->maxdata = 0x3fff; /* 14 bits DAC */
> +       s->range_table = &range_bipolar10;
> +       s->insn_write = mf6x4_ao_insn_write;
> +       s->insn_read = mf6x4_ao_insn_read;
> +
> +       /* DIN */
> +       s = &dev->subdevices[2];
> +       s->type = COMEDI_SUBD_DI;
> +       s->subdev_flags = SDF_READABLE;
> +       s->n_chan = 8;
> +       s->maxdata = 1;
> +       s->range_table = &range_digital;
> +       s->insn_bits = mf6x4_di_insn_bits;
> +
> +       /* DOUT */
> +       s = &dev->subdevices[3];
> +       s->type = COMEDI_SUBD_DO;
> +       s->subdev_flags = SDF_WRITABLE;
> +       s->n_chan = 8;
> +       s->maxdata = 1;
> +       s->range_table = &range_digital;
> +       s->insn_bits = mf6x4_do_insn_bits;
> +
> +       return 0;
> +}
> +
> +static void mf6x4_detach(struct comedi_device *dev)
> +{
> +       struct mf6x4_private *devpriv = dev->private;
> +
> +       if (devpriv->bar0_mem)
> +               iounmap(devpriv->bar0_mem);
> +       if (devpriv->bar1_mem)
> +               iounmap(devpriv->bar1_mem);
> +       if (devpriv->bar2_mem)
> +               iounmap(devpriv->bar2_mem);
> +
> +       comedi_pci_disable(dev);
> +}
> +
> +static struct comedi_driver mf6x4_driver = {
> +       .driver_name    = "mf6x4",
> +       .module         = THIS_MODULE,
> +       .auto_attach    = mf6x4_auto_attach,
> +       .detach         = mf6x4_detach,
> +};
> +
> +static int mf6x4_pci_probe(struct pci_dev *dev, const struct pci_device_id *id)
> +{
> +       return comedi_pci_auto_config(dev, &mf6x4_driver, id->driver_data);
> +}
> +
> +static const struct pci_device_id mf6x4_pci_table[] = {
> +       { PCI_VDEVICE(HUMUSOFT, 0x0634), BOARD_MF634 },
> +       { PCI_VDEVICE(HUMUSOFT, 0x0624), BOARD_MF624 },
> +       { 0 }
> +};
> +MODULE_DEVICE_TABLE(pci, mf6x4_pci_table);
> +
> +static struct pci_driver mf6x4_pci_driver = {
> +       .name           = "mf6x4",
> +       .id_table       = mf6x4_pci_table,
> +       .probe          = mf6x4_pci_probe,
> +       .remove         = comedi_pci_auto_unconfig,
> +};
> +
> +module_comedi_pci_driver(mf6x4_driver, mf6x4_pci_driver);
> +
> +MODULE_AUTHOR("Rostislav Lisovy <lisovy@gmail.com>");
> +MODULE_DESCRIPTION("Comedi MF634 and MF624 DAQ cards driver");
> +MODULE_LICENSE("GPL");
> --
> 1.8.3.2
>

Looks fine to me!

Reviewed-by: Ian Abbott <abbotti@mev.co.uk>

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
