Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162220Ab3DERej (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 13:34:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7535 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1162183Ab3DERei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 13:34:38 -0400
X-IronPort-AV: E=Sophos;i="4.87,416,1363132800"; 
   d="scan'208";a="16953028"
Date: Fri, 5 Apr 2013 18:34:30 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v6 4/4] xen/arm: introduce xen_early_init, use PSCI on
 xen
In-Reply-To: <alpine.DEB.2.02.1304051725580.21065@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1304051825390.21065@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-4-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1304051217560.1171@syhkavp.arg> <alpine.DEB.2.02.1304051725580.21065@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Apr 2013, Stefano Stabellini wrote:
> On Fri, 5 Apr 2013, Nicolas Pitre wrote:
> > On Fri, 5 Apr 2013, Stefano Stabellini wrote:
> > 
> > > Split xen_guest_init in two functions, one of them (xen_early_init) is
> > > going to be called very early from setup_arch.
> > > 
> > > Change machine_desc->smp_init to xen_smp_init if Xen is present on the
> > > platform. xen_smp_init just sets smp_ops to psci_smp_ops.
> > 
> > I still think the above is redundant, especially since psci_smp_ops has 
> > priority over default mdesc->smp_ops.  And doing so does break MCPM. But 
> > we're apparently going in circle over this issue.
> 
> Did you read my last email on this issue?
> 
> http://marc.info/?l=linux-arm-kernel&m=136500098703317&w=2
> 
> 
> Let's examine the use cases here, assuming that your MCPM patch series
> has been applied.
> 
> 
> This is what happens:
> 
> - No Xen
> Xen is not running on the platform and a Xen hypervisor node is not
> available on device tree.
> Everything keeps working seamlessly, this patch doesn't change anything.
> 
> - we are running on Xen
> Xen is running on the platform, we are running as a guest on Xen and an
> hypervisor node is available on device tree.
> Let's also assume that there aren't any "arm,cci" compatible nodes on
> device tree because Xen wouldn't export this kind of information to any
> guests right now. Therefore PSCI should be used to boot secondary cpus.

Just in case this isn't clear enough: we don't have big.LITTLE support
in Xen right now, not in the hypervisor and certainly not in guests.
I'm keen on having big.LITTLE support in the hypervisor (thus some code
similar to your MCPM patch series will probably end up in Xen at some
point) but I doubt we'll expose big.LITTLE to guests any time soon.
It's going to be years, so I am not particularly worried about it right
now.


> Because the versatile express machine sets smp_init to
> vexpress_smp_init_ops, vexpress_smp_init_ops will be called.
> vexpress_smp_init_ops sets smp_ops to vexpress_smp_ops, that *break*
> Xen.
> 
> With this patch, xen_smp_init will be called instead of
> vexpress_smp_init_ops, and smp_ops will be set to psci_smp_ops,
> therefore *unbreaking* Xen.
> 
> In fact what makes this patch really necessary is smp_init together with
> the MCPM series.
> 
> 
> Do you agree with me?
> 
