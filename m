Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753508Ab3IFOXm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 10:23:42 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:26543 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab3IFOXl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 10:23:41 -0400
Date: Fri, 6 Sep 2013 10:23:01 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5 05/13] xen/arm,arm64: move Xen initialization earlier
Message-ID: <20130906142301.GA5140@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
 <1377801154-29215-5-git-send-email-stefano.stabellini@eu.citrix.com>
 <20130905162026.GJ11887@arm.com>
 <alpine.DEB.2.02.1309051755560.6397@kaball.uk.xensource.com>
 <1378457939.14745.73.camel@kazak.uk.xensource.com>
 <20130906140921.GD1946@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130906140921.GD1946@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 06, 2013 at 03:09:21PM +0100, Catalin Marinas wrote:
> On Fri, Sep 06, 2013 at 09:58:59AM +0100, Ian Campbell wrote:
> > On Thu, 2013-09-05 at 17:59 +0100, Stefano Stabellini wrote:
> > > On Thu, 5 Sep 2013, Catalin Marinas wrote:
> > > > On Thu, Aug 29, 2013 at 07:32:26PM +0100, Stefano Stabellini wrote:
> > > > > Move Xen initialization earlier, before any DMA requests can be made.
> > > > > 
> > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > 
> > > > I guess you should cc the corresponding maintainers here.
> > > 
> > > Thanks for the reminder, I'll do that.
> > > 
> > > 
> > > > >  arch/arm/include/asm/xen/hypervisor.h |    8 ++++++++
> > > > >  arch/arm/kernel/setup.c               |    2 ++
> > > > >  arch/arm/xen/enlighten.c              |   21 ++++++++++++++-------
> > > > >  arch/arm64/kernel/setup.c             |    2 ++
> > > > >  4 files changed, 26 insertions(+), 7 deletions(-)
> > > > 
> > > > [...]
> > > > 
> > > > > --- a/arch/arm64/kernel/setup.c
> > > > > +++ b/arch/arm64/kernel/setup.c
> > > > > @@ -53,6 +53,7 @@
> > > > >  #include <asm/traps.h>
> > > > >  #include <asm/memblock.h>
> > > > >  #include <asm/psci.h>
> > > > > +#include <asm/xen/hypervisor.h>
> > > > >  
> > > > >  unsigned int processor_id;
> > > > >  EXPORT_SYMBOL(processor_id);
> > > > > @@ -267,6 +268,7 @@ void __init setup_arch(char **cmdline_p)
> > > > >  	unflatten_device_tree();
> > > > >  
> > > > >  	psci_init();
> > > > > +	xen_early_init();
> > > > 
> > > > So Xen guests don't have any hope for single Image? Basically you set
> > > > dma_ops unconditionally in xen_early_init(), even if the kernel is not
> > > > intended to run under Xen.
> > > 
> > > That should not happen: if we are not running on Xen xen_early_init
> > > returns early, before calling xen_mm_init.
> > 
> > x96 has a call to init_hypervisor_platform() at approximately this
> > location, which detects and calls the init function for any of Xen, KVM,
> > hyperv and vmware.
> 
> I would rather have a core_initcall(xen_early_init()) if possible,
> rather than hard-coded calls in setup_arch(). This early stuff is
> DT-driven, so in theory you don't need a specific xen call. The only
> thing is that you end up with swiotlb_init() and 64MB wasted if the Xen
> guest does not plan to use them.

There is a swiotlb_free mechanism in case the allocation was not
neccessary.
> 
> > I guess only Xen and KVM are currently relevant on Linux ARM(64), so
> > perhaps adding similar infrastructure on ARM would be overkill at this
> > point. I don't know if KVM needs such an early C-land hook, I suppose
> > it needs it even earlier so it can set up the hyp mode trampoline from
> > head.S?
> 
> head.S installs a Hyp stub if it starts in that mode and then forget
> about. Later when KVM is initialised it installs its own code by doing
> an HVC call.
> 
> -- 
> Catalin
