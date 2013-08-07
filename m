Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3HGK0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 06:26:12 -0400
Received: from mail2.gnudd.com ([213.203.150.91]:56389 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932456Ab3HGK0I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 06:26:08 -0400
Date: Wed, 7 Aug 2013 12:19:31 +0200
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: linux-kernel@vger.kernel.org
Cc: rubini@gnudd.com, Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, devicetree@vger.kernel.org
Subject: [PATCH 12/26] x86 kernel apic: notify MSI irqdomain(s) on
 etup/teardown of MSI IRQs
Message-ID: <7e98fe84a1cabd344308f8fa142e2a67aa105cdc.1375867291.git.rubini@gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: GnuDD, Device Drivers, Embedded Systems, Courses
References: <cover.1375867291.git.rubini@gnudd.com>
In-Reply-To: <cover.1375867291.git.rubini@gnudd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch should have no effect on non-OF x86 machines.

When CONFIG_OF is enabled, an irqdomain exists for each MSI controller
in the devicetree. This patch invokes the functions taking care of
adding/removing IRQs numbers to/from the MSI irqdomain they belong to.

Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>
Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
---
 arch/x86/kernel/apic/io_apic.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..65db413 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -60,6 +60,7 @@
 #include <asm/irq_remapping.h>
 #include <asm/hpet.h>
 #include <asm/hw_irq.h>
+#include <asm/prom.h>
 
 #include <asm/apic.h>
 
@@ -3154,6 +3155,9 @@ int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
 		ret = setup_msi_irq(dev, msidesc, irq, 0);
 		if (ret < 0)
 			goto error;
+		ret = x86_of_new_msi_irq(dev, irq);
+		if (ret < 0)
+			goto error;
 	}
 	return 0;
 
@@ -3164,6 +3168,7 @@ error:
 
 void native_teardown_msi_irq(unsigned int irq)
 {
+	x86_of_del_msi_irq(irq);
 	destroy_irq(irq);
 }
 
-- 
1.7.7.2
