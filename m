Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389Ab3ILJvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 05:51:46 -0400
Received: from eu1sys200aog125.obsmtp.com ([207.126.144.159]:55463 "EHLO
	eu1sys200aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751137Ab3ILJvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 05:51:43 -0400
X-Greylist: delayed 1262 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Sep 2013 05:51:40 EDT
Date: Thu, 12 Sep 2013 15:00:18 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Kishon Vijay Abraham I'" <kishon@ti.com>,
        "'Bjorn Helgaas'" <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        "'Arnd Bergmann'" <arnd@arndb.de>, "'Sean Cross'" <xobs@kosagi.com>,
        "'Thierry Reding'" <thierry.reding@gmail.com>,
        "'SRIKANTH TUMKUR SHIVANAND'" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH V3] pci: exynos: split into two parts such as Synopsys
 part and Exynos part
Message-ID: <20130912093018.GA2124@pratyush-vbox>
References: <002801ce8376$a807dbf0$f81793d0$@samsung.com>
 <51ED49D6.9050209@ti.com>
 <000701ce8741$fe47deb0$fad79c10$@samsung.com>
 <51EE22DF.6090902@ti.com>
 <001301ce8772$522dfc50$f689f4f0$@samsung.com>
 <5231607C.10702@ti.com>
 <003501ceaf87$cda45db0$68ed1910$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <003501ceaf87$cda45db0$68ed1910$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,


On Thu, Sep 12, 2013 at 03:15:04PM +0800, Jingoo Han wrote:
> On Tuesday 23 July 2013 12:30 PM, Kishon Vijay Abraham I wrote:
> > >> .
> > >> .
> > >>>>> +			of_pci_range_to_resource(&range, np, &pp->cfg);
> > >>>>> +			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
> > >>>>> +			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> > >>>>> +		}
> > >>>>> +	}
> > >>>>> +
> > >>>>> +	pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
> > >>>>> +				resource_size(&pp->cfg));
> > >>>>
> > >>>> Why is configuraion space divided into two?
> > >>>
> > >>> Sorry, I don't know the exact reason. :(
> > >>> Pratyush Anand may know about this.
> > >>> Pratyush Anand, could you answer the question?
> > >>>
> > >>> Also, if you find some problems, please let me know.
> > 
> > One more query..
> > 
> > Where is inbound translation configuration done in your driver? how should it
> > be done?
> 

Yes, Kishon is right. Inbound translation configuration is missing in
your code and I think it should be implemented.

> Hi Kishon,
> 
> Sorry, I cannot understand your question exactly.
> However, the following thread would be helpful.
> 
> http://www.spinics.net/lists/arm-kernel/msg252078.html
> https://lkml.org/lkml/2013/6/17/890

>From this conversation, It seems that you
have tested this driver and it works fine without inbound translation
function. I am sure that you would have tested a PCIe card with DMA
capability such as PCIe2USB or PCIe2Ethernet. Since it worked, it
means that by default your controller is supporting one to one mapping
in case of inbound transaction even when address translation is enabled.

In my opinion you should call a function like as follows from
dw_pcie_host_init in pcie-designware.c.  It will insure one to one
mapping for any inbound request in memory range 0 to (in_mem_size -
1) for all dw implementation.

static void dw_pcie_prog_viewport_mem_inbound(struct pcie_port *pp)
{        
	u32 val;
	void __iomem *dbi_base = pp->dbi_base;

	/* Program viewport 0 : INBOUND : MEMORY*/
	val = PCIE_ATU_REGION_INBOUND | (0 & 0xF);
	dw_pcie_writel_rc(pp, val, dbi_base + PCIE_ATU_VIEWPORT));
	dw_pcie_writel_rc(pp, PCIE_ATU_TYPE_MEM, dbi_base + PCIE_ATU_CR1));
	val = PCIE_ATU_ENABLE | PCIE_ATU_BAR_MODE_ENABLE;
	dw_pcie_writel_rc(pp, val, dbi_base + PCIE_ATU_CR2));
	dw_pcie_writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_BASE));
	dw_pcie_writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_BASE));
	/* in_mem_size must be in power of 2 */
	dw_pcie_writel_rc(pp, pp->config.in_mem_size - 1, dbi_base + PCIE_ATU_LIMIT));
	dw_pcie_writel_rc(pp, 0, dbi_base + PCIE_ATU_LOWER_TARGET));
	dw_pcie_writel_rc(pp, 0, dbi_base + PCIE_ATU_UPPER_TARGET));
}

Regards
Pratyush

> 
> Best regards.
> Jingoo Han
