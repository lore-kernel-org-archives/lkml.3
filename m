Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755233Ab3LROzi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:55:38 -0500
Received: from smtp.citrix.com ([66.165.176.89]:36565 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754693Ab3LROzh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:55:37 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85760824"
Date: Wed, 18 Dec 2013 14:55:03 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <david.vrabel@citrix.com>,
        <jbeulich@suse.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH v11 02/12] xen/pvh: Define what an PVH guest
 is.
In-Reply-To: <alpine.DEB.2.02.1312181421260.8667@kaball.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1312181453110.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-3-git-send-email-konrad.wilk@oracle.com> <alpine.DEB.2.02.1312181421260.8667@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 18 Dec 2013, Stefano Stabellini wrote:
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

On second thought, given that it is just temporary and that PVHVM is not
defined on ARM, it could be OK. But maybe it is worth adding a small
comment on the fact that this is an x86-only option.


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
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
