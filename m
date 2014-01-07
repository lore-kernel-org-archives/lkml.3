Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbaAGCpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:45:15 -0500
Received: from exprod5og111.obsmtp.com ([64.18.0.22]:38228 "HELO
	exprod5og111.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756395AbaAGCpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:45:12 -0500
MIME-Version: 1.0
In-Reply-To: <007401cf0a81$51429250$f3c7b6f0$%han@samsung.com>
References: <1387785725-24262-1-git-send-email-tinamdar@apm.com>
	<1387785725-24262-2-git-send-email-tinamdar@apm.com>
	<007401cf0a81$51429250$f3c7b6f0$%han@samsung.com>
Date: Mon, 6 Jan 2014 18:45:11 -0800
Message-ID: <CACoXjcmqUixctokJ9COLWAsaDTUyVKk9vTAbW1hUhUdcgaj-kg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/3] pci: APM X-Gene PCIe controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Grant Likely <grant.likely@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, linux-pci@vger.kernel.org,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        patches <patches@apm.com>, Jon Masters <jcm@redhat.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 5, 2014 at 5:47 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Monday, December 23, 2013 5:02 PM, Tanmay Inamdar wrote:
>>
>> This patch adds the AppliedMicro X-gene SOC PCIe controller driver.
>> APM X-Gene PCIe controller supports maximum upto 8 lanes and
>> GEN3 speed. X-Gene has maximum 5 PCIe ports supported.
>
> (+cc Jason Gunthorpe, Arnd Bergmann)
>
> Hi Tanmay Inamdar,
>
> I added some minor comments. :-)
>
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  drivers/pci/host/Kconfig      |    5 +
>>  drivers/pci/host/Makefile     |    1 +
>>  drivers/pci/host/pcie-xgene.c | 1017 +++++++++++++++++++++++++++++++++++++++++
>
> Would you change the file name to 'pci-xgene.c'?
> Now, all PCI host drivers are using the prefix 'pci-', not 'pcie-'.

I guess designware is an exception. There is
"drivers/pci/host/pcie-designware.c"
>
> [.....]
>
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/pci.h>
>> +#include <linux/slab.h>
>> +#include <linux/memblock.h>
>> +#include <linux/io.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/of.h>
>> +#include <linux/of_address.h>
>> +#include <linux/of_irq.h>
>> +#include <linux/of_pci.h>
>> +#include <linux/jiffies.h>
>> +#include <linux/clk-private.h>
>
> Would you re-order these headers alphabetically?
> It enhances the readability.

ok.

>
> [.....]
>
>> +static int xgene_pcie_parse_map_ranges(struct xgene_pcie_port *port)
>> +{
>> +     struct device_node *np = port->node;
>> +     struct of_pci_range range;
>> +     struct of_pci_range_parser parser;
>> +     struct device *dev = port->dev;
>> +     u32 cfg_map_done = 0;
>> +     int ret;
>> +
>> +     if (of_pci_range_parser_init(&parser, np)) {
>> +             dev_err(dev, "missing ranges property\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* Get the I/O, memory, config ranges from DT */
>> +     for_each_of_pci_range(&parser, &range) {
>> +             struct resource *res = NULL;
>> +             u64 restype = range.flags & IORESOURCE_TYPE_BITS;
>> +             u64 end = range.cpu_addr + range.size - 1;
>> +             dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
>> +                     range.flags, range.cpu_addr, end, range.pci_addr);
>> +
>> +             switch (restype) {
>> +             case IORESOURCE_IO:
>> +                     res = &port->res[XGENE_IO];
>> +                     of_pci_range_to_resource(&range, np, res);
>> +                     xgene_pcie_setup_ob_reg(port->csr_base, OMR1BARL,
>> +                                             XGENE_IO, res);
>> +                     break;
>> +             case IORESOURCE_MEM:
>> +                     res = &port->res[XGENE_MEM];
>> +                     of_pci_range_to_resource(&range, np, res);
>> +                     xgene_pcie_setup_ob_reg(port->csr_base, OMR2BARL,
>> +                                             XGENE_MEM, res);
>> +                     break;
>> +             case 0:
>> +                     if (!cfg_map_done) {
>> +                             /* config region */
>> +                             if (port->type == PTYPE_ROOT_PORT) {
>> +                                     ret = xgene_pcie_map_cfg(port, &range);
>> +                                     if (ret)
>> +                                             return ret;
>> +                             }
>> +                             cfg_map_done = 1;
>> +                     } else {
>> +                             /* msi region */
>> +                             res = &port->res[XGENE_MSI];
>> +                             of_pci_range_to_resource(&range, np, res);
>
> As Jason Gunthorpe said, the DT 'range' property should not
> handle MSI. Please refer to other PCI host drivers such as
> pci-mvebu.c, pci-tegra.c and pcie-designware.c.

Right. I will remove MSI from ranges.

>
> Currently, 'struct msi_chip', ' struct irq_domain' are used
> for implementing MSI feature.
>
> Best regards,
> Jingoo Han
>
