Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875AbaABSde (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:33:34 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:24768 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752294AbaABSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:33:32 -0500
Date: Thu, 2 Jan 2014 13:32:21 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 03/18] xen/pvh: Early bootup changes in PV code (v2).
Message-ID: <20140102183221.GD3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-4-git-send-email-konrad.wilk@oracle.com>
 <52C58691.4040502@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C58691.4040502@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 03:32:33PM +0000, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > In the bootup code for PVH we can trap cpuid via vmexit, so don't
> > need to use emulated prefix call. We also check for vector callback
> > early on, as it is a required feature. PVH also runs at default kernel
> > IOPL.
> > 
> > Finally, pure PV settings are moved to a separate function that are
> > only called for pure PV, ie, pv with pvmmu. They are also #ifdef
> > with CONFIG_XEN_PVMMU.
> [...]
> > @@ -331,12 +333,15 @@ static void xen_cpuid(unsigned int *ax, unsigned int *bx,
> >  		break;
> >  	}
> >  
> > -	asm(XEN_EMULATE_PREFIX "cpuid"
> > -		: "=a" (*ax),
> > -		  "=b" (*bx),
> > -		  "=c" (*cx),
> > -		  "=d" (*dx)
> > -		: "0" (*ax), "2" (*cx));
> > +	if (xen_pvh_domain())
> > +		native_cpuid(ax, bx, cx, dx);
> > +	else
> > +		asm(XEN_EMULATE_PREFIX "cpuid"
> > +			: "=a" (*ax),
> > +			"=b" (*bx),
> > +			"=c" (*cx),
> > +			"=d" (*dx)
> > +			: "0" (*ax), "2" (*cx));
> 
> For this one off cpuid call it seems preferrable to me to use the
> emulate prefix rather than diverge from PV.

This was before the PV cpuid was deemed OK to be used on PVH.
Will rip this out to use the same version.

> 
> > @@ -1431,13 +1449,18 @@ asmlinkage void __init xen_start_kernel(void)
> >  
> >  	xen_domain_type = XEN_PV_DOMAIN;
> >  
> > +	xen_setup_features();
> > +	xen_pvh_early_guest_init();
> >  	xen_setup_machphys_mapping();
> >  
> >  	/* Install Xen paravirt ops */
> >  	pv_info = xen_info;
> >  	pv_init_ops = xen_init_ops;
> > -	pv_cpu_ops = xen_cpu_ops;
> >  	pv_apic_ops = xen_apic_ops;
> > +	if (xen_pvh_domain())
> > +		pv_cpu_ops.cpuid = xen_cpuid;
> > +	else
> > +		pv_cpu_ops = xen_cpu_ops;
> 
> If cpuid is trapped for PVH guests why does PVH need non-native cpuid op?

There are a couple of filtering done on the cpuid. But with HVM I am
not entirely sure if it is worth preserving those or not.

My fear is that if we switch over to the native one without the
filtering that the kernel does we open up a can of worms that had been
closed in the past. The reason is that for dom0 - there is no cpuid
filtering being done. So it gets everything that the hypervisor sees.

Which we don't want to do for APERF (b/c the generic scheduler code will
try to do those MSRs), and then there is the ACPI extended C-states.

Perhaps a better thing is just to still have the xen_cpuid but
but a big comment saying: "/* We should use native, but we need to
filter some cpuid's out. TODO */

?
> 
> David
