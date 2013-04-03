Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761261Ab3DCL2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 07:28:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:3696 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760840Ab3DCL2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 07:28:37 -0400
X-IronPort-AV: E=Sophos;i="4.87,401,1363132800"; 
   d="scan'208";a="16384639"
Date: Wed, 3 Apr 2013 12:28:31 +0100
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
In-Reply-To: <alpine.LFD.2.03.1304021325230.1171@syhkavp.arg>
Message-ID: <alpine.DEB.2.02.1304031217310.5078@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304021700380.5078@kaball.uk.xensource.com> <1364919374-7836-3-git-send-email-stefano.stabellini@eu.citrix.com> <alpine.LFD.2.03.1304021325230.1171@syhkavp.arg>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Nicolas Pitre wrote:
> On Tue, 2 Apr 2013, Stefano Stabellini wrote:
> 
> > Split xen_guest_init in two functions, one of them (xen_early_init) is
> > going to be called very early from setup_arch.
> > 
> > Change machine_desc->smp_init to xen_smp_init if Xen is present on the
> > platform. xen_smp_init just sets smp_ops to psci_smp_ops.
> > 
> > Introduce a dependency for ARM_PSCI in XEN.
> 
> The Kconfig stuff should be more understandable to "normal" users 
> configuring the kernel.  Hence it might make more sense for Xen to 
> select PSCI rather than making it a prerequisite.

You are right, I'll do that.


> [...]
> > @@ -176,27 +178,30 @@ static int __init xen_secondary_init(unsigned int cpu)
> >  	return 0;
> >  }
> >  
> > +static void __init xen_smp_init(void)
> > +{
> > +	if (psci_smp_available())
> > +		smp_set_ops(&psci_smp_ops);
> > +}
> > +
> 
> I still don't understand why you need to do this.  Why can't you just 
> rely on the next priority which is to set PSCI ops by default if 
> available?  Using this hook for Xen doesn't look justified. As it is, 
> you break MCPM.
> 
> As I explained to you, MCPM will end up using PSCI as well when 
> available, which I think should be sufficient for your concern.

The smp_init hook is not limited to MCPM or the versatile express
platform. It's a generic hook that can be used by any platform and can
override the platform smp_ops or the psci_smp_ops depending on platform
specific configurations.

Configurations that I am pretty sure won't be available on Xen anyway,
while I am certain that using psci_smp_ops would work.

It seems to me that relying on the fact that only versatile express and
only MCPM use smp_init, even though it might work today, it's very
fragile and could break tomorrow without any of us noticing.
