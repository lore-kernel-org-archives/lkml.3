Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbaABSvh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:51:37 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:29681 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbaABSvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:51:33 -0500
Date: Thu, 2 Jan 2014 13:50:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 15/18] xen/pvh: Piggyback on PVHVM for grant driver
 (v2)
Message-ID: <20140102185023.GG3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-16-git-send-email-konrad.wilk@oracle.com>
 <52C59483.5030607@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C59483.5030607@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 04:32:03PM +0000, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > In PVH the shared grant frame is the PFN and not MFN,
> > hence its mapped via the same code path as HVM.
> > 
> > The allocation of the grant frame is done differently - we
> > do not use the early platform-pci driver and have an
> > ioremap area - instead we use balloon memory and stitch
> > all of the non-contingous pages in a virtualized area.
> > 
> > That means when we call the hypervisor to replace the GMFN
> > with a XENMAPSPACE_grant_table type, we need to lookup the
> > old PFN for every iteration instead of assuming a flat
> > contingous PFN allocation.
> > 
> > Lastly, we only use v1 for grants. This is because PVHVM
> > is not able to use v2 due to no XENMEM_add_to_physmap
> > calls on the error status page (see commit
> > 69e8f430e243d657c2053f097efebc2e2cd559f0
> >  xen/granttable: Disable grant v2 for HVM domains.)
> > 
> > Until that is implemented this workaround has to
> > be in place.
> > 
> > Also per suggestions by Stefano utilize the PVHVM paths
> > as they share common functionality.
> > 
> > v2 of this patch moves most of the PVH code out in the
> > arch/x86/xen/grant-table driver and touches only minimally
> > the generic driver.
> [...]
> > --- a/arch/x86/xen/grant-table.c
> > +++ b/arch/x86/xen/grant-table.c
> [...]
> > +static int __init xen_pvh_gnttab_setup(void)
> > +{
> > +	if (!xen_domain())
> > +		return -ENODEV;
> > +
> > +	if (!xen_pv_domain())
> > +		return -ENODEV;
> > +
> > +	if (!xen_feature(XENFEAT_auto_translated_physmap))
> > +		return -ENODEV;
> 
> Replace all these with if (!xen_pvh_domain()) ?

Yes.
> 
> > @@ -1320,4 +1323,4 @@ static int __gnttab_init(void)
> >  	return gnttab_init();
> >  }
> >  
> > -core_initcall(__gnttab_init);
> > +core_initcall_sync(__gnttab_init);
> 
> Why has this become _sync?

It needs to run _after_ the xen_pvh_gnttab_setup has run (which is
at gnttab_init):

+core_initcall(xen_pvh_gnttab_setup); /* Call it _before_ __gnttab_init */

Otherwise __gnttab_init will try to use the xen_auto_xlat_grant_frames
that has not yet xen_pvh_gnttab_setup setup.

Do you think I should: a) expand the comment in 'xen_pvh_gnttab_setup'
to mention this, or b) put it in the commit description, or c) what is
there is OK?
> 
> David
> 
