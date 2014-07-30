Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755792AbaG3R6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:58:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51122 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755648AbaG3R6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:58:44 -0400
Date: Wed, 30 Jul 2014 19:58:36 +0200
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        lkml <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH] x86, irq: Keep IRQ assignment for PCI devices during
 suspend/hibernation
Message-ID: <20140730175836.GC10213@pd.tnic>
References: <alpine.DEB.2.10.1407282255120.23352@nanos>
 <1406713034-3387-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406713034-3387-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 05:37:13PM +0800, Jiang Liu wrote:
> Function pci_disable_device() may be called for PCI devices during
> suspend/hibernation, which in turn may release IRQ assigned to PCI
> interrupt. Later when pci_enable_device() is called during resume,
> a different IRQ may be assigned and thus break the driver.
> So keep IRQ assignment for PCI devices during suspend/hibernation.
> We check pci_dev.dev.power.is_prepared to detect that pci_disable_device()
> and pci_enable_device() is called during suspend/hibernation.
> 
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
> Hi Borislav,
> 	I can't reproduce the issue with my test machine. So could you
> please help to test this patch?
> Regards!
> Gerry
> ---
>  arch/x86/pci/common.c |    5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
> index 059a76c29739..417de4c92e8f 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -662,14 +662,15 @@ int pcibios_enable_device(struct pci_dev *dev, int mask)
>  	if ((err = pci_enable_resources(dev, mask)) < 0)
>  		return err;
>  
> -	if (!pci_dev_msi_enabled(dev))
> +	if (!pci_dev_msi_enabled(dev) && !dev->dev.pm.is_prepared)
>  		return pcibios_enable_irq(dev);
>  	return 0;
>  }
>  
>  void pcibios_disable_device (struct pci_dev *dev)
>  {
> -	if (!pci_dev_msi_enabled(dev) && pcibios_disable_irq)
> +	if (!pci_dev_msi_enabled(dev) && pcibios_disable_irq &&
> +	    !dev->dev.pm.is_prepared)
>  		pcibios_disable_irq(dev);

Did you even build-test this patch?

arch/x86/pci/common.c: In function ‘pcibios_enable_device’:
arch/x86/pci/common.c:665:44: error: ‘struct device’ has no member named ‘pm’
  if (!pci_dev_msi_enabled(dev) && !dev->dev.pm.is_prepared)
                                            ^
arch/x86/pci/common.c: In function ‘pcibios_disable_device’:
arch/x86/pci/common.c:673:15: error: ‘struct device’ has no member named ‘pm’
      !dev->dev.pm.is_prepared)
               ^
make[1]: *** [arch/x86/pci/common.o] Error 1
make[1]: *** Waiting for unfinished jobs....
make: *** [arch/x86/pci] Error 2
make: *** Waiting for unfinished jobs....



My tree is rc7 + tip/master from Sunday.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
