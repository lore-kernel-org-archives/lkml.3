Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3KDS1K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:27:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:41847 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab3KDS1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:27:07 -0500
Date: Mon, 4 Nov 2013 13:25:32 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: linux-next: Tree for Nov 1 (xen_swiotllb)
Message-ID: <20131104182532.GA7345@phenom.dumpdata.com>
References: <20131101191138.442028fb1f243c7f9c7f0844@canb.auug.org.au>
 <5273EFFA.1030400@infradead.org>
 <20131101194324.GC15622@phenom.dumpdata.com>
 <alpine.DEB.2.02.1311041800540.26077@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311041800540.26077@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 06:20:42PM +0000, Stefano Stabellini wrote:
> On Fri, 1 Nov 2013, Konrad Rzeszutek Wilk wrote:
> > On Fri, Nov 01, 2013 at 11:16:26AM -0700, Randy Dunlap wrote:
> > > On 11/01/13 01:11, Stephen Rothwell wrote:
> > > > Hi all,
> > > > 
> > > > Changes since 20131031:
> > > > 
> > > > The squashfs tree gained a build failure so I used the version from
> > > > next-20131031.
> > > > 
> > > > The block tree gained conflicts against the f2fs, aio-direct and Linus'
> > > > trees and a build failure and generated several warnings so I used the
> > > > version from next-20131031.
> > > > 
> > > > The dt-rh tree gained a conflict against the powerpc tree.
> > > > 
> > > > The kvm-ppc tree gained a conflict against the powerpc tree.
> > > > 
> > > > The leds tree gained a conflict against the powerpc tree.
> > > > 
> > > > The tty tree lost its build failure.
> > > 
> > > 
> > > on x86_64, when CONFIG_PCI is not enabled:
> > > 
> > > arch/x86/built-in.o: In function `pci_xen_swiotlb_init_late':
> > > (.text+0x102cc): undefined reference to `pci_request_acs'
> > > arch/x86/built-in.o: In function `pci_xen_swiotlb_init':
> > > (.init.text+0x3f6c): undefined reference to `pci_request_acs'
> > 
> > Stefano,
> > 
> > Please fix that. I think it is commit 83862ccfc0a03212fde43b4ac29c28381828768b
> > Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Date:   Thu Oct 10 13:40:44 2013 +0000
> > 
> >     xen/arm,arm64: enable SWIOTLB_XEN
> > 
> > that is causing this. Is it safe to add:
> > 
> >        depends on PCI
> > 
> > back on it?
>  
> On ARM it is possible to use the swiotlb without PCI support.
> Ideally we wouldn't even build arch/x86/xen/pci-swiotlb-xen.c if
> CONFIG_PCI was missing. However other core x86 kernel stuff seem to have
> similar issues, for example arch/x86/kernel/pci-swiotlb.c build with or
> without CONFIG_PCI and references pci_xen_swiotlb_detect.
> I think that the right solution would be to completely disentangle
> CONFIG_PCI from swiotlb related stuff, but for the moment I went for the
> easy fix:

Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 
> commit 1e6d541cc26683d0f347e1cedfee1bc57e3f8875
> Author: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Date:   Mon Nov 4 18:11:54 2013 +0000
> 
>     pci-swiotlb-xen: call pci_request_acs only ifdef CONFIG_PCI
>     
>     Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> diff --git a/arch/x86/xen/pci-swiotlb-xen.c b/arch/x86/xen/pci-swiotlb-xen.c
> index 9695704..0e98e5d 100644
> --- a/arch/x86/xen/pci-swiotlb-xen.c
> +++ b/arch/x86/xen/pci-swiotlb-xen.c
> @@ -75,8 +75,10 @@ void __init pci_xen_swiotlb_init(void)
>  		xen_swiotlb_init(1, true /* early */);
>  		dma_ops = &xen_swiotlb_dma_ops;
>  
> +#ifdef CONFIG_PCI
>  		/* Make sure ACS will be enabled */
>  		pci_request_acs();
> +#endif
>  	}
>  }
>  
> @@ -92,8 +94,10 @@ int pci_xen_swiotlb_init_late(void)
>  		return rc;
>  
>  	dma_ops = &xen_swiotlb_dma_ops;
> +#ifdef CONFIG_PCI
>  	/* Make sure ACS will be enabled */
>  	pci_request_acs();
> +#endif
>  
>  	return 0;
>  }
