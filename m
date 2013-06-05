Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154Ab3FEMQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 08:16:39 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:43345 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754629Ab3FEMPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 08:15:43 -0400
X-IronPort-AV: E=Sophos;i="4.87,806,1363132800"; 
   d="scan'208";a="27976488"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xensource.com>,
        <Stefano.Stabellini@eu.citrix.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <Ian.Campbell@citrix.com>,
        <konrad.wilk@oracle.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v3 2/6] arm64/xen: introduce asm/xen header files on arm64
Date: Wed, 5 Jun 2013 13:15:26 +0100
Message-ID: <1370434530-22428-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1306041712100.4589@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

asm/xen/hypercall.h, asm/xen/hypervisor.h, asm/xen/interface.h and
asm/xen/page.h are identical so to avoid code duplication we are just
including the original arm header files here.

asm/xen/events.h is slightly different, so introduce a different file
here (use xchg to implement xchg_xen_ulong and pass regs->pstate to
raw_irqs_disabled_flags).

Also introduce asm/hypervisor.h and asm/sync_bitops.h.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Acked-by: Ian Campbell <ian.campbell@citrix.com>

Change in v2:
- add all the required headers in this patch, by including the original
  arch/arm headers when possible to avoid code duplication;
- use xchg to implement xchg_xen_ulong.
---
 arch/arm64/include/asm/hypervisor.h     |    6 ++++++
 arch/arm64/include/asm/sync_bitops.h    |   26 ++++++++++++++++++++++++++
 arch/arm64/include/asm/xen/events.h     |   21 +++++++++++++++++++++
 arch/arm64/include/asm/xen/hypercall.h  |    1 +
 arch/arm64/include/asm/xen/hypervisor.h |    1 +
 arch/arm64/include/asm/xen/interface.h  |    1 +
 arch/arm64/include/asm/xen/page.h       |    1 +
 7 files changed, 57 insertions(+), 0 deletions(-)
 create mode 100644 arch/arm64/include/asm/hypervisor.h
 create mode 100644 arch/arm64/include/asm/sync_bitops.h
 create mode 100644 arch/arm64/include/asm/xen/events.h
 create mode 100644 arch/arm64/include/asm/xen/hypercall.h
 create mode 100644 arch/arm64/include/asm/xen/hypervisor.h
 create mode 100644 arch/arm64/include/asm/xen/interface.h
 create mode 100644 arch/arm64/include/asm/xen/page.h

diff --git a/arch/arm64/include/asm/hypervisor.h b/arch/arm64/include/asm/hypervisor.h
new file mode 100644
index 0000000..d2c7904
--- /dev/null
+++ b/arch/arm64/include/asm/hypervisor.h
@@ -0,0 +1,6 @@
+#ifndef _ASM_ARM64_HYPERVISOR_H
+#define _ASM_ARM64_HYPERVISOR_H
+
+#include <asm/xen/hypervisor.h>
+
+#endif
diff --git a/arch/arm64/include/asm/sync_bitops.h b/arch/arm64/include/asm/sync_bitops.h
new file mode 100644
index 0000000..8da0bf4
--- /dev/null
+++ b/arch/arm64/include/asm/sync_bitops.h
@@ -0,0 +1,26 @@
+#ifndef __ASM_SYNC_BITOPS_H__
+#define __ASM_SYNC_BITOPS_H__
+
+#include <asm/bitops.h>
+#include <asm/cmpxchg.h>
+
+/* sync_bitops functions are equivalent to the SMP implementation of the
+ * original functions, independently from CONFIG_SMP being defined.
+ *
+ * We need them because _set_bit etc are not SMP safe if !CONFIG_SMP. But
+ * under Xen you might be communicating with a completely external entity
+ * who might be on another CPU (e.g. two uniprocessor guests communicating
+ * via event channels and grant tables). So we need a variant of the bit
+ * ops which are SMP safe even on a UP kernel.
+ */
+
+#define sync_set_bit(nr, p)            set_bit(nr, p)
+#define sync_clear_bit(nr, p)          clear_bit(nr, p)
+#define sync_change_bit(nr, p)         change_bit(nr, p)
+#define sync_test_and_set_bit(nr, p)   test_and_set_bit(nr, p)
+#define sync_test_and_clear_bit(nr, p) test_and_clear_bit(nr, p)
+#define sync_test_and_change_bit(nr, p)        test_and_change_bit(nr, p)
+#define sync_test_bit(nr, addr)                test_bit(nr, addr)
+#define sync_cmpxchg                   cmpxchg
+
+#endif
diff --git a/arch/arm64/include/asm/xen/events.h b/arch/arm64/include/asm/xen/events.h
new file mode 100644
index 0000000..8655321
--- /dev/null
+++ b/arch/arm64/include/asm/xen/events.h
@@ -0,0 +1,21 @@
+#ifndef _ASM_ARM64_XEN_EVENTS_H
+#define _ASM_ARM64_XEN_EVENTS_H
+
+#include <asm/ptrace.h>
+#include <asm/atomic.h>
+
+enum ipi_vector {
+	XEN_PLACEHOLDER_VECTOR,
+
+	/* Xen IPIs go here */
+	XEN_NR_IPIS,
+};
+
+static inline int xen_irqs_disabled(struct pt_regs *regs)
+{
+	return raw_irqs_disabled_flags((unsigned long) regs->pstate);
+}
+
+#define xchg_xen_ulong(ptr, val) xchg((ptr), (val))
+
+#endif /* _ASM_ARM64_XEN_EVENTS_H */
diff --git a/arch/arm64/include/asm/xen/hypercall.h b/arch/arm64/include/asm/xen/hypercall.h
new file mode 100644
index 0000000..74b0c42
--- /dev/null
+++ b/arch/arm64/include/asm/xen/hypercall.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/hypercall.h>
diff --git a/arch/arm64/include/asm/xen/hypervisor.h b/arch/arm64/include/asm/xen/hypervisor.h
new file mode 100644
index 0000000..f263da8
--- /dev/null
+++ b/arch/arm64/include/asm/xen/hypervisor.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/hypervisor.h>
diff --git a/arch/arm64/include/asm/xen/interface.h b/arch/arm64/include/asm/xen/interface.h
new file mode 100644
index 0000000..44457ae
--- /dev/null
+++ b/arch/arm64/include/asm/xen/interface.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/interface.h>
diff --git a/arch/arm64/include/asm/xen/page.h b/arch/arm64/include/asm/xen/page.h
new file mode 100644
index 0000000..bed87ec
--- /dev/null
+++ b/arch/arm64/include/asm/xen/page.h
@@ -0,0 +1 @@
+#include <../../arm/include/asm/xen/page.h>
-- 
1.7.2.5

