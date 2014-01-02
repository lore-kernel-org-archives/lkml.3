Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaABSY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 13:24:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19276 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870AbaABSY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 13:24:26 -0500
Date: Thu, 2 Jan 2014 13:23:12 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, stefano.stabellini@eu.citrix.com,
        mukesh.rathor@oracle.com
Subject: Re: [PATCH v12 07/18] xen/pvh: Setup up shared_info.
Message-ID: <20140102182311.GA3021@pegasus.dumpdata.com>
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
 <1388550945-25499-8-git-send-email-konrad.wilk@oracle.com>
 <52C54D3C.4050101@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52C54D3C.4050101@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 02, 2014 at 11:27:56AM +0000, David Vrabel wrote:
> On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> > From: Mukesh Rathor <mukesh.rathor@oracle.com>
> > 
> > For PVHVM the shared_info structure is provided via the same way
> > as for normal PV guests (see include/xen/interface/xen.h).
> > 
> > That is during bootup we get 'xen_start_info' via the %esi register
> > in startup_xen. Then later we extract the 'shared_info' from said
> > structure (in xen_setup_shared_info) and start using it.
> > 
> > The 'xen_setup_shared_info' is all setup to work with auto-xlat
> > guests, but there are two functions which it calls that are not:
> > xen_setup_mfn_list_list and xen_setup_vcpu_info_placement.
> > This patch modifies those to work in auto-xlat mode.
> [...]
> > --- a/arch/x86/xen/enlighten.c
> > +++ b/arch/x86/xen/enlighten.c
> > @@ -1147,8 +1147,9 @@ void xen_setup_vcpu_info_placement(void)
> >  		xen_vcpu_setup(cpu);
> >  
> >  	/* xen_vcpu_setup managed to place the vcpu_info within the
> > -	   percpu area for all cpus, so make use of it */
> > -	if (have_vcpu_info_placement) {
> > +	 * percpu area for all cpus, so make use of it. Note that for
> > +	 * PVH we want to use native IRQ mechanism. */
> > +	if (have_vcpu_info_placement && !xen_pvh_domain()) {
> >  		pv_irq_ops.save_fl = __PV_IS_CALLEE_SAVE(xen_save_fl_direct);
> >  		pv_irq_ops.restore_fl = __PV_IS_CALLEE_SAVE(xen_restore_fl_direct);
> >  		pv_irq_ops.irq_disable = __PV_IS_CALLEE_SAVE(xen_irq_disable_direct);
> 
> Should this be in a separate patch: "xen/pvh: use native irq ops"?

Good idea. Initially it was part of the event channel one, but I split
it.
> 
> David
