Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbaCGScd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 13:32:33 -0500
Received: from exprod5og104.obsmtp.com ([64.18.0.178]:49379 "HELO
	exprod5og104.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752080AbaCGSca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 13:32:30 -0500
MIME-Version: 1.0
In-Reply-To: <005901cf39e0$81ceb960$856c2c20$%han@samsung.com>
References: <1394085963-27553-1-git-send-email-tinamdar@apm.com>
	<1394085963-27553-2-git-send-email-tinamdar@apm.com>
	<005901cf39e0$81ceb960$856c2c20$%han@samsung.com>
Date: Fri, 7 Mar 2014 10:32:29 -0800
Message-ID: <CACoXjcmPu9JL0Xrd8uYce2wRrqYbJPO=EoVsuVAJQgPL=diKLQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] pci: APM X-Gene PCIe controller driver
From: Tanmay Inamdar <tinamdar@apm.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches <patches@apm.com>,
        Jon Masters <jcm@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Landley <rob@landley.net>, Liviu Dudau <liviu.dudau@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for reviewing and the comments. I will surely include them in
next version.

-Tanmay

On Fri, Mar 7, 2014 at 12:37 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, March 06, 2014 3:06 PM, Tanmay Inamdar wrote:
>>
>
> Hi Tanmay Inamdar,
>
> I added some minor comments. :-)
>
>> This patch adds the AppliedMicro X-Gene SOC PCIe controller driver.
>> X-Gene PCIe controller supports maxmum upto 8 lanes and GEN3 speed.
>
> Would you fix the followings?
>
> s/maxmum/maximum
> s/upto/up to
>
>> X-Gene SOC supports maximum 5 PCIe ports.
>>
>> Signed-off-by: Tanmay Inamdar <tinamdar@apm.com>
>> ---
>>  drivers/pci/host/Kconfig     |   10 +
>>  drivers/pci/host/Makefile    |    1 +
>>  drivers/pci/host/pci-xgene.c |  739 ++++++++++++++++++++++++++++++++++++++++++
>>  3 files changed, 750 insertions(+)
>>  create mode 100644 drivers/pci/host/pci-xgene.c
>
> [.....]
>
>> --- /dev/null
>> +++ b/drivers/pci/host/pci-xgene.c
>
> [.....]
>
>> +
>> +static int xgene_pcie_parse_map_dma_ranges(struct xgene_pcie_port *port)
>> +{
>> +     struct device_node *np = port->node;
>> +     struct of_pci_range range;
>> +     struct of_pci_range_parser parser;
>> +     struct device *dev = port->dev;
>> +     u8 ib_reg_mask = 0;
>> +
>> +     if (pci_dma_range_parser_init(&parser, np)) {
>> +             dev_err(dev, "missing dma-ranges property\n");
>> +             return -EINVAL;
>> +     }
>> +
>> +     /* Get the dma-ranges from DT */
>> +     for_each_of_pci_range(&parser, &range) {
>> +             u64 end = range.cpu_addr + range.size - 1;
>> +             dev_dbg(port->dev, "0x%08x 0x%016llx..0x%016llx -> 0x%016llx\n",
>> +                     range.flags, range.cpu_addr, end, range.pci_addr);
>> +             xgene_pcie_setup_ib_reg(port, &range, &ib_reg_mask);
>> +     }
>> +     return 0;
>> +}
>> +
>> +static int __init xgene_pcie_probe_bridge(struct platform_device *pdev)
>
> Please, remove '__init' marker in order to fix section mismatch
> warning.
>
>> +{
>> +     struct device_node *np = of_node_get(pdev->dev.of_node);
>> +     struct xgene_pcie_port *port;
>> +     struct pci_host_bridge *bridge;
>> +     resource_size_t lastbus;
>> +     u32 lanes = 0, speed = 0;
>> +     u64 cfg_addr = 0;
>> +     int ret;
>> +
>> +     port = devm_kzalloc(&pdev->dev, sizeof(*port), GFP_KERNEL);
>> +     if (!port)
>> +             return -ENOMEM;
>> +     port->node = np;
>> +     port->dev = &pdev->dev;
>> +
>> +     ret = xgene_pcie_map_reg(port, pdev, &cfg_addr);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = xgene_pcie_init_port(port);
>> +     if (ret)
>> +             return ret;
>> +     xgene_pcie_program_core(port->csr_base);
>> +     xgene_pcie_setup_root_complex(port);
>> +
>> +     bridge = of_create_pci_host_bridge(&pdev->dev, &xgene_pcie_ops, port);
>> +     if (IS_ERR_OR_NULL(bridge))
>> +             return PTR_ERR(bridge);
>> +
>> +     ret = xgene_pcie_map_ranges(port, bridge, cfg_addr);
>> +     if (ret)
>> +             return ret;
>> +
>> +     ret = xgene_pcie_parse_map_dma_ranges(port);
>> +     if (ret)
>> +             return ret;
>> +
>> +     xgene_pcie_poll_linkup(port, &lanes, &speed);
>> +     if (!port->link_up)
>> +             dev_info(port->dev, "(rc) link down\n");
>> +     else
>> +             dev_info(port->dev, "(rc) x%d gen-%d link up\n",
>> +                             lanes, speed + 1);
>> +     platform_set_drvdata(pdev, port);
>> +     lastbus = pci_rescan_bus(bridge->bus);
>> +     pci_bus_update_busn_res_end(bridge->bus, lastbus);
>> +     return 0;
>> +}
>> +
>> +static const struct of_device_id xgene_pcie_match_table[] __initconst = {
>
> Please, remove '__initconst' marker in order to fix section mismatch
> warning.
>
>> +     {.compatible = "apm,xgene-pcie",},
>> +     {},
>> +};
>> +
>> +static struct platform_driver xgene_pcie_driver = {
>> +     .driver = {
>> +                .name = "xgene-pcie",
>> +                .owner = THIS_MODULE,
>> +                .of_match_table = of_match_ptr(xgene_pcie_match_table),
>> +               },
>
> Please fix this indent style, as below:
>
> +       },
>
> See you later. :-)
>
> Best regards,
> Jingoo Han
>
>> +     .probe = xgene_pcie_probe_bridge,
>> +};
>> +module_platform_driver(xgene_pcie_driver);
>> +
>> +MODULE_AUTHOR("Tanmay Inamdar <tinamdar@apm.com>");
>> +MODULE_DESCRIPTION("APM X-Gene PCIe driver");
>> +MODULE_LICENSE("GPL v2");
>> --
>> 1.7.9.5
>
