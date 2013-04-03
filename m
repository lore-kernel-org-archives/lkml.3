Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3DCOrQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 10:47:16 -0400
Received: from smtp.citrix.com ([66.165.176.89]:39762 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761228Ab3DCOrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 10:47:14 -0400
X-IronPort-AV: E=Sophos;i="4.87,402,1363132800"; 
   d="scan'208";a="17237765"
Date: Wed, 3 Apr 2013 15:47:08 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Will Deacon <will.deacon@arm.com>, Arnd Bergmann <arnd@arndb.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>
Subject: Re: [PATCH v5 3/3] xen/arm: introduce xen_early_init, use PSCI on
 xen
In-Reply-To: <alpine.LFD.2.03.1304030955180.1171@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1304031525550.5078@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com> <1364919374-7836-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1304021325230.1171@syhkavp.arg> <alpine.DEB.2.02.1304031217310.5078@kaball.uk.xensource.com>
 <alpine.LFD.2.03.1304030955180.1171@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013, Nicolas Pitre wrote:
> On Wed, 3 Apr 2013, Stefano Stabellini wrote:
> 
> > On Tue, 2 Apr 2013, Nicolas Pitre wrote:
> > > On Tue, 2 Apr 2013, Stefano Stabellini wrote:
> > > 
> > > > @@ -176,27 +178,30 @@ static int __init xen_secondary_init(unsigned int cpu)
> > > >  	return 0;
> > > >  }
> > > >  
> > > > +static void __init xen_smp_init(void)
> > > > +{
> > > > +	if (psci_smp_available())
> > > > +		smp_set_ops(&psci_smp_ops);
> > > > +}
> > > > +
> > > 
> > > I still don't understand why you need to do this.  Why can't you just 
> > > rely on the next priority which is to set PSCI ops by default if 
> > > available?  Using this hook for Xen doesn't look justified. As it is, 
> > > you break MCPM.
> > > 
> > > As I explained to you, MCPM will end up using PSCI as well when 
> > > available, which I think should be sufficient for your concern.
> > 
> > The smp_init hook is not limited to MCPM or the versatile express
> > platform. It's a generic hook that can be used by any platform and can
> > override the platform smp_ops or the psci_smp_ops depending on platform
> > specific configurations.
> > 
> > Configurations that I am pretty sure won't be available on Xen anyway,
> > while I am certain that using psci_smp_ops would work.
> > 
> > It seems to me that relying on the fact that only versatile express and
> > only MCPM use smp_init, even though it might work today, it's very
> > fragile and could break tomorrow without any of us noticing.
> 
> I claim: this breaks MCPM today.
>
> You claim: the alternative _could_ break with Xen tomorrow.
> 
> Could we please wait until there is an actual problem with Xen before 
> being overly defensive in the code?

Sorry, I realized that I should have explained myself better.

The smp_init patch together with the MCPM patch series
(http://marc.info/?l=linux-arm-kernel&m=136004188122492) breaks Xen Dom0
SMP support on versatile express *today* (ifndef CONFIG_CLUSTER_PM):
smp_init is not NULL on versatile express anymore therefore smp_init is
going to be called, causing vexpress_smp_ops to be selected even if psci
is on device tree.

On the other hand if this patch was applied, xen_smp_init would override
smp_init making sure that psci_smp_ops is used on Xen and everything
would work as expected.


So as it stands today, we need this patch for regular Xen Dom0 SMP
support.


BTW I have actually tried it on my versatile express machine to make
sure that it is correct :)
