Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426Ab3I3OHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:07:06 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:38619 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab3I3OHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:07:02 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Kevin Hilman <khilman@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Russell King <rmk@arm.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arm Linux <linux-arm-kernel@lists.infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/3] vtime: Add HAVE_VIRT_CPU_ACCOUNTING_GEN Kconfig
Date: Mon, 30 Sep 2013 16:06:50 +0200
Message-Id: <1380550012-7321-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
References: <1380550012-7321-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kevin Hilman <khilman@linaro.org>

With VIRT_CPU_ACCOUNTING_GEN, cputime_t becomes 64-bit. In order
to use that feature, arch code should be audited to ensure there are no
races in concurrent read/write of cputime_t. For example,
reading/writing 64-bit cputime_t on some 32-bit arches may require
multiple accesses for low and high value parts, so proper locking
is needed to protect against concurrent accesses.

Therefore, add CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN which arches can
enable after they've been audited for potential races.

This option is automatically enabled on 64-bit platforms.

Feature requested by Frederic Weisbecker.

Signed-off-by: Kevin Hilman <khilman@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Arm Linux <linux-arm-kernel@lists.infradead.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/Kconfig        | 12 ++++++++++++
 init/Kconfig        |  1 +
 kernel/time/Kconfig |  1 +
 3 files changed, 14 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index af2cc6e..185f8b0 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -353,6 +353,18 @@ config HAVE_CONTEXT_TRACKING
 config HAVE_VIRT_CPU_ACCOUNTING
 	bool
 
+config HAVE_VIRT_CPU_ACCOUNTING_GEN
+	bool
+	default y if 64BIT
+	help
+	  With VIRT_CPU_ACCOUNTING_GEN, cputime_t becomes 64-bit.
+	  Before enabling this option, arch code must be audited
+	  to ensure there are no races in concurrent read/write of
+	  cputime_t. For example, reading/writing 64-bit cputime_t on
+	  some 32-bit arches may require multiple accesses, so proper
+	  locking is needed to protect against concurrent accesses.
+
+
 config HAVE_IRQ_TIME_ACCOUNTING
 	bool
 	help
diff --git a/init/Kconfig b/init/Kconfig
index 3ecd8a1..68c1a0e 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -355,6 +355,7 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 config VIRT_CPU_ACCOUNTING_GEN
 	bool "Full dynticks CPU time accounting"
 	depends on HAVE_CONTEXT_TRACKING && 64BIT
+	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select VIRT_CPU_ACCOUNTING
 	select CONTEXT_TRACKING
 	help
diff --git a/kernel/time/Kconfig b/kernel/time/Kconfig
index 2b62fe8..f148475 100644
--- a/kernel/time/Kconfig
+++ b/kernel/time/Kconfig
@@ -101,6 +101,7 @@ config NO_HZ_FULL
 	depends on HAVE_CONTEXT_TRACKING
 	# VIRT_CPU_ACCOUNTING_GEN dependency
 	depends on 64BIT
+	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select NO_HZ_COMMON
 	select RCU_USER_QS
 	select RCU_NOCB_CPU
-- 
1.8.3.1

