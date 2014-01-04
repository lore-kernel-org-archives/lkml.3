Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513AbaADAtP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:49:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:47257 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442AbaADAtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:49:13 -0500
Date: Fri, 3 Jan 2014 16:48:00 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com, jbeulich@suse.com
Subject: Re: [Xen-devel] [PATCH v11 09/12] xen/pvh: Piggyback on PVHVM
 XenBus and event channels for PVH.
Message-ID: <20140103164800.00ef581c@mantra.us.oracle.com>
In-Reply-To: <20131218211739.GD11717@phenom.dumpdata.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
	<1387313503-31362-10-git-send-email-konrad.wilk@oracle.com>
	<alpine.DEB.2.02.1312181827280.8667@kaball.uk.xensource.com>
	<20131218211739.GD11717@phenom.dumpdata.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013 16:17:39 -0500
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Wed, Dec 18, 2013 at 06:31:43PM +0000, Stefano Stabellini wrote:
> > On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > 
> > > PVH is a PV guest with a twist - there are certain things
> > > that work in it like HVM and some like PV. There is
> > > a similar mode - PVHVM where we run in HVM mode with
> > > PV code enabled - and this patch explores that.
> > > 
> > > The most notable PV interfaces are the XenBus and event channels.
> > > For PVH, we will use XenBus and event channels.
> > > 
> > > For the XenBus mechanism we piggyback on how it is done for
> > > PVHVM guests.
> > > 
> > > Ditto for the event channel mechanism - we piggyback on PVHVM -
> > > by setting up a specific vector callback and that
> > > vector ends up calling the event channel mechanism to
> > > dispatch the events as needed.
> > > 
> > > This means that from a pvops perspective, we can use
> > > native_irq_ops instead of the Xen PV specific. Albeit in the
> > > future we could support pirq_eoi_map. But that is
> > > a feature request that can be shared with PVHVM.
> > > 
> > > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > ---
> > >  arch/x86/xen/enlighten.c           | 6 ++++++
> > >  arch/x86/xen/irq.c                 | 5 ++++-
> > >  drivers/xen/events.c               | 5 +++++
> > >  drivers/xen/xenbus/xenbus_client.c | 3 ++-
> > >  4 files changed, 17 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> > > index e420613..7fceb51 100644
> > > --- a/arch/x86/xen/enlighten.c
> > > +++ b/arch/x86/xen/enlighten.c
> > > @@ -1134,6 +1134,8 @@ void xen_setup_shared_info(void)
> > >  	/* In UP this is as good a place as any to set up shared
> > > info */ xen_setup_vcpu_info_placement();
> > >  #endif
> > > +	if (xen_pvh_domain())
> > > +		return;
> > >  
> > >  	xen_setup_mfn_list_list();
> > >  }
> > 
> > This is another one of those cases where I think we would benefit
> > from introducing xen_setup_shared_info_pvh instead of adding more
> > ifs here.
> 
> Actually this one can be removed.
> 
> > 
> > 
> > > @@ -1146,6 +1148,10 @@ void xen_setup_vcpu_info_placement(void)
> > >  	for_each_possible_cpu(cpu)
> > >  		xen_vcpu_setup(cpu);
> > >  
> > > +	/* PVH always uses native IRQ ops */
> > > +	if (xen_pvh_domain())
> > > +		return;
> > > +
> > >  	/* xen_vcpu_setup managed to place the vcpu_info within
> > > the percpu area for all cpus, so make use of it */
> > >  	if (have_vcpu_info_placement) {
> > 
> > Same here?
> 
> Hmmm, I wonder if the vcpu info placement could work with PVH.

It should now (after a patch I sent while ago)... the comment implies
that PVH uses native IRQs even case of vcpu info placlement...

perhaps it would be more clear to do:

        for_each_possible_cpu(cpu)
                xen_vcpu_setup(cpu);
        /* PVH always uses native IRQ ops */
        if (have_vcpu_info_placement && !xen_pvh_domain) {
            pv_irq_ops.save_fl = __PV_IS_CALLEE_SAVE(xen_save_fl_direct);
            .........

