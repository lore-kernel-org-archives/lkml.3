Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245Ab3DVOGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 10:06:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36280 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660Ab3DVOGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 10:06:18 -0400
Date: Mon, 22 Apr 2013 15:06:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
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
Message-ID: <20130422140601.GH14496@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1304031239550.5078@kaball.uk.xensource.com> <1365167495-18508-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130418161341.GB14496@n2100.arm.linux.org.uk> <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1304181714560.7254@kaball.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 05:20:23PM +0100, Stefano Stabellini wrote:
> On Thu, 18 Apr 2013, Russell King - ARM Linux wrote:
> > Remember, we're trying to move away from using "mdesc"s for platform
> > stuff, relying on things like DT and such like.  We really should not
> > be going for mdesc-overriding-newstuff but newstuff-overriding-mdesc.
> 
> That's correct, in fact if you look at the next patch you'll see that it
> changes the order.

You may have noticed that I've been catching up with email, and it's
exceedingly difficult to track what patches are obsolete and have been
overridden by new versions.

> I introduced the mechanism first and changed the priority later - it
> should help bisectability.
> I can fold the two patches into one if you prefer.

On the face of it, I think that would be better.  I don't remember what
your last version looks like though.

> > Now, if the psci stuff can't be relied upon to provide the correct
> > functionality, then that's a separate problem which needs addressing
> > differently.
> > 
> > This should allow the Xen problem to be resolved, because Xen will
> > provide the PSCI operations, and it's correct in that case to override
> > the platform's SMP operations.
> 
> Yes, increasing the priority of PSCI helps Xen a lot.
> In order to completely solve the issue for Xen though, another patch is
> needed (http://marc.info/?l=linux-kernel&m=136630106201968&w=2) because
> of the introduction of smp_init.

Given the way the code in setup.c will work:

+static bool __init xen_smp_init(void)
+{
+#ifdef CONFIG_SMP
+	/* If we are running on Xen, use PSCI if available.
+	 * In any case do not try to use the native smp_ops. */
+	if (psci_smp_available())
+		smp_set_ops(&psci_smp_ops);
+#endif
+	return true;
+}

Doesn't this just need to return false, and then we'll drop down to
using PSCI if those operations are available?
