Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759687Ab3DZKd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 06:33:57 -0400
Received: from smtp.citrix.com ([66.165.176.89]:30626 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215Ab3DZKd4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 06:33:56 -0400
X-IronPort-AV: E=Sophos;i="4.87,557,1363132800"; 
   d="scan'208";a="21763089"
Date: Fri, 26 Apr 2013 11:33:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>
Subject: Re: [PATCH v4 2/7] xen/arm: SMP support
In-Reply-To: <1366972256.3142.60.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1304261132470.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304242012590.4180@kaball.uk.xensource.com>  <1366831695-13214-2-git-send-email-stefano.stabellini@eu.citrix.com>  <1366897221.20256.544.camel@zakaz.uk.xensource.com>  <alpine.DEB.2.02.1304251503100.4180@kaball.uk.xensource.com>
  <1366909184.3142.0.camel@zakaz.uk.xensource.com>  <alpine.DEB.2.02.1304251945290.4180@kaball.uk.xensource.com>  <1366966304.3142.33.camel@zakaz.uk.xensource.com>  <alpine.DEB.2.02.1304261125440.4180@kaball.uk.xensource.com>
 <1366972256.3142.60.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Apr 2013, Ian Campbell wrote:
> On Fri, 2013-04-26 at 11:27 +0100, Stefano Stabellini wrote:
> > On Fri, 26 Apr 2013, Ian Campbell wrote:
> > > On Thu, 2013-04-25 at 19:45 +0100, Stefano Stabellini wrote:
> > > > On Thu, 25 Apr 2013, Ian Campbell wrote:
> > > > > > > > @@ -216,6 +245,8 @@ static int __init xen_guest_init(void)
> > > > > > > >  	 * is required to use VCPUOP_register_vcpu_info to place vcpu info
> > > > > > > >  	 * for secondary CPUs as they are brought up. */
> > > > > > > >  	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> > > > > > > > +	for_each_online_cpu(i)
> > > > > > > > +		xen_secondary_init(i);
> > > > > > > >  
> > > > > > > >  	gnttab_init();
> > > > > > > >  	if (!xen_initial_domain())
> > > > > > > [...]
> > > > > > > > @@ -244,7 +280,7 @@ static int __init xen_init_events(void)
> > > > > > > >  		return -EINVAL;
> > > > > > > >  	}
> > > > > > > >  
> > > > > > > > -	enable_percpu_irq(xen_events_irq, 0);
> > > > > > > > +	on_each_cpu(xen_percpu_enable_events, NULL, 0);
> > > > > > > 
> > > > > > > It feels like there ought to be some sort of per-cpu bringup callback
> > > > > > > which takes care of these dynamically. Maybe that doesn't matter until
> > > > > > > we get vcpu hotplug going?
> > > > > > 
> > > > > > I suspect there isn't one, considering that on_each_cpu is also used by 
> > > > > > kvm_vgic_hyp_init, kvm_timer_hyp_init and others.
> > > > > 
> > > > > Could we use cpu_notifiers for this?
> > > > 
> > > > cpu_notifiers are for cpu hotplug, not for secondary cpu bringup
> > > 
> > > Are you sure they don't also trigger during bringup, because the
> > > distinction is a little bit academic...
> > 
> > My mistake, they do run on secondary cpus, but not in our case because
> > xen_guest_init is called *after* cpu_notifiers are called.
> > So, they are too early for Xen.
> 
> Another reason to consider calling xen_guest_init much earlier then
> IMHO. although we can live with the solution you have now I suppose.

Yeah, moving the call to xen_guest_init earlier might be a good idea,
but I wouldn't want to do it in this patch series, at this point of the
Linux release cycle.
