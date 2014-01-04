Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbaADAaW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 19:30:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44570 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaADAaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 19:30:18 -0500
Date: Fri, 3 Jan 2014 16:29:04 -0800
From: Mukesh Rathor <mukesh.rathor@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 09/12] xen/pvh: Piggyback on PVHVM
 XenBus and event channels for PVH.
Message-ID: <20140103162904.5b51041f@mantra.us.oracle.com>
In-Reply-To: <alpine.DEB.2.02.1401031501180.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com>
	<1387313503-31362-10-git-send-email-konrad.wilk@oracle.com>
	<alpine.DEB.2.02.1312181827280.8667@kaball.uk.xensource.com>
	<20131231185656.GB3129@phenom.dumpdata.com>
	<alpine.DEB.2.02.1401031501180.8667@kaball.uk.xensource.com>
Organization: Oracle Corporation
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.18.9; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jan 2014 15:04:27 +0000
Stefano Stabellini <stefano.stabellini@eu.citrix.com> wrote:

> On Tue, 31 Dec 2013, Konrad Rzeszutek Wilk wrote:
> > > > --- a/drivers/xen/xenbus/xenbus_client.c
> > > > +++ b/drivers/xen/xenbus/xenbus_client.c
> > > > @@ -45,6 +45,7 @@
> > > >  #include <xen/grant_table.h>
> > > >  #include <xen/xenbus.h>
> > > >  #include <xen/xen.h>
> > > > +#include <xen/features.h>
> > > >  
> > > >  #include "xenbus_probe.h"
> > > >  
> > > > @@ -743,7 +744,7 @@ static const struct xenbus_ring_ops
> > > > ring_ops_hvm = { 
> > > >  void __init xenbus_ring_ops_init(void)
> > > >  {
> > > > -	if (xen_pv_domain())
> > > > +	if (xen_pv_domain()
> > > > && !xen_feature(XENFEAT_auto_translated_physmap))
> > > 
> > > Can we just change this test to
> > > 
> > > if (!xen_feature(XENFEAT_auto_translated_physmap))
> > > 
> > > ?
> > 
> > No. If we do then the HVM domains (which are also !auto-xlat)
> > will end up using the PV version of ring_ops.
> 
> Actually HVM guests have XENFEAT_auto_translated_physmap, so in this
> case they would get &ring_ops_hvm.

Right. Back then I was confused about all the other PV modes, like
shadow, supervisor, ... but looks like they are all obsolete. It could 
just be:

        if (!xen_feature(XENFEAT_auto_translated_physmap))
                ring_ops = &ring_ops_pv;
        else
                ring_ops = &ring_ops_hvm;

thanks,
Mukesh
