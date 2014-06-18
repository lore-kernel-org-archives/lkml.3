Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934035AbaFRGiy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 02:38:54 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:59537 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933990AbaFRGiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 02:38:52 -0400
Date: Wed, 18 Jun 2014 12:07:07 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 1/8] PCI: designware: add rd[wr]_other_conf API
Message-ID: <20140618063706.GA6098@pratyush-vbox>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
 <1402426287-31157-2-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1402426287-31157-2-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-18_03:2014-06-17,2014-06-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 02:51:20AM +0800, Murali Karicheri wrote:
> v3.65 version of the designware h/w, requires application space
> registers to be configured to access the remote EP config space.
> To support this, add rd[wr]_other_conf API in the pcie_host_opts
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mohit Kumar <mohit.kumar@st.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Pratyush Anand <pratyush.anand@st.com>
> CC: Richard Zhu <r65037@freescale.com>
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Marek Vasut <marex@denx.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Grant Likely <grant.likely@linaro.org> 
> 
> ---
>  drivers/pci/host/pcie-designware.c |   12 ++++++++++--
>  drivers/pci/host/pcie-designware.h |    4 ++++
>  2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index c4e3732..e8f5d8d 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -654,7 +654,11 @@ static int dw_pcie_rd_conf(struct pci_bus *bus, u32 devfn, int where,
>  
>  	spin_lock_irqsave(&pp->conf_lock, flags);
>  	if (bus->number != pp->root_bus_nr)
> -		ret = dw_pcie_rd_other_conf(pp, bus, devfn,
> +		if (pp->ops->rd_other_conf)
> +			ret = pp->ops->rd_other_conf(pp, bus, devfn,
> +						where, size, val);
> +		else
> +			ret = dw_pcie_rd_other_conf(pp, bus, devfn,
>  						where, size, val);
>  	else
>  		ret = dw_pcie_rd_own_conf(pp, where, size, val);
> @@ -680,7 +684,11 @@ static int dw_pcie_wr_conf(struct pci_bus *bus, u32 devfn,
>  
>  	spin_lock_irqsave(&pp->conf_lock, flags);
>  	if (bus->number != pp->root_bus_nr)
> -		ret = dw_pcie_wr_other_conf(pp, bus, devfn,
> +		if (pp->ops->wr_other_conf)
> +			ret = pp->ops->wr_other_conf(pp, bus, devfn,
> +						where, size, val);
> +		else
> +			ret = dw_pcie_wr_other_conf(pp, bus, devfn,
>  						where, size, val);
>  	else
>  		ret = dw_pcie_wr_own_conf(pp, where, size, val);
> diff --git a/drivers/pci/host/pcie-designware.h b/drivers/pci/host/pcie-designware.h
> index 3063b35..2d6dd66 100644
> --- a/drivers/pci/host/pcie-designware.h
> +++ b/drivers/pci/host/pcie-designware.h
> @@ -62,6 +62,10 @@ struct pcie_host_ops {
>  			u32 val, void __iomem *dbi_base);
>  	int (*rd_own_conf)(struct pcie_port *pp, int where, int size, u32 *val);
>  	int (*wr_own_conf)(struct pcie_port *pp, int where, int size, u32 val);
> +	int (*rd_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
> +			unsigned int devfn, int where, int size, u32 *val);
> +	int (*wr_other_conf)(struct pcie_port *pp, struct pci_bus *bus,
> +			unsigned int devfn, int where, int size, u32 val);
>  	int (*link_up)(struct pcie_port *pp);
>  	void (*host_init)(struct pcie_port *pp);
>  };

Reviewed-by: Pratyush Anand <pratyush.anand@st.com> 

> -- 
> 1.7.9.5
