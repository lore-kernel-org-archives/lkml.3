Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350AbaEIL3y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 07:29:54 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:38005 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753422AbaEIL3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 07:29:52 -0400
Message-ID: <536CBC00.6000709@ti.com>
Date: Fri, 9 May 2014 16:59:04 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
CC: Marek Vasut <marex@denx.de>, <devicetree@vger.kernel.org>,
        <balajitk@ti.com>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Jingoo Han <jg1.han@samsung.com>,
        <linux-kernel@vger.kernel.org>, Mohit Kumar <mohit.kumar@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>, <linux-omap@vger.kernel.org>,
        <rogerq@ti.com>
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx
 controller
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <4300084.bc6ByDTk7W@wuerfel> <5369F287.6000103@ti.com> <6485683.q96o7U6vf8@wuerfel>
In-Reply-To: <6485683.q96o7U6vf8@wuerfel>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wednesday 07 May 2014 03:00 PM, Arnd Bergmann wrote:
> On Wednesday 07 May 2014 14:14:55 Kishon Vijay Abraham I wrote:
>>>> +static void dra7xx_pcie_enable_interrupts(struct pcie_port *pp)
>>>> +{
>>>> +    struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
>>>> +
>>>> +    dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN,
>>>> +                       ~INTERRUPTS);
>>>> +    dra7xx_pcie_writel(dra7xx->base,
>>>> +                       PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MAIN, INTERRUPTS);
>>>> +    dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI,
>>>> +                       ~LEG_EP_INTERRUPTS & ~MSI);
>>>> +
>>>> +    if (IS_ENABLED(CONFIG_PCI_MSI))
>>>> +            dra7xx_pcie_writel(dra7xx->base,
>>>> +                               PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI, MSI);
>>>> +    else
>>>> +            dra7xx_pcie_writel(dra7xx->base,
>>>> +                               PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI,
>>>> +                               LEG_EP_INTERRUPTS);
>>>
>>> Doesn't this just enable one or the other? In general I'd assume you need
>>> both INTx and MSI, at least if MSI is available.
>>
>> Not sure since the programming sequence in the TRM explicitly states either
>> legacy interrupts or MSI interrupts should be enabled but not both.
> 
> Hmm, I think that means you can't have MSI at all. You have to support
> legacy PCI devices that can't do MSI.
> 
> Do you know if you have a modern GIC implementation with MSI support
> in these SoCs? It would be better anyway to use the GIC for doing

In DRA7 it is not there. I'm not sure in other platforms.
> MSI, so you can just ignore the internal MSI controller here.
> 
>>>> +static int add_pcie_port(struct dra7xx_pcie *dra7xx,
>>>> +                      struct platform_device *pdev)
>>>> +{
>>>> +    int ret;
>>>> +    struct pcie_port *pp;
>>>> +    struct resource *res;
>>>> +    struct device *dev = &pdev->dev;
>>>> +
>>>> +    pp = &dra7xx->pp;
>>>> +    pp->dev = dev;
>>>> +    pp->ops = &dra7xx_pcie_host_ops;
>>>> +
>>>> +    spin_lock_init(&pp->conf_lock);
>>>> +
>>>> +    pp->irq = platform_get_irq(pdev, 1);
>>>> +    if (pp->irq < 0) {
>>>> +            dev_err(dev, "missing IRQ resource\n");
>>>> +            return -EINVAL;
>>>> +    }
>>>>
>>>
>>> The binding does not list a mandatory "interrupts" property, so
>>> this should not be treated as an error.
>>
>> actually the 'interrupts' property is documented in pci/designware-pcie.txt.
> 
> Hmm, but you don't seem to use it the same way as documented there.
> I'm not sure what 'level interrupt, pulse interrupt, special interrupt'
> in the parent binding are, but they don't seem to be the ones you use
> here.

Yeah. I'll update my Documentation. Thanks for pointing this out.

Thanks
Kishon
