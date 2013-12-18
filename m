Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129Ab3LRO7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:59:06 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:23810 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab3LRO7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:59:04 -0500
Date: Wed, 18 Dec 2013 09:57:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        mukesh.rathor@oracle.com, jbeulich@suse.com
Subject: Re: [Xen-devel] [PATCH v11 02/12] xen/pvh: Define what an PVH guest
 is.
Message-ID: <20131218145754.GB4934@phenom.dumpdata.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
 <1387313503-31362-3-git-send-email-konrad.wilk@oracle.com>
 <alpine.DEB.2.02.1312181421260.8667@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1312181421260.8667@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 02:22:35PM +0000, Stefano Stabellini wrote:
> On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > Which is a PV guest with auto page translation enabled
> > and with vector callback. It is a cross between PVHVM and PV.
> > 
> > The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
> > with modifications):
> > 
> > "* the guest uses auto translate:
> >  - p2m is managed by Xen
> >  - pagetables are owned by the guest
> >  - mmu_update hypercall not available
> > * it uses event callback and not vlapic emulation,
> > * IDT is native, so set_trap_table hcall is also N/A for a PVH guest.
> > 
> > For a full list of hcalls supported for PVH, see pvh_hypercall64_table
> > in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
> > PV guest with auto translate, although it does use hvm_op for setting
> > callback vector."
> > 
> > We don't have yet a Kconfig entry setup as we do not
> > have all the parts ready for it - so we piggyback
> > on the PVHVM config option. This scaffolding will
> > be removed later.
> > 
> > Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Could you please add an "&& CONFIG_X86"?

I think that CONFIG_XEN_PVHVM is only X86 anyhow.

And the XEN_PVH is going to be X86 as well - so it would always
be turned off on ARM.

I can of course add it in - but it might not neccessary?
> 
> 
> >  include/xen/xen.h | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> > 
> > diff --git a/include/xen/xen.h b/include/xen/xen.h
> > index a74d436..1d6a237 100644
> > --- a/include/xen/xen.h
> > +++ b/include/xen/xen.h
> > @@ -29,4 +29,13 @@ extern enum xen_domain_type xen_domain_type;
> >  #define xen_initial_domain()	(0)
> >  #endif	/* CONFIG_XEN_DOM0 */
> >  
> > +#ifdef CONFIG_XEN_PVHVM
> > +/* Temporarily under XEN_PVHVM, but will be under CONFIG_XEN_PVH */
> > +#include <xen/features.h>
> > +#define xen_pvh_domain() (xen_pv_domain() && \
> > +			  xen_feature(XENFEAT_auto_translated_physmap) && \
> > +			  xen_have_vector_callback)
> > +#else
> > +#define xen_pvh_domain()	(0)
> > +#endif
> >  #endif	/* _XEN_XEN_H */
> > -- 
> > 1.8.3.1
> > 
> > 
> > _______________________________________________
> > Xen-devel mailing list
> > Xen-devel@lists.xen.org
> > http://lists.xen.org/xen-devel
> > 
