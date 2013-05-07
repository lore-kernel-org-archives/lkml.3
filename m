Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab3EGNuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 09:50:16 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7508 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932223Ab3EGNuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 09:50:13 -0400
X-IronPort-AV: E=Sophos;i="4.87,628,1363132800"; 
   d="scan'208";a="22611915"
Date: Tue, 7 May 2013 14:49:46 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <Ian.Campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH RFC v2 4/4] xen/arm: account for stolen
 ticks
In-Reply-To: <1367931401.26321.118.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.DEB.2.02.1305071448390.4147@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305061532310.4756@kaball.uk.xensource.com>  <1367851878-21629-4-git-send-email-stefano.stabellini@eu.citrix.com>  <1367918270.26321.39.camel@zakaz.uk.xensource.com>  <alpine.DEB.2.02.1305071252350.4147@kaball.uk.xensource.com>
 <1367931401.26321.118.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 May 2013, Ian Campbell wrote:
> > > > @@ -301,6 +320,10 @@ static int __init xen_init_events(void)
> > > >  
> > > >  	on_each_cpu(xen_percpu_init, NULL, 0);
> > > >  
> > > > +	pv_time_ops.steal_clock = xen_stolen_accounting;
> > > > +	static_key_slow_inc(&paravirt_steal_enabled);
> > > > +	static_key_slow_inc(&paravirt_steal_rq_enabled);
> > > 
> > > We don't seem to do this on x86 -- is that a bug on x86 on Xen?
> > 
> > On x86 we do all the accounting in do_stolen_accounting, called from our
> > own interrupt handler (xen_timer_interrupt).
> > I don't think we would gain anything by using the common infrastructure,
> > we would actually loose the idle ticks accounting we do there.
> > 
> > Speaking of which, I don't think that pv_time_ops.steal_clock would
> > properly increase CPUTIME_IDLE the way we do in do_stolen_accounting.
> > 
> > How much of an issue is that?
> 
> Doesn't the generic account_idle_time handle this?

AFAICT only if the rq is idle, while do_stolen_accounting would account
for ticks in RUNSTATE_blocked
