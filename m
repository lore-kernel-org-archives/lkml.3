Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757053Ab3DXSZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 14:25:34 -0400
Received: from smtp.citrix.com ([66.165.176.89]:25737 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756298Ab3DXSZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 14:25:33 -0400
X-IronPort-AV: E=Sophos;i="4.87,545,1363132800"; 
   d="scan'208";a="21366116"
Date: Wed, 24 Apr 2013 19:25:29 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "will.deacon@arm.com" <will.deacon@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "nico@linaro.org" <nico@linaro.org>
Subject: Re: [PATCH v6 1/4] arm: introduce psci_smp_ops
In-Reply-To: <20130422140601.GH14496@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1304241913280.4180@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
 <20130422140601.GH14496@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Apr 2013, Russell King - ARM Linux wrote:
> > > Now, if the psci stuff can't be relied upon to provide the correct
> > > functionality, then that's a separate problem which needs addressing
> > > differently.
> > > 
> > > This should allow the Xen problem to be resolved, because Xen will
> > > provide the PSCI operations, and it's correct in that case to override
> > > the platform's SMP operations.
> > 
> > Yes, increasing the priority of PSCI helps Xen a lot.
> > In order to completely solve the issue for Xen though, another patch is
> > needed (http://marc.info/?l=linux-kernel&m=136630106201968&w=2) because
> > of the introduction of smp_init.
> 
> Given the way the code in setup.c will work:
> 
> +static bool __init xen_smp_init(void)
> +{
> +#ifdef CONFIG_SMP
> +	/* If we are running on Xen, use PSCI if available.
> +	 * In any case do not try to use the native smp_ops. */
> +	if (psci_smp_available())
> +		smp_set_ops(&psci_smp_ops);
> +#endif
> +	return true;
> +}
> 
> Doesn't this just need to return false, and then we'll drop down to
> using PSCI if those operations are available?

If we are running on Xen, we are sure that the only available mechanism
to boot secondary cpus is PSCI; there is no need to try anything else if
that one is not available. This is way xen_smp_init is returning true
unconditionally.

However I am going to drop the "xen/arm: introduce xen_early_init, use
PSCI on xen" patch linked above entirely, because I'll just assume that
if we are running on Xen smp_init is going to fail and return false. The
next option on the list is PSCI so in theory we won't have to do
anything special to make it work.
