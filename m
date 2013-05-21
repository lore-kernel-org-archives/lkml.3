Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3EUOw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 10:52:28 -0400
Received: from smtp.citrix.com ([66.165.176.89]:33983 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754310Ab3EUOw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 10:52:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,714,1363132800"; 
   d="scan'208";a="26485104"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <will.deacon@arm.com>, <arnd@arndb.de>, <nicolas.pitre@linaro.org>,
        <Stefano.Stabellini@eu.citrix.com>, <rob.herring@calxeda.com>,
        <olof@lixom.net>, <xen-devel@lists.xensource.com>,
        Jon Medhurst <tixy@linaro.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH v11 2/2] ARM: Enable selection of SMP operations at boot time
Date: Tue, 21 May 2013 15:38:53 +0100
Message-ID: <1369147133-29729-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1305211522120.4799@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1305211522120.4799@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Medhurst <tixy@linaro.org>

Add a new 'smp_init' hook to machine_desc so platforms can specify a
function to be used to setup smp ops instead of having a statically
defined value.  The hook must return true when smp_ops are initialized.
If false the static mdesc->smp_ops will be used by default.

Add the definition of "bool" by including the linux/types.h file to
asm/mach/arch.h and make it self-contained.

Signed-off-by: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Reviewed-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 arch/arm/include/asm/mach/arch.h |    5 +++++
 arch/arm/kernel/setup.c          |   10 ++++++----
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/mach/arch.h b/arch/arm/include/asm/mach/arch.h
index 308ad7d..75bf079 100644
--- a/arch/arm/include/asm/mach/arch.h
+++ b/arch/arm/include/asm/mach/arch.h
@@ -8,6 +8,8 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/types.h>
+
 #ifndef __ASSEMBLY__
 
 struct tag;
@@ -16,8 +18,10 @@ struct pt_regs;
 struct smp_operations;
 #ifdef CONFIG_SMP
 #define smp_ops(ops) (&(ops))
+#define smp_init_ops(ops) (&(ops))
 #else
 #define smp_ops(ops) (struct smp_operations *)NULL
+#define smp_init_ops(ops) (bool (*)(void))NULL
 #endif
 
 struct machine_desc {
@@ -41,6 +45,7 @@ struct machine_desc {
 	unsigned char		reserve_lp2 :1;	/* never has lp2	*/
 	char			restart_mode;	/* default restart mode	*/
 	struct smp_operations	*smp;		/* SMP operations	*/
+	bool			(*smp_init)(void);
 	void			(*fixup)(struct tag *, char **,
 					 struct meminfo *);
 	void			(*reserve)(void);/* reserve mem blocks	*/
diff --git a/arch/arm/kernel/setup.c b/arch/arm/kernel/setup.c
index 8f7a6e9..2b3ba15 100644
--- a/arch/arm/kernel/setup.c
+++ b/arch/arm/kernel/setup.c
@@ -800,10 +800,12 @@ void __init setup_arch(char **cmdline_p)
 	psci_init();
 #ifdef CONFIG_SMP
 	if (is_smp()) {
-		if (psci_smp_available())
-			smp_set_ops(&psci_smp_ops);
-		else if (mdesc->smp)
-			smp_set_ops(mdesc->smp);
+		if (!mdesc->smp_init || !mdesc->smp_init()) {
+			if (psci_smp_available())
+				smp_set_ops(&psci_smp_ops);
+			else if (mdesc->smp)
+				smp_set_ops(mdesc->smp);
+		}
 		smp_init_cpus();
 	}
 #endif
-- 
1.7.2.5

