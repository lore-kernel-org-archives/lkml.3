Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751909Ab3IPW2z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 18:28:55 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33269 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3IPW2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 18:28:33 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] full_nohz: Kconfig: add HAVE_VIRT_CPU_ACCOUNTING_GEN
Date: Mon, 16 Sep 2013 15:28:21 -0700
Message-Id: <1379370502-30376-4-git-send-email-khilman@linaro.org>
X-Mailer: git-send-email 1.8.3
In-Reply-To: <1379370502-30376-1-git-send-email-khilman@linaro.org>
References: <1379370502-30376-1-git-send-email-khilman@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With HAVE_VIRT_CPU_ACCOUNTING_GEN, cputime_t becomes 64-bit.  In order
to use that feature, arch code should be audited ensure there are no
races in concurrent read/write of cputime_t.  For example,
reading/writing 64-bit cputime_t on some 32-bit arches may require
multiple accesses, so proper locking is needed to protect against
concurrent accesses.

Therefore, add CONFIG_HAVE_VIRT_CPU_ACCOUNTING_GEN which arches can
enabled after they've been audited for potential races.

This option is automatically enabled on 64-bit platforms.

Feature requested by Frederic Weisbecker.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 arch/Kconfig | 11 +++++++++++
 init/Kconfig |  1 +
 2 files changed, 12 insertions(+)

diff --git a/arch/Kconfig b/arch/Kconfig
index 1feb169..3c94a2d 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -356,6 +356,17 @@ config HAVE_CONTEXT_TRACKING
 config HAVE_VIRT_CPU_ACCOUNTING
 	bool
 
+config HAVE_VIRT_CPU_ACCOUNTING_GEN
+	bool
+	default y if 64BIT
+	help
+	  With HAVE_VIRT_CPU_ACCOUNTING_GEN, cputime_t becomes 64-bit.
+	  Before enabling this option, arch code must be audited
+	  ensure there are no races in concurrent read/write of
+	  cputime_t.  For example, reading/writing 64-bit cputime_t on
+	  some 32-bit arches may require multiple accesses, so proper
+	  locking is needed to protect against concurrent accesses.
+
 config HAVE_IRQ_TIME_ACCOUNTING
 	bool
 	help
diff --git a/init/Kconfig b/init/Kconfig
index e9cd23b..7c283a5 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -355,6 +355,7 @@ config VIRT_CPU_ACCOUNTING_NATIVE
 config VIRT_CPU_ACCOUNTING_GEN
 	bool "Full dynticks CPU time accounting"
 	depends on HAVE_CONTEXT_TRACKING
+	depends on HAVE_VIRT_CPU_ACCOUNTING_GEN
 	select VIRT_CPU_ACCOUNTING
 	select CONTEXT_TRACKING
 	help
-- 
1.8.3

