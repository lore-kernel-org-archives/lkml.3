Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889Ab3IFI7G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 04:59:06 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:17045 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab3IFI7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 04:59:04 -0400
X-IronPort-AV: E=Sophos;i="4.90,853,1371081600"; 
   d="scan'208";a="8483061"
Message-ID: <1378457939.14745.73.camel@kazak.uk.xensource.com>
Subject: Re: [PATCH v5 05/13] xen/arm,arm64: move Xen initialization earlier
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Date: Fri, 6 Sep 2013 09:58:59 +0100
In-Reply-To: <alpine.DEB.2.02.1309051755560.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com>
	 <1377801154-29215-5-git-send-email-stefano.stabellini@eu.citrix.com>
	 <20130905162026.GJ11887@arm.com>
	 <alpine.DEB.2.02.1309051755560.6397@kaball.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-05 at 17:59 +0100, Stefano Stabellini wrote:
> On Thu, 5 Sep 2013, Catalin Marinas wrote:
> > On Thu, Aug 29, 2013 at 07:32:26PM +0100, Stefano Stabellini wrote:
> > > Move Xen initialization earlier, before any DMA requests can be made.
> > > 
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > 
> > I guess you should cc the corresponding maintainers here.
> 
> Thanks for the reminder, I'll do that.
> 
> 
> > >  arch/arm/include/asm/xen/hypervisor.h |    8 ++++++++
> > >  arch/arm/kernel/setup.c               |    2 ++
> > >  arch/arm/xen/enlighten.c              |   21 ++++++++++++++-------
> > >  arch/arm64/kernel/setup.c             |    2 ++
> > >  4 files changed, 26 insertions(+), 7 deletions(-)
> > 
> > [...]
> > 
> > > --- a/arch/arm64/kernel/setup.c
> > > +++ b/arch/arm64/kernel/setup.c
> > > @@ -53,6 +53,7 @@
> > >  #include <asm/traps.h>
> > >  #include <asm/memblock.h>
> > >  #include <asm/psci.h>
> > > +#include <asm/xen/hypervisor.h>
> > >  
> > >  unsigned int processor_id;
> > >  EXPORT_SYMBOL(processor_id);
> > > @@ -267,6 +268,7 @@ void __init setup_arch(char **cmdline_p)
> > >  	unflatten_device_tree();
> > >  
> > >  	psci_init();
> > > +	xen_early_init();
> > 
> > So Xen guests don't have any hope for single Image? Basically you set
> > dma_ops unconditionally in xen_early_init(), even if the kernel is not
> > intended to run under Xen.
> 
> That should not happen: if we are not running on Xen xen_early_init
> returns early, before calling xen_mm_init.

x96 has a call to init_hypervisor_platform() at approximately this
location, which detects and calls the init function for any of Xen, KVM,
hyperv and vmware. I guess only Xen and KVM are currently relevant on
Linux ARM(64), so perhaps adding similar infrastructure on ARM would be
overkill at this point. I don't know if KVM needs such an early C-land
hook, I suppose it needs it even earlier so it can set up the hyp mode
trampoline from head.S?

Ian.

