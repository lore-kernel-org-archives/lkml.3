Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324AbaAHSwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 13:52:23 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:55841 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbaAHSu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 13:50:58 -0500
X-IronPort-AV: E=Sophos;i="4.95,625,1384300800"; 
   d="scan'208";a="88846947"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <xen-devel@lists.xensource.com>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <konrad.wilk@oracle.com>, <marc.zyngier@arm.com>,
        <will.deacon@arm.com>, <Stefano.Stabellini@eu.citrix.com>,
        <Ian.Campbell@citrix.com>, <linux@arm.linux.org.uk>, <olof@lixom.net>,
        <arnd@arndb.de>, <catalin.marinas@arm.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <nico@linaro.org>, <cov@codeaurora.org>
Subject: [PATCH v8 3/6] arm: introduce CONFIG_PARAVIRT, PARAVIRT_TIME_ACCOUNTING and pv_time_ops
Date: Wed, 8 Jan 2014 18:49:55 +0000
Message-ID: <1389206998-27875-3-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1401081845040.21510@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce CONFIG_PARAVIRT and PARAVIRT_TIME_ACCOUNTING on ARM.

The only paravirt interface supported is pv_time_ops.steal_clock, so no
runtime pvops patching needed.

This allows us to make use of steal_account_process_tick for stolen
ticks accounting.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Christopher Covington <cov@codeaurora.org>
CC: linux@arm.linux.org.uk
CC: will.deacon@arm.com
CC: nico@linaro.org
CC: marc.zyngier@arm.com
CC: cov@codeaurora.org
CC: arnd@arndb.de
CC: olof@lixom.net

---

Changes in v7:
- ifdef CONFIG_PARAVIRT the content of paravirt.h.

Changes in v3:
- improve commit description and Kconfig help text;
- no need to initialize pv_time_ops;
- add PARAVIRT_TIME_ACCOUNTING.
---
 arch/arm/Kconfig         |   20 ++++++++++++++++++++
 arch/arm/kernel/Makefile |    1 +
 2 files changed, 21 insertions(+)

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index c1f1a7e..d6c3ba1 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -1874,6 +1874,25 @@ config SWIOTLB
 config IOMMU_HELPER
 	def_bool SWIOTLB
 
+config PARAVIRT
+	bool "Enable paravirtualization code"
+	---help---
+	  This changes the kernel so it can modify itself when it is run
+	  under a hypervisor, potentially improving performance significantly
+	  over full virtualization.
+
+config PARAVIRT_TIME_ACCOUNTING
+	bool "Paravirtual steal time accounting"
+	select PARAVIRT
+	default n
+	---help---
+	  Select this option to enable fine granularity task steal time
+	  accounting. Time spent executing other tasks in parallel with
+	  the current vCPU is discounted from the vCPU power. To account for
+	  that, there can be a small performance impact.
+
+	  If in doubt, say N here.
+
 config XEN_DOM0
 	def_bool y
 	depends on XEN
@@ -1885,6 +1904,7 @@ config XEN
 	depends on !GENERIC_ATOMIC64
 	select ARM_PSCI
 	select SWIOTLB_XEN
+	select PARAVIRT
 	help
 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
 
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index a30fc9b..bcd2b38 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -87,6 +87,7 @@ obj-$(CONFIG_ARM_CPU_TOPOLOGY)  += topology.o
 ifneq ($(CONFIG_ARCH_EBSA110),y)
   obj-y		+= io.o
 endif
+obj-$(CONFIG_PARAVIRT)	+= paravirt.o
 
 head-y			:= head$(MMUEXT).o
 obj-$(CONFIG_DEBUG_LL)	+= debug.o
-- 
1.7.10.4

