Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaAERTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 12:19:11 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:65361 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbaAERTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 12:19:10 -0500
X-IronPort-AV: E=Sophos;i="4.95,607,1384300800"; 
   d="scan'208";a="87710243"
Date: Sun, 5 Jan 2014 17:18:19 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Mukesh Rathor <mukesh.rathor@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 09/12] xen/pvh: Piggyback on PVHVM XenBus
 and event channels for PVH.
In-Reply-To: <20140103164800.00ef581c@mantra.us.oracle.com>
Message-ID: <alpine.DEB.2.02.1401051718020.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-10-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181827280.8667@kaball.uk.xensource.com> <20131218211739.GD11717@phenom.dumpdata.com>
 <20140103164800.00ef581c@mantra.us.oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014, Mukesh Rathor wrote:
> On Wed, 18 Dec 2013 16:17:39 -0500
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > On Wed, Dec 18, 2013 at 06:31:43PM +0000, Stefano Stabellini wrote:
> > > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > 
> > > > PVH is a PV guest with a twist - there are certain things
> > > > that work in it like HVM and some like PV. There is
> > > > a similar mode - PVHVM where we run in HVM mode with
> > > > PV code enabled - and this patch explores that.
> > > > 
> > > > The most notable PV interfaces are the XenBus and event channels.
> > > > For PVH, we will use XenBus and event channels.
> > > > 
> > > > For the XenBus mechanism we piggyback on how it is done for
> > > > PVHVM guests.
> > > > 
> > > > Ditto for the event channel mechanism - we piggyback on PVHVM -
> > > > by setting up a specific vector callback and that
> > > > vector ends up calling the event channel mechanism to
> > > > dispatch the events as needed.
> > > > 
> > > > This means that from a pvops perspective, we can use
> > > > native_irq_ops instead of the Xen PV specific. Albeit in the
> > > > future we could support pirq_eoi_map. But that is
> > > > a feature request that can be shared with PVHVM.
> > > > 
> > > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > > ---
> > > >  arch/x86/xen/enlighten.c           | 6 ++++++
> > > >  arch/x86/xen/irq.c                 | 5 ++++-
> > > >  drivers/xen/events.c               | 5 +++++
> > > >  drivers/xen/xenbus/xenbus_client.c | 3 ++-
> > > >  4 files changed, 17 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > > > index e420613..7fceb51 100644
> > > > --- a/arch/x86/xen/enlighten.c
> > > > +++ b/arch/x86/xen/enlighten.c
> > > > @@ -1134,6 +1134,8 @@ void xen_setup_shared_info(void)
> > > >  	/* In UP this is as good a place as any to set up shared
> > > > info */ xen_setup_vcpu_info_placement();
> > > >  #endif
> > > > +	if (xen_pvh_domain())
> > > > +		return;
> > > >  
> > > >  	xen_setup_mfn_list_list();
> > > >  }
> > > 
> > > This is another one of those cases where I think we would benefit
> > > from introducing xen_setup_shared_info_pvh instead of adding more
> > > ifs here.
> > 
> > Actually this one can be removed.
> > 
> > > 
> > > 
> > > > @@ -1146,6 +1148,10 @@ void xen_setup_vcpu_info_placement(void)
> > > >  	for_each_possible_cpu(cpu)
> > > >  		xen_vcpu_setup(cpu);
> > > >  
> > > > +	/* PVH always uses native IRQ ops */
> > > > +	if (xen_pvh_domain())
> > > > +		return;
> > > > +
> > > >  	/* xen_vcpu_setup managed to place the vcpu_info within
> > > > the percpu area for all cpus, so make use of it */
> > > >  	if (have_vcpu_info_placement) {
> > > 
> > > Same here?
> > 
> > Hmmm, I wonder if the vcpu info placement could work with PVH.
> 
> It should now (after a patch I sent while ago)... the comment implies
> that PVH uses native IRQs even case of vcpu info placlement...
> 
> perhaps it would be more clear to do:
> 
>         for_each_possible_cpu(cpu)
>                 xen_vcpu_setup(cpu);
>         /* PVH always uses native IRQ ops */
>         if (have_vcpu_info_placement && !xen_pvh_domain) {
>             pv_irq_ops.save_fl = __PV_IS_CALLEE_SAVE(xen_save_fl_direct);
>             .........

Yeah, this looks better
