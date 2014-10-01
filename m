Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaJALzp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:55:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:20117 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750997AbaJALzo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:55:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,632,1406617200"; 
   d="scan'208";a="608097746"
From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
To: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>,
        "'David Miller'" <davem@davemloft.net>
CC: "'peppe.cavallaro@st.com'" <peppe.cavallaro@st.com>,
        "'rayagond@vayavyalabs.com'" <rayagond@vayavyalabs.com>,
        "'vbridgers2013@gmail.com'" <vbridgers2013@gmail.com>,
        "'srinivas.kandagatla@st.com'" <srinivas.kandagatla@st.com>,
        "'wens@csie.org'" <wens@csie.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: RE: [PATCH 4/4] net: stmmac: add MSI support for Intel Quark X1000
Thread-Topic: [PATCH 4/4] net: stmmac: add MSI support for Intel Quark X1000
Thread-Index: AQHP3WsDvvwBrDuo1keHXNY4pD5ocpwbIC7A
Date: Wed, 1 Oct 2014 11:55:22 +0000
Message-ID: <F54AEECA5E2B9541821D670476DAE19C2B7F6612@PGSMSX102.gar.corp.intel.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B7F65A6@PGSMSX102.gar.corp.intel.com>
 <542BE580.2000807@nexus-software.ie>
In-Reply-To: <542BE580.2000807@nexus-software.ie>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.30.20.206]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Bryan O'Donoghue [mailto:pure.logic@nexus-software.ie]
> Sent: Wednesday, October 01, 2014 7:29 PM
> Hi Wilson.
> 
> Seeing you post now on the PCI emumeration suggestion from Dave Miller I
> see
> 
> I wasn't copied on this https://lkml.org/lkml/2014/8/27/190 thread so can
> only respond now....
> 
> What's missing from your MSI enabling code is the PVM mask/unmask
> required on the Quark X1000 bridge - for *all* downstream devices using MSI.
> 
> I realise it's not an upstreaming friendly piece of code - however - without
> the PVM mask operation all MSIs on Quark should be considered unreliable.
> 
> Maybe you guys have submitted patches to the PCI layer on this already ?
> If so feel free to ignore.
> 
> If not then please re-evaluate all MSI enabling code.
> 
>  From the original
> 
> http://downloadmirror.intel.com/23171/eng/Board_Support_Package_Sour
> ces_for_Intel_Quark_v1.0.0.7z
> 
> +#if defined(CONFIG_INTEL_QUARK_X1000_SOC)
> +	#define mask_pvm(x) qrk_pci_pvm_mask(x)
> +	#define unmask_pvm(x) qrk_pci_pvm_unmask(x) #else
> +	#define mask_pvm(x)
> +	#define unmask_pvm(x)
> +#endif
> +
>   static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
>   {
>   	struct net_device *dev = (struct net_device *)dev_id; @@ -1601,10
> +1686,12 @@ static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
>   		return IRQ_NONE;
>   	}
> 
> +	mask_pvm(priv->pdev);
> +
>   	/* To handle GMAC own interrupts */
>   	if (priv->plat->has_gmac) {
> -		int status = priv->hw->mac->host_irq_status((void __iomem
> *)
> -							    dev->base_addr);
> +		int status = priv->hw->mac->host_irq_status(priv);
> +
>   		if (unlikely(status)) {
>   			if (status & core_mmc_tx_irq)
>   				priv->xstats.mmc_tx_irq_n++;
> @@ -1634,6 +1721,8 @@ static irqreturn_t stmmac_interrupt(int irq, void
> *dev_id)
>   	/* To handle DMA interrupts */
>   	stmmac_dma_interrupt(priv);
> 
> +	unmask_pvm(priv->pdev);
> +
>   	return IRQ_HANDLED;
>   }

Hi Bryan,

The MSI masking is already implemented in the MSI framework: http://lxr.free-electrons.com/source/drivers/pci/msi.c#L181.
I don't see a reason to upstream a local set implementation to Ethernet subsystem.
Thanks.


Regards,
Wilson

