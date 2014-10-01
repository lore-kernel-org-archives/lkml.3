Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaJAL3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 07:29:11 -0400
Received: from outbound-smtp01.blacknight.com ([81.17.249.7]:34400 "EHLO
	outbound-smtp01.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750768AbaJAL3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 07:29:08 -0400
Message-ID: <542BE580.2000807@nexus-software.ie>
Date: Wed, 01 Oct 2014 12:29:04 +0100
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>,
        "'David Miller'" <davem@davemloft.net>
CC: "'peppe.cavallaro@st.com'" <peppe.cavallaro@st.com>,
        "'rayagond@vayavyalabs.com'" <rayagond@vayavyalabs.com>,
        "'vbridgers2013@gmail.com'" <vbridgers2013@gmail.com>,
        "'srinivas.kandagatla@st.com'" <srinivas.kandagatla@st.com>,
        "'wens@csie.org'" <wens@csie.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
Subject: Re: [PATCH 4/4] net: stmmac: add MSI support for Intel Quark X1000
References: <F54AEECA5E2B9541821D670476DAE19C2B7F65A6@PGSMSX102.gar.corp.intel.com>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B7F65A6@PGSMSX102.gar.corp.intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Guys,
>
> Just gently ping for the discussion to carry on before forgetting the context.
> Anyone have any better idea or comments or concern to this topic?
> Hope the above explanation clear out your doubt.
>
>
> Regards,
> Wilson

Hi Wilson.

Seeing you post now on the PCI emumeration suggestion from Dave Miller I see

I wasn't copied on this https://lkml.org/lkml/2014/8/27/190 thread so 
can only respond now....

What's missing from your MSI enabling code is the PVM mask/unmask 
required on the Quark X1000 bridge - for *all* downstream devices using MSI.

I realise it's not an upstreaming friendly piece of code - however - 
without the PVM mask operation all MSIs on Quark should be considered 
unreliable.

Maybe you guys have submitted patches to the PCI layer on this already ? 
If so feel free to ignore.

If not then please re-evaluate all MSI enabling code.

 From the original

http://downloadmirror.intel.com/23171/eng/Board_Support_Package_Sources_for_Intel_Quark_v1.0.0.7z

+#if defined(CONFIG_INTEL_QUARK_X1000_SOC)
+	#define mask_pvm(x) qrk_pci_pvm_mask(x)
+	#define unmask_pvm(x) qrk_pci_pvm_unmask(x)
+#else
+	#define mask_pvm(x)
+	#define unmask_pvm(x)
+#endif
+
  static irqreturn_t stmmac_interrupt(int irq, void *dev_id)
  {
  	struct net_device *dev = (struct net_device *)dev_id;
@@ -1601,10 +1686,12 @@ static irqreturn_t stmmac_interrupt(int irq, 
void *dev_id)
  		return IRQ_NONE;
  	}

+	mask_pvm(priv->pdev);
+
  	/* To handle GMAC own interrupts */
  	if (priv->plat->has_gmac) {
-		int status = priv->hw->mac->host_irq_status((void __iomem *)
-							    dev->base_addr);
+		int status = priv->hw->mac->host_irq_status(priv);
+
  		if (unlikely(status)) {
  			if (status & core_mmc_tx_irq)
  				priv->xstats.mmc_tx_irq_n++;
@@ -1634,6 +1721,8 @@ static irqreturn_t stmmac_interrupt(int irq, void 
*dev_id)
  	/* To handle DMA interrupts */
  	stmmac_dma_interrupt(priv);

+	unmask_pvm(priv->pdev);
+
  	return IRQ_HANDLED;
  }
