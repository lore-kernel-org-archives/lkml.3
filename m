Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753047AbaGGERP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 00:17:15 -0400
Received: from mga02.intel.com ([134.134.136.20]:51231 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752824AbaGGERM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 00:17:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,616,1400050800"; 
   d="scan'208";a="569185550"
From: Lv Zheng <lv.zheng@intel.com>
To: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>
Cc: Lv Zheng <lv.zheng@intel.com>, Lv Zheng <zetalog@gmail.com>,
        <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v2 2/7] ACPICA: Linux: Add stub implementation of ACPICA 64-bit mathematics.
Date: Mon,  7 Jul 2014 12:17:08 +0800
Message-Id: <2c589d7e1cfcb1abfdca27ba2e183f86548d9287.1404706299.git.lv.zheng@intel.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <cover.1404706298.git.lv.zheng@intel.com>
References: <cover.1387336613.git.lv.zheng@intel.com> <cover.1404706298.git.lv.zheng@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds default 64-bit mathematics in aclinux.h using do_div(). As
do_div() can be used for all Linux architectures, this can also be used as
stub macros for ACPICA 64-bit mathematics.

But this is not a performance friendly way, as ACPICA's architecture
specific division OSL only requires a dividing 64-bit number with a 32-bit
number implementation, while Linux __div64_32() is not available for all
build environments. So currently, if an architecture really wants to
support ACPICA, it must implement its own division OSL.

This is required by the ACPICA header stub support. ACPICA header stubs are
useful to protect CONFIG_ACPI=n Linux kernel builds where ACPICA headers
are included. Lv Zheng.

Signed-off-by: Lv Zheng <lv.zheng@intel.com>
---
 include/acpi/platform/aclinuxex.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/include/acpi/platform/aclinuxex.h b/include/acpi/platform/aclinuxex.h
index 191e741..568d4b8 100644
--- a/include/acpi/platform/aclinuxex.h
+++ b/include/acpi/platform/aclinuxex.h
@@ -46,6 +46,28 @@
 
 #ifdef __KERNEL__
 
+#ifndef ACPI_USE_NATIVE_DIVIDE
+
+#ifndef ACPI_DIV_64_BY_32
+#define ACPI_DIV_64_BY_32(n_hi, n_lo, d32, q32, r32) \
+	do { \
+		u64 (__n) = ((u64) n_hi) << 32 | (n_lo); \
+		(r32) = do_div ((__n), (d32)); \
+		(q32) = (u32) (__n); \
+	} while (0)
+#endif
+
+#ifndef ACPI_SHIFT_RIGHT_64
+#define ACPI_SHIFT_RIGHT_64(n_hi, n_lo) \
+	do { \
+		(n_lo) >>= 1; \
+		(n_lo) |= (((n_hi) & 1) << 31); \
+		(n_hi) >>= 1; \
+	} while (0)
+#endif
+
+#endif
+
 /*
  * Overrides for in-kernel ACPICA
  */
-- 
1.7.10

