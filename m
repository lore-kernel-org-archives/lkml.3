Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3AaQse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 11:48:34 -0500
Received: from nat-pool-12-rdu.redhat.com ([66.187.233.206]:55505 "EHLO
	intel-canoepass-08.lab.bos.redhat.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752485Ab3AaQs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 11:48:29 -0500
X-Greylist: delayed 462 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2013 11:48:29 EST
From: Don Zickus <dzickus@redhat.com>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Prarit Bhargava <prarit@redhat.com>
Subject: [PATCH] x86, x2apic: Only WARN on broken BIOSes inside a virtual guest
Date: Thu, 31 Jan 2013 11:40:35 -0500
Message-Id: <1359650435-73586-1-git-send-email-dzickus@redhat.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit "41750d3 x86, x2apic: Enable the bios request for x2apic optout"
it was explained how OEMs are trying to opt out of using x2apics.

That commit moved code around and screamed with a WARN if the BIOS
opted out of x2apic mode.  Fair enough.

This code hit our RHEL distro and OEMs started complaining that the
WARN is scaring their customers and asked we tone it down to a
pr_warn().

Before we did that, we thought we should change it upstream too.
Upstream complained that WARN was necessary due to a serious
security threat, namely irq injections.  Hard to argue that.

This left us between a rock and a hard place.  We toned down the
WARN in RHEL to keep our customers happy.  But this leaves us with
a perpetual patch in RHEL and possibly covering up a security threat.

I poked around to understand the nature of the security threat and why
OEMs would want to leave themselves vulnerable.  The only security
threat I could find was this whitepaper talking about Xen and irq
injections:

http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf

After talking with folks, the threat of irq injections on virtual guests
made sense.  However, when discussing if this was possible on bare metal
machines, we could not come up with a plausible scenario.

Talking with OEMs, it seems like opting out of x2apic only happens on
bare metal as virtual guests seem to have their own bioses.

Unless irq injections can happen on bare metal too, I am proposing a
tweak in the WARN code.  I am breaking the printk into two pieces.

The first is the loud BIOS disabled x2apic message, but at a printk level
instead of a WARN.  Our OEMs are ok with that.

The second is the security threat of irq injections.  The code now
only WARNs when it detects itself on a virtual machine using x86_hyper.

The hypervisor is configured through setup_arch(), which is run before
the irqs are configured through smp_prepare_boot_cpu(), so this variable
should always be defined correctly.

I tested this on a Dell machine that has x2apic disabled and on an
Intel box that had x2apic enabled.  Everything looked as expected. I
couldn't figure out how to test a virtual guest setup to verify the WARN
works as expected.

Cc: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 drivers/iommu/intel_irq_remapping.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index af8904d..f639906 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -14,6 +14,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/pci-direct.h>
 #include <asm/msidef.h>
+#include <asm/hypervisor.h>
 
 #include "irq_remapping.h"
 
@@ -536,10 +537,13 @@ static int __init intel_enable_irq_remapping(void)
 
 	if (x2apic_supported()) {
 		eim = !dmar_x2apic_optout();
-		WARN(!eim, KERN_WARNING
+		if (!eim) {
+			printk(KERN_WARNING
 			   "Your BIOS is broken and requested that x2apic be disabled\n"
-			   "This will leave your machine vulnerable to irq-injection attacks\n"
 			   "Use 'intremap=no_x2apic_optout' to override BIOS request\n");
+			WARN(x86_hyper,
+			   "This will leave your machine vulnerable to irq-injection attacks\n");
+		}
 	}
 
 	for_each_drhd_unit(drhd) {
-- 
1.7.1

