Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355AbaEGJbQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 05:31:16 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:53657 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932274AbaEGJbN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 05:31:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        devicetree@vger.kernel.org, balajitk@ti.com, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org, Mohit Kumar <mohit.kumar@st.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-omap@vger.kernel.org,
        rogerq@ti.com
Subject: Re: [PATCH 05/17] pci: host: pcie-dra7xx: add support for pcie-dra7xx controller
Date: Wed, 07 May 2014 11:30:35 +0200
Message-ID: <6485683.q96o7U6vf8@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5369F287.6000103@ti.com>
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <4300084.bc6ByDTk7W@wuerfel> <5369F287.6000103@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:E2cwf7rJbYBQftBW0Jyd3R8HEIkYOKKhWKMmWuovZx7
 cYeiKvLt0JqpAlz9DnWH9MueO+iR8dQtXg/JC101Mas1TVcO86
 jgee7/IMh80B8fW3nHjLfBCvkc95eJtNfBZuKmNfCRgNCYaIor
 1qE2jw2vQPxFAd+kT5ahuuyuC/s4jBjjP5KZrL5296pn7Lbcxt
 NtwfuYybtobvtTqnx3aKMM/Fk5xBk++YZx97IcC7iYXH23dTqa
 iWbTDRzsm0K+cNxoBryXAq+kpTPP/GPie7tOFufS0Z5GqF4GqN
 zA/MRwXSLOOhdG5wui0YZDyQ1XLE21SpTMRBlpxCA385SxQScP
 iOuOuHFW7umxFkP3wcIc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 May 2014 14:14:55 Kishon Vijay Abraham I wrote:
> >> +static void dra7xx_pcie_enable_interrupts(struct pcie_port *pp)
> >> +{
> >> +    struct dra7xx_pcie *dra7xx = to_dra7xx_pcie(pp);
> >> +
> >> +    dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MAIN,
> >> +                       ~INTERRUPTS);
> >> +    dra7xx_pcie_writel(dra7xx->base,
> >> +                       PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MAIN, INTERRUPTS);
> >> +    dra7xx_pcie_writel(dra7xx->base, PCIECTRL_DRA7XX_CONF_IRQSTATUS_MSI,
> >> +                       ~LEG_EP_INTERRUPTS & ~MSI);
> >> +
> >> +    if (IS_ENABLED(CONFIG_PCI_MSI))
> >> +            dra7xx_pcie_writel(dra7xx->base,
> >> +                               PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI, MSI);
> >> +    else
> >> +            dra7xx_pcie_writel(dra7xx->base,
> >> +                               PCIECTRL_DRA7XX_CONF_IRQENABLE_SET_MSI,
> >> +                               LEG_EP_INTERRUPTS);
> > 
> > Doesn't this just enable one or the other? In general I'd assume you need
> > both INTx and MSI, at least if MSI is available.
> 
> Not sure since the programming sequence in the TRM explicitly states either
> legacy interrupts or MSI interrupts should be enabled but not both.

Hmm, I think that means you can't have MSI at all. You have to support
legacy PCI devices that can't do MSI.

Do you know if you have a modern GIC implementation with MSI support
in these SoCs? It would be better anyway to use the GIC for doing
MSI, so you can just ignore the internal MSI controller here.

> >> +static int add_pcie_port(struct dra7xx_pcie *dra7xx,
> >> +                      struct platform_device *pdev)
> >> +{
> >> +    int ret;
> >> +    struct pcie_port *pp;
> >> +    struct resource *res;
> >> +    struct device *dev = &pdev->dev;
> >> +
> >> +    pp = &dra7xx->pp;
> >> +    pp->dev = dev;
> >> +    pp->ops = &dra7xx_pcie_host_ops;
> >> +
> >> +    spin_lock_init(&pp->conf_lock);
> >> +
> >> +    pp->irq = platform_get_irq(pdev, 1);
> >> +    if (pp->irq < 0) {
> >> +            dev_err(dev, "missing IRQ resource\n");
> >> +            return -EINVAL;
> >> +    }
> >>
> > 
> > The binding does not list a mandatory "interrupts" property, so
> > this should not be treated as an error.
> 
> actually the 'interrupts' property is documented in pci/designware-pcie.txt.

Hmm, but you don't seem to use it the same way as documented there.
I'm not sure what 'level interrupt, pulse interrupt, special interrupt'
in the parent binding are, but they don't seem to be the ones you use
here.

	Arnd
