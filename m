Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225AbaI3RSQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 13:18:16 -0400
Received: from dliviu.plus.com ([80.229.23.120]:58394 "EHLO smtp.dudau.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751719AbaI3RSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 13:18:15 -0400
Date: Tue, 30 Sep 2014 18:10:03 +0100
From: Liviu Dudau <liviu@dudau.co.uk>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Liviu Dudau <Liviu.Dudau@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Rob Herring <robh@kernel.org>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of/pci: add pci_pio_to_address dummy for !CONFIG_OF
Message-ID: <20140930171002.GB15854@bart.dudau.co.uk>
References: <706416181.hbVGLDA3o6@wuerfel>
 <20140930160139.GA5625@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140930160139.GA5625@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Sep 30 18:18:13 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 13,542ae5d448391169974385
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2014 at 10:01:39AM -0600, Bjorn Helgaas wrote:
> On Tue, Sep 30, 2014 at 03:19:05PM +0200, Arnd Bergmann wrote:
> > The pci_register_io_range() and pci_pio_to_address() were recently
> > introduced to generalize the handling of memory mapped PCI I/O space,
> > but they are only valid when CONFIG_OF is set, leading to a possible
> > build error:
> > 
> > drivers/pci/host/pcie-rcar.c: In function 'rcar_pcie_setup_window':
> > drivers/pci/host/pcie-rcar.c:340:3: error: implicit declaration of function 'pci_pio_to_address' [-Werror=implicit-function-declaration]
> >    res_start = pci_pio_to_address(res->start);
> >    ^
> > drivers/pci/host/pcie-rcar.c: In function 'rcar_pcie_probe':
> > drivers/pci/host/pcie-rcar.c:945:3: error: implicit declaration of function 'of_pci_range_to_resource' [-Werror=implicit-function-declaration]
> >    err = of_pci_range_to_resource(&range, pdev->dev.of_node,
> >    ^
> > cc1: some warnings being treated as errors
> > 
> > This provides inline dummy implementations for the case that
> > CONFIG_OF is disabled, to allow better build testing.
> > 
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > Fixes: 279c5dd046 ("of/pci: Add pci_register_io_range() and pci_pio_to_address()")
> 
> I'm rebuilding the pci/host-generic branch to pick up the other v13 fixes,
> so I folded this fix directly into the "of/pci: Add pci_register_io_range()
> and pci_pio_to_address()" patch.  Thanks for finding this; the config
> dependencies are a bit of a mess.

Bjorn,

I suggest splitting this patch into 2 parts, move the one that adds pci_pio_to_address() in patch 2
and the other in patch 5.

Best regards,
Liviu

> 
> > diff --git a/include/linux/of_address.h b/include/linux/of_address.h
> > index 7ebb877b07c2..851097aab115 100644
> > --- a/include/linux/of_address.h
> > +++ b/include/linux/of_address.h
> > @@ -71,6 +71,11 @@ static inline const __be32 *of_get_address(struct device_node *dev, int index,
> >  	return NULL;
> >  }
> >  
> > +static inline phys_addr_t pci_pio_to_address(unsigned long pio)
> > +{
> > +	return 0;
> > +}
> > +
> >  static inline int of_pci_range_parser_init(struct of_pci_range_parser *parser,
> >  			struct device_node *node)
> >  {
> > @@ -144,6 +149,12 @@ static inline const __be32 *of_get_pci_address(struct device_node *dev,
> >  {
> >  	return NULL;
> >  }
> > +static inline int of_pci_range_to_resource(struct of_pci_range *range,
> > +					   struct device_node *np,
> > +					   struct resource *res)
> > +{
> > +	return -ENOSYS;
> > +}
> >  #endif /* CONFIG_OF_ADDRESS && CONFIG_PCI */
> >  
> >  #endif /* __OF_ADDRESS_H */
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
-------------------
   .oooO
   (   )
    \ (  Oooo.
     \_) (   )
          ) /
         (_/

 One small step
   for me ...

