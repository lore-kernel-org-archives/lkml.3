Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab3C0RKd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 13:10:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42698 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751934Ab3C0RKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 13:10:31 -0400
X-IronPort-AV: E=Sophos;i="4.84,920,1355097600"; 
   d="scan'208";a="15200071"
Date: Wed, 27 Mar 2013 17:10:26 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Rob Herring <robherring2@gmail.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Will Deacon <will.deacon@arm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        "nico@linaro.org" <nico@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3] [RFC] arm: use PSCI if available
In-Reply-To: <51531FE3.8010905@gmail.com>
Message-ID: <alpine.DEB.2.02.1303271642340.4430@kaball.uk.xensource.com>
References: <1364388639-11210-1-git-send-email-stefano.stabellini@eu.citrix.com> <20130327133811.GE18429@mudshark.cambridge.arm.com> <alpine.DEB.2.02.1303271610430.4430@kaball.uk.xensource.com> <51531FE3.8010905@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Mar 2013, Rob Herring wrote:
> On 03/27/2013 11:23 AM, Stefano Stabellini wrote:
> > Would you agree on a patch that moves virt_smp_ops out of mach-virt and
> > renames them to psci_smp_ops (maybe to arch/arm/kernel/psci_smp_ops.c)?
> > 
> > Would you agree on initializing psci from setup_arch, right after the
> > call to arm_dt_init_cpu_maps()?
> > 
> > Finally the most controversial point: would you agree on using
> > psci_smp_ops by default if they are available?
> > If not, would you at least agree on letting Xen overwrite the default
> > machine smp_ops?
> > We need one or the other for dom0 support.
> 
> It should not be *always* use PSCI smp ops if available, but use them
> only if the platform does not define its own smp ops.

Well, that is the one additional problem that we have on Xen.

On x86 Xen replaces a lot of core native function calls with its own
implementations (see paravirt_ops).
On ARM we only need *one* set of calls: the smp_ops calls.

So if we don't want to give priority to PSCI over the platform smp_ops,
then we need a simple workaround just for Xen in common code like the
one appended below.
Not pretty, but at least small:

diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 3f6cbb2..08cf7e0 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -43,6 +43,8 @@
 #include <asm/cacheflush.h>
 #include <asm/cachetype.h>
 #include <asm/tlbflush.h>
+#include <xen/xen.h>
+#include <asm/xen/hypervisor.h>
 
 #include <asm/prom.h>
 #include <asm/mach/arch.h>
@@ -766,9 +768,13 @@ void __init setup_arch(char **cmdline_p)
 	unflatten_device_tree();
 
 	arm_dt_init_cpu_maps();
+	xen_early_init();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
-		smp_set_ops(mdesc->smp);
+		if (xen_domain())
+			smp_set_ops(&xen_smp_ops);
+		else
+			smp_set_ops(mdesc->smp);
 		smp_init_cpus();
 	}
 #endif
