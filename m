Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967525Ab3DRQUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:20:38 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:28996 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965490Ab3DRQUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:20:36 -0400
X-IronPort-AV: E=Sophos;i="4.87,502,1363132800"; 
   d="scan'208";a="19278221"
Date: Thu, 18 Apr 2013 17:20:23 +0100
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
In-Reply-To: <20130418161341.GB14496@n2100.arm.linux.org.uk>
Message-ID: <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Russell King - ARM Linux wrote:
> On Fri, Apr 05, 2013 at 02:11:32PM +0100, Stefano Stabellini wrote:
> > +	psci_init();
> >  #ifdef CONFIG_SMP
> >  	if (is_smp()) {
> > -		smp_set_ops(mdesc->smp);
> > +		if (mdesc->smp)
> > +			smp_set_ops(mdesc->smp);
> > +		else if (psci_smp_available())
> > +			smp_set_ops(&psci_smp_ops);
> 
> So, I have a vague recollection that the ordering of the above got discussed
> but I can't find it amongst the 21k of messages so far this year.
> 
> The above looks weird to me.  Surely this should be:
> 
> 		if (psci_smp_available())
> 			smp_set_ops(&psci_smp_ops);
> 		else if (mdesc->smp)
> 			smp_set_ops(mdesc->ops);
> 
> This means that if PSCI is available, and provides a set of operations,
> we override whatever the platform has statically provided.
> 
> Remember, we're trying to move away from using "mdesc"s for platform
> stuff, relying on things like DT and such like.  We really should not
> be going for mdesc-overriding-newstuff but newstuff-overriding-mdesc.

That's correct, in fact if you look at the next patch you'll see that it
changes the order.

I introduced the mechanism first and changed the priority later - it
should help bisectability.
I can fold the two patches into one if you prefer.


> Now, if the psci stuff can't be relied upon to provide the correct
> functionality, then that's a separate problem which needs addressing
> differently.
> 
> This should allow the Xen problem to be resolved, because Xen will
> provide the PSCI operations, and it's correct in that case to override
> the platform's SMP operations.

Yes, increasing the priority of PSCI helps Xen a lot.
In order to completely solve the issue for Xen though, another patch is
needed (http://marc.info/?l=linux-kernel&m=136630106201968&w=2) because
of the introduction of smp_init.

